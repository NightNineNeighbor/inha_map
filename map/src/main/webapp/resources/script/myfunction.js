function sayHello(){
	console.log("hello world!!");
}

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

function printInfo(targetName, m){
	console.log("nodes : ")
	console.log(m.nodes);
	console.log("graph : ")
	console.log(m.graph);
	console.log("selectableNode : ")
	console.log(m.selectableNode);
	$("#" + targetName).text("");
	$("#" + targetName).append("node </br>");
	$("#" + targetName).append(JSON.stringify(m.nodes));
	$("#" + targetName).append("</br>graph </br>");
	$("#" + targetName).append(JSON.stringify(m.graph))
	$("#" + targetName).append("</br>selectableNode </br>");
	$("#" + targetName).append(JSON.stringify(m.selectableNode))
}

function ajaxFindPath(startingPoint, destinationPoint, m){
	$.ajax({
		url : "/map/dijkstra",
		type : "post",
		data : "json=" + JSON.stringify(m.graph) + 
				"&nodeAmount=" + String(Object.keys(m.nodes).length) + 
				"&startingPoint=" + startingPoint +
				"&destinationPoint=" + destinationPoint,
		success : function(result) {
			var parsedResult = JSON.parse(result);
			m.bestLine.setMap(null);
			m.bestLine = new naver.maps.Polyline({
				map : m.map,
				path : [],
				strokeColor : '#AA0000',
				strokeWeight : 4
			});
			var bestPath = m.bestLine.getPath();
			for (var i = 0; i < parsedResult.length; i++) {
				bestPath.push(m.nodes[parsedResult[i]]);
			}
		}
	});
}

function ajaxFullFindPath(startingPoint, buildingName, destinationPoint, m1, m2, m3){
	$.ajax({
		url : "/map/findpath",
		type : "post",
		data : 	"startingPoint=" + startingPoint +
				"&buildingName=" + buildingName +
				"&destinationPoint=" + destinationPoint,
		success : function(result) {
			var parsedResult = JSON.parse(result);
			console.log(parsedResult);
			
			m1.nodes = JSON.parse(parsedResult['ground_Nodes']);
			var ground_Paths = parsedResult['ground_Paths'];
			m1.bestLine.setMap(null);
			m1.bestLine = new naver.maps.Polyline({
				map : m1.map,
				path : [],
				strokeColor : '#AA0000',
				strokeWeight : 4
			});
			var bestPath = m1.bestLine.getPath();
			for (var i = 0; i < ground_Paths.length; i++) {
				bestPath.push(m1.nodes[ground_Paths[i]]);
			}
			console.log(m1);
			
			m2.nodes = JSON.parse(parsedResult['building_1F_Nodes']);
			var building_1F_Paths = parsedResult['building_1F_Paths'];
			m2.bestLine.setMap(null);
			m2.bestLine = new naver.maps.Polyline({
				map : m2.map,
				path : [],
				strokeColor : '#AA0000',
				strokeWeight : 4
			});
			var bestPath = m2.bestLine.getPath();
			for (var i = 0; i < building_1F_Paths.length; i++) {
				bestPath.push(
					new naver.maps.Point(m2.nodes[building_1F_Paths[i]].x , m2.nodes[building_1F_Paths[i]].y));
			}
			
			m3.nodes = JSON.parse(parsedResult['building_2F_Nodes']);
			var building_2F_Paths = parsedResult['building_2F_Paths'];
			m3.bestLine.setMap(null);
			m3.bestLine = new naver.maps.Polyline({
				map : m3.map,
				path : [],
				strokeColor : '#AA0000',
				strokeWeight : 4
			});
			var bestPath = m3.bestLine.getPath();
			console.log("DEBUG");
			for (var i = 0; i < building_2F_Paths.length; i++) {
				console.log(i + " : " +new naver.maps.Point(m3.nodes[building_2F_Paths[i]].x , m3.nodes[building_2F_Paths[i]].y));
				bestPath.push(
					new naver.maps.Point(m3.nodes[building_2F_Paths[i]].x , m3.nodes[building_2F_Paths[i]].y));
			}
		}
	});
}

function showSelectableList( targetName , m ){
	$("#" + targetName).text("");
	$.each(m.selectableNode, function(key, value) {
		$("#" + targetName).append("[ " + key + ", " + value + " ] ");
	});
}

function mapToggle(m){
	if (m.markers[0].map === m.map) {
		toggleGraphNode(null, m);
	} else {
		toggleGraphNode(m.map, m);
	}
}

function toggleGraphNode(param, m) {
	$.each(m.markers, function(key, value) {
		value.setMap(param);
	})
	for (var i = 0, ii = m.polylines.length; i < ii; i++) { //polyline 모두 삭제
		m.polylines[i].setMap(param);
	}
}

function makeMarker(name, position, m) { //마커 생성
	m.nodes[name] = position;
	var marker = new naver.maps.Marker({
		position : position,
		map : m.map,
		title : name,
		name : name
	});
	m.markers[name] = marker;
	
	//두 마커를 클릭하면 라인이 그려진다.
	naver.maps.Event.addListener(marker, 'click', function(e) {
		if (m.flag) {
			m.pl = new naver.maps.Polyline({
				map : m.map,
				path : [],
				strokeColor : '#5347AA',
				strokeWeight : 4
			});
			m.path = m.pl.getPath();
			m.polylines.push(m.pl);
			m.path.push(e.overlay.getPosition());

			//그래프 생성 1
			m.prevNode = e.overlay.name;
			m.prevX = e.overlay.position.x;
			m.prevY = e.overlay.position.y;
		} else {
			m.path.push(e.overlay.getPosition());
			
				//피타고라스
			var distance = Math.pow(m.prevX * 100000
					- e.overlay.position.x * 100000, 2)
					+ Math.pow(m.prevY * 100000 - e.overlay.position.y
							* 100000, 2);
			distance = Math.sqrt(distance);
			distance = Math.floor(distance);
				//그래프 생성2
			m.graph.push([ m.prevNode, e.overlay.name, distance ]);
		}
		m.flag = !m.flag;
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
		m.selectableNode[e.overlay.name] = prompt();
	});

	//더블클릭 -> 마커의 제거
	naver.maps.Event.addListener(marker, 'dblclick', function(e) {
		var deleteTarget = e.overlay.name;
		
		m.markers[deleteTarget].setMap(null); //마커 삭제
		delete m.markers[deleteTarget];

		delete m.nodes[deleteTarget]; //node 삭제

		delete m.selectableNode[deleteTarget];

		var index = 0; //해당 graph 삭제
		var length = m.graph.length;
		while (true && length !== 0) {	//TODO
			if (m.graph[index][0] == deleteTarget || m.graph[index][1] == deleteTarget) {
				m.graph.splice(index, 1);
				index--;
				length--;
			}

			index++;
			if (index === length) {
				break;
			}
		}

		for (var i = 0, ii = m.polylines.length; i < ii; i++) { //polyline 모두 삭제
			m.polylines[i].setMap(null);
		}
		m.polylines = [];

		for (var i = 0, ii = m.graph.length; i < ii; i++) { //graph 를 기준으로 polyline 다시 생성
			var pl = new naver.maps.Polyline({
				map : m.map,
				path : [],
				strokeColor : '#5347AA',
				strokeWeight : 4
			});
			var path = pl.getPath();
			
			path.push(m.nodes[m.graph[i][0]]);
			path.push(m.nodes[m.graph[i][1]]);
			m.polylines.push(pl);
		}
	});
}

function loadNode(nodesInfo, graphInfo, selectableInfo, m) {
	$.each(m.markers, function(key, value) {
		value.setMap(null);
	});
	m.markers = {};
	for (var i = 0, ii = m.polylines.length; i < ii; i++) { //polyline 모두 삭제
		m.polylines[i].setMap(null);
	}
	m.polylines = [];

	m.nodes = JSON.parse(nodesInfo);
	m.nextMarkerName = -1;
	$.each(m.nodes, function(key, value) {
		makeMarker(key, value, m);
		m.nextMarkerName = Math.max(m.nextMarkerName, key);
	});
	m.nextMarkerName++;
	
	m.selectableNode = JSON.parse(selectableInfo) 
	$.each(m.selectableNode, function(key, values) {
		var icon = {
			url : './resources/j.png',
			size : new naver.maps.Size(24, 37),
			anchor : new naver.maps.Point(12, 37),
			origin : new naver.maps.Point(0, 0)
		}
		m.markers[key].setIcon(icon);
	})

	m.graph = JSON.parse(graphInfo);
	$.each(m.graph, function(index, item) {
		var pl = new naver.maps.Polyline({
			map : m.map,
			path : [],
			strokeColor : '#5347AA',
			strokeWeight : 4
		});
		m.polylines.push(pl);
		path = pl.getPath();
		//path.push(m.nodes[item[0]]);
		//path.push(m.nodes[item[1]]);
		path.push(new naver.maps.Point(m.nodes[item[0]].x , m.nodes[item[0]].y) );
		path.push(new naver.maps.Point(m.nodes[item[1]].x , m.nodes[item[1]].y) );
	});
}

//빌딩 그리기
function makeBuilding(controlObject,targetDiv) {
	var HOME_PATH = './resources';
	var tileSize = new naver.maps.Size(256, 256),
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
			maxZoom : 4,
			tileSize : tileSize,
			projection : proj,
			repeatX : false,
			tileSet : '',
			vendor : '\xa9 NAVER Corp.',
			uid : ''
		}, 
		mapTypeOptions = $.extend({}, commonOptions, {
			name : floor,
			tileSet : HOME_PATH
					+ '/tiles/gf-{floor}/{z}/{x}-{y}.png'.replace(
							'{floor}', floor.toLowerCase()),
			uid : 'naver:greenfactory:' + floor
		});

		return new naver.maps.ImageMapType(mapTypeOptions);
	};

	controlObject = new naver.maps.Map(targetDiv, {
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

function makeCustomMap(controlObject, fileName, targetDiv) {
	console.log("makeCustmoMap1");
	var imgPath = './resources/' + fileName;

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
			},
			mapTypeOptions = $.extend({}, commonOptions, {
				name : floor,
				tileSet : imgPath,
			});

		return new naver.maps.ImageMapType(mapTypeOptions);
		};

	return new naver.maps.Map(targetDiv, {
		center : new naver.maps.Point(250, 250),
		zoom : 0,
		background : '#FFFFFF',
		mapTypes : new naver.maps.MapTypeRegistry({
			'default' : getMapType()}),
		mapTypeId : 'default'
	});
}

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

function ajaxLoadGraphAndNodes(id, m){
	$.ajax({
		url : "/map/loadGraphAndNodes",
		type : "post",
		data : "id=" + id,
		success : function(result) {
			var info = JSON.parse(result);
			loadNode(info.nodes, info.graph, info.selectableNodes, m);
		}
		
	});
}




