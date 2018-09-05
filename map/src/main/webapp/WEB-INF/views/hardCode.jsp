<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>하드코드</title>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
window.onload = function() {
	function myParser(arg, startFloor){
		var obj = {};
		
		$.each(arg, function(index, item){
			var floorNum = startFloor + index
			$.each(item, function(key, value){		//key ->nodeNum, value ->selectName
				$.each(value, function(i, item2){	//index, item
					var t = [];
					t.push(key);
					t.push(floorNum);
					obj[item2] = t;
				});
			});
		});
		return obj;
	}
	var myObj={};
	var hardCoding = [];
	hardCoding.push(JSON.parse('${building1_0F}'));
	hardCoding.push(JSON.parse('${building1_1F}'));
	hardCoding.push(JSON.parse('${building1_2F}'));
	hardCoding.push(JSON.parse('${building1_3F}'));
	hardCoding.push(JSON.parse('${building1_4F}'));
	hardCoding.push(JSON.parse('${building1_5F}'));
	myObj["building1"] = myParser(hardCoding, 0);
	arr = Object.keys(myObj["building1"]);
	
	hardCoding = [];
	hardCoding.push(JSON.parse('${building2_0F}'));
	hardCoding.push(JSON.parse('${building2_1F}'));
	hardCoding.push(JSON.parse('${building2_2F}'));
	hardCoding.push(JSON.parse('${building2_3F}'));
	hardCoding.push(JSON.parse('${building2_4F}'));
	hardCoding.push(JSON.parse('${building2_5F}'));
	hardCoding.push(JSON.parse('${building2_6F}'));
	myObj["building2"] = myParser(hardCoding, 0);
	
	hardCoding = [];
	hardCoding.push(JSON.parse('${building5_0F}'));
	hardCoding.push(JSON.parse('${building5_1F}'));
	hardCoding.push(JSON.parse('${building5_2F}'));
	hardCoding.push(JSON.parse('${building5_3F}'));
	hardCoding.push(JSON.parse('${building5_4F}'));
	hardCoding.push(JSON.parse('${building5_5F}'));
	myObj["building5"] = myParser(hardCoding, 0);
	
	hardCoding = [];
	hardCoding.push(JSON.parse('${building6_1F}'));
	hardCoding.push(JSON.parse('${building6_2F}'));
	hardCoding.push(JSON.parse('${building6_3F}'));
	hardCoding.push(JSON.parse('${building6_4F}'));
	hardCoding.push(JSON.parse('${building6_5F}'));
	hardCoding.push(JSON.parse('${building6_6F}'));
	hardCoding.push(JSON.parse('${building6_7F}'));
	myObj["building6"] = myParser(hardCoding, 1);
	
	hardCoding = [];
	hardCoding.push(JSON.parse('${building7_1F}'));
	hardCoding.push(JSON.parse('${building7_2F}'));
	hardCoding.push(JSON.parse('${building7_3F}'));
	hardCoding.push(JSON.parse('${building7_4F}'));
	hardCoding.push(JSON.parse('${building7_5F}'));
	myObj["building7"] = myParser(hardCoding, 1);
	
	hardCoding = [];
	hardCoding.push(JSON.parse('${building10_0F}'));
	hardCoding.push(JSON.parse('${building10_1F}'));
	hardCoding.push(JSON.parse('${building10_2F}'));
	hardCoding.push(JSON.parse('${building10_3F}'));
	hardCoding.push(JSON.parse('${building10_4F}'));
	myObj["building10"] = myParser(hardCoding, 0);
	
	hardCoding = [];
	hardCoding.push(JSON.parse('${building11_1F}'));
	hardCoding.push(JSON.parse('${building11_2F}'));
	hardCoding.push(JSON.parse('${building11_3F}'));
	myObj["building11"] = myParser(hardCoding, 1);
	
	hardCoding = [];
	hardCoding.push(JSON.parse('${building12_0F}'));
	hardCoding.push(JSON.parse('${building12_1F}'));
	hardCoding.push(JSON.parse('${building12_2F}'));
	hardCoding.push(JSON.parse('${building12_3F}'));
	hardCoding.push(JSON.parse('${building12_4F}'));
	hardCoding.push(JSON.parse('${building12_5F}'));
	hardCoding.push(JSON.parse('${building12_6F}'));
	hardCoding.push(JSON.parse('${building12_7F}'));
	hardCoding.push(JSON.parse('${building12_8F}'));
	hardCoding.push(JSON.parse('${building12_9F}'));
	hardCoding.push(JSON.parse('${building12_10F}'));
	hardCoding.push(JSON.parse('${building12_11F}'));
	hardCoding.push(JSON.parse('${building12_12F}'));
	hardCoding.push(JSON.parse('${building12_13F}'));
	hardCoding.push(JSON.parse('${building12_14F}'));
	hardCoding.push(JSON.parse('${building12_15F}'));
	myObj["building12"] = myParser(hardCoding, 0);	
	
	$("#code").text(JSON.stringify(myObj));
	$("#selectable").text(JSON.stringify('${selectable}'));
	
	
}
</script>
</head>
<body>
<h1>ground</h1>
<div id="selectable"></div>
<h1>building</h1>
<div id="code" style="width:90%">
</div>
</body>
</html>