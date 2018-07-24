<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>지도112a3</title>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=nVEUh5PrMsL3BXJq_8Pl&submodules=geocoder"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>
<script>
	window.onload = function() {
		//지도 그리기
		var map = new naver.maps.Map('map', {
			center : new naver.maps.LatLng(37.451001, 126.656370),
			zoom : 12
		});
		
		var i = 0;
		var markers = [];
		var polylines = [];
		var nodes = {};			//format : {"0":{"y":37.4515427,"_lat":37.4515427,"x":126.6564996,"_lng":126.6564996},}
		var graph = [];			//format : [[0,1,33700],[1,2,9236]]
		var selectableNode = [];//출발지나 목적지가 될 수 있는 노드
		var vertexAmount = 0; 	//정점의 총 갯수
		
		var flag = true;		//polyline 생성에 쓰인다.
		var prevX = 0;		
		var prevY = 0;
		var path;
		var pl;

		//클릭하면 마커 생상
		naver.maps.Event.addListener(map, 'click', function(e) {
			nodes[i.toString()] = e.coord;
			var marker = new naver.maps.Marker({
				position : e.coord,
				map : map,
				title : i,
				name : i++
			});
			vertexAmount++;
			markers.push(marker);
			
			//두 마커를 클릭하면 라인이 그려진다.
			naver.maps.Event.addListener(marker, 'click', function(e) {
				if (flag) {
					pl = new naver.maps.Polyline({
						map : map,
						path : [],
						strokeColor : '#5347AA',
						strokeWeight : 4
					});
					path = pl.getPath();
					polylines.push(pl);
					path.push(e.overlay.getPosition());

					//그래프 생성 1
					prevNode = e.overlay.name;
					prevX = e.overlay.position.x;
					prevY = e.overlay.position.y;
				} else {
					path.push(e.overlay.getPosition());
					
					//피타고라스
					var distance = Math.pow(prevX*100000 - e.overlay.position.x*100000, 2) + Math.pow(prevY*100000 - e.overlay.position.y*100000, 2);
					distance = Math.sqrt(distance);
					distance = Math.floor(distance);
					
					//그래프 생성2
					graph.push([ prevNode, e.overlay.name, distance ]);
				}
				flag = !flag;
			});

			//마커를 우클릭 -> 도착지 or 출발지로 지정할 수 있다.
			naver.maps.Event.addListener(marker, 'rightclick', function(e) {
				var icon = {
			            url: './resources/j.png',
			            size: new naver.maps.Size(24, 37),
			            anchor: new naver.maps.Point(12, 37),
			            origin: new naver.maps.Point(0, 0)
			        }
				e.overlay.setIcon(icon);
				selectableNode.push(e.overlay.name);
			});
			
			//우클릭 -> 마커의 제거
			naver.maps.Event.addListener(marker, 'dblclick', function(e) {
				var deleteTarget = e.overlay.name;
				var index = 0;
				console.log(markers);
				while(true){
					if(markers[i]['name']===deleteTarget){
						markers[i].setMap(null);
						markers.splice(index,1);
						index--;
					}
					index++;
					if(index === markers.length){
						break;
					}
				}
				
				for (var i = 0, ii = polylines.length; i < ii; i++) {
					polylines[i].setMap(null);
				}
				polylines = [];
				
				var deleteTarget = e.overlay.name;
				delete nodes[deleteTarget];
				
				var index = 0;
				while(true){
					if(graph[index][0] === deleteTarget || graph[index][1] === deleteTarget){
						graph.splice(index,1);
						index--;
					}
					
					index++;
					if(index === graph.length){
						break;
					}
				}
				
				$.each(nodes, function(key, value) {
					var marker = new naver.maps.Marker({
						position : value,
						map : map,
						title : key,
						name : key
					});
				});
				
				for(var i = 0, ii = graph.length; i < ii; i++){
					var pl = new naver.maps.Polyline({
						map : map,
						path : [],
						strokeColor : '#5347AA',
						strokeWeight : 4
					});
					var path = pl.getPath();
					path.push(nodes[graph[i][0]]);
					path.push(nodes[graph[i][1]]);
					polylines.push(pl);
				}
			});

		});

		//esc를 누르면 전부 닫는다.
		naver.maps.Event
				.addListener(
						map,
						'keydown',
						function(e) {
							var keyboardEvent = e.keyboardEvent, keyCode = keyboardEvent.keyCode
									|| keyboardEvent.which;

							var ESC = 27;

							if (keyCode === ESC) {
								keyboardEvent.preventDefault();

								for (var i = 0, ii = markers.length; i < ii; i++) {
									markers[i].setMap(null);
								}
								for (var i = 0, ii = polylines.length; i < ii; i++) {
									polylines[i].setMap(null);
								}
								markers = [];
								polylines = [];
							}
						});

		var btn = document.getElementById("printNode");
		btn.addEventListener("click", function() {
			console.log("nodes : ")
			console.log(nodes);
			console.log("selectableNode : ")
			console.log(selectableNode);
			console.log("graph : ")
			console.log(graph);
		});

		var button = document.getElementById("createNode");
		button.addEventListener("click", function() {
			var node = prompt();
			var p = JSON.parse(node);
			$.each(p, function(key, value) {
				console.log(key + " " + value);
				new naver.maps.Marker({
					position : value,
					map : map,
					name : key
				});
			});

			var graph = JSON.parse(prompt());
			$.each(graph, function(index, item) {
				var pl = new naver.maps.Polyline({
					map : map,
					path : [],
					strokeColor : '#5347AA',
					strokeWeight : 4
				});
				polylines.push(pl);
				path = pl.getPath();
				path.push(p[item[0]]);
				path.push(p[item[1]]);
			});
		})
	
		var bestLine = new naver.maps.Polyline();
		var findPath = document.getElementById("findPath");
		findPath.addEventListener("click", function() {
			$.ajax({
				url : "/map/dijkstra",
				type : "post",
				data : "json=" + JSON.stringify(graph) + 
					   "&nodeAmount=" + String(Object.keys(nodes).length) +
					   "&startingPoint=" + $("#startingPoint").val() +
					   "&destinationPoint=" + $("#destinationPoint").val(),
				success : function(result) {
					var parsedResult = JSON.parse(result);
					bestLine.setMap(null);
					bestLine = new naver.maps.Polyline({
						map : map,
						path : [],
						strokeColor : '#AA0000',
						strokeWeight : 4
					});
					var bestPath = bestLine.getPath();
					for (var i = 0; i < parsedResult.length; i++) {
						bestPath.push(nodes[parsedResult[i]]);
					}
					
				}
			}); 
		});
		
		var endOfSetting = document.getElementById("endOfSetting");
		endOfSetting.addEventListener("click", function() {
			$("#selectableList").text("list : ");
			$.each(selectableNode, function(index, item) {
				$("#selectableList").append(item + ", ");
			});
		});
	};
</script>
<body id="body">
	<div id="map"
		style="border: 1px solid black; height: 500px; width: 500px;"></div>

</body>
<button id="printNode">printNode</button>
<button id="createNode">create Node</button>
<button id="endOfSetting">endOfSetting</button>
<div id="selectableList"></div>
<div>
출발지 : <input id="startingPoint" type="text">
도착지 : <input id="destinationPoint" type="text">
<button id="findPath">findPath</button>
</div>
</html>