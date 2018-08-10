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
<style>
div{
	margin : 0 auto;
}
.autocomplete {
  /*the container must be positioned relative:*/
  position: relative;
  display: inline-block;
}
.autocomplete-items {
  position: absolute;
  border: 1px solid #d4d4d4;
  border-bottom: none;
  border-top: none;
  z-index: 99;
  /*position the autocomplete items to be the same width as the container:*/
  top: 100%;
  left: 0;
  right: 0;
}
.autocomplete-items div {
  padding: 10px;
  cursor: pointer;
  background-color: #fff; 
  border-bottom: 1px solid #d4d4d4; 
}
.autocomplete-items div:hover {
  /*when hovering an item:*/
  background-color: #e9e9e9; 
}
</style>
<script>
	window.onload = function() {
		var destinationPoints = {};
		var arr = [];
		inite();
		
		var ground = new naver.maps.Map('ground', {
			center : new naver.maps.LatLng(37.451001, 126.656370),
			zoom : 12
		});
		var metaMap = getMetaMap(ground);
		
		var metaMapBE ;
		
		var metaMapBD;
		
		//buildingEnterance = makeCustomMap(buildingEnterance, "hak_1.jpg", "buildingEnterance");
		//var metaMapBE = getMetaMap(buildingEnterance);
		
		//var buildingDestination = makeCustomMap(buildingDestination, "hak_1.jpg", "buildingDestination");
		//var metaMapBD = getMetaMap(buildingDestination) 
		
		document.getElementById("findFullPath").addEventListener("click",function() {
			var t = destinationPoints[$("#destinationPoint").val()];
			var floor = t["floor"];
			console.log("floor" + floor);
			var buildingName = t["buildingName"];
			console.log("buildingName" + buildingName);
			var destinationPoint = t["nodeNum"];
			console.log("nodeNum" + destinationPoint);
			ajaxFullFindPath($("#startingPoint").val(), buildingName, floor, destinationPoint,
					metaMap, metaMapBE, metaMapBD);
		});
		
		autocomplete(document.getElementById("destinationPoint"), arr);
		autocomplete(document.getElementById("autoTest"), countries);
		console.log(countries);
		
		function inite(){
			var selectable = '${selectable}';
			var building5_0F = '${building5_0F}';
			var building5_1F = '${building5_1F}';
			var building5_2F = '${building5_2F}';
			selectable = JSON.parse(selectable);
			building5_0F = JSON.parse(building5_0F);
			building5_1F = JSON.parse(building5_1F);
			building5_2F = JSON.parse(building5_2F);
			console.log(selectable);
			var startingPoint = document.getElementById("startingPoint");
			$.each(selectable, function(key,value){
				a = document.createElement("OPTION");
				a.setAttribute("value",key);
				a.innerHTML = value;
				startingPoint.appendChild(a);
			});
			$.each(building5_0F, function(key,value){
				arr.push(value);
				destinationPoints[value] = {buildingName:"building5",
											"floor":0,
											"nodeNum":key};
			});
			$.each(building5_1F, function(key,value){
				arr.push(value);
				destinationPoints[value] = {buildingName:"building5",
											"floor":1,
											"nodeNum":key};
			});
			$.each(building5_2F, function(key,value){
				arr.push(value);
				destinationPoints[value] = {buildingName:"building5",
											"floor":2,
											"nodeNum":key};
			});
			console.log(destinationPoints);
		}
		
	};
</script>
</head>
<body id="body">
<div id="header">
<h1>인하지도</h1>
</div>
<div id="selector">
	출발 지점 : <select id="startingPoint"></select>
	찾는 것 : 
	<select>
		<option>강의실</option>
		<option>건물</option>
		<option>행정 건물</option>
		<option>편의 시설</option>
		<option>동아리</option>
	</select>
	건물 이름 : 
	<select id="buildingName">
		<option value="1">5호관</option>
		<option>본관</option>
		<option>2호관</option>
		<option>6호관</option>
	</select>
	
	<div class="autocomplete">
	도착 : <input id = destinationPoint type = "text">
	</div>
	<button id="findFullPath">길찾기!</button>
</div>
<div>
	<div id="ground" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<div id="buildingEnterance" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<div id="buildingDestination" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<div class="autocomplete">
	도착 호실 : <input id="autoTest" type="text">
	</div>
</div>
</body>
</html>