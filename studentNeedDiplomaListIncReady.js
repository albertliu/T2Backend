	var studentNeedDiplomaListLong = 0;		//0: 标准栏目  1：短栏目
	var studentNeedDiplomaListChk = 0;

	$(document).ready(function (){
		getComboBoxList("statusYes","searchStudentNeedDiplomaHavePhoto",1);
		// getComboList("searchStudentNeedDiplomaCert","v_certificateInfo","certID","shortName","status=0 and mark=1",1);
		// getComboList("searchStudentNeedDiplomaCert","[dbo].[getNeedDiplomaQty]('" + currHost + "')","certID","certName","1=1",1);
        getComboList("StudentNeedDiplomaPartner","partnerInfo","ID","title","status=0 and host='" + currHost + "' order by ID",1);
        getComboList("StudentNeedDiplomaSales","userInfo","username","realName","status=0 and host='" + currHost + "' and username in(select username from roleUserList where roleID='saler') order by realName",1);

		$("#searchStudentNeedDiplomaPhotoItem").hide();
		$("#btnStudentNeedDiplomaCancel").hide();
		$("#btnStudentNeedDiplomaOk").hide();
		$("#btnStudentNeedDiplomaAttentionPhoto").hide();
		$("#btnStudentNeedDiplomaAttentionPhotoClose").hide();

		if(currPartner > 0){
			$("#searchStudentNeedDiplomaPartnerItem").hide();
			$("#searchStudentNeedDiplomaSalesItem").hide();
		}
		
		if(checkPermission("deptShow")){
			$("#searchStudentNeedDiplomaPartnerItem").show();
		}else{
			$("#searchStudentNeedDiplomaPartnerItem").hide();
		}
		
		$("#txtSearchStudentNeedDiploma").textbox('textbox').css('background','#FFFF00');
		

		$("#searchStudentNeedDiplomaCert").combobox({
			onShowPanel:function() {
				getComboList("searchStudentNeedDiplomaCert","[dbo].[getNeedDiplomaQty]('" + currHost + "')","certID","certName","1=1 order by certID",1);
			}
		});

		if(!checkPermission("studentAdd")){
			$("#btnStudentNeedDiplomaAttentionPhotoClose").hide();
			$("#btnStudentNeedDiplomaAttentionPhoto").hide();
		}
		$("#btnStudentNeedDiplomaSel").linkbutton({
			width:70,
			height:25,
			text:'全选/取消',
			onClick:function() {
				setSel("visitstockchkNeed");
				$("#searchStudentNeedDiplomaPick").html(selCount);
			}
		});
		
		$("#searchStudentNeedDiplomaCert").combobox({
			onChange:function() {
				getStudentNeedDiplomaList();
			}
		});
		
		$("#btnStudentNeedDiplomaIssue").linkbutton({
			iconCls:'icon-man',
			width:85,
			height:25,
			text:'制作证书',
			onClick:function() {
				getSelCart("visitstockchkNeed");
				if(selCount==0){
					jAlert("请选择要制作的名单。");
					return false;
				}
				if($("#searchStudentNeedDiplomaCert").combobox("getValue")==""){
					jAlert("请选择一个证书项目。");
					return false;
				}
				jConfirm("确定为这" + selCount + "个学员制作证书吗？","确认",function(r){
					if(r){
						setSession("need2DiplomaList", selList);
						showGenerateDiplomaInfo1(0,$("#searchStudentNeedDiplomaCert").combobox("getValue"),"need2DiplomaList",selCount,$("#searchStudentNeedDiplomaCert").combobox("getText"),1,1);
					}
				});
			}
		});
		
		$("#btnStudentNeedDiplomaCancel").linkbutton({
			iconCls:'icon-man',
			width:85,
			height:25,
			text:'拒绝申请',
			onClick:function() {
				getSelCart("visitstockchkNeed");
				if(selCount==0){
					jAlert("请选择要拒绝的名单。");
					return false;
				}
				jConfirm("确定要拒绝这" + selCount + "个人的证书申请吗？以后根据需要还可以恢复。","确认",function(r){
					if(r){
						//
					}
				});
			}
		});
		
		$("#btnStudentNeedDiplomaOk").linkbutton({
			iconCls:'icon-man',
			width:85,
			height:25,
			text:'恢复申请',
			onClick:function() {
				getSelCart("visitstockchkNeed");
				if(selCount==0){
					jAlert("请选择要恢复的名单。");
					return false;
				}
				jConfirm("确定要恢复这" + selCount + "个人的证书申请吗？","确认",function(r){
					if(r){
						//
					}
				});
			}
		});
		
		$("#btnStudentNeedDiplomaAttentionPhoto").linkbutton({
			iconCls:'icon-send',
			width:85,
			height:25,
			text:'照片通知',
			onClick:function() {
				getSelCart("visitstockchkNeed");
				if(selCount==0){
					jAlert("请选择要通知的名单。");
					return false;
				}
				jConfirm("确定通知将这" + selCount + "个学员提交电子照片吗？","确认",function(r){
					if(r){
						//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
						$.post(uploadURL + "/public/send_message_submit_photo", {kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
							//jAlert(data);
							getStudentNeedDiplomaList();
							jAlert("发送成功。");
						});
					}
				});
			}
		});
		
		$("#btnStudentNeedDiplomaAttentionPhotoClose").linkbutton({
			iconCls:'icon-ok',
			width:85,
			height:25,
			text:'照片确认',
			onClick:function() {
				getSelCart("visitstockchkNeed");
				if(selCount==0){
					jAlert("请选择要确认照片的名单。");
					return false;
				}
				jConfirm("确定要将这" + selCount + "个提交电子照片通知关闭吗？","确认",function(r){
					if(r){
						//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
						$.post(uploadURL + "/public/send_message_submit_attention_close", {batchID: "", kindID:0, kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
							//jAlert(data);
							getStudentNeedDiplomaList();
							jAlert("操作成功。");
						});
					}
				});
			}
		});
		
		$("#btnStudentNeedDiplomaAttentionPhoto").click(function(){
			getSelCart("visitstockchkNeed");
			if(selCount==0){
				jAlert("请选择要通知的学员清单。");
				return false;
			}
			if(confirm("确定要通知这" + selCount + "个学员提交电子照片吗？")){
				$.post(uploadURL + "/public/send_message_submit_photo", {kind: "cert", selList: selList, SMS:1, registerID: currUser} ,function(data){
					jAlert("发送成功。");
					getStudentNeedDiplomaList();
				});
			}
		});
		
		$("#btnStudentNeedDiplomaAttentionPhotoClose").click(function(){
			getSelCart("visitstockchkNeed");
			if(selCount==0){
				jAlert("请选择要关闭的名单。");
				return false;
			}
			if(confirm("确定要将这" + selCount + "个提交电子照片通知关闭吗？")){
				$.post(uploadURL + "/public/send_message_submit_attention_close", {batchID: "", kindID:0, kind: "cert", selList: selList, SMS:1, registerID: currUser} ,function(data){
					jAlert("操作成功。");
					getStudentNeedDiplomaList();
				});
			}
		});
		
		$("#btnStudentNeedDiplomaCancel").click(function(){
			getSelCart("visitstockchkNeed");
			if(selCount==0){
				jAlert("请选择要拒绝的名单。");
				return false;
			}
			if(confirm("确定要拒绝这" + selCount + "个人的证书申请吗？以后根据需要还可以恢复。")){
				$.post(uploadURL + "/public/refuse_diploma_order", {kind:0, selList: selList, registerID: currUser} ,function(data){
					jAlert("操作成功。");
					getStudentNeedDiplomaList();
				});
			}
		});
		
		$("#btnStudentNeedDiplomaOk").click(function(){
			getSelCart("visitstockchkNeed");
			if(selCount==0){
				jAlert("请选择要恢复的名单。");
				return false;
			}
			if(confirm("确定要恢复这" + selCount + "个人的证书申请吗？")){
				$.post(uploadURL + "/public/refuse_diploma_order", {kind:1, selList: selList, registerID: currUser} ,function(data){
					jAlert("操作成功。");
					getStudentNeedDiplomaList();
				});
			}
		});

		$("#searchStudentNeedDiplomaRefuse").checkbox({
			onChange: function(val){
				getStudentNeedDiplomaList();
			}
		});

		if(!checkPermission("diplomaAdd")){
			$("#studentNeedDiplomaDoItem").hide();
		}
	});

	function getStudentNeedDiplomaList(){
		sWhere = $("#txtSearchStudentNeedDiploma").textbox("getValue");
		var refuse = 0;
		if($("#searchStudentNeedDiplomaRefuse").checkbox("options").checked){refuse = 1;}
		//alert($("#searchStudentNeedDiplomaHavePhoto").combobox("getValue"));
		$.get("diplomaControl.asp?op=getStudentNeedDiplomaList&where=" + escape(sWhere) + "&kindID=" + $("#searchStudentNeedDiplomaCert").combobox("getValue") + "&partnerID=" + $("#StudentNeedDiplomaPartner").combobox("getValue") + "&sales=" + $("#StudentNeedDiplomaSales").combobox("getValue") + "&fStart=" + $("#searchStudentNeedDiplomaStartDate").datebox("getValue") + "&fEnd=" + $("#searchStudentNeedDiplomaEndDate").datebox("getValue") + "&keyID=" + $("#searchStudentNeedDiplomaHavePhoto").combobox("getValue") + "&refID=" + refuse + "&dk=21&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#studentNeedDiplomaCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='studentNeedDiplomaTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='11%'>身份证</th>");
			arr.push("<th width='6%'>姓名</th>")
			arr.push("<th width='7%'>学历</th>");;
			arr.push("<th width='15%'>单位名称</th>");
			arr.push("<th width='10%'>手机</th>");
			arr.push("<th width='15%'>证书名称</th>");
			arr.push("<th width='5%'>学费</th>");
			arr.push("<th width='8%'>考试日期</th>");
			arr.push("<th width='6%'>照片</th>");
			arr.push("<th width='2%'>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var img = "";
				var attention_status = ["FFFFAA","AAFFAA","F3F3F3"];
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentNeedDiplomaInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(" + ar1[0] + ",\"" + ar1[1] + "\",0,1,\"*\",\"\");'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[13] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					arr.push("<td class='left'>" + ar1[16] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					if(ar1[15]==1){
						arr.push("<td class='left'>" + imgChk + "</td>");
					}else{
						arr.push("<td class='left'>&nbsp;</td>");
					}
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					if(ar1[19]>0){	//根据照片或签字提醒状态，显示不同背景颜色
						h = " style='background-color:#" + attention_status[ar1[19]-1] + ";'";
					}else{
						h = "";
					}
					if($("#searchStudentNeedDiplomaShowPhoto").checkbox("options").checked && ar1[12].length>0){
						img = "<img id='photoA" + ar1[1] + "' src='users" + ar1[12] + "?t=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[12] + "\",\"" + ar1[1] + "\",\"photo\",\"A\",0,1)' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'>";
						arr.push("<td class='center'" + h + ">" + img + "</td>");
					}else{
						arr.push("<td class='center'" + h + ">&nbsp;</td>");
					}
					if(ar1[15]==1){	//未交费的不能做证书
						arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkNeed'>" + "</td>");
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#studentNeedDiplomaCover").html(arr.join(""));
			arr = [];
			$('#studentNeedDiplomaTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"bInfo": true,
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
			$("#searchStudentNeedDiplomaPick").html(0);
			$('input[type=checkbox][name=visitstockchkNeed]').change(function(){
				getSelCart("visitstockchkNeed");
				$("#searchStudentNeedDiplomaPick").html(selCount);
			});
		});
	}
	