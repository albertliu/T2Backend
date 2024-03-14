<!--#include file="js/doc1.js" -->
<%
var event = "";
var msg = "";
if (String(Request.QueryString("event")) != "undefined" && 
    String(Request.QueryString("event")) != "") { 
  event = String(Request.QueryString("event"));
}
if (String(Request.QueryString("msg")) != "undefined" && 
    String(Request.QueryString("msg")) != "") { 
  msg = String(Request.QueryString("msg"));
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>电子证书</title>

<link href="css/style_main.css?v=1.3"  rel="stylesheet" type="text/css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<style>
.ant-table-cell{
    font-size: 0.9em;
    border: 1px solid blue;
    border-collapse: collapse;
}
.td1{
    text-align: center;
    background-color: rgb(240, 253, 253);
    border: 1px solid gray;
}
.td2{
    text-align: left;
    padding-left: 1.5em;
    padding-top: 5px;
    padding-bottom: 5px;
    border: 1px solid gray;
}
.table-cell{
    font-size: 0.9em;
    border: 1px solid gray;
}
h2{
    font-family:微软雅黑, "Open Sans", "宋体";
    /* font-weight: bold; */
    font-size: 1.3em;
    padding:5px;
}
h3{
    font-family:微软雅黑, "Open Sans", "宋体";
    /* font-weight: bold; */
    font-size: 1.1em;
    padding:5px;
}
</style>
<script language="javascript">
	var backendURL = "<%=backendURL%>";
	var uploadURL = "<%=uploadURL%>";
   var cert = [];
   var k = 0;
	$(document).ready(function (){
      nodeID = "<%=msg%>";
      //window.innerWidth = 86mm;
      nodeID = nodeID.replace('.pdf','');
      if(nodeID.indexOf(".pdf")>0){
         k = 1;
      }
      // alert(nodeID + ":" + k);
      if(k==1){
         $.get(uploadURL + "/public/getPDF2img?path=users/upload/students/diplomas/" + nodeID,function(data){
            //alert(data);
            $("#img").prop("src",data);
         });
      }else{
         $.getJSON(uploadURL + "/public/get_diploma_byID?diplomaID=" + nodeID,function(data){
            cert = data;
            let arr = [];
            arr = [];
            arr.push("<table class='ant-table-cell' style='width:100%'>");
            arr.push("  <tr>");
            arr.push("    <td style='width:'25%'' class='td1'>姓名</td>");
            arr.push("    <td style='width:'25%'' class='td2'>" + cert.name + "</td>");
            arr.push("    <td style='width:'25%'' class='td1'>性别</td>");
            arr.push("    <td style='width:'25%'' class='td2'>" + cert.sexName + "</td>");
            arr.push("  </tr>");
            arr.push("  <tr>");
            arr.push("    <td class='td1'>证书编号</td>");
            arr.push("    <td class='td2' colspan='3'>" + cert.diplomaID + "</td>");
            arr.push("  </tr>");
            arr.push("  <tr>");
            arr.push("    <td class='td1'>身份证号</td>");
            arr.push("    <td class='td2' colspan='3'>" + cert.username + "</td>");
            arr.push("  </tr>");
            arr.push("  <tr>");
            arr.push("    <td class='td1'>工作单位</td>");
            arr.push("    <td class='td2' colspan='3'>" + cert.unit + "</td>");
            arr.push("  </tr>");
            arr.push("  <tr>");
            arr.push("    <td class='td1'>培训项目</td>");
            arr.push("    <td class='td2' colspan='3'>" + cert.certName + "</td>");
            arr.push("  </tr>");
            arr.push("  <tr>");
            arr.push("    <td class='td1'>有效期限</td>");
            arr.push("    <td class='td2' colspan='3'>" + cert.startDate + "至" + cert.endDate + "</td>");
            arr.push("  </tr>");
            arr.push("  <tr>");
            arr.push("    <td class='td1'>发证单位</td>");
            arr.push("    <td class='td2' colspan='3'>" + cert.hostName + "</td>");
            arr.push("  </tr>");
            arr.push("</table>");
            $("#cover").html(arr.join(""));
         });
      }
      $.ajaxSetup({ 
			async: false 
		}); 
	});
</script>
</head>

<body>
<div>
   <div style="height:100%;">
         <div style='background-color: #F0FFFF'>
            <h2 style='text-align: left'>安全生产培训证书查询</h2>
         </div>
         <div>
            <h3 style='text-align: left; color: gray'>
               上海市应急管理局核准的特种作业培训机构
            </h3>
         </div>
         <div>
            <h3 style='text-align: left; color: gray'>
               本机构信息在应急管理部官网可查询（cx.mem.gov.cn）
            </h3>
         </div>
         <div>&nbsp;</div>
         <div id="cover" style="width:99%;">
            <img id="img" src="" style="width:95%;padding:5px;margin:0 auto;-webkit-filter: drop-shadow(10px 10px 10px rgba(0, 0, 0, .5));filter: drop-shadow(10px 10px 10px rgba(0, 0, 0, .5));" />
         </div>
   </div>
</div>

</body>
</html>
