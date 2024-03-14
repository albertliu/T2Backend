	var knowpointListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getComList("searchKnowPointCourse","courseInfo","courseID","courseName","status=0 order by courseID",1);
		getDicList("statusEffect","searchKnowPointStatus",1);
		
		if(checkPermission("courseAdd")){
			$("#btnAddKnowPoint").show();
		}else{
			$("#btnAddKnowPoint").hide();
		}
		$("#btnSearchKnowPoint").click(function(){
			getKnowPointList();
		});
		
		$("#btnAddKnowPoint").click(function(){
			showKnowPointInfo(0,0,1,1);	//showKnowPointInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
		});
		
		//getKnowPointList();
	});

	function getKnowPointList(){
		sWhere = $("#txtSearchKnowPoint").val();
		//alert((sWhere) + "&status=" + $("#searchKnowPointStatus").val() + "&refID=" + $("#searchKnowPointCourse").val());
		$.get("knowPointControl.asp?op=getKnowPointList&where=" + escape(sWhere) + "&status=" + $("#searchKnowPointStatus").val() + "&refID=" + $("#searchKnowPointCourse").val() + "&dk=44&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#knowpointCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='knowpointTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='8%'>编号</th>");
			arr.push("<th width='20%'>名称</th>");
			arr.push("<th width='20%'>所属课程</th>");
			arr.push("<th width='8%'>状态</th>");
			arr.push("<th width='15%'>备注</th>");
			arr.push("<th width='12%'>登记日期</th>");
			arr.push("<th width='10%'>登记人</th>");
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
					arr.push("<td class='link1'><a href='javascript:showKnowPointInfo(" + ar1[0] + ",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#knowpointCover").html(arr.join(""));
			arr = [];
			$('#knowpointTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
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

	
	