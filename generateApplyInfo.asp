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
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.19">
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

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var op = 0;
	var updateCount = 0;
	var address = "";
    var certID = "";
	var price1 = 0;
	var agencyID = 0;
	var reexamine = 0;
	var timer1 = null;
	var courseName = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//ID
		refID = "<%=refID%>";		//
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		getComboBoxList("statusApply","s_status",1);
		getComboBoxList("statusNo","s_resit",1);
		getComboBoxList("applyKind","kindID",0);
		getComboList("courseID","v_courseInfo","courseID","courseName2","status=0 and mark=1",1);

		$("#sendMsgExam").click(function(){
			if(address==""){
				$.messager.alert("提示","请填写考试地址并保存。","info");
				return false;
			}
			jConfirm("确定向这批考生发送考试通知吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.getJSON(uploadURL + "/public/send_message_exam_apply?SMS=1&batchID=" + nodeID + "&registerID=" + currUser ,function(data){
						if(data>""){
							$.messager.alert("提示","通知发送成功。","info");
							getNodeInfo(nodeID);
						}else{
							$.messager.alert("提示","没有可供处理的数据。","info");
						}
					});
				}
			});
		});

		$("#sendMsgScore").click(function(){
			jConfirm("确定向这批考生发送成绩单吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.getJSON(uploadURL + "/public/send_message_score_apply?SMS=1&batchID=" + nodeID + "&registerID=" + currUser ,function(data){
						if(data>""){
							$.messager.alert("提示","通知发送成功。","info");
							getNodeInfo(nodeID);
						}else{
							$.messager.alert("提示","没有可供处理的数据。","info");
						}
					});
				}
			});
		});

		$("#sendMsgDiploma").click(function(){
			getSelCart("");
			if(selCount==0){
				$.messager.alert("提示","请选择要通知的人员。","info");
				return false;
			}
			jConfirm("确定通知这些人领证吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.post(uploadURL + "/public/send_message_diploma_apply?SMS=1&batchID=" + nodeID + "&registerID=" + currUser,{"selList":selList} ,function(data){
						if(data>""){
							$.messager.alert("提示","通知发送成功。","info");
							getNodeInfo(nodeID);
						}else{
							$.messager.alert("提示","没有可供处理的数据。","info");
						}
					});
				}
			});
		});

		$("#btnSave").linkbutton({
			iconCls:'icon-save',
			width:70,
			height:25,
			text:'保存',
			onClick:function() {
				saveNode();
			}
		});

		$("#btnDel").linkbutton({
			iconCls:'icon-cancel',
			width:70,
			height:25,
			text:'删除',
			onClick:function() {
				if($("#qty").text()>0){
					$.messager.alert("提示","该批申报还有考生，请将其清空后再删除。","info");
					return false;
				}
				jConfirm('你确定要删除申报信息吗?', '确认对话框', function(r) {
					if(r){
						$.get("diplomaControl.asp?op=delGenerateApply&nodeID=" + nodeID + "&&times=" + (new Date().getTime()),function(data){
							$.messager.alert("提示","成功删除！","info");
							op = 1;
							setButton();
							updateCount += 1;
						});
					}
				});
			}
		});

		$("#close").linkbutton({
			iconCls:'icon-archive',
			width:70,
			height:25,
			text:'存档',
			onClick:function() {
				if(confirm('确定要结束本次申报吗?')){
					$.get("diplomaControl.asp?op=closeGenerateApply&nodeID=" + $("#ID").val() + "&refID=2&times=" + (new Date().getTime()),function(data){
						jAlert("已关闭申报","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			}
		});
		$("#lock").linkbutton({
			iconCls:'icon-lock',
			width:70,
			height:25,
			text:'锁定',
			onClick:function() {
				if(confirm('确定要锁定本次申报吗? 将无法调整考生名单。')){
					$.get("diplomaControl.asp?op=closeGenerateApply&nodeID=" + $("#ID").val() + "&refID=1&times=" + (new Date().getTime()),function(data){
						jAlert("已锁定申报","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			}
		});
		$("#open").linkbutton({
			iconCls:'icon-unlock',
			width:70,
			height:25,
			text:'开启',
			onClick:function() {
				if(confirm('确定要重新开启本次申报吗? 如果有人员调整，请注意重新生成数据。')){
					$.get("diplomaControl.asp?op=closeGenerateApply&nodeID=" + $("#ID").val() + "&refID=0&times=" + (new Date().getTime()),function(data){
						jAlert("已重新开启申报，请及时关闭或锁定。","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			}
		});
		$("#adjustClassDate").linkbutton({
			iconCls:'icon-gear',
			width:120,
			height:25,
			text:'调整报名日期',
			onClick:function() {
				if(confirm('确定要自动调整学员的报名日期吗? 只处理晚于培训开始日期的人员。')){
					$.get("diplomaControl.asp?op=adjustClassDate&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(data){
						$.messager.alert("提示","已调整完毕。","info");
						getApplyList();
						updateCount += 1;
					});
				}
			}
		});

		$("#btnRemove").linkbutton({
			iconCls:'icon-cut',
			width:70,
			height:25,
			text:'移除',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要移除的人员。","info");
					return false;
				}
				jConfirm('确定要将这' + selCount + '个人从本次申报移除吗?', "确认对话框",function(r){
					if(r){
						$.post("diplomaControl.asp?op=remove4GenerateApply&refID=" + nodeID, {"selList":selList},function(data){
							//jAlert(data);
							$.messager.alert("提示","已成功移除","info");
							getNodeInfo(nodeID);
							updateCount += 1;
						});
					}
				});
			}

		});

		$("#doApplyEnter").linkbutton({
			iconCls:'icon-gear',
			width:85,
			height:25,
			text:'自动报名',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要报名的人员。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人报名吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						// $.post(uploadURL + "/public/applyEnter?SMS=1&reexamine=" + reexamine + "&registerID=" + currUser,{"selList":selList} ,function(data){
						// 	//jAlert(data);
						// 	if(data.err==0){
						// 		jAlert("成功报名数量：" + data.count_s + "; 失败数量：" + data.count_e,"信息提示");
						// 		getApplyList();
						// 	}else{
						// 		jAlert("操作失败：" + data.errMsg,"信息提示");
						// 	}
						// });
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=" + reexamine + "&register=" + currUserName + "&host=" + currHost + "&classID=1&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":selList},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								//jAlert(data);
								if(data.err==0){
									var end = performance.now(); 
									jAlert("成功报名数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","信息提示");
								}else{
									jAlert("操作失败，请稍后再试。" + data.errMsg,"信息提示");
								}
								if($("#showPhoto").checkbox("options").checked){
									$("#showPhoto").checkbox({checked:false});
								}else{
									getApplyList();
								}
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							}
						});
					}
				});
			}
		});

		$("#doApplyUpload").linkbutton({
			iconCls:'icon-upload',
			width:85,
			height:25,
			text:'自动上传',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要上传报名表的人员。","info");
					return false;
				}
				if($("#applyID").textbox("getValue")==""){
					$.messager.alert("提示","请填写开班编号并保存。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人上传报名表吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						// $.post(uploadURL + "/public/applyEnter?SMS=1&reexamine=" + reexamine + "&registerID=" + currUser,{"selList":selList} ,function(data){
						// 	//jAlert(data);
						// 	if(data.err==0){
						// 		jAlert("成功报名数量：" + data.count_s + "; 失败数量：" + data.count_e,"信息提示");
						// 		getApplyList();
						// 	}else{
						// 		jAlert("操作失败：" + data.errMsg,"信息提示");
						// 	}
						// });
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=9&register=" + currUserName + "&host=" + currHost + "&classID=" + $("#applyID").textbox("getValue") + "&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":selList},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								//jAlert(data);
								if(data.err==0){
									var end = performance.now(); 
									jAlert("成功上传数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","信息提示");
								}else{
									jAlert("操作失败，请稍后再试。" + data.errMsg,"信息提示");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							}
						});
					}
				});
			}
		});

		$("#doApplyUploadPhoto").linkbutton({
			iconCls:'icon-upload',
			width:85,
			height:25,
			text:'上传照片',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要上传照片的人员。","info");
					return false;
				}
				if($("#applyID").textbox("getValue")==""){
					$.messager.alert("提示","请填写开班编号并保存。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人上传照片吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=8&register=" + currUserName + "&host=" + currHost + "&classID=" + $("#applyID").textbox("getValue") + "&courseName=" + $("#courseName").val() + "&reex=" + ((reexamine==0?"初证":"复审")),
							type: "post",
							data: {"selList":selList},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								//jAlert(data);
								if(data.err==0){
									var end = performance.now(); 
									jAlert("成功上传数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","信息提示");
								}else{
									jAlert("操作失败，请稍后再试。" + data.errMsg,"信息提示");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							}
						});
					}
				});
			}
		});
		
		$("#doApplyUploadSchedule").linkbutton({
			iconCls:'icon-upload',
			width:85,
			height:25,
			text:'上传课表',
			onClick:function() {
				if($("#applyID").textbox("getValue")==""){
					$.messager.alert("提示","请填写开班编号并保存。","info");
					return false;
				}
				if($("#adviserID").combobox("getValue")==""){
					$.messager.alert("提示","请选择班主任并保存。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要上传班级课表吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=7&register=" + currUserName + "&host=" + currHost + "&classID=" + $("#applyID").textbox("getValue") + "&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":$("#adviserID").combobox("getText")},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								//jAlert(data);
								if(data.err==0){
									var end = performance.now(); 
									jAlert("成功上传数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","信息提示");
								}else{
									jAlert("操作失败，请稍后再试。" + data.errMsg,"信息提示");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							},
							error: function () {
								$.messager.progress('close');
							}
						});
					}
				});
			}
		});

		$("#doApplyDownload").linkbutton({
			iconCls:'icon-download',
			width:85,
			height:25,
			text:'自动下载',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要下载成绩证书的人员。","info");
					return false;
				}
				if($("#applyID").textbox("getValue")==""){
					$.messager.alert("提示","请填写开班编号并保存。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人下载成绩和证书吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						// $.post(uploadURL + "/public/applyEnter?SMS=1&reexamine=" + reexamine + "&registerID=" + currUser,{"selList":selList} ,function(data){
						// 	//jAlert(data);
						// 	if(data.err==0){
						// 		jAlert("成功报名数量：" + data.count_s + "; 失败数量：" + data.count_e,"信息提示");
						// 		getApplyList();
						// 	}else{
						// 		jAlert("操作失败：" + data.errMsg,"信息提示");
						// 	}
						// });
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=10&register=" + currUserName + "&host=" + currHost + "&classID=" + $("#applyID").textbox("getValue") + "&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":selList, "kindID":0},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								//jAlert(data);
								if(data.err==0){
									var end = performance.now(); 
									jAlert("成功下载数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","信息提示");
								}else{
									jAlert("操作失败，请稍后再试。" + data.errMsg,"信息提示");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							}
						});
					}
				});
			}
		});

		$("#doApplyCheck").linkbutton({
			iconCls:'icon-ok',
			width:85,
			height:25,
			text:'复审核查',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要核查应复审日期的人员。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人核查应复审日期吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/diplomaCheck?host=" + currHost + "&register=" + currUserName,
							type: "post",
							data: {"selList":selList, "kindID":0},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								//jAlert(data);
								if(data.err==0){
									var end = performance.now(); 
									jAlert("成功核查数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","信息提示");
								}else{
									jAlert("操作失败，请稍后再试。" + data.errMsg,"信息提示");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							}
						});
					}
				});
			}
		});

		$("#list").click(function(){
			//alert(nodeID+$("#courseName").val()+$("#reexamineName").val());
			outputExcelBySQL('x05','file',nodeID,$("#courseName").val(),$("#reexamineName").val(),agencyID);
		});

		$("#diplomaSign").click(function(){
			outputExcelBySQL('x06','file',nodeID,$("#courseName").val(),$("#reexamineName").val());
		});

		$("#archive").click(function(){
			// window.open("class_archives.asp?nodeID=" + nodeID + "&keyID=1", "_self");
			outputExcelBySQL('x10','file',nodeID,$("#applyID").val()+' '+$("#courseName").val()+'('+$("#reexamineName").val()+')');
		});
		$("#checkin").click(function(){
			showClassCheckin(nodeID,"A","",0,1);
		});

		$("#courseID").combobox({
			onChange: function(val){
				var c = $("#courseID").combobox("getText");
				$("#title").textbox("setValue", c + currDate);
				$.get("diplomaControl.asp?op=getLastApplyAddress&refID=" + $("#courseID").combobox("getValue") + "&times=" + (new Date().getTime()),function(re){
					//alert(unescape(re));
					var ar = new Array();
					ar = unescape(re).split("|");
					if(ar > ""){
						$("#address").textbox("setValue",ar[0]);
					}
				});
			}
		});
		$("#closed").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});
		$("#needResit").checkbox({
			onChange: function(val){
				getApplyList();
				if(checkPermission("applyEdit") && $("#status").val()==1 && $("#kindID").combobox("getValue")==0 && val){
					$("#btnResit").show();
				}else{
					$("#btnResit").hide();
				}
			}
		});
		$("#needRetake").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});
		
		$("#btnSearch").linkbutton({
			iconCls:'icon-search',
			width:70,
			height:25,
			text:'查找',
			onClick:function() {
				getApplyList();
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
		
		$("#btnResit").linkbutton({
			iconCls:'icon-filter',
			width:80,
			height:25,
			text:'去补考',
			onClick:function() {
				if($("#status").val()==0){
					jAlert("请先结束申报，再安排补考。");
					return false;
				}
				getSelCart("");
				if(selCount==0){
					jAlert("请选择要申报的名单。");
					return false;
				}
				setSession("applyPicker", selList);
				showApplyPicker($("#courseID").combobox("getValue"), selCount, 1, "getApplyList()", 1);
			}
		});
		
		$("#doImportApply").linkbutton({
			iconCls:'icon-download',
			width:110,
			height:25,
			text:'导入申报结果',
			onClick:function() {
				showUploadFile(nodeID, "", "apply_list", "申报结果（考试安排）名单", "getNodeInfo(nodeID)",1, 1);
				updateCount += 1;
			}
		});
		
		$("#doImportScore").linkbutton({
			iconCls:'icon-download',
			width:110,
			height:25,
			text:'导入成绩证书',
			onClick:function() {
				showUploadFile(1, "", "apply_score_list", "成绩证书名单", "getNodeInfo(nodeID)",1, 1);
				updateCount += 1;
			}
		});
		
		$("#btnRetake").linkbutton({
			iconCls:'icon-rmb',
			width:85,
			height:25,
			text:'付费重修',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					jAlert("请选择要付费重修的名单。");
					return false;
				}
				jPrompt('确定这' + selCount + '个人要付费重修吗? \n请输入付费金额：',price1,"输入窗口",function(x){
					if(x && x>="0" && !isNaN(x)){
						$.post("diplomaControl.asp?op=retake4GenerateApply&refID=" + nodeID + "&keyID=" + x, {"selList":selList},function(data){
							//jAlert(data);
							jAlert("成功处理" + data + "条记录。","信息提示");
							getNodeInfo(nodeID);
							updateCount += 1;
						});
					}else{
						jAlert("金额错误","信息提示");
					}
				});
			}
		});
		
		$("#btnShutdown").linkbutton({
			iconCls:'icon-clear',
			width:70,
			height:25,
			text:'关闭',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					jAlert("请选择要关闭的名单。");
					return false;
				}
				jConfirm('确定要将这' + selCount + '个人关闭吗?', "确认对话框",function(r){
					if(r){
						$.post("diplomaControl.asp?op=shutdown4GenerateApply&refID=" + nodeID, {"selList":selList},function(data){
							//jAlert(data);
							jAlert("操作成功","信息提示");
							getNodeInfo(nodeID);
							updateCount += 1;
						});
					}
				});
			}
		});
	
		$("#generateMZip").click(function(){
			generateZip("m");
		});
	
		$("#generatePhotoZip").click(function(){
			generateZip("p");
		});
	
		$("#generateEZip").click(function(){
			generateZip("e");
		});
	
		$("#generateTZip").click(function(){
			generateZip("t");
		});
	
		$("#generateApplyZip").click(function(){
			generateZip("a");
		});
	
		$("#generateExamDoc").click(function(){
			getSelCart("");
			if(selCount==0){
				$.messager.alert("提示","请选择要操作的名单。","info");
				return false;
			}
			if(confirm("确定要生成这" + selCount + "个鉴定文档吗？")){
				$.post(uploadURL + "/outfiles/generate_emergency_exam_materials_byclass?refID=" + nodeID + "&keyID=3&registerID=" + currUser + "&host=" + currHost, {selList:selList}, function(data){
					if(data>"0"){
						// generateZip("e");
						alert("已生成" + data + "份文档");
						getApplyList();
					}else{
						alert("没有可供处理的数据。");
					}
				});
			}
		});
	
		$("#generateClassDoc").click(function(){
			getSelCart("");
			if(selCount==0){
				$.messager.alert("提示","请选择要操作的名单。","info");
				return false;
			}
			if(confirm("确定要生成这" + selCount + "个存档资料吗？")){
				$.post(uploadURL + "/outfiles/generate_emergency_exam_materials_byclass?refID=" + nodeID + "&keyID=2&registerID=" + currUser + "&host=" + currHost, {selList:selList}, function(data){
					if(data>"0"){
						// generateZip("e");
						alert("已生成" + data + "份文档");
						getApplyList();
					}else{
						alert("没有可供处理的数据。");
					}
				});
			}
		});
		/*
		$("#generateEntryDoc").click(function(){
			getSelCart("");
			if(selCount==0){
				$.messager.alert("提示","请选择要操作的名单。","info");
				return false;
			}
			if(confirm("确定要生成这" + selCount + "个报名表吗？")){
				$.post(uploadURL + "/outfiles/generate_emergency_exam_materials_byclass?refID=" + nodeID + "&keyID=5&registerID=" + currUser + "&host=" + currHost, {selList:selList}, function(data){
					if(data>"0"){
						// generateZip("e");
						alert("已生成" + data + "份文档");
						getApplyList();
					}else{
						alert("没有可供处理的数据。");
					}
				});
			}
		});
		*/
		$("#generateEntryDoc").click(function(){
			generateEntryDoc(0);
		});
	
		$("#generateEntryDoc1").click(function(){
			generateEntryDoc(1);
		});

		$("#btnProof").click(function(){
			$.get(uploadURL + "/outfiles/get_trainProof_shot?nodeID=" + nodeID, function(data){
				$.messager.alert("提示","已生成","info");
				getNodeInfo(nodeID);
			});
		});

		$("#showPhoto").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});

		$("#showWait").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});

		$("#showWaitUpload").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});
		
		$("#btnSchedule").click(function(){
			if($("#startDate").datebox("getValue")==""){
				jAlert("请确定开课日期。");
				return false;
			}
			if($("#teacher").combobox("getValue")==""){
				jAlert("请确定任课教师。");
				return false;
			}
			if($("#classroom").textbox("getValue")==""){
				jAlert("请确定上课地点。");
				return false;
			}
			if(confirm("确定要编排课表吗？")){
				$.get("classControl.asp?op=generateClassSchedule&refID=" + nodeID + "&kindID=A&times=" + (new Date().getTime()),function(re){
					if(re==0){
						getNodeInfo(nodeID);
						jAlert("课表编排完毕。");
					}else{
						jAlert("已有考勤记录，不能重新生成课表。");
					}
				});
			}
		});
		$("#schedule").click(function(){
			showClassSchedule(nodeID, "A", "{className:'" + nodeID + "', courseName:'" + courseName + "', transaction_id:'" + $("#applyID").textbox("getValue") + "', startDate:'"+$("#startDate").datebox("getValue").substr(0,10)+"', endDate:'', adviser:'" + $("#adviserID").find("option:selected").text() + "', qty:"+$("#qty").val()+"}",0,1);
		});

		if(op==1){
			setButton();
		}else{
			getNodeInfo(nodeID);
		}

	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("diplomaControl.asp?op=getGenerateApplyNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				getComboList("teacher","dbo.getFreeTeacherList('','" + ar[0] + "','A')","teacherID","teacherName","1=1 order by freePoint desc",1);
				getComboList("adviserID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser' and host='" + currHost + "') order by realName",1);
				$("#ID").val(ar[0]);
				$("#courseID").combobox("setValue",ar[1]);
				$("#kindID").combobox("setValue",ar[36]);
				$("#courseName").val(ar[2]);
				$("#title").textbox("setValue",ar[3]);
				$("#qty").html(ar[4]);
				$("#qtyYes").html(ar[21]);
				$("#qtyNo").html(ar[22]);
				$("#qtyNull").html(ar[23]);
				$("#applyID").textbox("setValue",ar[5]);
				$("#startDate").datebox("setValue",ar[6]);
				$("#endDate").datebox("setValue",ar[38]);
				$("#address").textbox("setValue",ar[11]);
				address = ar[11];
				$("#memo").textbox("setValue",ar[8]);
				$("#regDate").textbox("setValue",ar[9]);
				$("#registerName").textbox("setValue",ar[10]);
				$("#status").val(ar[15]);
				$("#statusName").textbox("setValue",ar[16]);
				$("#send").textbox("setValue",nullNoDisp(ar[12]));
				//$("#sendDate").val(ar[13]);
				$("#senderName").textbox("setValue",ar[14] + (ar[13]>""?"&nbsp;" + ar[13]:""));
				$("#sendScore").textbox("setValue",nullNoDisp(ar[18]));
				//$("#sendScoreDate").val(ar[19]);
				$("#senderScoreName").textbox("setValue",ar[20] + (ar[19]>""?"&nbsp;" + ar[19]:""));
				$("#reexamineName").val(ar[24]);
				certID = ar[31];
				price1 = ar[40];
				agencyID = ar[41];
				reexamine = ar[44];
				$("#adviserID").combobox("setValue",ar[45]);
				$("#teacher").combobox("setValue",ar[47]);
				$("#classroom").textbox("setValue",ar[48]);
				$("#scheduleDate").textbox("setValue",ar[49]);
				$("#uploadScheduleDate").datebox("setValue",ar[52]);
				if(ar[49]>""){
					$("#schedule").html("<a>课程表</a>");
				}
				$("#list").html("<a href='' style='text-decoration:none;color:green;'>申报名单</a>");
				$("#archive").html("<a href='' style='text-decoration:none;color:green;'>在线学时</a>");
				$("#diplomaSign").html("<a href='' style='text-decoration:none;color:green;'>证书签收单</a>");
				if(ar[7] > ""){
					$("#sign").html("<a href='/users" + ar[7] + "?" + (new Date().getTime()) + "' target='_blank' style='text-decoration:none;color:green;'>申报结果</a>");
				}
				if(ar[17] > ""){
					$("#scoreResult").html("<a href='/users" + ar[17] + "?" + (new Date().getTime()) + "' target='_blank' style='text-decoration:none;color:green;'>成绩单</a>");
                    $("#diplomaSign").show();
				}else{
                    $("#diplomaSign").hide();
                }
				if(ar[33] > ""){
					$("#mzip").html("<a href='/users" + ar[33] + "?" + (new Date().getTime()) + "' target='_blank' style='text-decoration:none;color:green;'>班级包</a>");
				}
				if(ar[34] > ""){
					$("#pzip").html("<a href='/users" + ar[34] + "?" + (new Date().getTime()) + "' target='_blank' style='text-decoration:none;color:green;'>照片包</a>");
				}
				if(ar[35] > ""){
					$("#ezip").html("<a href='/users" + ar[35] + "?" + (new Date().getTime()) + "' target='_blank' style='text-decoration:none;color:green;'>鉴定包</a>");
				}
				if(ar[42] > ""){
					$("#azip").html("<a href='/users" + ar[42] + "?" + (new Date().getTime()) + "' target='_blank' style='text-decoration:none;color:green;'>申报包</a>");
				}
				if(ar[43] > ""){
					$("#tzip").html("<a href='/users" + ar[43] + "?" + (new Date().getTime()) + "' target='_blank' style='text-decoration:none;color:green;'>报名表</a>");
				}
				if(ar[7] > ""){
					$("#proof").html("<a href='/users" + ar[7] + "?" + (new Date().getTime()) + "' target='_blank' style='text-decoration:none;color:green;'>&nbsp;&nbsp;培训证明</a>");
				}
				//getDownloadFile("generateDiplomaID");
				nodeID = ar[0];
				setButton();
				getApplyList();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//$.messager.progress();	// 显示进度条
		keyID = $("#courseID").combobox("getValue");
		$('#forms').form('submit', {   
			url: "diplomaControl.asp?op=updateGenerateApplyInfo&times=" + (new Date().getTime()),   
			onSubmit: function(){   
				//var isValid = $(this).form('validate');
				var isValid = true;
				if(op==1 && $("#courseID").textbox("getValue")==""){
					$.messager.alert("提示","请选择课程。","warning");
					isValid = false;
				}
				if($("#title").textbox("getValue")==""){
					$.messager.alert("提示","请填写标题。","warning");
					isValid = false;
				}
				if (!isValid){
					$.messager.progress('close');	// 如果表单是无效的则隐藏进度条
				}else{
					//$("#username").textbox("enable");	//先解除身份证只读，否则后台无法读取数据。
				}
				return isValid;	// 返回false终止表单提交
			},   
			success:function(data){  
				//alert(unescape(data));
				var ar = new Array();
				ar = unescape(data).split("|");
				if(ar[0]>0){
					updateCount += 1;
					nodeID = ar[0];
					if(op==1){
						op = 0;
					}
					$.messager.progress('close');	// 如果提交成功则隐藏进度条 
					getNodeInfo(nodeID);
					$.messager.alert("提示","保存成功。","info");
				}else{
					$.messager.alert("提示",ar[1],"warning");
				}
			}   
		});
	}

	function getApplyList(){
		var need = 0;
		var noclosed = 0;
		var photo = 0;
		var retake = 0;
		var wait = 0;
		var upload = 0;
		if($("#showPhoto").checkbox("options").checked){
			photo = 1;
		}
		if($("#showWait").checkbox("options").checked){
			wait = 1;
		}
		if($("#showWaitUpload").checkbox("options").checked){
			upload = 1;
		}
		if($("#needResit").checkbox("options").checked){ need = 1;}
		if($("#needRetake").checkbox("options").checked){ 
			retake = 1;	//初考
			if($("#kindID").combobox("getValue")==1){	//补考
				retake = 2;
			}
		}
		if($("#closed").checkbox("options").checked){ noclosed = 1;}

		$.get("diplomaControl.asp?op=getApplyListByBatch&refID=" + nodeID + "&status=" + $("#s_status").combobox("getValue") + "&keyID=" + $("#s_resit").combobox("getValue") + "&wait=" + wait + "&upload=" + upload + "&needResit=" + need + "&needRetake=" + retake + "&closed=" + noclosed + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='8%'>身份证</th>");
			arr.push("<th width='5%'>姓名</th>");
			arr.push("<th width='7%'>单位</th>");
			arr.push("<th width='5%'>证明</th>");
			arr.push("<th width='6%'>签名日期</th>");
			arr.push("<th width='6%'>复训日期</th>");
			arr.push("<th width='6%'>申报</th>");
			arr.push("<th width='5%'>上传</th>");
			arr.push("<th width='6%'>考试时间</th>");
			arr.push("<th width='5%'>成绩</th>");
			arr.push("<th width='5%'>结果</th>");
			if(photo == 0){
				// arr.push("<th width='7%'>去向</th>");
				arr.push("<th width='15%'>备注</th>");
			}else{
				// arr.push("<th width='7%'>考站签名</th>");
				arr.push("<th width='7%'>照片</th>");
				arr.push("<th width='6%'>签名</th>");
			}
			arr.push("<th width='3%'>鉴</th>");
			arr.push("<th width='3%'>班</th>");
			arr.push("<th width='3%'>传</th>");
			arr.push("<th width='1%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var k = 0;
				var s = $("#status").val();
				var imgChk = "<img src='images/green_check.png'>";
				let photo_size = 0;
				let photo_type = "jpg";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(\"" + ar1[2] + "\",\"" + ar1[4] + "\",0,1);'>" + ar1[4] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[4] + "\",0,1);'>" + ar1[5] + "</a></td>");
					arr.push("<td class='left' title='" + ar1[13] + "'>" + ar1[13].substring(0,6) + "</td>");
					h = "单位";
					if(ar1[33]==1 || ar1[13]=="个人"){
						h = "个人";
					}
					arr.push("<td class='left'>" + h + "</td>");
					arr.push("<td class='left'>" + ar1[35] + "</td>");
					arr.push("<td class='left' " + (ar1[40]==1?"style='color:blue;' title='已确认'":"") + ">" + ar1[39] + "</td>");	// 复训日期
					arr.push("<td class='left'>" + ar1[28] + "</td>");
					arr.push("<td class='left'>" + (ar1[37]==1?imgChk:'&nbsp;') + "</td>");	// 上传
					arr.push("<td class='left' title='" + ar1[18] + "'>" + ar1[18].substring(0,10) + "</td>");
                    h = nullNoDisp(ar1[19].replace(".00",""));
                    if(ar1[27]==1){	//有应会成绩
                        h = (ar1[20]>"0"? h + "/" + ar1[20].replace(".00",""):h);
                    }
					arr.push("<td class='left'>" + h + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");	// 结果
					// if(ar1[7]>0){
					// 	arr.push("<td class='center'>" + imgChk + "</td>");	//补考
					// }else{
					// 	arr.push("<td class='center'>&nbsp;</td>");
					// }
					if(photo == 0){
						// arr.push("<td class='left'>" + ar1[34] + "</td>");	// 去向
						arr.push("<td class='link1'><a href='javascript:showMsg(\"" + ar1[38] + "\",\"历史数据\");'>" + ar1[10] + "</a></td>");	// 备注
					}else{
						// arr.push("<td class='left'>" + ar1[36] + "</td>");	// 考站签名
						photo_type = ar1[30].substr(ar1[30].indexOf("."));
						photo_size = ar1[32];
						if(photo_size > 100 || photo_type !== ".jpg"){	//根据照片类型或文件大小，显示不同背景颜色
							h = " style='background-color:#FFFFAA;'";
						}else{
							h = "";
						}
						if(ar1[30] > ""){	//照片
							arr.push("<td class='center'" + h + "><img id='photo" + ar1[4] + "' title='大小：" + photo_size + "k, 类型：" + photo_type + "' src='users" + ar1[30] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[30] + "\",\"" + ar1[4] + "\",\"photo\",\"\",0,1)' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'" + h + ">&nbsp;</td>");
						}
						if(ar1[31] > ""){	//签字
							arr.push("<td class='center'><img src='users" + ar1[31] + "?times=" + (new Date().getTime()) + "' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
					}
					if(s==0){
						k = ar1[0];
					}else{
						k = ar1[2];
					}
					if(ar1[25]==''){
						arr.push("<td class='center'><div id='materialExam" + ar1[2] + "'><span onclick='generateMaterialsExam(" + ar1[2] + ",\"" + ar1[4] + "\",\"" + ar1[29] + "\")' title='鉴定归档资料'><img src='images/addDoc.png' style='width:15px;'><span><div></td>");
					}else{
						arr.push("<td class='center'><a href='javascript:void(0);' title='鉴定归档资料' onclick='openMaterial(\"/users" + ar1[25] + "?t=" + (new Date().getTime()) + "\");' ondblclick='generateMaterialsExam(" + ar1[2] + ",\"" + ar1[4] + "\",\"" + ar1[29] + "\")' title='鉴定归档资料'>" + imgFile + "</a></td>");
					}
					if(ar1[24]==''){
						arr.push("<td class='center'><div id='material" + ar1[2] + "'><span onclick='generateMaterials(" + ar1[2] + ",\"" + ar1[4] + "\",\"" + ar1[29] + "\")' title='班级归档资料'><img src='images/addDoc.png' style='width:15px;'><span><div></td>");
					}else{
						arr.push("<td class='center'><a href='javascript:void(0);' title='班级归档资料' onclick='openMaterial(\"/users" + ar1[24] + "?t=" + (new Date().getTime()) + "\");' ondblclick='generateMaterials(" + ar1[2] + ",\"" + ar1[4] + "\",\"" + ar1[29] + "\")' title='申报材料'>" + imgFile + "</a></td>");
					}
					if(ar1[26]==''){
						arr.push("<td class='center'></td>");
					}else{
						arr.push("<td class='center'><a href='javascript:void(0);' title='申报材料' onclick='showPic(\"" + ar1[26] + "\");' title='申报材料'>" + imgFile + "</a></td>");
					}
					arr.push("<td class='left'><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchk'></td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			if(photo != 0){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
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

	function generateMaterials(enterID,username,entryForm){
		clearTimeout(timer1);
		if(confirm("确定要生成报名资料吗？")){
			$.getJSON(uploadURL + "/outfiles/generate_emergency_materials?refID=" + username + "&nodeID=" + enterID + "&entryform=" + entryForm + "&host=" + currHost ,function(data){
				if(data>""){
					alert("已生成文件");
					$("#material" + enterID).html("<a href='/users" + data + "?t=" + (new Date().getTime()) + "' target='_blank' title='班级归档资料'>" + imgFile + "</a>");
				}else{
					alert("没有可供处理的数据。");
				}
			});
		}
	}

	function generateMaterialsExam(enterID,username,entryForm){
		clearTimeout(timer1);
		$.messager.confirm("提示","确定要生成鉴定归档材料吗？",function(r){
			if(r){
				$.getJSON(uploadURL + "/outfiles/generate_emergency_materials_exam?refID=" + username + "&nodeID=" + enterID + "&entryform=" + entryForm ,function(data){
					if(data>""){
						$.messager.alert("提示","已生成文件","info");
					$("#materialExam" + enterID).html("<a href='/users" + data + "?t=" + (new Date().getTime()) + "' target='_blank' title='鉴定归档资料'>" + imgFile + "</a>");
					}else{
						$.messager.alert("提示","没有可供处理的数据。","warning");
					}
				});
			}
		});
	}

	function openMaterial(path){
		clearTimeout(timer1);
		timer1=setTimeout(function(){
			window.open(path);
		},300);
	}

	function showPic(path){
		showImage(path,2,1.5,0,1);
	}

	function generateZip(t){
		var url = uploadURL + "/outfiles/generate_material_zip?refID=" + nodeID + "&kind=apply&type=" + t;
		if(agencyID==7 && t =="a"){
			url = uploadURL + "/outfiles/generate_building_material_zip?refID=" + nodeID;
		}
		
		$.getJSON(url, function(data){
			$.ajaxSettings.async = false;    //将getJSO()方法设置为同步操作的方法 
			if(data>""){
				alert("已生成压缩包");
				getNodeInfo(nodeID);
			}else{
				alert("没有可供处理的数据。");
			}
		});
	}

	function generateEntryDoc(k){
		//k: 0 普通  1 带培训证明
		getSelCart("");
		if(selCount==0){
			$.messager.alert("提示","请选择要操作的名单。","info");
			return false;
		}
		if(confirm("确定要生成这" + selCount + "个报名表吗？")){
			$.post(uploadURL + "/outfiles/generate_emergency_exam_materials_byclass?refID=" + nodeID + "&keyID=5&registerID=" + currUser + "&kindID=" + k + "&host=" + currHost, {selList:selList}, function(data){
				if(data>"0"){
					$.messager.alert("提示","已生成" + data + "份文档","info");
					getApplyList();
				}else{
					$.messager.alert("提示","没有可供处理的数据。","info");
				}
			});
		}
	}
	
	function setButton(){
		var s = $("#status").val();
		var k = $("#kindID").combobox("getValue");
		$("#btnSave").hide();
		$("#btnDel").hide();
		$("#lock").hide();
		$("#close").hide();
		$("#open").hide();
		$("#btnZip").hide();
		$("#btnGen").hide();
		$("#generateApplyZip").hide();
		// $("#generateMZip").hide();
		$("#azip").hide();
		$("#doImportApply").hide();
		$("#doImportScore").hide();
		$("#doApplyUploadPhoto").hide();
		$("#doApplyUploadSchedule").hide();
		// $("#generateEZip").hide();
		// $("#generateExamDoc").prop("disabled",true);
		$("#sendMsgExam").prop("disabled",true);
		$("#sendMsgScore").prop("disabled",true);
		$("#sendMsgDiploma").hide();
		$("#btnRemove").hide();
		$("#s_needResit").hide();
		$("#s_close").hide();
		$("#btnRetake").hide();
		$("#btnShutdown").hide();
		$("#btnResit").hide();
		$("#doApplyEnter").hide();
		$("#doApplyUpload").hide();
		$("#doApplyDownload").hide();
		$("#doApplyCheck").hide();
		$("#adjustClassDate").hide();
		// $("#generateClassDoc").hide();
		// $("#generateExamDoc").hide();
		// $("#generateZip").prop("disabled",true);
		// $("#generatePhotoZip").prop("disabled",true);
		// $("#generateEntryZip").prop("disabled",true);
		// $("#generateApplyZip").prop("disabled",true);
		if(op==1){
			setEmpty();
			$("#btnSave").show();
			//$("#save").focus();
		}else{
			if(checkPermission("applyEdit")){
				if(s==0){		//考前可以删除申报、调整人员
					$("#btnSave").show();
					$("#btnDel").show();
					$("#lock").show();
					$("#btnRemove").show();
				}
				if(s==1){		//锁定后可以导入申报结果，发考试通知，上传成绩，发成绩通知，安排补考
					$("#btnSave").show();
					$("#sendMsgExam").prop("disabled",false);
					$("#s_needResit").show();
					$("#btnShutdown").show();
				}
				if(s==2){
					//结束后什么都不能做
					$("#sendMsgScore").prop("disabled",false);
					$("#sendMsgDiploma").show();
				}
				if(s<2){
					$("#close").show();
					$("#btnGen").show();
					$("#btnZip").show();
					$("#adjustClassDate").show();
					if(agencyID==1){
						$("#doApplyEnter").show();	// 应急局项目可以自动报名
						$("#doApplyUpload").show();	// 
						$("#doApplyUploadPhoto").show();
						$("#doApplyDownload").show();	//
						if(currUser=="desk"){ 
							$("#doApplyCheck").show();	// 
						}
					}
					// $("#generateZip").prop("disabled",false);
					// $("#generatePhotoZip").prop("disabled",false);
					// $("#generateEntryZip").prop("disabled",false);
					// $("#generateApplyZip").prop("disabled",false);
				}
			}
			if(checkPermission("applyEdit") && s == 1){
				// $("#doImportApply").show();
				// $("#doImportScore").show();
			}
			if(checkPermission("applyOpen") && s > 0){
				$("#open").show();
			}
			if(checkPermission("applyEdit") && k == 0){	//初考批次，可以安排缴费重读或结束
				$("#btnRetake").show();
				$("#btnShutdown").show();
			}
			if(checkPermission("applyEdit") && k == 1){	//补考批次，不能安排补考，可以安排缴费重读或结束
				// $("#doImportApply").show();
				// $("#doImportScore").show();
				// $("#lock").hide();
				// $("#close").hide();
				$("#s_needResit").hide();
				$("#btnRetake").show();
				$("#btnShutdown").show();
				if($("#qty").text()>0){
					$("#btnDel").hide();
				}
			}
			if(k == 1){	
				$("#s_close").show();
				$("#closed").checkbox("check");
			}
		}
	}
	
	function setEmpty(){
		$("#startDate").datebox("setValue",currDate);
		$("#kindID").combobox("setValue",0);
		$("#title").textbox("setValue","");
		$("#ID").val(0);
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="forms" method="post" style="width:98%;float:right;margin:1px;padding-left:1px;background:#eefaf8;">
			<table>
			<tr><input type="hidden" id="ID" name="ID" /><input type="hidden" id="status" /><input type="hidden" id="reexamineName" /><input type="hidden" id="courseName" />
				<td align="right">申报科目</td>
				<td colspan="3"><select id="courseID" name="courseID" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:300"></select>
					&nbsp;&nbsp;&nbsp;&nbsp;类别&nbsp;<select id="kindID" name="kindID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100"></select>
				</td>
			</tr>
			<tr>
				<td align="right">申报标题</td>
				<td colspan="3"><input id="title" name="title" class="easyui-textbox" data-options="height:22,width:300,required:true" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;状态&nbsp;<input id="statusName" name="statusName" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
			</tr>
			<tr>
				<td align="right">开班编号</td>
				<td><input id="applyID" name="applyID" class="easyui-textbox" data-options="height:22,width:210" /></td>
				<td align="right">培训日期</td>
				<td>
					<input id="startDate" name="startDate" class="easyui-datebox" data-options="height:22,width:100" />&nbsp;&nbsp;
					<input id="endDate" name="endDate" class="easyui-datebox" data-options="height:22,width:100" />
				</td>
			</tr>
			<tr>
				<td align="right">考试地址</td>
				<td>
					<input id="address" name="address" class="easyui-textbox" data-options="height:22,width:220" />
				</td>
				<td align="right"><input class="button" type="button" id="btnSchedule" value="排课表" /></td>
				<td><input id="scheduleDate" name="scheduleDate" class="easyui-datebox" data-options="height:22,width:100,readonly:true" />&nbsp;&nbsp;<span id="schedule" style="margin-left:10px;"></span>&nbsp;&nbsp;<span id="checkin" style="margin-left:10px;">考勤</span></td>
			</tr>
			<tr>
				<td align="right">任课教师</td>
				<td colspan="3">
					<select id="teacher" name="teacher" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100">></select>
					&nbsp;&nbsp;教室&nbsp;<input id="classroom" name="classroom" class="easyui-textbox" data-options="height:22,width:180" />
					&nbsp;&nbsp;班主任&nbsp;<select id="adviserID" name="adviserID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100">></select>
				</td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:210" /></td>
				<td align="right">经办</td>
				<td>
					<input id="regDate" name="regDate" class="easyui-textbox" data-options="height:22,width:100,readonly:true" />&nbsp;&nbsp;
					<input id="registerName" name="registerName" class="easyui-textbox" data-options="height:22,width:100,readonly:true" />
				</td>
			</tr>
			<tr>
				<td align="right"><input class="button" type="button" id="sendMsgExam" value="考试通知" /></td>
				<td>
					次数&nbsp;<input id="send" name="send" class="easyui-textbox" data-options="height:22,width:20,readonly:true" />&nbsp;&nbsp;
					发送&nbsp;<input id="senderName" name="senderName" class="easyui-textbox" data-options="height:22,width:125,readonly:true" />
				</td>
				<td align="right"><input class="button" type="button" id="sendMsgScore" value="成绩通知" /></td>
				<td>
					次数&nbsp;<input id="sendScore" name="sendScore" class="easyui-textbox" data-options="height:22,width:20,readonly:true" />&nbsp;&nbsp;
					发送&nbsp;<input id="senderScoreName" name="senderScoreName" class="easyui-textbox" data-options="height:22,width:125,readonly:true" />
				</td>
			</tr>
			<tr>
				<td align="right">申报统计</td>
				<td>
					人数:<span id="qty" style="margin-left:2px;"></span>&nbsp;&nbsp;
					待申:<span id="qtyNull" style="margin-left:2px;"></span>&nbsp;&nbsp;
					通过:<span id="qtyYes" style="margin-left:2px;"></span>&nbsp;&nbsp;
					未通过:<span id="qtyNo" style="margin-left:2px;"></span>
				</td>
				<td colspan="2">
					<span id="list" style="margin-left:2px;"></span>&nbsp;&nbsp;
					<span id="archive" style="margin-left:2px;"></span>&nbsp;&nbsp;
					<span id="sign" style="margin-left:2px;"></span>&nbsp;&nbsp;
					<span id="scoreResult" style="margin-left:2px;"></span>&nbsp;&nbsp;
					<span id="diplomaSign" style="margin-left:2px;"></span>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="4">
					<span id="btnGen">
						<label style="color:orange;font-size:1.2em;">生成</label><input class="button" type="button" id="generateExamDoc" value="鉴定文档" />
						<input class="button" type="button" id="generateClassDoc" value="班级文档" />
						<input class="button" type="button" id="generateEntryDoc" value="报名表" />
						<input class="button" type="button" id="generateEntryDoc1" value="报名表带证明" />
						<input class="button" type="button" id="btnProof" value="培训证明" />
					</span>
					<span id="btnZip">
						<label style="color:orange;font-size:1.2em;">打包</label><input class="button" type="button" id="generateEZip" value="鉴定包" />
						<input class="button" type="button" id="generatePhotoZip" value="照片包" />
						<input class="button" type="button" id="generateMZip" value="班级包" />
						<input class="button" type="button" id="generateTZip" value="报名表" />
						<input class="button" type="button" id="generateApplyZip" value="申报包" />&nbsp;
					</span>
					<label style="color:orange;font-size:1.2em;">下载</label>
					<span id="pzip" style="margin-left:2px;"></span>&nbsp;&nbsp;
					<span id="ezip" style="margin-left:2px;"></span>&nbsp;&nbsp;
					<span id="mzip" style="margin-left:2px;"></span>&nbsp;&nbsp;
					<span id="tzip" style="margin-left:2px;"></span>&nbsp;&nbsp;
					<span id="azip" style="margin-left:2px;"></span>&nbsp;&nbsp;
					<span id="proof" style="margin-left:2px;"></span>
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
		<a class="easyui-linkbutton" id="btnDel" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="lock" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="open" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="close" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="doImportApply" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="doImportScore" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="adjustClassDate" href="javascript:void(0)"></a>
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div class="buttonbox">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;">
			<a class="easyui-linkbutton" id="btnSearch" href="javascript:void(0)"></a>&nbsp;&nbsp;
			<span>申报结果&nbsp;<select id="s_status" name="s_status" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select></span>
			<span id="s_needResit">
				&nbsp;&nbsp;安排补考&nbsp;<select id="s_resit" name="s_resit" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>
				&nbsp;&nbsp;<input class="easyui-checkbox" id="needRetake" name="needRetake" value="1" />&nbsp;需重修&nbsp;
				&nbsp;&nbsp;<input class="easyui-checkbox" id="needResit" name="needResit" value="1" />&nbsp;需补考&nbsp;
				<a class="easyui-linkbutton" id="btnResit" href="javascript:void(0)"></a>
			</span>
			<span id="s_close">
				&nbsp;&nbsp;<input class="easyui-checkbox" id="closed" name="closed" value="1"/>&nbsp;未关闭&nbsp;
			</span>
			<a class="easyui-linkbutton" id="btnSel" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="btnRetake" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="btnShutdown" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="btnRemove" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="sendMsgDiploma" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="doApplyEnter" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="doApplyUpload" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="doApplyUploadPhoto" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="doApplyUploadSchedule" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="doApplyDownload" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="doApplyCheck" href="javascript:void(0)"></a>
			&nbsp;&nbsp;<input class="easyui-checkbox" id="showPhoto" name="showPhoto" checked value="1"/>&nbsp;显示照片&nbsp;
			&nbsp;&nbsp;<input class="easyui-checkbox" id="showWait" name="showWait" value="1"/>&nbsp;未报名&nbsp;
			&nbsp;&nbsp;<input class="easyui-checkbox" id="showWaitUpload" name="showWaitUpload" value="1"/>&nbsp;未上传&nbsp;
		</div>
	</div>
	<hr size="1" noshadow />
	<div id="cover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
</div>
</body>
