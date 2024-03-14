<!--#include file="js/doc1.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title></title>
<meta name="viewport" content="width=device-width">

<!--必要样式-->
<link href="css/style_inner1.css?ver=1.2"  rel="stylesheet" type="text/css" id="css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>


<script language="javascript">
	var nodeID = 0;
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
	var kindID = "";
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";  //enterID
		$.ajaxSetup({ 
			async: false 
		}); 
		//$("#test").html(refID);
		$("#item_kind7").hide();
		$("input[name='fire_kind5']").change(function(){
			setKind4();
		});
		getNodeInfo(nodeID);
	});

	function getNodeInfo(id){
		$.getJSON(uploadURL + "/public/getFiremanEnterInfo?refID=" + id,function(re){
			//jAlert(unescape(data));
			var ar = re;
			if(ar > ""){
				$("#SNo").html(ar["SNo"]);
				$("#courseName").html(ar["courseName"]);
				$("#missingItems").html("缺项：" + ar["missingItems"]);
				$("#fire_area").val(ar["area"]);
				$("#fire_address").val(ar["address"]);
				$("#fire_employDate").val(ar["employDate"]);
				$("#fire_university").val(ar["university"]);
				$("#fire_gradeDate").val(ar["gradeDate"]);
				$("#fire_profession").val(ar["profession"]);
				$("#fire_area_now").val(ar["area_now"]);
				$("input[name='fire_kind1'][value=" + ar["kind1"] + "]").attr("checked",true);
				$("input[name='fire_kind2'][value=" + ar["kind2"] + "]").attr("checked",true);
				$("input[name='fire_kind3'][value=" + ar["kind3"] + "]").attr("checked",true);
				$("input[name='fire_kind4'][value=" + ar["kind4"] + "]").attr("checked",true);
				$("input[name='fire_kind5'][value=" + ar["kind5"] + "]").attr("checked",true);
				$("input[name='fire_kind6'][value=" + ar["kind6"] + "]").attr("checked",true);
				$("input[name='fire_kind7'][value=" + ar["kind7"] + "]").attr("checked",true);
				$("input[name='fire_kind8'][value=" + ar["kind8"] + "]").attr("checked",true);
				$("input[name='fire_kind9'][value=" + ar["kind9"] + "]").attr("checked",true);
				$("input[name='fire_kind10'][value=" + ar["kind10"] + "]").attr("checked",true);
				$("input[name='fire_kind11'][value=" + ar["kind11"] + "]").attr("checked",true);
				$("input[name='fire_kind12'][value=" + ar["kind12"] + "]").attr("checked",true);
				$("#fire_memo").val(ar["memo"]);
				$("#username").html(ar["username"]);
				$("#name").html(ar["name"]);
				$("#mobile").html(ar["mobile"]);
				$("#sexName").html(ar["sexName"]);
				$("#age").html(ar["age"]);
				$("#birthday").html(ar["birthday"]);
				$("#unit").html(ar["unit"]);
				$("#ethnicity").html(ar["ethnicity"]);
				$("#IDaddress").html(ar["IDaddress"]);
				if(ar["photo_filename"] > ""){
					$("#img_photo").attr("src","/users" + ar["photo_filename"]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
				}
				kindID = ar["certID"];
				setKind4();
			}
		});
		//setSession("public",0);
	}

	function setKind4(){
		if($("input[name='fire_kind5']:checked").val()==1){
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
</script>

</head>

<body>

<div>	
	
	<div style="width:92%;float:left;margin:10mm;">
		<div style="text-align:center;">
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>全国消防行业职业技能鉴定报名表</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em;'>学员编号：</span><span style='font-size:1.2em;' id="SNo"></span><span style='font-size:1.2em;padding-left:30px;' id="missingItems"></span></div>
			<table class='table_resume' style='width:99%;'>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>姓名</td><td align="center" width='32%'><p style='font-size:1em;' id="name"></p></td>
				<td align="center" class='table_resume_title' width='16%'>性别</td><td align="center" width='16%'><p style='font-size:1em;' id="sexName"></p></td>
				<td rowspan="4" align="center" class='table_resume_title' width='20%'>
					<img id="img_photo" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>身份证号</td><td align="center"><p style='font-size:1em;' id="username"></p></td>
				<td align="center" class='table_resume_title' width='16%'>出生日期</td><td class='table_resume_title'><p style='font-size:1em;' id="birthday"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>年龄</td><td align="center" width='20%'><p style='font-size:1em;' id="age"></p></td>
				<td align="center" class='table_resume_title' width='16%'>民族</td><td align="center"><p style='font-size:1em;' id="ethnicity"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>人员属性</td><td align="left">
					<span style='font-size:1em;'><input type="radio" name="fire_kind1" value=0 />&nbsp;&nbsp;社会人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind1" value=1 />&nbsp;&nbsp;专职消防人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind1" value=2 />&nbsp;&nbsp;综合性消防救援队伍人员</span>
				</td>
				<td align="center" class='table_resume_title' width='16%'>户口所在地</td><td class='table_resume_title'><input type="text" id="fire_area" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>政治面貌</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind2" value=0 />&nbsp;&nbsp;中国共产党党员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind2" value=1 />&nbsp;&nbsp;民主党派人士</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind2" value=2 />&nbsp;&nbsp;群众</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>身份证地址</td><td align="center" colspan="4"><p style='font-size:1em;' id="IDaddress"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>在职情况</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind11" value=0 />&nbsp;&nbsp;在职人员</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind11" value=1 />&nbsp;&nbsp;待业人员</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;'>工作单位</td><td align="center" colspan="2"><p style='font-size:1em;' id="unit"></p></td>
				<td align="center" class='table_resume_title'>参加工作时间</td><td align="center"><input type="text" id="fire_employDate" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>从事职业</td><td align="center" colspan="4">
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
				<td align="center" class='table_resume_title' width='16%' height='45px;'>所在学校</td><td align="center"><input type="text" id="fire_university" style="width:100%;" /></td>
				<td align="center" class='table_resume_title'>学校类型</td><td align="center" colspan="2">
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=0 />&nbsp;&nbsp;普通高等学校</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=1 />&nbsp;&nbsp;高级技校</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=2 />&nbsp;&nbsp;技校</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=3 />&nbsp;&nbsp;技师学院</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind3" value=4 />&nbsp;&nbsp;其他</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>学历</td><td align="center" colspan="2">
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
				<td align="center" class='table_resume_title' width='16%' height='45px;'>专业名称</td><td align="center" colspan="4"><input type="text" id="fire_profession" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>手机号码</td><td align="center"><p style='font-size:1em;' id="mobile"></p></td>
				<td align="center" class='table_resume_title'>常住地市</td><td align="center" colspan="2"><input type="text" id="fire_area_now" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>详细地址</td><td align="center" colspan="4"><input type="text" id="fire_address" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>报考工种</td><td align="center" colspan="4"><p style='font-size:1em;' id="courseName"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>职业方向</td><td align="left" colspan="4">
					<span style='font-size:1em;' id="fire_kind4_0"><input type="radio" name="fire_kind4" value=0 />&nbsp;&nbsp;消防设施监控操作</span>
					<span style='font-size:1em;' id="fire_kind4_1"><input type="radio" name="fire_kind4" value=1 />&nbsp;&nbsp;消防设施检测维保</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>职业等级</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind5" value=3 />&nbsp;&nbsp;四级/中级工</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind5" value=4 />&nbsp;&nbsp;五级/初级工</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>鉴定分类</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind6" value=0 />&nbsp;&nbsp;初次鉴定</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind6" value=1 />&nbsp;&nbsp;晋级鉴定</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind6" value=2 />&nbsp;&nbsp;补考</span>
				</td>
			</tr>
			<tr id="item_kind7">
				<td align="center" class='table_resume_title' width='16%' height='45px;'>满足资格所属类</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind7" value=0 />&nbsp;&nbsp;...</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind7" value=1 />&nbsp;&nbsp;...</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind7" value=2 />&nbsp;&nbsp;...</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>申报资格(中级)</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=0 />&nbsp;&nbsp;取得本职业五级/初级工职业资格证书（技能等级证书）后，累计从事本职业工作4年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=1 />&nbsp;&nbsp;累计从事本职业工作6年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=2 />&nbsp;&nbsp;取得相关职业五级/初级工职业资格证书（技能等级证书）后，累计从事相关职业工作4年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=3 />&nbsp;&nbsp;累计从事相关职业工作6年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=4 />&nbsp;&nbsp;取的技工学校或相关专业毕业证书（含尚未取得毕业证书的在校应届毕业生）</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=5 />&nbsp;&nbsp;取得经评估论证、以中级技能为培养目标的中等及以上职业学校专业或相关专业毕业证书（含尚未取得毕业证书的在校应届毕业生）</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>申报资格(初级)</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=6 />&nbsp;&nbsp;累计从事本职业工作1年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=7 />&nbsp;&nbsp;本职业学徒期满</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=8 />&nbsp;&nbsp;累计从事相关职业工作1年（含）以上</span>
					<span style='font-size:1em;'><input type="radio" name="fire_kind9" value=9 />&nbsp;&nbsp;相关职业学徒期满</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>*相关职业</td><td align="left" colspan="4">
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
