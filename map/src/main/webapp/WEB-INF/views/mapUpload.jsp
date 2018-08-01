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
		var map;
		makeCustomMap();
		
		var nextMarkerName = 0;
		var markers = {};
		var polylines = [];
		var nodes = {}; //format : {"0":{"y":37.4515427,"_lat":37.4515427,"x":126.6564996,"_lng":126.6564996},}
		var graph = []; //format : [[0,1,33700],[1,2,9236]]
		var selectableNode = {};//출발지나 목적지가 될 수 있는 노드
		
		naver.maps.Event.addListener(map, 'click', function(e) {
			makeMarker(nextMarkerName, e.coord);
			nextMarkerName++;
		});

		function makeMarker(name, position) { //마커 생성
			console.log(position);
			console.log(name);
			nodes[name] = position;
			var marker = new naver.maps.Marker({
				position : position,
				map : map,
				title : name,
				name : name
			});
			console.log(marker);
			markers[name] = marker;

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
					var distance = Math.pow(prevX * 100000
							- e.overlay.position.x * 100000, 2)
							+ Math.pow(prevY * 100000 - e.overlay.position.y
									* 100000, 2);
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
					url : './resources/j.png',
					size : new naver.maps.Size(24, 37),
					anchor : new naver.maps.Point(12, 37),
					origin : new naver.maps.Point(0, 0)
				}
				e.overlay.setIcon(icon);
				selectableNode[e.overlay.name] = prompt();
			});

			//더블클릭 -> 마커의 제거
			naver.maps.Event.addListener(marker, 'dblclick', function(e) {
				var deleteTarget = e.overlay.name;

				markers[deleteTarget].setMap(null); //마커 삭제
				delete markers[deleteTarget];

				delete nodes[deleteTarget]; //node 삭제

				delete selectableNode[deleteTarget];

				var index = 0; //해당 graph 삭제
				while (true && graph.length !== 0) {
					if (graph[index][0] === deleteTarget
							|| graph[index][1] === deleteTarget) {
						graph.splice(index, 1);
						index--;
					}

					index++;
					if (index === graph.length) {
						break;
					}
				}

				for (var i = 0, ii = polylines.length; i < ii; i++) { //polyline 모두 삭제
					polylines[i].setMap(null);
				}
				polylines = [];

				for (var i = 0, ii = graph.length; i < ii; i++) { //graph 를 기준으로 polyline 다시 생성
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

		}

		//빌딩 그리기
		function makeCustomMap() {
			var HOME_PATH = './resources';

			var tileSize = new naver.maps.Size(500, 500),
			
				proj = {
					fromCoordToPoint : function(coord) {
						var pcoord = coord.clone();

						if (coord instanceof naver.maps.LatLng) {
							pcoord = new naver.maps.Point(coord.lng(), coord.lat());
						}

						return pcoord.div(tileSize.width, tileSize.height);
					},

					fromPointToCoord : function(point) {
						return point.clone().mul(tileSize.width, tileSize.height);
					}
				},
				
				getMapType = function(floor) {
					var commonOptions = {
						name : '',
						minZoom : 0,
						maxZoom : 0,
						tileSize : tileSize,
						projection : proj,
						repeatX : false,
						tileSet : '',
						vendor : '\xa9 NAVER Corp.',
						uid : ''
					},
					mapTypeOptions = $.extend({}, commonOptions, {
						name : floor,
						tileSet : HOME_PATH	+ '/hak_1.jpg',
						uid : 'naver:greenfactory:' + floor
					});
					console.log("mapTypeOptions")
					console.log(mapTypeOptions);

				return new naver.maps.ImageMapType(mapTypeOptions);
				};

			map = new naver.maps.Map('map', {
				center : new naver.maps.Point(128, 128),
				zoom : 2,
				background : '#FFFFFF',
				mapTypes : new naver.maps.MapTypeRegistry({
					'+1F' : getMapType('1F'),
					'+2F' : getMapType('2F'),
					'+4F' : getMapType('4F'),
					'+5F' : getMapType('5F'),
				}),
				mapTypeId : '+1F',
				mapTypeControl : true,
				mapTypeControlOptions : {
					mapTypeIds : [ '+1F', '+2F', '+4F', '+5F' ],
					position : naver.maps.Position.BOTTOM_CENTER,
					style : naver.maps.MapTypeControlStyle.BUTTON
				},
				zoomControl : true,
				zoomControlOptions : {
					position : naver.maps.Position.TOP_RIGHT
				}
			});
		}
	};
</script>
<body id="body">
	<h1>${uploadedFile }</h1>

	<div id="map"
		style="border: 1px solid black; height: 500px; width: 500px;"></div>
</body>
</html>