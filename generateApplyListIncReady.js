	var generateApplyListLong = 0;		//0: 标准栏目  1：短栏目
	var generateApplyListChk = 0;

	$(document).ready(function (){
		getComboBoxList("planStatus","searchGenerateApplyStatus",1);
		getComboBoxList("statusNo","searchGenerateApplyMakeup",1);
		getComboBoxList("applyKind","searchGenerateApplyKindID",1);
		getComboList("searchGenerateApplyRegister","v_applyRegister","registerID","registerName","host='" + currHost + "' order by ID desc",1);
		getComboList("searchGenerateApplyCourseID","v_courseInfo","courseID","courseName2","status=0 and mark=1 order by seq",1);
        getComboList("searchGenerateApplyPartner","partnerInfo","ID","title","status=0 and host='" + currHost + "' order by ID",1);
        getComboList("searchGenerateApplySales","userInfo","username","realName","status=0 and host='" + currHost + "' and username in(select username from roleUserList where roleID='saler') order by realName",1);

		if(currPartner > 0){
			$("#searchGenerateApplyRegister").hide();
			// $("#applySalesItem").hide();
		}
		$("#applySalesItem").hide();
		$("#searchGenerateApplyImportScore").hide();
		
		if(checkPermission("deptShow")){
			$("#applyPartnerItem").show();
		}else{
			$("#applyPartnerItem").hide();
		}
		if(checkPermission("applyEdit")){
			$("#searchGenerateApplyImportScore").show();
		}

		$("#txtSearchGenerateApply").textbox('textbox').css('background','#FFFF00');
		
		$("#btnSearchGenerateApplyAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				showGenerateApplyInfo(0,0,1,1);
			}
		});		

		$("#searchGenerateApplyImportScore").linkbutton({
			iconCls:'icon-download',
			width:110,
			height:25,
			text:'导入成绩证书',
			onClick:function() {
				showUploadFile(1, "", "apply_score_list", "成绩证书名单", "getGenerateApplyList()",1, 1);
				updateCount += 1;
			}
		});
		
		$("#searchGenerateApplyCourseID").combobox({
			onChange:function() {
				getGenerateApplyList();
			}
		});
		
		if(!checkPermission("applyAdd") || currPartner>0){
			$("#btnSearchGenerateApplyAdd").hide();
		}
	});

	function getGenerateApplyList(){
		sWhere = $("#txtSearchGenerateApply").textbox("getValue");
		// alert((sWhere) + "&partnerID=" + $("#searchGenerateApplyPartner").combobox("getValue") + "&status=" + $("#searchGenerateApplyStatus").combobox("getValue") + "&sales=" + $("#searchGenerateApplySales").combobox("getValue") + "&courseID=" + $("#searchGenerateApplyCourseID").combobox("getValue") + "&kindID=" + $("#searchGenerateApplyKindID").combobox("getValue") + "&refID=" + $("#searchGenerateApplyRegister").combobox("getValue") + "&fStart=" + $("#searchGenerateApplyStart").datebox("getValue") + "&fEnd=" + $("#searchGenerateApplyEnd").datebox("getValue"));
		$.get("diplomaControl.asp?op=getGenerateApplyList&where=" + escape(sWhere) + "&partnerID=" + $("#searchGenerateApplyPartner").combobox("getValue") + "&status=" + $("#searchGenerateApplyStatus").combobox("getValue") + "&sales=" + $("#searchGenerateApplySales").combobox("getValue") + "&courseID=" + $("#searchGenerateApplyCourseID").combobox("getValue") + "&kindID=" + $("#searchGenerateApplyKindID").combobox("getValue") + "&refID=" + $("#searchGenerateApplyRegister").combobox("getValue") + "&fStart=" + $("#searchGenerateApplyStart").datebox("getValue") + "&fEnd=" + $("#searchGenerateApplyEnd").datebox("getValue") + "&dk=106&times=" + (new Date().getTime()),function(data){
			// jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#generateApplyCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='generateApplyTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='12%'>申报名称</th>");
			arr.push("<th width='8%'>开班编号</th>");
			arr.push("<th width='4%'>人数</th>");
			arr.push("<th width='6%'>开课日期</th>");
			arr.push("<th width='5%'>状态</th>");
			arr.push("<th width='5%'>类别</th>");
			arr.push("<th width='6%'>申报导入</th>");
			arr.push("<th width='6%'>成绩导入</th>");
			arr.push("<th width='5%'>申报</th>");
			arr.push("<th width='5%'>考试</th>");
			arr.push("<th width='7%'>考试通知</th>");
			arr.push("<th width='7%'>成绩通知</th>");
			arr.push("<th width='7%'>备注</th>");
			arr.push("<th width='5%'>制作</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/printer1.png'>";
				var imgChk1 = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + ar1[0] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showGenerateApplyInfo(" + ar1[0] + ",0,0,1,1);'>" + ar1[3] + "</a></td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='center'>" + ar1[16] + "</td>");
					arr.push("<td class='center'>" + ar1[32] + "</td>");
					arr.push("<td class='left'>" + ar1[25] + "</td>");
					arr.push("<td class='center'>" + ar1[26] + "</td>");
					arr.push("<td class='left' title='申报/批准/失败'>" + ar1[37] + "/" + ar1[30] + "/" + ar1[23] + "</td>");
					arr.push("<td class='left' title='合格/不合格'>" + ar1[21] + "/" + ar1[22] + "</td>");
					arr.push("<td class='left'>" + ar1[13] + "</td>");
					arr.push("<td class='left'>" + ar1[19] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#generateApplyCover").html(arr.join(""));
			arr = [];
			$('#generateApplyTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aLengthMenu":[15,30,50,100],
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
		});
	}
