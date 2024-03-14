<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var op = 0;
	var fn = "";
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//
		refID = "<%=refID%>";		//
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		getComList("certID","certificateInfo","certID","shortName","status=0 and type=0 and agencyID=4 order by certID",1);
		getDicList("examResult","s_status",1);
		getDicList("statusNo","s_resit",1);
		getDicList("online","kindID",0);
		getDicList("statusNo","sync",0);
		$("#startDate").click(function(){WdatePicker({dateFmt:'yyyy-MM-dd HH:mm', onpicked:pickerChange});});
		$("#startTime").click(function(){WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'});});
		setButton();
		if(nodeID>0 && op==0){
			getNodeInfo(nodeID);
		}

		$("#sendMsgExam").click(function(){
			jConfirm("确定向这批考生发送考试通知吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.getJSON(uploadURL + "/public/send_message_exam?SMS=1&batchID=" + nodeID + "&registerID=" + currUser ,function(data){
						if(data>""){
							jAlert("通知发送成功。");
							getNodeInfo(nodeID);
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});

		$("#sendMsgScore").click(function(){
			jConfirm("确定向这批考生发送成绩单吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.getJSON(uploadURL + "/public/send_message_score?SMS=1&batchID=" + nodeID + "&registerID=" + currUser ,function(data){
						if(data>""){
							jAlert("通知发送成功。");
							getNodeInfo(nodeID);
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});

		$("#save").click(function(){
			saveNode();
		});

		$("#del").click(function(){
			if($("#qty").val()>0){
				jAlert("该场次还有考生，请将其清空后再删除。");
				return false;
			}
			jConfirm('你确定要删除考试信息吗?', '确认对话框', function(r) {
				if(r){
					$.get("diplomaControl.asp?op=delGeneratePasscard&nodeID=" + nodeID + "&&times=" + (new Date().getTime()),function(data){
						jAlert("成功删除！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});
		$("#close").click(function(){
			if(confirm('确定要结束本场考试吗?')){
				$.get("diplomaControl.asp?op=closeGeneratePasscard&nodeID=" + $("#ID").val() + "&refID=2&times=" + (new Date().getTime()),function(data){
					jAlert("已关闭考试","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#lock").click(function(){
			if(confirm('确定要锁定本场考试吗? 将无法调整考生名单。')){
				$.get("diplomaControl.asp?op=closeGeneratePasscard&nodeID=" + $("#ID").val() + "&refID=1&times=" + (new Date().getTime()),function(data){
					jAlert("已锁定考试","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#open").click(function(){
			if(confirm('确定要重新开启本场考试吗? 如果有人员调整，请注意重新生成数据。')){
				$.get("diplomaControl.asp?op=closeGeneratePasscard&nodeID=" + $("#ID").val() + "&refID=0&times=" + (new Date().getTime()),function(data){
					jAlert("已重新开启考试，请及时关闭或锁定。","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#btnRemove").click(function(){
			getSelCart("");
			if(selCount==0){
				jAlert("请选择要移除的人员。");
				return false;
			}
			jConfirm('确定要将这' + selCount + '个人从本场考试移除吗?', "确认对话框",function(r){
				if(r){
					$.post("diplomaControl.asp?op=remove4GeneratePasscard&nodeID=0", {"selList":selList},function(data){
						//jAlert(data);
						jAlert("已成功移除","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			});
		});
		$("#doPasscard").click(function(){
			doPasscard();
		});
		$("#list").click(function(){
			outputExcelBySQL('x01','file',nodeID,0,0);
		});
		$("#sign").click(function(){
			outputExcelBySQL('x02','file',nodeID,0,0);
		});
		$("#score").click(function(){
			outputExcelBySQL('x03','file',nodeID,0,0);
		});
		$("#certID").change(function(){
			pickerChange();
		});
		$("#startDate").blur(function(){
			pickerChange();
		});
		$("#kindID").change(function(){
            //alert($("#certID").val() + ":" + $("#kindID").val());
            $.get("diplomaControl.asp?op=getLastExamAddress&refID=" + $("#certID").val() + "&kindID=" + $("#kindID").val() + "&times=" + (new Date().getTime()),function(re){
                //alert(unescape(re));
                var ar = new Array();
                ar = unescape(re).split("|");
                if(ar > ""){
                    $("#address").val(ar[0]);
                    $("#notes").val(ar[1]);
                }
            });
            if($("#photo").html()>""){
                jAlert("如果改变考试类型，请重新生成准考证。");
            }
		});
		$("#needResit").change(function(){
			getPasscardList();
		});
		$("#btnSearch").click(function(){
			getPasscardList();
		});
		$("#examStatus").click(function(){
            if($("#closeDate").val()==""){
                $("#examClose").show();
            }
			getPasscardExamList();
		});
		$("#examClose").click(function(){
			jConfirm('确定要收卷吗? 收卷后所有考生将强制交卷。', "确认对话框",function(r){
				if(r){
					$.get("diplomaControl.asp?op=closeExam&nodeID=" + nodeID,function(data){
						//jAlert(data);
						jAlert("已成功收卷","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
                        getPasscardExamList();
					});
				}
			});
		});

		$("#btnSel").click(function(){
			setSel("");
		});
		
		$("#btnResit").click(function(){
			if($("#status").val()==0){
				jAlert("请先结束考试，再安排补考。");
				return false;
			}
			getSelCart("");
			if(selCount==0){
				jAlert("请选择要加入购物车的人员。");
				return false;
			}
			jConfirm('确定要安排这' + selCount + '个人补考吗?', "确认对话框",function(r){
				if(r){
					add2Cart("","examer","*补考*");
					updateCount += 1;
				}
			});
		});
		$("#doImportScore").click(function(){
			showLoadFile("score_list",$("#ID").val(),"studentList",'');
			updateCount += 1;
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("diplomaControl.asp?op=getGeneratePasscardNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID1").html("&nbsp;&nbsp;&nbsp;" + ar[0] + "&nbsp;&nbsp;&nbsp;");
				$("#ID").val(ar[0]);
				$("#certID").val(ar[1]);
				//$("#className").val(ar[2]);
				$("#title").val(ar[3]);
				$("#qty").val(ar[4]);
				$("#startTime").val(ar[5]);
				$("#address").val(ar[6]);
				$("#notes").val(ar[7]);
				$("#startDate").val(ar[8]);
				//$("#filename").val(ar[9]);
				fn = ar[9];
				$("#memo").val(ar[10]);
				$("#regDate").val(ar[11]);
				$("#registerName").val(ar[12]);
				$("#startNo").val(ar[13]);
				$("#send").val(ar[14]);
				$("#sendDate").val(ar[15]);
				$("#senderName").val(ar[16]);
				$("#sendScore").val(ar[20]);
				$("#sendScoreDate").val(ar[21]);
				$("#senderScoreName").val(ar[22]);
				$("#status").val(ar[17]);
				$("#statusName").val(ar[18]);
				$("#kindID").val(ar[26]);
				$("#closeDate").val(ar[28]);
				$("#minutes").val(ar[29]);
				$("#scorePass").val(ar[30]);
				$("#sync").val(ar[31]);
				$("#sendMsgExam").hide();
				$("#sendMsgScore").hide();
				var c = "";
				if(ar[9] > ""){
					c += "<a href='/users" + ar[9] + "' target='_blank'>准考证</a>";
					$("#list").html("<a href=''>考站数据</a>");
					$("#sign").html("<a href=''>签到表</a>");
					$("#score").html("<a href=''>评分表</a>");
					if(ar[19] > ""){
						$("#scoreResult").html("<a href='/users" + ar[19] + "' target='_blank'>成绩单</a>");
					}
					if(checkPermission("studentAdd") && ar[17]==1){
						$("#sendMsgExam").show();
						$("#sendMsgScore").show();
					}
				}
				$("#photo").html(c);
				//getDownloadFile("generateDiplomaID");
				nodeID = ar[0];
				setButton();
				getPasscardList();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function doPasscard(){
		if($("#title").val()==""){
			jAlert("请填写标题。");
			return false;
		}
		if($("#startDate").val()==""){
			jAlert("请填写考试日期。");
			return false;
		}
		if($("#startTime").val()==""){
			jAlert("请填写考试时间。");
			return false;
		}
		if($("#startNo").val()=="" || $("#startNo").val()<1 || $("#startNo").val()>1000){
			jAlert("请检查起始编号值。");
			return false;
		}
		var s = "确定要制作准考证吗?";
		if(fn > ""){
			s = "要重新制作准考证吗？请随后下载新的考站数据、签到表。";
		}

		jConfirm('确定要制作准考证吗?', '确认对话框', function(r) {
			if(r){
				//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
				$.getJSON(uploadURL + "/outfiles/generate_passcard_byExamID?mark=0&ID=" + nodeID + "&username=" + currUser ,function(data){
					if(data>""){
						jAlert("准考证制作成功");
						op = 0;
						updateCount = 1;
						nodeID = data;
						getNodeInfo(data);
					}else{
						jAlert("没有可供处理的数据。");
					}
				});
			}
		});
		return false;
	}
	
	function saveNode(){
		if($("#title").val()==""){
			jAlert("请填写标题。");
			return false;
		}
		if($("#startDate").val()==""){
			jAlert("请填写考试时间。");
			return false;
		}
		
		if($("#kindID").val()==1 && $("#startTime").val()==""){
			jAlert("请填写截止时间。");
			return false;
		}
		
		if($("#certID").val()==""){
			alert(1);
			jAlert("请选择考试科目。");
			return false;
		}
		/*if(checkNumber($("#startTime").val())==false){
			jAlert("请正确填写考试时长。");
			return false;
		}*/
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("diplomaControl.asp?op=updateGeneratePasscardInfo&nodeID=" + nodeID + "&refID=" + $("#certID").val() + "&sync=" + $("#sync").val() + "&kindID=" + $("#kindID").val() + "&keyID=" + $("#startNo").val() + "&startDate=" + $("#startDate").val() + "&startTime=" + $("#startTime").val() + "&item=" + escape($("#title").val()) + "&address=" + escape($("#address").val()) + "&notes=" + escape($("#notes").val()) + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			if(re>0){
				jAlert("保存成功");
				op = 0;
				updateCount = 1;
				getNodeInfo(re);
				nodeID = re;
			}else{
				jAlert("没有可供处理的数据。");
			}
		});
		return false;
	}

	function getPasscardList(){
		var need = 0;
		if($("#needResit").attr("checked")){ need = 1;}
		$.get("diplomaControl.asp?op=getPasscardListByExam&refID=" + nodeID + "&status=" + $("#s_status").val() + "&keyID=" + $("#s_resit").val() + "&needResit=" + need + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='10%'>身份证</th>");
			arr.push("<th width='8%'>姓名</th>");
			arr.push("<th width='7%'>准考证</th>");
			arr.push("<th width='13%'>单位</th>");
			arr.push("<th width='8%'>电话</th>");
			arr.push("<th width='7%'>成绩</th>");
			arr.push("<th width='7%'>结果</th>");
			arr.push("<th width='7%'>证书</th>");
			arr.push("<th width='12%'>备注</th>");
			arr.push("<th width='7%'>补考</th>");
			arr.push("<th width='8%'>学号</th>");
			arr.push("<th width='2%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var k = 0;
				var s = $("#status").val();
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(\"" + ar1[2] + "\",0,0,1);'>" + ar1[4] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[4] + "\",0,1);'>" + ar1[5] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[14] + ar1[15].substring(0,2) + "." + ar1[16] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'><a href='javascript:showStudentExamPaper(" + ar1[2] + ",\"" + ar1[5] + "\");'>" + ar1[7] + "</a></td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					if(ar1[19]>""){
						arr.push("<td class='center'>" + imgChk + "</td>");	//证书
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					arr.push("<td class='left' title='" + ar1[17] + "'>" + ar1[17].substring(0,8) + "</td>");
					if(ar1[8]>0){
						arr.push("<td class='center'>" + imgChk + "</td>");	//补考
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					if(s==0){
						k = ar1[0];
					}else{
						k = ar1[2];
					}
					arr.push("<td class='left'>" + ar1[18] + "</td>");
					arr.push("<td class='left'><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + k + "' name='visitstockchk'></td>");
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
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}

	function getPasscardExamList(){
		$.get("diplomaControl.asp?op=getPasscardExamList&refID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='13%'>身份证</th>");
			arr.push("<th width='8%'>姓名</th>");
			arr.push("<th width='11%'>电话</th>");
			arr.push("<th width='8%'>成绩</th>");
			arr.push("<th width='8%'>状态</th>");
			arr.push("<th width='12%'>开始时间</th>");
			arr.push("<th width='10%'>剩余时间</th>");
			arr.push("<th width='12%'>交卷时间</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var k = 0;
				var s = $("#status").val();
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					k = ar1[4];
					if(ar1[5]==0){
						k = "";	//缺考的不显示成绩
					}
					arr.push("<td class='left'><a href='javascript:showStudentExamPaper(" + ar1[14] + ",\"" + ar1[2] + "\");'>" + k + "</a></td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
                    h = "";
                    if(ar1[5]==1){
                        h = ar1[9] + "分钟";
                    }
					arr.push("<td class='left'>" + h + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}
	
	function pickerChange(){
		if($("#startDate").val()>""){
			$("#startTime").val(new Date($("#startDate").val()).dateAdd("n",90).format("yyyy-MM-dd hh:mm"));
			var c = $("#certID").find("option:selected").text();
			if(c > ""){
				$("#title").val(c + $("#startDate").val());
			}
		}
	}

	function setButton(){
		var s = $("#status").val();
		$("#save").hide();
		$("#del").hide();
		$("#lock").hide();
		$("#close").hide();
		$("#open").hide();
		$("#doPasscard").hide();
		$("#doImportScore").hide();
		//$("#sendMsgExam").hide();
		//$("#sendMsgScore").hide();
		$("#btnRemove").hide();
		$("#btnResit").hide();
		$("#s_needResit").hide();
		$("#examStatus").hide();
        $("#examClose").hide();
		$("#startNo").prop("disabled",true);
		$("#certID").prop("disabled",true);
		if(op==1){
			setEmpty();
			$("#save").show();
			$("#certID").prop("disabled",false);
			//$("#save").focus();
		}else{
			if(checkPermission("studentAdd")){
				if(s==0){		//考前可以删除考试、调整人员
					$("#save").show();
					$("#del").show();
					$("#lock").show();
					$("#btnRemove").show();
				}
				if(s==1){		//锁定后可以做准考证，发考试通知，上传成绩，发成绩通知
					$("#doPasscard").show();
					//$("#sendMsgExam").show();
					//$("#sendMsgScore").show();
				}
				if(s==2){
					$("#btnResit").show();
					$("#s_needResit").show();
					$("#sendMsgScore").show();
					//结束后，安排补考
				}
				if(s<2){
					$("#close").show();
				}
			}
			if(checkPermission("scoreUpload") && s == 1){
				$("#doImportScore").show();
			}
			if(checkPermission("examOpen") && s > 0){
				$("#open").show();
			}
			if($("#kindID").val()==1){
				$("#examStatus").show();
			}
		}
	}
	
	function setEmpty(){
		//$("#title").val("中石化从业人员安全知识考核");
		$("#title").val("");
		$("#startDate").val(currDate + " 15:00");
		$("#qty").val(0);
		$("#startTime").val(currDate + " 16:30");
		$("#startNo").val(1);
		$("#address").val("黄兴路158号D103");
		$("#notes").val("请务必携带身份证原件和准考证；迟到15分钟不得入场。");
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">考试时间</td><input type="hidden" id="closeDate" /><input type="hidden" id="ID" />
				<td><input class="mustFill" type="text" id="startDate" size="18" /><label id="ID1" style="background:#ffff00;"></label></td>
				<td align="right">截止时间</td>
				<td><input type="text" id="startTime" size="25" /></td>
			</tr>
			<tr>
				<td align="right">考试科目</td><input type="hidden" id="status" /><input type="hidden" id="startNo" />
				<td><select id="certID" style="width:100%;"></select></td>
				<td align="right">人数</td>
				<td><input class="readOnly" type="text" id="qty" size="5" readOnly="true" />&nbsp;&nbsp;类型&nbsp;<select id="kindID" style="width:60px;"></select></td>
			</tr>
			<tr>
				<td align="right">标准时长</td>
				<td><input class="readOnly" type="text" id="minutes" readOnly="true" size="5" />&nbsp;&nbsp;分钟</td>
				<td align="right">合格分数</td>
				<td><input class="readOnly" type="text" id="scorePass" readOnly="true" size="5" />&nbsp;&nbsp;优化&nbsp;<select id="sync" style="width:60px;"></select></td>
			</tr>
			<tr>
				<td align="right">场次标识</td>
				<td colspan="3"><input class="mustFill" type="text" id="title" style="width:70%;" />&nbsp;&nbsp;状态&nbsp;<input class="readOnly" type="text" id="statusName" size="5" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">考试地址</td>
				<td><input type="text" id="address" size="25" /></td>
				<td colspan="2">
					<span id="photo" style="margin-left:10px;"></span>
					<span id="list" style="margin-left:10px;"></span>
					<span id="sign" style="margin-left:10px;"></span>
					<span id="score" style="margin-left:10px;"></span>
					<span id="scoreResult" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">注意事项</td>
				<td colspan="3"><input type="text" id="notes" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><input type="text" id="memo" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">制作日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">制作人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">考试通知</td>
				<td colspan="5">
					次数&nbsp;<input class="readOnly" type="text" id="send" size="2" readOnly="true" />&nbsp;&nbsp;
					日期&nbsp;<input class="readOnly" type="text" id="sendDate" size="6" readOnly="true" />&nbsp;&nbsp;
					发送人&nbsp;<input class="readOnly" type="text" id="senderName" size="5" readOnly="true" />&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<td align="right">成绩通知</td>
				<td colspan="5">
					次数&nbsp;<input class="readOnly" type="text" id="sendScore" size="2" readOnly="true" />&nbsp;&nbsp;
					日期&nbsp;<input class="readOnly" type="text" id="sendScoreDate" size="6" readOnly="true" />&nbsp;&nbsp;
					发送人&nbsp;<input class="readOnly" type="text" id="senderScoreName" size="5" readOnly="true" />&nbsp;&nbsp;
				</td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
		<input class="button" type="button" id="save" value="保存" />&nbsp;
		<input class="button" type="button" id="del" value="删除" />&nbsp;
		<input class="button" type="button" id="doPasscard" value="做准考证" />&nbsp;
		<input class="button" type="button" id="sendMsgExam" value="考试通知" />&nbsp;
		<input class="button" type="button" id="doImportScore" value="成绩导入" />&nbsp;
		<input class="button" type="button" id="sendMsgScore" value="成绩通知" />&nbsp;
		<input class="button" type="button" id="lock" value="锁定" />&nbsp;
		<input class="button" type="button" id="close" value="结束" />&nbsp;
		<input class="button" type="button" id="open" value="开启" />&nbsp;
		<input class="button" type="button" id="examStatus" value="考试情况" />&nbsp;
		<input class="button" type="button" id="examClose" value="收卷" />&nbsp;
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;padding-left:20px;">
			<span>鉴定结果&nbsp;<select id="s_status" style="width:70px"></select></span>
			<span>&nbsp;&nbsp;申请补考&nbsp;<select id="s_resit" style="width:70px"></select></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSearch" value="查找" /></span>
			<span id="s_needResit"><input style="border:0px;" type="checkbox" id="needResit" value="" />&nbsp;需补考&nbsp;</span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSel" value="全选/取消" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnRemove" value="移出名单" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnResit" value="加入补考购物车" /></span>
		</div>
	</div>
	<hr size="1" noshadow />
	<div id="cover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
</div>
</body>
