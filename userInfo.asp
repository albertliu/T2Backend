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
        width: 50px;
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
		width: 400px;
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
	var userName = "";
	var realName = "";
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = <%=op%>;
		$.ajaxSetup({ 
			async: false 
		}); 
		
		getComboBoxList("userStatus","status",1);
        getComboList("partnerID","partnerInfo","partnerID","title","status=0 order by ID",1);

		$("#btnSave").linkbutton({
			iconCls:'icon-save',
			width:70,
			height:25,
			text:'保存',
			onClick:function() {
				if($("#userName").textbox("getValue")=="" || $("#realName").textbox("getValue")=="" ){
					$.messager.alert("提示","用户名或姓名不能为空。","warning");
					return false;
				}
				$.get("userControl.asp?op=update&nodeID=" + $("#userID").val() + "&userName=" + escape($("#userName").textbox("getValue")) + "&partnerID=" + $("#partnerID").combobox("getValue") + "&realName=" + escape($("#realName").textbox("getValue")) + "&status=" + $("#status").combobox("getValue") + "&limitedDate=" + $("#limitedDate").datebox("getValue")+ "&phone=" + escape($("#phone").textbox("getValue")) + "&memo=" + escape($("#memo").textbox("getValue")) + "&p=0&times=" + (new Date().getTime()),function(re){
					jAlert(unescape(re));
					var ar = new Array();
					ar = unescape(re).split("|");
					if(ar[0] == 0){
						jAlert("保存成功！","信息提示");
						updateCount += 1;
						nodeID = ar[1];
						getNodeInfo(ar[1]);
					}
					if(ar[0] == 1){
						jAlert("该用户名已经存在。","信息提示");
						$("#userNo").focus();
					}
					if(ar[0] == 2){
						jAlert("用户名不能为空。","信息提示");
						$("#userNo").focus();
					}
					if(ar[0] == 3){
						jAlert("姓名不能为空。","信息提示");
						$("#realName").focus();
					}
				});
				return false;
			}
		});

		$("#btnAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				op = 1;
				nodeID = "";
				setButton();
			}
		});

		$("#btnReset").linkbutton({
			iconCls:'icon-redo',
			width:85,
			height:25,
			text:'重置密码',
			onClick:function() {
				jConfirm('你确定要将这个用户密码重置吗?', '确认对话框', function(r) {
					if(r){
						$.get("userControl.asp?op=resetPasswd&nodeID=" + $("#userID").val() + "&times=" + (new Date().getTime()),function(data){
							jAlert("操作成功！新密码为：123456","信息提示");
						});
					}
				});
			}
		});

		$("#del").click(function(){
			if($("#kindID").val()==1){
				jAlert("固定用户不可删除");
				return false;
			}
			jConfirm('你确定要删除这个用户吗?', '确认对话框', function(r) {
				if(r){
					$.get("userControl.asp?op=delNode&nodeID=" + $("#userID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("删除成功！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});
		
		$("#changeRole").linkbutton({
			iconCls:'icon-edit',
			width:85,
			height:25,
			text:'变更角色',
			onClick:function() {
				showUserRoleList();
			}
		});
		
		$("#changePermission").linkbutton({
			iconCls:'icon-edit',
			width:85,
			height:25,
			text:'变更权限',
			onClick:function() {
				showUserPermissionList();
			}
		});
		
		$("#userName").change(function(){
			if($("#userName").textbox("getValue")>"" && op == 1){
				$.get("userControl.asp?op=chkUser&nodeID=" + $("#userID").val() + "&userName=" + escape($("#userName").textbox("getValue")) + "&times=" + (new Date().getTime()),function(data){
					if(data == 1){
						jAlert("该用户名已经存在。","信息提示");
						$("#userName").textbox("setValue", "");
					}
				});
			}
		});

		$("#userName").textbox({
			onChange:function() {
				if(op==1 && $("#userName").textbox("getValue")>""){
					checkExistKeyInTab("userName","userInfo","userName",$("#userName").textbox("getValue"));
				}
			}
		});

		$("#btnSignature").click(function(){
			showSignatureInfo("user_letter_signature",userName,0,1,"getNodeInfo($('#userID').val())");
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

		if(op==1){
			setButton();
		}
		if(op==0){
			getNodeInfo(nodeID);
		}
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("userControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#userID").val(ar[0]);
				$("#userName").textbox("setValue", ar[2]);
				$("#realName").textbox("setValue", ar[3]);
				userName = ar[2];
				realName = ar[3];
				$("#status").combobox("setValue", ar[4]);
				$("#partnerID").combobox("setValue", (ar[6]>""?ar[6]:""));
				$("#limitedDate").datebox("setValue", ar[10]);
				$("#phone").textbox("setValue", ar[11]);
				$("#memo").textbox("setValue", ar[13]);
				$("#regDate").textbox("setValue", ar[14]);
				$("#registerName").textbox("setValue", ar[16]);
				if(ar[18] > ""){
					$("#signature").html("<img src='users" + ar[18] + "?times=" + (new Date().getTime()) + "' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'>");
				}else{
					$("#signature").html("尚未签名");
				}
				var text = uploadURL + "/public/get_qr_img?size=10&text=" + encodeURIComponent("<%=mobile_url%>/#/login?host=" + currHost + "&sales=" + ar[2] + "&partner=" + currPartner);
				// alert(text)
				$("#img").prop("src", text);
				getRoleListByUser();
				getPermissionListByUser();
				getAllPermissionListByUser();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
			op = 0;
			setButton();
		});
	}
	
	function setButton(){
		$("#btnAdd").hide();
		$("#btnSave").hide();
		$("#btnSignature").hide();
		$("#btnReset").hide();
		$("#userNo").attr("disabled",true);
		$("#changeRole").hide();
		$("#changePermission").hide();
		if(op == 0){
			if(checkPermission("userAdd")){
				$("#btnAdd").show();
				$("#btnSave").show();
				$("#btnReset").show();
				$("#changeRole").show();
				$("#changePermission").show();
			}
			if(currUser == userName){
				$("#btnSignature").show();
			}
		}
		if(op == 1){
			setEmpty();
			$("#btnSave").show();
			//$("#btnLoadFile").attr("disabled",true);
			$("#userName").attr("disabled",false);
			$("#userName").focus();
		}
	}
	
	function setEmpty(){
		$("#userID").val(0);
		$("#userName").textbox("setValue", "");
		$("#status").combobox("setValue", 0);
		$("#realName").textbox("setValue", "");
		$("#partnerID").combobox("setValue", "");
		$("#phone").textbox("setValue", "");
		$("#limitedDate").datebox("setValue", "2037-09-20");
		$("#regDate").textbox("setValue", currDate);
		$("#registerName").textbox("setValue", currUserName);
		$("#roleList").empty();
		$("#permissionList").empty();
		$("#allPermissionList").empty();
		userName = "";
		realName = "";
	}
	
	function getUpdateCount(){
		return updateCount;
	}

	function getRoleListByUser(){
		//根据用户名列出其拥有的角色
		$.get("userControl.asp?op=getRoleListByUser&userName=" + userName + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//$("#roleList").empty();
			document.getElementById("roleList").options.length = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#roleList");
				});
			}
		});
	}

	function getPermissionListByUser(){
		//根据用户名列出其拥有的直接分配权限
		$.get("userControl.asp?op=getPermissionListByUser&userName=" + userName + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//$("#permissionList").empty();
			document.getElementById("permissionList").options.length = 0;
			if(ar>""){
				var s = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					s = "";
					if(ar1[3]>""){s = "&nbsp;&nbsp;&nbsp;(" + ar1[3] + ")";}
					$("<option value='" + ar1[0] + "'>" + ar1[1] + s + "</option>").appendTo("#permissionList");
				});
			}
		});
	}

	function getAllPermissionListByUser(){
		//根据用户名列出其拥有的所有权限
		$.get("userControl.asp?op=getAllPermissionListByUser&userName=" + userName + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//$("#permissionList").empty();
			document.getElementById("allPermissionList").options.length = 0;
			if(ar>""){
				var s = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					s = "";
					if(ar1[3]>""){s = "&nbsp;&nbsp;&nbsp;(" + ar1[3] + ")";}
					$("<option value='" + ar1[0] + "'>" + ar1[1] + s + "</option>").appendTo("#allPermissionList");
				});
			}
		});
	}
	
	function showUserRoleList(){
		if($("#userID").val() > 0){
			//$.get("commonControl.asp?op=setSession&sName=pagePara" + "&anyStr=" + escape(userName + "|" + realName + "|" + 1) + "&times=" + (new Date().getTime()),function(re){
				asyncbox.open({
					url:'userRoleList.asp?refID=' + userName + '&item=' + escape(realName) + '&kindID=1&times=' + (new Date().getTime()),
					title: '角色分配',
					width : 730,
					height : 520,
					callback : function(action){
						if(action == 'close'){
							getRoleListByUser();
							getAllPermissionListByUser();
	　　　　　			}
		　　		}
				});
			//});
		}
	}
	
	function showUserPermissionList(){
		if($("#userID").val() > 0){
			//$.get("commonControl.asp?op=setSession&sName=pagePara" + "&anyStr=" + escape(userName + "|" + realName + "|" + 1) + "&times=" + (new Date().getTime()),function(re){
				asyncbox.open({
					url:'userPermissionList.asp?refID=' + userName + '&item=' + escape(realName) + '&kindID=1&times=' + (new Date().getTime()),
					title: '权限分配',
					width : 730,
					height : 520,
					callback : function(action){
				　　	if(action == 'close'){
							getPermissionListByUser();
							getAllPermissionListByUser();
		　　　　　		 }
		　　　  	 }
				});
			//});
		}
	}

</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<table border='0' cellpadding='0' cellspacing='0' valign='top' width = '99%'>
		<tr>
	    <td colspan="3" valign='top'>
			<div style="width:98%;float:left;margin:0;">
				<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
					<div class="comm" style="background:#f5faf8;">
						<form action="docControl.asp?op=update" id="fm1" name="fm1"  method="post" encType="multipart/form-data" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
							<table border="0" cellpadding="0" cellspacing="0" width="98%" style="line-height:10px;">
								<tr>
									<td align="right">用户名</td><input id="userID" type="hidden" /><input id="kindID" type="hidden" />
									<td><input id="userName" name="userName" class="easyui-textbox" data-options="height:22,width:195,required:true" /></td>
									<td align="right">姓名</td>
									<td><input id="realName" name="realName" class="easyui-textbox" data-options="height:22,width:195,required:true" /></td>
								</tr>
								<tr>
									<td align="right">部门</td>
									<td><select id="partnerID" name="partnerID" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:195"></select></td>
									<td align="right">电话</td>
									<td><input id="phone" name="phone" class="easyui-textbox" data-options="height:22,width:195" /></td>
								</tr>
								<tr>
									<td align="right">有效期</td>
									<td><input id="limitedDate" name="limitedDate" class="easyui-datebox" data-options="height:22,width:100" /></td>
									<td align="right">状态</td>
									<td><select id="status" name="status" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:100"></select></td>
								</tr>
								<tr>
									<td align="right"><input class="button" type="button" id="btnSignature" value="签名" /></td>
									<td><span id="signature"></span></td>
									<td align="right">二维码</td>
									<td>
										<div class="img-list-box">
											<div class="img-select">
												<img id="img" src="" />
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td align="right">备注</td>
									<td colspan="3"><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:500" /></td>
								</tr>
								<tr>
									<td align="right">登记日期</td>
									<td><input id="regDate" name="regDate" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
									<td align="right">登记人</td>
									<td><input id="registerName" name="registerName" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
								</tr>
							</table>
		        		</form>
					</div>
				</div>
				<div style="width:100%;float:left;margin:10;height:4px;"></div>
				<div class="buttonbox">
					<a class="easyui-linkbutton" id="btnSave" href="javascript:void(0)"></a>
					<a class="easyui-linkbutton" id="btnAdd" href="javascript:void(0)"></a>
					<a class="easyui-linkbutton" id="btnReset" href="javascript:void(0)"></a>
				</div>
				<div style="width:100%;float:left;margin:10;height:4px;"></div>
			</div>
	   </td>
		</tr>
		<tr>
	   <td valign='top' width = '30%'>
			<div style="float:left;border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
	    	<div align="center">
	    		<div class="comm"><h2>拥有角色</h2></div>
					<select name="roleList" size="20" id="roleList" multiple style="background-color:#FFFFFE; border: '#EEEEFF'; width:90% "></select>
	    		</div>
				<hr size="1" color="#c0c0c0" noshadow>
				<div class="comm" align="center" style="margin:3px;">
					<a class="easyui-linkbutton" id="changeRole" href="javascript:void(0)"></a>
				</div>
			</div>
	   </td>
	   <td valign='top' width = '30%'>
			<div style="float:left;border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
	    	<div align="center">
	    		<div class="comm"><h2>直接权限</h2></div>
					<select name="permissionList" size="20" id="permissionList" multiple style="background-color:#FFFFFE; border: '#EEEEFF'; width:90% "></select>
				</div>
				<hr size="1" color="#c0c0c0" noshadow>
				<div class="comm" align="center" style="margin:3px;">
					<a class="easyui-linkbutton" id="changePermission" href="javascript:void(0)"></a>
				</div>
			</div>
	   </td>
	   <td valign='top' width = '30%'>
			<div style="float:left;border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
	    	<div align="center">
	    		<div class="comm"><h2>实际权限</h2></div>
					<select name="allPermissionList" size="20" id="allPermissionList" multiple style="background-color:#FCFCFC; border: '#EEEEFF'; width:90% ">
					</select>
	    	</div>
	    	<div style="color:gray;">* 包括直接分配的权限、从角色获得的权限以及他人的授权。</div>
			</div>
	   </td>
		</tr>
	</table>
	<div class="dialog-bg" id="dialog-bg">
    <div class="img-box">
        <img id="img-box" src="">
    </div>
</div>
	
</div>
</body>
