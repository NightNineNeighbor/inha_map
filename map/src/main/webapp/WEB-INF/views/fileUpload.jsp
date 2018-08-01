<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
<title>Home</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>
<body>
<h1>
	Hello world!   ${msg }
</h1>
<form action="/map/fileUpload" method="post" enctype="multipart/form-data">
	<input type="file" name="myfile">
	<input type="submit" value="file throw">
</form>

</body>
</html>
