<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.0"  rel="stylesheet" type="text/css" />
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
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";

		getComList("knowpointID","knowPointInfo","knowPointID","knowpointID","status=0 order by knowPointID",1);
		getDicList("statusEffect","status",0);
		getDicList("questionType","kindID",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#add").click(function(){
			op = 1;
			setButton();
		});
		$("#save").click(function(){
			saveNode();
		});
		$("#add_image").click(function(){
			showUploadFile(nodeID, "", "question_image", "题干图片", "setImag('image',reDo)", 0, 1);
		});
		$("#add_imageA").click(function(){
			showUploadFile(nodeID, "", "question_imageA", "选项A图片", "setImag('imageA',reDo)", 0, 1);
		});
		$("#add_imageB").click(function(){
			showUploadFile(nodeID, "", "question_imageB", "选项B图片", "setImag('imageB',reDo)", 0, 1);
		});
		$("#add_imageC").click(function(){
			showUploadFile(nodeID, "", "question_imageC", "选项C图片", "setImag('imageC',reDo)", 0, 1);
		});
		$("#add_imageD").click(function(){
			showUploadFile(nodeID, "", "question_imageD", "选项D图片", "setImag('imageD',reDo)", 0, 1);
		});
		$("#add_imageE").click(function(){
			showUploadFile(nodeID, "", "question_imageE", "选项E图片", "setImag('imageE',reDo)", 0, 1);
		});
		$("#add_imageF").click(function(){
			showUploadFile(nodeID, "", "question_imageF", "选项F图片", "setImag('imageF',reDo)", 0, 1);
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("questionControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#questionID").val(ar[1]);
				$("#questionName").val(ar[2]);
				$("#answer").val(ar[7]);
				$("#A").val(ar[8]);
				$("#B").val(ar[9]);
				$("#C").val(ar[10]);
				$("#D").val(ar[11]);
				$("#E").val(ar[12]);
				$("#F").val(ar[19]);
				$("#knowpointID").val(ar[13]);
				$("#kindID").val(ar[5]);
				$("#status").val(ar[3]);
				$("#memo").val(ar[15]);
				$("#regDate").val(ar[16]);
				$("#registerName").val(ar[18]);
				if(ar[20] > ""){
					$("#image").attr("src","/users" + ar[20] + "?times=" + (new Date().getTime()));
					$("#image").attr("title",ar[20].replace('/upload/questions/images/',''));
				}
				if(ar[21] > ""){
					$("#imageA").attr("src","/users" + ar[21] + "?times=" + (new Date().getTime()));
					$("#imageA").attr("title",ar[21].replace('/upload/questions/images/',''));
				}
				if(ar[22] > ""){
					$("#imageB").attr("src","/users" + ar[22] + "?times=" + (new Date().getTime()));
					$("#imageB").attr("title",ar[22].replace('/upload/questions/images/',''));
				}
				if(ar[23] > ""){
					$("#imageC").attr("src","/users" + ar[23] + "?times=" + (new Date().getTime()));
					$("#imageC").attr("title",ar[23].replace('/upload/questions/images/',''));
				}
				if(ar[24] > ""){
					$("#imageD").attr("src","/users" + ar[24] + "?times=" + (new Date().getTime()));
					$("#imageD").attr("title",ar[24].replace('/upload/questions/images/',''));
				}
				if(ar[25] > ""){
					$("#imageE").attr("src","/users" + ar[25] + "?times=" + (new Date().getTime()));
					$("#imageE").attr("title",ar[25].replace('/upload/questions/images/',''));
				}
				if(ar[26] > ""){
					$("#imageF").attr("src","/users" + ar[26] + "?times=" + (new Date().getTime()));
					$("#imageF").attr("title",ar[26].replace('/upload/questions/images/',''));
				}
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}

	function setImag(obj,path){
		$("#" + obj).prop("src","/users" + path + "?times=" + (new Date().getTime()));
	}
	
	function saveNode(){
		//alert($("#questionID").val() + "&item=" + ($("#memo").val()));
		$.get("questionControl.asp?op=update&nodeID=" + $("#ID").val() + "&questionID=" + $("#questionID").val() + "&questionName=" + escape($("#questionName").val()) + "&answer=" + $("#answer").val() + "&A=" + escape($("#A").val()) + "&B=" + escape($("#B").val()) + "&C=" + escape($("#C").val()) + "&D=" + escape($("#D").val()) + "&E=" + escape($("#E").val()) + "&F=" + escape($("#F").val()) + "&refID=" + $("#knowpointID").val() + "&status=" + $("#status").val() + "&kindID=" + $("#kindID").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				if(op == 1){
					op = 0;
					getNodeInfo(ar[1]);
				}
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}
			if(ar[0] != 0){
				jAlert("未能成功提交，请退出后重试。","信息提示");
			}
		});
		//return false;
	}
	
	function setButton(){
		$("#save").hide();
		$("#add").hide();
		if(checkPermission("examAdd")){
			$("#save").show();
			$("#add").show();
		}
		if(op ==1){
			setEmpty();
			$("#add").hide();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#questionID").val("");
		$("#questionName").val("");
		$("#memo").val("");
		$("#status").val(0);
		$("#regDate").val(currDate);
		$("#registerName").val(currUserName);
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
				<td align="right" style="5%;">编号</td><input id="ID" type="hidden" />
				<td><input type="text" id="questionID" size="25" /></td>
				<td align="right">知识点</td>
				<td><select id="knowpointID" style="width:200px;"></select></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td align="right">题型</td>
				<td><select id="kindID" style="width:100px;"></select></td>
				<td align="right">状态</td>
				<td><select id="status" style="width:100px;"></select></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td align="right">题干</td>
				<td colspan="3"><textarea id="questionName" rows="5" cols="75"></textarea></td>
				<td align="right" style="width:5%;"><img id="add_image" src="images/plus.png" tag="plus" /></td>
				<td style="width:10%;">
					<img id="image" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="right">选项A</td>
				<td colspan="3"><textarea id="A" rows="3" cols="75"></textarea></td>
				<td align="right"><img id="add_imageA" src="images/plus.png" tag="plus" /></td>
				<td>
					<img id="imageA" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="right">选项B</td>
				<td colspan="3"><textarea id="B" rows="3" cols="75"></textarea></td>
				<td align="right"><img id="add_imageB" src="images/plus.png" tag="plus" /></td>
				<td>
					<img id="imageB" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="right">选项C</td>
				<td colspan="3"><textarea id="C" rows="3" cols="75"></textarea></td>
				<td align="right"><img id="add_imageC" src="images/plus.png" tag="plus" /></td>
				<td>
					<img id="imageC" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="right">选项D</td>
				<td colspan="3"><textarea id="D" rows="3" cols="75"></textarea></td>
				<td align="right"><img id="add_imageD" src="images/plus.png" tag="plus" /></td>
				<td>
					<img id="imageD" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="right">选项E</td>
				<td colspan="3"><textarea id="E" rows="3" cols="75"></textarea></td>
				<td align="right"><img id="add_imageE" src="images/plus.png" tag="plus" /></td>
				<td>
					<img id="imageE" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="right">选项F</td>
				<td colspan="3"><textarea id="F" rows="3" cols="75"></textarea></td>
				<td align="right"><img id="add_imageF" src="images/plus.png" tag="plus" /></td>
				<td>
					<img id="imageF" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="right">答案</td>
				<td><input type="text" id="answer" size="25" /></td>
				<td align="right">备注</td>
				<td colspan="3"><input type="text" id="memo" style="100%" /></td>
			</tr>
			<tr>
				<td align="right">登记日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">登记人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
				<td></td>
				<td></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;
  	<input class="button" type="button" id="add" name="add" value="新增" />&nbsp;
  </div>
</div>
</body>
