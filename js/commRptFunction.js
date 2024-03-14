
	//未结清单位列表
	function getDebtUnitList(coverName,tabName){
		$.get("rptControl.asp?op=getDebtUnitList&dk=0&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			if(coverName==""){
				coverName = "floatCover";
			}
			if(tabName==""){
				tabName = "floatTab";
			}
			$("#" + coverName).empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = ar0[1];
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='" + tabName + "' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='35%'>单位名称</th>");
			arr.push("<th width='15%'>机构代码</th>");
			arr.push("<th width='10%'>次数</th>");
			arr.push("<th width='15%'>欠款金额</th>");
			arr.push("<th width='10%'>联系人</th>");
			arr.push("<th width='15%'>联系电话</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='35%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='15%' class='right'>" + ar1[3] + "</td>");
					arr.push("<td width='10%' class='right'>" + ar1[4] + "</td>");
					arr.push("<td width='15%' class='right'>" + ar1[5] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#" + coverName).html(arr.join(""));
			arr = [];
			$("#" + tabName).dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aaSorting": []
			});
			
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "查询日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			//floatKind[0] = dKind;		//a mark point some special thing in target program
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatSum = "账单数量：" + floatCount + "&nbsp;&nbsp;&nbsp;&nbsp;应收款合计：" + floatSum + "&nbsp;元";		//recordset's sum items
			
			if(coverName == "floatCover"){
				showFloatCover();
			}
		});
	}

	//未送达退工单单位列表
	function getNoReturnDocUnitList(coverName,tabName){
		$.get("rptControl.asp?op=getNoReturnDocUnitList&dk=0&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			if(coverName==""){
				coverName = "floatCover";
			}
			if(tabName==""){
				tabName = "floatTab";
			}
			$("#" + coverName).empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = ar0[1];
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='" + tabName + "' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='30%'>单位名称</th>");
			arr.push("<th width='10%'>退工单</th>");
			arr.push("<th width='10%'>联系人</th>");
			arr.push("<th width='15%'>联系电话</th>");
			arr.push("<th width='15%'>最早退工日期</th>");
			arr.push("<th width='10%'>状态</th>");
			arr.push("<th width='10%'>类型</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					i += 1;
					var ar1 = new Array();
					ar1 = val.split("|");
					arr.push("<tr class='grade0'>");
					arr.push("<td width='30%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[4] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[5] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[6] + "</td>");
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
			$("#" + coverName).html(arr.join(""));
			arr = [];
			$("#" + tabName).dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aaSorting": []
			});
			
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "查询日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			//floatKind[0] = dKind;		//a mark point some special thing in target program
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatSum = "单位数量：" + floatCount + "&nbsp;&nbsp;&nbsp;&nbsp;未送达退工单合计：" + floatSum + "&nbsp;";		//recordset's sum items
			
			if(coverName == "floatCover"){
				showFloatCover();
			}
		});
	}

	//未送达更名函单位列表
	function getNoRenameUnitList(coverName,tabName){
		$.get("rptControl.asp?op=getNoRenameUnitList&dk=0&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			if(coverName==""){
				coverName = "floatCover";
			}
			if(tabName==""){
				tabName = "floatTab";
			}
			$("#" + coverName).empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = ar0[1];
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='" + tabName + "' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='30%'>单位名称</th>");
			arr.push("<th width='30%'>原单位名称</th>");
			arr.push("<th width='10%'>联系人</th>");
			arr.push("<th width='15%'>联系电话</th>");
			arr.push("<th width='15%'>机构代码</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					i += 1;
					var ar1 = new Array();
					ar1 = val.split("|");
					arr.push("<tr class='grade0'>");
					arr.push("<td width='30%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='30%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[4] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#" + coverName).html(arr.join(""));
			arr = [];
			$("#" + tabName).dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aaSorting": []
			});
			
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "查询日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			//floatKind[0] = dKind;		//a mark point some special thing in target program
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatSum = "单位数量：" + floatCount + "&nbsp;&nbsp;&nbsp;&nbsp;";		//recordset's sum items
			
			if(coverName == "floatCover"){
				showFloatCover();
			}
		});
	}

	//合同待办单位列表
	function getContractMarkUnitList(coverName,tabName){
		$.get("rptControl.asp?op=getContractMarkUnitList&dk=0&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));s.replace(/,/g, ''); 
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			if(coverName==""){
				coverName = "floatCover";
			}
			if(tabName==""){
				tabName = "floatTab";
			}
			$("#" + coverName).empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = ar0[1];
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='" + tabName + "' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='30%'>单位名称</th>");
			arr.push("<th width='12%'>机构代码</th>");
			arr.push("<th width='10%'>联系人</th>");
			arr.push("<th width='15%'>联系电话</th>");
			arr.push("<th width='10%'>事项</th>");
			arr.push("<th width='13%'>当前合同</th>");
			arr.push("<th width='10%'>单位</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					i += 1;
					var ar1 = new Array();
					ar1 = val.split("|");
					arr.push("<tr class='grade0'>");
					arr.push("<td width='30%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[4] + "</td>");
					arr.push("<td width='13%' class='left'>" + ar1[5] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[6] + "</td>");
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
			$("#" + coverName).html(arr.join(""));
			arr = [];
			$("#" + tabName).dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aaSorting": []
			});
			
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "查询日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			//floatKind[0] = dKind;		//a mark point some special thing in target program
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatSum = "单位数量：" + floatCount + "&nbsp;&nbsp;&nbsp;&nbsp;未送达合同文本合计：" + floatSum + "&nbsp;";		//recordset's sum items
			
			if(coverName == "floatCover"){
				showFloatCover();
			}
		});
	}

	//未取发票单位列表
	function getNoBillUnitList(coverName,tabName){
		$.get("rptControl.asp?op=getNoBillUnitList&dk=0&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			if(coverName==""){
				coverName = "floatCover";
			}
			if(tabName==""){
				tabName = "floatTab";
			}
			$("#" + coverName).empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = ar0[1];
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='" + tabName + "' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='28%'>单位名称</th>");
			arr.push("<th width='14%'>发票号码</th>");
			arr.push("<th width='10%'>金额</th>");
			arr.push("<th width='14%'>付款日期</th>");
			arr.push("<th width='10%'>收款人</th>");
			arr.push("<th width='10%'>联系人</th>");
			arr.push("<th width='14%'>联系电话</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					i += 1;
					var ar1 = new Array();
					ar1 = val.split("|");
					arr.push("<tr class='grade0'>");
					arr.push("<td width='28%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='14%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='14%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[4] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[5] + "</td>");
					arr.push("<td width='14%' class='left'>" + ar1[6] + "</td>");
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
			$("#" + coverName).html(arr.join(""));
			arr = [];
			$("#" + tabName).dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aaSorting": []
			});
			
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "查询日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			//floatKind[0] = dKind;		//a mark point some special thing in target program
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatSum = "单位数量：" + floatCount + "&nbsp;&nbsp;&nbsp;&nbsp;";		//recordset's sum items
			
			if(coverName == "floatCover"){
				showFloatCover();
			}
		});
	}

	//长期不活动单位列表
	function getNoVoiceUnitList(coverName,tabName){
		$.get("rptControl.asp?op=getNoVoiceUnitList&dk=0&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			if(coverName==""){
				coverName = "floatCover";
			}
			if(tabName==""){
				tabName = "floatTab";
			}
			$("#" + coverName).empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = ar0[1];
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='" + tabName + "' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='32%'>单位名称</th>");
			arr.push("<th width='15%'>上次活动</th>");
			arr.push("<th width='8%'>档案</th>");
			arr.push("<th width='10%'>欠款</th>");
			arr.push("<th width='10%'>合同</th>");
			arr.push("<th width='10%'>联系人</th>");
			arr.push("<th width='15%'>联系电话</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='32%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='8%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='10%' class='right'>" + ar1[4] + "</td>");
					arr.push("<td width='10%' class='right'>" + ar1[5] + "</td>");
					arr.push("<td width='15%' class='right'>" + ar1[6] + "</td>");
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
			$("#" + coverName).html(arr.join(""));
			arr = [];
			$("#" + tabName).dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aaSorting": []
			});
			
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "查询日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			//floatKind[0] = dKind;		//a mark point some special thing in target program
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatSum = "账单数量：" + floatCount + "&nbsp;&nbsp;&nbsp;&nbsp;应收款合计：" + floatSum + "&nbsp;元";		//recordset's sum items
			
			if(coverName == "floatCover"){
				showFloatCover();
			}
		});
	}

	//有退休人员单位
	function getRetireUnitList(coverName,tabName){
		$.get("rptControl.asp?op=getRetireUnitList&dk=0&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			if(coverName==""){
				coverName = "floatCover";
			}
			if(tabName==""){
				tabName = "floatTab";
			}
			$("#" + coverName).empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = ar0[1];
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='" + tabName + "' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='35%'>单位名称</th>");
			arr.push("<th width='15%'>机构代码</th>");
			arr.push("<th width='15%'>退休数量</th>");
			arr.push("<th width='10%'>类型</th>");
			arr.push("<th width='10%'>联系人</th>");
			arr.push("<th width='15%'>联系电话</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='35%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='15%' class='center'>" + ar1[2] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='10%' class='right'>" + ar1[4] + "</td>");
					arr.push("<td width='15%' class='right'>" + ar1[5] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#" + coverName).html(arr.join(""));
			arr = [];
			$("#" + tabName).dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aaSorting": []
			});
			
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "查询日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			//floatKind[0] = dKind;		//a mark point some special thing in target program
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatSum = "";		//recordset's sum items
			
			if(coverName == "floatCover"){
				showFloatCover();
			}
		});
	}

	//自管档案未取单位
	function getSelfArchiveUnitList(coverName,tabName){
		$.get("rptControl.asp?op=getSelfArchiveUnitList&dk=0&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			if(coverName==""){
				coverName = "floatCover";
			}
			if(tabName==""){
				tabName = "floatTab";
			}
			$("#" + coverName).empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = ar0[1];
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='" + tabName + "' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='35%'>单位名称</th>");
			arr.push("<th width='15%'>机构代码</th>");
			arr.push("<th width='15%'>档案数量</th>");
			arr.push("<th width='10%'>类型</th>");
			arr.push("<th width='10%'>联系人</th>");
			arr.push("<th width='15%'>联系电话</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='35%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='15%' class='center'>" + ar1[2] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='10%' class='right'>" + ar1[4] + "</td>");
					arr.push("<td width='15%' class='right'>" + ar1[5] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#" + coverName).html(arr.join(""));
			arr = [];
			$("#" + tabName).dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aaSorting": []
			});
			
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "查询日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			//floatKind[0] = dKind;		//a mark point some special thing in target program
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatSum = "";		//recordset's sum items
			
			if(coverName == "floatCover"){
				showFloatCover();
			}
		});
	}
