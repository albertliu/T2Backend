	var studentCourseListLong = 0;		//0: 标准栏目  1：短栏目
	var studentCourseListChk = 0;
	var studentCourseClassStatus = 0;

	$(document).ready(function (){
		var w1 = "status=0 and hostNo='" + currHost + "'";
		var w2 = "status=0 and (kindID=0 or host='" + currHost + "')";
		var w3 = " and deptID=" + currDeptID;
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchStudentCourseHost","hostInfo","hostNo","title","status=0 order by hostName",0);
			$("#searchStudentCourseHost").val("spc");
			//getComList("searchStudentCourseDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentCourseHost").val() + "' and pID=0) and dept_status<9",1);
		}else{
			getComList("searchStudentCourseHost","hostInfo","hostNo","title",w1,0);
			$("#studentCourseListLongItem1").hide();
			/*
			if(currDeptID>0){
				getComList("searchStudentCourseDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentCourseHost").val() + "' and pID=0)" + w3,0);
				getComList("searchStudentCourseClassID","v_classInfo","classID","className","1=1 order by ID desc",1);
			}else{
				getComList("searchStudentCourseDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentCourseHost").val() + "' and pID=0) and dept_status<9",1);
				getComList("searchStudentCourseClassID","v_classInfo","classID","className","1=1 order by ID desc",1);
			}*/
		}
		getDicList("student","searchStudentCourseKind",1);
		getDicList("planStatus","searchStudentCourseStatus",1);
		getDicList("statusCheck","searchStudentCourseChecked",1);
		getDicList("statusSubmit","searchStudentCourseSubmited",1);
		getDicList("statusYes","searchStudentCourseMark",1);
		getDicList("statusAsk","searchStudentCoursePhotoStatus",1);
		$("#searchStudentCourseStartDate").click(function(){WdatePicker();});
		$("#searchStudentCourseEndDate").click(function(){WdatePicker();});
		
		$("#btnSearchStudentCourse").click(function(){
			getStudentCourseList();
		});
		
		$("#txtSearchStudentCourse").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchStudentCourse").val()>""){
					getStudentCourseList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		$("#btnStudentCourseSel").click(function(){
			setSel("visitstockchkCourse");
		});
		
		$("#btnStudentCourseBadPhoto").click(function(){
			getSelCart("visitstockchkCoursePhoto");
			if(selCount==0){
				jAlert("请选择要通知重新上传图片的名单。");
				return false;
			}
			jConfirm("确定通知将这些(" + selCount + "个)图片重新上传吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					//$.get("studentCourseControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
					$.getJSON(uploadURL + "/public/resubmit_student_materials", {status: 1, selList: selList, registerID: currUser} ,function(data){
						//jAlert(data);
						if(data["status"]==0){
							getStudentCourseList();
						}
						jAlert(data["msg"]);
					});
				}
			});
		});
		
		$("#btnStudentCourseGoodPhoto").click(function(){
			getSelCart("visitstockchkCoursePhoto");
			if(selCount==0){
				jAlert("请选择要确认图片的名单。");
				return false;
			}
			jConfirm("确定接受这些(" + selCount + "个)图片吗？","确认",function(r){
				if(r){
					$.getJSON(uploadURL + "/public/resubmit_student_materials", {status: 3, selList: selList, registerID: currUser} ,function(data){
						//jAlert(data);
						if(data["status"]==0){
							getStudentCourseList();
						}
						jAlert(data["msg"]);
					});
				}
			});
		});
		
		$("#searchStudentCourseHost").change(function(){
			//alert($("#searchStudentCourseHost").val());
			setHostChange();
		});
		
		$("#searchStudentCourseDept").change(function(){
			setClassList();
		});
		
		$("#searchStudentCourseCertID").change(function(){
			setClassList();
		});
		
		$("#searchStudentCourseClassID").change(function(){
			if($("#searchStudentCourseClassID").val() > ""){
				setStudentCourseItem();
				getStudentCourseList();
			}
		});

		//$("#studentCourseListLongItem3").hide();
		$("#studentCourseListLongItem4").hide();
		$("#studentCourseListLongItem5").hide();
		
		$("#btnStudentCourseCheck").click(function(){
			getSelCart("visitstockchkCourse");
			if($("#searchStudentCourseClassID").val() == ""){
				jAlert("请选择一个班级。");
				return false;
			}
			if(selCount==0){
				jAlert("请选择要确认的名单。");
				return false;
			}
			jConfirm("确定要确认这些(" + selCount + "个)人的报名吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList);
					//alert($("#searchStudentCourseHost").val() + "&keyID=" + selList);
					$.get("studentCourseControl.asp?op=doStudentCourse_check&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList + "&refID=" + $("#searchStudentCourseClassID").val(), function(data){
						//alert(data);
						if(data=="0"){
							jAlert("确认成功");
							getStudentCourseList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		
		$("#btnStudentCourseRefuse").click(function(){
			getSelCart("visitstockchkCourse");
			if($("#searchStudentCourseClassID").val() == ""){
				jAlert("请选择一个班级。");
				return false;
			}
			if(selCount==0){
				jAlert("请选择剔除的名单。");
				return false;
			}
			jConfirm("确定要里剔除这些(" + selCount + "个)人吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					//jAlert(selList);
					$.get("studentCourseControl.asp?op=doStudentCourse_check&status=2&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList + "&refID=" + $("#searchStudentCourseClassID").val() ,function(data){
						//jAlert(data);
						if(data=="0"){
							jAlert("剔除成功");
							getStudentCourseList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		
		$("#btnStudentCourseCall").click(function(){
			getSelCart("visitstockchkCourse");
			if(selCount==0){
				jAlert("请选择要通知的名单。");
				return false;
			}
			jConfirm("确定要通知这些(" + selCount + "个)人参加培训吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					$.post(uploadURL + "/public/send_message_class", {batchID: $("#searchStudentCourseClassID").val(), selList: selList, SMS:1, registerID: currUser} ,function(data){
						jAlert("发送成功。");
					});
				}
			});
		});
		
		$("#btnStudentCourseError").click(function(){
			if($("#searchStudentCourseClassID").val() == ""){
				jAlert("请选择一个班级。");
				return false;
			}
			$.get("studentCourseControl.asp?op=getStudentListByClassCheck&refID=" + $("#searchStudentCourseClassID").val() + "&host=" + $("#searchStudentCourseHost").val(),function(data){
				var ar = new Array();
				ar = (unescape(data)).split("%%");
				if(ar > ""){
					var s = "";
					$.each(ar,function(iNum,val){
						var ar1 = new Array();
						ar1 = val.split("|");
						s += "<a style='color:red;'>[" + ar1[2].substring(0,ar1[2].length-ar1[2].indexOf('2')) + "]</a>&nbsp;&nbsp;" + ar1[1] + "&nbsp;&nbsp;" + ar1[0] + "&nbsp;&nbsp;\n";
					});
					jAlert("以下人员可能应该报其他课程，请核实：<hr />" + s);
				}else{
					jAlert("该班级名单未发现可疑情况。");
				}
			});
		});

		setHostChange();
	});

	function getStudentCourseList(){
		sWhere = $("#txtSearchStudentCourse").val();
		if($("#searchStudentCourseClassID").val() == ""){
			//jAlert("请选择一个班级。");
			return false;
		}
		//if($("#searchStudentCourseOld").attr("checked")){Old = 1;}
		//alert($("#searchStudentCourseDept").val() + "&refID=" + $("#searchStudentCourseProjectID").val() + "&status=" + $("#searchStudentCourseStatus").val() + "&courseID=" + $("#searchStudentCourseID").val() + "&host=" + $("#searchStudentCourseHost").val());
		$.get("studentCourseControl.asp?op=getStudentListByClass&where=" + escape(sWhere) + "&refID=" + $("#searchStudentCourseClassID").val() + "&host=" + $("#searchStudentCourseHost").val() + "&kindID=" + $("#searchStudentCourseMark").val() + "&checked=" + $("#searchStudentCourseChecked").val() + "&submited=" + $("#searchStudentCourseSubmited").val() + "&fStart=" + $("#searchStudentCourseStartDate").val() + "&fEnd=" + $("#searchStudentCourseEndDate").val() + "&dk=13&times=" + (new Date().getTime()),function(data){
		//$.getJSON("studentCourseControl.asp?op=getStudentCourseList",function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#studentCourseCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='studentCourseTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='6%'>序号</th>");
			arr.push("<th width='12%'>身份证</th>");
			arr.push("<th width='8%'>姓名</th>");
			arr.push("<th width='8%'>学号</th>");
			arr.push("<th width='10%'>部门</th>");
			arr.push("<th width='10%'>电话</th>");
			arr.push("<th width='8%'>岗位</th>");
			arr.push("<th width='8%'>备注</th>");
			arr.push("<th width='13%'>确认</th>");
			arr.push("<th width='9%'>报到日期</th>");
			arr.push("<th width='3%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk1 = "<img src='images/green_check.png'>";
				var imgChk2 = "<img src='images/cancel.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 1;
					if(ar1[7]==0){
						c = 0;
						if(ar1[15]==0){
							c = 2;
						}
					}
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + ar1[0] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[1] + "\",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[14] + "</td>");
					arr.push("<td class='left'>" + ar1[20] + ar1[22] + "</td>");
					arr.push("<td class='center'>" + ar1[16] + "</td>");
					//if(ar1[15]==0 && ar1[23] > 0){
						arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[1] + "' name='visitstockchkCourse'>" + "</td>");
					//}else{
						//arr.push("<td class='center'>&nbsp;</td>");
					//}
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
			$("#studentCourseCover").html(arr.join(""));
			arr = [];
			$('#studentCourseTab').dataTable({
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

	function setStudentCourseItem(){
		if($("#searchStudentCourseClassID").val()>""){
			$.get("classControl.asp?op=getStatus&refID=" + $("#searchStudentCourseClassID").val() ,function(data){
				studentCourseClassStatus = data;
			});
			if(checkPermission("studentCourseCheck") && studentCourseClassStatus<2){
				$("#studentCourseListLongItem5").show();
			}else{
				$("#studentCourseListLongItem5").hide();
			}
		}else{
			$("#studentCourseListLongItem5").hide();
		}
		getStudentCourseList();
	}

	function setHostChange(){
		//alert($("#searchStudentCourseHost").val());
		getComList("searchStudentCourseCertID","dbo.getCertListByHost('" + $("#searchStudentCourseHost").val() + "')","certID","shortName","1=1 order by certID",1);
		if(currDeptID>0){
			getComList("searchStudentCourseDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentCourseHost").val() + "' and pID=0) and deptID=" + currDeptID,0);
		}else{
			getComList("searchStudentCourseDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentCourseHost").val() + "' and pID=0) and kindID=0 and dept_status<9",1);
		}
		setClassList();
}

	function setClassList(){
		//alert($("#searchStudentCourseHost").val() + "','" + $("#searchStudentCourseDept").val() + "','" + $("#searchStudentCourseCertID").val());
		getComList("searchStudentCourseClassID","[dbo].[getClassListByDept]('" + $("#searchStudentCourseHost").val() + "','" + $("#searchStudentCourseDept").val() + "','" + $("#searchStudentCourseCertID").val() + "')","classID","className","1=1 order by classID desc",1);
	}
	