
	var need_username = "";

	function getNeed2know(id){
		$.getJSON(uploadURL + "/public/getNeed2knowByEnterID?refID=" + id,function(data){
			var c = "";
			var arr = new Array();
			if(data.length>0){
				var val = data[0];
				arr.push('<div style="page-break-after:always"></div>');
				arr.push('<div style="position: relative;">');
				arr.push('<div style="position: absolute; z-index:10; width:100%;">');
				arr.push('<div style="float:left;width:32%;">');
				arr.push('	<span><img src="/users/upload/companies/logo/znxf.png" style="width:85px;margin:0px 0px 8px 0px;padding-left:20px;"></span>');
				arr.push('	<span><img src="" id="qr-img" style="width:110px;padding-top:8px;padding-left:20px;"></span>');
				arr.push('</div>');
				arr.push('<div style="float:left;width:50%;margin-top:20px;">');
				arr.push('	<div style="text-align:center;margin:8px 0 0 0;"><h3 style="font-size:1.4em;">上海智能消防学校</h2></div>');
				arr.push('	<div style="text-align:center;margin:15px 0 10px 0;"><h2 style="font-size:1.7em;">学员须知</h2></div>');
				arr.push('</div>');
				arr.push('<div style="float:left;width:17%;margin-top:70px;">');
				arr.push('	<div style="text-align:right;padding-right:3px;"><p style="font-size:1.3em;">编号：' + val["SNo"] + '</p></div>');
				arr.push('</div>');
				arr.push('<div style="clear: both;"></div>');
				arr.push('<hr size=1 color="gray">');
				arr.push('<div style="float:left;width:100%;">');
				arr.push('	<table style="width:100%; padding-left:10px;margin-top:25px;">');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">' + val["name"] + '同学，你好！</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;text-indent:30px;">欢迎参加' + val["courseName"] + '培训课程，为顺利完成学习任务，请遵守以下规定：</p></td>');
				arr.push('		</tr>');
				//特种设备操作员有特殊事项
				if(val["certID"]=="C13"){
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">1. 一网通网申报考试成功后，注意每周周初登录查看考试安排。抓紧时间网上学习。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">2. 收到考试通知短信后，注意认真阅读，明确考试时间和地点。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">3. 考试当天带好身份证和一张2吋照片，准时参加考试。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">4. 考试题型：判断题50题、单选题40题、多选题10题，考试时间90分钟。70分合格。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">5. 做题结束交卷时，如提示“再检查一下”，先不要急着交卷，检查一遍试卷后再交卷。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">6. 交卷成功会提示“合格”或“不合格”。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">7. 如果“合格”去底楼大厅办理证书；如果“不合格”去底楼大厅办理补考。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">8. 证书一般在一个月后领取。</p></td>');
					arr.push('		</tr>');
				}else{
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">1. 填写报名表并签字。准备一张  寸照片，背面写上编号、姓名、部门。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">2. 到教室将上述材料一起交给老师审核，并领取教材，开始上课。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">3. 不迟到不早退不大声喧哗，保持环境卫生。</p></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">4. 服从老师安排，有事请及时与老师沟通。</p></td>');
					arr.push('		</tr>');
				}
				arr.push('		<tr>');
				arr.push('			<td class="foot" colspan="4" style="height:30px;"><h3></h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:50px;"><p style="font-size:1.3em;text-indent:30px;">请扫描本页上的二维码，登录在线培训系统，用户名为身份证号码，密码默认为123456(登录后可自己修改)。</p></td>');
				arr.push('		</tr>');
				if(val["missingItems"]>""){
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.6em; text-decoration:underline;">&bull;&nbsp;&nbsp;您尚未填写' + val["missingItems"] + '，请尽快在"个人信息"中补充。否则可能会影响您的学习和证书办理。</p></td>');
					arr.push('		</tr>');
				}
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">&bull;&nbsp;&nbsp;在"我的课程"中，可选择相关课程，进行在线学习和模拟考试。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">&bull;&nbsp;&nbsp;在"个人信息"中，可上传照片、身份证、学历证书等图片。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">&bull;&nbsp;&nbsp;在"我的证书"中，可查看已获得的证书。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">&bull;&nbsp;&nbsp;可在"反馈"中提交反馈信息，老师将及时处理。可在“消息”中查看回复信息。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td class="foot" colspan="4" style="height:30px;"><h3></h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">课程安排：' + val["timetable"] + '</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">培训地点：' + val["classroom"] + '</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="2" style="height:30px;width:30%;"><p style="font-size:1.3em;">班&nbsp;主&nbsp;任：' + val["adviserName"] + '</p></td>');
				arr.push('			<td colspan="2" style="height:30px;width:70%;"><p style="font-size:1.3em;">联系电话：' + val["phone"] + '</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td class="foot" colspan="4" style="height:50px;"><h3></h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td style="width:40%;"><h3></h3></td>');
				arr.push('			<td colspan="3" style="width:60%;height:20px; align:center;"><p style="font-size:1.3em;">上海智能消防学校&nbsp;&nbsp;&nbsp;&nbsp;' + currDate + '</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td style="width:40%;"><h3></h3></td>');
				arr.push('			<td colspan="3" style="width:60%;height:20px; align:center;"><p style="font-size:1.3em;">杨浦区黄兴路158号（长阳创谷）1182幢D103室</p></td>');
				arr.push('		</tr>');
				arr.push('	</table>');
				arr.push('</div>');
				arr.push('</div>');
				arr.push('</div>');
				$("#needCover").html(arr.join(""));
				var text = uploadURL + "/public/get_user_qr?username=" + val["username"] + "&size=4&host=" + val["host"];
				$("#qr-img").attr("src", text);
			}
		});
	}

	function needPrint(){
		$("#need_print").print({
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
			//prepend : "<div style='text-align:center; margin:50px 0 20px 0;'><h3 style='font-size:1.5em;'>" + need_username + "个人简历</h3></div>",
			//Add this on bottom
			append : "<br/>"
		});
	}