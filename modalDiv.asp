<!--#include file="js/doc.js" -->
<%
var url = "";
if (String(Request.QueryString("url")) != "undefined" && 
    String(Request.QueryString("url")) != "") { 
  url = String(Request.QueryString("url"));
}
%>

<html>
<head>
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<!--#include file="js/correctPng.js"-->
<title>档案管理系统</title>
<script type="text/javascript">
$(document).ready(function () {
	/*
	jQuery.noConflict();
*/
	
	// Position modal box in the center of the page
	jQuery.fn.center = function () {
		this.css("position","absolute");
		this.css("top", "10px");
		this.css("left", "10px");
		return this;
	}
	
	jQuery(".modal-profile").center();

	// Set height of light out div	
	jQuery('.modal-lightsout').css("height", jQuery(document).height());
		
	// closes modal box once close link is clicked, or if the lights out divis clicked
	jQuery('a.modal-close-profile, .modal-lightsout').click(function() {
		jQuery('.modal-profile').fadeOut("slow");
		jQuery('.modal-lightsout').fadeOut("slow");
		window.close();
	});
	
	// Fade in modal box once link is clicked
	jQuery('.modal-profile').fadeIn("slow");
	jQuery('.modal-lightsout').fadeTo("slow", .5);
	$("#modalDiv").load("<%=url%>?pageItem=<%=pageItem%>&pageModel=div");
	//$("#modalDiv").load("test1.asp");
});
</script>
<style type="text/css">
body {
	color:#ccc;
	background-color:#cccccc;
	font-family:Arial, Helvetica, sans-serif;
	font-size:12px;
	overflow-x:hidden;
	overflow-y:hidden;
	overflow:hidden; 
}
.modal-profile h2 {
	font-size:2em;
	letter-spacing:-1px;
}
.modal-profile {
	display:none;
	height: 250px;
	width: 500px;
	padding:25px;
	border:1px solid #fff;
	box-shadow: 0px 2px 7px #292929;
	-moz-box-shadow: 0px 2px 7px #292929;
	-webkit-box-shadow: 0px 2px 7px #292929;
	border-radius:10px;
	-moz-border-radius:10px;
	-webkit-border-radius:10px;
	background: #f2f2f2;
	z-index:50;
}

.modal-lightsout {
	display:none;
	position:absolute;
	top:0;
	left:0;
	width:100%;
	z-index:25;
	background:#000;
}

a.modal-close-profile {
	position:absolute;
	top:-15px;
	right:-15px;
}

a.modal-social {
	margin:0 10px 0 0;
}

</style>

</head>
<body>
<div class="container">
	<div class="modal-lightsout"></div>
	<div class="modal-profile">
    <a href="#" title="关闭" class="modal-close-profile"><img src="images\close.png" width="24" border="0" alt="Close Window" /></a>
		<div id="modalDiv"></div>
	
	</div>
</div>
</body>
</html>









