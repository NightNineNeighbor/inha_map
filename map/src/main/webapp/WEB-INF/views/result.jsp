<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>인하지도</title>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css?family=Noto+Sans:400,700" rel="stylesheet">
<script src="//code.jquery.com/jquery.min.js"></script>
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=nVEUh5PrMsL3BXJq_8Pl&submodules=panorama"></script>
<script src="./resources/script/myfunction.js" type="text/javascript"></script>
<style>
@import url(http://fonts.googleapis.com/earlyaccess/notosanskr.css);
*{
	font-family: 'Noto Sans KR', 'Noto Sans', sans-serif;
}
body{
	background-image: linear-gradient( to bottom, white, #c5eef4 );
	 margin:0;
}

#title{
	font-weight: 700;
	font-size:42px;
	display:table;
	color : #97d2da;
	height:10%;
	width:100%;
}

#blank{
	height:14%;
}

#nav{
	font-size:42px;
	margin:0 auto;
	width:90%;
	height:24%;
	padding:7px;
	border:thin solid black;
	position:absolute;
	top:10%;
	right:5%;
	z-index:999;
	background-color:white;
}

hr{
	margin:0;
}

.msg{
	height:33%;	
	display:table;
}
.map{
	height:68%;
}

#footer{
	text-align:center;
	display:table;
	width:100%;
	height:8%;
	color:#8dbdc3;
	font-size:28px;
}
</style>
<script>
	window.onload = function() {
		var parsedResult = ${result};
		var destinationPoints = {};
		var arr = [];
		var ground;
		var metaMap = {};
		var metaMapFirstFloor = {} ;
		var metaMapDestFloor = {};
		var first = true;
		var pano;
		var streetLayer;
		var myObj;
		var bodyHeight = $(window).height();
		var buildingMapper = {"building1":"본관","building2":"2,4호관","building5":"5호관","building6":"6,9호관","building7":"학생회관","building10":"서호관","building11":"나빌레관","building12":"하이테크"};
		$("body").css("height",bodyHeight);
		
		
		
		ground = new naver.maps.Map('ground', {
			center : new naver.maps.LatLng(37.4492592, 126.6543461),
			zoom : 12
		});
		metaMap = getMetaMap(ground, false);
		
	   	streetLayer = new naver.maps.StreetLayer();
	    streetLayer.setMap(null);
	    
	    var btn = $('#street');
	    var h = $("#ground").height();
	   
	    var startingPoint = parsedResult["startingPoint"];
		var startingPointName = parsedResult["startingPointName"];
		var mappedBuildingName = buildingMapper[parsedResult["buildingName"]];
		var buildingName = parsedResult["buildingName"];
		var floor = parsedResult["floor"];
		var destination = parsedResult["destination"]; 
		var enteranceFloor = parsedResult["enteranceFloor"]
		
		var groundNodes = JSON.parse(parsedResult['ground_Nodes'])
		metaMap.map.setCenter(groundNodes[startingPoint])
		drawPath(groundNodes ,parsedResult['ground_Paths'], "도착" ,metaMap)
		
		var msg = destination;
		if(parsedResult['mapAmount']==="3"){
			msg = floor + "층으로";
			var secondMap = makeCustomMap(buildingName, floor, "secondMap");
			metaMapDestFloor = getMetaMap(secondMap, true);
			var secondNodes = JSON.parse(parsedResult['secondNodes']);
			drawPath(secondNodes, 
					 parsedResult['secondPaths'], 
					 destination,
					 metaMapDestFloor);
			var secondCenter = secondNodes[parsedResult['secondPaths'][0]];
			metaMapDestFloor.map.setCenter(secondCenter);
		}
		
		metaMapFirstFloor = getMetaMap(makeCustomMap(buildingName, enteranceFloor, "firstMap"), true);
		drawPath(JSON.parse(parsedResult['firstNodes']),
				 parsedResult['firstPaths'],
				 msg,
				 metaMapFirstFloor);
		var centerPosition = parsedResult['firstPaths'][0]
		metaMapFirstFloor.map.setCenter(JSON.parse(parsedResult['firstNodes'])[centerPosition]);
		
		var h1 = $("#msg1").height();
		$("#tt1").css("height",h1);
		$("#tt1").css("width",h1);
		$("#tt2").css("height",h1);
		$("#tt2").css("width",h1);
		$("#tt3").css("height",h1);
		$("#tt3").css("width",h1);
		
		$("#ground").show();
		$("#firstMap").hide();
		$("#secondMap").hide();
		
		$("#tt1").css("background-color","#96d2da");
		$("#tt2").css("background-color","white");
		$("#tt3").css("background-color","white");
		$("#tt1").css("color","white");
		$("#tt2").css("color","#a4a4a4");
		$("#tt3").css("color","#a4a4a4");
		$("#msg1").css("color","#343434").css("font-weight","Bold");
		$("#msg2").css("color","#a4a4a4").css("font-weight","");
		$("#msg3").css("color","#a4a4a4").css("font-weight","");
		
		$("#tt3").html("");
		$("#msg1").html("&nbsp");
		$("#msg2").html("&nbsp");
		$("#msg3").html("&nbsp");
		$("#msg1").text(startingPointName +"에서 " + mappedBuildingName + "으로");
		$("#msg2").text( mappedBuildingName + "입구에서 " + msg);
		if(parsedResult['mapAmount']==="3"){
			$("#msg3").text( floor+ "층에서 " + destination + "으로");
			$("#tt3").html("3");
		}
		
		document.getElementById("title").addEventListener("click",function() {
			location.href="./";
		});
		
		document.getElementById("box1").addEventListener("click",function() {
			$("#tt1").css("background-color","#96d2da");
			$("#tt2").css("background-color","white");
			$("#tt3").css("background-color","white");
			$("#tt1").css("color","white");
			$("#tt2").css("color","#a4a4a4");
			$("#tt3").css("color","#a4a4a4");
			$("#msg1").css("color","#343434").css("font-weight","Bold");
			$("#msg2").css("color","#a4a4a4").css("font-weight","200");
			$("#msg3").css("color","#a4a4a4").css("font-weight","200");
			
			$("#ground").show();
			$("#pano").show();
			$("#firstMap").hide();
			$("#secondMap").hide();
		});
		
		document.getElementById("box2").addEventListener("click",function() {
			$("#tt1").css("background-color","white");
			$("#tt2").css("background-color","#96d2da");
			$("#tt3").css("background-color","white");
			$("#tt1").css("color","#a4a4a4");
			$("#tt2").css("color","white");
			$("#tt3").css("color","#a4a4a4");
			$("#msg1").css("color","#a4a4a4").css("font-weight","200");
			$("#msg2").css("color","#343434").css("font-weight","Bold");
			$("#msg3").css("color","#a4a4a4").css("font-weight","200");
			
			$("#ground").hide();
			$("#pano").hide();
			$("#firstMap").show();
			$("#secondMap").hide();
		});
		
		document.getElementById("box3").addEventListener("click",function() {
			$("#tt1").css("background-color","white");
			$("#tt2").css("background-color","white");
			$("#tt3").css("background-color","#96d2da");
			$("#tt1").css("color","#a4a4a4");
			$("#tt2").css("color","#a4a4a4");
			$("#tt3").css("color","white");
			$("#msg1").css("color","#a4a4a4").css("font-weight","200");
			$("#msg2").css("color","#a4a4a4").css("font-weight","200");
			$("#msg3").css("color","#343434").css("font-weight","Bold");
			
			$("#ground").hide();
			$("#pano").hide();
			$("#firstMap").hide();
			$("#secondMap").show();
		});
		
		 btn.on("click", function(e) {
		        e.preventDefault();

		        if (streetLayer.getMap()) {
		        	naver.maps.Event.clearInstanceListeners(ground);
		        	$("#pano").hide();
		        	$("#ground").css("height",h);
		            streetLayer.setMap(null);
		            var groundNodes = JSON.parse(parsedResult['ground_Nodes']);
		            var startingPoint = parsedResult["startingPoint"];
					metaMap.map.setCenter(groundNodes[startingPoint])
		            drawPath(groundNodes ,parsedResult['ground_Paths'], "도착" ,metaMap)
		            
		        } else {
		        	naver.maps.Event.addListener(ground, 'click', function(e) {
				    	$("#ground").css("height",h/2);
			        	$("#pano").css("height",h/2);
			        	$("#pano").fadeIn(1700);
			        	pano = new naver.maps.Panorama("pano", {
					        position: e.coord,
					        pov: {
					            pan: -133,
					            tilt: 0,
					            fov: 100
					        }
					    });
				        if (streetLayer.getMap() && streetLayer.getMap()) {
				            var latlng = e.coord;
				            pano.setPosition(latlng);
				        }
				    });
		            streetLayer.setMap(ground);
		            var groundNodes = JSON.parse(parsedResult['ground_Nodes'])
		            var startingPoint = parsedResult["startingPoint"]
					metaMap.map.setCenter(groundNodes[startingPoint])
		            drawPath(groundNodes ,parsedResult['ground_Paths'], "도착" ,metaMap)
		        }
		    });
	};
</script>
</head>
<body>
<div id="nav" style="">
	<div id="box1" class="msg">
		<div style="display:table-cell;text-align:center;vertical-align:middle;">
		<div id="tt1" style="color:white;background-color:#96d2da;display:inline-block;margin:0 15px 0 15px;text-align:center;border-radius:50%;">1</div>
		<div id="msg1" style="display:inline-block">&nbsp하이테크에서 후문으로</div><button id="street">거리뷰</button>
		</div>
	</div>
	<hr  style="width : 97%;border:thin solid grey">
	<div id="box2" class="msg">
		<div style="display:table-cell;text-align:center;vertical-align:middle;">
		<div class="mint w "id="tt2" style="display:inline-block;margin:0 15px 0 15px;text-align:center;border-radius:50%;">2</div>
		<div id="msg2" style="display:inline-block">&nbsp하이테크에서 후문으로</div>
		</div>
	</div>
	<hr  style="width : 97%;border:thin solid grey">
	<div id="box3" class="msg">
		<div style="display:table-cell;text-align:center;vertical-align:middle;">
		<div class=""id="tt3" style="display:inline-block;margin:0 15px 0 15px;text-align:center;border-radius:50%;">3</div>
		<div id="msg3" style="display:inline-block">&nbsp하이테크에서 후문으로</div>
		</div>
	</div>
</div>
<div id="title">
	<div style="display:table-cell;text-align:center;vertical-align:middle;">INHAJIDO</div>
</div>
<div id="blank"></div>
<!-- map -->
<div id="ground" class="map">
	<!-- <input id="street" type="button" style="position:absolute;z-index:999;padding:5px;" value="거리뷰" /> -->
</div>
<div id="firstMap" class="map"></div>
<div id="secondMap" class="map"></div>
<div id="pano"></div>
	<div id="footer">
		<div style="display:table-cell;text-align:center;vertical-align:middle;">
		powered by sn1982
	</div>
</div>
</body>
</html>