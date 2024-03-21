<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title></title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
	<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.18">
	<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script src="js/jquery.alerts.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<style>
    .img-select img {
        width: 50px;
        height: auto;
    }

    .dialog-bg {
        display: none;
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        background: rgba(0,0,0,0.4);
    }
	.dialog-bg .img-box {
		width: 400px;
		height: auto;
		position: absolute;
		left: 50%;
		right: 50%;
		transform: translateX(-50%);
	}

	.dialog-bg .img-box img {
		width: 100%;
		height: 100%;
	}
</style>
<script language="javascript">
	var nodeID = "";
	var refID = "";
	var keyID = 0;
	var op = 0;
	var updateCount = 0;
	var lastone_item = new Array();
	var entryform = "";
	var refAlert = "";
	var sk = [0,0];
	var sk1 = [1980,8];
	var reDo = "";
	var psswd = "";
	var price = 0;
	var price1 = 0;
	var course = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//enterID
		refID = "<%=refID%>";	//username
		keyID = "<%=keyID%>";	//courseID
		op = "<%=op%>";

		getComboBoxList("IDkind","kindID",0);
		getComboBoxList("payNow","payNow",0);
		getComboBoxList("payType","pay_type",0);
		getComboBoxList("statusPay","pay_status",0);
		getComboBoxList("signatureType","signatureType",0);
		getComboBoxList("channel","channel",1);
		let host = currHost;
		if(currPartner == 10){	//考匠使用自己的销售名单
			host = "jiang";
		}
        getComboList("sales","userInfo","username","realName","status=0 and host='" + host + "' and username in(select username from roleUserList where roleID='saler') order by realName",1);
        getComboList("partnerID","partnerInfo","ID","title","status=0 and host='" + currHost + "' order by ID",1);
		getComboList("courseID","v_courseInfo","courseID","courseName1","status=0 order by seq",1);
		getComboList("agencyID","agencyInfo","agencyID","title","status=0 order by seq",1);

		$.ajaxSetup({ 
			async: false 
		}); 
		
		$("#smsList").linkbutton({
			iconCls:'icon-search',
			width:85,
			height:25,
			text:'查看通知',
			onClick:function() {
				showStudentSmsList(refID,0,0,1);
			}
		});

		$("#examList").linkbutton({
			iconCls:'',
			width:65,
			height:25,
			text:'查看考试',
			onClick:function() {
				showStudentExamList(refID,$("#name").textbox("getValue"),0,1);
			}
		});

		$("#opList").linkbutton({
			iconCls:'',
			width:65,
			height:25,
			text:'查看操作',
			onClick:function() {
				showStudentOpList(nodeID,"",0,1);
			}
		});

		$("#signList").linkbutton({
			iconCls:'',
			width:65,
			height:25,
			text:'查看签到',
			onClick:function() {
				showStudentSignList(nodeID,$("#name").textbox("getValue"),0,1);
			}
		});

		$("#btnSave").linkbutton({
			iconCls:'icon-save',
			width:65,
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
				jPrompt("请输入删除原因：","","输入窗口",function(x){
					if(x && x>""){
						jConfirm("确实要删除报名记录吗？", "确认对话框",function(r){
							if(r){
								$.get("studentCourseControl.asp?op=delNode&nodeID=" + $("#ID").val() + "&where=" + escape(x) + "&times=" + (new Date().getTime()),function(re){
									var ar = unescape(re).split("|");
									jAlert(ar[1]);
									if(ar[0]==0){
										updateCount += 1;
										op = 1;
										setButton();
									}
								});
							}
						});
					}
				});
			}
		});

		$("#courseID").combobox({
			onChange: function(val){
				if(op==1){
					getCourseInfo(val);
					$.get("studentCourseControl.asp?op=checkRetake&keyID=" + $("#courseID").combobox("getValue") + "&refID=" + refID + "&times=" + (new Date().getTime()),function(re){
						if(re==1){
							$("#retake").checkbox({checked:true});
						}
					});
				}
			}
		});
		
		$("#agencyID").combobox({
			onChange:function() {
				var id = $("#agencyID").combobox("getValue");
				if(id > ""){
					getComboList("courseID","[dbo].[getStudentCourseRestList]('" + refID + "')","courseID","courseName","agencyID='" + id + "' order by seq",1);
				}else{
					getComboList("courseID","v_courseInfo","courseID","courseName1","status=0 order by seq",1);
				}
			}
		});

		$("#skill").checkbox({
			onChange: function(val){
				setSkill();
			}
		});

		$("#retake").checkbox({
			onChange: function(val){
				setRetake();
			}
		});

		$("#try").checkbox({
			onChange: function(val){
				if(val){
					$("#pay_status").combobox("setValue",0);	// 试读的设为未付款
					$("#amount").numberbox("setValue",0);
				}else{
					$("#pay_status").combobox("setValue",0);	// 非试读的设为未付款
					$("#amount").numberbox("setValue",0);	//$("#price").numberbox("getValue")
				}
			}
		});

		$("#btnMaterials").click(function(){
			showMaterialsInfo(0,refID,0,0);
		});

		$("#btnViewInvoice").click(function(){
			showPDF($("#file5").val(),0,0,0);
		});

		$("#btnShowSignature").click(function(){
			showImage($("#signature").val(),0,0,0);
		});

		$("#btnShowCompletion").click(function(){
			showCompletionList(nodeID,0,0,0);
		});

		$("#btnEntryform").click(function(){
			generateMaterials();
		});

		$("#btnEntryformExam").click(function(){
			generateMaterialsExam();
		});

		$("#btnPrint").click(function(){
			printEntryform(1);
			//window.open("entryform_C13.asp?keyID=0&nodeID=" + nodeID + "&refID=" + refID, "_self");
		});

		// $("#btnPreview").click(function(){
		// 	// printEntryform(0);
		// 	printEntryform1(1);
		// });

		$("#btnGenSignForm").click(function(){
			generateEntryFormSign();
		});

		$("#btnSendQueue").click(function(){
			sendQRshow(1);
			// generateEntryFormSign();
		});

		$("#btnRefund").click(function(){
			// if($("#refund_amount").numberbox("getValue")=="0"){
			// 	$.messager.alert("提示","请填写退款金额。","warning");
			// 	return false;
			// }
			// if($("#refund_amount").numberbox("getValue") > $("#amount").numberbox("getValue")){
			// 	$.messager.alert("提示","退款金额不能大于付款金额。","warning");
			// 	return false;
			// }

			jConfirm('确定要退款' + $("#refund_amount").numberbox("getValue") + '元吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=enterRefund&nodeID=" + $("#ID").val() + "&amount=" + $("#refund_amount").numberbox("getValue") + "&memo=" + escape($("#refund_memo").textbox("getValue")) + "&times=" + (new Date().getTime()),function(re){
						// alert(unescape(re))
						jAlert("操作成功。");
						updateCount += 1;
						getNodeInfo($("#ID").val());
					});
				}
			});
		});

		$("#btnPay").click(function(){
			if($("#amount").numberbox("getValue")=="0"){
				$.messager.alert("提示","请填写付款金额。","warning");
				return false;
			}
			if($("#amount").numberbox("getValue") > $("#price").numberbox("getValue")){
				$.messager.alert("提示","付款金额大于应付金额。","warning");
				// return false;
			}

			jConfirm('确定要付款吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=enterPay&nodeID=" + $("#ID").val() + "&amount=" + $("#amount").numberbox("getValue") + "&kindID=0&refID=" + $("#pay_type").combobox("getValue") + "&memo=" + escape($("#pay_memo").textbox("getValue")) + "&times=" + (new Date().getTime()),function(re){
						// alert(unescape(re))
						$.messager.alert("提示","操作成功。","info");
						updateCount += 1;
						getNodeInfo($("#ID").val());
					});
				}
			});
		});

		$("#btnZeroPay").click(function(){
			$.messager.prompt('信息记录', '请填写说明:', function(r){
				if (r.length > 1){
					$.get("studentCourseControl.asp?op=zeroPay&nodeID=" + $("#ID").val() + "&memo=" + escape(r) + "&times=" + (new Date().getTime()),function(re){
						updateCount += 1;
						getNodeInfo($("#ID").val());
						$.messager.alert("提示","操作成功。","info");
					});
				}else{
					$.messager.alert("提示","请填写说明。");
				}
			});
		});

		$("#btnCloseStudentCourse").linkbutton({
			iconCls:'icon-lock',
			width:85,
			height:25,
			text:'关闭课程',
			onClick:function() {
				jConfirm('确定要关闭这个学员的课程吗?', '确认对话框', function(r) {
					if(r){
						$.get("studentCourseControl.asp?op=closeStudentCourse&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(re){
							jAlert("关闭成功。");
							updateCount += 1;
							getNodeInfo($("#ID").val());
						});
					}
				});
			}
		});

		$("#btnReviveStudentCourse").linkbutton({
			iconCls:'icon-unlock',
			width:85,
			height:25,
			text:'重启课程',
			onClick:function() {
				jConfirm('确定要重启这个学员的课程吗?', '确认对话框', function(r) {
					if(r){
						$.get("studentCourseControl.asp?op=reviveStudentCourse&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(re){
							jAlert("重启成功。");
							updateCount += 1;
							getNodeInfo($("#ID").val());
						});
					}
				});
			}
		});

		$("#btnRebuildLesson").linkbutton({
			iconCls:'icon-reload',
			width:85,
			height:25,
			text:'刷新课程',
			onClick:function() {
				jConfirm('确定要刷新这个学员的课表和模拟练习吗?', '确认对话框', function(r) {
					if(r){
						$.get("studentCourseControl.asp?op=rebuildStudentLesson&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(re){
							jAlert("刷新成功。");
							//updateCount += 1;
							//getNodeInfo($("#ID").val());
						});
					}
				});
			}
		});

		$("#btnResign").linkbutton({
			iconCls:'icon-reload',
			width:85,
			height:25,
			text:'重新签名',
			onClick:function() {
				jConfirm('确定要让这个学员重新签名吗?', '确认对话框', function(r) {
					if(r){
						$.get("studentCourseControl.asp?op=reset_sign&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(re){
							getNodeInfo(nodeID);
							updateCount += 1;
							jAlert("重置成功。");
						});
					}
				});
			}
		});
		$("#btnUploadInvoice").click(function(){
			showUploadFile(nodeID, "", "invoice_pdf", "发票", "getNodeInfo(nodeID)", 0, 1, $("#name").textbox("getValue"));
		});
		$("#btnCheckDiplomaDate").click(function(){
			// 检查复训日期
			checkDiplomaDate(course, $("#username").textbox("getValue"), $("#name").textbox("getValue"));
		});

		//无论点击哪一个img弹出层都会展示相应的图片。
		$("#img").click(function () {
			var src = $("#img").attr("src");//获取当前点击img的src的值
			$("#img-box").attr("src", src);//将获取的当前点击img的src赋值到弹出层的图片的src
			$("#dialog-bg").show();//弹出层显示
		});
		$("#imgSign").click(function () {
			var src = $("#imgSign").attr("src");//获取当前点击img的src的值
			$("#img-box").attr("src", src);//将获取的当前点击img的src赋值到弹出层的图片的src
			$("#dialog-bg").show();//弹出层显示
		});

		//弹出层隐藏
		$("#dialog-bg").click(function () {
			$(this).hide();//
		});

		if(op==1){
			setButton();
		}else{
			getNodeInfo(nodeID);
		}
	});

	function getNodeInfo(id){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				refID = ar[1];
				$("#ID").val(ar[0]);
				$("#username").textbox("setValue",ar[1]);
				$("#student").val(ar[1]);
				$("#name").textbox("setValue",ar[8]);
				$("#kindID").combobox("setValue",ar[91]);
				$("#mobile").textbox("setValue",ar[11]);
				$("#job").textbox("setValue",ar[15]);
				$("#educationName").textbox("setValue",ar[33]);
				$("#unit").textbox("setValue",ar[35]);
				$("#certID").val(ar[32]);
				course = ar[56];
				$("#status").val(ar[3]);
				$("#paystatus").val(ar[77]);
				$("#signature").val(ar[43]);
				$("#result").val(ar[81]);
				$("#courseID").combobox("setValue",ar[2]);
				// $("#currDiplomaID").textbox("setValue",ar[36]);
				$("#currDiplomaDate").datebox("setValue",ar[41]);
				$("#signatureType").combobox("setValue",ar[47]);
				$("#signatureDate").textbox("setValue",ar[44]);
				$("#sales").combobox("setValue",ar[42]);
				if(ar[54]>0){
					$("#partnerID").combobox("setValue",ar[54]);
				}
				if(ar[110]==1){
					$("#try").checkbox({checked:true});
				}else{
					$("#try").checkbox({checked:false});
				}
				$("#statusName").textbox("setValue",ar[92]);
				$("#submiterName").textbox("setValue",ar[39]);
				$("#submitDate").textbox("setValue",ar[29]);
				$("#completionPass").textbox("setValue",ar[14]);
				$("#completion").textbox("setValue",ar[7]);
				$("#startDate").textbox("setValue",ar[5]);
				$("#endDate").textbox("setValue",ar[6]);
				$("#score").textbox("setValue",ar[78]);
				$("#score1").textbox("setValue",ar[79]);
				$("#resultName").textbox("setValue",ar[83]);
				$("#diplomaID").textbox("setValue",ar[55]);
				$("#memo").textbox("setValue",ar[93]);
				$("#pay_type").combobox("setValue",ar[66]);
				$("#pay_kindID").val(ar[65]);
				$("#datePay").datebox("setValue",ar[67]);
				$("#pay_status").combobox("setValue",ar[77]);
				$("#pay_checkerName").textbox("setValue",ar[94]);
				$("#pay_checkDate").textbox("setValue",ar[74]);
				$("#pay_memo").textbox("setValue",ar[76]);
				$("#cards").numberbox("setValue",ar[60]);
				sk[0] = ar[63];
				sk[1] = ar[60];
				setSkill();
				$("#cardsRest").textbox("setValue",ar[61]);
				$("#price").numberbox("setValue",ar[63]);
				$("#amount").numberbox("setValue",ar[64]);
				$("#invoice").textbox("setValue",ar[68]);
				$("#title").textbox("setValue",ar[69]);
				$("#dateInvoice").datebox("setValue",ar[70]);
				$("#dateInvoicePick").datebox("setValue",ar[71]);
				$("#dateRefund").datebox("setValue",ar[72]);
				$("#refunderName").textbox("setValue",ar[95]);
				entryform = ar[102];
				$("#refund_amount").numberbox("setValue",ar[103]);
				$("#refund_memo").textbox("setValue",ar[104]);
				$("#channel").combobox("setValue",ar[114]);
				$("#signatureDate1").datebox("setValue",ar[115]);
				$("#file5").val(ar[116]);
				$("#payNow").combobox("setValue",ar[118]);

				if(ar[43]>""){
					$("#status_signature").checkbox({checked:true});
				}else{
					$("#status_signature").checkbox({checked:false});
				}
				if(ar[51]==1){
					$("#overdue").checkbox({checked:true});
				}else{
					$("#overdue").checkbox({checked:false});
				}
				if(ar[52]==1){
					$("#express").checkbox({checked:true});
				}else{
					$("#express").checkbox({checked:false});
				}
				if(ar[62]==1){
					$("#retake").checkbox({checked:true});
					price1 = ar[113];
					setRetake();
				}else{
					$("#retake").checkbox({checked:false});
				}
				if(ar[111]==1){
					$("#person").checkbox({checked:true});
				}else{
					$("#person").checkbox({checked:false});
				}
				if(ar[117]==1){
					$("#needInvoice").checkbox({checked:true});
				}else{
					$("#needInvoice").checkbox({checked:false});
				}
				if(ar[48] > ""){
					$("#file1").html("<a href='/users" + ar[48] + "?" + (new Date().getTime()) + "' style='text-decoration:none;' target='_blank'>班级档</a>");
				}
				if(ar[49] > ""){
					$("#file2").html("<a href='/users" + ar[49] + "?" + (new Date().getTime()) + "' style='text-decoration:none;' target='_blank'>鉴定档</a>");
				}
				if(ar[50] > ""){
					$("#file3").html("<a href='/users" + ar[50] + "?" + (new Date().getTime()) + "' style='text-decoration:none;' target='_blank'>报名表</a>");
				}

				if(ar[2]=="L40"){
					if($("#skill").checkbox("options").checked){
					}
				}else{
					$("#item_skill").hide();
				}
				if(ar[37]=="1"){
					$("#retakeItem").hide()
				}
				if(ar[37]==1 && ar[112]==1){
					//安监复训
					$("#reexamineItem").show();
				}else{
					$("#reexamineItem").hide();
				}
				$("#imgSignInItem").hide();
				$("#imgSignInItem1").hide();
				if(ar[32]=="C40"){
					// var text = uploadURL + "/public/get_qr_img?size=10&text=" + escape("http://021edu.net/signIn.asp?msg=" + ar[0] + "&event=" + ar[8] + "&count=" + ar[61] + "&registerID=" + currUser);
					// alert(text)
					// $("#imgSign").prop("src", text);
					// $("#imgSignInItem").show();
					$("#signList").show();
				}else{
					$("#signList").hide();
				}

				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + refID + "&times=" + (new Date().getTime()),function(re1){
			//alert(unescape(re));
			var ar1 = new Array();
			ar1 = unescape(re1).split("|");
			if(ar1 > ""){
				var text = uploadURL + "/public/get_qr_img?size=10&text=" + encodeURIComponent("<%=mobile_url%>/#/login?host=" + currHost + "&username=" + refID + "&password=" + ar1[36]);
				// alert(text)
				$("#img").prop("src", text);
			}
		});
	}
	
	function saveNode(){
		keyID = $("#courseID").combobox("getValue");
		if($("#courseID").combobox("getValue")==""){
			$.messager.alert("提示","请选择课程。","warning");
			return false;
		}
		if($("#channel").combobox("getValue")=="" && currPartner == 0){
			$.messager.alert("提示","请选择渠道。","warning");
			return false;
		}
		// if($("#sales").combobox("getValue")=="" && $("#partnerID").combobox("getValue")=="" && currPartner == 0){
			// $.messager.alert("提示","请选择销售。","warning");
			// return false;
		// }
		if(op==1 && $("#pay_status").combobox("getValue")=="1" && $("#amount").numberbox("getValue")==0){
			$.messager.alert("提示","收款金额不能为0。","warning");
			return false;
		}
		$.messager.progress();	// 显示进度条
		$('#forms').form('submit', {   
			url: "studentCourseControl.asp?op=update&times=" + (new Date().getTime()),   
			onSubmit: function(){   
				//var isValid = $(this).form('validate');
				// alert($("#price").numberbox("getValue") + ":" + $("#amount").numberbox("getValue"))
				var isValid = true;
				if(op==1 && $("#courseID").textbox("getValue")==""){
					$.messager.alert("提示","请选择课程。","warning");
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
				// $.messager.alert("提示",unescape(data));
				// return false;
				var ar = new Array();
				var c = "";
				ar = unescape(data).split("|");
				if(ar[0]==0){
					updateCount += 1;
					nodeID = ar[2];
					if(op==1){
						op = 0;
						$.messager.alert("提示","报名成功。","info");
						//新报名结束后直接关闭页面
						generateEntryForm(1);
						generateEntryFormSign();	//生成签名时显示的报名表
						// sendQRshow(0);
						// window.parent.$.close("enterInfo");
					}else{
						getNodeInfo(nodeID);
						$.messager.alert("提示","保存成功。","info");
					}
					$.messager.progress('close');	// 如果提交成功则隐藏进度条 
				}else{
					$.messager.alert("提示",ar[1],"warning");
				}
			}   
		});
	}
	
	function generateEntryForm(i){
		window.open("entryform_" + entryform + ".asp?nodeID=" + nodeID + "&refID=" + refID + "&keyID=" + i + "&host=" + currHost + "&times=" + (new Date().getTime()), "_self");
	}
	
	function printEntryform(k){
		window.open("entryform_" + entryform + ".asp?keyID=" + k + "&nodeID=" + nodeID + "&refID=" + refID + "&kindID=" + $("#certID").val() + "&host=" + currHost + "&times=" + (new Date().getTime()), "_self");
	}
	
	function printEntryform1(k){
		window.open("entryform_" + entryform + "_202301.asp?keyID=" + k + "&nodeID=" + nodeID + "&refID=" + refID + "&kindID=" + $("#certID").val() + "&host=" + currHost + "&times=" + (new Date().getTime()), "_self");
	}

	function generateMaterials(){
		$.messager.confirm("提示","确定要生成报名材料吗？",function(r){
			if(r){
				$.getJSON(uploadURL + "/outfiles/generate_emergency_materials?refID=" + refID + "&nodeID=" + nodeID + "&entryform=" + entryform + "&host=" + currHost ,function(data){
					if(data>""){
						$.messager.alert("提示","已生成文件","info");
						getNodeInfo(nodeID);
					}else{
						$.messager.alert("提示","没有可供处理的数据。","warning");
					}
				});
			}
		});
	}

	function generateMaterialsExam(){
		$.messager.confirm("提示","确定要生成鉴定归档材料吗？",function(r){
			if(r){
				$.getJSON(uploadURL + "/outfiles/generate_emergency_materials_exam?refID=" + refID + "&nodeID=" + nodeID + "&entryform=" + entryform + "&host=" + currHost ,function(data){
					if(data>""){
						$.messager.alert("提示","已生成文件","info");
						getNodeInfo(nodeID);
					}else{
						$.messager.alert("提示","没有可供处理的数据。","warning");
					}
				});
			}
		});
	}

	function generateEntryFormSign(){
		$.getJSON(uploadURL + "/outfiles/generate_entryform_sign?refID=" + refID + "&nodeID=" + nodeID + "&entryform=" + entryform + "&host=" + currHost ,function(data){
			// no action
		});
	}
	
	function getCourseInfo(id){
		$.get("courseControl.asp?op=getNodeInfo&nodeID=0&refID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#cards").textbox("setValue",ar[12]);
				$("#cardsRest").textbox("setValue",ar[12]);
				$("#price").textbox("setValue",ar[25]);
				$("#amount").textbox("setValue",0);
				$("#completionPass").textbox("setValue",ar[14]);
				price = ar[25];
				price1 = ar[26];
				entryform = ar[24];
				sk[0] = ar[25];
				sk[1] = ar[12];
				course = ar[2];
				setSkill();
				if(ar[21]==1 && ar[28]==1){
					//安监复训
					$("#reexamineItem").show();
					if(op == 1){	
						// 新增默认选中个人
						$("#person").checkbox({checked:true});
					}
				}else{
					$("#reexamineItem").hide();
					if(op == 1){	// 新增默认选中个人
						$("#person").checkbox({checked:false});
					}
				}
				if(ar[21]==1 || ar[19]==0){
					//复训或不分初训复训项目，屏蔽过期选项。
					$("#overdue").checkbox({readonly:true, checked:false});
				}
				if(ar[21]==0 && ar[19]==1){
					//分初训复训的初训项目，显示过期选项。
					$("#overdue").checkbox({readonly:false, checked:false});
				}
			}else{
				alert("课程信息未找到！","信息提示");
			}
		});
	}
	
	function sendQRshow(i){
		$.get("hostControl.asp?op=addQRshow&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			if(i>0){
				alert("发送成功","信息提示");
			}
		});
	}

	function setSkill(){
		if($("#courseID").combobox("getValue")=="L40"){
			$("#item_skill").show();
			if($("#skill").checkbox("options").checked){
				$("#price").textbox("setValue",sk[0]);
				$("#amount").textbox("setValue",sk[0]);
				$("#cards").textbox("setValue",sk[1]);
				$("#cardsRest").textbox("setValue",sk[1]);
			}else{
				$("#price").textbox("setValue",sk1[0]);
				$("#amount").textbox("setValue",sk1[0]);
				$("#cards").textbox("setValue",sk1[1]);
				$("#cardsRest").textbox("setValue",sk1[1]);
			}
		}else{
			$("#item_skill").hide();
		}
	}

	function setRetake(){
		if($("#retake").checkbox("options").checked){
			$("#price").textbox("setValue",price1);
			// $("#amount").textbox("setValue",price1);
		}else{
			$("#price").textbox("setValue",price);
			// $("#amount").textbox("setValue",price);
		}
	}

	function checkDiplomaDate(courseName, username, name){
		$.ajax({
			url: uploadURL + "/public/diplomaCheckSingle",
			type: "post",
			data: {"username":username, "name":name, "courseName":courseName},
			success: function(data){
				//jAlert(data);
				if(data.msg == ""){
					jAlert("未能查到应复训日期。", "信息提示");
				}else{
					$("#currDiplomaDate").datebox("setValue",data.msg);
					$("#currDiplomaChecked").checkbox({checked:true});
					jAlert("应复训日期：" + data.msg, "信息提示");
				}
			}
		});
	}
	
	function setButton(){
		$("#btnSave").hide();
		$("#btnRefund").hide();
		$("#btnPay").hide();
		$("#btnZeroPay").hide();
		$("#btnDel").hide();
		$("#btnEntryform").hide();
		$("#btnShowSignature").hide();
		$("#btnCloseStudentCourse").hide();
		$("#btnReviveStudentCourse").hide();
		$("#btnRebuildLesson").hide();
		$("#btnPrint").hide();
		$("#btnResign").hide();
		$("#enterTrail1").hide();
		$("#enterTrail2").hide();
		// $("#payTrail1").hide();
		// $("#payTrail2").hide();
		$("#partnerItem").hide();
		$("#agencyItem").hide();
		$("#tryItem").hide();
		$("#btnSendQueue").hide();
		$("#btnCheckDiplomaDate").hide();
		$("#statusName").textbox("disable");
		$("#submiterName").textbox("disable");
		$("#cardsRest").textbox({readonly:true});
		$("#completionPass").textbox("disable");
		$("#completion").textbox("disable");
		$("#diplomaID").textbox("disable");
		$("#resultName").textbox("disable");
		$("#score").textbox("disable");
		$("#score1").textbox("disable");
		$("#refunderName").textbox("disable");
		$("#dateRefund").textbox({readonly:true});
		$("#submitDate").textbox({readonly:true});
		$("#pay_checkDate").textbox({readonly:true});
		$("#pay_checkerName").textbox("disable");
		$("#status_signature").checkbox({readonly:true});
		$("#btnViewInvoice").prop("disabled",true);
		if(currUser != "desk"){
			$("#currDiplomaCheckItem").hide();
		}
			
		if(checkPermission("enterTrail")){
			$("#enterTrail1").show();
			$("#enterTrail2").show();
		}
		if(checkPermission("payTrail")){
			$("#payTrail1").show();
			$("#payTrail2").show();
		}
		if(!checkRole("cashier")){
			$("#invoice").textbox({readonly:true});
			$("#btnUploadInvoice").prop("disabled",true);
		}
		if(checkPermission("deptShow")){
			$("#partnerItem").show();
		}

		if(op==1){
			//新增报名：显示报名选项、报名按钮
			$("#btnSave").show();
			$("#agencyItem").show();
			$("#tryItem").show();
			setEmpty();
			//只显示可以报名的课程列表
        	getComboList("courseID","[dbo].[getStudentCourseRestList]('" + refID + "')","courseID","courseName","1=1 order by seq",1);
		}else{
			$("#courseID").combobox("readonly",true);
			$("#pay_status").combobox("readonly",true);
			if(checkPermission("zeroPay")){
				$("#btnZeroPay").show();
			}

			if($("#file5").val()>""){
				$("#btnViewInvoice").prop("disabled",false);
			}

			if(!checkPermission("applyEdit")){
				$("#signatureDate1").numberbox({readonly:true});
				$("#signatureDate").numberbox({readonly:true});
				// $("#btnPreview").hide();
			}

			if(checkPermission("studentAdd")){
				//编辑状态：显示保存按钮；一定条件下可以退学、退款
				$("#btnRebuildLesson").show();
				$("#btnSave").show();
				$("#btnEntryform").show();
				if($("#signature").val()>""){
					$("#btnShowSignature").show();	//查看签名按钮
					$("#btnResign").show();	//重置签名按钮
				}

				if($("#paystatus").val()==0){
					//未支付的付款可以支付\删除\试读。
					$("#btnPay").show();
					$("#btnDel").show();
					$("#tryItem").show();
				}
				if($("#paystatus").val()==1){
					//已支付的付款可以退款。
					$("#btnRefund").show();
					// if($("#datePay").datebox("getValue") != (new Date().format("yyyy-MM-dd"))){	//付款当天可以修改付款日期
						$("#amount").numberbox({readonly:true});
						if(!checkPermission("editPayDate")){
							$("#datePay").datebox("disable");
						}
					// }
				}
				if($("#status").val()<2){
					//未完成的可以关闭课程、转至九峰
					$("#btnCloseStudentCourse").show();
				}
				if($("#status").val()>=2 && $("#diplomaID").textbox("getValue")==""){
					//已完成且未取得证书的可以开启课程。
					$("#btnReviveStudentCourse").show();
				}
			}
			$("#btnPrint").show();
		}
		$("#hideitem1").hide();
	}

	function setEmpty(){
		$("#pay_kindID").val(0);
		$("#payNow").combobox("setValue",0);
		$("#pay_type").combobox("setValue",0);
		$("#pay_status").combobox("setValue",0);
		$("#signatureType").combobox("setValue",1);
		$("#item_skill").hide();
		$("#sales").combobox("setValue",'');
		$("#channel").combobox("setValue",'');
		if(currPartner > 0){
			$("#partnerID").combobox("setValue",currPartner);
		}
		$("#ID").val(0);
		$("#reexamineItem").hide();
		$("#imgSignInItem").hide();
		if(keyID>""){
			//填充课程信息
			getCourseInfo(keyID);
			$("#courseID").combobox("setValue",keyID);
		}
		//填充个人信息
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + refID + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#username").textbox("setValue",ar[1]);
				$("#student").val(ar[1]);
				$("#name").textbox("setValue",ar[2]);
				$("#kindID").combobox("setValue",ar[5]);
				$("#mobile").textbox("setValue",ar[7]);
				$("#job").textbox("setValue",ar[14]);
				$("#educationName").textbox("setValue",ar[21]);
				$("#unit").textbox("setValue",ar[25]);
				$("#title").textbox("setValue",ar[25]);
				if(ar[9]<18){
					jAlert("未满18岁，不能报名。");
					$("#btnSave").hide();
				}
			}else{
				alert("学员信息未找到！","信息提示");
				$("#btnSave").hide();
			}
		});
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
			<form style="width:98%;float:right;margin:1px;padding-left:1px;background:#fefaf8;">
			<table>
				<tr>
					<td align="right">证件号</td><input type="hidden" id="pay_kindID" name="pay_kindID" />
					<td><input id="username" name="username" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
					<td align="right">类别</td>
					<td><select id="kindID" name="kindID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80,readonly:true"></select></td>
				</tr>
				<tr>
					<td align="right">姓名</td>
					<td><input id="name" name="name" class="easyui-textbox" data-options="height:22,width:70,readonly:true" />&nbsp;&nbsp;学历&nbsp;<input id="educationName" name="educationName" class="easyui-textbox" data-options="height:22,width:90,readonly:true" /></td>
					<td align="right">手机</td>
					<td><input id="mobile" name="mobile" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				</tr>
				<tr>
					<td align="right">单位名称</td>
					<td><input id="unit" name="unit" class="easyui-textbox" data-options="height:22,width:250,readonly:true" /></td>
					<td align="right">岗位职务</td>
					<td><input id="job" name="job" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				</tr>
			</table>
			</form>
			</div>
			<div style="width:100%;float:left;height:4px;"></div>
			<div class="comm" style="background:#f5faf8;">
			<form id="forms" method="post" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
				<tr><input type="hidden" id="ID" name="ID" /><input type="hidden" id="certID" /><input type="hidden" id="status" /><input type="hidden" id="student" name="student" /><input type="hidden" id="paystatus" />
					<td align="right">课程名称</td>
					<td colspan="3">
					<div>
						<span><select id="courseID" name="courseID" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:280,required:true"></select></span>
						<span id="agencyItem">&nbsp;&nbsp;类别&nbsp;<select id="agencyID" name="agencyID" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:100"></select></span>
						<span id="hideitem1"><input class="easyui-checkbox" id="overdue" name="overdue" value="1" />&nbsp;复审过期
						&nbsp;&nbsp;<input class="easyui-checkbox" id="express" name="express" value="1" />&nbsp;加急</span>
					</div>
					</td>
				</tr>
				<tr id="reexamineItem">
					<td align="right">证明格式</td>
					<td><input class="easyui-checkbox" id="person" name="person" value="1" />&nbsp;个人</td>
					<td align="left" colspan="2">
						应复训日期
						<input id="currDiplomaDate" name="currDiplomaDate" class="easyui-datebox" data-options="height:22,width:100,required:true" />
						<span id="currDiplomaCheckItem">
							<input class="easyui-checkbox" id="currDiplomaChecked" name="currDiplomaChecked" value="1" />&nbsp;已确认
							<input class="button" type="button" id="btnCheckDiplomaDate" value="查询" />
						</span>
						&nbsp;&nbsp;请核实确认
					</td>
				</tr>
				<tr>
					<td align="right">签名类型</td><input type="hidden" id="signature" /><input type="hidden" id="result" />
					<td colspan="3"><select id="signatureType" name="signatureType" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:70"></select>
						&nbsp;&nbsp;&nbsp;<input class="easyui-checkbox" id="status_signature" name="status_signature" value="1" />&nbsp;已签名
						&nbsp;&nbsp;&nbsp;签名日期
						<input id="signatureDate" name="signatureDate" class="easyui-datebox" data-options="height:22,width:100" />
						<input class="button" type="button" id="btnShowSignature" value="查看签名" />
						<input class="button" type="button" id="btnGenSignForm" value="生成协议" />
						&nbsp;&nbsp;&nbsp;考站签名
						<input id="signatureDate1" name="signatureDate1" class="easyui-datebox" data-options="height:22,width:100" />
					</td>
				</tr>
				<tr>
					<td align="right">销售</td>
					<td>
						<div>
						<span><select id="sales" name="sales" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select></span>
						<span>&nbsp;渠道&nbsp;<select id="channel" name="channel" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100,required:true"></select></span>
						<span id="tryItem">&nbsp;&nbsp;&nbsp;<input class="easyui-checkbox" value="1" id="try" name="try" />&nbsp;试读</span>
						</div>
					</td>
					<td align="right"></td>
					<td>
						<div>
						<span id="partnerItem">部门&nbsp;<select id="partnerID" name="partnerID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100,readonly:true"></select></span>
						<span id="retakeItem">&nbsp;&nbsp;<input class="easyui-checkbox" value="1" id="retake" name="retake" />&nbsp;付费重修</span>
						</div>
					</td>
				</tr>
				<tr>
					<td align="right">状态</td>
					<td><input id="statusName" name="statusName" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
					<td align="right">经办人</td>
					<td><input id="submiterName" name="submiterName" class="easyui-textbox" data-options="height:22,width:90,readonly:true" />&nbsp;&nbsp;<input id="submitDate" name="submitDate" class="easyui-textbox" data-options="height:22,width:90,readonly:true" /></td>
				</tr>
				<tr>
					<td align="right">考试条件</td>
					<td><input id="completionPass" name="completionPass" class="easyui-textbox" data-options="height:22,width:100,readonly:true" />&nbsp;课时%</td>
					<td align="right">实际完成</td>
					<td>
						<input id="completion" name="completion" class="easyui-textbox" data-options="height:22,width:100,readonly:true" />&nbsp;%
						&nbsp;<input class="button" type="button" id="btnShowCompletion" value="查看详情" />
					</td>
				</tr>
				<tr id="enterTrail1">
					<td align="right">培训日期</td>
					<td><input id="startDate" name="startDate" class="easyui-textbox" data-options="height:22,width:85,readonly:true" />&nbsp;至&nbsp;<input id="endDate" name="endDate" class="easyui-textbox" data-options="height:22,width:85,readonly:true" /></td>
					<td align="right">考试成绩</td>
					<td><input id="score" name="score" class="easyui-textbox" data-options="height:22,width:80,readonly:true" />&nbsp;/&nbsp;<input id="score1" name="score1" class="easyui-textbox" data-options="height:22,width:80,readonly:true" /></td>
				</tr>
				<tr id="enterTrail2">
					<td align="right">考试结果</td>
					<td><input id="resultName" name="resultName" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
					<td align="right">证书编号</td>
					<td><input id="diplomaID" name="diplomaID" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				</tr>
				<tr>
					<td align="right">备注</td>
					<td colspan="3"><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:525" /></td>
				</tr>
				<tr>
					<td align="right">付款方式</td>
					<td><select id="pay_type" name="pay_type" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100"></select>&nbsp;&nbsp;类型&nbsp;<select id="payNow" name="payNow" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100"></select></td>
					<td align="right">应付金额</td>
					<td><input id="price" name="price" class="easyui-numberbox" data-options="min:0,height:22,width:70" />&nbsp;&nbsp;实付&nbsp;<input id="amount" name="amount" class="easyui-numberbox" data-options="height:22,width:70" /><span id="item_skill">&nbsp;&nbsp;<input class="easyui-checkbox" id="skill" name="skill" value="1" checked />&nbsp;会开</span></td>
				</tr>
				<tr>
					<td align="right">付款日期</td>
					<td><input id="datePay" name="datePay" class="easyui-datebox" data-options="height:22,width:100" />&nbsp;&nbsp;状态&nbsp;<select id="pay_status" name="pay_status" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100"></select></td>
					<td align="right">经办人</td>
					<td><input id="pay_checkerName" name="pay_checkerName" class="easyui-textbox" data-options="height:22,width:90" />&nbsp;&nbsp;日期&nbsp;<input id="pay_checkDate" name="pay_checkDate" class="easyui-textbox" data-options="height:22,width:70" />&nbsp;<input class="button" type="button" id="btnPay" value="付款" />&nbsp;<input class="button" type="button" id="btnZeroPay" value="0支付" /></td>
				</tr>
				<tr id="payTrail1">
					<td align="right">付款说明</td>
					<td><input id="pay_memo" name="pay_memo" class="easyui-textbox" data-options="height:22,width:195" /></td>
					<td align="right">实训额度</td>
					<td><input id="cards" name="cards" class="easyui-numberbox" data-options="min:0,height:22,width:100" />&nbsp;&nbsp;剩余&nbsp;<input id="cardsRest" name="cardsRest" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
				</tr>
				<tr id="payTrail2">
					<td align="right">开票信息</td><input type="hidden" id="file5" name="file5" />
					<td colspan="3">
						<input id="title" name="title" class="easyui-textbox" data-options="height:22,width:480" />
						<input class="easyui-checkbox" id="needInvoice" name="needInvoice" value="1" />&nbsp;需开票
						&nbsp;<input class="button" type="button" id="btnUploadInvoice" value="上传发票" />
					</td>
				</tr>
				<tr>
					<td align="right">发票号码</td>
					<td><input id="invoice" name="invoice" class="easyui-textbox" data-options="height:22,width:195" />&nbsp;<input class="button" type="button" id="btnViewInvoice" value="查看" /></td>
					<td align="right">开票日期</td>
					<td><input id="dateInvoice" name="dateInvoice" class="easyui-datebox" data-options="height:22,width:100" />&nbsp;&nbsp;取票&nbsp;<input id="dateInvoicePick" name="dateInvoicePick" class="easyui-datebox" data-options="height:22,width:100" /></td>
				</tr>
				<tr>
					<td align="right">退款日期</td>
					<td><input id="dateRefund" name="dateRefund" class="easyui-datebox" data-options="height:22,width:100" />&nbsp;&nbsp;经办人&nbsp;<input id="refunderName" name="refunderName" class="easyui-textbox" data-options="height:22,width:80" /></td>
					<td align="right">退款金额</td>
					<td><input id="refund_amount" name="refund_amount" class="easyui-numberbox" data-options="min:0,height:22,width:60" />&nbsp;&nbsp;退款说明&nbsp;<input id="refund_memo" name="refund_memo" class="easyui-textbox" data-options="height:22,width:100" />&nbsp;<input class="button" type="button" id="btnRefund" value="退款" /></td>
				</tr>
				<tr>
					<td align="right">报名材料</td>
					<td colspan="3"><div style="color:blue;font-family:'幼圆';font-size:1em;">
						<input class="button" type="button" id="btnMaterials" value="查看材料" />
						<input class="button" type="button" id="btnEntryform" value="班级资料" />
						<input class="button" type="button" id="btnEntryformExam" value="鉴定归档" />
						<input class="button" type="button" id="btnPrint" value="打印" />
						<span id="file1"></span>
						<span id="file2"></span>
						<span id="file3"></span>
					</div></td>
				</tr>
				<tr>
					<td colspan="2">
						<div style="display: table;">
							<span style="vertical-align: middle;display: table-cell;">
								<input class="button" type="button" id="btnSendQueue" value="发送二维码" />
								签名二维码
							</span>
							<span style="float:left;">
								<div class="img-list-box">
									<div class="img-select">
										<img id="img" src="" />
									</div>
								</div>
							</span>
							<span id="imgSignInItem" style="vertical-align: middle;display: table-cell; padding-left:10px;">
								报到二维码
							</span>
							<span id="imgSignInItem1" style="float:left;">
								<div class="img-list-box">
									<div class="img-select">
										<img id="imgSign" src="" />
									</div>
								</div>
							</span>
						</div>
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
		<a class="easyui-linkbutton" id="btnReviveStudentCourse" href="javascript:void(0)" value="重启课程"></a>
		<a class="easyui-linkbutton" id="btnCloseStudentCourse" href="javascript:void(0)" value="关闭课程"></a>
		<a class="easyui-linkbutton" id="btnRebuildLesson" href="javascript:void(0)" value="刷新课表"></a>
		<a class="easyui-linkbutton" id="smsList" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="examList" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="opList" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="signList" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="btnResign" href="javascript:void(0)"></a>
  	</div>

	<div class="dialog-bg" id="dialog-bg">
    <div class="img-box">
        <img id="img-box" src="">
    </div>

</div>
</body>
