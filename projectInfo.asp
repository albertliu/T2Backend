<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
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
		
		getComList("courseID","v_courseInfo","courseID","shortName","status=0 and type=0 order by shortName",1);
		getComList("host","hostInfo","hostNo","title","status=0 order by hostName",1);
		getDicList("payKind","payKind",0);
		getDicList("payGroup","payGroup",0);
		$("#deadline").click(function(){WdatePicker();});
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();

		$("#cancel").click(function(){
			asyncbox.confirm('确定要撤回这个通知吗?','确认',function(action){
			　　if(action == 'ok'){
					setStatus(0);
			　　}
			});
		});

		$("#issue").click(function(){
			asyncbox.confirm('确定要发布这个通知吗?','确认',function(action){
			　　if(action == 'ok'){
					setStatus(1);
			　　}
			});
		});

		$("#close").click(function(){
			asyncbox.confirm('确定要关闭这个通知吗?','确认',function(action){
			　　if(action == 'ok'){
					setStatus(2);
			　　}
			});
		});

		$("#lock").click(function(){
			asyncbox.confirm('确定要锁定这个通知吗? 锁定后将不能进行确认、剔除、提交等操作。','确认',function(action){
			　　if(action == 'ok'){
					setStatus(3);
			　　}
			});
		});

		$("#del").click(function(){
			asyncbox.confirm('确定要删除这个通知吗？','确认',function(action){
			　　if(action == 'ok'){
					setStatus(9);
			　　}
			});
		});

		$("#btnEntryForm").click(function(){
			var n = $("#projectCount").val().split('/');
			if(n[0]==0){
				alert("已确认的学员为0，无法生成报名表。");
				return false;
			}
			asyncbox.confirm('确定要生成培训报名表[' + n[0] + '个学员]吗?','确认',function(action){
			　　//confirm 返回三个 action 值，分别是 'ok'、'cancel' 和 'close'。
			　　if(action == 'ok'){
					generateEntryForm();
			　　}
			　　if(action == 'cancel'){
			　　　　//alert('cancel');
			　　}
			　　if(action == 'close'){
			　　　　//alert('close');
			　　}
			});
		});
		
		$("#courseID").change(function(){
			setPrice();
		});
		
		$("#save").click(function(){
			saveNode();
		});
		$("#host").change(function(){
			setPrice();
			setDeptList($("#host").val(),0,[]);
			getComList("courseID","[dbo].[getHostCourseList]('" + $("#host").val() + "')","courseID","courseName","1=1",1);
		});
		$("#payKind").change(function(){
			setPayGroup();
		});
		
		$("#btnPhoto").click(function(){
			$.getJSON(uploadURL + "/outfiles/generate_student_photos?kindID=0&item=projectID='" + $("#projectID").val() + "'" ,function(data){
				if(data>""){
					asyncbox.alert("照片文件已生成 <a href='" + data + "' target='_blank'>下载文件</a>",'操作成功',function(action){
					　　//alert 返回action 值，分别是 'ok'、'close'。
					　　if(action == 'ok'){
							getStudentNeedDiplomaList();
					　　}
					　　if(action == 'close'){
					　　　　//alert('close');
					　　}
					});
				}else{
					alert("没有可供处理的数据。");
				}
			});
		});

	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("projectControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#projectID").val(ar[1]);
				$("#projectName").val(ar[2]);
				$("#courseID").val(ar[33]);
				$("#kindID").val(ar[4]);
				$("#status").val(ar[5]);
				$("#object").val(ar[6]);
				$("#statusName").val(ar[8]);
				$("#address").val(ar[9]);
				$("#deadline").val(ar[10]);
				$("#host").val(ar[11]);
				setDeptList(ar[11],0,ar[23]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#registerName").val(ar[16]);
				$("#phone").val(ar[18]);
				$("#email").val(ar[19]);
				$("#projectCount").val(ar[20]);
				//$("#dept").val(ar[23]);
				$("#linker").val(ar[24]);
				$("#mobile").val(ar[25]);
				$("#price").val(ar[28]);
				$("#payKind").val(ar[29]);
				$("#payGroup").val(ar[30]);
				$("#upload1").html("<a href='javascript:showLoadFile(\"project_brochure\",\"" + ar[1] + "\",\"project\",\"" + ar[11] + "\");' style='padding:3px;'>上传</a>");
				var c = "";
				if(ar[21] > ""){
					c += "<a href='/users" + ar[21] + "' target='_blank'>招生简章</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;还未上传";}
				$("#photo").html(c);
				var c1 = "";
				if(ar[22] > ""){
					c1 += "<a href='/users" + ar[22] + "' target='_blank'>报名表</a>";
				}
				if(c1 == ""){c1 = "&nbsp;&nbsp;还未生成";}
				$("#entryform").html(c1);
				
				//getDownloadFile("projectID");
				setButton();
				setPayGroup();
			}else{
				alert("该信息未找到！");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#projectName").val().length < 3){
			alert("标题内容请至少填写3个字的内容。");
			return false;
		}
		//alert($("#ID").val() + "&keyID=" + $("#projectID").val() + "&item=" + ($("#projectName").val()) + "&price=" + $("#price").val() + "&payKind=" + $("#payKind").val() + "&payGroup=" + $("#payGroup").val() + "&refID=" + $("#courseID").val() + "&kindID=" + $("#kindID").val() + "&deadline=" + $("#deadline").val() + "&object=" + ($("#object").val()) + "&address=" + ($("#address").val()) + "&dept=" + $("#dept").combobox("getValues") + "&linker=" + ($("#linker").val()) + "&mobile=" + ($("#mobile").val()) + "&phone=" + ($("#phone").val()) + "&email=" + ($("#email").val()) + "&host=" + $("#host").val());
		$.get("projectControl.asp?op=update&nodeID=" + $("#ID").val() + "&keyID=" + $("#projectID").val() + "&item=" + escape($("#projectName").val()) + "&price=" + $("#price").val() + "&payKind=" + $("#payKind").val() + "&payGroup=" + $("#payGroup").val() + "&refID=" + $("#courseID").val() + "&kindID=" + $("#kindID").val() + "&deadline=" + $("#deadline").val() + "&object=" + escape($("#object").val()) + "&address=" + escape($("#address").val()) + "&dept=" + $("#dept").combobox("getValues") + "&linker=" + escape($("#linker").val()) + "&mobile=" + escape($("#mobile").val()) + "&phone=" + escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&host=" + $("#host").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				if(op == 1){
					op = 0;
				}
				alert("保存成功！","信息提示");
				nodeID = ar[1];
				getNodeInfo(nodeID);
				updateCount += 1;
			}
			if(ar[0] != 0){
				alert("未能成功提交，请退出后重试。","信息提示");
			}
		});
		//return false;
	}
	
	function generateEntryForm(){
		$.getJSON(uploadURL + "/outfiles/generate_entryform_byProjectID?certID=" + $("#certID").val() + "&projectID=" + $("#projectID").val() + "&registerID=" + currUser ,function(data){
			if(data>""){
				asyncbox.alert("报名表已生成 <a href='users" + data + "' target='_blank'>下载文件</a>",'操作成功',function(action){
				　　//alert 返回action 值，分别是 'ok'、'close'。
				　　if(action == 'ok'){
						getNodeInfo(nodeID);
				　　}
				　　if(action == 'close'){
				　　　　//alert('close');
				　　}
				});
			}else{
				alert("没有可供处理的数据。");
			}
		});
	}
	
	function setStatus(x){
		//alert($("#projectID").val() + "&projectName=" + ($("#memo").val()));
		$.get("projectControl.asp?op=setProjectStatus&nodeID=" + $("#ID").val() + "&status=" + x + "&times=" + (new Date().getTime()),function(data){
			alert("操作成功！");
			getNodeInfo(nodeID);
			updateCount += 1;
		});
		//return false;
	}
	
	function setPayGroup(){
		if($("#payKind").val()==0){
			$("#item_payGroup").hide();
		}else{
			$("#item_payGroup").show();
		}
	}
	function setDeptList(h,kind,s){
		$.get("deptControl.asp?op=getRootDeptByHost&refID=" + h + "&times=" + (new Date().getTime()),function(re){
			if(re>0){
				$.getJSON(uploadURL + "/public/getDeptListByPID?pID=" + re + "&kindID=" + kind ,function(data){
					if(data>""){
						//alert(data[0]["deptName"]);
						//data = [{"id":1,"text":"text1"},{"id":2,"text":"text2"},{"id":3,"text":"text3"},{"id":4,"text":"text4"},{"id":5,"text":"text5"}];
						$('#dept').combobox({
							data: data,
							valueField:'deptID',
							textField:'deptName',
							//panelHeight: 200,
							multiple: true,
							editable: false,
							onLoadSuccess: function () { // 下拉框数据加载成功调用
								// 正常情况下是默认选中“所有”，但我想实现点击所有全选功能，这这样会冲突，暂时默认都不选
								//$("#dept").combobox('clear'); //清空
								$('#dept').combobox("setValues",s);

								// var opts = $(this).combobox('options');
								// var values = $('#'+_id).combobox('getValues');
								// $.map(opts.data, function (opt) {
								//     if (opt.id === '') { // 将"所有"的复选框勾选
								//         $('#'+opt.domId + ' input[type="checkbox"]').prop("checked", true);
								//     }
								// });
							}
						});
					}
				});
				//getComList("dept","deptInfo","deptID","deptName","dept_status=0 and pID=" + re + " and kindID=" + kind + " order by deptID",1);
			}
		});
	}
	
	function setPrice(){
		if($("#courseID").val()>"" && $("#host").val()>""){
			//获取费用标准
			$.get("courseControl.asp?op=getCoursePrice&nodeID=" + $("#courseID").val() + "&refID=&keyID=0&host=" + $("#host").val() + "&times=" + (new Date().getTime()),function(re){
				$("#price").val(re);
			});
			if(op==1){
				$("#projectName").val($("#host").find("option:selected").text().substr(0,4) + "." + $("#courseID").find("option:selected").text());
			}
		}
	}
	
	function setButton(){
		$("#cancel").hide();
		$("#del").hide();
		$("#close").hide();
		$("#issue").hide();
		$("#save").hide();
		$("#lock").hide();
		$("#btnPhoto").hide();
		$("#btnEntryForm").hide();
		if(checkPermission("projectEdit")){
			$("#save").show();
			$("#btnEntryForm").show();
			if(op == 0){
				var s = $("#status").val();
				if(s==1){	//发布的通知可以撤销
					$("#cancel").show();
				}
				if(s != 1){	//发布状态以外的其他状态都可以进行发布
					$("#issue").show();
				}
				if(s != 2){	//关闭状态以外的其他状态都可以进行关闭
					$("#close").show();
				}
				if(s < 3){	//删除和锁定状态以外的其他状态都可以进行锁定
					$("#lock").show();
				}
				if(s != 9){	//删除状态以外的其他状态都可以进行删除
					$("#del").show();
				}
			}
		}
		if(op ==1){
			setEmpty();
			$("#item_payGroup").hide();
		}else{
			if(checkPermission("photoPrint")){
				$("#btnPhoto").show();
			}
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#projectID").val("");
		$("#certID").val("");
		$("#deadline").val("");
		$("#status").val(0);
		$("#kindID").val(0);
		$("#regDate").val(currDate);
		$("#registerID").val(currUser);
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
				<td align="right">对象单位</td>
				<td><select id="host" style="width:150px;"></select></td>
				<td align="right">对象部门</td>
				<td><input type="text" id="dept" name="dept" size="33" /></td>
			</tr>
			<tr>
				<td align="right" width="15%">课程</td>
				<td><select id="courseID" style="width:200px;"></select></td>
				<td align="right" width="15%">编号</td><input id="ID" type="hidden" /><input type="hidden" id="kindID" /><input type="hidden" id="status" />
				<td><input class="readOnly" type="text" id="projectID" size="24" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">招生对象</td>
				<td><input type="text" id="object" size="24" /></td>
				<td align="right">标题</td>
				<td><input class="mustFill" type="text" id="projectName" size="33" /></td>
			</tr>
			<tr>
				<td align="right">截止日期</td>
				<td><input type="text" id="deadline" size="24" /></td>
				<td align="right">培训地点</td>
				<td><input type="text" id="address" size="33" /></td>
			</tr>
			<tr>
				<td align="right">培训费用</td>
				<td><input type="text" id="price" size="10" />&nbsp;元</td>
				<td align="right">收费方式</td>
				<td><select id="payKind" style="width:60px;"></select><span id="item_payGroup">&nbsp;&nbsp;开票单元<select id="payGroup" style="width:60px;"></select></span></td>
			</tr>
			<tr>
				<td align="right">联系人</td>
				<td><input type="text" id="linker" size="24" /></td>
				<td align="right">手机</td>
				<td><input type="text" id="mobile" size="33" /></td>
			</tr>
			<tr>
				<td align="right">联系电话</td>
				<td><input type="text" id="phone" size="24" /></td>
				<td align="right">电子邮箱</td>
				<td><input type="text" id="email" size="33" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><textarea id="memo" style="padding:2px;" rows="4" cols="70"></textarea></td>
			</tr>
			<tr>
				<td align="right">发布人</td>
				<td><input class="readOnly" type="text" id="registerName" size="24" readOnly="true" /></td>
				<td align="right">发布日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><input class="readOnly" type="text" id="statusName" size="24" readOnly="true" /></td>
				<td align="right">报名人数</td>
				<td><input class="readOnly" type="text" id="projectCount" size="10" readOnly="true" />&nbsp;确认/拒绝/报名</td>
			</tr>
			<tr>
				<td align="right">招生简章</td>
				<td>
					<span id="upload1" style="margin-left:20px;border:1px solid orange;"></span>
					<span id="photo" style="margin-left:20px;"></span>
				</td>
				<td align="right">报名表</td>
				<td>
					<span ><input class="button" type="button" id="btnEntryForm" value="生成" />&nbsp;</span>
					<span id="entryform" style="margin-left:20px;"></span>
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
  	<input class="button" type="button" id="issue" value="发布" />&nbsp;
  	<input class="button" type="button" id="close" value="关闭" />&nbsp;
  	<input class="button" type="button" id="cancel" value="撤回" />&nbsp;
  	<input class="button" type="button" id="lock" value="锁定" />&nbsp;
  	<input class="button" type="button" id="del" value="删除" />&nbsp;
  	<input class="button" type="button" id="btnPhoto" value="打印照片" />&nbsp;
  </div>
</div>
</body>
