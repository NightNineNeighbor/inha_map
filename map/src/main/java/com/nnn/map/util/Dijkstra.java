package com.nnn.map.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.PriorityQueue;

import com.nnn.map.info.Node;

public class Dijkstra {
	int starting;
	List<Integer[]> rawGraph;
	Integer[] destinations;
	ArrayList<Node>[] graph;
	int[] distance;
	ArrayList<Integer>[] paths;
	int theDestination;
	int biggestNodeNum;
	public int indexOfDestination;
	PriorityQueue<Node> pq;
	
	private void statusForDEBUG() {
		System.out.println("STATUS FOR DEBUG");
		System.out.println("starting : " + starting);
		System.out.println("theDestination : " + theDestination);
		System.out.println("biggestNodeNum : " + biggestNodeNum);
		System.out.println("indexOfDestination : " + indexOfDestination);
	}
	
	public Dijkstra(int starting, List<Integer[]> rawGraph, Integer[] destinations) {
		inite(starting, rawGraph, destinations);
	}
	
	public Dijkstra(int starting, List<Integer[]> rawGraph, int destination) {
		Integer[] d = new Integer[1];
		d[0] = destination;
		inite(starting, rawGraph, d);
	}

	private void inite(int starting, List<Integer[]> rawGraph, Integer[] destinations) {
		this.rawGraph = rawGraph;
		this.starting = starting;
		this.destinations = destinations;
		calcBiggestNodeNum();
		initDist();
		initeGraph();
		initePath();
		calc();
	}

	private void calcBiggestNodeNum() {
		for(int i = 0 ; i < rawGraph.size(); i++) {
			Integer[] t = rawGraph.get(i);
			biggestNodeNum = Math.max(Math.max(t[0], t[1]), biggestNodeNum);
		}
		biggestNodeNum++;	//cause zero base
	}
	
	private void initDist() {
		distance = new int[biggestNodeNum];
		Arrays.fill(distance, Integer.MAX_VALUE);
	}
	
	private void initeGraph() {
		graph = new ArrayList[biggestNodeNum];
		for (int i = 0; i < biggestNodeNum; i++) {
			graph[i] = new ArrayList<Node>();
		}

		int size = rawGraph.size();
		for (int i = 0; i < size; i++) {
			Integer[] t = rawGraph.get(i);
			graph[t[0]].add(new Node(t[1], t[2]));
			graph[t[1]].add(new Node(t[0], t[2]));
		}
	}
	
	private void initePath() {
		paths = new ArrayList[biggestNodeNum];
		for (int i = 0; i < biggestNodeNum; i++) {
			paths[i] = new ArrayList<Integer>();
		}
		paths[starting].add(starting);
	}
	
	private void calc(){
		pq = new PriorityQueue<>();
		pq.offer(new Node(starting, 0));
		
		while (!pq.isEmpty()) {
			Node n = pq.poll();
			int here = n.node;
			if (n.distance > distance[here])
				continue;

			for (int i = 0; i < graph[here].size(); i++) {
				Node node = graph[here].get(i);
				int next = node.node;
				int nextDistance = node.distance;

				if (distance[next] > distance[here] + nextDistance) {
					distance[next] = distance[here] + nextDistance;
					pq.offer(new Node(next, distance[next]));

					paths[next].clear();
					for (int k = 0; k < paths[here].size(); k++) {
						paths[next].add(paths[here].get(k));
					}
					paths[next].add(next);
				}
			}
		}
	}
	
	public ArrayList<Integer> getShortestPath(){
		int temp = Integer.MAX_VALUE;
		for(int index = 0; index < destinations.length; index++) {
			int destination = destinations[index];
			if(destination == -1) {
				continue;
			}
			if(distance[destination] < temp) {
				temp = distance[destination];
				theDestination = destination;
				this.indexOfDestination = index;
			}
		}
		return paths[theDestination];
	}
	
	public int getDestitnation() {
		return this.theDestination;
	}
	
}
