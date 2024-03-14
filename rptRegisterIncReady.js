	$(document).ready(function (){
        getComboList("rptRegisterTeacher","userInfo","username","realName","status=0 and host='" + currHost + "' and username in(select username from roleUserList where roleID='teacher') order by realName",1);
		$("#rptRegisterStartDate").datebox("setValue", new Date().format("yyyy-MM") + '-01');		

		$("#rptRegisterMoth").checkbox({
			onChange: function(val){
				if($("#rptRegisterMoth").checkbox("options").checked){
					$("#rptRegisterStartDate").datebox("setValue",new Date().format("yyyy") + '-01-01');
				}else{
					$("#rptRegisterStartDate").datebox("setValue", new Date().format("yyyy-MM") + '-01');
				}
			}
		});

		$("#btnRptRegister").linkbutton({
			iconCls:'icon-search',
			width:70,
			height:25,
			text:'预览',
			onClick:function() {
				getRptRegisterList("data");
			}
		});
		$("#btnRptRegisterDownLoad").linkbutton({
			iconCls:'icon-download',
			width:70,
			height:25,
			text:'下载',
			onClick:function() {
				getRptRegisterList("file");
			}
		});
	});

	function getRptRegisterList(mark){
		let mark1 = 'D';
		if($("#rptRegisterMoth").checkbox("options").checked){
			mark1 = 'M';
		}
		$.getJSON(uploadURL + "/public/getRptList?op=register&mark=" + mark + "&teacherID=" + $("#rptRegisterTeacher").combobox("getValue") + "&host=" + currHost + "&startDate=" + $("#rptRegisterStartDate").val() + "&endDate=" + $("#rptRegisterEndDate").val() + "&mark1=" + mark1,function(data){
			// jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}

			if(mark=="data" && data.length>0){
				$("#rptRegisterCover").empty();
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptRegisterCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='10%'>日期</th>");
				arr.push("<th width='10%'>叉车司机(初审)</th>");
				arr.push("<th width='10%'>叉车司机(复审)</th>");
				arr.push("<th width='10%'>小计</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					let j = 0;
					arr.push("<tr class='grade0'>");
					for(let key in val){
						if(key != "mark"){
							arr.push("<td" + (j>0 && val["mark"]==0 && mark1 == 'D' ? " class='link1'>" : " class='left'>") + (j>0 && val["mark"]==0 && mark1 == 'D' ? "<a href='javascript:getRptRegisterDetailList(\"" + val["签到时间"] + "\"," + j + ");'>" : "") + (val[key]) + (j>0 ? "</a>" : "") + "</td>");
							j += 1
						}
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
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptRegisterCover").html(arr.join(""));
				arr = [];
				$('#rptRegisterCoverTab').dataTable({
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

	function getRptRegisterDetailList(regDate, k){
		$.getJSON(uploadURL + "/public/getRptDetailList?op=register&host=" + currHost + "&kind=" + k + "&regDate=" + regDate + "&teacherID=" + $("#rptRegisterTeacher").combobox("getValue"),function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
	
			if(data.length>0){
				$("#rptRegisterDetailCover").empty();
				let i = 0;
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptRegisterDetailCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='2%'>No</th>");
				arr.push("<th width='18%'>身份证</th>");
				arr.push("<th width='8%'>姓名</th>");
				arr.push("<th width='20%'>课程</th>");
				arr.push("<th width='12%'>签到时间</th>");
				arr.push("<th width='12%'>教师</th>");
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
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptRegisterDetailCover").html(arr.join(""));
				arr = [];
				$('#rptRegisterDetailCoverTab').dataTable({
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
	