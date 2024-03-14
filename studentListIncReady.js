	var studentListLong = 0;		//0: 标准栏目  1：短栏目
	var studentListChk = 0;

	$(document).ready(function (){
		var w = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchStudentHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			getComList("searchStudentProjectID","projectInfo","projectID","projectID","status=1 or status=2 order by ID desc",1);
		}else{
			getComList("searchStudentHost","hostInfo","hostNo","title",w,0);
			getComList("searchStudentProjectID","projectInfo","projectID","projectID","host='" + currHost + "' and status=1 or status=2 order by ID desc",1);
		}
		if(currHost!="spc" && currHost!=""){
			$("#searchStudentKind").prop("disabled",true);
		}
		getDicList("student","searchStudentKind",1);
		getDicList("material","searchStudentMaterial",1);
		$("#searchStudentStartDate").click(function(){WdatePicker();});
		$("#searchStudentEndDate").click(function(){WdatePicker();});
		
		$("#btnSearchStudent").click(function(){
			getStudentList();
		});
		
		$("#btnSearchStudentAdd").click(function(){
			showStudentInfo(0,0,1,1,"student");
		});
		
		$("#txtSearchStudent").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchStudent").val()>""){
					getStudentList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		$("#searchStudentOld").change(function(){
			getStudentList();
		});
		$("#searchStudentPhoto").change(function(){
			getStudentList();
		});
		$("#searchStudentIDcard").change(function(){
			getStudentList();
		});
		
		if(!checkPermission("studentAdd")){
			$("#btnSearchStudentAdd").hide();
		}
		

		//getStudentList();
	});

	function getStudentList(){
		sWhere = $("#txtSearchStudent").val();
		var Old = $("#searchStudentOld").val();
        var mark = 1;
        if(checkRole("saler")){
            mark = 3;
        }
		//var photo = 0;
		//var IDcard = 0;
		//if($("#searchStudentOld").attr("checked")){Old = 1;}
		//if($("#searchStudentPhoto").attr("checked")){photo = 1;}
		//if($("#searchStudentIDcard").attr("checked")){IDcard = 1;}
		//alert((sWhere) + "&kindID=" + $("#searchStudentKind").val() + "&host=" + $("#searchStudentHost").val() + "&Old=" + Old + "&keyID=" + $("#searchStudentMaterial").val() + "&refID=" + $("#searchStudentProjectID").val() + "&fStart=" + $("#searchStudentStartDate").val() + "&fEnd=" + $("#searchStudentEndDate").val());
		//$.get("studentControl.asp?op=getStudentList&where=" + escape(sWhere) + "&kindID=" + $("#searchStudentKind").val() + "&host=" + $("#searchStudentHost").val() + "&Old=" + Old + "&IDcard=" + IDcard + "&photo=" + photo + "&fStart=" + $("#searchStudentStartDate").val() + "&fEnd=" + $("#searchStudentEndDate").val() + "&dk=11&times=" + (new Date().getTime()),function(data){
		$.get("studentControl.asp?op=getStudentList&where=" + escape(sWhere) + "&mark=" + mark + "&kindID=" + $("#searchStudentKind").val() + "&host=" + $("#searchStudentHost").val() + "&Old=" + Old + "&keyID=" + $("#searchStudentMaterial").val() + "&refID=" + $("#searchStudentProjectID").val() + "&fStart=" + $("#searchStudentStartDate").val() + "&fEnd=" + $("#searchStudentEndDate").val() + "&dk=11&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#studentCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='studentTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='10%'>身份证</th>");
			arr.push("<th width='6%'>姓名</th>");
			arr.push("<th width='5%'>性别</th>");
			arr.push("<th width='5%'>年龄</th>");
			if(currHost==""){
				arr.push("<th width='12%'>公司</th>");
				arr.push("<th width='12%'>部门</th>");
			}else{
				arr.push("<th width='12%'>部门</th>");
				arr.push("<th width='10%'>二级部门</th>");
			}
			arr.push("<th width='8%'>电话</th>");
			arr.push("<th width='8%'>学历</th>");
			arr.push("<th width='5%'>状态</th>");
			arr.push("<th width='8%'>注册</th>");
			arr.push("<th width='5%'>报名</th>");
			arr.push("<th width='5%'>资料</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					h = ar1[13];	//公司用户显示部门1名称
					//if(ar1[9]>=55){c = 2;}	//55岁红色
					if(currHost==""){h = ar1[12];}	//系统用户显示公司名称
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(" + ar1[0] + ",\"\",0,1,\"student\");'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2].substr(0,4) + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					if(currHost==""){
						if(ar1[19]=="znxf"){	//非集团客户，显示自己的单位和部门
							arr.push("<td class='left'>" + ar1[17].substr(0,10) + "</td>");
							arr.push("<td class='left'>" + ar1[18].substr(0,10) + "</td>");
						}else{
							arr.push("<td class='left'>" + ar1[12].substr(0,10) + "</td>");
							arr.push("<td class='left'>" + ar1[13].substr(0,10) + "</td>");
						}
					}else{
						arr.push("<td class='left'>" + ar1[13].substr(0,10) + "</td>");
						arr.push("<td class='left'>" + ar1[14].substr(0,10) + "</td>");
					}
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[21] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + nullNoDisp(ar1[20]) + "</td>");
					arr.push("<td class='left'>" + ar1[15] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#studentCover").html(arr.join(""));
			arr = [];
			$('#studentTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
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
	