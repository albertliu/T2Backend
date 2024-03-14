	var diplomaListLong = 0;		//0: 标准栏目  1：短栏目
	var diplomaListChk = 0;

	$(document).ready(function (){
		getComboBoxList("statusExpire","searchDiplomaStatus",1);
		getComboList("searchDiplomaCert","v_certificateInfo","certID","shortName","status=0",1);
        getComboList("searchDiplomaPartner","partnerInfo","ID","title","status=0 and host='" + currHost + "' order by ID",1);
        getComboList("searchDiplomaSales","userInfo","username","realName","status=0 and host='" + currHost + "' and username in(select username from roleUserList where roleID='saler') order by realName",1);

		if(currPartner > 0){
			$("#searchDiplomaPartnerItem").hide();
			$("#searchDiplomaSalesItem").hide();
		}
		
		if(checkPermission("deptShow")){
			$("#searchDiplomaPartnerItem").show();
		}else{
			$("#searchDiplomaPartnerItem").hide();
		}
		
		$("#txtSearchDiploma").textbox('textbox').css('background','#FFFF00');
		
		if(!checkPermission("diplomaDelivery")){
			$("#btnDiplomaIssue").hide();
		}
		if(!checkPermission("diplomaCancel")){
			$("#btnDiplomaCancel").hide();
		}

		$("#btnDiplomaSel").linkbutton({
			width:70,
			height:25,
			text:'全选/取消',
			onClick:function() {
				setSel("visitstockchkDiploma");
				$("#searchDiplomaPick").html(selCount);
			}
		});
		
		$("#searchDiplomaCert").combobox({
			onChange:function() {
				getDiplomaList();
			}
		});
		
		$("#btnDiplomaIssue").linkbutton({
			iconCls:'icon-send',
			width:85,
			height:25,
			text:'领取证书',
			onClick:function() {
				getSelCart("visitstockchkDiploma");
				if(selCount==0){
					jAlert("请选择要领取的名单。");
					return false;
				}
				$.messager.prompt("输入窗口","请输入备注：",function(x){
					if(x && x>""){
						jConfirm("确实要领取这" + selCount + "个证书吗？", "确认对话框",function(r){
							if(r){
								$.post("diplomaControl.asp?op=issueDiploma", {selList: selList, memo: x},function(re){
									getDiplomaList();
									jAlert("领取成功。");
								});
							}
						});
					}
				});
				$(".messager-input").val(" 本人现场领取/邮寄");
			}
		});
		
		$("#btnDiplomaCancel").linkbutton({
			iconCls:'icon-man',
			width:85,
			height:25,
			text:'撤销证书',
			onClick:function() {
				getSelCart("visitstockchkDiploma");
				if(selCount==0){
					jAlert("请选择要撤销的名单。");
					return false;
				}
				$.messager.prompt("输入窗口","请输入撤销原因：",function(x){
					if(x && x>""){
						jConfirm("确实要撤销这" + selCount + "个证书吗？\n撤销后将返回到待制作证书列表。", "确认对话框",function(r){
							if(r){
								$.post(uploadURL + "/outfiles/cancel_diplomas", {kind: 0, memo: x, selList: selList, registerID: currUser} ,function(data){
									getDiplomaList();
									jAlert("撤销成功。");
								});
							}
						});
					}
				});
				$(".messager-input").val(" 单位名称错误");
			}
		});
	});

	function getDiplomaList(){
		sWhere = $("#txtSearchDiploma").textbox("getValue");
		var nodelivery = 0;
		if($("#searchDiplomaDelivery").checkbox("options").checked){ nodelivery=1; }
		//alert(nodelivery);
		$.get("diplomaControl.asp?op=getDiplomaList&where=" + escape(sWhere) + "&nodelivery=" + nodelivery + "&kindID=" + $("#searchDiplomaCert").combobox("getValue") + "&status=" + $("#searchDiplomaStatus").combobox("getValue") + "&partnerID=" + $("#searchDiplomaPartner").combobox("getValue") + "&sales=" + $("#searchDiplomaSales").combobox("getValue") + "&fStart=" + $("#searchDiplomaStartDate").datebox("getValue") + "&fEnd=" + $("#searchDiplomaEndDate").datebox("getValue") + "&lastDate=" + $("#searchDiplomaLastDate").datebox("getValue") + "&dk=20&times=" + (new Date().getTime()),function(data){
			// jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#diplomaCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='diplomaTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='13%'>身份证</th>");
			arr.push("<th width='6%'>姓名</th>");
			arr.push("<th width='10%'>证书名称</th>");
			arr.push("<th width='8%'>证书编号</th>");
			arr.push("<th width='15%'>单位名称</th>");
			arr.push("<th width='9%'>电话</th>");
			arr.push("<th width='10%'>有效期</th>");
			arr.push("<th width='5%'>状态</th>");
			arr.push("<th width='6%'>销售</th>");
			arr.push("<th width='6%'>领取</th>");
			arr.push("<th width='2%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					h = ar1[13];	//公司用户显示部门1名称
					if(ar1[3]>0){c = 2;}	//失效红色
					if(currHost==""){h = ar1[12];}	//系统用户显示公司名称
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showDiplomaInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[13] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[16] + "/" + ar1[17] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[29] + "</td>");
					arr.push("<td class='left'>" + ar1[26] + "</td>");
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkDiploma'>" + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#diplomaCover").html(arr.join(""));
			arr = [];
			$('#diplomaTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"iDisplayLength": 100,
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
			$("#searchDiplomaPick").html(0);
			$('input[type=checkbox][name=visitstockchkDiploma]').change(function(){
				getSelCart("visitstockchkDiploma");
				$("#searchDiplomaPick").html(selCount);
			});
		});
	}
	