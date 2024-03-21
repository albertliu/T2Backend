	var enterListLong = 0;		//0: 标准栏目  1：短栏目
	var enterListChk = 0;
	var timer1 = null;
	let enterListDateKind = 0;

	$(document).ready(function (){
		// getComboBoxList("planStatus","searchEnterStatus",1);
		// getComboBoxList("statusPay","searchEnterPay",1);
		// getComboList("searchEnterCourseID","[dbo].[getEnterQtyInPool]('" + currHost + "'," + currPartner + ")","courseID","courseName","1=1 order by seq",1);
        // getComboList("searchEnterPartner","partnerInfo","ID","title","status=0 and host='" + currHost + "' order by ID",1);
        // getComboList("searchEnterAgencyID","agencyInfo","agencyID","title","status=0 order by seq",1);
		// getComboBoxList("statusSubmit","searchEnterSubmit",0);
        // getComboList("searchEnterSales","userInfo","username","realName","status=0 and host='" + currHost + "' and username in(select username from roleUserList where roleID='saler') order by realName",1);
		
		getComboList("searchEnterHost","hostInfo","hostNo","title","status=0 and hostNo<>'" + currHost + "' order by hostNo",1);
		getComboBoxList("statusSubmit","searchEnterSubmit",0);
		
		$("#btnEnterApplyImport1").hide();

		$("#txtSearchEnter").textbox('textbox').css('background','#FFFF00');
		
		$("#btnSearchEnterAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				if(checkPartner == 1 && $("#searchEnterHost").combobox("getValue") == ""){
					$.messager.alert("提示","请选择一个主管单位。","warning");
					return false;
				}
				showStudentInfo(0,0,1,1,"enter");
			}
		});
		
		$("#searchEnterCourseID").combobox({
			onChange:function() {
				let c = $("#searchEnterCourseID").combobox("getValue");
				if(c>""){
					$.get("courseControl.asp?op=getNodeInfo&nodeID=0&refID=" + c + "&times=" + (new Date().getTime()),function(re){
						//alert(unescape(re));
						var ar = new Array();
						ar = unescape(re).split("|");
						if(ar > ""){
							if(ar[21]==1 && ar[28]==1){
								//安监复训
								$("#searchEnterDateLabel").text("复训日期");
								enterListDateKind = 1;
							}else{
								$("#searchEnterDateLabel").text("报名日期");
								enterListDateKind = 0;
							}
						}
					});
				}else{
					$("#searchEnterDateLabel").text("报名日期");
					enterListDateKind = 0;
				}
				getEnterList();
			}
		});
		
		$("#searchEnterHost").combobox({
			onChange:function(val) {
				getEnterList();
			}
		});
		
		$("#searchEnterSubmit").combobox({
			onChange:function(val) {
				if(val==0){
					//未提交的，可以提交或分拣
					$("#btnEnterSubmit").linkbutton("enable");
					$("#btnEnterSort").linkbutton("enable");
				}else{
					$("#btnEnterSubmit").linkbutton("disable");
					$("#btnEnterSort").linkbutton("disable");
				}
			}
		});
		
		$("#searchEnterHostCheck").checkbox({
			onChange:function(val) {
				if(val){
					checkPartner = 1;
				}else{
					checkPartner = 0;
				}
				setEnterListMenu();
				setHostMenu();
			}
		});

		$("#searchEnterCourseID").combobox({
			onShowPanel:function() {
				var id = $("#searchEnterAgencyID").combobox("getValue");
				if(id > ""){
					getComboList("searchEnterCourseID","[dbo].[getEnterQtyInPool]('" + currHost + "'," + currPartner + ")","courseID","courseName","agencyID='" + id + "' order by seq",1);
				}else{
					getComboList("searchEnterCourseID","[dbo].[getEnterQtyInPool]('" + currHost + "'," + currPartner + ")","courseID","courseName","1=1 order by seq",1);
				}
			}
		});
		$("#searchEnterAgencyID").combobox({
			onShowPanel:function() {
				getComboList("searchEnterAgencyID","agencyInfo","agencyID","title","status=0 order by seq",1);
			}
		});
		$("#searchEnterStartDate").datebox({
			onChange:function() {
				var id = $("#searchEnterStartDate").datebox("getValue");
				if(id == "" && $("#searchEnterCourseID").combobox("getValue")==""){
					$("#searchEnterStartDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
				}
			}
		});
		$("#searchEnterStatus").combobox({
			onShowPanel:function() {
				getComboBoxList("planStatus","searchEnterStatus",1);
			}
		});
		$("#searchEnterPay").combobox({
			onShowPanel:function() {
				getComboBoxList("statusPay","searchEnterPay",1);
			}
		});
		$("#searchEnterSales").combobox({
			onShowPanel:function() {
				getComboList("searchEnterSales","userInfo","username","realName","status=0 and host='" + currHost + "' and username in(select username from roleUserList where roleID='saler') order by realName",1);
			}
		});
		
		$("#btnAttentionPhoto").linkbutton({
			iconCls:'icon-send',
			width:85,
			height:25,
			text:'照片通知',
			onClick:function() {
				getSelCart("visitstockchkEnter");
				if(selCount==0){
					jAlert("请选择要通知的名单。");
					return false;
				}
				jConfirm("确定通知将这" + selCount + "个学员提交电子照片吗？","确认",function(r){
					if(r){
						//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
						$.post(uploadURL + "/public/send_message_submit_photo", {kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
							//jAlert(data);
							getEnterList();
							jAlert("发送成功。");
						});
					}
				});
			}
		});
		
		$("#btnAttentionSignature").linkbutton({
			iconCls:'icon-send',
			width:85,
			height:25,
			text:'签名通知',
			onClick:function() {
				getSelCart("visitstockchkEnter");
				if(selCount==0){
					jAlert("请选择要通知的名单。");
					return false;
				}
				jConfirm("确定要通知这" + selCount + "个学员完成签名吗？","确认",function(r){
					if(r){
						//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
						$.post(uploadURL + "/public/send_message_submit_signature", {batchID: $("#classID").val(), selList: selList, SMS:1, registerID: currUser} ,function(data){
							//jAlert(data);
							getEnterList();
							jAlert("发送成功。");
						});
					}
				});
			}
		});
		
		$("#btnAttentionPhotoClose").linkbutton({
			iconCls:'icon-ok',
			width:85,
			height:25,
			text:'照片确认',
			onClick:function() {
				getSelCart("visitstockchkEnter");
				if(selCount==0){
					jAlert("请选择要确认照片的名单。");
					return false;
				}
				jConfirm("确定要将这" + selCount + "个提交电子照片通知关闭吗？","确认",function(r){
					if(r){
						//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
						$.post(uploadURL + "/public/send_message_submit_attention_close", {batchID: "", kindID:0, kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
							//jAlert(data);
							getEnterList();
							jAlert("操作成功。");
						});
					}
				});
			}
		});
		
		$("#btnAttentionSignatureClose").linkbutton({
			iconCls:'icon-ok',
			width:85,
			height:25,
			text:'签名确认',
			onClick:function() {
				getSelCart("visitstockchkEnter");
				if(selCount==0){
					jAlert("请选择要确认签名的名单。");
					return false;
				}
				jConfirm("确定要将这" + selCount + "个提交签名通知关闭吗？","确认",function(r){
					if(r){
						//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
						$.post(uploadURL + "/public/send_message_submit_attention_close", {batchID: $("#classID").val(), kindID:1, kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
							//jAlert(data);
							getEnterList();
							jAlert("操作成功。");
						});
					}
				});
			}
		});
		
		$("#btnEnterApply").linkbutton({
			iconCls:'icon-filter',
			width:80,
			height:25,
			text:'去申报',
			onClick:function() {
				getSelCart("visitstockchkEnter");
				c = $("#searchEnterCourseID").combobox("getValue");
				if(c==""){
					jAlert("请选择一个课程。");
					return false;
				}
				if(selCount==0){
					jAlert("请选择要申报的名单。");
					return false;
				}
				setSession("applyPicker", selList);
				showApplyPicker(c, selCount, 0, "getEnterList()", 1);
			}
		});
		
		$("#btnEnterApplyByExcel").linkbutton({
			iconCls:'icon-filter',
			width:85,
			height:25,
			text:'接龙申报',
			onClick:function() {
				c = $("#searchEnterCourseID").combobox("getValue");
				if(c==""){
					jAlert("请选择一个课程。");
					return false;
				}
				showUploadFile(c, "", "apply_picker", "接龙申报名单", "getEnterList(reDo)", 1, 1);
			}
		});
		
		$("#btnEnterApplyImport1").linkbutton({
			iconCls:'icon-download',
			width:110,
			height:25,
			text:'导入申报结果',
			onClick:function() {
				c = $("#searchEnterCourseID").combobox("getValue");
				if(c==""){
					jAlert("请选择一个课程。");
					return false;
				}
				showUploadFile(0, c, "apply_list", "申报结果（考试安排）名单", "getEnterList()",1, 1);
			}
		});
		
		$("#btnEnterApplyImport2").linkbutton({
			iconCls:'icon-download',
			width:110,
			height:25,
			text:'导入成绩证书',
			onClick:function() {
				c = $("#searchEnterCourseID").combobox("getValue");
				if(c==""){
					jAlert("请选择一个课程。");
					return false;
				}
				showUploadFile(0, c, "apply_score_list", "成绩证书名单", "getEnterList()",1, 1);
			}
		});
		
		$("#btnEnterStudentImport").linkbutton({
			iconCls:'icon-download',
			width:110,
			height:25,
			text:'导入报名表',
			onClick:function() {
				let c = $("#searchEnterCourseID").combobox("getValue");
				if(c==""){
					jAlert("请选择一个课程。");
					return false;
				}
				showUploadFile(c, "", "student_list", "批量报名名单", "getEnterList()",1, 1);
			}
		});
		
		$("#btnEnterSubmit").linkbutton({
			iconCls:'icon-ok',
			width:85,
			height:25,
			text:'报名提交',
			onClick:function() {
				getSelCart("visitstockchkEnter");
				if(selCount==0){
					jAlert("请选择要提交的名单。");
					return false;
				}
				let d = $("#searchEnterHost").combobox("getValue");
				if(d==""){
					jAlert("请选择一个主管学校。");
					return false;
				}
				jConfirm("确定要这" + selCount + "个人的报名提交到" + $("#searchEnterHost").combobox("getText") + "吗？","确认",function(r){
					if(r){
						//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
						$.post(uploadURL + "/public/submit_enter_inpool", {selList: selList, registerID: currUser} ,function(data){
							//jAlert(data);
							getEnterList();
							jAlert("操作成功。");
						});
					}
				});
			}
		});
		
		$("#btnEnterSort").linkbutton({
			iconCls:'icon-filter',
			width:85,
			height:25,
			text:'报名分拣',
			onClick:function() {
				getSelCart("visitstockchkEnter");
				if(selCount==0){
					jAlert("请选择要分拣的名单。");
					return false;
				}

				$.get("hostControl.asp?op=getHostListPure",function(data){
					//alert(unescape(data));
					var ar = $.parseJSON(unescape(data));
					jSelect("<p style='color:red; font-size:1.1em;'>要更改这" + selCount + "个人的学校标记</p>请选择目标学校：", ar, "学员分拣", function(d){
						d = d.replace(/\s*/g,"");
						if(d > ""){
							//alert($("#searchStudentPreProjectID").val() + "&status=1&host=" + $("#searchStudentPreHost").val() + "&keyID=" + selList);
							alert(uploadURL + ":" + d + ":" + selList);
							$.post(uploadURL + "/public/sort_enter_host", {selList: selList, host:d, registerID: currUser} ,function(data1){
								//jAlert(data1);
								getEnterList();
								jAlert("操作成功。");
							});
						}else{
							jAlert("目标学校不能为空。");
						}
					});
				});
			}
		});
		
		$("#btnEnterReturn").linkbutton({
			iconCls:'icon-undo',
			width:85,
			height:25,
			text:'退回部门',
			onClick:function() {
				getSelCart("visitstockchkEnter");
				if(selCount==0){
					jAlert("请选择要退回的名单。");
					return false;
				}
				let d = $("#searchEnterPartner").combobox("getValue");
				if(d==""){
					jAlert("请选择一个部门。");
					return false;
				}
				if(!$("#searchEnterPool").checkbox("options").checked){
					jAlert("请勾选候考标识。");
					return false;
				}
				jConfirm("确定要这" + selCount + "个人的报名退回到" + $("#searchEnterPartner").combobox("getText") + "吗？","确认",function(r){
					if(r){
						//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
						$.post(uploadURL + "/public/return_enter_partner", {selList: selList, registerID: currUser} ,function(data){
							//jAlert(data);
							getEnterList();
							jAlert("操作成功。");
						});
					}
				});
			}
		});
		
		$("#btnEnterSel").linkbutton({
			width:70,
			height:25,
			text:'全选/取消',
			onClick:function() {
				setSel("visitstockchkEnter");
				$("#searchEnterPick").html(selCount);
			}
		});
		
		if(!checkPermission("studentAdd")){
			$("#btnSearchEnterAdd").hide();
			$("#btnEnterStudentImport").hide();
		}
		
		if(!checkPermission("applyEdit")){
			$("#enterApplyItem").hide();
		}

		$("#btnSearchEnterDownload").click(function(){
			getEnterList();
			outputFloat(101,'file');
		});

		$("#enterPhotoItem").hide();
		$("#enterQRItem").hide();
		
		$("#btnSearchQR").linkbutton({
			iconCls:'icon-qr',
			width:95,
			height:25,
			text:'二维码队列',
			onClick:function() {
				// showQRshowInfo(0,0,0,0);
				// window.open("qrShow.asp","", 'height=' + screen.height+100 + ', width=' + screen.width+100 + ', top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no', "_blank");
				// window.open("qrShow.asp","", 'top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no', "_blank");
				var w=screen.availWidth;
				var h=screen.availHeight;        
				window.open('qrShow.asp','qrShow','fullscreen,width='+w+',height='+h+',top=0,left=0,status=yes,location=no');
			}
		});
		$("#searchEnterPool").checkbox({
			onChange: function(val){
				getEnterList();
			}
		});
		$("#searchEnterNosort").checkbox({
			onChange: function(val){
				getEnterList();
			}
		});
		$("#searchEnterPartner").combobox({
			onChange: function(val){
				getEnterList();
			}
		});

		$("#searchEnterStartDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
	});

	function getEnterList(list){
		sWhere = $("#txtSearchEnter").textbox("getValue");
		var photo = 0;
		var pool = 0;
		var trys = 0;
		var inv = 0;
		let nosort = 0;
		if($("#searchEnterShowPhoto").checkbox("options").checked){
			photo = 1;
			// $("#enterPhotoItem").show();
		}else{
			// $("#enterPhotoItem").hide();
		}
		if($("#searchEnterPool").checkbox("options").checked){
			pool = 1;
		}
		if($("#searchEnterNosort").checkbox("options").checked){
			nosort = 1;
		}
		if($("#searchEnterTry").checkbox("options").checked){
			trys = 1;
		}
		if($("#searchEnterInvoice").checkbox("options").checked){
			inv = 1;
		}
		// alert("&partnerID=" + $("#searchEnterPartner").combobox("getValue"));
		$.get("studentCourseControl.asp?op=getStudentCourseList&where=" + escape(sWhere) + "&enterListDateKind=" + enterListDateKind + "&photo=" + photo + "&list=" + list + "&pool=" + pool + "&nosort=" + nosort + "&needInvoice=" + inv + "&try=" + trys + "&host=" + $("#searchEnterHost").combobox("getValue") + "&partnerID=" + $("#searchEnterPartner").combobox("getValue") + "&status=" + $("#searchEnterStatus").combobox("getValue") + "&sales=" + $("#searchEnterSales").combobox("getValue") + "&courseID=" + $("#searchEnterCourseID").combobox("getValue") + "&pay=" + $("#searchEnterPay").combobox("getValue") + "&submited=" + $("#searchEnterSubmit").combobox("getValue") + "&fStart=" + $("#searchEnterStartDate").datebox("getValue") + "&fEnd=" + $("#searchEnterEndDate").datebox("getValue") + "&completion1=" + $("#searchEnter_completion1").textbox("getValue") + "&dk=101&times=" + (new Date().getTime()),function(data){
		//$.getJSON("enterControl.asp?op=getEnterList",function(data){
			// alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#enterCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			var ar2 = new Array();
			var role = checkRole("teacher");
			let r = checkPermission("applyEdit");
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='enterTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='10%'>证件号码</th>");
			arr.push("<th width='5%'>姓名</th>");
			arr.push("<th width='9%'>课程名称</th>");
			// arr.push("<th width='10%'>单位名称</th>");
			arr.push("<th width='7%'>电话</th>");
			arr.push("<th width='6%'>签名</th>");
			if(photo == 0){
				arr.push("<th width='6%'>材料</th>");
				arr.push("<th width='5%'>进度</th>");
				// arr.push("<th width='5%'>练习</th>");
				// arr.push("<th width='4%'>申报</th>");
				arr.push("<th width='5%'>成绩</th>");
				arr.push("<th width='4%'>补考</th>");
				arr.push("<th width='4%'>收费</th>");
			}else{
				arr.push("<th width='6%'>照片</th>");
				arr.push("<th width='6%'>身份证</th>");
				arr.push("<th width='6%'>学历</th>");
				// arr.push("<th width='6%'>在职</th>");
			}
			arr.push("<th width='6%'>复审日期</th>");
			if(checkPermission("applyEdit")){
				arr.push("<th width='4%'>部门</th>");
			}
			arr.push("<th width='5%'>状态</th>");
			// arr.push("<th width='5%'>证书</th>");
			arr.push("<th width='10%'>销售</th>");
			if(checkPartner == 1){
				arr.push("<th width='5%'>主管</th>");
			}
			arr.push("<th width='2%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var n = 0;
				var attention_status = ["FFFFAA","AAFFAA","F3F3F3"];
				let photo_size = 0;
				let photo_type = "jpg";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					h = ar1[13];	//公司用户显示部门1名称
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(" + ar1[0] + ",\"" + ar1[1] + "\",0,1,\"\",\"\");'>" + ar1[1] + "</a></td>");
					arr.push("<td class='link1'" + (ar1[107]==1 ? " style='background-color:#FFFFAA;'" : "") + "><a href='javascript:showStudentInfo(0,\"" + ar1[1] + "\",0,1);'>" + ar1[8] + "</a></td>");
					arr.push("<td class='left'>" + ar1[87] + "</td>");
					// arr.push("<td class='left'>" + ar1[35] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					if(ar1[46]>0){
						h = " style='background-color:#" + attention_status[ar1[46]-1] + ";'";
					}else{
						h = "";
					}
					if(ar1[43] > ""){	//签字
						arr.push("<td class='center'" + h + "><img src='users" + ar1[43] + "?times=" + (new Date().getTime()) + "' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
					}else{
						arr.push("<td class='center'" + h + ">&nbsp;</td>");
					}
					if(photo == 0){
						arr.push("<td class='left' title='照片 身份证正面 身份证反面 学历证明'>" + (ar1[22]>""?imgChk:imgChkWrong) + (ar1[23]>""?imgChk:imgChkWrong) + (ar1[24]>""?imgChk:imgChkWrong) + (ar1[25]>"" ? imgChk : (ar1[37]==0 ? imgChkWrong : "")) + "</td>");	//材料
						c = ar1[7];
						if(c>0){
							c = c;
						}else{
							c = "";
						}
						arr.push("<td class='center'>" + (ar1[7]>0?ar1[7]:"") + "</td>");	//学习进度
						// arr.push("<td class='center'>" + (ar1[98]>0?ar1[98]:"") + "</td>");	//模拟成绩
						// arr.push("<td class='center'>" + (ar1[53]==1?imgChk:"") + "</td>");	//申报
						arr.push("<td class='center'>" + (nullNoDisp(ar1[78].replace(".00","")) + (ar1[100]==1?("/" + nullNoDisp(ar1[79].replace(".00",""))):"")) + "</td>");	//成绩:应知/应会
						arr.push("<td class='left'>" + (ar1[97]>0?ar1[97]:"") + "</td>");	//补考次数
						arr.push("<td class='left'>" + ar1[86] + "</td>");	//付费
					}else{
						photo_type = ar1[22].substr(ar1[22].indexOf("."));
						photo_size = ar1[102];
						if(ar1[22] > "" && ar1[103] !== 4 && (photo_type !== ".jpg" || (ar1[103] == 1 && photo_size > 100))){	//根据照片类型或文件大小，显示不同背景颜色
							h = " style='background-color:#FFFFAA;'";
						}else{
							h = "";
						}
						if(ar1[22] > ""){	//照片
							arr.push("<td class='center'" + h + "><img id='photo" + ar1[1] + "' title='大小：" + photo_size + "k, 类型：" + photo_type + "' src='users" + ar1[22] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[22] + "\",\"" + ar1[1] + "\",\"photo\",\"\",0,1)' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'" + h + ">&nbsp;</td>");
						}
						if(ar1[23] > ""){	//身份证正面
							arr.push("<td class='center'><img id='IDcardA" + ar1[1] + "' src='users" + ar1[23] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[23] + "\",\"" + ar1[1] + "\",\"IDcardA\",\"\",0,1)' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
						if(ar1[25] > ""){	//学历
							arr.push("<td class='center'><img id='education" + ar1[1] + "' src='users" + ar1[25] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[25] + "\",\"" + ar1[1] + "\",\"education\",\"\",0,1)' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
						// if(ar1[27] > ""){	//在职
						// 	arr.push("<td class='center'><img id='employment" + ar1[1] + "' src='users" + ar1[27] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[27] + "\",\"" + ar1[1] + "\",\"employment\",\"\",0,1)' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						// }else{
						// 	arr.push("<td class='center'>&nbsp;</td>");
						// }
					}
					arr.push("<td class='center'>" + ar1[41] + "</td>");	//复审日期
					if(r){
						arr.push("<td class='center'>" + ar1[90] + "</td>");	//部门
					}
					arr.push("<td class='center'>" + ar1[92] + "</td>");	//状态
					// arr.push("<td class='center'>" + (ar1[55]>""?imgChk:"") + "</td>");		//证书
					arr.push("<td class='center'>" + ar1[104] + "&nbsp;" + ar1[29] + "</td>");	//经办
					if(checkPartner == 1){
						arr.push("<td class='center'>" + ar1[108] + "</td>");
					}
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkEnter' " + (list>""?"checked":"") + " />" + "</td>");
					arr.push("</tr>");
				});
				setCourseList();
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
			if(r){
				arr.push("<th>&nbsp;</th>");
			}
			if(checkPartner == 1){
				arr.push("<th>&nbsp;</th>");
			}
			if(photo == 0){
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#enterCover").html(arr.join(""));
			arr = [];
			$('#enterTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 50,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
			setSel("");
			$("#searchEnterPick").html(0);
			$('input[type=checkbox][name=visitstockchkEnter]').change(function(){
				getSelCart("visitstockchkEnter");
				$("#searchEnterPick").html(selCount);
			});
		});
	}

	function generateMaterials(enterID,username,entryform){
		jConfirm("确定要生成报名材料吗？","确认",function(r){
			if(r){
				$.getJSON(uploadURL + "/outfiles/generate_emergency_materials?refID=" + username + "&nodeID=" + enterID + "&entryform=" + entryform ,function(data){
					if(data>""){
						jAlert("已生成文件");
						$("#material" + enterID).html("<a href='/users" + data + "?t=" + (new Date().getTime()) + "' target='_blank' title='班级归档资料'>" + imgFile + "</a>");
					}else{
						jAlert("没有可供处理的数据。");
					}
				});
			}
		});
	}

	function openMaterial(path){
		window.open(path);
	}

	function setCourseList(){
		$("#searchEnterCourseID").combobox("reload");
	}

	function getStudentCourseLists(id){
		//do nothing, just callback for entryform return's event
	}

	function setEnterListMenu(){
		if(checkPartner == 0){
			$("#enterSubmitItem").hide();
			$("#btnEnterSubmit").hide();
			$("#enterSortItem").hide();
			getComboList("searchEnterPartner","v_partnerList","partnerID","title","partnerID<>'" + currHost + "' order by mark, title",1);
			$("#enterHostItem").hide();
			$("#searchEnterHost").combobox({"setValue": ""});
			if(checkPermission("deptShow")){
				$("#enterPartnerItem").show();
			}else{
				$("#enterPartnerItem").hide();
			}
			$("#searchEnterSubmit").combobox("setValue", 1);  // 学校只能查看合作单位提交的数据
			if(checkPermission("submitReturn")){
				$("#btnEnterReturn").show();
			}
		}else{
			$("#enterSubmitItem").show();
			$("#btnEnterSubmit").show();
			$("#enterSortItem").show();
			$("#enterApplyItem").hide();
			$("#enterSalesItem").hide();
			$("#enterPayItem").hide();
			getComboList("searchEnterPartner","v_partnerList","partnerID","title","partnerID='" + (currHost>""?currHost:currPartner) + "'",0);
			$("#enterHostItem").show();
			$("#searchEnterSubmit").combobox("setValue", 0)
			$("#enterPartnerItem").hide();
			$("#btnEnterReturn").hide();
		}
	}
	