	var taskListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		$("#searchTaskStart").click(function(){WdatePicker();});
		$("#searchTaskEnd").click(function(){WdatePicker();});

		$("#btnAddTask").click(function(){
			$("#searchTaskKind0").attr("checked",true);
			showTaskInfo(0,1,1);	//showTaskInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchTask").click(function(){
			getTaskList();
		});
		
		$("input[name='searchTaskKind']").click(function(){
			getTaskList();
		});
		
		$("input[name='searchTaskStatus']").click(function(){
			getTaskList();
		});
		
		if(taskListLong == 0){
			$("#taskListLongItem1").show();
		}else{
			$("#taskListLongItem1").hide();
		}
		
		getTaskList();
	});

	function getTaskList(){
		sWhere = $("#txtSearchTask").val();
		var kind = $("input[name='searchTaskKind']:checked").val();
		var st = $("input[name='searchTaskStatus']:checked").val();
		var dKind = "getTaskSendList";			//委托项目
		if(kind=="1"){
			dKind = "getTaskReceiveList";		//被委托项目
		}
		//alert(dKind + "&where=" + (sWhere) + "&status=" + st + "&fStart=" + $("#searchTaskStart").val() + "&fEnd=" + $("#searchTaskEnd").val());
		$.get("taskControl.asp?op=" + dKind + "&where=" + escape(sWhere) + "&status=" + st + "&fStart=" + $("#searchTaskStart").val() + "&fEnd=" + $("#searchTaskEnd").val() + "&dk=15&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#taskCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='taskTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='26%'>委托项目</th>");
			arr.push("<th width='12%'>预定日期</th>");
			if(kind==0){		//委托项目
				arr.push("<th width='12%'>完成情况</th>");
				arr.push("<th width='24%'>被委托人</th>");
			}else{			//被委托项目
				arr.push("<th width='12%'>完成日期</th>");
				arr.push("<th width='12%'>委托人</th>");
			}
			arr.push("<th width='8%'>回执</th>");
			arr.push("<th width='8%'>状态</th>");
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
					mNew = "";
					if(kind==1 && ar1[15]==0){
						mNew = "<span id='newTask" + ar1[0] + "'>&nbsp;<img src='images/new.gif'></span>";
					}
					arr.push("<tr class='grade" + ar1[2] + "'>");
					arr.push("<td width='3%' class='center'>" + i + "</td>");
					arr.push("<td width='26%' class='link1'><a href='javascript:closeObj(\"newTask" + ar1[0] + "\");showTaskInfo(\"" + ar1[0] + "\",0,1);'>" + ar1[1] + "</a>" + mNew + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[6] + "</td>");
					if(kind==0){		//委托项目
						arr.push("<td width='12%' class='left'>" + ar1[7] + "/" + ar1[16] + "</td>");
						arr.push("<td width='24%' class='left'>" + ar1[10] + "</td>");
					}else{			//被委托项目
						arr.push("<td width='12%' class='left'>" + ar1[7] + "</td>");
						arr.push("<td width='12%' class='left'>" + ar1[14] + "</td>");
					}
					if(kind==0){		//委托项目
						arr.push("<td width='8%' class='left'>" + ar1[15] + "/" + ar1[16] + "</td>");
					}else{			//被委托项目
						if(ar1[15]==0){
							arr.push("<td width='8%' class='left'>&nbsp;</td>");
						}else{
							arr.push("<td width='8%' class='left'>" + imgChk + "</td>");
						}
					}
					arr.push("<td width='8%' class='left'>" + ar1[3] + "</td>");
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
			$("#taskCover").html(arr.join(""));
			arr = [];
			$('#taskTab').dataTable({
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

	function pickupTask(id,name){
		var keyID = "<%=keyID%>";
		var refID = "<%=refID%>";
		pickupID = id;
		pickupName = name;
		$("#txtSearchTask").val(name);
		//parent.asyncbox.close("taskList");
		if(keyID>""){
			parent.$("#" + keyID).val(id);
		}
		if(refID>""){
			parent.$("#" + refID).val(name);
		}
		parent.$.close("taskList");
	}
	
	