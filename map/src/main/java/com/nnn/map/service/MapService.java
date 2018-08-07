package com.nnn.map.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nnn.map.dao.MapInfoDao;
import com.nnn.map.util.Dijkstra;
import com.nnn.map.vo.MapInfo;

@Service
public class MapService {
	@Autowired
	MapInfoDao dao;
	@Autowired
	ObjectMapper mapper;
	
	public ArrayList<Integer> getGroundPath(String startingPoint, String buildingName) throws JsonParseException, JsonMappingException, IOException{
		int starting = Integer.parseInt(startingPoint);
		MapInfo groundMapInfo = dao.readGraphAndNodes("ground");
		List<Integer[]> rawGraph = mapper.readValue(groundMapInfo.getGraph(), new TypeReference<List<Integer[]>>() {});
		Integer[] destinations = mapper.readValue(dao.getEnterance(buildingName), new TypeReference<Integer[]>(){});
		Dijkstra dijkstra = new Dijkstra(starting, rawGraph, destinations);
		return dijkstra.getShortestPath();
	}
}
