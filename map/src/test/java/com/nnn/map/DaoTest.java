package com.nnn.map;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.nnn.map.dao.MapInfoDao;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations= {"classpath:servlet-context.xml","classpath:root-context"})
@WebAppConfiguration
public class DaoTest {
	@Autowired
	MapInfoDao dao;
	
	@Test
	public void setUPTest() {
		assertThat(dao, is(notNullValue()));
	}

}
