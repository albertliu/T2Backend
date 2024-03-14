	var workLogListLong = 0;		//0: 标准栏目  1：短栏目
	var ar_workLogList = getSession("ar_workLogList").split("|");	//refID | 0 normal  1 engineering  2 project
	var workLogListRefID = 0;
	var workLogListKindID = "";
	var workLogListChk = 0;
	var workLogListVal = "";

	$(document).ready(function (){
		getComList("searchWorkLogEngineering","engineeringInfo","ID","item","status>0",1);
		setComUserList("searchWorkLogUser",0,0,0,1);
		getDicList("private","searchWorkLogPrivate",1);
		$("#searchWorkLogEngineering").attr("disabled",true);
		$("#searchWorkLogProject").attr("disabled",true);
		$("#searchWorkLogUser").val(currUser);
		$("#searchWorkLogPrivate").val("");
		$("#searchWorkLogStart").click(function(){WdatePicker();});
		$("#searchWorkLogEnd").click(function(){WdatePicker();});

		workLogListRefID = ar_workLogList[0];		//ref ID
		workLogListKindID = ar_workLogList[1];	//0 normal  1 engineering  2 project
		
		if(workLogListRefID>"0" && workLogListKindID==2){
			$("#searchWorkLogKind2").attr("checked",true);
			getProjectInfo(workLogListRefID);
			$("#searchWorkLogUser").val("");
			//workLogListChk = checkPermission("CA",workLogListRefID);
		}

		$("#btnAddWorkLog").click(function(){
			showWorkLogInfo(0,1,1);	//showWorkLogInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchWorkLog").click(function(){
			getWorkLogList();
		});
		
		$("#searchWorkLogPrivate").change(function(){
			if($("#searchWorkLogPrivate").val()==0){
				$("#searchWorkLogUser").val(currUser);
			}
			getWorkLogList();
		});
		
		$("#searchWorkLogUser").change(function(){
			if($("#searchWorkLogUser").val()!=currUser){
				$("#searchWorkLogPrivate").val(1);
			}
			getWorkLogList();
		});
		
		$("input[name='searchWorkLogKind']").click(function(){
			//alert($("input[name='searchWorkLogKind']:checked").val());
			getWorkLogList();
			var kind = $("input[name='searchWorkLogKind']:checked").val();
			if(kind==0 || kind==99){
				$("#searchWorkLogEngineering").attr("disabled",true);
				$("#searchWorkLogProject").attr("disabled",true);
				$("#searchWorkLogEngineering").val("");
				$("#searchWorkLogProject").val("");
			}
			if(kind==1){
				$("#searchWorkLogEngineering").attr("disabled",false);
				$("#searchWorkLogProject").attr("disabled",true);
				$("#searchWorkLogProject").val("");
				$("#searchWorkLogEngineering").focus();
			}
			if(kind==2){
				$("#searchWorkLogEngineering").attr("disabled",false);
				$("#searchWorkLogProject").attr("disabled",false);
				$("#searchWorkLogEngineering").change();
				$("#searchWorkLogEngineering").focus();
			}
		});
		
		$("input[name='searchWorkLogStatus']").click(function(){
			//alert($("input[name='searchWorkLogStatus']:checked").val());
			getWorkLogList();
		});
		
		$("#searchWorkLogEngineering").change(function(){
			var kind = $("input[name='searchWorkLogKind']:checked").val();
			//alert(kind + ":" + $("#searchWorkLogEngineering").val());
			if((kind==2) && $("#searchWorkLogEngineering").val()>0){
				getComList("searchWorkLogProject","projectInfo","ID","item","engineeringID=" + $("#searchWorkLogEngineering").val() + " and status>0",1);
			}else{
				$("#searchWorkLogProject").val("");
			}
		});
		
		if(workLogListLong == 0){
			$("#workLogListLongItem1").show();
		}else{
			$("#workLogListLongItem1").hide();
		}
		
		getWorkLogList();
	});

	function getWorkLogList(){
		sWhere = $("#txtSearchWorkLog").val();
		var kind = $("input[name='searchWorkLogKind']:checked").val();
		var st = $("input[name='searchWorkLogStatus']:checked").val();
		//alert((sWhere) + "&kindID=" + kind + "&status=" + st + "&engineeringID=" +$("#searchWorkLogEngineering").val() + "&projectID=" + $("#searchWorkLogProject").val() + "&userID=" + $("#searchWorkLogUser").val() + "&private=" + $("#searchWorkLogPrivate").val());
		$.get("workLogControl.asp?op=getWorkLogListByWhere&where=" + escape(sWhere) + "&kindID=" + kind + "&status=" + st + "&engineeringID=" +$("#searchWorkLogEngineering").val() + "&projectID=" + $("#searchWorkLogProject").val() + "&userID=" + $("#searchWorkLogUser").val() + "&private=" + $("#searchWorkLogPrivate").val() + "&fStart=" + $("#searchWorkLogStart").val() + "&fEnd=" + $("#searchWorkLogEnd").val() + "&dk=12&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#workLogCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='workLogTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='20%'>标题</th>");
			arr.push("<th width='12%'>标记日期</th>");
			arr.push("<th width='7%'>范围</th>");
			arr.push("<th width='7%'>类型</th>");
			arr.push("<th width='7%'>状态</th>");
			if(workLogListLong == 0){
				arr.push("<th width='10%'>工程项目</th>");
				arr.push("<th width='8%'>登记人</th>");
			}
			if(workLogListLong == 1){
				arr.push("<th width='8%'>选择</th>");
			}
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var s = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					s = ar1[10];
					if(ar1[12]>""){s += " / " + ar1[12];}
					i += 1;
					arr.push("<tr class='grade" + ar1[2] + "'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					arr.push("<td width='20%' class='link1'><a href='javascript:showWorkLogInfo(\"" + ar1[0] + "\",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td width='12%' class='left'>" + ar1[6] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[18] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[8] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[3] + "</td>");
					if(workLogListLong == 0){
						arr.push("<td width='10%' class='left' title='" + s + "'>" + s.substring(s.length-7) + "</td>");
						arr.push("<td width='8%' class='left'>" + ar1[16] + "</td>");
					}
					if(workLogListLong == 1){
						arr.push("<td width='8%' class='link1'>" + "<a href='javascript: pickupWorkLog(" + ar1[0] + ",\"" + ar1[1] + "\");'><img src='images/hand.png' border='0'></a></td>");
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
			if(workLogListLong == 0){
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
			}
			if(workLogListLong == 1){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#workLogCover").html(arr.join(""));
			arr = [];
			$('#workLogTab').dataTable({
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

	function getProjectInfo(id){
		//alert(id);
		$.get("projectControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#searchWorkLogEngineering").attr("disabled",false);
				$("#searchWorkLogEngineering").val(ar[20]);
				getComList("searchWorkLogProject","projectInfo","ID","item","engineeringID=" + ar[20] + " and status>0",1);
				//$("#engineeringName").val(ar[21]);
				$("#searchWorkLogProject").attr("disabled",false);
				$("#searchWorkLogProject").val(ar[0]);
				//$("#projectName").val(ar[1]);
			}
		});
	}
	
	