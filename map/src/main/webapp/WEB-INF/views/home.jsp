<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>지도111aa3</title>
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

		var flag = true;
		var i = 0;
		var markerList = [];
		var pathList = [];
		var nodeList = {};
		var graph = new Array();
		var something = {};
		var vertexAmount = 0; //정점의 총 갯수
		var map;

		var pl = new naver.maps.Polyline({
			map : map,
			path : [],
			strokeColor : '#5347AA',
			strokeWeight : 4
		});
		pathList.push(pl);
		path = pl.getPath();
		path.push({
			y : 37.451805,
			_lat : 37.451805,
			x : 126.656621,
			_lng : 126.656621
		});
		path.push({
			y : 37.4499395,
			_lat : 37.4499395,
			x : 126.6579308,
			_lng : 126.6579308
		});
		console.log(pathList);

		//클릭하면 마커 생상
		var prevX = 0;
		var prevY = 0;
		naver.maps.Event.addListener(map, 'click', function(e) {
			nodeList[i.toString()] = e.coord;
			var marker = new naver.maps.Marker({
				position : e.coord,
				map : map,
				name : i++
			});
			vertexAmount++;
			markerList.push(marker);

			//두 마커를 클릭하면 라인이 그려진다.

			naver.maps.Event.addListener(marker, 'click', function(e) {
				if (flag) {
					var pl = new naver.maps.Polyline({
						map : map,
						path : [],
						strokeColor : '#5347AA',
						strokeWeight : 4
					});
					path = pl.getPath();
					pathList.push(pl);

					prevNode = e.overlay.name;
					var x = e.overlay.position.x;
					var y = e.overlay.position.y;
					prevX = Math.floor((x - Math.floor(x)) * 100000);
					prevY = Math.floor((y - Math.floor(y)) * 100000);
					path.push(e.overlay.getPosition());
				} else {
					path.push(e.overlay.getPosition());
					var x = e.overlay.position.x;
					var y = e.overlay.position.y;
					x = Math.floor((x - Math.floor(x)) * 100000);
					y = Math.floor((y - Math.floor(y)) * 100000);
					var distance = 0;
					distance = Math.pow(prevX - x, 2) + Math.pow(prevY - y, 2);
					graph.push([ prevNode, e.overlay.name, distance ]);
				}
				flag = !flag;
			});

			//마커를 더블클릭하면 마커를 바꾼다.
			naver.maps.Event.addListener(marker, 'dblclick', function(e) {
				e.overlay.setIcon("./resources/i.png");
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

								for (var i = 0, ii = markerList.length; i < ii; i++) {
									markerList[i].setMap(null);
								}
								for (var i = 0, ii = pathList.length; i < ii; i++) {
									pathList[i].setMap(null);
								}
								markerList = [];
								pathList = [];
							}
						});

		var node = document.getElementById("node");
		var btn = document.getElementById("printNode");
		btn.addEventListener("click", function() {
			console.log(JSON.stringify(nodeList));
			console.log(JSON.stringify(graph));
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
				pathList.push(pl);
				path = pl.getPath();
				path.push(p[item[0]]);
				path.push(p[item[1]]);
			});
		})

		var ajaxButton = document.getElementById("ajax");
		ajaxButton.addEventListener("click", function() {
			console.log(vertexAmount);
			console.log(JSON.stringify(graph));
			$.ajax({
				url : "/map/dijkstra",
				type : "post",
				data : "json=" + JSON.stringify(graph) + "&vertexAmount="
						+ vertexAmount,
				success : function(result) {
					map = JSON.parse(result);
					console.log(result);
					console.log(map);
					for (var i = 0, ii = markerList.length; i < ii; i++) {
						markerList[i].setMap(null);
					}
					for (var i = 0, ii = pathList.length; i < ii; i++) {
						pathList[i].setMap(null);
					}
					markerList = [];
					pathList = [];
				}
			});
		});

		var two = document.getElementById("2");
		two.addEventListener("click", function() {
			var pl = new naver.maps.Polyline({
				map : map,
				path : [],
				strokeColor : '#5347AA',
				strokeWeight : 4
			});
			for (var i = 0; i < (map[2].length) - 1; i++) {
				path = pl.getPath();
				path.push(nodeList[map[2][i]]);
				path.push(nodeList[map[2][i+1]]);
				console.log(map[2][i]);
				console.log(map[2][i+1])
			}
		});

		var tt = document.getElementById("tt");
		tt.addEventListener("click", function() {
			var pl = new naver.maps.Polyline({
				map : map,
				path : [],
				strokeColor : '#5347AA',
				strokeWeight : 4
			});
			pathList.push(pl);
			path = pl.getPath();
			path.push(nodeList[0]);
			path.push(nodeList[1]);
			console.log("tt");
			console.log(nodeList[0]);
			console.log(nodeList[1]);

		});

	};
</script>
<body id="body">
	<div id="map"
		style="border: 1px solid black; height: 500px; width: 500px;"></div>

</body>
<button id="printNode">printNode</button>
<div id="node"></div>
<button id="createNode">create Node</button>
<button id="ajax">ajax</button>
<button id="2">2</button>
<button id="tt">tt</button>
</html>