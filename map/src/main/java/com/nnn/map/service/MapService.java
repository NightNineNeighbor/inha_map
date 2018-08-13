package com.nnn.map.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nnn.map.dao.MapInfoDao;
import com.nnn.map.info.ParsedBuildingInfo;
import com.nnn.map.util.Dijkstra;
import com.nnn.map.vo.MapInfo;

@Service
public class MapService {
	@Autowired
	MapInfoDao dao;
	@Autowired
	ObjectMapper mapper;
	
	public String findPath(String startingPoint, String buildingName, String floor, String destinationPoint) throws JsonParseException, JsonMappingException, IOException{
		HashMap<String, Object> ret = new HashMap<>();
		int starting = Integer.parseInt(startingPoint);
		int destination = Integer.parseInt(destinationPoint);
		
		ParsedBuildingInfo parsedBuildingInfo = new ParsedBuildingInfo(dao.getBuildingInfo(buildingName), mapper);
		
		MapInfo groundMapInfo = dao.readGraphAndNodes("ground");
		List<Integer[]> groundRawGraph = mapper.readValue(groundMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
		Dijkstra groundDijkstra = new Dijkstra(starting, groundRawGraph, parsedBuildingInfo.outsideEnterances);
		ret.put("ground_Nodes", groundMapInfo.getNodes());
		ret.put("ground_Paths", groundDijkstra.getShortestPath());
		
		if(floor.equals("1")) {
			Integer[] innerEnterances = parsedBuildingInfo.innerEnterances;
			int innerEnterance = innerEnterances[groundDijkstra.indexOfDestination];
			
			MapInfo firstFloorMapInfo = dao.readGraphAndNodes(buildingName+"_"+floor+"F");
			List<Integer[]> firstFloorRawGraph = mapper.readValue(firstFloorMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
			Dijkstra firstFloorDijkstra = new Dijkstra(innerEnterance, firstFloorRawGraph, destination);
			ret.put(buildingName+"_"+floor+"F"+"_Paths", firstFloorDijkstra.getShortestPath());
			ret.put(buildingName+"_"+floor+"F"+"_Nodes", firstFloorMapInfo.getNodes());
		}else {
			MapInfo destFloorMapInfo = dao.readGraphAndNodes(buildingName+"_"+floor+"F");
			List<Integer[]> destFloorRawGraph = mapper.readValue(destFloorMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
			Dijkstra destFloorDijkstra = new Dijkstra(destination, destFloorRawGraph, parsedBuildingInfo.stairsOfSpecificFloor(Integer.parseInt(floor)));
			ret.put(buildingName+"_"+floor+"F"+"_Paths", reverse(destFloorDijkstra.getShortestPath()));
			ret.put(buildingName+"_"+floor+"F"+"_Nodes", destFloorMapInfo.getNodes());
			
			Integer[] innerEnterances = parsedBuildingInfo.innerEnterances;
			int innerEnterance = innerEnterances[groundDijkstra.indexOfDestination];
			Integer[] firstFloorStairs = parsedBuildingInfo.stairsOfSpecificFloor(1);
			int firstFloorStair = firstFloorStairs[destFloorDijkstra.indexOfDestination];
			
			MapInfo firstFloorMapInfo = dao.readGraphAndNodes(buildingName+"_1F");
			List<Integer[]> firstFloorRawGraph = mapper.readValue(firstFloorMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
			Dijkstra firstFloorDijkstra = new Dijkstra(innerEnterance, firstFloorRawGraph, firstFloorStair);
			ret.put(buildingName+"_1F_Paths", firstFloorDijkstra.getShortestPath());
			ret.put(buildingName+"_1F_Nodes", firstFloorMapInfo.getNodes());
		}
		return mapper.writeValueAsString(ret);
	}
	
	private ArrayList<Integer> reverse(ArrayList<Integer> arr){
		@SuppressWarnings("unchecked")
		ArrayList<Integer> ret = (ArrayList<Integer>) arr.clone();
		Collections.reverse(ret);
		return ret;
	}
}
