	$(document).ready(function (){
		getComboBoxList("statusEffect","searchPartnerStatus",1);

		$("#txtSearchPartner").textbox('textbox').css('background','#FFFF00');
		
		$("#btnSearchPartnerAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				showPartnerInfo(0,0,1,1);	//showPartnerInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
			}
		});
		
		$("#btnSearchUserHost").linkbutton({
			iconCls:'icon-tip',
			width:85,
			height:25,
			text:'学校信息',
			onClick:function() {
				showHostInfo(currHost,0,0,0);
			}
		});
		
		$("#btnSearchUserCheckin").linkbutton({
			iconCls:'icon-tip',
			width:95,
			height:25,
			text:'签到二维码',
			onClick:function() {
				showCheckInfo();
			}
		});

		$("#btnAddPartner").hide();
		if(checkPermission("deptAdd")){
			$("#btnAddPartner").show();
		}
	});

	function getPartnerList(){
		sWhere = $("#txtSearchPartner").textbox("getValue");
		//alert($("#searchPartnerStatus").val());
		$.get("hostControl.asp?op=getPartnerList&where=" + escape(sWhere) + "&status=" + $("#searchPartnerStatus").combobox("getValue") + "&dk=63&times=" + (new Date().getTime()),function(data){
			// jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#partnerCover").empty();
			floatSum = "";
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='partnerTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10'>No</th>");
			arr.push("<th width='250'>名称</th>");
			arr.push("<th width='150'>简称</th>");
			arr.push("<th width='100'>编号</th>");
			arr.push("<th width='100'>状态</th>");
			arr.push("<th width='300'>备注</th>");
			arr.push("<th width='150'>注册日期</th>");
			arr.push("<th>注册人</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showPartnerInfo(\"" + ar1[8] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
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
			$("#partnerCover").html(arr.join(""));
			arr = [];
			$('#partnerTab').dataTable({
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
