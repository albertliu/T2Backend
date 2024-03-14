<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
	<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.12">
	<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
	<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script language="javascript" src="js/jquery.form.js"></script>
	<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
	<script src="js/jquery.alerts.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>

<script language="javascript">
	var nodeID = "";
	var count = 0;
	var reDo = "";
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//courseID
		count = "<%=refID%>";	//qty
		kindID = "<%=kindID%>";	// 0 初考 1 补考
		
		getComboList("applyID","v_generateApplyInfo","ID","IDtitle","status=0 and kindID=" + kindID + " and courseID='" + nodeID + "' and host='" + currHost + "' order by ID desc",1);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		$("#btnDo").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'加入',
			onClick:function() {
				if(count==0){
					$.messager.alert('提示对话框', "没有要添加的人员，请重新选择。");
					return false;
				}
				if($("#applyID").combobox("getValue")==""){
					$.messager.alert('提示对话框', "请选择申报批次。");
					return false;
				}
				$.messager.confirm("确认","确定将这" + count + "人加入到'" + $("#applyID").combobox("getText") + "'批次吗？",function(r){
					if(r){
						$.post(uploadURL + "/public/add_apply_from_picker", {applyID:$("#applyID").combobox("getValue"), selList: getSession("applyPicker"), registerID: currUser}, function(data){
							//jAlert(data);
							if(data.length==0){
								$.messager.alert('提示对话框', "操作成功。");
							}else{
								$.messager.alert('提示对话框', "以下" + data.length + "个人未能加入，请检查。");
								getCartList(data);
							}
							if(data.length < count){
								updateCount += 1;
							}
							setSession("applyPicker", "");
						});
					}
				});
			}
		});
	});

	function getCartList(data){
		//jAlert(unescape(data));
		$("#cartCover").empty();
		var arr = new Array();
		arr = [];
		if(data.length>0){
			var i = 0;
			var c = 0;
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cartTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='20%'>身份证</th>");
			arr.push("<th width='12%'>姓名</th>");
			arr.push("<th width='15%'>课程</th>");
			arr.push("<th width='15%'>备注</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			$.each(data,function(iNum,val){
				i += 1;
				arr.push("<tr class='grade" + c + "'>");
				arr.push("<td class='center'>" + i + "</td>");
				arr.push("<td class='left'>" + val["username"] + "</td>");
				arr.push("<td class='left'>" + val["name"] + "</td>");
				arr.push("<td class='left'>" + val["courseName"] + "</td>");
				arr.push("<td class='left'>" + val["memo"] + "</td>");
				arr.push("</tr>");
			});
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cartCover").html(arr.join(""));
			arr = [];
			$('#cartTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"aoColumnDefs": []
			});
		}
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:10px;">
		申报项目&nbsp;<select id="applyID" name="applyID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:25,width:300"></select>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="buttonbox">
  		<a class="easyui-linkbutton" id="btnDo" href="javascript:void(0)"></a>
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div id="cartCover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
</div>
</body>
