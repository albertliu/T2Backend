	var classListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getDicList("planStatus","searchClassStatus",1);
		getComList("searchClassProject","projectInfo","projectID","projectName","status>0 and status<9 order by projectID desc",1);
		if(currHost==""){
			getComList("searchClassPartner","hostInfo","hostNo","title","status=0 and kindID=1 order by ID",1);
			getComList("searchClassCert","certificateInfo","certID","shortName","status=0 and type=0 order by certID",1);
			getComList("searchClassAdviser","v_classAdviser","adviserID","adviserName","1=1",1);
		}else{
			getComList("searchClassPartner","hostInfo","hostNo","title","status=0 and kindID=1 and hostNo='" + currHost + "' order by ID",0);
			getComList("searchClassCert","v_hostCourseList","courseID","shortName","host='" + currHost + "' order by courseID",1);
			getComList("searchClassAdviser","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser' and host='" + currHost + "') order by realName",1);
			$("#searchClassProject").hide();
			//$("#searchClassAdviser").hide();
		}
		
		if(checkPermission("classAdd")){
			$("#btnAddClass").show();
		}else{
			$("#btnAddClass").hide();
		}
		$("#btnSearchClass").click(function(){
			getClassList();
		});
		$("#btnCheckStudent").click(function(){
			if($("#searchClassCert").val()==""){
				alert("请选择一个课程。");
				return false;
			}
			showLoadFile("check_student_list",$("#searchClassCert").val(),"studentList",'');
		});
		
		$("#btnAddClass").click(function(){
			showClassInfo(0,0,1,1);	//showClassInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#searchClassAdviser").change(function(){
			if($("#searchClassAdviser").val()>""){
				getComList("searchClassCert","certificateInfo","certID","shortName","status=0 and type=0 and certID in(select certID from classInfo where adviserID='" + $("#searchClassAdviser").val() + "') order by certID",1);
			}else{
				getComList("searchClassCert","certificateInfo","certID","shortName","status=0 and type=0 order by certID",1);
			}
			getClassList();
		});
	});

	function getClassList(){
		sWhere = $("#txtSearchClass").val();
        var mark = 1;
        if(checkRole("saler")){
            mark = 3;
        }
		var k = $("#searchClassAdviser").val();
		if(k=="null" || k==null){k="";}
		//alert((sWhere) + "&refID=" + $("#searchClassCert").val() + "&status=" + $("#searchClassStatus").val() + "&project=" + $("#searchClassProject").val());
		$.get("classControl.asp?op=getClassList&where=" + escape(sWhere) + "&mark=" + mark + "&refID=" + $("#searchClassCert").val() + "&host=" + $("#searchClassPartner").val() + "&status=" + $("#searchClassStatus").val() + "&kindID=" + k + "&project=" + $("#searchClassProject").val() + "&dk=91&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#classCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='classTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='7%'>编号</th>");
			arr.push("<th width='14%'>班级名称</th>");
			arr.push("<th width='8%'>开课日期</th>");
			arr.push("<th width='8%'>结课日期</th>");
			arr.push("<th width='7%'>班主任</th>");
			arr.push("<th width='8%'>开课通知</th>");
			arr.push("<th width='8%'>归档日期</th>");
			arr.push("<th width='6%'>状态</th>");
			arr.push("<th width='6%'>人数</th>");
			arr.push("<th width='6%'>报考</th>");
			arr.push("<th width='6%'>考试</th>");
			arr.push("<th width='6%'>合格/证</th>");
			arr.push("<th width='6%'>通过%</th>");
			arr.push("<th width='6%'>类型</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			var mNew = "";
			var k = "";
			var imgChk = "<img src='images/green_check.png'>";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + ar1[0] + "</td>");
					arr.push("<td class='link1' title='序号：" + ar1[0] + "'><a href='javascript:showClassInfo(" + ar1[0] + ",0,0,1);'>" + (ar1[37]>"" ? "*" : "") + ar1[1] + "</a></td>");  //*合作单位
					arr.push("<td class='left'>" + ar1[17] + (ar1[13]>""?"&nbsp;" + ar1[13]:"") + (ar1[39]==1?"&nbsp;" + ar1[40]:"") + "</td>");
					arr.push("<td class='left'>" + ar1[10].substring(0,10) + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					arr.push("<td class='left'>" + ar1[29] + "</td>");
					arr.push("<td class='left'>" + ar1[23] + "</td>");
					if(ar1[6]==0){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'>" + ar1[7] + "</td>");
					}
					arr.push("<td class='left'>" + ar1[20] + "</td>");
					if(ar1[24] ==0 || ar1[24]==ar1[20]){
						arr.push("<td class='left'>" + nullNoDisp(ar1[24]) + "</td>");
					}else{	//有未报考人员，显示为灰色
						arr.push("<td class='left' style='background-color:#FFFF00;'>" + nullNoDisp(ar1[24]) + "</td>");
					}
					arr.push("<td class='left'>" + nullNoDisp(ar1[25]) + "</td>");
					arr.push("<td class='left' title='合格/发证'" + (ar1[26]>0 && parseInt(ar1[26])>parseInt(ar1[42])?" style='background-color:#FFFF00;'":"") + ">" + nullNoDisp(ar1[26]) + (ar1[26]>0?"/"+ar1[42]:"") + "</td>");
					var x = ar1[20];
					if(x > 0 && ar1[26] > 0){
						x = (ar1[26]*100/ar1[20]).toFixed(2);
					}else{
						x = "";
					}
					arr.push("<td align='right'>" + x + "</td>");
					k = ar1[41];
					if(k=="线下"){
						k = "";
					}
					arr.push("<td class='left'>" + k + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#classCover").html(arr.join(""));
			arr = [];
			$('#classTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100],
				"iDisplayLength": 100,
				"bInfo": true,
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

	
	