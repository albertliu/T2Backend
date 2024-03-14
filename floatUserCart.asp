<!--#include file="js/doc.js" -->
<%
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<!--#include file="js/correctPng.js"-->

<script language="javascript">
	var sWwhere = "";
	var sTitle = "";
	$(document).ready(function (){
	    $.ajaxSetup({ 
	  		async: false 
	  	}); 
				$('#floatTab1').dataTable({
					"aaSorting": [],
					"bFilter": false,
					"bPaginate": true,
					"bLengthChange": false,
					"bInfo": false,
					"bAutoWidth": false,
					"aoColumnDefs": []
				});
	
	});
	function delFromCart(userName){
		//alert(userName);
		$.get("commonControl.asp?op=delFromSession&sName=userCart&anyStr=" + userName + "&times=" + (new Date().getTime()), function(re){
			//jAlert(userName + "已经从名单中去掉。");
			opSel();
		});
	}

</script>

</head>

<body>
		<div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="floatTab1" width="30%">
				<tbody id="tbody">
				<%
				var ar = new Array();
				ar = (Session("userCart")).split(",");
				sql = "SELECT userName,realName,unitName FROM v_userInfo where userName in('" + (Session("userCart")).replace(/,/g,"','") + "')";
				var rs = conn.Execute(sql);
				while (!rs.EOF){
				%>
					<tr class='grade0' align='left'>
						<td><%=rs("userName")%></td>
						<td><%=rs("realName")%></td>
						<td><%=rs("unitName")%></td>
						<td><a herf="#" onClick="delFromCart('<%=rs("userName")%>')"><img src='images/delete.png' title="去除"></a></td>
					</tr>
				<%
					rs.MoveNext();
				}
				rs.Close();
				%>
				</tbody>
			</table>
		</div>
</body>
</html>
