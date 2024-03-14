var courseLessonRefID = "";

$(document).ready(function (){
	if(checkPermission("courseAdd")){
		$("#btnAddLesson").show();
	}else{
		$("#btnAddLesson").hide();
	}
		
	$("#btnAddLesson").click(function(){
		if(courseLessonRefID > ""){
			showLessonInfo(0,courseLessonRefID,1,1);	//showCertInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
		}else{
			jAlert("请先选择一门课程");
		}
		
	});
});

	function getLessonList(refID){
		courseLessonRefID = refID;
		//alert(refID);
		$.get("lessonControl.asp?op=getLessonList&refID=" + refID + "&status=0&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#courseLessonCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];		
			arr.push("<table cellpadding='5' cellspacing='2' border='0' id='courseLessonTab' width='98%'>");
			arr.push("<tr align='center'>");
			arr.push("<td align='center' width='10%'>编号</td>");
			arr.push("<td align='center' width='70%'>课节名称</td>");
			arr.push("<td align='center' width='10%'>序号</td>");
			arr.push("<td align='center' width='10%'>课时</td>");
			arr.push("</tr>");
			var i = 0;
			var c = 0;
			var mNew = "";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr>");
					arr.push("<td align='center'>" + ar1[1] + "</td>");
					arr.push("<td align='left'><a href='javascript:showLessonInfo(" + ar1[0] + ",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td align='center'>" + ar1[8] + "</td>");
					arr.push("<td align='center'>" + ar1[3] + "</td>");
					arr.push("</tr>");
				});
			}
			arr.push("</table>");
			$("#courseLessonCover").html(arr.join(""));
			arr = [];
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}
