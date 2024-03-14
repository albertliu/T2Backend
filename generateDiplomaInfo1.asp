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
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.18">
	<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
	<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script language="javascript" src="js/jquery.form.js"></script>
	<script src="js/jquery.alerts.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
	<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
	<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
	<script type='text/javascript' src='js/jquery.autocomplete.js'></script>

<script language="javascript">
	var nodeID = "";
	var kindID = "";
	var refID = "";
	var keyID = 0;
	var item = "";
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		kindID = "<%=kindID%>";		//certID
		refID = "<%=refID%>";		//selList
		keyID = "<%=keyID%>";		//selCount
		item = "<%=item%>";		//certName
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 

		getComboBoxList("diplomaStyle","styleID",0);

		$("#btnSave").linkbutton({
			iconCls:'icon-save',
			width:70,
			height:25,
			text:'保存',
			onClick:function() {
				saveNode();
			}
		});

		$("#btnPrint").linkbutton({
			iconCls:'icon-print',
			width:70,
			height:25,
			text:'打印',
			onClick:function() {
				showDiplomaCards(nodeID + "," + currHost);
			}
		});

		$("#btnCancel").linkbutton({
			iconCls:'icon-undo',
			width:85,
			height:25,
			text:'撤销证书',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					jAlert("请选择要撤销证书的人员。");
					return false;
				}
				jConfirm("确定要撤销这" + selCount + "个人的证书吗？将重新回到待发证状态。","确认",function(r){
					if(r){
						//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
						$.post(uploadURL + "/outfiles/cancel_diplomas?kind=0&registerID=" + currUser, {"selList":selList} ,function(data){
							if(data>""){
								jAlert("证书已撤销");
								updateCount += 1;
								getDiplomaListByBatch();
							}else{
								jAlert("没有可供处理的数据。");
							}
						});
					}
				});
			}
		});


		$("#btnDo").linkbutton({
			iconCls:'icon-add',
			width:85,
			height:25,
			text:'生成证书',
			onClick:function() {
				if($("#startDate").datebox("getValue")==""){
					jAlert("请填写发证日期。");
					return false;
				}
				//jAlert(getSession(refID));
				jConfirm("确定要制作" + keyID + "个" + $("#styleID").combobox("getText") + "式证书吗？","确认",function(r){
					if(r){
						//$.getJSON(uploadURL + "/outfiles/generate_diploma_byClassID?ID=0&mark=0&certID=" + kindID + "&selList=" + refID + "&startDate=" + $("#startDate").val() + "&class_startDate=" + $("#class_startDate").val() + "&class_endDate=" + $("#class_endDate").val() + "&registerID=" + currUser ,function(data){
						$.post(uploadURL + "/outfiles/generate_diploma_byClassID?ID=0&card=" + $("#styleID").combobox("getValue") + "&mark=0&certID=" + kindID + "&startDate=" + $("#startDate").datebox("getValue") + "&memo=" + $("#memo").textbox("getValue") + "&host=" + currHost + "&registerID=" + currUser, {"selList": getSession(refID)} ,function(data){
							// alert(data)
							if(data>0){
								jAlert("证书制作成功。");
								nodeID = data;
								op = 0;
								updateCount += 1;
								getNodeInfo(nodeID);
								setSession(refID, "");
							}else{
								jAlert("已保存。");
							}
						});
					}
				});
			}
		});

		$("#btnRedo").linkbutton({
			iconCls:'icon-redo',
			width:85,
			height:25,
			text:'重新生成',
			onClick:function() {
				jConfirm("确定要重新制作证书吗？证书编号将保持不变。","确认",function(r){
					if(r){
						//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
						$.post(uploadURL + "/outfiles/generate_diploma_byClassID?card=" + $("#styleID").combobox("getValue") + "&ID=" + $("#ID").val() + "&mark=0&certID=" + $("#certID").val() + "&startDate=" + $("#startDate").datebox("getValue") + "&host=" + currHost + "&registerID=" + currUser, {selList:""} ,function(data){
							if(data>""){
								jAlert("证书重新制作成功 <a href='" + data + "' target='_blank'>下载文件</a>");
								updateCount += 1;
							}else{
								jAlert("没有可供处理的数据。");
							}
						});
					}
				});
			}
		});

		$("#btnSel").linkbutton({
			width:70,
			height:25,
			text:'全选/取消',
			onClick:function() {
				setSel("");
			}
		});

		$("#list").click(function(){
			outputExcelBySQL('x04','file',nodeID,0,0);
		});
		
		if(op==0){
			getNodeInfo(nodeID);
			getDiplomaListByBatch();
		}else{
			setButton();
		}
	});

	function getNodeInfo(id){
		$.get("diplomaControl.asp?op=getGenerateDiplomaNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#certID").val(ar[1]);
				$("#certName").textbox("setValue", ar[2]);
				$("#qty").textbox("setValue", ar[3]);
				$("#host").val(ar[4]);
				$("#firstID").textbox("setValue", ar[8]);
				$("#lastID").textbox("setValue", ar[9]);
				//$("#title").val(ar[6]);
				$("#memo").textbox("setValue", ar[10]);
				$("#regDate").textbox("setValue", ar[11]);
				$("#registerName").textbox("setValue", ar[12]);
				$("#printDate").datebox("setValue", ar[14]);
				$("#deliveryDate").datebox("setValue", ar[16]);
				$("#startDate").textbox("setValue", ar[17]);
				$("#styleID").combobox("setValue", ar[23]);
				if(ar[13]==1){
					$("#printed").checkbox("check");
				}else{
					$("#printed").checkbox("uncheck");
				}
				if(ar[15]==1){
					$("#delivery").checkbox("check");
				}else{
					$("#delivery").checkbox("uncheck");
				}
				var c = "";
				if(ar[7] > ""){
					c += "<a href='/users" + ar[7] + "' target='_blank' style='text-decoration:none;color:green;'>证书打印</a>";
					$("#list").html("<a href='' style='text-decoration:none;color:green;'>证书清单</a>");
				}
				if(c == ""){c = "&nbsp;&nbsp;还未制作";}
				$("#doc").html(c);
				//getDownloadFile("generateDiplomaID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}

	function getDiplomaListByBatch(){
		//alert(nodeID);
		$.get("diplomaControl.asp?op=getDiplomaListByBatch&refID=" + nodeID,function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#dimplomaListByBatch").empty();
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='diplomaTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='18%'>身份证</th>");
			arr.push("<th width='14%'>姓名</th>");
			arr.push("<th width='30%'>单位名称</th>");
			arr.push("<th width='15%'>电话</th>");
			arr.push("<th width='12%'>照</th>");
			arr.push("<th width='1%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					if(ar1[5]>""){
						imgChk = "<img id='photo" + ar1[1] + "' src='users" + ar1[5] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[5] + "\",\"" + ar1[1] + "\",\"photo\",\"\",0,1)' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'>";
					}else{
						imgChk = "";
					}
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='center'>" + imgChk + "</td>");
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchk'></td>");
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#dimplomaListByBatch").html(arr.join(""));
			arr = [];
			$('#diplomaTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}
	
	function saveNode(){
		if($("#startDate").val()==""){
			jAlert("请填写发证日期。");
			return false;
		}
		if($("#class_startDate").val()==""){
			jAlert("请填写培训起始日期。");
			return false;
		}
		if($("#class_endDate").val()==""){
			jAlert("请填写培训结束日期。");
			return false;
		}
		if($("#class_endDate").val() < $("#class_startDate").val()){
			jAlert("开始日期不得大于结束日期。");
			return false;
		}
		if($("#class_endDate").val() > $("#startDate").val()){
			jAlert("结束日期不得大于发证日期。");
			return false;
		}
		var printed = 0;
		if($("#printed").attr("checked")){printed = 1;}
		var delivery = 0;
		if($("#delivery").attr("checked")){delivery = 1;}
		var photo = 0;
		if($("#photos").attr("checked")){photo = 1;}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("diplomaControl.asp?op=updateGenerateDiplomaMemo&nodeID=" + $("#ID").val() + "&keyID=" + $("#styleID").val() + "&kindID=" + $("#kindID").val() + "&printed=" + printed + "&delivery=" + delivery + "&photo=" + photo + "&printDate=" + $("#printDate").val() + "&deliveryDate=" + $("#deliveryDate").val() + "&photoDate=" + $("#photoDate").val() + "&startDate=" + $("#startDate").val() + "&class_startDate=" + $("#class_startDate").val() + "&class_endDate=" + $("#class_endDate").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				updateCount += 1;
				if(op==1){
					op = 0;
				}
				getNodeInfo(nodeID);
			}
		});
		return false;
	}
	
	function setButton(){
		$("#btnRedo").hide();
		$("#btnDo").hide();
		$("#btnSave").hide();
		$("#btnCancel").hide();
		$("#btnPrint").hide();
		if(op == 1){
			$("#btnDo").show();
			$("#certName").textbox("setValue", item);
			$("#qty").textbox("setValue", keyID);
			setEmpty();
		}
		if(op==0 && checkPermission("diplomaAdd")){
			$("#btnRedo").show();
		}
		if(op==0 && checkPermission("diplomaCancel")){
			$("#btnCancel").show();
		}
		if(op==0 && (checkPermission("diplomaPrint") || checkPermission("diplomaAdd"))){
			$("#btnSave").show();
		}
	}
	
	function setEmpty(){
		$("#startDate").datebox("setValue", currDate);
		$("#styleID").combobox("setValue", 1);
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr><input type="hidden" id="certID" /><input type="hidden" id="ID" /><input type="hidden" id="host" />
				<td align="right">证书</td>
				<td><input id="certName" name="certName" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				<td align="right">证书样式</td>
				<td>
					<select id="styleID" name="styleID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100"></select>
					&nbsp;&nbsp;数量&nbsp;<input id="qty" name="qty" class="easyui-textbox" data-options="height:22,width:50,readonly:true" />
				</td>
			</tr>
			<tr>
				<td align="right">最小序号</td>
				<td><input id="firstID" name="firstID" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				<td align="right">最大序号</td>
				<td><input id="lastID" name="lastID" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
			</tr>
			<tr>
				<td align="right">发证日期</td>
				<td><input id="startDate" name="startDate" class="easyui-datebox" data-options="height:22,width:100" /></td>
				<td align="right">资料</td>
				<td>
					<span id="list" style="margin-left:10px;"></span>
					<span id="doc" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:195" /></td>
				<td align="right">制作</td>
				<td>
					<input id="regDate" name="regDate" class="easyui-textbox" data-options="height:22,width:100,readonly:true" />&nbsp;&nbsp;
					<input id="registerName" name="registerName" class="easyui-textbox" data-options="height:22,width:80,readonly:true" />
				</td>
			</tr>
			<tr>
				<td align="left" colspan="4">
				&nbsp;证书打印&nbsp;<input class="easyui-checkbox" id="printed" value="1"/>&nbsp;&nbsp;<input id="printDate" name="printDate" class="easyui-datebox" data-options="height:22,width:100" />
				&nbsp;&nbsp;&nbsp;&nbsp;证书发放&nbsp;<input class="easyui-checkbox" id="delivery" value="1"/>&nbsp;&nbsp;<input id="deliveryDate" name="deliveryDate" class="easyui-datebox" data-options="height:22,width:100" />
				</td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>

	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="buttonbox">
		<a class="easyui-linkbutton" id="btnSave" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="btnDo" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="btnRedo" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="btnPrint" href="javascript:void(0)"></a>
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="buttonbox">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;">
			<a class="easyui-linkbutton" id="btnSel" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="btnCancel" href="javascript:void(0)"></a>
		</div>
  	</div>

	<hr size="1" noshadow />
	<div id="dimplomaListByBatch">
	</div>
</div>
</body>
