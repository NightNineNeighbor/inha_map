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
import com.nnn.map.info.ParsedEnteranceInfo;
import com.nnn.map.util.Dijkstra;
import com.nnn.map.vo.EnteranceInfo;
import com.nnn.map.vo.MapInfo;

@Service
public class MapService {
	@Autowired
	MapInfoDao dao;
	@Autowired
	ObjectMapper mapper;
	
	public String findPath(String startingPoint, String buildingName, String floor, String destinationPoint, String startingName, String destName) throws JsonParseException, JsonMappingException, IOException{
		HashMap<String, Object> ret = new HashMap<>();
		
		ret.put("startingPoint", startingPoint);
		ret.put("startingPointName", startingName);
		ret.put("buildingName", buildingName);
		ret.put("floor", floor);
		ret.put("destination", destName);
		
		int starting = Integer.parseInt(startingPoint);
		int destination = Integer.parseInt(destinationPoint);
		
		ParsedEnteranceInfo parsedEnteranceInfo = 
				new ParsedEnteranceInfo(dao.readEnteranceInfo(buildingName), mapper);
		
		MapInfo groundMapInfo = dao.readMapInfo("ground_1F");
		List<Integer[]> groundRawGraph = mapper.readValue(groundMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
		Dijkstra groundDijkstra = new Dijkstra(starting, groundRawGraph, parsedEnteranceInfo.outer);
		ret.put("ground_Nodes", groundMapInfo.getNodes());
		ret.put("ground_Paths", groundDijkstra.getShortestPath());
		
		Integer[] innerEnteranceInfo = parsedEnteranceInfo.inner[groundDijkstra.indexOfDestination];
		int innerEnterance = innerEnteranceInfo[0]; //innerEnteranceFormat -> [node#][floor#]
		int enteranceFloor = innerEnteranceInfo[1];
		ret.put("enteranceFloor", enteranceFloor+"");
		
		if(floor.equals(enteranceFloor+"")) {
			ret.put("mapAmount", "2");
			MapInfo firstFloorMapInfo = dao.readMapInfo(buildingName+"_"+floor+"F");
			List<Integer[]> firstFloorRawGraph = mapper.readValue(firstFloorMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
			Dijkstra firstFloorDijkstra = new Dijkstra(innerEnterance, firstFloorRawGraph, destination);
			ret.put("firstPaths", firstFloorDijkstra.getShortestPath());
			ret.put("firstNodes", firstFloorMapInfo.getNodes());
		}else {
			ret.put("mapAmount", "3");
			MapInfo destFloorMapInfo = dao.readMapInfo(buildingName+"_"+floor+"F");
			List<Integer[]> destFloorRawGraph = mapper.readValue(destFloorMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
			Dijkstra destFloorDijkstra = new Dijkstra(destination, destFloorRawGraph, destFloorMapInfo.getParsedStairs(mapper));
			ret.put("secondPaths", reverse(destFloorDijkstra.getShortestPath()));
			ret.put("secondNodes", destFloorMapInfo.getNodes());
			
			MapInfo firstFloorMapInfo = dao.readMapInfo(buildingName+"_1F");
			Integer[] firstFloorStairs = firstFloorMapInfo.getParsedStairs(mapper);
			int firstFloorStair = firstFloorStairs[destFloorDijkstra.indexOfDestination];
			
			List<Integer[]> firstFloorRawGraph = mapper.readValue(firstFloorMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
			Dijkstra firstFloorDijkstra = new Dijkstra(innerEnterance, firstFloorRawGraph, firstFloorStair);
			ret.put("firstPaths", firstFloorDijkstra.getShortestPath());
			ret.put("firstNodes", firstFloorMapInfo.getNodes());
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
