	var otherListLong = 0;		//0: 标准栏目  1：短栏目
	var otherListChk = 0;

	$(document).ready(function (){
		$("#rptOtherStartDate").click(function(){WdatePicker();});
		$("#rptOtherEndDate").click(function(){WdatePicker();});
		
		/*$("#btnRptOther").click(function(){
			getRptOtherList("data");
		});*/
      	$("#rptOtherStartDate").val(addDays(currDate,-7));
		
		$("#btnRptOther1DownLoad").click(function(){
			getRptOtherList("daily_unit_course","file");
		});
		$("#btnRptOther2DownLoad").click(function(){
			getRptOtherList("daily_course","file");
		});
	});

	function getRptOtherList(op,mark){
		if($("#rptOtherStartDate").val()==""){
			jAlert("请指定一个起始日期。")
			return false;
		}
		//alert("op=other&mark=" + mark + "&host=" + $("#rptOtherHost").val() + "&kindID=" + $("#rptOtherKind").val() + "&startDate=" + $("#rptOtherStartDate").val() + "&endDate=" + $("#rptOtherEndDate").val() + "&groupHost=" + g1 + "&groupDept1=" + g2 + "&groupKindID=" + g3 + "&groupDate=" + g4);
		//@host varchar(50),@startDate varchar(50),@endDate varchar(50),@kindID varchar(20),@groupHost int,@groupDept1 int,@groupKindID int,@groupDate
		$.getJSON(uploadURL + "/public/getRptList?op=" + op + "&mark=" + mark + "&startDate=" + $("#rptOtherStartDate").val() + "&endDate=" + $("#rptOtherEndDate").val(),function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}
		});
	}
	