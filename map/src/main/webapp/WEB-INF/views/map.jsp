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
<script src="./resources/script/myfunction.js" type="text/javascript"></script>
<style>
body{
	font-size: 250%;
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

.mapNav:hover{
	background-color: #e9e9e9; 
}

#loadingPage {
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
	position: fixed;
	display: table;
	background: black;
	z-index: 999;
	text-align: center;
	font-weight: bold;
	font-size: 50px;
}

#loadingMessage {
	display: table-cell;
	vertical-align: middle;
	color:white;
}
</style>
<script>
	window.onload = function() {
		var destinationPoints = {};
		var arr = [];
		var ground;
		var metaMap = getMetaMap(ground, false);
		var metaMapFirstFloor ;
		var metaMapDestFloor;
		var first = true;
		inite();
		
		document.getElementById("findFullPath").addEventListener("click",function() {
			var destination = $("#destinationPoint").val();
			var t = destinationPoints[destination];
			var floor = t["floor"];
			var buildingName = t["buildingName"];
			var destinationPoint = t["nodeNum"];
			var startingPointName = $("#startingPoint").find("option[value='" + $("#startingPoint").val() + "']").text()
			
			ajaxFullFindPath($("#startingPoint").val(), startingPointName, buildingName, floor, destinationPoint, destination,
					metaMap, metaMapFirstFloor, metaMapDestFloor);
		});
		
		document.getElementById("groundNav").addEventListener("click",function() {
			$("#ground").show();
			$("#firstMap").hide();
			$("#secondMap").hide();
		});
		
		document.getElementById("firstMapNav").addEventListener("click",function() {
			$("#ground").hide();
			$("#firstMap").show();
			$("#secondMap").hide();
		});
		
		document.getElementById("secondMapNav").addEventListener("click",function() {
			$("#ground").hide();
			$("#firstMap").hide();
			$("#secondMap").show();
		});
		
		autocomplete(document.getElementById("destinationPoint"), arr);
		
		function inite(){
			ground = new naver.maps.Map('ground', {
				center : new naver.maps.LatLng(37.4492592, 126.6543461),
				zoom : 12
			});
			
			var selectable = '${selectable}';
			var building5_0F = '${building5_0F}';
			var building5_1F = '${building5_1F}';
			selectable = JSON.parse(selectable);
			building5_0F = JSON.parse(building5_0F);
			building5_1F = JSON.parse(building5_1F);
			var startingPoint = document.getElementById("startingPoint");
			$.each(selectable, function(key,value){
				a = document.createElement("OPTION");
				a.setAttribute("value",key);
				a.innerHTML = value;
				startingPoint.appendChild(a);
			});
			
			$.each(building5_0F, function(key,value){
				$.each(value, function(index, item){
					arr.push(item);
					destinationPoints[item] = {buildingName:"building5",
													"floor":0,
													"nodeNum":key};
				})
			});
			
			$.each(building5_1F, function(key,value){
				$.each(value, function(index, item){
					arr.push(item);
					destinationPoints[item] = {buildingName:"building5",
													"floor":1,
													"nodeNum":key};
				})
			});
			
			var h = $(window).height() - $("#header").height();
			$("#ground").css("height",h);
			$("#firstMap").css("height",h);
			$("#secondMap").css("height",h);
			
			$("#ground").show();
			$("#firstMap").hide();
			$("#secondMap").hide();
			
			$("#loadingPage").fadeOut(1000);
		}
		
		function clearDiv(){
			if(first === false){
				$("#ground").empty();
				$("#firstMap").empty()
				$("#secondMap").empty()
			}
			first = false;
		}
	};
</script>
</head>
<body>
<div id="loadingPage">
	<div id="loadingMessage">인하지도</div>
</div>
<div id="header">
	<div>
	출발 지점 : <select id="startingPoint"></select>
	</div>

	<div>
	<div class="autocomplete" >
		도착 지점 : <input id = destinationPoint type = "text">
		<button id="findFullPath">길찾기!</button>
	</div>
	</div>
	<div id="groundNav" class="mapNav">&nbsp</div>
	<div id="firstMapNav" class="mapNav">&nbsp</div>
	<div id="secondMapNav" class="mapNav">&nbsp</div>
</div>
<div id="ground" style="border: 1px solid black;  width: 100%;"></div>
<div id="firstMap" style="border: 1px solid white; height: 1000px; width: 100%;" ></div>
<div id="secondMap" style="border: 1px solid white; height: 1000px; width: 100%;"></div>
<div id="fotter">
<h1>FOOTER INFO</h1>
</div>
</body>
</html>