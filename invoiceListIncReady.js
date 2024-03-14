	var invoiceListLong = 0;		//0: 标准栏目  1：短栏目
	var invoiceListChk = 0;
	var invoiceProjectStatus = 0;

	$(document).ready(function (){
		getDicList("statusPay","searchInvoiceStatus",1);
		getDicList("payType","searchInvoiceType",1);
		getDicList("payKind","searchInvoiceKind",1);
		getDicList("statusNo","searchPayCheck",1);
		$("#searchInvoiceStartDate").click(function(){WdatePicker();});
		$("#searchInvoiceEndDate").click(function(){WdatePicker();});
		
		$("#btnSearchInvoice").click(function(){
			getInvoiceList();
		});
		
		$("#txtSearchInvoice").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchInvoice").val()>""){
					getInvoiceList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		if(checkPermission("cashier")){
			$("#invoiceListLongItem5").show();
		}else{
			$("#invoiceListLongItem5").hide();
		}
		$("#btnPaySel").click(function(){
			setSel("visitstockchkPay");
		});
		
		$("#btnPayCheck").click(function(){
			getSelCart("visitstockchkPay");
			if(selCount==0){
				jAlert("请选择要接收的名单。");
				return false;
			}
			jConfirm("确定要接收这些(" + selCount + "个)收费清单吗？","确认",function(r){
				if(r){
					//alert($("#searchPayProjectID").val() + "&status=1&host=" + $("#searchPayHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					$.get("studentCourseControl.asp?op=doAccount_check_batch&keyID=" + selList ,function(data){
						//jAlert(data);
						if(data=="0"){
							jAlert("接收成功");
							getPayList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		//getInvoiceList();
	});

	function getInvoiceList(){
		sWhere = $("#txtSearchInvoice").val();
		//if($("#searchInvoiceOld").attr("checked")){Old = 1;}
		//alert("kindID=" + $("#searchInvoiceKind").val() + "&refID=" + $("#searchInvoiceType").val() + "&status=" + $("#searchInvoiceStatus").val() + "&fStart=" + $("#searchInvoiceStartDate").val() + "&fEnd=" + $("#searchInvoiceEndDate").val());
		$.get("studentCourseControl.asp?op=getInvoiceList&where=" + escape(sWhere) + "&kindID=" + $("#searchInvoiceKind").val() + "&refID=" + $("#searchInvoiceType").val() + "&checked=" + $("#searchPayCheck").val() + "&status=" + $("#searchInvoiceStatus").val() + "&fStart=" + $("#searchInvoiceStartDate").val() + "&fEnd=" + $("#searchInvoiceEndDate").val() + "&dk=102&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#invoiceCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='invoiceTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='10%'>发票号码</th>");
			arr.push("<th width='7%'>金额</th>");
			arr.push("<th width='10%'>支付方式</th>");
			arr.push("<th width='7%'>类别</th>");
			arr.push("<th width='7%'>状态</th>");
			arr.push("<th width='10%'>开票日期</th>");
			arr.push("<th width='15%'>发票抬头</th>");
			arr.push("<th width='10%'>招生批次</th>");
			arr.push("<th width='6%'>财务</th>");
			arr.push("<th width='3%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk1 = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					h = "未开票";
					if(ar1[1]>""){h=ar1[1];}
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showInvoiceInfo(" + ar1[0] + ",0,0,1);'>" + h + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[22] + "</td>");
					arr.push("<td class='left'>" + ar1[23] + "</td>");
					if(ar1[15]==""){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'>" + imgChk1 + "</td>");
					}
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkPay'>" + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#invoiceCover").html(arr.join(""));
			arr = [];
			$('#invoiceTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"iDisplayLength": 100,
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
	