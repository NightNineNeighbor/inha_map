package com.nnn.map.info;

import java.io.IOException;


import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nnn.map.vo.EnteranceInfo;

public class ParsedEnteranceInfo {
	public Integer[] outer;
	public Integer[][] inner;
	
	
	public ParsedEnteranceInfo(EnteranceInfo o, ObjectMapper mapper) throws JsonParseException, JsonMappingException, IOException {
		this.outer = 
				mapper.readValue(o.getOuterEnterance(), new TypeReference<Integer[]>() {});
		this.inner = 
				mapper.readValue(o.getInnerEnterance(), new TypeReference<Integer[][]>() {});
	}
}
