	$(document).ready(function (){
		$("#rptPartnerSalesStartDate").datebox("setValue", new Date().format("yyyy-MM-dd"));		
		$("#btnRptPartnerSales").linkbutton({
			iconCls:'icon-search',
			width:70,
			height:25,
			text:'预览',
			onClick:function() {
				getRptPartnerSalesList("data");
				getRptPartnerSalesTypeList("data");
			}
		});
		$("#btnRptPartnerSalesDownLoad").linkbutton({
			iconCls:'icon-download',
			width:70,
			height:25,
			text:'下载',
			onClick:function() {
				getRptPartnerSalesList("file");
			}
		});
	});

	function getRptPartnerSalesList(mark){
		$.getJSON(uploadURL + "/public/getRptList?op=partnerSales&mark=" + mark + "&partnerID=" + currHost + "&startDate=" + $("#rptPartnerSalesStartDate").val() + "&endDate=" + $("#rptPartnerSalesEndDate").val(),function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}

			if(mark=="data" && data.length>0){
				$("#rptPartnerSalesCover").empty();
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptPartnerSalesCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='30%'>销售姓名</th>");
				arr.push("<th width='30%'>当日合计</th>");
				arr.push("<th width='40%'>当月合计</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					let j = 0;
					arr.push("<tr class='grade0'>");
					for(let key in val){
						if(key != "sales"){
							arr.push("<td" + (j>0 ? " class='link1'>" : " class='left'>") + (j>0 ? "<a href='javascript:getRptPartnerSalesDetailList(\"" + val["sales"] + "\"," + (j - 1) + ");'>" : "") + (val[key]) + (j>0 ? "</a>" : "") + "</td>");
						}
						j += 1
					}
					arr.push("</tr>");
				});
				arr.push("</tbody>");
				arr.push("<tfoot>");
				arr.push("<tr>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptPartnerSalesCover").html(arr.join(""));
				arr = [];
				$('#rptPartnerSalesCoverTab').dataTable({
					"aaSorting": [],
					"bFilter": true,
					"bPaginate": true,
					"bLengthChange": true,
					"aLengthMenu":[15,30,50,100],
					"iDisplayLength": 50,
					"bInfo": true,
					"aoColumnDefs": []
				});
	
			}
		});
	}

	function getRptPartnerSalesTypeList(mark){
		$.getJSON(uploadURL + "/public/getRptList?op=partnerSalesType&mark=" + mark + "&partnerID=" + currHost + "&startDate=" + $("#rptPartnerSalesStartDate").val() + "&endDate=" + $("#rptPartnerSalesEndDate").val(),function(data){
			//jAlert(data);
			if(mark=="data" && data.length>0){
				$("#rptPartnerSalesTypeCover").empty();
				arr = [];
				var i = 0;
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptPartnerSalesTypeCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='20%'>序号</th>");
				arr.push("<th width='40%'>付款方式</th>");
				arr.push("<th width='40%'>金额</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + (val["pay_typeName"]) + "</td>");
					arr.push("<td class='left'>" + (val["金额"]) + "</td>");
					arr.push("</tr>");
				});
				arr.push("</tbody>");
				arr.push("<tfoot>");
				arr.push("<tr>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptPartnerSalesTypeCover").html(arr.join(""));
				arr = [];
				$('#rptPartnerSalesTypeCoverTab').dataTable({
					"aaSorting": [],
					"bFilter": false,
					"bPaginate": false,
					"bLengthChange": false,
					"bInfo": false,
					"aoColumnDefs": []
				});
	
			}
		});
	}

	function getRptPartnerSalesDetailList(sales, k){
		$.getJSON(uploadURL + "/public/getRptDetailList?op=partnerSales&sales=" + sales + "&partnerID=" + currHost + "&kind=" + k + "&startDate=" + $("#rptPartnerSalesStartDate").val() + "&endDate=" + $("#rptPartnerSalesEndDate").val(),function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}

			if(data.length>0){
				$("#rptPartnerSalesDetailCover").empty();
				let i = 0;
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptPartnerSalesDetailCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='2%'>No</th>");
				arr.push("<th width='16%'>身份证</th>");
				arr.push("<th width='8%'>姓名</th>");
				arr.push("<th width='8%'>金额</th>");
				arr.push("<th width='10%'>日期</th>");
				arr.push("<th width='8%'>类型</th>");
				arr.push("<th width='18%'>课程</th>");
				arr.push("<th width='12%'>备注</th>");
				arr.push("<th width='12%'>去向</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					for(let key in val){
						arr.push("<td class='left'>" + nullNoDisp(val[key]) + "</td>");
					}
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
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptPartnerSalesDetailCover").html(arr.join(""));
				arr = [];
				$('#rptPartnerSalesDetailCoverTab').dataTable({
					"aaSorting": [],
					"bFilter": true,
					"bPaginate": true,
					"bLengthChange": true,
					"aLengthMenu":[15,30,50,100],
					"iDisplayLength": 50,
					"bInfo": true,
					"aoColumnDefs": []
				});
	
			}
		});
	}
	