package com.nnn.map.info;


public class Node implements Comparable<Node> {
	public int node;
	public int distance;

	public Node(int node, int distance) {
		this.node = node;
		this.distance = distance;
	}

	public int compareTo(Node o) {
		if (this.distance > o.distance)
			return 1;
		else if (this.distance < o.distance)
			return -1;
		else
			return 0;
	}
}