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
import com.nnn.map.vo.EnteranceInfo;
import com.nnn.map.vo.MapInfo;

@Controller
public class MapController {
	@Autowired
	MapInfoDao dao;
	@Autowired
	MapService service;
	@Autowired
	ObjectMapper mapper;
	
	@GetMapping("/")
	public String map(Model model){
		//1 : 본관
		//2	: 2, 4
		//3 : 60주년 (x)
		//5	: 5
		//6	: 6, 9
		//7	: 학생회관
		//8	: 정석
		//10: 서호관
		//11: 나빌레관
		//12: 하이테크
		model.addAttribute("selectable",dao.getSelectable("ground_1F").getSelectableNodes());
		
		//model.addAttribute("building1_0F",dao.getSelectable("building1_0F").getSelectableNodes());
		model.addAttribute("building1_1F",dao.getSelectable("building1_1F").getSelectableNodes());
		model.addAttribute("building1_2F",dao.getSelectable("building1_2F").getSelectableNodes());
		model.addAttribute("building1_3F",dao.getSelectable("building1_3F").getSelectableNodes());
		model.addAttribute("building1_4F",dao.getSelectable("building1_4F").getSelectableNodes());
		model.addAttribute("building1_5F",dao.getSelectable("building1_5F").getSelectableNodes());
		
		/*
		model.addAttribute("building2_0F",dao.getSelectable("building2_0F").getSelectableNodes());
		model.addAttribute("building2_1F",dao.getSelectable("building2_1F").getSelectableNodes());
		model.addAttribute("building2_2F",dao.getSelectable("building2_2F").getSelectableNodes());
		model.addAttribute("building2_3F",dao.getSelectable("building2_3F").getSelectableNodes());
		model.addAttribute("building2_4F",dao.getSelectable("building2_4F").getSelectableNodes());
		model.addAttribute("building2_5F",dao.getSelectable("building2_5F").getSelectableNodes());
		model.addAttribute("building2_6F",dao.getSelectable("building2_6F").getSelectableNodes());
		
		model.addAttribute("building5_0F",dao.getSelectable("building5_0F").getSelectableNodes());
		model.addAttribute("building5_1F",dao.getSelectable("building5_1F").getSelectableNodes());
		model.addAttribute("building5_2F",dao.getSelectable("building5_2F").getSelectableNodes());
		model.addAttribute("building5_3F",dao.getSelectable("building5_3F").getSelectableNodes());
		model.addAttribute("building5_4F",dao.getSelectable("building5_4F").getSelectableNodes());
		model.addAttribute("building5_5F",dao.getSelectable("building5_5F").getSelectableNodes());
		
		//model.addAttribute("building6_0F",dao.getSelectable("building6_0F").getSelectableNodes());
		//model.addAttribute("building6_1F",dao.getSelectable("building6_1F").getSelectableNodes());
		model.addAttribute("building6_2F",dao.getSelectable("building6_2F").getSelectableNodes());
		model.addAttribute("building6_3F",dao.getSelectable("building6_3F").getSelectableNodes());
		model.addAttribute("building6_4F",dao.getSelectable("building6_4F").getSelectableNodes());
		model.addAttribute("building6_5F",dao.getSelectable("building6_5F").getSelectableNodes());
		model.addAttribute("building6_6F",dao.getSelectable("building6_6F").getSelectableNodes());
		model.addAttribute("building6_7F",dao.getSelectable("building6_7F").getSelectableNodes());
		
		//model.addAttribute("building7_1F",dao.getSelectable("building7_1F").getSelectableNodes());
		//model.addAttribute("building7_2F",dao.getSelectable("building7_2F").getSelectableNodes());
		//model.addAttribute("building7_3F",dao.getSelectable("building7_3F").getSelectableNodes());
		//model.addAttribute("building7_4F",dao.getSelectable("building7_4F").getSelectableNodes());
		//model.addAttribute("building7_5F",dao.getSelectable("building7_5F").getSelectableNodes());
		//model.addAttribute("building7_6F",dao.getSelectable("building7_6F").getSelectableNodes());
		//model.addAttribute("building7_7F",dao.getSelectable("building7_7F").getSelectableNodes());
		
		//model.addAttribute("building10_0F",dao.getSelectable("building10_0F").getSelectableNodes());
		model.addAttribute("building10_1F",dao.getSelectable("building10_1F").getSelectableNodes());
		model.addAttribute("building10_2F",dao.getSelectable("building10_2F").getSelectableNodes());
		model.addAttribute("building10_3F",dao.getSelectable("building10_3F").getSelectableNodes());
		model.addAttribute("building10_4F",dao.getSelectable("building10_4F").getSelectableNodes());
		
		model.addAttribute("building11_1F",dao.getSelectable("building11_1F").getSelectableNodes());
		model.addAttribute("building11_2F",dao.getSelectable("building11_2F").getSelectableNodes());
		model.addAttribute("building11_3F",dao.getSelectable("building11_3F").getSelectableNodes());
		
		model.addAttribute("building12_0F",dao.getSelectable("building12_0F").getSelectableNodes());
		model.addAttribute("building12_1F",dao.getSelectable("building12_1F").getSelectableNodes());
		model.addAttribute("building12_2F",dao.getSelectable("building12_2F").getSelectableNodes());
		model.addAttribute("building12_3F",dao.getSelectable("building12_3F").getSelectableNodes());
		model.addAttribute("building12_4F",dao.getSelectable("building12_4F").getSelectableNodes());
		model.addAttribute("building12_5F",dao.getSelectable("building12_5F").getSelectableNodes());
		model.addAttribute("building12_6F",dao.getSelectable("building12_6F").getSelectableNodes());
		model.addAttribute("building12_7F",dao.getSelectable("building12_7F").getSelectableNodes());
		model.addAttribute("building12_8F",dao.getSelectable("building12_8F").getSelectableNodes());
		model.addAttribute("building12_9F",dao.getSelectable("building12_9F").getSelectableNodes());
		model.addAttribute("building12_10F",dao.getSelectable("building12_10F").getSelectableNodes());
		model.addAttribute("building12_11F",dao.getSelectable("building12_11F").getSelectableNodes());
		model.addAttribute("building12_12F",dao.getSelectable("building12_12F").getSelectableNodes());
		model.addAttribute("building12_13F",dao.getSelectable("building12_13F").getSelectableNodes());
		model.addAttribute("building12_14F",dao.getSelectable("building12_14F").getSelectableNodes());
		model.addAttribute("building12_15F",dao.getSelectable("building12_15F").getSelectableNodes());
		*/
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
		dao.deleteMapInfo(id);
		dao.insertMapInfo(mapInfo);
		return new ResponseEntity<String>( "" , HttpStatus.OK);
	}
	
	@RequestMapping(value = "/loadMapInfo",method=RequestMethod.POST, produces="text/plan;charset=UTF-8")
	public ResponseEntity<String> loadMapInfo(String id) throws JsonProcessingException{
		MapInfo mapInfo = dao.readMapInfo(id);
		return new ResponseEntity<String>( mapper.writeValueAsString(mapInfo) , HttpStatus.OK);
	}
	
	@RequestMapping(value = "/saveEnteranceInfo",method=RequestMethod.POST, produces="text/plan;charset=UTF-8")
	public ResponseEntity<String> saveEnteranceInfo(String id, String outer, String inner) throws JsonProcessingException{
		EnteranceInfo enteranceInfo = new EnteranceInfo(id, outer, inner);
		dao.deleteEnteranceInfo(id);
		dao.insertEnteranceInfo(enteranceInfo);
		return new ResponseEntity<String>( "ok" , HttpStatus.OK);
	}
	
	@RequestMapping(value = "/getEnteranceInfo",method=RequestMethod.POST, produces="text/plan;charset=UTF-8")
	public ResponseEntity<String> saveEnteranceInfo(String id) throws JsonProcessingException{
		EnteranceInfo enteranceInfo = dao.readEnteranceInfo(id);
		return new ResponseEntity<String>( mapper.writeValueAsString(enteranceInfo) , HttpStatus.OK);
	}
}
