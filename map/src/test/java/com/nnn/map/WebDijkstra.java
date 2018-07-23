package com.nnn.map;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.PriorityQueue;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nnn.map.HomeController.Node;

public class WebDijkstra {
public static void main(String[] args) throws JsonParseException, JsonMappingException, IOException {
	String json = "[[0,1,6800],[1,3,21537],[3,4,13316],[4,5,15605],[0,2,12960],[2,5,32418]]";
	ObjectMapper mapper = new ObjectMapper();
	List<Integer[]> list = mapper.readValue(json, new TypeReference<List<Integer[]>>() {
	});
	System.out.println(json);
	int startingPoint = 0;
	int vertex = 6;

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
	path[startingPoint].add(startingPoint);

	PriorityQueue<Node> pq = new PriorityQueue<>();
	pq.offer(new Node(startingPoint, 0));
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

	String ret = "";
	for(int j = 0; j < path.length; j++) {
		ret += j + " : ";
		for (int i = 0; i < path[j].size(); i++) {
			ret += path[j].get(i);
		}
		ret += "\n";
	}
	System.out.println("ret : " + ret);
}
}
