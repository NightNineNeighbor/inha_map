package com.nnn.map.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.nnn.map.vo.MapInfo;

@Repository
public class MapInfoDao {
	@Autowired
	SqlSessionTemplate tpl;
	
	public int insertGraphAndNodes(MapInfo mapInfo) {
		return tpl.insert("mapInfoMapper.insertGraphAndNodes",mapInfo);
	}

	public MapInfo readGraphAndNodes(String id) {
		return tpl.selectOne("mapInfoMapper.readGraphAndNodes",id);
	}
	
	public int updateGraphAndNodes(MapInfo mapInfo) {
		return tpl.update("mapInfoMapper.updateGraphAndNodes",mapInfo);
	}
	
	public int deleteGraphAndNodes(String id) {
		return tpl.delete("mapInfoMapper.deleteGraphAndNodes", id);
	}

	public String getEnterance(String string) {
		// TODO Auto-generated method stub
		return "[7,8]";
		
	}

	public int getFloor(String destinationPoint) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	
}
