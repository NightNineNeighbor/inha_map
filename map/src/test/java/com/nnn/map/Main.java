package com.nnn.map;
import java.io.*;
import java.util.*;

public class Main {
	
	public static void main(String[] args) throws Exception{
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		StringTokenizer st = new StringTokenizer(br.readLine(), " ");
		
		int vertex = Integer.parseInt(st.nextToken());
		int edge = Integer.parseInt(st.nextToken());
		
		ArrayList<Node>[] graph = new ArrayList[vertex+1];
		for(int i = 0; i<=vertex; i++) {
			graph[i] = new ArrayList<Node>();
		}
		
		int[] dist = new int[vertex+1];
		Arrays.fill(dist, Integer.MAX_VALUE);
		
		st = new StringTokenizer(br.readLine(), " ");
		int startingPoint = Integer.parseInt(st.nextToken());
		
		int x,y,w = 0;
		for(int i = 0 ; i < edge ; i++) {
			st = new StringTokenizer(br.readLine(), " ");
			x = Integer.parseInt(st.nextToken());
			y = Integer.parseInt(st.nextToken());
			w = Integer.parseInt(st.nextToken());
			
			graph[x].add(new Node(y,w));
		}
		//init end
		
		ArrayList<Integer>[] path = new ArrayList[vertex+1]; 
		for(int i = 0; i< vertex+1; i++) {
			path[i] = new ArrayList<>();
		}
		path[startingPoint].add(startingPoint);
		
		dist[startingPoint] = 0;
		PriorityQueue<Node> pq = new PriorityQueue<>();
		pq.offer(new Node(startingPoint, 0));
		//dijkstra
		while(!pq.isEmpty()) {
			Node n = pq.poll();
			int here = n.vertex;
			if(n.dist > dist[here])
				continue;
			
			for(int i = 0; i< graph[here].size(); i++) {
				Node node = graph[here].get(i);
				int destination = node.vertex;
				int destDist = node.dist;
				
				if(dist[destination] > dist[here] + destDist) {
					dist[destination] = dist[here] + destDist;
					pq.offer( new Node( destination , dist[destination]) );
					
					path[destination].clear();
					for(int k = 0; k < path[here].size(); k++) {
						path[destination].add(path[here].get(k));
					}
					path[destination].add(destination);
				}
			}
		}
		
		//output print
		for(int i = 1; i <= vertex; i++) {
			if(dist[i]==Integer.MAX_VALUE) {
				System.out.println("INF");
			} else {
				System.out.println(dist[i]);
			}
		}
		
		System.out.println("path");
		for(int j = 1; j <= vertex; j++) {
			for(int i = 0; i < path[j].size(); i++) {
				System.out.print(path[j].get(i) + " ");
			}
			System.out.println();
		}
	}
	
	static class Node implements Comparable<Node>{
		public int vertex;
		public int dist;
		
		public Node(int vertex,int dist) {
			this.vertex = vertex;
			this.dist = dist;
		}
		
		public int compareTo(Node o) {
			if(this.dist > o.dist)
				return 1;
			else if(this.dist < o.dist)
				return -1;
			else
				return 0;
		}
	}
}
