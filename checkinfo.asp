<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
	<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.18">
	<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script src="js/jquery.alerts.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<style>
    .img-select img {
        width: 80px;
        height: auto;
    }

    .dialog-bg {
        display: none;
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        background: rgba(0,0,0,0.4);
    }
	.dialog-bg .img-box {
		width: 500px;
		height: auto;
		position: absolute;
		left: 50%;
		right: 50%;
		transform: translateX(-50%);
	}

	.dialog-bg .img-box img {
		width: 100%;
		height: 100%;
	}
</style>
<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//hostNo
		op = "<%=op%>";
		
		getComboList("courseID","v_courseInfo","courseID","courseName1","status=0 order by seq",1);
		getComboList("placeID","classroomPlace","placeID","placeName","status=0 and host='" + currHost + "'",0);
		$("#checkDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
		$("#checkDate").datebox("disable");
		
		$("#btnDo").click(function(){
			if($("#courseID").combobox("getValue")==""){
				$.messager.alert("提示","请选择课程。","warning");
				return false;
			}
			if($("#placeID").combobox("getValue")==""){
				$.messager.alert("提示","请选择上课地点。","warning");
				return false;
			}
			let text = uploadURL + "/public/get_qr_img?size=15&text=" + encodeURIComponent("<%=mobile_url%>/#/login?checkin=1&ck_courseID=" + $("#courseID").combobox("getValue") + "&ck_courseName=" + $("#courseID").combobox("getText") + "&ck_placeID=" + $("#placeID").combobox("getValue") + "&ck_kindID=0&ck_date=" + $("#checkDate").datebox("getValue"));
			$("#img").prop("src", text);
		});

		//无论点击哪一个img弹出层都会展示相应的图片。
		$("#img").click(function () {
			var src = $("#img").attr("src");//获取当前点击img的src的值
			$("#img-box").attr("src", src);//将获取的当前点击img的src赋值到弹出层的图片的src
			$("#dialog-bg").show();//弹出层显示
		});

		//弹出层隐藏
		$("#dialog-bg").click(function () {
			$(this).hide();//
		});
	});
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="forms" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
				<tr>
					<td align="right">课程名称</td><input id="hostID" name="hostID" type="hidden" />
					<td colspan="3"><select id="courseID" name="courseID" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:280,required:true"></select></td>
				</tr>
				<tr>
					<td align="right">上课地点</td>
					<td><select id="placeID" name="placeID" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:120"></select></td>
					<td align="right">上课日期</td>
					<td><input id="checkDate" name="checkDate" class="easyui-datebox" data-options="height:22,width:100" /></td>
				</tr>
				<tr>
					<td align="right"><input class="button" type="button" id="btnDo" value="生成二维码" /></td>
					<td align="left" colspan="3">
						<div class="img-list-box;">
							<div class="img-select">
								<div style="vertical-align:middle;text-align:center;height:80px;">
									<span><img id="img" src="" /></span>
								</div>
							</div>
						</div>
					</td>
				</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
  </div>

	<div class="dialog-bg" id="dialog-bg">
    <div class="img-box">
        <img id="img-box" src="">
    </div>

</div>
</body>
