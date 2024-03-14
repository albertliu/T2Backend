	var projectListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		var w_project = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchProjectHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			$("#searchProjectHost").val("spc");
		}else{
			getComList("searchProjectHost","hostInfo","hostNo","title",w_project,0);
		}
		$("#searchProjectStart").click(function(){WdatePicker();});
		$("#searchProjectEnd").click(function(){WdatePicker();});
		getComList("searchProjectCert","certificateInfo","certID","certName","status=0 and type=0 order by certID",1);
		getDicList("statusIssue","searchProjectStatus",1);

		$("#btnSearchProject").click(function(){
			getProjectList();
		});

		$("#btnSearchProjectAdd").click(function(){
			showProjectInfo(0,0,1,1);
		});
		
		if(projectListLong == 0){
			$("#projectListLongprojectName1").show();
		}else{
			$("#projectListLongprojectName1").hide();
		}
		
		if(checkPermission("projectAdd")){
			$("#btnSearchProjectAdd").show();
		}else{
			$("#btnSearchProjectAdd").hide();
		}
		
		$("#searchProjectHost").change(function(){
			setHostProjectChange();
		});
		
		setHostProjectChange();
		//getProjectList();
	});

	function getProjectList(){
		sWhere = $("#txtSearchProject").val();
		//alert("&fStart=" + $("#searchProjectStart").val() + "&fEnd=" + $("#searchProjectEnd").val() + "&kindID=" + $("#searchProjectKind").val() + "&status=" + $("#searchProjectStatus").val() + "&host=" + $("#searchProjectHost").val());
		var s = $("#searchProjectStatus").val();
		if(!checkPermission("projectAdd")){
			s = 1;	//一般人只能看已发布的通知
		}
		//alert($("#searchProjectDept").val() + "&fStart=" + $("#searchProjectStart").val() + "&fEnd=" + $("#searchProjectEnd").val() + "&refID=" + $("#searchProjectCert").val() + "&status=" + s + "&host=" + $("#searchProjectHost").val());
		$.get("projectControl.asp?op=getProjectList&where=" + escape(sWhere) + "&keyID=" + $("#searchProjectDept").val() + "&fStart=" + $("#searchProjectStart").val() + "&fEnd=" + $("#searchProjectEnd").val() + "&refID=" + $("#searchProjectCert").val() + "&status=" + s + "&host=" + $("#searchProjectHost").val() + "&dk=17&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#projectCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='projectTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='12%'>批次</th>");
			arr.push("<th width='20%'>标题</th>");
			arr.push("<th width='12%'>截止日期</th>");
			arr.push("<th width='8%'>总数</th>");
			arr.push("<th width='8%'>已确认</th>");
			arr.push("<th width='8%'>待确认</th>");
			arr.push("<th width='8%'>拒绝</th>");
			arr.push("<th width='8%'>报到</th>");
			arr.push("<th width='8%'>状态</th>");
			arr.push("<th width='8%'>附件</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			var mNew = "";
			var imgChk = "<img src='images/attachment.png' height='15'>";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showProjectInfo(" + ar1[0] + ",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + nullNoDisp(ar1[20]) + "</td>");
					arr.push("<td class='left'>" + nullNoDisp(ar1[17]) + "</td>");
					arr.push("<td class='left'>" + nullNoDisp(ar1[35]) + "</td>");
					arr.push("<td class='left'>" + nullNoDisp(ar1[27]) + "</td>");
					arr.push("<td class='left'>" + nullNoDisp(ar1[26]) + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					if(ar1[21]==''){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'><a href='/users" + ar1[21] + "' target='_blank'>" + imgChk + "</a></td>");
					}
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
			$("#projectCover").html(arr.join(""));
			arr = [];
			$('#projectTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatprojectName = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}


	function downloadProjectList(pID){
		//alert(pID);
		$("#searchStudentCourseProjectID").val(pID);
		getProjectList();
		outputFloat(13,'file');
	}

	function setHostProjectChange(){
		//alert($("#searchStudentPreHost").val());
		if(currDeptID>0){
			getComList("searchProjectDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchProjectHost").val() + "' and pID=0) and deptID=" + currDeptID,0);
		}else{
			getComList("searchProjectDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchProjectHost").val() + "' and pID=0) and kindID=0 and dept_status<9",1);
		}
		setProjectList();
	}
	
	