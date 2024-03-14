	//kind: 0 单位  1 个人
	function getCommitment(username,name,course,path,signDate,kind){
		var arr = new Array();
		// arr.push('<div style="page-break-after:always">&nbsp;</div>');
		arr.push('<div style="">');
		arr.push('	<div style="text-align:left;margin:8px 0 0 0;"><h3 style="font-size:1.3em;">附件：复审提交材料</h2></div>');
		arr.push('	<div style="text-align:center; margin:25px 0 20px 0;"><h2 style="font-size:1.7em;">从事特种作业情况说明（' + (kind==0? '单位':'个人') + '）</h2></div>');
		arr.push('</div>');
		arr.push('<div style="float:left;width:100%;">');
		arr.push('	<table style="width:100%; padding-left:10px;margin-top:25px;">');
		arr.push('		<tr>');
		if(kind==0){
			arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;text-indent:30px;line-height:62px;">[' + name + ']为本单位员工，身份证号：[' + username + ']，在我单位从事特种作业[' + course + ']（作业类别）相应工种的工作，该员工按规定参加安全培训，从事特种作业期间未发生拒绝、阻碍安全生产监管监察部门监督检查的行为；未发生违章操作造成严重后果或者未发生2次以上违章行为；未发生安全生产违法行为，并接受过行政处罚；特种作业人员未离开特种作业岗位6个月以上。</p></td>');
		}else{
			arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;text-indent:30px;line-height:50px;">本人姓名[' + name + ']，身份证号：[' + username + ']，取得[' + course + ']（作业类别）特种作业操作资格证，从事相应作业类别的工作。本人按规定参加安全培训，从事特种作业期间未发生拒绝、阻碍安全生产监管监察部门监督检查的行为；未发生违章操作造成严重后果或者未发生2次以上违章行为；未发生安全生产违法行为，并接受过行政处罚；特种作业人员未离开特种作业岗位6个月以上。本人对以上信息的真实性负责。</p></td>');
		}
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;text-indent:50px;">特此证明！</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="4" style="height:80px;"><p style="font-size:1.3em;text-indent:150px;">本人签字：</p></td>');
		arr.push('		</tr>');
		if(kind==0){
			arr.push('		<tr>');
			arr.push('			<td colspan="4" style="height:50px;"><p style="font-size:1.3em;text-indent:150px;">（单位盖章）</p></td>');
			arr.push('		</tr>');
		}
		arr.push('		<tr>');
		if(path>""){
			arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;text-indent:150px;">日&nbsp;&nbsp;&nbsp;&nbsp;期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + signDate + '</p></td>');
		}else{
			arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;text-indent:150px;">日&nbsp;&nbsp;&nbsp;&nbsp;期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</p></td>');
		}
		arr.push('		</tr>');
		arr.push('	</table>');
		arr.push('</div>');
		if(path>""){
			//alert(path);
			arr.push('<div style="position: relative;width:100%;">');
			arr.push('<div style="position: absolute; z-index:10;">');
			arr.push('<div style="float:left;">');
			arr.push('	<span><img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:170px;margin:0px 0px 8px 180px;padding-left:80px;padding-top:330px;"></span>');
			arr.push('</div>');
			arr.push('</div>');
			arr.push('</div>');
		}
		arr.push('<div style="page-break-after:always">&nbsp;</div>');
		$("#commitmentCover").html(arr.join(""));
	}
