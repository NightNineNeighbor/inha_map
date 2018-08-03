<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>지도112a3</title>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=nVEUh5PrMsL3BXJq_8Pl&submodules=geocoder"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="./resources/script/myfunction.js" type="text/javascript"></script>
</head>
<script>
	window.onload = function() {
		var ground = new naver.maps.Map('ground', {
			center : new naver.maps.LatLng(37.451001, 126.656370),
			zoom : 12
		});
		var metaMap = getMetaMap(ground);
		
		var buildingEnterance;
		makeCustomMap(buildingEnterance, "hak_1.jpg", "buildingEnterance");
		
		var buildingDestination;
		makeCustomMap(buildingDestination, "hak_1.jpg", "buildingDestination");
		
	};
</script>
<body id="body">
	출발 지점 : <input type="text">
	건물 이름 : <input type="text">
	도착 호식 : <input type="text">
	<button>길찾기!</button>
	<div id="ground" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<div id="buildingEnterance" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<div id="buildingDestination" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	
</body>
</html>