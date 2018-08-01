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
<script src="./resources/script/myfunction.html"></script>
</head>
<script>
	window.onload = function() {
		sayHello();
		
		var building;
		makeBuilding();
		
		function getMetaMap(map){
			var Object = {};
			Object["map"] = map;
			Object["nextMarkerName"] = 0;
			Object["nodes"] = {};			//format : {"0":{"y":37.4515427,"_lat":37.4515427,"x":126.6564996,"_lng":126.6564996},}
			Object["graph"] = [];			//format : [[0,1,33700],[1,2,9236]]
			Object["markers"] = {};
			Object["polylines"] = [];
			Object["selectableNode"] = {};
			Object["bestLine"] = new naver.maps.Polyline();
			Object["flag"] = true;
			Object["prevNode"] = 0;
			Object["prevX"] = 0;
			Object["prevY"] = 0;
			Object["path"] = {};
			Object["pl"] = {};
			return Object
		}
		var map = new naver.maps.Map('map', {
			center : new naver.maps.LatLng(37.451001, 126.656370),
			zoom : 12
		});
		var metaMap = getMetaMap(map)

		inite();

		//클릭하면 마커 생상
		naver.maps.Event.addListener(map, 'click', function(e) {
			makeMarker(metaMap.nextMarkerName++, e.coord, metaMap);
		});

		document.getElementById("saveNode").addEventListener("click",function() {
			printInfo(metaMap);
		});

		document.getElementById("loadNode").addEventListener("click",function() {
			loadNode($("#nodesInfo").val(), $("#graphInfo").val(), $("#selectableInfo").val(), metaMap)
		})

		
		document.getElementById("findPath").addEventListener("click",function() {
			ajaxFindPath($("#startingPoint").val(), $("#destinationPoint").val(), metaMap);
		});
		
		

		document.getElementById("endOfSetting").addEventListener("click",function() {
			showSelectableList("selectableList" , metaMap);
		});
		
		document.getElementById("mapToggle").addEventListener("click",function() {
			mapToggle(metaMap)
		});

		function inite() {
			loadNode('${nodes}', '${graph}', '${selectable}', metaMap);
			toggleGraphNode(null, metaMap);
			showSelectableList("selectableList" , metaMap);
		}

		
	};
</script>
<body id="body">
	<div id="map"
		style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<h3>리스트를 바탕으로 길을 찾아 보☆아☆요!</h3>
	<div id="selectableList"></div>
	<div>출발지 : <input id="startingPoint" type="text" value = "0"></div>
	<div>도착지 : <input	id="destinationPoint" type="text" value="13"></div> 
	<div><button id="findPath">길찾기</button></div>
	<button id="saveNode">saveNode</button>
	<div id="printInfo"></div>
	nodesInfo :
	<input id="nodesInfo" type="text">
	<br> graphInfo :
	<input id="graphInfo" type="text">
	<br> selectableInfo :
	<input id="selectableInfo" type="text">
	<br>
	<button id="loadNode">loadNode</button>
	<br>
	<button id="endOfSetting">endOfSetting</button>
	
	<div>
		
	</div>
	<button id="mapToggle">mapToggle</button>

	<div id="building"
		style="border: 1px solid black; height: 500px; width: 500px;"></div>
</body>
</html>