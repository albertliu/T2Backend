
	function getAgreement(username,name,course,path,signDate,price,unit,host){
		var arr = new Array();
		if(keyID==4 || keyID==2){
			arr.push('<div style="page-break-after:always">&nbsp;</div>');
		}
		arr.push('<div>');
		arr.push('	<div style="text-align:center; margin:20px 0 20px 0;"><h2 style="font-size:1.7em;">培训协议书</h2></div>');
		arr.push('</div>');
		arr.push('<div style="float:left;width:100%;">');
		arr.push('	<table style="width:100%; padding-left:10px;margin-top:25px;">');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><div><span class="agreep" style="padding-left:20px;">甲方：' + unit + '</span><span class="agreep" style="padding-left:100px;">乙方：' + name + '</span></div></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">明确甲乙双方的义务，经平等、自愿、协商签订本“培训协议书”。具体约定如下：</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">1、乙方[' + name + ']身份证号[' + username + ']，自主选择[' + course + ']培训项目，培训价格为' + price + '元（包括培训费、教材资料费、考试费）。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">2、该培训项目实行考培分离制度，学校（甲方）负责培训，考试由甲方向相关鉴定机构申报考试。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">3、乙方知晓职业培训报名考试的相关政策，如因各种原因不能及时开班或考试，导致证件过期或其他结果，甲方对于复审过期产生的后果不负任何责任。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">4、乙方在报名表上填写的各项报名信息必须正确（特别是手机号要正确）需本人亲自签名确认，如因以上信息错误造成差错的责任由乙方承担。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">5、乙方必须关注对应项目培训微信群内的信息，如因未关注培训微信群信息而请成差错的责任由乙方承担。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">6、培训和考试按照甲方通知参加培训和考试，乙方确认参加考试后不能缺考，如乙方因个人原因未按期参加考试，就是自动放弃考试机会。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">7、乙方参加培训和考试，应遵从所在地的管理规定，规范停车、在指定场所吸烟。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">8、课时按照甲方要求，除了参加线下课程外，还要进行线上课程的学习，达不到课时要求的，甲方将不安排乙方参加考试。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p class="agreep">9、本协议一式一份，甲、乙双方各执一份，乙方在签字前应认真阅读本协议各项条数内容本协议一经签字立即生效。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:50px;"></p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td  style="height:50px; width:60%;"><p class="agreep">甲方（盖章）：' + unit + '</p></td>');
		arr.push('			<td  style="height:50px; width:40%;"><p style="font-size:1.3em;">乙方（签字）：</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td style="height:50px;"><p style="font-size:1.3em;text-indent:50px;"></p></td>');
		arr.push('			<td></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td style="height:30px;"><p style="font-size:1.3em;text-indent:50px;">日&nbsp;&nbsp;&nbsp;&nbsp;期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + signDate + '</p></td>');
		arr.push('			<td style="height:30px;"><p style="font-size:1.3em;">日&nbsp;&nbsp;&nbsp;&nbsp;期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + signDate + '</p></td>');
		arr.push('		</tr>');
		arr.push('	</table>');
		arr.push('</div>');
		if(path>""){
			//alert(path);
			arr.push('<div style="position: relative;width:100%;height:80%;">');
			arr.push('<div style="position: absolute; z-index:10;">');
			arr.push('<div style="float:left;">');
			arr.push('	<span><img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:200px;margin:0px 0px 8px 500px;padding-left:80px;padding-top:795px;"></span>');
			arr.push('</div>');
			arr.push('</div>');
			arr.push('<div style="position: absolute; z-index:10;">');
			arr.push('<div style="float:left;">');
			arr.push('	<span><img src="/users/upload/companies/stamp/' + host + '.png" style="width:200px;margin:0px 0px 8px 50px;padding-left:30px;padding-top:770px;opacity:0.7;"></span>');
			arr.push('</div>');
			arr.push('</div>');
			arr.push('</div>');
		}
		/**/
		$("#agreementCover").html(arr.join(""));
	}
