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
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.12">
	<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
	<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script language="javascript" src="js/jquery.form.js"></script>
	<script src="js/jquery.alerts.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>

<script language="javascript">
	var updateCount = 0;
	var reDo = "";
	var reList = "";
	var memo = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//
		kindID = "<%=kindID%>";	// 
		refID = "<%=refID%>";	// 
		item = "<%=item%>";	// 
		keyID = "<%=keyID%>";	// 
		memo = "<%=memo%>";	// 
		$.ajaxSetup({ 
			async: false 
		}); 

		$('#avatar').filebox({
			buttonText: '选择文件',
			buttonAlign: 'left'
		})

		$("#kindID").html(item);

		$("#uploadTitle").html((memo ? memo : ''));
        
		$("#btnDo").linkbutton({
			iconCls:'icon-redo',
			width:70,
			height:25,
			text:'上传',
			onClick:function() {
				//var isValid = $(this).form('validate');
				if($("#avatar").filebox("getValue")==""){
					$.messager.alert("提示","请选择一个文件。","warning");
					return false;
				}
				
				var form = new FormData(document.getElementById("fmUpload"));
				var act = uploadURL + "/outfiles/uploadSingle?upID=" + kindID + "&username=" + nodeID + "&refID=" + refID + "&keyID=" + keyID + "&currUser=" + currUser + "&host=" + currHost + "&currPartner=" + currPartner;
				$.ajax({
					url: act,
					type:"post",
					data:form,
					processData:false,
					contentType:false,
					success:function(data){
						reDo = data.reDo;
						reList = data.reList;
						if(kindID == "check_student_list"){
							//学员信息核对，返回结果列表excel
							if(data.file>""){
								asyncbox.alert("核对结果已生成 <a href='" + data.file + "' target='_blank'>下载文件</a>",'核对完成',function(action){
								　　//alert 返回action 值，分别是 'ok'、'close'。
								　　if(action == 'ok'){
								　　}
								　　if(action == 'close'){
								　　　　//alert('close');
								　　}
								});
							}else{
								$.messager.alert("提示","没有可供处理的数据。","warning");
							}
						}else{
							var msg = data.msg;
							if(msg == ""){
								if(data.count>0){
									msg = "成功处理" + data.count + "条数据。";
								}else{
									msg = "没有上传有效数据。\n";
								}
								if(data.err_msg > ""){
									msg += data.err_msg;
								}
								if(data.exist_msg > ""){
									msg += data.exist_msg;
								}
							}

							if(data.reList && data.reList.length>0){
								msg += "\n以下" + data.reList.length + "条数据有错误，请核实。";
								getReList(data.reList);
							}
							
							$.messager.alert("提示",msg,"warning");
						}
						updateCount += 1;
					},
					error:function(e){
						//alert(e);
					}
				});    
			}
		});
	});

	function getReList(data){
		//jAlert(unescape(data));
		$("#listCover").empty();
		var arr = new Array();
		arr = [];
		if(data.length>0){
			var i = 0;
			var c = 0;
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cartTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='20%'>项目1</th>");
			arr.push("<th width='20%'>项目2</th>");
			arr.push("<th width='20%'>项目3</th>");
			arr.push("<th width='25%'>备注</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			$.each(data,function(iNum,val){
				i += 1;
				arr.push("<tr class='grade" + c + "'>");
				arr.push("<td class='center'>" + i + "</td>");
				arr.push("<td class='left'>" + val["f1"] + "</td>");
				arr.push("<td class='left'>" + val["f2"] + "</td>");
				arr.push("<td class='left'>" + val["f3"] + "</td>");
				arr.push("<td class='left'>" + val["f4"] + "</td>");
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
			$("#listCover").html(arr.join(""));
			arr = [];
			$('#cartTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aLengthMenu":[15,30,50,100],
				"iDisplayLength": 15,
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
	<div id='uploadTitle' style='padding:10px; font-size: 1.3em;'></div>
	<form id="fmUpload" method="post" enctype="multipart/form-data" style="margin:0;padding:20px 20px">
		<div style="width:100%;float:left;">
			<div id="kindID" style="padding:10px; font-size:1.4em; font-family:幼圆;"></div>
			<input id="avatar" name="avatar" type="text" style="width:100%;">
		</div>
		
		<div style="width:100%;float:left;margin:10;height:4px;"></div>
 		<div class="buttonbox">
			<a class="easyui-linkbutton" id="btnDo" href="javascript:void(0)"></a>
		</div>
		<div style="width:100%;float:left;margin:10;height:4px;"></div>
 	</form>
	<div id="listCover" style="float:top;margin:0px;background:#f8fff8;"></div>
</body>
