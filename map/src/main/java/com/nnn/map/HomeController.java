package com.nnn.map;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.PriorityQueue;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		return "home";
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
			int here = n.vertex;
			if (n.dist > dist[here])
				continue;

			for (int i = 0; i < graph[here].size(); i++) {
				Node node = graph[here].get(i);
				int destination = node.vertex;
				int destDist = node.dist;

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

	static class Node implements Comparable<Node> {
		public int vertex;
		public int dist;

		public Node(int vertex, int dist) {
			this.vertex = vertex;
			this.dist = dist;
		}

		public int compareTo(Node o) {
			if (this.dist > o.dist)
				return 1;
			else if (this.dist < o.dist)
				return -1;
			else
				return 0;
		}

	}

	@RequestMapping(value = "/dijkstra", method = RequestMethod.GET)
	public ResponseEntity<String> testdijkstra() {
		return new ResponseEntity<String>("didijkstra", HttpStatus.OK);
	}
}
