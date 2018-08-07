<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>빌딩</title>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=nVEUh5PrMsL3BXJq_8Pl&submodules=geocoder"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="http://127.0.0.1:8081/map/resources/script/myfunction.js" type="text/javascript"></script>
</head>
<script>
	window.onload = function() {
		var HOME_PATH = './resources';

		var tileSize = new naver.maps.Size(256, 256),
		    proj = {
		        fromCoordToPoint: function(coord) {
		            var pcoord = coord.clone();

		            if (coord instanceof naver.maps.LatLng) {
		                pcoord = new naver.maps.Point(coord.lng(), coord.lat());
		            }

		            return pcoord.div(tileSize.width, tileSize.height);
		        },

		        fromPointToCoord: function(point) {
		            return point.clone().mul(tileSize.width, tileSize.height);
		        }
		    },
		    getMapType = function(floor) {
		        var commonOptions = {
		                name: '',
		                minZoom: 0,
		                maxZoom: 4,
		                tileSize: tileSize,
		                projection: proj,
		                repeatX: false,
		                tileSet: '',
		                vendor: '\xa9 NAVER Corp.',
		                uid: ''
		            },
		            mapTypeOptions = $.extend({}, commonOptions, {
		                name: floor,
		                tileSet: HOME_PATH +'/tiles/gf-{floor}/{z}/{x}-{y}.png'.replace('{floor}', floor.toLowerCase()),
		                uid: 'naver:greenfactory:' + floor
		            });

		        return new naver.maps.ImageMapType(mapTypeOptions);
		    }; 

		
		    
		var building = new naver.maps.Map('map', {
		    center: new naver.maps.Point(128, 128),
		    zoom: 2,
		    background: '#FFFFFF',
		    mapTypes: new naver.maps.MapTypeRegistry({
		        '+1F': getMapType('1F'),
		        '+2F': getMapType('2F'),
		        '+4F': getMapType('4F'),
		        '+5F': getMapType('5F'),
		    }),
		    mapTypeId: '+1F',
		    mapTypeControl: true,
		    mapTypeControlOptions: {
		        mapTypeIds: ['+1F', '+2F', '+4F', '+5F'],
		        position: naver.maps.Position.BOTTOM_CENTER,
		        style: naver.maps.MapTypeControlStyle.BUTTON
		    },
		    zoomControl: true,
		    zoomControlOptions: {
		        position: naver.maps.Position.TOP_RIGHT
		    }
		});
		
		
		var metaMap = getMetaMap(building);
		console.log(metaMap.map);
		
		naver.maps.Event.addListener(metaMap.map, 'click', function(e) {
			makeMarker(metaMap.nextMarkerName++, e.coord, metaMap);
		});
	}
</script>
<body id="body">
	<div id="map"
		style="border: 1px solid black; height: 500px; width: 500px;"></div>

</body>
</html>