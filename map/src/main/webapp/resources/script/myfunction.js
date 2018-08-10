function sayHello(){
	console.log("hello world!!");
}

function getMetaMap(map){
	var object = {};
	object["map"] = map;
	object["nextMarkerName"] = 0;
	object["nodes"] = {};			//format : {"0":{"y":37.4515427,"_lat":37.4515427,"x":126.6564996,"_lng":126.6564996},}
	object["graph"] = [];			//format : [[0,1,33700],[1,2,9236]]
	object["markers"] = {};
	object["circles"] = {};
	object["polylines"] = [];
	object["selectableNode"] = {};
	object["bestLine"] = new naver.maps.Polyline();
	object["flag"] = true;
	object["prevNode"] = 0;
	object["prevX"] = 0;
	object["prevY"] = 0;
	object["path"] = {};
	object["pl"] = {};
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

function ajaxFullFindPath(startingPoint, buildingName, floor, destinationPoint, m1, m2, m3){
	$.ajax({
		url : "/map/findpath",
		type : "post",
		data : 	"startingPoint=" + startingPoint +
				"&buildingName=" + buildingName +
				"&floor=" + floor +
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
			
			console.log("position : " + m1.nodes[ground_Paths[0]]);
			var mmm1 = new naver.maps.Marker({
			    position: m1.nodes[ground_Paths[0]],
			    map: m1.map,
			    title: 'Green',
			    icon: {
			        content:'<div style="background-color:white;border: 1px solid black;">출발</div>',
			        size: new naver.maps.Size(22, 35),
			        anchor: new naver.maps.Point(11, 30)
			    }
			});
			var mmm2 = new naver.maps.Marker({
			    position: m1.nodes[ground_Paths[ground_Paths.length-1]],
			    map: m1.map,
			    title: 'Green',
			    icon: {
			        content:'<div style="background-color:white;border: 1px solid black;">도착</div>',
			        size: new naver.maps.Size(23, 35),
			        anchor: new naver.maps.Point(11, 30)
			    }
			});
			
			
			
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
		var name = prompt();
		e.overlay.setIcon(getHtmlIcon(name));
		m.selectableNode[e.overlay.name] = name;
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
		console.log(m.graph);	//DEBUG

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
		makeCircle(key, m);
		m.markers[key].setIcon(getHtmlIcon(values));
		m.markers[key].setZIndex(100);
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
	return {content:'<div style="background-color:white;border: 1px solid black;">'+name+'</div>',
	 size: new naver.maps.Size(22, 35),
	 anchor: new naver.maps.Point(11, 30)};
}
function makeCircle(name, m){
	return new naver.maps.Circle({
	    map: m.map,
	    center: m.nodes[name],
	    radius: 5,
	    fillColor: '#5347AA',
	    fillOpacity: 1,
	    strokeColor: '#5347AA'
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

function makeCustomMap(fileName, targetDiv) {
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
			console.log(info);	//DEBUG
			loadNode(info.nodes, info.graph, info.selectableNodes, m);
		}
		
	});
}

function autocomplete(inp, arr) {
  /*the autocomplete function takes two arguments,
  the text field element and an array of possible autocompleted values:*/
  var currentFocus;
  /*execute a function when someone writes in the text field:*/
  inp.addEventListener("input", function(e) {
      var a, b, i, val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      if (!val) { return false;}
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      for (i = 0; i < arr.length; i++) {
        /*check if the item starts with the same letters as the text field value:*/
        if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
          /*create a DIV element for each matching element:*/
          b = document.createElement("DIV");
          /*make the matching letters bold:*/
          b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
          b.innerHTML += arr[i].substr(val.length);
          /*insert a input field that will hold the current array item's value:*/
          b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
          /*execute a function when someone clicks on the item value (DIV element):*/
          b.addEventListener("click", function(e) {
              /*insert the value for the autocomplete text field:*/
              inp.value = this.getElementsByTagName("input")[0].value;
              /*close the list of autocompleted values,
              (or any other open lists of autocompleted values:*/
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

var countries = ["김","김이","김이박","김이박최","Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua & Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia & Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Cayman Islands","Central Arfrican Republic","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cuba","Curacao","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kiribati","Kosovo","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Myanmar","Namibia","Nauro","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palau","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre & Miquelon","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","St Kitts & Nevis","St Lucia","St Vincent","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad & Tobago","Tunisia","Turkey","Turkmenistan","Turks & Caicos","Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States of America","Uruguay","Uzbekistan","Vanuatu","Vatican City","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"];



