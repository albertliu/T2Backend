	var courseListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getComboBoxList("statusEffect","searchCourseStatus",1);
        getComboList("searchCourseAgency","agencyInfo","agencyID","agencyName","status=0 order by agencyID",1);
 
		$("#txtSearchCourse").textbox('textbox').css('background','#FFFF00');
		
		$("#btnSearchCourseAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				showCourseInfo(0,0,1,1);	//showCourseInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
			}
		});
		
		$("#searchCourseAgency").combobox({
			onChange:function() {
				getCourseList();
			}
		});
		
		if(checkPermission("courseAdd") && currHost=="feng"){
			$("#btnAddCourse").show();
		}else{
			$("#btnAddCourse").hide();
		}
	});

	function getCourseList(){
		sWhere = $("#txtSearchCourse").textbox("getValue");
		//alert((sWhere) + "&kindID=" + $("#searchCourseKind").val() + "&status=" + $("#searchCourseStatus").val() + "&agency=" + $("#searchCourseAgency").val());
		$.get("courseControl.asp?op=getCourseList&where=" + escape(sWhere) + "&agency=" + $("#searchCourseAgency").combobox("getValue") + "&status=" + $("#searchCourseStatus").combobox("getValue") + "&dk=15&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#courseCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='courseTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='5%'>编号</th>");
			arr.push("<th width='25%'>课程名称</th>");
			arr.push("<th width='5%'>课时数</th>");
			arr.push("<th width='12%'>达标进度%</th>");
			arr.push("<th width='12%'>报名表样式</th>");
			arr.push("<th width='5%'>状态</th>");
			arr.push("<th width='10%'>显示顺序</th>");
			arr.push("<th width='10%'>备注</th>");
			arr.push("<th width='5%'>计划</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			var mNew = "";
			var imgChk = "<img src='images/green_check.png'>";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showCourseInfo(" + ar1[0] + ",0,0,1);'>" + ar1[21] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[19] + "</td>");
					arr.push("<td class='left'>" + ar1[18] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[22] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					if(ar1[23]>0){
						arr.push("<td class='left'><a href='javascript:showStandardSchedule(\"" + ar1[1] + "\",\"" + ar1[2] + "\");'>" + ar1[23] + "</a></td>");
					}else{
						arr.push("<td>&nbsp;</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#courseCover").html(arr.join(""));
			arr = [];
			$('#courseTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100],
				"iDisplayLength": 50,
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
		});
	}

	
	