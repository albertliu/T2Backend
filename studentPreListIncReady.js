	var studentPreListLong = 0;		//0: 标准栏目  1：短栏目
	var studentPreListChk = 0;
	var studentPreProjectStatus = 0;

	$(document).ready(function (){
		var w11 = "status=0 and hostNo='" + currHost + "'";
		var w12 = "status=0 and (kindID=0 or host='" + currHost + "')";
		var w13 = " and deptID=" + currDeptID;
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchStudentPreHost","hostInfo","hostNo","title","status=0 order by hostName",0);
			$("#searchStudentPreHost").val("spc");
			//getComList("searchStudentPreDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentPreHost").val() + "' and pID=0) and dept_status<9",1);
		}else{
			getComList("searchStudentPreHost","hostInfo","hostNo","title",w11,0);
			$("#studentPreListLongItem1").hide();
			/*
			if(currDeptID>0){
				getComList("searchStudentPreDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentPreHost").val() + "' and pID=0)" + w3,0);
				getComList("searchStudentPreProjectID","v_classInfo","classID","className","1=1 order by ID desc",1);
			}else{
				getComList("searchStudentPreDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentPreHost").val() + "' and pID=0) and dept_status<9",1);
				getComList("searchStudentPreProjectID","v_classInfo","classID","className","1=1 order by ID desc",1);
			}*/
		}
		getDicList("student","searchStudentPreKind",1);
		getDicList("planStatus","searchStudentPreStatus",1);
		getDicList("statusCheck","searchStudentPreChecked",1);
		getDicList("statusSubmit","searchStudentPreSubmited",1);
		getDicList("statusAsk","searchStudentPrePhotoStatus",1);
		getDicList("statusYes","searchStudentPreClass",1);
		$("#searchStudentPreStartDate").click(function(){WdatePicker();});
		$("#searchStudentPreEndDate").click(function(){WdatePicker();});
		$("#searchStudentPreStartDate").val(addDays(currDate,-30));

		if(currHost==""){
			$("#searchStudentPreChecked").val(1);	//学校默认看已确认的，未编班的人
			$("#btnStudentPreExpress").hide();	//加急是石化公司的权限
		}else{
			$("#searchStudentPreChecked").val(0);	//石化公司默认看未确认的人
		}

		$("#btnSearchStudentPre").click(function(){
			getStudentPreList();
		});
		
		$("#txtSearchStudentPre").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchStudentPre").val()>""){
					getStudentPreList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		$("#btnStudentPreSel").click(function(){
			setSel("visitstockchkPre");
		});
		
		$("#btnStudentPreBadPhoto").click(function(){
			getSelCart("visitstockchkPrePhoto");
			if(selCount==0){
				jAlert("请选择要通知重新上传图片的名单。");
				return false;
			}
			jConfirm("确定通知将这些(" + selCount + "个)图片重新上传吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentPreProjectID").val() + "&status=1&host=" + $("#searchStudentPreHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					//$.get("studentCourseControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
					$.getJSON(uploadURL + "/public/resubmit_student_materials", {status: 1, selList: selList, registerID: currUser} ,function(data){
						//jAlert(data);
						if(data["status"]==0){
							getStudentPreList();
						}
						jAlert(data["msg"]);
					});
				}
			});
		});
		
		$("#btnStudentPreGoodPhoto").click(function(){
			getSelCart("visitstockchkPrePhoto");
			if(selCount==0){
				jAlert("请选择要确认图片的名单。");
				return false;
			}
			jConfirm("确定接受这些(" + selCount + "个)图片吗？","确认",function(r){
				if(r){
					$.getJSON(uploadURL + "/public/resubmit_student_materials", {status: 3, selList: selList, registerID: currUser} ,function(data){
						//jAlert(data);
						if(data["status"]==0){
							getStudentPreList();
						}
						jAlert(data["msg"]);
					});
				}
			});
		});
		
		$("#searchStudentPreHost").change(function(){
			setHostPreChange();
		});
		
		$("#searchStudentPreDept").change(function(){
			setProjectList();
		});
		
		$("#searchStudentPreCertID").change(function(){
			setProjectList();
		});
		
		$("#searchStudentPreActive").change(function(){
			setProjectList();
		});
		
		$("#searchStudentPreProjectID").change(function(){
			if($("#searchStudentPreProjectID").val() > ""){
				setStudentPreItem();
				getStudentPreList();
			}
		});

		//$("#studentPreListLongItem3").hide();
		$("#studentPreListLongItem4").hide();
		$("#studentPreListLongItem5").hide();
		
		$("#btnStudentPreCheck").click(function(){
			getSelCart("visitstockchkPre");
			if($("#searchStudentPreProjectID").val() == ""){
				jAlert("请选择一个批次。");
				return false;
			}
			if(selCount==0){
				jAlert("请选择要确认的名单。");
				return false;
			}
			jConfirm("确定要确认这些(" + selCount + "个)人的报名吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentPreProjectID").val() + "&status=1&host=" + $("#searchStudentPreHost").val() + "&keyID=" + selList);
					//alert($("#searchStudentPreHost").val() + "&keyID=" + selList);
					$.get("studentCourseControl.asp?op=doStudentPre_check&status=1&host=" + $("#searchStudentPreHost").val() + "&keyID=" + selList, function(data){
						//alert(data);
						if(data=="0"){
							jAlert("确认成功");
							getStudentPreList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		
		$("#btnStudentPreRefuse").click(function(){
			getSelCart("visitstockchkPre");
			if($("#searchStudentPreProjectID").val() == ""){
				jAlert("请选择一个批次。");
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
					$.get("studentCourseControl.asp?op=doStudentPre_check&status=2&host=" + $("#searchStudentPreHost").val() + "&keyID=" + selList + "&refID=" + $("#searchStudentPreProjectID").val() ,function(data){
						//jAlert(data);
						if(data=="0"){
							jAlert("剔除成功");
							getStudentPreList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		
		$("#btnStudentPreCall").click(function(){
			getSelCart("visitstockchkPre");
			if(selCount==0){
				jAlert("请选择要通知的学员名单。");
				return false;
			}
			jConfirm("确定要通知这些(" + selCount + "个)人参加培训吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentPreProjectID").val() + "&status=1&host=" + $("#searchStudentPreHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					$.post(uploadURL + "/public/send_message_class", {batchID: $("#searchStudentPreProjectID").val(), selList: selList, SMS:1, registerID: currUser} ,function(data){
						jAlert("发送成功。");
					});
				}
			});
		});
		
		$("#btnStudentPreExpress").click(function(){
			getSelCart("visitstockchkPre");
			if(selCount==0){
				jAlert("请选择要标记的学员名单。");
				return false;
			}
			jConfirm("确定要将这些(" + selCount + "个)人标记为加急吗？","确认",function(r){
				if(r){
					$.post("studentCourseControl.asp?op=set_students_express", {selList: selList} ,function(data){
						alert(data);
						if(data>0){
							jAlert("标记完成。");
							getStudentPreList();
						}else{
							jAlert("操作失败，没有符合要求的学员。");
						}
					});
				}
			});
		});
		
		$("#btnStudentPreClass").click(function(){
			if($("#searchStudentPreProjectID").val() == ""){
				jAlert("请选择一个批次。");
				return false;
			}
			getSelCart("visitstockchkPre");
			if(selCount==0){
				jAlert("请选择要编班的学员名单。");
				return false;
			}
			//jPrompt("请输入班级编号：", "", "目标班级",function(d){
			$.get("classControl.asp?op=getClassListByProject&refID=" + $("#searchStudentPreProjectID").val(),function(data){
				//alert(unescape(data));
				var ar = $.parseJSON(unescape(data));
				jSelect("请输入班级编号：", ar, "目标班级",function(d){
					d = d.replace(/\s*/g,"");
					if(d > ""){
						//alert($("#searchStudentPreProjectID").val() + "&status=1&host=" + $("#searchStudentPreHost").val() + "&keyID=" + selList);
						//jAlert(selList);
						$.post("studentCourseControl.asp?op=pick_students4class", {batchID: d, selList: selList} ,function(data){
							//alert(data);
							if(data>0){
								jAlert("成功将" + data + "个学员编入班级。");
								getStudentPreList();
							}else{
								jAlert("操作失败，没有符合要求的学员。");
							}
						});
					}else{
						jAlert("班级编号不能为空。");
					}
				});
			});
		});
		
		$("#btnStudentPreError").click(function(){
			if($("#searchStudentPreProjectID").val() == ""){
				jAlert("请选择一个批次。");
				return false;
			}
			$.get("studentCourseControl.asp?op=getStudentListByProjectCheck&refID=" + $("#searchStudentPreProjectID").val() + "&host=" + $("#searchStudentPreHost").val(),function(data){
				var ar = new Array();
				ar = (unescape(data)).split("%%");
				if(ar > ""){
					var s = "";
					$.each(ar,function(iNum,val){
						var ar1 = new Array();
						ar1 = val.split("|");
						s += "<a style='color:red;'>[" + ar1[2].substring(0,ar1[2].length-ar1[2].indexOf('2')) + "]</a>&nbsp;&nbsp;" + ar1[1] + "&nbsp;&nbsp;" + ar1[0] + "\n&nbsp;&nbsp;";
					});
					jAlert("以下人员同时报名的课程有冲突，请核实：<hr />" + s);
				}else{
					jAlert("该批次名单未发现可疑情况。");
				}
			});
		});

		setHostPreChange();
		$("#btnStudentPreCall").hide();
		$("#searchStudentPreClass").val(1);
		if(!checkPermission("classAdd")){
			$("#btnStudentPreClass").hide();
		}
		if(currHost=="spc"){
			//getStudentPreList();
		}
	});

	function getStudentPreList(){
		sWhere = $("#txtSearchStudentPre").val();
		if($("#searchStudentPreProjectID").val() == ""){
			jAlert("请选择一个批次。");
			return false;
		}
		//if($("#searchStudentPreOld").attr("checked")){Old = 1;}
		//alert($("#searchStudentPreDept").val() + "&refID=" + $("#searchStudentPreProjectID").val() + "&status=" + $("#searchStudentPreStatus").val() + "&courseID=" + $("#searchStudentPreID").val() + "&host=" + $("#searchStudentPreHost").val());
		$.get("studentCourseControl.asp?op=getStudentListByProject&where=" + escape(sWhere) + "&refID=" + $("#searchStudentPreProjectID").val() + "&keyID=" + $("#searchStudentPreDept").val() + "&host=" + $("#searchStudentPreHost").val() + "&kindID=" + $("#searchStudentPreMark").val() + "&checked=" + $("#searchStudentPreChecked").val() + "&submited=" + $("#searchStudentPreSubmited").val() + "&class=" + $("#searchStudentPreClass").val() + "&fStart=" + $("#searchStudentPreStartDate").val() + "&fEnd=" + $("#searchStudentPreEndDate").val() + "&dk=130&times=" + (new Date().getTime()),function(data){
		//$.getJSON("studentCourseControl.asp?op=getStudentPreList",function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#studentPreCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='studentPreTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'></th>");
			arr.push("<th width='9%'>身份证</th>");
			arr.push("<th width='7%'>姓名</th>");
			//arr.push("<th width='6%'>别</th>");
			arr.push("<th width='4%'>单位</th>");
			arr.push("<th width='9%'>部门</th>");
			arr.push("<th width='6%'>电话</th>");
			arr.push("<th width='7%'>岗位</th>");
			//arr.push("<th width='7%'>备注</th>");
			arr.push("<th width='11%'>确认</th>");
			arr.push("<th width='7%'>班级</th>");
			arr.push("<th width='7%'>练习</th>");
			arr.push("<th width='6%'>进度%</th>");
			arr.push("<th width='6%'>成绩</th>");
			arr.push("<th width='6%'>准考</th>");
			arr.push("<th width='6%'>补考</th>");
			arr.push("<th width='6%'>证书</th>");
			arr.push("<th width='3%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var s = "";
				var imgChk1 = "<img src='images/green_check.png'>";
				var imgChk2 = "<img src='images/cancel.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					if(ar1[19]==0){
						c = 3;
					}
					if(ar1[19]==2){
						c = 2;
					}
					if(ar1[15]==1){
						c = 4;
					}
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'" + (ar1[31]==1? " style='background-color:yellow;'":"") + "><a href='javascript:showEnterInfo(" + ar1[0] + ",\"" + ar1[1] + "\",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[1] + "\",0,1);'>" + ar1[2] + "</a></td>");
					//arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='center' title='" + ar1[10] + "'>" + ar1[10].substring(0,2) + "</td>");
					arr.push("<td class='left' title='" + (ar1[8] || ar1[10] || ar1[30]) + "'>" + (ar1[8] || ar1[10] || ar1[30]).substring(0,6) + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					//arr.push("<td class='left'>" + ar1[14] + "</td>");
					arr.push("<td class='left' title='" + ar1[22] + "'>" + ar1[20] + ar1[22].substring(0,2) + "</td>");
					arr.push("<td class='center'>" + ar1[13] + "</td>");
					s = "";
					if(ar1[27]>0){
						s = nullNoDisp(ar1[7]) + " * " + nullNoDisp(ar1[27]);
					}
					arr.push("<td class='right'>" + s + "</td>");
					var j = ar1[29];
					if(j>0){
						j = j;
					}else{
						j = "";
					}
					arr.push("<td class='center'>" + j + "</td>");	//学习进度
					arr.push("<td class='center'>" + nullNoDisp(ar1[11].replace(".00","")) + "</td>");
					if(ar1[28]>0){
						arr.push("<td class='center'>" + imgChk1 + "</td>");	//准考证
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					arr.push("<td class='center'>" + nullNoDisp(ar1[26]) + "</td>");
					if(ar1[23]>0){
						arr.push("<td class='center'>" + imgChk1 + "</td>");	//证书
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					//if(ar1[15]==0 && ar1[23] > 0){
						arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkPre'>" + "</td>");
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
			//arr.push("<th>&nbsp;</th>");
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
			$("#studentPreCover").html(arr.join(""));
			arr = [];
			$('#studentPreTab').dataTable({
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

	function setStudentPreItem(){
		if($("#searchStudentPreProjectID").val()>""){
			$.get("projectControl.asp?op=getStatus&refID=" + $("#searchStudentPreProjectID").val() ,function(data){
				studentPreProjectStatus = data;
			});
			//if(checkPermission("studentCourseCheck") && studentPreProjectStatus<2){
			if(checkPermission("studentCourseCheck")){
				$("#studentPreListLongItem5").show();
			}else{
				$("#studentPreListLongItem5").hide();
			}
		}else{
			$("#studentPreListLongItem5").hide();
		}
		getStudentPreList();
	}

	function setHostPreChange(){
		//alert($("#searchStudentPreHost").val());
		getComList("searchStudentPreCertID","dbo.getCertListByHost('" + $("#searchStudentPreHost").val() + "')","certID","shortName","1=1 order by certID",1);
		if(currDeptID>0){
			getComList("searchStudentPreDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentPreHost").val() + "' and pID=0) and deptID=" + currDeptID,0);
		}else{
			getComList("searchStudentPreDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentPreHost").val() + "' and pID=0) and kindID=0 and dept_status<9",1);
		}
		setProjectList();
	}

	function setProjectList(){
		var x = "";
		if($("#searchStudentPreActive").prop("checked")){
			x = " and status=1"
		}
		getComList("searchStudentPreProjectID","[dbo].[getProjectListByDept]('" + $("#searchStudentPreHost").val() + "','" + $("#searchStudentPreDept").val() + "','" + $("#searchStudentPreCertID").val() + "')","projectID","projectName","1=1" + x + " order by projectID desc",1);
	}
	