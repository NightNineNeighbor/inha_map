<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>인하지도</title>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/latest/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/latest/js/bootstrap.min.js"></script>
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=nVEUh5PrMsL3BXJq_8Pl&submodules=geocoder"></script>
<script src="http://127.0.0.1:8081/map/resources/script/myfunction.js" type="text/javascript"></script>
<style>
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
		var metaMapFirstFloor ;
		var metaMapDestFloor;
		
		document.getElementById("findFullPath").addEventListener("click",function() {
			var destination = $("#destinationPoint").val();
			var t = destinationPoints[destination];
			var floor = t["floor"];
			var buildingName = t["buildingName"];
			var destinationPoint = t["nodeNum"];
			ajaxFullFindPath($("#startingPoint").val(), buildingName, floor, destinationPoint, destination,
					metaMap, metaMapFirstFloor, metaMapDestFloor);
		});
		
		autocomplete(document.getElementById("destinationPoint"), arr);
		
		function inite(){
			var selectable = '${selectable}';
			var building5_0F = '${building5_0F}';
			var building5_1F = '${building5_1F}';
			var building5_2F = '${building5_2F}';
			selectable = JSON.parse(selectable);
			building5_0F = JSON.parse(building5_0F);
			building5_1F = JSON.parse(building5_1F);
			building5_2F = JSON.parse(building5_2F);
			var startingPoint = document.getElementById("startingPoint");
			$.each(selectable, function(key,value){
				a = document.createElement("OPTION");
				a.setAttribute("value",key);
				a.innerHTML = value;
				startingPoint.appendChild(a);
			});
			$.each(building5_0F, function(key,value){
				if(value.substr(0,2)!=="계단"){
					arr.push(value);
					destinationPoints[value] = {buildingName:"building5",
												"floor":0,
												"nodeNum":key};
				}
			});
			$.each(building5_1F, function(key,value){
				if(value.substr(0,2)!=="계단"){
					arr.push(value);
					destinationPoints[value] = {buildingName:"building5",
												"floor":1,
												"nodeNum":key};
				}
			});
			$.each(building5_2F, function(key,value){
				if(value.substr(0,2)!=="계단"){
					arr.push(value);
					destinationPoints[value] = {buildingName:"building5",
												"floor":2,
												"nodeNum":key};
				}
			});
		}
		
	};
</script>
</head>
<body id="body">
<div id="header" style="text-align: center;">
<h1>인하지도</h1>
</div>
<div style="width:500px; margin:0 auto;">
출발 지점 : <select id="startingPoint"></select>
</div>

<div style="width:500px; margin:0 auto;">
<div class="autocomplete" >
	도착 지점 : <input id = destinationPoint type = "text">
	<button id="findFullPath">길찾기!</button>
</div>
</div>
<div id="ground" class="center-block" style="border: 1px solid black; height: 500px; width: 500px; margin : auto"></div>
<div id=firstFloor class="center-block" style="border: 1px solid white; height: 500px; width: 500px; margin : auto"></div>
<div id="destFloor" class="center-block" style="border: 1px solid white; height: 500px; width: 500px; margin : auto"></div>
</body>
</html>