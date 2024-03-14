
var examRuleRefID = "";
$(document).ready(function (){
	if(checkPermission("examAdd")){
		$("#btnAddExamRule").show();
	}else{
		$("#btnAddExamRule").hide();
	}
		
	$("#btnAddExamRule").click(function(){
		if(examRuleRefID > ""){
			showExamRuleInfo(0,examRuleRefID,1,1);	//showExamRuleInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
		}else{
			jAlert("请先选择一门课程");
		}
		
	});
});
	function getExamRuleList(refID){
		//alert(refID);
		examRuleRefID = refID;
		$.get("examRuleControl.asp?op=getExamRuleList&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#examRuleCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];		
			ar.shift();
			arr.push("<table cellpadding='5' cellspacing='2' border='0' id='examRuleTab' width='98%'>");
			arr.push("<tr align='center'>");
			arr.push("<td align='center' width='3%'>No.</td>");
			arr.push("<td align='center' width='20%'>知识点</td>");
			arr.push("<td align='center' width='20%'>类型</td>");
			arr.push("<td align='center' width='20%'>数量</td>");
			arr.push("<td align='center' width='30%'>每题分值</td>");
			arr.push("</tr>");
			var i = 0;
			var c = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td align='center'>" + ar1[2] + "</td>");
					arr.push("<td align='center'><a href='javascript:showExamRuleInfo(" + ar1[0] + ",0,0,1);'>" + ar1[4] + "</a></td>");
					arr.push("<td align='center'>" + ar1[5] + "</td>");
					arr.push("<td align='center'>" + ar1[6] + "</td>");
					arr.push("</tr>");
				});
			}
			arr.push("</table>");
			$("#examRuleCover").html(arr.join(""));
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
