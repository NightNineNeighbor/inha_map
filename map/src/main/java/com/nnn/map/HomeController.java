package com.nnn.map;

import java.io.File;
import java.io.IOException;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nnn.map.dao.MapInfoDao;
import com.nnn.map.info.StaticMapInfo;
import com.nnn.map.vo.MapInfo;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	@Autowired
	MapInfoDao dao;
	@Autowired
	ObjectMapper mapper;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		model.addAttribute("nodes", StaticMapInfo.nodes);
		model.addAttribute("graph", StaticMapInfo.graph);
		model.addAttribute("selectable", StaticMapInfo.selectable);
		return "home";
	}
	
	@GetMapping("/building")
	public String building() {
		return "building";
	}
	
	
	@GetMapping("/fileUpload")
	public String fileUpload() {
		return "fileUpload";
	}
	
	@PostMapping("/fileUpload")
	public String fileUpload(MultipartFile myfile, RedirectAttributes ra) throws IOException {
		System.out.println(System.getProperty("user.dir"));
		final String rootDirectory = "c:/Users/IN/Desktop/inha_map/map/src/main/webapp/";
		final String webDirectory = "resources/";
		final String fileName = myfile.getOriginalFilename();
		File file = new File(rootDirectory + webDirectory, fileName);
		FileCopyUtils.copy(myfile.getBytes(), file);
		
		ra.addFlashAttribute("uploadedFile", webDirectory+fileName);
		return "redirect:/mapUpload";//TODO
	}
	
	@GetMapping("/test")
	public String test(Model model) {
		//String testResult = mapInfoTestStory();
		String testResult = dao.test();
		model.addAttribute("testResult", testResult);
		return "test";
	}
	
	/*private String mapInfoTestStory() {
		MapInfo mapInfo = dao.readGraphAndNodes("테스트 지도");
		mapInfo.setGraph("test message");
		dao.updateGraphAndNodes(mapInfo);
		mapInfo = dao.readGraphAndNodes("테스트 지도");
		if(mapInfo.getGraph().equals("test message")) {
			return "OK";
		}else {
			return "fail";
		}
	}*/
}
