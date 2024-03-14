	$(document).ready(function (){
        getComboList("rptTrainningSales","userInfo","username","realName","status=0 and host='" + currHost + "' and username in(select username from roleUserList where roleID='saler') order by realName",1);
		getComboList("rptTrainningCourseID","v_courseInfo","courseID","courseName2","status=0 and mark=1 order by seq",1);
		$("#rptTrainningStartDate").datebox("setValue", new Date().format("yyyy-MM") + '-01');		

		$("#rptTrainningMoth").checkbox({
			onChange: function(val){
				if($("#rptTrainningMoth").checkbox("options").checked){
					$("#rptTrainningStartDate").datebox("setValue",new Date().format("yyyy") + '-01-01');
				}else{
					$("#rptTrainningStartDate").datebox("setValue", new Date().format("yyyy-MM") + '-01');
				}
			}
		});

		$("#btnRptTrainning").linkbutton({
			iconCls:'icon-search',
			width:70,
			height:25,
			text:'预览',
			onClick:function() {
				getRptTrainningList("data");
			}
		});
		$("#btnRptTrainningDownLoad").linkbutton({
			iconCls:'icon-download',
			width:70,
			height:25,
			text:'下载',
			onClick:function() {
				getRptTrainningList("file");
			}
		});
	});

	function getRptTrainningList(mark){
		let mark1 = 'D';
		if($("#rptTrainningMoth").checkbox("options").checked){
			mark1 = 'M';
		}
		$.getJSON(uploadURL + "/public/getRptList?op=trainning&mark=" + mark + "&sales=" + $("#rptTrainningSales").combobox("getValue") + "&host=" + currHost + "&courseID=" + $("#rptTrainningCourseID").combobox("getValue") + "&startDate=" + $("#rptTrainningStartDate").val() + "&endDate=" + $("#rptTrainningEndDate").val() + "&mark1=" + mark1,function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}

			if(mark=="data" && data.length>0){
				$("#rptTrainningCover").empty();
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptTrainningCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='10%'>日期</th>");
				arr.push("<th width='10%'>财付通G</th>");
				arr.push("<th width='10%'>财付通S</th>");
				arr.push("<th width='10%'>微信收款</th>");
				arr.push("<th width='10%'>支付宝收款</th>");
				arr.push("<th width='10%'>现金收款</th>");
				arr.push("<th width='10%'>对公汇款</th>");
				arr.push("<th width='10%'>小计</th>");
				arr.push("<th width='10%'>退款</th>");
				arr.push("<th width='10%'>合计</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					arr.push("<tr class='grade0'>");
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
				arr.push("<th>&nbsp;</th>");
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptTrainningCover").html(arr.join(""));
				arr = [];
				$('#rptTrainningCoverTab').dataTable({
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
	