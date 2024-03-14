<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.2"  rel="stylesheet" type="text/css" />
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
<script type="text/javascript" src="js/asyncbox.v1.5.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script src="js/jQuery.print.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->
<style type="text/css"> 
	input[type="text"]{
		background: #ffdddd;
		width:100%;
		height: 30px;
		border: 1px solid #cccccc;
		font-size:1em;
	}
</style> 

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var keyID = 0;
	kindID = "";
	var updateCount = 1;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//0 预览  1 打印
		kindID = "<%=kindID%>";		//certID
		op = "<%=op%>";
		$("#fire_employDate").click(function(){WdatePicker();});
		$("#fire_gradeDate").click(function(){WdatePicker();});
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		$("#img_photo").click(function(){
			if($("#img_photo").attr("value")>""){
				window.open($("#img_photo").attr("value"));
			}
		});

		$("#btnFiremanMaterials").click(function(){
			generateFiremanMaterials();
		});
		$("#btnFiremanZip").click(function(){
			generateFiremanZip();
		});

		$("#save").click(function(){
			saveNode();
		});
		$("input[name='fire_kind5']").change(function(){
			setKind4();
		});
		//getNeed2know(nodeID);
		$("#item_kind7").hide();
		getNodeInfo(nodeID, refID);
		if(getSession("public")==1){
			//resize window
			//$("#layout").css("width":"1000px");
		}

});

	function getNodeInfo(id,ref){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				$("#SNo").html(ar[25] + "&nbsp;&nbsp;班级：" + ar[34]);
				$("#courseName").html(ar[6]);
				$("#missingItems").html("缺项：" + ar[43]);
				kindID = ar[36];
				if(kindID=="C20A"){
					$("#fire_kind4_0").prop("disabled",true);
				}else{
					$("#fire_kind4_1").prop("disabled",true);
				}
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
		});
		$.get("studentCourseControl.asp?op=getFiremanEnterInfo&refID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				$("#fire_area").val(ar[2]);
				$("#fire_address").val(ar[3]);
				$("#fire_employDate").val(ar[4]);
				$("#fire_university").val(ar[5]);
				$("#fire_gradeDate").val(ar[6]);
				$("#fire_profession").val(ar[7]);
				$("#fire_area_now").val(ar[8]);
				$("input[name='fire_kind1'][value=" + ar[9] + "]").attr("checked",true);
				$("input[name='fire_kind2'][value=" + ar[10] + "]").attr("checked",true);
				$("input[name='fire_kind3'][value=" + ar[11] + "]").attr("checked",true);
				$("input[name='fire_kind4'][value=" + ar[12] + "]").attr("checked",true);
				$("input[name='fire_kind5'][value=" + ar[13] + "]").attr("checked",true);
				$("input[name='fire_kind6'][value=" + ar[14] + "]").attr("checked",true);
				$("input[name='fire_kind7'][value=" + ar[15] + "]").attr("checked",true);
				$("input[name='fire_kind8'][value=" + ar[16] + "]").attr("checked",true);
				$("input[name='fire_kind9'][value=" + ar[17] + "]").attr("checked",true);
				$("input[name='fire_kind10'][value=" + ar[18] + "]").attr("checked",true);
				$("input[name='fire_kind11'][value=" + ar[19] + "]").attr("checked",true);
				$("input[name='fire_kind12'][value=" + ar[20] + "]").attr("checked",true);
				$("#fire_memo").val(ar[24]);
				var c = "";
				if(ar[21] > ""){
					c += "<a href='/users" + ar[21] + "' target='_blank'>证明材料</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;证明材料还未生成";}
				$("#fire_materials").html(c);
				c = "";
				if(ar[22] > ""){
					c += "<a href='/users" + ar[22] + "' target='_blank'>报名表</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;报名表还未生成";}
				$("#fire_materials1").html(c);
				c = "";
				if(ar[23] > ""){
					c += "<a href='/users" + ar[23] + "' target='_blank'>压缩包</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;压缩包还未生成";}
				$("#fire_zip").html(c);
				setKind4();
			}
		});
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
			//alert(ref + ":" + unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#username").html(ar[1]);
				$("#name").html(ar[2]);
				$("#mobile").html(ar[7]);
				$("#sexName").html(ar[8]);
				$("#age").html(ar[9]);
				$("#birthday").html(ar[33]);
				$("#unit").html(ar[35]);
				$("#ethnicity").html(ar[37]);
				$("#IDaddress").html(ar[38]);
				if(ar[21] > ""){
					$("#img_photo").attr("src","/users" + ar[21]);
					$("#img_photo").attr("value","/users" + ar[21]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
					$("#img_photo").attr("value","");
				}
				var c = "";
				if(ar[22] > ""){
					c += "<a href='/users" + ar[22] + "' target='_blank'>身份证正面</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;身份证正面还未上传";}
				$("#img_cardA").html(c);
				if(keyID==1){
					resumePrint();
				}
			}else{
				alert("没有找到要打印的内容。");
				return false;
			}
		});
		//setSession("public",0);
	}
	
	function generateFiremanMaterials(){
		$.getJSON(uploadURL + "/outfiles/generate_fireman_materials?username=" + refID + "&enterID=" + nodeID + "&registerID=" + currUser ,function(data){
			if(data>""){
				alert("已生成文件");
				getNodeInfo(nodeID, refID);
			}else{
				alert("没有可供处理的数据。");
			}
		});
	}
	
	function generateFiremanZip(){
		$.getJSON(uploadURL + "/outfiles/generate_fireman_zip?username=" + refID + "&enterID=" + nodeID + "&registerID=" + currUser ,function(data){
			if(data>""){
				alert("已生成压缩包");
				getNodeInfo(nodeID, refID);
			}else{
				alert("没有可供处理的数据。");
			}
		});
	}
	
	function saveNode(){
		//alert(nodeID + "&area=" + ($("#fire_area").val()) + "&address=" + ($("#fire_address").val()));
		$.get("studentCourseControl.asp?op=updateFiremanEnterInfo&refID=" + nodeID + "&area=" + escape($("#fire_area").val()) + "&address=" + escape($("#fire_address").val())+ "&employDate=" + $("#fire_employDate").val() + "&university=" + escape($("#fire_university").val()) + "&profession=" + escape($("#fire_profession").val()) + "&gradeDate=" + $("#fire_gradeDate").val() + "&area_now=" + escape($("#fire_area_now").val()) + "&kind1=" + $("input[name='fire_kind1']:checked").val() + "&kind2=" + $("input[name='fire_kind2']:checked").val() + "&kind3=" + $("input[name='fire_kind3']:checked").val() + "&kind4=" + $("input[name='fire_kind4']:checked").val() + "&kind5=" + $("input[name='fire_kind5']:checked").val() + "&kind6=" + $("input[name='fire_kind6']:checked").val() + "&kind7=0&kind8=" + $("input[name='fire_kind8']:checked").val() + "&kind9=" + $("input[name='fire_kind9']:checked").val() + "&kind10=" + $("input[name='fire_kind10']:checked").val() + "&kind11=" + $("input[name='fire_kind11']:checked").val() + "&kind12=" + $("input[name='fire_kind12']:checked").val() + "&memo=" + escape($("#fire_memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				alert("保存成功！","信息提示");
				updateCount += 1;
			}else{
				alert(ar[1]);
			}
		});
		//return false;
	}

	function resumePrint(){
		$("#resume_print").print({
			//Use Global styles
			globalStyles : true,
			//Add link with attrbute media=print
			mediaPrint : false,
			//Custom stylesheet
			stylesheet : "",
			//Print in a hidden iframe
			iframe : true,
			//Don't print this
			noPrintSelector : ".no-print",
			//Add this at top
			prepend : "",
			//Add this on bottom
			append : "<br/>"
		});
		window.setTimeout(function () {
			//window.parent.asyncbox.close("enterInfo");
			window.parent.getStudentCourseList(refID);
			window.parent.$.close("enterInfo");
			//refreshMsg();
		}, 1000);
	}

	function setKind4(){
		if($("input[name='fire_kind5']:checked").val()==4){
			$("#fire_kind4_1").hide();
		}else{
			$("#fire_kind4_1").show();
		}
		if(kindID=="C20A"){
			$("#fire_kind4_0").hide();
			$("#fire_kind4_1").show();
		}else{
			$("#fire_kind4_0").show();
			$("#fire_kind4_1").hide();
		}
	}

	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;width:1000px;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="text-align:center;">
		<input class="button" type="button" id="print" value="打印" />&nbsp;<input class="button" type="button" id="save" value="保存" />&nbsp;
		</div>
		<hr style="text-align:center;margin-top:10px;margin-bottom:10px;">
		<div>
		申报文件
			<span id="fire_materials" style="margin-left:20px;"></span>
			<span id="fire_materials1" style="margin-left:20px;"></span>
			<span id="img_cardA" style="margin-left:20px;"></span>
			<span id="fire_zip" style="margin-left:20px;"></span>
			<input class="button" style="margin-left:20px;" type="button" id="btnFiremanMaterials" value="生成文件" />
			<input class="button" style="margin-left:20px;" type="button" id="btnFiremanZip" value="生成压缩包" />
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>全国消防行业职业技能鉴定报名表</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em;'>学员编号：</span><span style='font-size:1.2em;' id="SNo"></span><span style='font-size:1.2em;padding-left:30px;' id="missingItems"></span></div>
			<table class='table_resume' style='width:99%;'>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>姓名</td><td align="center" width='32%'><p style='font-size:1em;' id="name"></p></td>
				<td align="center" class='table_resume_title' width='16%'>性别</td><td align="center" width='16%'><p style='font-size:1em;' id="sexName"></p></td>
				<td rowspan="4" align="center" class='table_resume_title' width='20%'>
					<img id="img_photo" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>身份证号</td><td align="center"><p style='font-size:1em;' id="username"></p></td>
				<td align="center" class='table_resume_title' width='16%'>出生日期</td><td class='table_resume_title'><p style='font-size:1em;' id="birthday"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>年龄</td><td align="center" width='20%'><p style='font-size:1em;' id="age"></p></td>
				<td align="center" class='table_resume_title' width='16%'>民族</td><td align="center"><p style='font-size:1em;' id="ethnicity"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>人员属性</td><td align="left">
					<span style='font-size:1em;'><input type="radio" name="fire_kind1" value=0 />&nbsp;&nbsp;社会人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind1" value=1 />&nbsp;&nbsp;专职消防人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind1" value=2 />&nbsp;&nbsp;综合性消防救援队伍人员</span>
				</td>
				<td align="center" class='table_resume_title' width='16%'>户口所在地</td><td class='table_resume_title'><input type="text" id="fire_area" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>政治面貌</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind2" value=0 />&nbsp;&nbsp;中国共产党党员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind2" value=1 />&nbsp;&nbsp;民主党派人士</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind2" value=2 />&nbsp;&nbsp;群众</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>身份证地址</td><td align="center" colspan="4"><p style='font-size:1em;' id="IDaddress"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>在职情况</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind11" value=0 />&nbsp;&nbsp;在职人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind11" value=1 />&nbsp;&nbsp;待业人员</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='44px;'>工作单位</td><td align="center" colspan="2"><p style='font-size:1em;' id="unit"></p></td>
				<td align="center" class='table_resume_title'>参加工作时间</td><td align="center"><input type="text" id="fire_employDate" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>从事职业</td><td align="center" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=0 />&nbsp;&nbsp;农林牧渔水利</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=1 />&nbsp;&nbsp;工业</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=2 />&nbsp;&nbsp;建筑</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=3 />&nbsp;&nbsp;交运电信</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=4 />&nbsp;&nbsp;商业、饮食、物资供应和仓储</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=5 />&nbsp;&nbsp;房地产、公用事业、居民服务</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=6 />&nbsp;&nbsp;卫生体育福利</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=7 />&nbsp;&nbsp;教育文化广电</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=8 />&nbsp;&nbsp;科研技术服务</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=9 />&nbsp;&nbsp;金融保险</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=10 />&nbsp;&nbsp;机关社团</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind10" value=11 />&nbsp;&nbsp;其他</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>所在学校</td><td align="center"><input type="text" id="fire_university" style="width:100%;" /></td>
				<td align="center" class='table_resume_title'>学校类型</td><td align="center" colspan="2">
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=0 />&nbsp;&nbsp;普通高等学校</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=1 />&nbsp;&nbsp;高级技校</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=2 />&nbsp;&nbsp;技校</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=3 />&nbsp;&nbsp;技师学院</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=4 />&nbsp;&nbsp;其他</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>学历</td><td align="center" colspan="2">
					<span style='font-size:1em;'><input type="radio" name="fire_kind12" value=0 />&nbsp;&nbsp;博士</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind12" value=1 />&nbsp;&nbsp;研究生</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind12" value=2 />&nbsp;&nbsp;本科</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind12" value=3 />&nbsp;&nbsp;大专</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind12" value=4 />&nbsp;&nbsp;高中</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind12" value=5 />&nbsp;&nbsp;中专</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind12" value=6 />&nbsp;&nbsp;职高</span>
				</td>
				<td align="center" class='table_resume_title'>毕业时间</td><td align="center"><input type="text" id="fire_gradeDate" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>专业名称</td><td align="center" colspan="4"><input type="text" id="fire_profession" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>手机号码</td><td align="center"><p style='font-size:1em;' id="mobile"></p></td>
				<td align="center" class='table_resume_title'>常住地市</td><td align="center" colspan="2"><input type="text" id="fire_area_now" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>详细地址</td><td align="center" colspan="4"><input type="text" id="fire_address" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>报考工种</td><td align="center" colspan="4"><p style='font-size:1em;' id="courseName"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>职业方向</td><td align="left" colspan="4">
					<span style='font-size:1em;' id="fire_kind4_0"><input type="radio" name="fire_kind4" value=0 />&nbsp;&nbsp;消防设施监控操作</span>
					<span style='font-size:1em;' id="fire_kind4_1"><input type="radio" name="fire_kind4" value=1 />&nbsp;&nbsp;消防设施检测维保</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>职业等级</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind5" value=3 />&nbsp;&nbsp;四级/中级工</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind5" value=4 />&nbsp;&nbsp;五级/初级工</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>鉴定分类</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind6" value=0 />&nbsp;&nbsp;初次鉴定</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind6" value=1 />&nbsp;&nbsp;晋级鉴定</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind6" value=2 />&nbsp;&nbsp;补考</span>
				</td>
			</tr>
			<tr id="item_kind7">
				<td align="center" class='table_resume_title' width='16%' height='44px;'>满足资格所属类</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind7" value=0 />&nbsp;&nbsp;...</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind7" value=1 />&nbsp;&nbsp;...</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind7" value=2 />&nbsp;&nbsp;...</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>申报资格(中级)</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=0 />&nbsp;&nbsp;取得本职业五级/初级工职业资格证书（技能等级证书）后，累计从事本职业工作4年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=1 />&nbsp;&nbsp;累计从事本职业工作6年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=2 />&nbsp;&nbsp;取得相关职业五级/初级工职业资格证书（技能等级证书）后，累计从事相关职业工作4年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=3 />&nbsp;&nbsp;累计从事相关职业工作6年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=4 />&nbsp;&nbsp;取的技工学校或相关专业毕业证书（含尚未取得毕业证书的在校应届毕业生）</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=5 />&nbsp;&nbsp;取得经评估论证、以中级技能为培养目标的中等及以上职业学校专业或相关专业毕业证书（含尚未取得毕业证书的在校应届毕业生）</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>申报资格(初级)</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=6 />&nbsp;&nbsp;累计从事本职业工作1年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=7 />&nbsp;&nbsp;本职业学徒期满</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=8 />&nbsp;&nbsp;累计从事相关职业工作1年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=9 />&nbsp;&nbsp;相关职业学徒期满</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='44px;'>*相关职业</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=0 />&nbsp;&nbsp;安全防范设计评估工程技术人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=1 />&nbsp;&nbsp;消防工程技术人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=2 />&nbsp;&nbsp;安全生产管理工程技术人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=3 />&nbsp;&nbsp;安全评价工程技术人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=4 />&nbsp;&nbsp;人民警察</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=5 />&nbsp;&nbsp;保卫管理员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=6 />&nbsp;&nbsp;消防员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=7 />&nbsp;&nbsp;消防指挥员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=8 />&nbsp;&nbsp;消防装备管理员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=9 />&nbsp;&nbsp;消防安全管理员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=10 />&nbsp;&nbsp;消防监督检查员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=11 />&nbsp;&nbsp;森林消防员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=12 />&nbsp;&nbsp;森林火情瞭望观察员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=13 />&nbsp;&nbsp;应急救援员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=14 />&nbsp;&nbsp;物业管理员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=15 />&nbsp;&nbsp;保安员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=16 />&nbsp;&nbsp;智能楼宇管理员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=17 />&nbsp;&nbsp;安全防范系统安装维护员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=18 />&nbsp;&nbsp;机械设备安装工</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=19 />&nbsp;&nbsp;电气设备安装工</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=20 />&nbsp;&nbsp;管工</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=21 />&nbsp;&nbsp;电工</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind8" value=22 />&nbsp;&nbsp;安全员</span>
				</td>
			</tr>
			</table>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>&bull; 注：凡在“申报资格”中选择带有“相关职业”选项的，需要勾选“相关职业”内容。</p></div>
		</div>
	</div>
  </div>
</div>
</body>
