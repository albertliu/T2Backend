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

<link href="css/style_inner1.css?v=1.4"  rel="stylesheet" type="text/css" />
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
<script language="javascript" src="js/jquery-2.1.1.min.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.0"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script language="javascript">
	var nodeID = "";
	var refID = "";
	var op = 0;
	var updateCount = 0;
	var kindID=0;
	var replace_item = "";
	var original_item = "";
	var cardJson = "";
	var fromCard = 0;
	var lastCourseID = "";
	let scanPhoto = 0;
	let hasPhoto = 0;
	<!--#include file="js/commFunction.js"-->
	<!--#include file="js/EST_reader.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";	//username
		op = "<%=op%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		getComboBoxList("IDkind","kindID",0);
		getComboBoxList("sex","sex",0);
		getComboBoxList("education","education",0);
		getComboBoxList("statusJob","job_status",0);
		getComboBoxList("job","job",0);

		$("#add").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				op = 1;
				setButton();
			}
		});
		$("#enter").linkbutton({
			iconCls:'icon-edit',
			width:85,
			height:25,
			text:'去报名',
			onClick:function() {
				showEnterInfo(0,refID,1,1,lastCourseID,"getStudentCourseList(refID)");
			}
		});
		$("#smsList").linkbutton({
			iconCls:'',
			width:65,
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
				// window.open("http://localhost:8084/pdfs_diploma_card.asp?refID=5496","_blank")
			}
		});

		$("#opList").linkbutton({
			iconCls:'',
			width:65,
			height:25,
			text:'查看操作',
			onClick:function() {
				showStudentOpList(refID,1,0,1);
			}
		});

		$("#btnSave").linkbutton({
			iconCls:'icon-save',
			width:70,
			height:25,
			text:'保存',
			onClick:function() {
				fromCard = 0;
				saveNode();
			}
		});

		$("#close").linkbutton({
			iconCls:'icon-lock',
			width:70,
			height:25,
			text:'禁用',
			onClick:function() {
				$.messager.confirm('确认对话框', '确定要禁用这个学员吗?', function(r) {
					if(r){
						$.get("studentControl.asp?op=setStatus&nodeID=" + $("#studentID").val() + "&status=1&times=" + (new Date().getTime()),function(data){
							alert("成功禁用！","信息提示");
							getNodeInfo(nodeID);
							updateCount += 1;
						});
					}
				});
				// jConfirm('你确定要禁用这个学员吗?', '确认对话框', function(r) {
				// 	if(r){
				// 		$.get("studentControl.asp?op=setStatus&nodeID=" + $("#studentID").val() + "&status=1&times=" + (new Date().getTime()),function(data){
				// 			alert("成功禁用！","信息提示");
				// 			getNodeInfo(nodeID);
				// 			updateCount += 1;
				// 		});
				// 	}
				// });
			}
		});

		$("#btnDel").linkbutton({
			iconCls:'icon-cut',
			width:70,
			height:25,
			text:'删除',
			onClick:function() {
				$.messager.confirm('确认对话框', '确定要删除这个学员吗? <br>所有信息将丢失，且无法恢复!', function(r) {
					if(r){
						$.get("studentControl.asp?op=delNode&nodeID=" + refID + "&times=" + (new Date().getTime()),function(data){
							alert("成功删除！","信息提示");
							op = 1;
							setEmpty();
							updateCount += 1;
						});
					}
				});
			}
		});
		$("#open").linkbutton({
			iconCls:'icon-unlock',
			width:70,
			height:25,
			text:'解禁',
			onClick:function() {
				$.messager.confirm('确认对话框', '确定要解禁这个学员吗?', function(r) {
					if(r){
						$.get("studentControl.asp?op=setStatus&nodeID=" + $("#studentID").val() + "&status=0&times=" + (new Date().getTime()),function(data){
							alert("成功解禁！","信息提示");
							getNodeInfo(nodeID,"");
							updateCount += 1;
						});
					}
				});
			}
		});
		$("#reset").linkbutton({
			iconCls:'icon-reload',
			width:85,
			height:25,
			text:'重置密码',
			onClick:function() {
				$.messager.confirm('确认对话框', '确定要重置密码吗?', function(r) {
					if(r){
						$.get("studentControl.asp?op=reset&nodeID=" + $("#studentID").val() + "&times=" + (new Date().getTime()),function(data){
							alert("重置完成，当前密码为123456","信息提示");
						});
					}
				});
			}
		});
		$("#username").textbox({
			onChange: function(val){
				refID = $("#username").textbox("getValue");
				if(refID>""){
					$("#username").textbox("initValue",refID.toUpperCase());
					if($("#kindID").combobox("getValue")==0){
						if(checkIDcard(refID)==1 || refID=='111' || refID=='222'){
							var n = studentExist(refID);
							if(n>0){
								//alert("该身份证已经存在。");
								//已有该身份证记录，则调出原记录，进入编辑状态
								op = 0;
								getNodeInfo(0,refID);
								if(refID.substring(0,3) == '310'){
									$.messager.alert('提示对话框', '该学员为310开头身份证<br>请提醒学员进行一网通认证');
								}
							}
							replace_item = "";
						}else{
							$.messager.alert('提示对话框', "身份证号码有误，请核对。");
							$("#username").textbox("setValue","");
						}
					}
				}
			}
		});

		$("#kindID").combobox({
			onSelect: function(val){
				if(val==0){
					//身份证
					$("#sex").combobox("disable");
					$("#birthday").datebox("disable");
				}else{
					//其他证
					$("#sex").combobox("enable");
					$("#birthday").datebox("enable");
				}
			}
		});
		
		$("#add_img_photo").click(function(){
			showUploadFile(refID, "", "student_photo", "照片", "setImag('img_photo',reDo)", 0, 1);
		});
		$("#add_img_cardA").click(function(){
			showUploadFile(refID, "", "student_IDcardA", "身份证正面", "setImag('img_cardA',reDo)", 0, 1);
		});
		$("#add_img_cardB").click(function(){
			//showLoadFile("student_IDcardB",refID,"student","");
			showUploadFile(refID, "", "student_IDcardB", "身份证背面", "setImag('img_cardB',reDo)", 0, 1);
		});
		$("#add_img_education").click(function(){
			showUploadFile(refID, "", "student_education", "学历证明", "setImag('img_education',reDo)", 0, 1);
		});
		$("#add_img_CHESICC").click(function(){
			showUploadFile(refID, "", "student_CHESICC", "学信网截图", "setImag('img_CHESICC',reDo)", 0, 1);
		});
		$("#add_img_employment").click(function(){
			showUploadFile(refID, "", "student_employment", "在职证明", "setImag('img_employment',reDo)", 0, 1);
		});
		$("#add_img_jobCertificate").click(function(){
			showUploadFile(refID, "", "student_jobCertificate", "职业资格证书", "setImag('img_jobCertificate',reDo)", 0, 1);
		});
		$("#img_photo").click(function(){
			if($("#img_photo").attr("value")>""){
				//window.open($("#img_photo").attr("value"));
				showCropperInfo($("#img_photo").attr("value"),refID,"photo","img_photo",0,1);
			}
		});
		$("#img_cardA").click(function(){
			if($("#img_cardA").attr("value")>""){
				// window.open($("#img_cardA").attr("value"));
				showCropperInfo($("#img_cardA").attr("value"),refID,"IDcardA","img_cardA",0,1);
			}
		});
		$("#img_cardB").click(function(){
			if($("#img_cardB").attr("value")>""){
				// window.open($("#img_cardB").attr("value"));
				showCropperInfo($("#img_cardB").attr("value"),refID,"IDcardB","img_cardB",0,1);
			}
		});
		$("#img_education").click(function(){
			if($("#img_education").attr("value")>""){
				// window.open($("#img_education").attr("value"));
				showCropperInfo($("#img_education").attr("value"),refID,"education","img_education",0,1);
			}
		});
		$("#img_CHESICC").click(function(){
			if($("#img_CHESICC").attr("value")>""){
				window.open($("#img_CHESICC").attr("value"));
			}
		});
		$("#img_employment").click(function(){
			if($("#img_employment").attr("value")>""){
				window.open($("#img_employment").attr("value"));
			}
		});
		$("#img_jobCertificate").click(function(){
			if($("#img_jobCertificate").attr("value")>""){
				window.open($("#img_jobCertificate").attr("value"));
			}
		});

		if(op==0){
			getNodeInfo(nodeID,refID);
		}else{
			setButton();
		}
		/*
		var imgArr = $("#xx").find("img");
		//alert(imgArr.length);
		$.each(imgArr,function(){
			var img = $(this);
			alert(img.parent().width());
		});*/
	});

	function setImag(obj,path){
		$("#" + obj).prop("src","/users" + path + "?times=" + (new Date().getTime()));
		if(obj=="img_education"){
			$.messager.alert('提示对话框', '请核对学历是否与材料一致');
		}
	}

	function getNodeInfo(id,ref){
		$.get("studentControl.asp?op=getNodeInfo&nodeID=" + id + "&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#studentID").val(ar[0]);
				$("#username").textbox("initValue",ar[1]);
				refID = ar[1];
				$("#name").textbox("setValue",ar[2]);
				$("#status").val(ar[3]);
				$("#statusName").textbox("setValue",ar[4]);
				$("#kindID").combobox("setValue",ar[5]);
				$("#mobile").textbox("setValue",ar[7]);
				$("#age").textbox("setValue",ar[9]);
				$("#memo").textbox("setValue",ar[10]);
				$("#regDate").textbox("setValue",ar[11]);
				$("#email").textbox("setValue",ar[12]);
				$("#phone").textbox("setValue",ar[13]);
				$("#job").textbox("setValue",ar[14]);
				$("#province").textbox("setValue",ar[19]);
				$("#education").combobox("setValue",ar[20]);
				$("#job_status").combobox("setValue",ar[22]);
				$("#birthday").datebox("setValue",ar[23]);
				$("#address").textbox("setValue",ar[24]);
				$("#unit").textbox("setValue",ar[25]);
				$("#ethnicity").textbox("setValue",ar[26]);
				$("#IDaddress").textbox("setValue",ar[27]);
				$("#bureau").textbox("setValue",ar[28]);
				$("#IDdateStart").datebox("setValue",ar[29]);
				$("#scanID").val(ar[38]);
				$("#IDdateEnd").datebox("setValue",ar[30]);
				$("#IDdateEnd").datebox("readonly",false);
				// if(ar[29]>"" && ar[30]=="" && ar[38]==0){	// 扫身份证且截至日期为长期的，不允许修改。
					// $("#IDdateEnd").combo("readonly",true);
				// }
				$("#linker").textbox("setValue",ar[34]);
				$("#sex").combobox("setValue",ar[35]);
				if(ar[39]==1){
					$("#scanPhoto").checkbox({checked:true});
					scanPhoto = 1;
				}else{
					$("#scanPhoto").checkbox({checked:false});
					scanPhoto = 0;
				}
				
				if(ar[25]==""){
					$("#unit").textbox("textbox").css("border", "solid 1px red");
				}
				if(ar[24]==""){
					$("#address").textbox("textbox").css("border", "solid 1px red");
				}
				if(ar[29]==""){
					$("#IDdateStart").datebox("textbox").css("border", "solid 1px red");
				}
				//$("#upload1").html("<a href='javascript:showLoadFile(\"student_education\",\"" + ar[1] + "\",\"student\",\"\");' style='padding:3px;'>上传</a>");
				//<a href='/users" + ar[21] + "' target='_blank'></a>
				arr = [];
				if(ar[15] > ""){
					$("#img_photo").attr("src","/users" + ar[15] + "?times=" + (new Date().getTime()));
					$("#img_photo").attr("value","/users" + ar[15]);
					hasPhoto = 1;
				}else{
					$("#img_photo").attr("src","images/blank_photo.png" + "?times=" + (new Date().getTime()));
					arr.push("," + "photo");
					hasPhoto = 0;
				}
				if(ar[16] > ""){
					$("#img_cardA").attr("src","/users" + ar[16] + "?times=" + (new Date().getTime()));
					$("#img_cardA").attr("value","/users" + ar[16]);
				}else{
					$("#img_cardA").attr("src","images/blank_cardA.png" + "?times=" + (new Date().getTime()));
					arr.push("," + "cardA");
				}
				if(ar[17] > ""){
					$("#img_cardB").attr("src","/users" + ar[17] + "?times=" + (new Date().getTime()));
					$("#img_cardB").attr("value","/users" + ar[17]);
				}else{
					$("#img_cardB").attr("src","images/blank_cardB.png" + "?times=" + (new Date().getTime()));
					arr.push("," + "cardB");
				}
				if(ar[18] > ""){
					$("#img_education").attr("src","/users" + ar[18] + "?times=" + (new Date().getTime()));
					$("#img_education").attr("value","/users" + ar[18]);
				}else{
					$("#img_education").attr("src","images/blank_education.png" + "?times=" + (new Date().getTime()));
				}
				if(ar[31] > ""){
					$("#img_CHESICC").attr("src","/users" + ar[31] + "?times=" + (new Date().getTime()));
					$("#img_CHESICC").attr("value","/users" + ar[31]);
				}else{
					$("#img_CHESICC").attr("src","images/blank_CHESICC.png" + "?times=" + (new Date().getTime()));
				}
				if(ar[32] > ""){
					$("#img_employment").attr("src","/users" + ar[32] + "?times=" + (new Date().getTime()));
					$("#img_employment").attr("value","/users" + ar[32]);
				}else{
					$("#img_employment").attr("src","images/blank_employment.png" + "?times=" + (new Date().getTime()));
				}
				if(ar[33] > ""){
					$("#img_jobCertificate").attr("src","/users" + ar[33] + "?times=" + (new Date().getTime()));
					$("#img_jobCertificate").attr("value","/users" + ar[33]);
				}else{
					$("#img_jobCertificate").attr("src","images/blank_jobCertificate.png" + "?times=" + (new Date().getTime()));
				}
				
				//$("#photo").html(c);
				//getDownloadFile("studentID");
				original_item = arr.join("").substr(1);
				getStudentCourseList(ar[1]);
				setButton();
			}else{
				alert("该信息未找到！","信息提示");
				op = 1;
				setButton();
			}
		});
	}
	
	function saveNode(){
		$.messager.progress();	// 显示进度条
		refID = $("#username").textbox("getValue");
		kindID = $("#kindID").combobox("getValue");
		
		$('#forms').form('submit', {   
			url: "studentControl.asp?op=update&times=" + (new Date().getTime()),   
			onSubmit: function(){   
				var isValid = $(this).form('validate');
				
				if(op==1 && kindID==0 && (refID=="" || checkIDcard(refID) > 1)){
					$.messager.alert("提示","身份证号码有误，请核对。","warning");
					isValid = false;
				}
				if($("#mobile").textbox("getValue").replace(' ','').length != 11){
					$.messager.alert("提示","请正确填写手机号码。","warning");
					isValid = false;
				}
				if($("#name").textbox("getValue")==""){
					$.messager.alert("提示","请填写姓名。","warning");
					isValid = false;
				}
				if($("#address").textbox("getValue")==""){
					$.messager.alert("提示","请填写联系地址。","warning");
					isValid = false;
				}
				if(kindID!=0 && $("#birthday").datebox("getValue")==""){
					$.messager.alert("提示","请填写出生日期。","warning");
					isValid = false;
				}
				if (!isValid){
					$.messager.progress('close');	// 如果表单是无效的则隐藏进度条
				}else{
					$("#username").textbox("enable");	//先解除身份证只读，否则后台无法读取数据。
				}
				return isValid;	// 返回false终止表单提交
			},   
			success:function(data){  
				// alert(unescape(data));
				if(kindID==0 && replace_item > ""){
					//上传被替换的图片
					//替换原来的图片资料
					var ar = new Array();
					ar = replace_item.split(",");
					$.each(ar,function(iNum,val){
						if(val=="photo"){
							//替换照片
							$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_photo",username:refID,name:$("#name").textbox("getValue"),currUser:currUser,imgData:cardJson.base64Data},function(re){
								//alert(re.status);
							});
						}
						if(val=="cardA"){
							//替换身份证正面
							$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_IDcardA",username:refID,name:$("#name").textbox("getValue"),currUser:currUser,imgData:cardJson.imageFront},function(re){
								//alert(re.status);
							});
						}
						if(val=="cardB"){
							//替换身份证反面
							$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_IDcardB",username:refID,name:$("#name").textbox("getValue"),currUser:currUser,imgData:cardJson.imageBack},function(re){
								//alert(re.status);
							});
						}
					});
				}

				updateCount += 1;
				getNodeInfo(0,refID);
				if(op==1){
					op = 0;
					//新学员保存后直接进入报名页面
					showEnterInfo(0,refID,1,1,"","getStudentCourseList(refID)");
				}else{
					if(fromCard==0){
						$.messager.alert("提示","保存成功！", "info");
					}
					fromCard = 0;
					$("#enter").focus();
				}
				$.messager.progress('close');	// 如果提交成功则隐藏进度条 
			}   
		});
	}

	function getStudentCourseList(id){
		$.get("studentCourseControl.asp?op=getStudentCourseList&mark=2&keyID=" + id,function(data1){
			//alert(unescape(data1));
			var ar = new Array();
			var arr1 = new Array();
			ar = unescape(data1).split("%%");
			ar.shift();
			ar.shift();
			arr1.push("<table class='table_help' width='100%'>");
			arr1.push("<tr align='center' bgcolor='#e0e0e0'>");
			arr1.push("<td width='25%'>课程名称</td><td width='8%'>考试</td><td width='20%'>证书编号</td><td width='10%'>进度%</td><td width='10%'>缴费</td><td width='18%'>销售</td><td width='10%'>部门</td>");
			arr1.push("</tr>");
			//var imgChk = "<img src='images/green_check.png'>";
			if(ar > ""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					var d = "";
					//if(ar1[44]==1){
						//d = imgChk;
					//}
					var c = "#E0EEE0;";
					if(ar1[77] == 0){	//未付款
						c = "#FFFACD;";
					}
					if(ar1[77] == 2){	//退款
						c = "#DDDDDD;";
					}
					arr1.push("<tr style='background-color:" + c + "'>");
					arr1.push("<td><a style='text-decoration:none;' href='javascript:showEnterInfo(" + ar1[0] + ",\"" + refID + "\",0,1,\"\",\"getStudentCourseList(refID)\");'>" + ar1[87] + "</a></td><td>" + ar1[83] + "</td><td>" + ar1[55] + "</td><td>" + ar1[7] + "</td><td>" + ar1[86] + "</td><td>" + ar1[104] + "&nbsp;" + ar1[29] + "</td><td>" + ar1[90] + "</td>");
					arr1.push("</tr>");
				});
			}
			arr1.push("</table>");
			$("#enterCover").html(arr1.join(""));
		});
	}
	
	function setButton(){
		$("#reply").hide();
		$("#add").hide();
		$("#btnSave").hide();
		$("#open").hide();
		$("#close").hide();
		$("#reset").hide();
		$("#btnDel").hide();
		$("#smsList").hide();
		$("#examList").hide();
		$("#enter").hide();
		$("#username").textbox("disable");
		$("#age").textbox("disable");
		$("#statusName").textbox("disable");
		$("*[tag='plus'").hide();
		$("#mark").val(1);
		$("#sex").combobox("disable");
		$("#birthday").datebox("disable");
		//$("#birthday").prop("disabled",true);
		if(op==1){
			$("#btnSave").show();
			$("#add_img_education").hide();
			$("#username").textbox("enable");
			setEmpty();
			//$("#save").focus();
		}else{
			if($("#kindID").combobox("getValue") != 0){
				$("#sex").combobox("enable");
				$("#birthday").datebox("enable");
			}
			if(checkPermission("messageAdd")){
				$("#reply").show();
			}
			if(checkPermission("studentAdd")){
				$("#open").show();
				$("#close").show();
				$("#btnSave").show();
				$("#enter").show();
				$("#add").show();
			}
			if(checkPermission("studentEdit")){
				$("#btnSave").show();
				$("#reset").show();
			}
			if(checkPermission("studentPhoto")){
				//$("#upload1").show();
				$("*[tag='plus'").show();
			}
			if(checkPermission("studentDel")){
				$("#close").show();
			}
			if(checkPermission("studentKill")){
				$("#btnDel").show();
			}
			if($("#status").val()==0){
				$("#open").hide();
			}else{
				$("#close").hide();
			}
			$("#smsList").show();
			$("#examList").show();
		}
	}
	
	function setEmpty(){
		$("#studentID").val(0);
		$("#username").textbox("initValue","");
		$("#name").textbox("setValue","");
		$("#sex").combobox("setValue",0);
		$("#age").textbox("setValue","");
		$("#mobile").textbox("setValue","");
		$("#phone").textbox("setValue","");
		$("#email").textbox("setValue","");
		$("#linker").textbox("setValue","");
		$("#kindID").combobox("setValue",0);
		$("#statusName").textbox("setValue","");
		$("#address").textbox("setValue","");
		$("#province").textbox("setValue","201600");
		$("#ethnicity").textbox("setValue","汉");
		$("#IDaddress").textbox("setValue","");
		$("#bureau").textbox("setValue","");
		$("#IDdateStart").datebox("setValue","");
		$("#IDdateEnd").datebox("setValue","");
		$("#job_status").combobox("setValue",1);	//默认就业
		$("#memo").textbox("setValue","");
		$("#job").combobox("setValue","普工");	//默认普工
		$("#regDate").textbox("setValue",currDate);
		$("#education").combobox("setValue",2);
		$("#enterCover").empty();
		$("#img_photo").attr("src","");
		$("#img_cardA").attr("src","");
		$("#img_cardB").attr("src","");
		$("#img_education").attr("src","");
		$("#mark").val(0);
		$("#scanID").val(1);
		$("#unit").textbox("textbox").css("border", "solid 1px red");
		$("#address").textbox("textbox").css("border", "solid 1px red");
		$("#mobile").textbox("textbox").css("border", "solid 1px red");
		$("#IDdateStart").datebox("textbox").css("border", "solid 1px red");
		$("#IDdateEnd").datebox("textbox").css("border", "solid 1px red");
	}

	function dealResponse(re){
		var k = 0;
		var n = studentExist(re.certNo);
		cardJson = re;
		if(re.expire<currDate.replace("-","")){
			alert("该身份证已过有效期。");
		}
		if(k==0 && op==0 && re.certNo != refID){
			//编辑状态，如果是新的身份证，则自动定位到身份证之人，并进入编辑状态。
			k = 1;
			if(n>0){
				//已有该身份证记录，则调出原记录，进入编辑状态
				getNodeInfo(0,re.certNo);
				//弹出窗口，可选择覆盖原来的照片、身份证图片
				//替换原来的图片资料
				//showUseCardInfo();
				checkName(re.name);
			}else{
				op = 1;
				setButton();
				//填充文字
				$("#studentID").val(0);
				$("#username").textbox("initValue",re.certNo);
				$("#name").textbox("initValue",re.name);
				if(re.sex == "男"){
					$("#sex").combobox("setValue",1);
				}else{
					$("#sex").combobox("setValue",0);
				}


				//填充全部图片
				//replaceImgFromCard("photo,cardA,cardB");
			}
		}
		if(k==0 && op==0 && re.certNo == refID){
			//编辑状态，如果是当前的身份证，则比较其信息
			checkName(re.name);
			//弹出窗口，可选择覆盖原来的照片、身份证图片
			//替换原来的图片资料
			//showUseCardInfo();
			k = 1;
		}
		if(k==0 && op==1){
			//添加状态，先检查是否有该身份证的记录。
			k = 1;
			if(n>0){
				//已有该身份证记录，则调出原记录，进入编辑状态
				op = 0;
				getNodeInfo(0,re.certNo);
				//弹出窗口，可选择覆盖原来的照片、身份证图片
				//替换原来的图片资料
				//showUseCardInfo();
				checkName(re.name);
				//if(re.name != $("#name").val()){
					//校验姓名
				//	alert("姓名与身份证信息不符，请核对。");
				//}
			}else{
				//填充文字
				$("#studentID").val(0);
				$("#username").textbox("initValue",re.certNo);
				$("#name").textbox("initValue",re.name);
				if(re.sex == "男"){
					$("#sex").combobox("setValue",1);
				}else{
					$("#sex").combobox("setValue",0);
				}
				//填充全部图片
				//replaceImgFromCard("photo,cardA,cardB");
			}
		}
		//填充全部图片
		replaceImgFromCard("photo,cardA,cardB");

		//填充身份证信息
		$("#ethnicity").textbox("setValue",re.nation);
		$("#IDaddress").textbox("setValue",re.address);
		// if($("#address").textbox("getValue")==""){
		// 	$("#address").textbox("setValue",re.address);
		// }
		$("#bureau").textbox("setValue",re.department);
		$("#IDdateStart").datebox("setValue",re.effectData.substr(0,4)+"-"+re.effectData.substr(4,2)+"-"+re.effectData.substr(6,2));
		if(re.expire=="长期"){
			$("#IDdateEnd").combo('setValue', '').combo('setText', '');
			$("#IDdateEnd").combo("readonly",true);
		}else{
			$("#IDdateEnd").datebox("setValue",re.expire.substr(0,4)+"-"+re.expire.substr(4,2)+"-"+re.expire.substr(6,2));
			$("#IDdateEnd").datebox("readonly",false);
		}
		$("#scanID").val(0);
	}
	
	function replaceImgFromCard(item){
		replace_item = item;
		//替换原来的图片资料
		var ar = new Array();
		ar = item.split(",");
		$.each(ar,function(iNum,val){
			if(val=="photo"){
				//替换照片
				$("#img_photo").attr("src","data:image/jpeg;base64,"+cardJson.base64Data);
			}
			if(val=="cardA"){
				//替换身份证正面
				$("#img_cardA").attr("src","data:image/jpeg;base64,"+cardJson.imageFront);
			}
			if(val=="cardB"){
				//替换身份证反面
				$("#img_cardB").attr("src","data:image/jpeg;base64,"+cardJson.imageBack);
			}
		});
		if(op==1){
			$("#btnSave").focus();
		}else{
			fromCard = 1;
			setTimeout(function(){
				saveNode();
			},1000);
			
		}
	}
	
	function checkName(cname){
		if(cname != $("#name").textbox("getValue")){
			//校验姓名
			alert("当前姓名[" + $("#name").textbox("getValue") + "]与身份证信息不符，已更正。");
			$("#name").textbox("setValue",cname);
		}
	}

	function getEnterList(){
		//nothing, just callback enterInfo return's event
	}

	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div style="float:left;width:70%;">
	<div style="width:100%;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8; float:left;width:100%;">
			<form id="forms" method="post" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table style="width:100%;">
			<tr><input type="hidden" id="studentID" /><input type="hidden" id="status" name="status" /><input type="hidden" id="mark" name="mark" /><input type="hidden" id="scanID" name="scanID" />
				<td align="right" style="width:10%;">证件号</td>
				<td><input id="username" name="username" class="easyui-textbox" data-options="height:22,width:185,required:true" /></td>
				<td align="right">类别</td>
				<td><select id="kindID" name="kindID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22" style="width:85px;"></select>
				&nbsp;&nbsp;姓名&nbsp;<input id="name" name="name" class="easyui-textbox" data-options="height:22,width:60,required:true" /></td>
			</tr>
			<tr>
				<td align="right">性别</td>
				<td><select id="sex" name="sex" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:80"></select>&nbsp;&nbsp;年龄&nbsp;<input class="easyui-textbox" data-options="height:22,width:70" id="age" name="age" /></td>
				<td align="right">出生日期</td>
				<td><input id="birthday" name="birthday" class="easyui-datebox" data-options="height:22,width:100" /></td>
			</tr>
			<tr>
				<td align="right">证件期限</td><td align="left" colspan="2"><input id="IDdateStart" name="IDdateStart" class="easyui-datebox" data-options="height:22,width:100,required:true" />&nbsp;至&nbsp;<input id="IDdateEnd" name="IDdateEnd" class="easyui-datebox" data-options="height:22,width:100" /></td>
				<td align="left">民族&nbsp;<input id="ethnicity" name="ethnicity" class="easyui-textbox" data-options="height:22,width:80" /></td>
			</tr>
			<tr>
				<td align="right">证件地址</td>
				<td colspan="2"><input id="IDaddress" name="IDaddress" class="easyui-textbox" data-options="height:22,width:255" /></td>
				<td align="left">发证机关&nbsp;<input id="bureau" name="bureau" class="easyui-textbox" data-options="height:22,width:130" /></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><input id="statusName" name="statusName" class="easyui-textbox" data-options="height:22,width:185" /></td>
				<td align="right">文化程度</td>
				<td><select id="education" name="education" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select></td>
			</tr>
			<tr id="znxf_dept">
				<td align="right">单位名称</td>
				<td><input id="unit" name="unit" class="easyui-textbox" data-options="height:22,width:185,required:true" /></td>
				<td align="right">岗位职务</td>
				<td><select id="job" name="job" class="easyui-combobox" data-options="editable:true,panelHeight:'auto',height:22,width:180"></select></td>
			</tr>
			<tr>
				<td align="right">联系地址</td>
				<td><input id="address" name="address" class="easyui-textbox" data-options="height:22,width:185,required:true" /></td>
				<td align="right">手机</td>
				<td><input id="mobile" name="mobile" class="easyui-textbox" data-options="height:22,width:185,required:true" /></td>
			</tr>
			<tr>
				<td align="right">单位地址</td>
				<td><input id="email" name="email" class="easyui-textbox" data-options="height:22,width:185" /></td>
				<td align="right">单位电话</td>
				<td><input id="phone" name="phone" class="easyui-textbox" data-options="height:22,width:185" /></td>
			</tr>
			<tr>
				<td align="right">联系人</td>
				<td>
					<input id="linker" name="linker" class="easyui-textbox" data-options="height:22,width:75" />
					&nbsp;&nbsp;邮编&nbsp;<input id="province" name="province" class="easyui-textbox" data-options="height:22,width:75" />
				</td>
				<td align="right">就业状态</td>
				<td><select id="job_status" name="job_status" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="3"><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:480" /></td>
			</tr>
			<tr>
				<td align="right">注册日期</td>
				<td><input id="regDate" class="easyui-textbox" data-options="height:22,width:185" /></td>
				<td align="right">注册人</td><td><input id="registerName" class="easyui-textbox" data-options="editable:false,height:22,width:185" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>

	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="buttonbox">
		<a class="easyui-linkbutton" id="add" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="btnSave" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="open" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="close" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="reset" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="btnDel" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="smsList" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="examList" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="opList" href="javascript:void(0)"></a>
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fcfcfc;clear:both;">
		<a class="easyui-linkbutton" id="enter" href="javascript:void(0)"></a>
  	</div>
	<hr size="1" noshadow />
	<div id='enterCover'></div>
</div>
<div style="padding: 5px;text-align:center;overflow:hidden;margin:0 auto;flot:right;background: #eeeeff;" id="xx">
	<table style="width:99%;">
	<tr>
		<td align="right" style="width:15%;">
			<img id="add_img_photo" src="images/plus.png" tag="plus" />
			<div style="padding-top:5px;"><input class="easyui-checkbox" id="scanPhoto" name="scanPhoto" />识</div>
		</td>
		<td align="center" style="width:85%;">
			<img id="img_photo" src="" value="" style='width:100px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_cardA" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_cardA" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_cardB" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_cardB" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_education" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_education" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_CHESICC" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_CHESICC" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_employment" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_employment" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_jobCertificate" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_jobCertificate" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="left" colspan="2" style="width:100%;"><textarea id="text_reader_result" style="padding:5px;width:90%;background: #eeeeee;border:solid 1px #ccc;color:#ff0000;" rows="2"></textarea></td>
	</tr>
	</table>
</div>
</div>
</body>
