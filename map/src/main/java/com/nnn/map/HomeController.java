package com.nnn.map;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.PriorityQueue;

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

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nnn.map.dao.MapInfoDao;
import com.nnn.map.info.Node;
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
	
	@RequestMapping(value = "/dijkstra", method = RequestMethod.POST)
	public ResponseEntity<String> dijkstra(String json, String nodeAmount, String startingPoint, String destinationPoint)
			throws JsonParseException, JsonMappingException, IOException {
		System.out.println(json);
		ObjectMapper mapper = new ObjectMapper();
		List<Integer[]> list = mapper.readValue(json, new TypeReference<List<Integer[]>>() {
		});
		
		int startingNode = Integer.parseInt(startingPoint);		//시작점
		int endingNode = Integer.parseInt(destinationPoint);	//도착점
		int vertex = Integer.parseInt(nodeAmount);				//노드의 갯수

		int[] dist = new int[vertex];
		Arrays.fill(dist, Integer.MAX_VALUE);

		ArrayList<Node>[] graph = new ArrayList[vertex];
		for (int i = 0; i < vertex; i++) {
			graph[i] = new ArrayList<Node>();
		}
		for (int i = 0; i < list.size(); i++) {
			Integer[] test = list.get(i);

			graph[test[0]].add(new Node(test[1], test[2]));
			graph[test[1]].add(new Node(test[0], test[2]));
		}

		ArrayList<Integer>[] path = new ArrayList[vertex];
		for (int i = 0; i < vertex; i++) {
			path[i] = new ArrayList<>();
		}
		path[startingNode].add(startingNode);

		PriorityQueue<Node> pq = new PriorityQueue<>();
		pq.offer(new Node(startingNode, 0));
		// dijkstra
		while (!pq.isEmpty()) {
			Node n = pq.poll();
			int here = n.node;
			if (n.distance > dist[here])
				continue;

			for (int i = 0; i < graph[here].size(); i++) {
				Node node = graph[here].get(i);
				int destination = node.node;
				int destDist = node.distance;

				if (dist[destination] > dist[here] + destDist) {
					dist[destination] = dist[here] + destDist;
					pq.offer(new Node(destination, dist[destination]));

					path[destination].clear();
					for (int k = 0; k < path[here].size(); k++) {
						path[destination].add(path[here].get(k));
					}
					path[destination].add(destination);
				}
			}
		}


		return new ResponseEntity<String>(mapper.writeValueAsString(path[endingNode]), HttpStatus.OK);
	}

	

	@RequestMapping(value = "/dijkstra", method = RequestMethod.GET)
	public ResponseEntity<String> testdijkstra() {
		return new ResponseEntity<String>("didijkstra", HttpStatus.OK);
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
	
	@GetMapping("/mapUpload")
	public String makeMap() {
		return "mapUpload";
	}
	
	@GetMapping("/test")
	public String test(Model model) {
		String testResult = mapInfoTestStory();
		model.addAttribute("testResult", testResult);
		return "test";
	}
	
	private String mapInfoTestStory() {
		MapInfo mapInfo = dao.readGraphAndNodes("테스트 지도");
		mapInfo.setGraph("test message");
		dao.updateGraphAndNodes(mapInfo);
		mapInfo = dao.readGraphAndNodes("테스트 지도");
		if(mapInfo.getGraph().equals("test message")) {
			return "OK";
		}else {
			return "fail";
		}
	}
	
	@PostMapping("/saveGraphAndNodes")
	public ResponseEntity<String> saveGraphAndNodes(String id, String nodes, String graph, String selectableNodes){
		MapInfo mapInfo = new MapInfo(id, graph, nodes, selectableNodes);
		int isInsertClear = dao.insertGraphAndNodes(mapInfo);
		String inserStatus = "";
		if(isInsertClear == 1 ) {
			inserStatus = "OK";
		}else {
			inserStatus = "FAIL";
		}
		return new ResponseEntity<String>( inserStatus , HttpStatus.OK);
	}
	
	@RequestMapping(value = "/loadGraphAndNodes",method=RequestMethod.POST, produces="text/plan;charset=UTF-8")
	public ResponseEntity<String> loadGraphAndNodes(String id) throws JsonProcessingException{
		MapInfo mapInfo = dao.readGraphAndNodes(id);
		System.out.println(mapInfo);		//DEBUG
		System.out.println(mapper.writeValueAsString(mapInfo));	//DEBUG
		return new ResponseEntity<String>( mapper.writeValueAsString(mapInfo) , HttpStatus.OK);
	}
}
