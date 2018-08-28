package com.nnn.map.vo;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

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
	private String stairs;
	private String elevators;
	
	public Integer[] getParsedStairs(ObjectMapper mapper) throws JsonParseException, JsonMappingException, IOException {
		return mapper.readValue(stairs, new TypeReference<Integer[]>() {});
	}
}
