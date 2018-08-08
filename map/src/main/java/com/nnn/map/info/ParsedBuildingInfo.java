package com.nnn.map.info;

import java.io.IOException;


import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class ParsedBuildingInfo {
	public Integer[] outsideEnterances;
	public Integer[] innerEnterances;
	public Integer[][] stairs;
	public Integer[][] elevators;
	
	public ParsedBuildingInfo(JSONBuildingInfo o, ObjectMapper mapper) throws JsonParseException, JsonMappingException, IOException {
		this.outsideEnterances = 
				mapper.readValue(o.outsideEnterances, new TypeReference<Integer[]>() {});
		this.innerEnterances = 
				mapper.readValue(o.innerEnterances, new TypeReference<Integer[]>() {});
		this.stairs = 
				mapper.readValue(o.stairs, new TypeReference<Integer[][]>() {});
		this.elevators = 
				mapper.readValue(o.elevators, new TypeReference<Integer[][]>() {});
	}
	
	public Integer[] stairsOfSpecificFloor(int floorNum) {
		return stairs[floorNum];
	}
}
