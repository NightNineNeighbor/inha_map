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
		sayHello();
		
		
		var map;
		makeCustomMap(map, "hak_1.jpg", "map1");
		var metaMap = getMetaMap(map);
		
		
		naver.maps.Event.addListener(map, 'click', function(e) {
			makeMarker(metaMap.nextMarkerName++, e.coord, metaMap);
		});
		
		document.getElementById("saveNode").addEventListener("click",function() {
			printInfo("printInfo", metaMap);
		});
		
		document.getElementById("loadNode").addEventListener("click",function() {
			loadNode($("#nodesInfo").val(), $("#graphInfo").val(), $("#selectableInfo").val(), metaMap)
		})
		
		document.getElementById("save").addEventListener("click",function() {
			console.log("save");
			ajaxSaveGraphAndNodes($("#saveId").val(), metaMap)
		});
		
		function ajaxSaveGraphAndNodes(id, m){
			$.ajax({
				url : "/map/saveGraphAndNodes",
				type : "post",
				data : "id=" + id + 
						"&nodes=" + JSON.stringify(m.nodes) + 
						"&graph=" + JSON.stringify(m.graph) +
						"&selectableNodes=" + JSON.stringify(m.selectableNode),
				success : function(result) {
				}
				
			});
		}
		
		document.getElementById("load").addEventListener("click",function() {
			printInfo("one", metaMap);
			ajaxLoadGraphAndNodes($("#loadId").val(), metaMap)
		});
		
		function ajaxLoadGraphAndNodes(id, m){
			$.ajax({
				url : "/map/loadGraphAndNodes",
				type : "post",
				data : "id=" + id,
				success : function(result) {
					var info = JSON.parse(result);
					console.log(info);
					console.log(info.graph);
					console.log(JSON.parse(info.graph));
					loadNode(info.nodes, info.graph, info.selectableNodes, m);
					printInfo("two", metaMap);
				}
				
			});
		}
		
	};
</script>
<body id="body">
	<h1>${uploadedFile }</h1>

	<div id="map1" style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<div>
	save ID : <input type="text" id="saveId"><button id="save">save</button>
	</div>
	<div>
	load ID : <input type="text" id="loadId"><button id="load">load</button>
	</div>
	<div id = "one"></div>
	<div id = "two"></div>
	nodesInfo :
	<input id="nodesInfo" type="text">
	<br> graphInfo :
	<input id="graphInfo" type="text">
	<br> selectableInfo :
	<input id="selectableInfo" type="text">
	<br>
	<button id="loadNode">loadNode</button>
	<button id="saveNode">saveNode</button>
	<div id="printInfo"></div>
	
</body>
</html>