	var grantListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		$("#searchGrantStart").click(function(){WdatePicker();});
		$("#searchGrantEnd").click(function(){WdatePicker();});

		$("#btnAddGrant").click(function(){
			$("#searchGrantKind0").attr("checked",true);
			showGrantInfo(0,1,1);	//showGrantInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchGrant").click(function(){
			getGrantList();
		});
		
		$("input[name='searchGrantKind']").click(function(){
			getGrantList();
		});
		
		$("input[name='searchGrantStatus']").click(function(){
			getGrantList();
		});
		
		if(grantListLong == 0){
			$("#grantListLongItem1").show();
		}else{
			$("#grantListLongItem1").hide();
		}
		
		getGrantList();
	});

	function getGrantList(){
		sWhere = $("#txtSearchGrant").val();
		var kind = $("input[name='searchGrantKind']:checked").val();
		var st = $("input[name='searchGrantStatus']:checked").val();
		var dKind = "getGrantSendList";			//授权项目
		if(kind=="1"){
			dKind = "getGrantReceiveList";		//被授权项目
		}
		//alert(dKind + "&where=" + (sWhere) + "&status=" + st + "&fStart=" + $("#searchGrantStart").val() + "&fEnd=" + $("#searchGrantEnd").val());
		$.get("grantControl.asp?op=" + dKind + "&where=" + escape(sWhere) + "&status=" + st + "&fStart=" + $("#searchGrantStart").val() + "&fEnd=" + $("#searchGrantEnd").val() + "&dk=14&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#grantCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='grantTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='26%'>授权项目</th>");
			if(kind==0){		//授权项目
				arr.push("<th width='12%'>被授权人</th>");
			}else{			//被授权项目
				arr.push("<th width='12%'>授权人</th>");
			}
			arr.push("<th width='12%'>起始日期</th>");
			arr.push("<th width='12%'>截止日期</th>");
			arr.push("<th width='10%'>状态</th>");
			arr.push("<th width='12%'>登记日期</th>");
			arr.push("<th width='10%'>回执</th>");
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
					if(kind==1 && ar1[9]==0){
						mNew = "<span id='newGrant" + ar1[0] + "'>&nbsp;<img src='images/new.gif'></span>";
					}
					arr.push("<tr class='grade" + ar1[2] + "'>");
					arr.push("<td width='3%' class='center'>" + i + "</td>");
					arr.push("<td width='26%' class='link1'><a href='javascript:closeObj(\"newGrant" + ar1[0] + "\");showGrantInfo(\"" + ar1[0] + "\",0,1);'>" + ar1[1] + "</a>" + mNew + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[5] + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[6] + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[7] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[8] + "</td>");
					if(ar1[9]==0){
						arr.push("<td width='10%' class='left'>&nbsp;</td>");
					}else{
						arr.push("<td width='10%' class='left'>" + imgChk + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#grantCover").html(arr.join(""));
			arr = [];
			$('#grantTab').dataTable({
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

	function pickupGrant(id,name){
		var keyID = "<%=keyID%>";
		var refID = "<%=refID%>";
		pickupID = id;
		pickupName = name;
		$("#txtSearchGrant").val(name);
		//parent.asyncbox.close("grantList");
		if(keyID>""){
			parent.$("#" + keyID).val(id);
		}
		if(refID>""){
			parent.$("#" + refID).val(name);
		}
		parent.$.close("grantList");
	}
	
	