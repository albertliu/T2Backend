	var LessonListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getComboBoxList("statusEffect","searchLessonStatus",1);
        getComboList("searchLessonCourseID","v_courseInfo","courseID","courseName1","status=0 order by courseID",1);
 
		$("#txtSearchLesson").textbox('textbox').css('background','#FFFF00');
		
		$("#btnSearchLessonAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				showLessonInfo(0,0,1,1);	//showLessonInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
			}
		});
		
		$("#searchLessonCourseID").combobox({
			onChange:function() {
				getLessonList();
			}
		});
		
		if(checkPermission("LessonAdd")){
			$("#btnAddLesson").show();
		}else{
			$("#btnAddLesson").hide();
		}
	});

	function getLessonList(){
		sWhere = $("#txtSearchLesson").textbox("getValue");
		//alert((sWhere) + "&kindID=" + $("#searchLessonKind").val() + "&status=" + $("#searchLessonStatus").val() + "&agency=" + $("#searchLessonAgency").val());
		$.get("lessonControl.asp?op=getLessonList&where=" + escape(sWhere) + "&refID=" + $("#searchLessonCourseID").combobox("getValue") + "&status=" + $("#searchLessonStatus").combobox("getValue") + "&dk=15&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#LessonCover").empty();
			floatSum = "";
			arr = [];			
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='LessonTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='5%'>编号</th>");
			arr.push("<th width='25%'>课节名称</th>");
			arr.push("<th width='5%'>状态</th>");
			arr.push("<th width='15%'>备注</th>");
			arr.push("<th width='6%'>登记日期</th>");
			arr.push("<th width='5%'>登记人</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			var mNew = "";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showLessonInfo(" + ar1[0] + ",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#LessonCover").html(arr.join(""));
			arr = [];
			$('#LessonTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100],
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
		});
	}

	
	