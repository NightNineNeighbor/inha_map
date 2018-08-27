package com.nnn.map.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EnteranceInfo {
	private String id;
	private String outerEnterance;
	private String innerEnterance;
}
