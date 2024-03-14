	var payListLong = 0;		//0: 标准栏目  1：短栏目
	var payListChk = 0;
	var payProjectStatus = 0;

	$(document).ready(function (){
		getComList("searchPayHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		getComList("searchPayCourseID","v_courseInfo","courseID","courseName","status=0 and type=0 order by courseID",1);
		getComList("searchPayProjectID","projectInfo","projectID","projectID","status>0 and status<9 order by ID desc",1);
		getComList("searchPayClassID","classInfo","classID","classID","1=1 order by ID desc",1);

		getDicList("statusPay","searchPayStatus",1);
		$("#searchPayStartDate").click(function(){WdatePicker();});
		$("#searchPayEndDate").click(function(){WdatePicker();});
		
		$("#btnSearchPay").click(function(){
			getPayList();
		});
		
		$("#txtSearchPay").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchPay").val()>""){
					getPayList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		$("#btnPaySel").click(function(){
			setSel("visitstockchkPay");
		});
		
		$("#searchPayHost").change(function(){
			getComList("searchPayDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchPayHost").val() + "' and pID=0) and dept_status<9",1);
			getComList("searchPayProjectID","projectInfo","projectID","projectID","host='" + $("#searchPayHost").val() + "' and status=1 or status=2 order by ID desc",1);
		});
		
		$("#searchPayProjectID").change(function(){
			setPayItem();
		});

		$("#payListLongItem3").hide();
		$("#payListLongItem4").hide();

		//getPayList();
	});

	function getPayList(){
		sWhere = $("#txtSearchPay").val();
		var Old = 0;
        var mark = 1;
        if(checkRole("saler")){
            mark = 3;
        }
		//if($("#searchPayOld").attr("checked")){Old = 1;}
		//alert($("#searchPayDept").val() + "&refID=" + $("#searchPayProjectID").val() + "&status=" + $("#searchPayStatus").val() + "&photoStatus=" + $("#searchPayPhotoStatus").val() + "&courseID=" + $("#searchPayCourseID").val() + "&host=" + $("#searchPayHost").val() + "&checked=" + $("#searchPayChecked").val() + "&materialChecked=" + $("#searchPayMaterialChecked").val() + "&classID=" + $("#searchPayClassID").val());
		$.get("studentCourseControl.asp?op=getPayList&where=" + escape(sWhere) + "&mark=" + mark + "&kindID=" + $("#searchPayDept").val() + "&refID=" + $("#searchPayProjectID").val() + "&status=" + $("#searchPayStatus").val() + "&courseID=" + $("#searchPayCourseID").val() + "&host=" + $("#searchPayHost").val() + "&classID=" + $("#searchPayClassID").val() + "&fStart=" + $("#searchPayStartDate").val() + "&fEnd=" + $("#searchPayEndDate").val() + "&dk=102&times=" + (new Date().getTime()),function(data){
		//$.getJSON("payControl.asp?op=getPayList",function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#payCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='payTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='10%'>身份证</th>");
			arr.push("<th width='7%'>姓名</th>");
			arr.push("<th width='12%'>课程名称</th>");
			if(currHost==""){
				arr.push("<th width='10%'>公司</th>");
			}else{
				arr.push("<th width='10%'>部门</th>");
			}
			arr.push("<th width='6%'>状态</th>");
			arr.push("<th width='8%'>付款日期</th>");
			arr.push("<th width='6%'>金额</th>");
			arr.push("<th width='6%'>方式</th>");
			arr.push("<th width='6%'>类别</th>");
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
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(\"" + ar1[2] + "\",\"" + ar1[4] + "\",0,1);'>" + ar1[4] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[4] + "\",0,1);'>" + ar1[5] + "</a></td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					if(currHost==""){
						if(ar1[10]=="znxf"){	//非集团客户，显示自己的单位和部门
							arr.push("<td class='left'>" + ar1[42].substr(0,4) + "</td>");
						}else{
							arr.push("<td class='left'>" + ar1[11].substr(0,4) + "</td>");
						}
					}else{
						arr.push("<td class='left'>" + ar1[13].substr(0,5) + "</td>");
					}
					arr.push("<td class='left'>" + ar1[37] + "</td>");
					arr.push("<td class='left'>" + ar1[18] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[35] + "</td>");
					arr.push("<td class='left'>" + ar1[33] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#payCover").html(arr.join(""));
			arr = [];
			$('#payTab').dataTable({
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

	function setPayItem(){
		if($("#searchPayProjectID").val()>""){
			$("#payListLongItem6").hide();
			$.get("projectControl.asp?op=getStatus&refID=" + $("#searchPayProjectID").val() ,function(data){
				payProjectStatus = data;
			});
			if($("#searchPayShowPhoto").attr("checked")){
				$("#payListLongItem4").show();
			}else{
				$("#payListLongItem4").hide();
			}
		}else{
			$("#payListLongItem4").hide();
			$("#payListLongItem6").show();
		}
		getPayList();
	}
	