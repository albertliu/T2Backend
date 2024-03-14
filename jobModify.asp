<!--#include file="js/doc.js" -->
<%
var editType = "browse";
var articleID = "1";
var classID = "3";

if (String(Request.QueryString("articleID")) != "undefined" && 
    String(Request.QueryString("articleID")) != "") { 
  articleID = String(Request.QueryString("articleID"));
}
if (String(Request.QueryString("type")) != "undefined" && 
    String(Request.QueryString("type")) != "") { 
  editType = String(Request.QueryString("type"));
}

sql = "SELECT * FROM v_jobList WHERE articleID = " + articleID;
var rs = conn.Execute(sql);

if(rs.Eof){
	Response.Redirect("userDocListShow.asp?classID=3");
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>无标题文档</title>

<link rel="stylesheet" href="css/jqtransform.css" type="text/css" media="all" />
<link rel="stylesheet" href="css/demo.css" type="text/css" media="all" />
	
<script type="text/javascript" src="js/jquery132.min.js" ></script>
<script type="text/javascript" src="js/jquery.jqtransform.js" ></script>
<script language="javascript">
	$(function(){
		$('form').jqTransform({imgPath:'css/img/'});

		$("#form1").ajaxForm(function(re){
			/*
			//alert((re));
			if(re==0){  //passed
				//alert("ok");
				self.location = "userDocListShow.asp?classID=3&profile=1";
			}
			*/
		});
	});
</script>
</head>

<body>
<table width="80%" border="0" cellspacing="5" cellpadding="0">
<form name="form1" method="post" action="docControl.asp?type=updateJob&articleID=<%=articleID%>">
  <tr>
    <td><div class="rowElem"><lable>岗位名称： </label></div></td>
    <td><div class="rowElem"><input name="title" type="text" size="60" value="<%=rs("title")%>"></div></td>
  </tr>
  <tr>
    <td><div class="rowElem"><lable>招聘人数：</label></div></td>
    <td><div class="rowElem"><input name="jobNum" type="text" size="20" value="<%=rs("jobNum")%>"></div></td>
  </tr>
  <tr>
    <td><div class="rowElem"><lable>职位描述： </label></div></td>
    <td><div class="rowElem"><textarea name="description" cols="70" rows="8"><%=rs("description")%></textarea></div></td>
  </tr>
  <tr>
    <td><div class="rowElem"><lable>岗位要求： </label></div></td>
    <td><div class="rowElem"><textarea name="ask" cols="70" rows="8"><%=rs("ask")%></textarea></div></td>
  </tr>
  <tr>
    <td><div class="rowElem"><lable>电子邮件： </label></div></td>
    <td><div class="rowElem"><input name="email" type="text" size="60" value="<%=rs("email")%>"></div></td>
  </tr>
  <tr>
    <td><div class="rowElem"><lable>通讯地址： </label></div></td>
    <td><div class="rowElem"><input name="address" type="text" size="60" value="<%=rs("address")%>"></div></td>
  </tr>
  <tr>
    <td><div class="rowElem"><lable>联系电话： </label></div></td>
    <td><div class="rowElem"><input name="phone" type="text" size="60" value="<%=rs("phone")%>"></div></td>
  </tr>
  <tr>
    <td><div class="rowElem"><lable>邮政编码： </label></div></td>
    <td><div class="rowElem"><input name="zip" type="text" size="20" value="<%=rs("zip")%>"></div></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="center"><div class="rowElem"><input type="submit" name="Submit" value="保存">
&nbsp;
<input type="reset" name="Submit" value="重写"></div>
    </td>
  </tr>
</form>
</table>
</body>
</html>
<%
rs.Close();
%>