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

<script language="javascript">
	var nodeID = 0;
	var count = 0;
	var qrlist = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//hostNo
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		$("#btnDel").linkbutton({
			iconCls:'icon-clear',
			width:70,
			height:25,
			text:'清空',
			onClick:function() {
				emptyQRqueue();
			}
		});

		getQRqueueList();

		setInterval(function () {
			getQRqueueList();
		}, 5000);	//5秒刷新一次
		
	});

	function getQRqueueList(){
		// alert(count)
		$.get("hostControl.asp?op=getQRqueueList&times=" + (new Date().getTime()),function(re){
			// alert(unescape(re));
			var ar = new Array();
			var arr = new Array();
			count = 0;
			var i = 0;
			var j = 0;
			var m = 3;  //3 rows per table
			var n = 4;  //3 columns per row
			ar = unescape(re).split("%%");
			var list = ar.shift();
			if(qrlist == list){
				// 队列无变化时不更新二维码
				return false;
			}
			qrlist = list;
			// arr.push('<div><p style="font-size:2em;align:left;padding-left:20px;">请扫码、登录、签名：</p><span style="padding-right:20%;"><a class="easyui-linkbutton" id="btnDel" href="javascript:void(0)"></a></span></div>');
			if(ar > ""){
				$.each(ar,function(iNum,val){
					count += 1;
					var ar1 = new Array();
					ar1 = val.split("|");
					if(i == 0){
						arr.push('<table style="width:100%;max-width:100%; table-layout: fixed;">');
					}
					if(i%n == 0){
						arr.push('<tr>');
					}
					arr.push('<td style="width:25%;max-width:25%;height:30%;max-height:30%;" align="center">');
					var text = uploadURL + "/public/get_qr_img?size=10&text=" + encodeURIComponent("<%=mobile_url%>/#/login?host=" + currHost + "&username=" + ar1[1] + "&password=" + ar1[3]);
					arr.push('<div style="max-width:100%;max-height:100%;"><img src="' + text + '" style="max-width:100%;max-height:100%;" /></div>');
					arr.push('<div style="text-align:center;"><p style="font-size:2em;">' + ar1[2] + '&nbsp;&nbsp;**' + ar1[1].substr(14,4) + '</p></div>');
					arr.push('</td>');
					i += 1;
					if(i%n == 0){
						arr.push('</tr>');
					}
					if(i%(n*m) == 0){
						i = 0;
						arr.push('</table><hr style="page-break-after:always; border:none;">');	//分页
					}
				});
			}
			$("#qrCover").html(arr.join(""));
		});
	}
	
	function emptyQRqueue(){
		jConfirm('确定要清空所有二维码吗?', '确认对话框', function(r) {
			if(r){
				$.get("hostControl.asp?op=emptyQRqueue&times=" + (new Date().getTime()),function(data){
					$("#qrCover").html("");
				});
			}
		});
	}
	
	function setButton(){
		$("#btnDel").hide();
		if(count>0){
			$("#btnDel").show();
		}
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div style="margin:10px;"><span style="font-size:2em;text-align:left;padding-left:20px;">请扫码、登录、签名：</span><span style="float:right;padding-right:100px;"><a class="easyui-linkbutton" id="btnDel" href="javascript:void(0)"></a></span></div>
	<div id="qrCover"></div>

</div>
</body>
