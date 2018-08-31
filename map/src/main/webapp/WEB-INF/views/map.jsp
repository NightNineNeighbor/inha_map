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
@import url(//fonts.googleapis.com/earlyaccess/notosanskannada.css);
*{
	font-family: 'Noto Sans KR', 'Noto Sans', sans-serif;
	font-weight: 400;
	font-size:20px;
}

input{
	border:none;
	border-right:0px;
	border-top:0px;
	boder-left:0px;
	boder-bottom:0px;"
}
input:focus {
  outline: none;
}
select{
	border:none;
	border-right:0px;
	border-top:0px;
	boder-left:0px;
	boder-bottom:0px;"
}
select:focus {
  	outline: none;
}


.bold{
	font-weight: Bold;
}

.w{
	color: white;
}

.mint{
	background-color: #5ce7bd;
}
.white{
	background-color: #fff;
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
	z-index: 1000;
	text-align: center;
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
		var metaMap;
		var metaMapFirstFloor ;
		var metaMapDestFloor;
		var first = true;
		var pano;
		var streetLayer;
		inite();
		
		document.getElementById("findFullPath").addEventListener("click",function() {
			clearDiv();
			
			var destination = $("#destinationPoint").val();
			var t = destinationPoints[destination];
			var floor = t["floor"];
			var buildingName = t["buildingName"];
			var destinationPoint = t["nodeNum"];
			var startingPointName = $("#startingPoint").find("option[value='" + $("#startingPoint").val() + "']").text()
			
			$("#groundNav").css("color","#343434").css("font-weight","Bold");
			$("#firstMapNav").css("color","#a4a4a4").css("font-weight","");
			$("#secondMapNav").css("color","#a4a4a4").css("font-weight","");
			
			$("#ground").show();
			$("#firstMap").hide();
			$("#secondMap").hide();
			
			ajaxFullFindPath($("#startingPoint").val(), startingPointName, buildingName, floor, destinationPoint, destination,
					metaMap, metaMapFirstFloor, metaMapDestFloor);
		});
		
		document.getElementById("groundNav").addEventListener("click",function() {
			$("#groundNav").css("color","#343434").css("font-weight","Bold");
			$("#firstMapNav").css("color","#a4a4a4").css("font-weight","");
			$("#secondMapNav").css("color","#a4a4a4").css("font-weight","");
			
			$("#ground").show();
			$("#firstMap").hide();
			$("#secondMap").hide();
		});
		
		document.getElementById("firstMapNav").addEventListener("click",function() {
			$("#groundNav").css("color","#a4a4a4").css("font-weight","");
			$("#firstMapNav").css("color","#343434").css("font-weight","Bold");
			$("#secondMapNav").css("color","#a4a4a4").css("font-weight","");
			
			$("#ground").hide();
			$("#firstMap").show();
			$("#secondMap").hide();
		});
		
		document.getElementById("secondMapNav").addEventListener("click",function() {
			$("#groundNav").css("color","#a4a4a4").css("font-weight","");
			$("#firstMapNav").css("color","#a4a4a4").css("font-weight","");
			$("#secondMapNav").css("color","#343434").css("font-weight","Bold");
			
			$("#ground").hide();
			$("#firstMap").hide();
			$("#secondMap").show();
		});
		
		autocomplete(document.getElementById("destinationPoint"), arr);
		
		function inite(){
			var selectable = '${selectable}';
			
			var hardCoding = [];
			//hardCoding.push(JSON.parse('${building1_0F}'));
			hardCoding.push(JSON.parse('${building1_1F}'));
			hardCoding.push(JSON.parse('${building1_2F}'));
			hardCoding.push(JSON.parse('${building1_3F}'));
			hardCoding.push(JSON.parse('${building1_4F}'));
			hardCoding.push(JSON.parse('${building1_5F}'));
			var myobj={};
			myParse2(hardCoding,1,1,myobj)
			console.log(myobj);
			
			/* 
			hardCoding = [];
			hardCoding.push(JSON.parse('${building2_0F}'));
			hardCoding.push(JSON.parse('${building2_1F}'));
			hardCoding.push(JSON.parse('${building2_2F}'));
			hardCoding.push(JSON.parse('${building2_3F}'));
			hardCoding.push(JSON.parse('${building2_4F}'));
			hardCoding.push(JSON.parse('${building2_5F}'));
			hardCoding.push(JSON.parse('${building2_6F}'));
			
			hardCoding = [];
			hardCoding.push(JSON.parse('${building5_0F}'));
			hardCoding.push(JSON.parse('${building5_1F}'));
			hardCoding.push(JSON.parse('${building5_2F}'));
			hardCoding.push(JSON.parse('${building5_3F}'));
			hardCoding.push(JSON.parse('${building5_4F}'));
			hardCoding.push(JSON.parse('${building5_5F}'));
			
			hardCoding = [];
			//hardCoding.push(JSON.parse('${building6_0F}'));
			//hardCoding.push(JSON.parse('${building6_1F}'));
			hardCoding.push(JSON.parse('${building6_2F}'));
			hardCoding.push(JSON.parse('${building6_3F}'));
			hardCoding.push(JSON.parse('${building6_4F}'));
			hardCoding.push(JSON.parse('${building6_5F}'));
			hardCoding.push(JSON.parse('${building6_6F}'));
			hardCoding.push(JSON.parse('${building6_7F}'));
			
			//hardCoding = [];
			//hardCoding.push(JSON.parse('${building7_1F}'));
			//hardCoding.push(JSON.parse('${building7_2F}'));
			//hardCoding.push(JSON.parse('${building7_3F}'));
			//hardCoding.push(JSON.parse('${building7_4F}'));
			//hardCoding.push(JSON.parse('${building7_5F}'));
			//hardCoding.push(JSON.parse('${building7_6F}'));
			//hardCoding.push(JSON.parse('${building7_7F}'));
			
			hardCoding = [];
			hardCoding.push(JSON.parse('${building10_0F}'));
			hardCoding.push(JSON.parse('${building10_1F}'));
			hardCoding.push(JSON.parse('${building10_2F}'));
			hardCoding.push(JSON.parse('${building10_3F}'));
			hardCoding.push(JSON.parse('${building10_4F}'));
			
			hardCoding = [];
			hardCoding.push(JSON.parse('${building11_1F}'));
			hardCoding.push(JSON.parse('${building11_2F}'));
			hardCoding.push(JSON.parse('${building11_3F}'));
			
			hardCoding = [];
			hardCoding.push(JSON.parse('${building12_0F}'));
			hardCoding.push(JSON.parse('${building12_1F}'));
			hardCoding.push(JSON.parse('${building12_2F}'));
			hardCoding.push(JSON.parse('${building12_3F}'));
			hardCoding.push(JSON.parse('${building12_4F}'));
			hardCoding.push(JSON.parse('${building12_5F}'));
			hardCoding.push(JSON.parse('${building12_6F}'));
			hardCoding.push(JSON.parse('${building12_7F}'));
			hardCoding.push(JSON.parse('${building12_8F}'));
			hardCoding.push(JSON.parse('${building12_9F}'));
			hardCoding.push(JSON.parse('${building12_10F}'));
			hardCoding.push(JSON.parse('${building12_11F}'));
			hardCoding.push(JSON.parse('${building12_12F}'));
			hardCoding.push(JSON.parse('${building12_13F}'));
			hardCoding.push(JSON.parse('${building12_14F}'));
			hardCoding.push(JSON.parse('${building12_15F}'));
			 */
			/* 
			$.each(hardCoding, function(index, item){
				myParse(item, index);
			});
			 */
			selectable = JSON.parse(selectable);
			var startingPoint = document.getElementById("startingPoint");
			$.each(selectable, function(key,value){
				$.each(value, function(index, item){
					a = document.createElement("OPTION");
					a.setAttribute("value",key);
					a.innerHTML = item;
					startingPoint.appendChild(a);
				});
			});
			
			var h1 = $("#h1").innerHeight();
			console.log(h1);
			$("#findFullPath").css("height",h1);
			var w1 = $("#mySelect").width() - $("#hs").width()-5;
			$("#startingPoint").css("width",w1);
			$("#destinationPoint").css("width",w1);
			
			var h2 = $(window).height() - $("#header").height();
			$("#ground").css("height",h2);
			$("#firstMap").css("height",h2);
			$("#secondMap").css("height",h2);
			
			var h3 = $("#groundNav").height() * 3;
			$("#ulImg").css("height",h3);
			var w3 = $("#path").width() - $("#ulImg").width()-1;
			$("#groundNav").css("width",w3);
			$("#firstMapNav").css("width",w3);
			$("#secondMapNav").css("width",w3);
			
			$("#ground").show();
			$("#firstMap").hide();
			$("#secondMap").hide();
			
			$("#groundNav").css("color","#343434").css("font-weight","Bold");
			$("#firstMapNav").css("color","#a4a4a4").css("font-weight","");
			$("#secondMapNav").css("color","#a4a4a4").css("font-weight","");
			
			ground = new naver.maps.Map('ground', {
				center : new naver.maps.LatLng(37.4492592, 126.6543461),
				zoom : 12
			});
			metaMap = getMetaMap(ground, false);
			
		   	streetLayer = new naver.maps.StreetLayer();
		    streetLayer.setMap(null);
		    
		    var btn = $('#street');
		    btn.on("click", function(e) {
		        e.preventDefault();

		        if (streetLayer.getMap()) {
		        	naver.maps.Event.clearInstanceListeners(ground);
		        	$("#pano").hide();
		        	$("#ground").css("height",h2);
		            streetLayer.setMap(null);
		        } else {
		        	naver.maps.Event.addListener(ground, 'click', function(e) {
				    	$("#ground").css("height",h2/2);
			        	$("#pano").css("height",h2/2);
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
		        }
		    });
			
			$("#loadingPage").fadeOut(1000);
		}
		
		function myParse(arg, i){
			$.each(arg, function(key,value){
				$.each(value, function(index, item){
					arr.push(item);
					destinationPoints[item] = {buildingName:"building5",
													"floor":i,
													"nodeNum":key};
				});
			});
		}
		
		function myParse2(arg, startFloor, buildingN, o){
			$.each(arg, function(index, item){
				$.each(item, function(key, value){		//key ->nodeNum, value ->selectName
					$.each(value, function(i, item2){	//index, item
						var tmp = []
						tmp.push(key);		//[nodeNum,floor]
						tmp.push(startFloor+index);
						o[buildingN] = {value : tmp};
					});
					
				});
			});
		}
		
		function clearDiv(){
			if(first === false){
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
	<!-- title -->
	<div class="bold mint w" style="text-align: center;" >INHAJIDO</div>
	<!-- select -->
	<div style="padding:5px;height:100%"class="mint">
		<div style="position:absolute;margin-top:5px;right:0;width:29%;height:30px;border-radius:10px;margin-left:5px;margin-right:5px;
					background-color: #a4eedf;display: table;"
			id="findFullPath">
				<div style="display: table-cell;vertical-align: middle;">
					<div style="text-align:center;"><span class="glyphicon glyphicon-search w" aria-hidden="true"></span></div>
					<div style="text-align:center;"class="bold w">SEARCH</div>
				</div>
			</div>
		<div id="h1">
		<div style="padding:5px;width:70%;margin:5px;border-radius:10px;"class="white"id="mySelect">
			<span id="hs" class="bold">출발 지점 : </span>
			<select style="background-color:white;font-size:20px;"id="startingPoint"></select>
			<!-- <input style="width:0;"> -->
		</div>
		<div style="padding:5px;right:0;width:70%;margin:5px;border-radius:10px;"class="white">
			<span class="bold">도착 지점  : </span>
			<div class="autocomplete">
			<input id="destinationPoint" type = "text">
			</div>
		</div>
		</div>
	</div>
	<div id="path">
	<!-- path -->
		<img style="float:left;"src="./resources/ul.jpg"id="ulImg">
		<div style="display:inline-block;width:60%;" id="groundNav" class="mapNav">&nbsp</div>
		<div style="display:inline-block;width:60%;" id="firstMapNav" class="mapNav">&nbsp</div>
		<div style="display:inline-block;width:60%;" id="secondMapNav" class="mapNav">&nbsp</div>
	</div>
</div>
<!-- map -->
<div id="ground" style="border: 1px solid black;  width: 100%;">
	<input id="street" type="button" style="position:absolute;z-index:999;padding:5px;" value="거리뷰" />
</div>
<div id="firstMap" style="border: 1px solid white; height: 1000px; width: 100%;" ></div>
<div id="secondMap" style="border: 1px solid white; height: 1000px; width: 100%;"></div>
<div id="pano"></div>
<div id="fotter">
<h1>FOOTER INFO</h1>
</div>
</body>
</html>