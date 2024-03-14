	var agencyListLong = 0;		//0: 标准栏目  1：短栏目
	var agencyListChk = 0;

	$(document).ready(function (){
		getComboBoxList("statusEffect","searchAgencyStatus",1);

		$("#txtSearchAgency").textbox('textbox').css('background','#FFFF00');
		
		$("#btnAgencyAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				showAgencyInfo(0,0,1,1);	//showAgencyInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
			}
		});

		$("#btnAgencyAdd").hide();
		if(checkPermission("agencyAdd")){
			$("#btnAgencyAdd").show();
		}
	});

	function getAgencyList(){
		sWhere = $("#txtSearchAgency").textbox("getValue");
		$.get("agencyControl.asp?op=getAgencyList&where=" + escape(sWhere) + "&status=" + $("#searchAgencyStatus").combobox("getValue") + "&dk=45&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#agencyCover").empty();
			floatSum = "";
			arr = [];			
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='agencyTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='20%'>机构名称</th>");
			arr.push("<th width='12%'>简称</th>");
			arr.push("<th width='8%'>编号</th>");
			arr.push("<th width='10%'>类型</th>");
			arr.push("<th width='8%'>状态</th>");
			arr.push("<th width='10%'>联系人</th>");
			arr.push("<th width='12%'>电话</th>");
			arr.push("<th width='15%'>地址</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showAgencyInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#agencyCover").html(arr.join(""));
			arr = [];
			$('#agencyTab').dataTable({
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
	