<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>지도 업로드</title>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=nVEUh5PrMsL3BXJq_8Pl&submodules=geocoder"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="http://127.0.0.1:8081/map/resources/script/myfunction.js" type="text/javascript"></script>
</head>
<script>
	window.onload = function() {
		sayHello();
		
		var mapImage;
		var floor;
		
		var map;
		var metaMap;
		var refMap;
		var refMetaMap;
		var outer=[];
		var inner=[];
		
		document.getElementById("mapImageLoad").addEventListener("click",function() {
			outer = [];
			inner = [];
			
			if(metaMap !== undefined){
				$("#mapDiv").empty();
				$("#refMapDiv").empty()
			}
			
			map = {};
			metaMap = {};
			floor = $("#floor").val();
			mapImage = $("#mapImage").val();
			
			$.ajax({
				url : "./getEnteranceInfo",
				type : "post",
				data : "id=" + mapImage,
				success : function(result) {
					var p = JSON.parse(result);
					inner = JSON.parse(p.innerEnterance);
					outer = JSON.parse(p.outerEnterance);
				}
			});
			
			if(mapImage.substring(0,6) === 'ground'){
				console.log("ground");
				map = new naver.maps.Map('mapDiv', {
					center : new naver.maps.LatLng(37.451001, 126.656370),
					zoom : 12
				});
				metaMap = getMetaMap(map, false)
				ajaxLoadMapInfo(mapImage+"_1F", metaMap);
			}else if(floor===1){
				map = makeCustomMap(mapImage, 1, "mapDiv");
				metaMap = getMetaMap(map, true);
				ajaxLoadMapInfo(mapImage+"_1F", metaMap);
			}else{
				map = makeCustomMap(mapImage, floor, "mapDiv");
				metaMap = getMetaMap(map, true);
				ajaxLoadMapInfo(mapImage +"_"+floor+"F", metaMap);
				
				refMap = makeCustomMap(mapImage, 1, "refMapDiv");
				refMetaMap = getMetaMap(refMap, true);
				ajaxLoadMapInfo(mapImage+"_1F", refMetaMap);
			}
			
			naver.maps.Event.addListener(metaMap.map, 'click', function(e) {
				if(metaMap.isBuilding){
					e.coord.floor();
				}
				console.log(metaMap);
				makeMarker(metaMap.nextMarkerName++, e.coord, metaMap);
			});
		})
		
		document.getElementById("save").addEventListener("click",function() {
			$.each(metaMap.stairs, function(index, item) {
				if(item === undefined){
					metaMap.stairs[index] = -1;
				}
			});
			ajaxSaveMapInfo(mapImage +"_"+floor+"F", metaMap);
		});
		
		document.getElementById("printInfo").addEventListener("click",function() {
			printInfo("mapInfo", metaMap);
		});
		
		document.getElementById("setStairs").addEventListener("click",function() {
			setStairs();
		});
		
		document.getElementById("setElevator").addEventListener("click",function() {
			setElevator();
		});
		
		document.getElementById("setEnterance").addEventListener("click",function() {
			setEnterance();
		});
		
		document.getElementById("resetEnterance").addEventListener("click",function() {
			outer = [];
			inner = [];
		});
		
		document.getElementById("saveEnterance").addEventListener("click",function() {
			$.ajax({
				url : "./saveEnteranceInfo",
				type : "post",
				data : "id=" + mapImage + 
						"&outer=" + JSON.stringify(outer) + 
						"&inner=" + JSON.stringify(inner),
				success : function(result) {}
			});
		});
		
		document.getElementById("readEnterance").addEventListener("click",function() {
			console.log("outer");
			console.log(outer);
			console.log("inner");
			console.log(inner);
		});
		
		function setStairs(){
			metaMap.stairs[ $("#stairNumber").val() ] = $("#targetNode").val();
		}
		
		function setElevator(){
			metaMap.elevators[ $("#elevatorNumber").val() ] = $("#elvTargetNode").val();
		}
		
		function setEnterance(){
			outer.push($("#outerEnterance").val());
			var arr = [];
			arr.push($("#innerEnterance").val());
			arr.push(floor);
			inner.push(arr);
		}
		
		document.getElementById("xFiveAndTen").addEventListener("click",function() {
			var startNode = $("#startNode").val();
			var endNode = $("#endNode").val();
			var standardNode = $("#standardNode").val();
			fiveAndTen(startNode, endNode, standardNode, true, metaMap);
			console.log(metaMap);
		});
		
		document.getElementById("yFiveAndTen").addEventListener("click",function() {
			var startNode = $("#startNode").val();
			var endNode = $("#endNode").val();
			var standardNode = $("#standardNode").val();
			fiveAndTen(startNode, endNode, standardNode, false, metaMap);
			console.log(metaMap);
		});
		
		document.getElementById("toggle").addEventListener("click",function() {
			$.each(metaMap.markers, function(key, value) {
				value.setMap(null);
			});
			
		});
		
		function fiveAndTen(startNode, endNode, standardNode, isX, m){
			var standard;
			
			if(isX){
				standard = m.nodes[standardNode].x;
			}else{
				standard = m.nodes[standardNode].y;
			}
			
			for(var i = Number(startNode); i <= Number(endNode); i++){
				if(isX){
					m.nodes[i].x = standard;
					m.markers[i].setPosition(
							new naver.maps.Point(standard, m.nodes[i].y))
				}else{
					m.nodes[i].y = standard;
					m.markers[i].setPosition(
							new naver.maps.Point(m.nodes[i].x, standard))
				}
			}
		}
	};
</script>
<body id="body">
	<div>
		<input type="text" id="mapImage"><input type="number" id="floor">층
		<button id="mapImageLoad">맵 이미지 로드</button>
		<button id="save">저장</button>
	</div>
	<div id="mapDiv" style="border: 1px solid black; height: 500px; width: 100%;"></div>
	<div>
		계단
		<input type="number" id="stairNumber" style="width: 50px;">번을
		<input type="number" id="targetNode" style="width: 50px;">번 노드와 연동
		<button id="setStairs">계단 세팅</button>
	</div>
	<div>
		엘베
		<input type="number" id="elevatorNumber" style="width: 50px;">번을
		<input type="number" id="elvTargetNode" style="width: 50px;">번 노드와 연동
		<button id="setElevator">엘베 세팅</button>
	</div>
	<div>
		바깥 입구
		<input type="number" id="outerEnterance" style="width: 50px;">번과
		<input type="number" id="innerEnterance" style="width: 50px;">번 노드를 연동
		<button id="setEnterance">출입구 세팅</button>
		<button id="readEnterance">출입구 정보 출력</button>
		<button id="resetEnterance">출입구 정보 리셋</button>
		<button id="saveEnterance">출입구 정보 저장</button>
	</div>
	<div>
		<input type="number" id="startNode" style="width: 50px;">
		<input type="number" id="endNode" style="width: 50px;">
		<input type="number" id="standardNode" style="width: 50px;">
		<button id="xFiveAndTen" style="width: 50px;">세로</button>
		<button id="yFiveAndTen" style="width: 50px;">가로</button>
	</div>
	<button id="printInfo">맵 정보 표시</button>
	<button id="toggle">마커 끄기</button>
	<div id="mapInfo"></div>
	<div id="refMapDiv" style="border: 1px solid black; height: 500px; width: 100%;"></div>
</body>
</html>