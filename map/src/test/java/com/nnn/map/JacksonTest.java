package com.nnn.map;

import java.io.IOException;
import java.util.List;
import java.util.Scanner;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JacksonTest {
	public static void main(String[] args) throws JsonParseException, JsonMappingException, IOException {
		ObjectMapper mapper = new ObjectMapper();
		Scanner sc = new Scanner(System.in);
		String json = sc.nextLine();
		//String json = "[[5,6,15298],[0,0,0],[1,0,19816],[4,7,20781],[3,2,16848]]";
		System.out.println(json);
		
		List<Integer[]> list = mapper.readValue(json, new TypeReference<List<Integer[]>>() {}); 
		
		for(Integer[] i : list) {
			for(Integer a : i) {
				System.out.println(a);
			}
		}
		sc.close();
	}

}
