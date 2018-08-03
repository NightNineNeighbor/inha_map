package com.nnn.map.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MapInfo {
	private String id;
	private String graph;
	private String nodes;
	private String selectableNodes;
}
