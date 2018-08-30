function sayHello(){
	console.log("hello world!!!");
}

function getMetaMap(map, isBuilding){
	var object = {};
	object["map"] = map;
	object["nextMarkerName"] = 0;
	object["nodes"] = {};			//format : {"0":{"y":37.4515427,"_lat":37.4515427,"x":126.6564996,"_lng":126.6564996},}
	object["graph"] = [];			//format : [[0,1,33700],[1,2,9236]]
	object["markers"] = {};
	object["circles"] = {};
	object["polylines"] = [];
	object["selectableNode"] = {};
	object["stairs"] = [];
	object["elevators"] = [];
	object["bestLine"] = new naver.maps.Polyline();
	object["flag"] = true;
	object["prevNode"] = 0;
	object["prevX"] = 0;
	object["prevY"] = 0;
	object["path"] = {};
	object["pl"] = {};
	object["isBuilding"] = isBuilding;
	return object
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
	$("#" + targetName).append("</br>stairs </br>");
	$("#" + targetName).append(JSON.stringify(m.stairs))
	$("#" + targetName).append("</br>elevators </br>");
	$("#" + targetName).append(JSON.stringify(m.elevators))
}

function ajaxFindPath(startingPoint, destinationPoint, m){
	$.ajax({
		url : "./dijkstra",
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

function ajaxFullFindPath(startingPoint, startingPointName, buildingName, floor, destinationPoint, destination, m1, m2, m3){
	$.ajax({
		url : "./findpath",
		type : "post",
		data : 	"startingPoint=" + startingPoint +
				"&buildingName=" + buildingName +
				"&floor=" + floor +
				"&destinationPoint=" + destinationPoint,
		success : function(result) {
			var parsedResult = JSON.parse(result);
			
			var groundNodes = JSON.parse(parsedResult['ground_Nodes'])
			m1.map.setCenter(groundNodes[startingPoint])
			drawPath(groundNodes ,parsedResult['ground_Paths'], "도착" ,m1)
			
			var msg = destination;
			if(parsedResult['mapAmount']==="3"){
				msg = floor + "층으로";
				m3 = getMetaMap(makeCustomMap(buildingName, floor, "secondMap"), true);
				drawPath(JSON.parse(parsedResult['secondNodes']), 
						 parsedResult['secondPaths'], 
						 destination,
						 m3);
				var centerPosition = parsedResult['secondPaths'][0]
				m3.map.setCenter(JSON.parse(parsedResult['secondNodes'])[centerPosition]);
			}
			
			
			m2 = getMetaMap(makeCustomMap(buildingName, 1, "firstMap"), true);
			drawPath(JSON.parse(parsedResult['firstNodes']),
					 parsedResult['firstPaths'],
					 msg,
					 m2);
			var centerPosition = parsedResult['firstPaths'][0]
			m2.map.setCenter(JSON.parse(parsedResult['firstNodes'])[centerPosition]);
			
			$("#groundNav").html("&nbsp");
			$("#firstMapNav").html("&nbsp");
			$("#secondMapNav").html("&nbsp");
			$("#groundNav").text(startingPointName +"에서 " + buildingName + "으로");
			$("#firstMapNav").text( buildingName+ "입구에서 " + msg);
			if(parsedResult['mapAmount']==="3"){
				$("#secondMapNav").text( floor+ "층에서 " + destination + "으로");
			}
			$("#ground").show();
			$("#firstMap").hide();
			$("#secondMap").hide();
		}
	});
}

function drawPath(nodes, path, message, m){
	m.nodes = nodes;
	$.each(m.circles ,function(key, value){
		value.setMap(null);
	});
	m.bestLine.setMap(null);
	m.bestLine = new naver.maps.Polyline({
		map : m.map,
		path : [],
		strokeColor : '#5ce7bd',
		strokeWeight : 4
	});
	var bestPath = m.bestLine.getPath();
	for (var i = 0; i < path.length; i++) {
		bestPath.push(
				new naver.maps.Point(m.nodes[path[i]].x , m.nodes[path[i]].y));
	}
	m.circles[path[0]] = makeCircle(path[0], m);
	m.circles[path[path.length-1]] = makeCircle(path[path.length-1], m);
}

function makeHtmlIcon(message, position, m){
	new naver.maps.Marker({
	    position: position,
	    map: m.map,
	    title: message,
	    icon: {
	        content:'<div style="background-color:white;border: 1px solid black;">'+message+'</div>',
	        size: new naver.maps.Size(22, 35),
	        anchor: new naver.maps.Point(11, 30)
	    }
	});
}

function showSelectableList( targetName , m ){
	$("#" + targetName).text("");
	$.each(m.selectableNode, function(key, value) {
		$("#" + targetName).append("[ " + key + ", " + value + " ] ");
	});
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
			
			var factor;
			if(m.isBuilding){
				factor = 1;
			}else{
				factor = 100000;
			}
			
				//피타고라스
			var distance = Math.pow(m.prevX * factor
					- e.overlay.position.x * factor, 2)
					+ Math.pow(m.prevY * factor - e.overlay.position.y
							* factor, 2);
			distance = Math.sqrt(distance);
			distance = Math.floor(distance);
				//그래프 생성2
			m.graph.push([ m.prevNode, e.overlay.name, distance ]);
		}
		m.flag = !m.flag;
	});

	//마커를 우클릭 -> 도착지 or 출발지로 지정할 수 있다.
	naver.maps.Event.addListener(marker, 'rightclick', function(e) {
		var name = prompt();
		if(name.substring(0,2) === "계단"){
			name = name + m.stairs.length;
			m.stairs.push(e.overlay.name);
		}else if(name.substring(0,5) === "엘레베이터"){
			name = name + m.elevators.length;
			m.elevators.push(e.overlay.name);
		}else{
			if(m.selectableNode[e.overlay.name] === undefined){
				m.selectableNode[e.overlay.name] = Array(name);
			}else{
				m.selectableNode[e.overlay.name].push(name);
			}
		}
		e.overlay.setIcon(getHtmlIcon(name));
		m.circles[e.overlay.name] = makeCircle(e.overlay.name, m);
	});

	//더블클릭 -> 마커의 제거
	naver.maps.Event.addListener(marker, 'dblclick', function(e) {
		var deleteTarget = e.overlay.name;
		
		m.markers[deleteTarget].setMap(null); //마커 삭제
		delete m.markers[deleteTarget];

		delete m.nodes[deleteTarget]; //node 삭제

		if(m.selectableNode[deleteTarget] !==undefined){
			m.circles[deleteTarget].setMap(null);
			delete m.circles[deleteTarget];
			delete m.selectableNode[deleteTarget];
		}
		while( m.stairs.includes(deleteTarget) ){
			var i = m.stairs.indexOf(deleteTarget);
			m.stairs.splice(i,1);
			m.circles[deleteTarget].setMap(null);
			delete m.circles[deleteTarget];
		}
		while( m.elevators.includes(deleteTarget) ){
			var i = m.stairs.indexOf(deleteTarget);
			m.elevators.splice(i,1);
			m.circles[deleteTarget].setMap(null);
			delete m.circles[deleteTarget];
		}

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

function loadNode(nodesInfo, graphInfo, selectableInfo, stairs, elevators,  m) {
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
		makeCircle(key, m);
		m.markers[key].setIcon(getHtmlIcon(values));
		m.markers[key].setZIndex(100);
	})
	
	m.stairs = JSON.parse(stairs);
	console.log(m.stairs);
	$.each(m.stairs, function(index, item) {
		if(item!="-1"){
			makeCircle(item, m);
			m.markers[item].setIcon(getHtmlIcon("계단"+index));
			m.markers[item].setZIndex(100);
		}
	})
	
	m.elevators = JSON.parse(elevators)
	$.each(m.elevators, function(index, item) {
		makeCircle(item, m);
		m.markers[item].setIcon(getHtmlIcon("엘레베이터"+index));
		m.markers[item].setZIndex(100);
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
		path.push(new naver.maps.Point(m.nodes[item[0]].x , m.nodes[item[0]].y) );
		path.push(new naver.maps.Point(m.nodes[item[1]].x , m.nodes[item[1]].y) );
	});
}

function getHtmlIcon(name){
	return {content:'<div style="background-color:white;border: 1px solid black;opacity:0.5;">'+name+'</div>',
	 size: new naver.maps.Size(22, 35),
	 anchor: new naver.maps.Point(11, 30)};
}
function makeCircle(name, m){
	return new naver.maps.Circle({
	    map: m.map,
	    center: m.nodes[name],
	    radius: 5,
	    fillColor: '#40d0a3',
	    fillOpacity: 1,
	    strokeColor: '#40d0a3'
	});
}

function makeCustomMap(buildingName, floor, targetDiv) {
	var imgPath = './resources/' + buildingName + "/" + floor + "F.jpg";
	
	var tileSize = new naver.maps.Size(1000, 1000),
	
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
		center : new naver.maps.Point(500, 500),
		zoom : 0,
		background : '#FFFFFF',
		mapTypes : new naver.maps.MapTypeRegistry({
			'default' : getMapType()}),
		mapTypeId : 'default'
	});
}

function ajaxSaveMapInfo(id, m){
	$.ajax({
		url : "./saveMapInfo",
		type : "post",
		data : "id=" + id + 
				"&nodes=" + JSON.stringify(m.nodes) + 
				"&graph=" + JSON.stringify(m.graph) +
				"&selectableNodes=" + JSON.stringify(m.selectableNode) +
				"&stairs=" + JSON.stringify(m.stairs) +
				"&elevators=" + JSON.stringify(m.elevators),
		success : function(result) {
		}
		
	});
}

function ajaxLoadMapInfo(id, m){
	$.ajax({
		url : "./loadMapInfo",
		type : "post",
		data : "id=" + id,
		success : function(result) {
			var info = JSON.parse(result);
			if(info!==null){
				loadNode(info.nodes, info.graph, info.selectableNodes, info.stairs, info.elevators, m);
			}
		}
		
	});
}

function autocomplete(inp, arr) {
	inp.addEventListener("focus", function(e){
		a = document.createElement("DIV");
		a.setAttribute("id", this.id + "autocomplete-list");
		a.setAttribute("class", "autocomplete-items");
		this.parentNode.appendChild(a);
		for (i = 0; i < arr.length; i++) {
			b = document.createElement("DIV");
			b.innerHTML = arr[i];
			b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
			b.addEventListener("click", function(e) {
				inp.value = this.getElementsByTagName("input")[0].value;
				closeAllLists();
			});
			a.appendChild(b);
		}
	});
	
	inp.addEventListener("input", function(e) {
		var a, b, i, val = this.value;
		closeAllLists();
		if (!val) { return false;}
		a = document.createElement("DIV");
		a.setAttribute("id", this.id + "autocomplete-list");
		a.setAttribute("class", "autocomplete-items");
		this.parentNode.appendChild(a);
		for (i = 0; i < arr.length; i++) {
			if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
				b = document.createElement("DIV");
				b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
				b.innerHTML += arr[i].substr(val.length);
				b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
				b.addEventListener("click", function(e) {
					inp.value = this.getElementsByTagName("input")[0].value;
					closeAllLists();
				});
				a.appendChild(b);
			}
		}
	});

  function closeAllLists(elmnt) {
    /*close all autocomplete lists in the document,
    except the one passed as an argument:*/
    var x = document.getElementsByClassName("autocomplete-items");
    for (var i = 0; i < x.length; i++) {
      if (elmnt != x[i] && elmnt != inp) {
        x[i].parentNode.removeChild(x[i]);
      }
    }
  }
  /*execute a function when someone clicks in the document:*/
  document.addEventListener("click", function (e) {
      closeAllLists(e.target);
   });
}
