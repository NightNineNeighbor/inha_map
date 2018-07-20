<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>지도134</title>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=nVEUh5PrMsL3BXJq_8Pl&submodules=geocoder"></script>

</head>

<script>
	window.onload = function() {
		var map = new naver.maps.Map('map', {
			center : new naver.maps.LatLng(37.451001, 126.656370),
			zoom : 12
		});
		
		var polyline = new naver.maps.Polyline({
		    map: map,
		    path: [],
		    strokeColor: '#5347AA',
		    strokeWeight: 2
		});
		var path = polyline.getPath();

		var makePath = function(event) {
			console.log(event);
			console.log(this);
			if (this.id === 'a') {
				path.splice(0,path.length);
				path.push( new naver.maps.LatLng(37.451001, 126.656370));
				path.push( new naver.maps.LatLng(37.449130, 126.65590));
			}
			if (this.id === 'b') {
				path.splice(0,path.length);
				path.push( new naver.maps.LatLng(37.451001, 126.656370));
				path.push( new naver.maps.LatLng(37.448130, 126.655704));
			}
		}

		var buttonA = document.getElementById("a");
		buttonA.onclick = makePath;

		var buttonB = document.getElementById("b")
		buttonB.onclick = makePath;
	};
</script>
<body>
	<div id="map"
		style="border: 1px solid black; height: 500px; width: 500px;"></div>
	<button id="a">통일광장</button>
	<button id="b">쪽문</button>
</body>

</html>