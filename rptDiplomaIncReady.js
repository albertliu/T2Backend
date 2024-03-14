	var diplomaListLong = 0;		//0: 标准栏目  1：短栏目
	var diplomaListChk = 0;

	$(document).ready(function (){
		var w621 = "status=0 and hostNo='" + currHost + "'";
		var w622 = "status=0 and (kindID=0 or host='" + currHost + "')";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("rptDiplomaHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			getComList("rptDiplomaCert","certificateInfo","certID","certName","status=0 order by certID",1);
			$("#rptDiplomaGroupHost").attr("checked","checked");
		}else{
			getComList("rptDiplomaHost","hostInfo","hostNo","title",w621,0);
			getComList("rptDiplomaCert","certificateInfo","certID","certName",w622,1);
			$("#rptDiplomaGroupDept").attr("checked","checked");
		}
		getDicList("student","rptDiplomaKind",1);
		getDicList("statusExpire","rptDiplomaStatus",1);
		getComList("rptDiplomaAgency","agencyInfo","agencyID","agencyName","status=0 order by agencyID",1);
		$("#rptDiplomaStartDate").click(function(){WdatePicker();});
		$("#rptDiplomaEndDate").click(function(){WdatePicker();});
		
		$("#btnRptDiploma").click(function(){
			getRptDiplomaList("data");
		});
		
		$("#btnRptDiplomaDownLoad").click(function(){
			getRptDiplomaList("file");
		});
	});

	function getRptDiplomaList(mark){
		var g1 = 0;
		var g2 = 0;
		var g3 = 0;
		var g4 = 0;
		var g5 = 0;
		var g6 = 0;
		var g11 = "";
		if($("#rptDiplomaGroupHost").attr("checked")){g1 = 1;}
		if($("#rptDiplomaGroupDept").attr("checked")){g2 = 1;}
		if($("#rptDiplomaGroupKind").attr("checked")){g3 = 1;}
		if($("#rptDiplomaGroupCert").attr("checked")){g4 = 1;}
		if($("#rptDiplomaGroupStatus").attr("checked")){g5 = 1;}
		if($("#rptDiplomaGroupAgency").attr("checked")){g6 = 1;}
		g11 = $("input[name='rptDiplomaGroupDate']:checked").val();
		if(g1+g2+g3+g4+g5+g6==0 && g11==""){
			jAlert("请至少指定一个汇总项目。")
			return false;
		}
        var fromID = "";
        if(checkRole("saler")){
            fromID = currUser;
        }
		//alert("op=diploma&mark=" + mark + "&host=" + $("#rptDiplomaHost").val() + "&kindID=" + $("#rptDiplomaKind").val() + "&startDate=" + $("#rptDiplomaStartDate").val() + "&endDate=" + $("#rptDiplomaEndDate").val() + "&groupHost=" + g1 + "&groupDept1=" + g2 + "&groupKindID=" + g3 + "&groupDate=" + g4);
		//@host varchar(50),@startDate varchar(50),@endDate varchar(50),@kindID varchar(20),@groupHost int,@groupDept1 int,@groupKindID int,@groupDate
		$.getJSON(uploadURL + "/public/getRptList?op=diploma&mark=" + mark + "&fromID=" + fromID + "&host=" + $("#rptDiplomaHost").val() + "&kindID=" + $("#rptDiplomaKind").val() + "&certID=" + $("#rptDiplomaCert").val() + "&status=" + $("#rptDiplomaStatus").val() + "&agencyID=" + $("#rptDiplomaAgency").val() + "&startDate=" + $("#rptDiplomaStartDate").val() + "&endDate=" + $("#rptDiplomaEndDate").val() + "&groupHost=" + g1 + "&groupDept1=" + g2 + "&groupKindID=" + g3 + "&groupCertID=" + g4 + "&groupStatus=" + g5 + "&groupAgencyID=" + g6 + "&groupDate=" + g11,function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}

			if(mark=="data" && data.length>0){
				let ar = new Array();
				arr = [];
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptDiplomaTab' width='99%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='3%'>No</th>");
				let line = data[0];
				let colspan = 0;
				for(let key in line){
					arr.push("<th class='center'>" + key + "</th>");
					colspan += 1;
				}
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				var i = 0;
				var c = 0;
				var h = "";
				var qty = 0;
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					for(let key in val){
						arr.push("<td class='left'>" + val[key] + "</td>");
					}
					arr.push("</tr>");
					qty += val['数量'];
				});
				arr.push("<tr class='grade" + c + "' style='color:red;'>");
				arr.push("<td class='center' colspan=" + colspan + ">合计</td>");
				arr.push("<td class='left'>" + qty + "</td>");
				arr.push("</tr>");
				arr.push("</tbody>");
				arr.push("<tfoot>");
				arr.push("<tr>");
				for(let j=0; j<data[0].length+1; j++){
					arr.push("<th>&nbsp;</th>");
				}
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptDiplomaCover").html(arr.join(""));
				arr = [];
				$('#rptDiplomaTab').dataTable({
					"aaSorting": [],
					"bFilter": true,
					"bPaginate": true,
					"bLengthChange": true,
					"bInfo": true,
					"aoColumnDefs": []
				});
			}
		});
	}
	