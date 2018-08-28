package com.nnn.map.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.nnn.map.vo.EnteranceInfo;
import com.nnn.map.vo.MapInfo;

@Repository
public class MapInfoDao {
	@Autowired
	SqlSessionTemplate tpl;
	
	public String test() {
		return tpl.selectOne("mapInfoMapper.test");
	}
	
	//-------------------------------MAP INFO---------------------------------//
	public int insertMapInfo(MapInfo mapInfo) {
		return tpl.insert("mapInfoMapper.insertMapInfo",mapInfo);
	}

	public MapInfo readMapInfo(String id) {
		return tpl.selectOne("mapInfoMapper.readMapInfo",id);
	}
	
	public MapInfo getSelectable(String id) {
		return tpl.selectOne("mapInfoMapper.getSelectable",id);
	}
	
	public int updateMapInfo(MapInfo mapInfo) {
		return tpl.update("mapInfoMapper.updateMapInfo",mapInfo);
	}
	
	public int deleteMapInfo(String id) {
		return tpl.delete("mapInfoMapper.deleteMapInfo", id);
	}

	//-------------------------------ENTERANCE INFO----------------------------//
	public int insertEnteranceInfo(EnteranceInfo enteranceInfo) {
		return tpl.insert("mapInfoMapper.insertEnteranceInfo",enteranceInfo);
	}

	public EnteranceInfo readEnteranceInfo(String id) {
		return tpl.selectOne("mapInfoMapper.readEnteranceInfo",id);
	}
	
	public int updateEnteranceInfo(EnteranceInfo enteranceInfo) {
		return tpl.update("mapInfoMapper.updateEnteranceInfo",enteranceInfo);
	}
	
	public int deleteEnteranceInfo(String id) {
		return tpl.delete("mapInfoMapper.deleteEnteranceInfo", id);
	}
	
	
}
