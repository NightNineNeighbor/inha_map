package com.nnn.map.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nnn.map.dao.MapInfoDao;
import com.nnn.map.info.JSONBuildingInfo;
import com.nnn.map.info.ParsedBuildingInfo;
import com.nnn.map.util.Dijkstra;
import com.nnn.map.vo.MapInfo;

@Service
public class MapService {
	@Autowired
	MapInfoDao dao;
	@Autowired
	ObjectMapper mapper;
	
	public String getGroundPath(String startingPoint, String buildingName, String destinationPoint) throws JsonParseException, JsonMappingException, IOException{
		HashMap<String, Object> ret = new HashMap<>();
		int starting = Integer.parseInt(startingPoint);
		int destination = Integer.parseInt(destinationPoint);
		
		JSONBuildingInfo jsonBuildingInfo = dao.getBuildingInfo(buildingName);
		ParsedBuildingInfo parsedBuildingInfo = new ParsedBuildingInfo(jsonBuildingInfo, mapper);
		
		MapInfo groundMapInfo = dao.readGraphAndNodes("ground");
		List<Integer[]> rawGraph = mapper.readValue(groundMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
		Dijkstra dijkstra = new Dijkstra(starting, rawGraph, parsedBuildingInfo.outsideEnterances);
		ret.put("ground_Nodes", groundMapInfo.getNodes());
		ret.put("ground_Paths", dijkstra.getShortestPath());
		
		MapInfo groundMapInfo2 = dao.readGraphAndNodes("building_2F");
		List<Integer[]> rawGraph2 = mapper.readValue(groundMapInfo2.getGraph(), new TypeReference<List<Integer[]>>() {});
		Dijkstra dijkstra2 = new Dijkstra(destination, rawGraph2, parsedBuildingInfo.stairsOfSpecificFloor(2));
		ret.put("building_2F_Paths", dijkstra2.getShortestPath());
		ret.put("building_2F_Nodes", groundMapInfo2.getNodes());

		MapInfo groundMapInfo1 = dao.readGraphAndNodes("building_1F");
		Integer[] ss = parsedBuildingInfo.innerEnterances;
		int s = ss[dijkstra.indexOfDestination];
		Integer[] ds = parsedBuildingInfo.stairsOfSpecificFloor(1);
		int d = ds[dijkstra2.indexOfDestination];
		List<Integer[]> rawGraph1 = mapper.readValue(groundMapInfo1.getGraph(), new TypeReference<List<Integer[]>>() {});
		Dijkstra dijkstra1 = new Dijkstra(s, rawGraph1, d);
		ret.put("building_1F_Paths", dijkstra1.getShortestPath());
		ret.put("building_1F_Nodes", groundMapInfo1.getNodes());
		
		return mapper.writeValueAsString(ret);
	}
	
	public static void main(String[] args) throws JsonProcessingException {
		MapInfoDao dao = new MapInfoDao();
		ObjectMapper mapper = new ObjectMapper();
		String ret = mapper.writeValueAsString(dao.getStairs());
		System.out.println(ret);
		
	}
}
