<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>지도111aa3</title>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=nVEUh5PrMsL3BXJq_8Pl&submodules=geocoder"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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
		var nodeList = new Array();
		var graph = new Array();
		
		//클릭하면 마커 생상
		var prevX = 0;
	    var prevY = 0;
	    naver.maps.Event.addListener(map, 'click', function(e) {
	        nodeList.push({ coord : e.coord, nodeNum : i});
	    	var marker = new naver.maps.Marker({
	            position: e.coord,
	            map: map,
	            name : i++
	        });
	        
	        //두 마커를 클릭하면 라인이 그려진다.
	        
	        naver.maps.Event.addListener(marker, 'click', function(e) {
	        	if(flag){
	        		var pl = new naver.maps.Polyline({
	        		    map: map,
	        		    path: [],
	        		    strokeColor: '#5347AA',
	        		    strokeWeight: 4
	        		});
	        		path = pl.getPath();
	        		
	        		prevNode = e.overlay.name;
	        		var x = e.overlay.position.x;
	        		var y = e.overlay.position.y;
	        		prevX = Math.floor((x - Math.floor(x))*100000);
	        		prevY = Math.floor((y - Math.floor(y))*100000);
	        		path.push(e.overlay.getPosition());
	        	}else{
	        		path.push(e.overlay.getPosition());
	        		var x = e.overlay.position.x;
	        		var y = e.overlay.position.y;
	        		x = Math.floor((x - Math.floor(x))*100000);
	        		y = Math.floor((y - Math.floor(y))*100000);
	        		var distance = 0;
	        		distance = Math.pow(prevX - x ,2) + Math.pow(prevY - y ,2); 
	        		graph.push({nodeA : prevNode,
	        					nodeB : e.overlay.name,
	        					l : distance});
	        	}
	        	flag = !flag;
	        });
	        
	        //마커를 더블클릭하면 마커를 바꾼다.
	        naver.maps.Event.addListener(marker, 'dblclick', function(e) {
	        	e.overlay.setIcon("./resources/i.png");
	        });
	        
	        markerList.push(marker);
	    });

	    //esc를 누르면 전부 닫는다.
	    naver.maps.Event.addListener(map, 'keydown', function(e) {
	        var keyboardEvent = e.keyboardEvent,
	            keyCode = keyboardEvent.keyCode || keyboardEvent.which;

	        var ESC = 27;

	        if (keyCode === ESC) {
	            keyboardEvent.preventDefault();

	            for (var i=0, ii=markerList.length; i<ii; i++) {
	                markerList[i].setMap(null);
	            }
	            markerList = [];
	        }
	    });
	    
	    var ar = ['aasdf','sefsdf','asdf','sdfsdf'];
	    var node = document.getElementById("node");
	    var btn = document.getElementById("printNode");
	    btn.addEventListener("click",function(){
	    	var text = "";
	    	for(var i=0, ii=nodeList.length; i<ii; i++){
	    		text += "nodeNum : " + nodeList[i].nodeNum +
	    				" ( x : " + nodeList[i].coord.x +
	    				" y : " + nodeList[i].coord.y + " )\n";
	    		
	    	}
	    	node.innerText = text;
	    	console.log(nodeList);
	    	console.log(graph);
	    });
	};
</script>
<body id="body">
	<div id="map"
		style="border: 1px solid black; height: 500px; width: 500px;"></div>
	
</body>
	<button id="printNode">printNode</button>
	<div id="node"></div>
</html>