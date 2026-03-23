	$(document).ready(function (){
		$("#btnRptPayInvoice").linkbutton({
			iconCls:'icon-search',
			width:70,
			height:25,
			text:'预览',
			onClick:function() {
				getRptPayInvoiceList("data");
			}
		});
		$("#btnRptPayInvoiceDownLoad").linkbutton({
			iconCls:'icon-download',
			width:70,
			height:25,
			text:'下载',
			onClick:function() {
				getRptPayInvoiceList("file");
			}
		});
		$("#rptPayInvoiceAutoPay").checkbox({
			onChange: function(val){
				getRptPayInvoiceList("data");
			}
		});
		$("#rptPayInvoiceAutoInvoice").checkbox({
			onChange: function(val){
				getRptPayInvoiceList("data");
			}
		});
		$("#rptPayInvoiceReceived").checkbox({
			onChange: function(val){
				if(val){
					//if it's true, set other checkbox to false
					$("#rptPayInvoiceReceivable").prop("checked",false);
					$("#rptPayInvoiceAutoInvoice").prop("checked",false);
					$("#rptPayInvoiceAutoPay").prop("checked",false);
				}
				getRptPayInvoiceList("data");
			}
		});
		$("#rptPayInvoiceReceivable").checkbox({
			onChange: function(val){
				if(val){
					$("#rptPayInvoiceReceived").prop("checked",false);
					$("#rptPayInvoiceStartDate1").datebox("setValue","");
					$("#rptPayInvoiceEndDate1").datebox("setValue","");
					$("#rptPayInvoiceStartDate").datebox("setValue","");
					$("#rptPayInvoiceEndDate").datebox("setValue", "");
				}else{
					$("#rptPayInvoiceStartDate1").datebox("setValue","");
					$("#rptPayInvoiceEndDate1").datebox("setValue","");
					$("#rptPayInvoiceStartDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
				}
				getRptPayInvoiceList("data");
			}
		});
		$("#rptPayInvoiceStartDate").datebox({
			onChange:function() {
				if($("#rptPayInvoiceStartDate").datebox("getValue")>''){
					$("#rptPayInvoiceStartDate1").datebox("setValue","");
					$("#rptPayInvoiceEndDate1").datebox("setValue","");
					$("#rptPayInvoiceEndDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
				}
			}
		});
		$("#rptPayInvoiceStartDate1").datebox({
			onChange:function() {
				if($("#rptPayInvoiceStartDate1").datebox("getValue")>''){
					$("#rptPayInvoiceStartDate").datebox("setValue","");
					$("#rptPayInvoiceEndDate").datebox("setValue","");
					$("#rptPayInvoiceEndDate1").datebox("setValue", new Date().format("yyyy-MM-dd"));
				}
			}
		});
		$("#rptPayInvoiceStartDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
		$("#rptPayInvoiceEndDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
		
		$("#btnRptPayInvoiceReceive").click(function(){
			if(!$("#rptPayInvoiceReceivable").checkbox("options").checked){
				jAlert("请勾选[应收]选项。");
				return false;
			}
			getSelCart("rptPayInvoiceChk");
			if(selCount==0){
				jAlert("请选择要确认的名单。");
				return false;
			}
			jConfirm("确定这些(" + selCount + "个)应收款已到账吗？","确认",function(r){
				if(r){
					jPrompt('到账日期:', currDate, '附加信息', function (r1) {
						if ((r1>"" && isDate(r1))) {
							$.post(uploadURL + "/public/checkReceiveList", {selList: selList, theDate:r1, registerID: currUser} ,function(data){
								//jAlert(data);
								jAlert("已确认。");
								getRptPayInvoiceList("data");
							});
						}else{
							jAlert("请输入正确的到账日期");
						}
					});
				}
			});
		});
		if(!checkPermission("receiveCheck")){
			$("#rptPayInvoiceItem1").hide();
		}
	});

	function getRptPayInvoiceList(mark){
		let autoPay = 0;
		let autoInvoice = 0;
		let receivable = 0;
		let received = 0;
		if($("#rptPayInvoiceAutoPay").checkbox("options").checked){
			autoPay = 1;
		}
		if($("#rptPayInvoiceAutoInvoice").checkbox("options").checked){
			autoInvoice = 1;
		}
		if($("#rptPayInvoiceReceivable").checkbox("options").checked){
			receivable = 1;
		}
		if($("#rptPayInvoiceReceived").checkbox("options").checked){
			received = 1;
		}
		$.getJSON(uploadURL + "/public/getRptList?op=payInvoice&mark=" + mark + "&autoPay=" + autoPay + "&autoInvoice=" + autoInvoice + "&receivable=" + receivable + "&received=" + received + "&host=znxf&startDate=" + $("#rptPayInvoiceStartDate").val() + "&endDate=" + $("#rptPayInvoiceEndDate").val() + "&startDate1=" + $("#rptPayInvoiceStartDate1").val() + "&endDate1=" + $("#rptPayInvoiceEndDate1").val(),function(data){
			// jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}
			if(mark=="data"){
				$("#rptPayInvoiceCover").empty();
			}
			
			if(mark=="data" && data.length>0){
				let i = 0;
				let imgChk = "<img src='images/attachment.png' style='width:14px;'>";
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptPayInvoiceCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='2%'>No</th>");
				arr.push("<th width='6%'>姓名</th>");
				arr.push("<th width='6%'>金额</th>");
				arr.push("<th width='8%'>付款日期</th>");
				if(receivable==0){
					arr.push("<th width='7%'>类型</th>");
				}
				arr.push("<th width='14%'>课程</th>");
				arr.push("<th width='6%'>应收</th>");
				arr.push("<th width='14%'>发票号码</th>");
				arr.push("<th width='8%'>开票日期</th>");
				arr.push("<th width='14%'>发票抬头</th>");
				arr.push("<th width='11%'>备注</th>");
				arr.push("<th width='4%'>票</th>");
				if(receivable==1){
					arr.push("<th width='1%'></th>");
				}
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					let s = "";
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(\"" + val["ID"] + "\",\"" + val["username"] + "\",0,0);'>" + val["name"] + "</a></td>");
					arr.push("<td class='left'>" + val["金额"] + "</td>");
					arr.push("<td class='left'" + (val["autoPay"]=="1"?" style='background:#FFFF88;'" : "") + ">" + val["datePay"] + "</td>");
					if(receivable==0){
						arr.push("<td class='left'>" + val["pay_typeName"] + "</td>");
					}
					arr.push("<td class='left'>" + val["shortName"] + "</td>");
					if(val["noReceive"]==1){
						s = "待收";
					}
					if(val["noReceive"]==2){
						s = "已收";
					}
					arr.push("<td class='left'>" + s + "</td>");
					arr.push("<td class='left'>" + val["发票号码"] + "</td>");
					arr.push("<td class='left'" + (val["autoInvoice"]=="1"?" style='background:#FFFF88;'" : "") + ">" + val["dateInvoice"] + "</td>");
					arr.push("<td class='left'>" + val["title"] + "</td>");
					arr.push("<td class='left' title='" + val["pay_memo"] + "'>" + nullNoDisp(val["pay_memo"]).substring(0,10) + "</td>");
					arr.push("<td class='link1'><a href='javascript:showPDF(\"" + val["invoicePDF"] + "\",0,0,0);'>" + (val["invoicePDF"]>""?imgChk:"") + "</td>");
					if(receivable==1){
						arr.push("<td class='center'><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + val["ID"] + "' name='rptPayInvoiceChk'></td>");
					}
					/*for(let key in val){
						if(j>4){
							t = 0;
							if(key == "name" && val[key]>""){
								t = 1;
							}
							if(key == "invoicePDF" && val[key]>""){
								t = 2;
							}
							s = "<td" + (t>0 ? " class='link1'>" : " class='left' " + ((val["autoPay"]=="1" && key=="datePay") || (val["autoInvoice"]=="1" && key=="dateInvoice") ? "style='background:#FFFF88;'" : "") + ">");
							// s += (key == "invoicePDF" && val[key]>"" ? "<a href='javascript:showPDF(\"" + val["invoicePDF"] + "\",0,0,0);'>" + imgChk : (key=="pay_memo"?nullNoDisp(val[key]).substring(0,10):nullNoDisp(val[key])));
							if(t==0){
								s += (key=="pay_memo"?nullNoDisp(val[key]).substring(0,10):nullNoDisp(val[key]));
							}
							if(t==1){
								s += "<a href='javascript:showEnterInfo(\"" + val["ID"] + "\",\"" + val["username"] + "\",0,0);'>" + nullNoDisp(val[key]);
							}
							if(t==2){
								s += "<a href='javascript:showPDF(\"" + val["invoicePDF"] + "\",0,0,0);'>" + imgChk;
							}
							s += (t>0 ? "</a>" : "") + "</td>";
							arr.push(s);
							//alert(s)
						}
						j += 1;
					}*/
					arr.push("</tr>");
				});
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
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptPayInvoiceCover").html(arr.join(""));
				arr = [];
				$('#rptPayInvoiceCoverTab').dataTable({
					"aaSorting": [],
					"bFilter": true,
					"bPaginate": true,
					"bLengthChange": true,
					"aLengthMenu":[15,30,50,100,500],
					"iDisplayLength": 50,
					"bInfo": true,
					"aoColumnDefs": []
				});
	
			}
		});
	}