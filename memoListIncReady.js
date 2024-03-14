	var ar_memoList = getSession("ar_memoList").split("|");	// unit/user ID
	var memoListRefID = 0;
	var memoListKindID = "";
	var memoListChk = 0;
	var searchMemoUnit = 0;
	var searchMemoUser = "";

	$(document).ready(function (){
		getComboBoxList("statusMemo","searchMemoKind",0);
		$("#txtSearchMemo").textbox('textbox').css('background','#FFFF00');
		$("#btnAddMemo").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				showMemoInfo(0,0,1,1);
			}
		});

		$("#btnAddMemo").click(function(){
			showMemoInfo(0,searchMemoUnit,1,1);	//showMemoInfo(nodeID,ref,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});

		$("#searchMemoStatus").checkbox({
			onChange: function(val){
				getMemoList();
			}
		});

		$("#searchMemoKind").combobox({
			onChange: function(val){
				getMemoList();
			}
		});
		
		//getMemoList();
	});

	function getMemoList(){
		var status = 0;
		if($("#searchMemoStatus").checkbox("options").checked){status = 1;}
		sWhere = $("#txtSearchMemo").textbox("getValue");
		//alert((sWhere) + "&kindID=" + kind + "&status=" + st + "&unitID=" +$("#searchMemoUnit").val() + "&userID=" + $("#searchMemoUser").val() + "&private=" + $("#searchMemoPrivate").val() + "&fStart=" + $("#searchMemoStart").val() + "&fEnd=" + $("#searchMemoEnd").val());
		$.get("memoControl.asp?op=getMemoList&where=" + escape(sWhere) + "&kindID=" + $("#searchMemoKind").combobox("getValue") + "&fStart=" + $("#searchMemoStart").datebox("getValue") + "&fEnd=" + $("#searchMemoEnd").datebox("getValue") + "&status=" + status + "&dk=10&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#memoCover").empty();
			floatSum = "";
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='memoTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='60%'>标题</th>");
			arr.push("<th width='5%'>类型</th>");
			arr.push("<th width='5%'>状态</th>");
			arr.push("<th width='15%'>备注</th>");
			arr.push("<th width='5%'>登记人</th>");
			arr.push("<th width='5%'>登记日期</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + ar1[2] + "'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					arr.push("<td width='20%' class='link1'><a href='javascript:showMemoInfo(\"" + ar1[0] + "\"," + searchMemoUnit + ",0,1,\"\");'>" + ar1[1] + "</a></td>");
					arr.push("<td width='12%' class='left'>" + ar1[5] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[7] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[8] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[10] + "</td>");
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
			$("#memoCover").html(arr.join(""));
			arr = [];
			$('#memoTab').dataTable({
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
	
	