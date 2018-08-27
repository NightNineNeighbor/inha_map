<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>지도1233</title>
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
					console.log(result);
					alert();
				}
			});
			
			if(mapImage.substring(0,6) === 'ground'){
				console.log("ground");
				map = new naver.maps.Map('mapDiv', {
					center : new naver.maps.LatLng(37.451001, 126.656370),
					zoom : 12
				});
				metaMap = getMetaMap(map)
				ajaxLoadMapInfo(mapImage, metaMap);
			}else if(floor===1){
				map = makeCustomMap(mapImage, 1, "mapDiv");
				metaMap = getMetaMap(map);
				ajaxLoadMapInfo(mapImage+"_1F", metaMap);
			}else{
				map = makeCustomMap(mapImage, floor, "mapDiv");
				metaMap = getMetaMap(map);
				ajaxLoadMapInfo(mapImage +"_"+floor+"F", metaMap);
				
				refMap = makeCustomMap(mapImage, 1, "refMapDiv");
				refMetaMap = getMetaMap(refMap);
				ajaxLoadMapInfo(mapImage+"_1F", refMetaMap);
								
				metaMap.stairs = Array( refMetaMap.stairs.length );
				metaMap.elevators = Array( refMetaMap.elevators.length );
			}
			
			naver.maps.Event.addListener(metaMap.map, 'click', function(e) {
				makeMarker(metaMap.nextMarkerName++, e.coord, metaMap);
			});
		})
		
		document.getElementById("save").addEventListener("click",function() {
			ajaxSaveMapInfo(mapImage +"_"+floor+"F", metaMap)
		});
		
		document.getElementById("printInfo").addEventListener("click",function() {
			printInfo("mapInfo", metaMap);
		});
		
		document.getElementById("setStairs").addEventListener("click",function() {
			setStairs();
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
			alert(metaMap.stairs[ $("#stairNumber").val() ]);
		}
		
		function setEnterance(){
			outer.push($("#outerEnterance").val());
			var arr = [];
			arr.push($("#innerEnterance").val());
			arr.push(floor);
			inner.push(arr);
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
		바깥 입구
		<input type="number" id="outerEnterance" style="width: 50px;">번과
		<input type="number" id="innerEnterance" style="width: 50px;">번 노드를 연동
		<button id="setEnterance">출입구 세팅</button>
		<button id="readEnterance">출입구 정보 출력</button>
		<button id="resetEnterance">출입구 정보 리셋</button>
		<button id="saveEnterance">출입구 정보 저장</button>
	</div>
	<button id="printInfo">맵 정보 표시</button>
	<div id="mapInfo"></div>
	<div id="refMapDiv" style="border: 1px solid black; height: 500px; width: 100%;"></div>
</body>
</html>