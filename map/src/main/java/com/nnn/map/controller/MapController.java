package com.nnn.map.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.PriorityQueue;

import javax.validation.ConstraintValidatorContext.ConstraintViolationBuilder.NodeBuilderDefinedContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nnn.map.dao.MapInfoDao;
import com.nnn.map.info.Node;
import com.nnn.map.service.MapService;
import com.nnn.map.util.Dijkstra;
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
	public String map(){
		return "map";
	}
	
	@RequestMapping(value = "/findpath", method = RequestMethod.POST)
	public ResponseEntity<String> findpath(String startingPoint, String buildingName, String destinationPoint)
			throws JsonParseException, JsonMappingException, IOException {
		return new ResponseEntity<String>(service.getGroundPath(startingPoint, buildingName, destinationPoint) , HttpStatus.OK);
	}
}
