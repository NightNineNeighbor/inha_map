package com.nnn.map.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nnn.map.dao.MapInfoDao;
import com.nnn.map.service.MapService;
import com.nnn.map.vo.MapInfo;

@Controller
public class MapController {
	@Autowired
	MapInfoDao dao;
	@Autowired
	MapService service;
	@Autowired
	ObjectMapper mapper;

	@GetMapping("/map")
	public String map(Model model){
		model.addAttribute("selectable",
							dao.getSelectable("ground")
									.getSelectableNodes());
		model.addAttribute("building5_0F",
				dao.getSelectable("building5_0F")
						.getSelectableNodes());
		model.addAttribute("building5_1F",
				dao.getSelectable("building5_1F")
						.getSelectableNodes());
		model.addAttribute("building5_2F",
				dao.getSelectable("building5_2F")
						.getSelectableNodes());
		return "map";
	}
	
	@GetMapping("/mapUpload")
	public String makeMap() {
		return "mapUpload";
	}
	
	@RequestMapping(value = "/findpath", method = RequestMethod.POST)
	public ResponseEntity<String> findpath(String startingPoint, String buildingName, String floor, String destinationPoint)
			throws JsonParseException, JsonMappingException, IOException {
		return new ResponseEntity<String>(service.findPath(startingPoint, buildingName, floor, destinationPoint) , HttpStatus.OK);
	}
	
	@PostMapping("/saveMapInfo")
	public ResponseEntity<String> saveGraphAndNodes(String id, String nodes, String graph, String selectableNodes, String stairs, String elevators){
		MapInfo mapInfo = new MapInfo(id, graph, nodes, selectableNodes, stairs, elevators);
		int isInsertClear = dao.insertGraphAndNodes(mapInfo);
		String inserStatus = "";
		if(isInsertClear == 1 ) {
			inserStatus = "OK";
		}else {
			inserStatus = "FAIL";
		}
		return new ResponseEntity<String>( inserStatus , HttpStatus.OK);
	}
	
	@RequestMapping(value = "/loadMapInfo",method=RequestMethod.POST, produces="text/plan;charset=UTF-8")
	public ResponseEntity<String> loadMapInfo(String id) throws JsonProcessingException{
		MapInfo mapInfo = dao.readGraphAndNodes(id);
		System.out.println(mapInfo);		//DEBUG
		System.out.println(mapper.writeValueAsString(mapInfo));	//DEBUG
		return new ResponseEntity<String>( mapper.writeValueAsString(mapInfo) , HttpStatus.OK);
	}
}
