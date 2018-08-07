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
<script src="http://127.0.0.1:8081/map/resources/script/myfunction.js" type="text/javascript"></script>
</head>
<script>
	window.onload = function() {
		var ground = new naver.maps.Map('ground', {
			center : new naver.maps.LatLng(37.451001, 126.656370),
			zoom : 12
		});
		var metaMap = getMetaMap(ground);
		
		naver.maps.Event.addListener(ground, 'click', function(e) {
			makeMarker(metaMap.nextMarkerName++, e.coord, metaMap);
		});
		
		var buildingEnterance;
		buildingEnterance = makeCustomMap(buildingEnterance, "hak_1.jpg", "buildingEnterance");
		console.log(buildingEnterance);
		var metaMap1 = getMetaMap(buildingEnterance)
		
		console.log(metaMap1.map)
		naver.maps.Event.addListener(metaMap1.map, 'click', function(e) {
			makeMarker(metaMap1.nextMarkerName++, e.coord, metaMap1);
		});
		
		var buildingDestination;
		makeCustomMap(buildingDestination, "hak_1.jpg", "buildingDestination");
		
		document.getElementById("load").addEventListener("click",function() {
			//printInfo("one", metaMap);
			ajaxLoadGraphAndNodes($("#loadId").val(), metaMap)
		});
		
		document.getElementById("findFullPath").addEventListener("click",function() {
			alert("click");
			ajaxFullFindPath($("#startingPoint").val(), $("#buildingName").val(), $("#destinationPoint").val(), metaMap);
		});
		
		
		
		
	};
</script>
<body id="body">
	<div>
	load ID : <input type="text" id="loadId"><button id="load">load</button>
	</div>
	출발 지점 : <input id="startingPoint" type="text">
	건물 이름 : <input id="buildingName" type="text">
	도착 호실 : <input id="destinationPoint" type="text">
	<button id="findFullPath">길찾기!</button>
	<div id="ground" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<div id="buildingEnterance" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<div id="buildingDestination" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	
</body>
</html>