	//path: 签名文件 p: 1 打印学历证明 0 不打印  k: 1 打印从事特种作业情况说明（在职证明） 0 不打印  s: 1 打印身份证 0 不打印
	function getMaterials(username,path,p,k,s){
		$.getJSON(uploadURL + "/public/getStudentMaterials?username=" + username + "&IDcard=0",function(data){
			//jAlert(unescape(data));
			var c = 0;
			var i = 0;
			var idc = 0;
			$("#materialsCover").empty();
			var arr = new Array();
			if(data.length>0){
				arr.push('<div style="float:left;width:100%;">');
				arr.push('<table style="margin-top:10mm;width:100%;">');
				$.each(data,function(iNum,val){
					if(s==1 && (val["kindID"]==1 || val["kindID"]==2)){	//身份证正反面
						i += 1;
						idc += 1;
						if(idc==1){
							arr.push('<div style="page-break-after:always">&nbsp;</div>');
						}
						arr.push('<tr>');
						arr.push('<td align="center" style="width:100%;">');
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:300px;max-height:300px;padding-top:20px;">');
						arr.push('</td>');
						arr.push('</tr>');
					}
					if(p==1 && val["kindID"]==3){	//学历证明
						c = 1;
						i += 1;
						arr.push('<div style="page-break-after:always">&nbsp;</div>');
						arr.push('<tr>');
						arr.push('<td align="center" style="width:100%;">');
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:450px;max-height:400px;padding-top:20px;">');
						arr.push('</td>');
						arr.push('</tr>');
					}
					if(k==1 && val["kindID"]==5){	//在职证明
						i += 1;
						arr.push('<div style="page-break-after:always">&nbsp;</div>');
						arr.push('<tr>');
						arr.push('<td align="center" style="width:100%;">');
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:450px;max-height:600px;padding-top:20px;">');
						arr.push('</td>');
						arr.push('</tr>');
					}
				});
				arr.push('</table>');
				arr.push('</div>');
				if(path>"" && (idc>1 || c==1)){
					arr.push('<div style="position: relative;width:100%;height:100%;">');
					if(idc>1){
						//身份证签字
						arr.push('<div style="position: absolute; z-index:20;">');
						arr.push('<div style="float:left;">');
						arr.push('	<span><img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:90px;margin:0px 0px 0px 537px;padding-left:0px;padding-top:200px;"></span>');
						arr.push('</div>');
						arr.push('</div>');
						arr.push('<div style="position: absolute; z-index:40;">');
						arr.push('<div style="float:left;">');
						arr.push('	<span><img src="images/sign_stamp.png" style="width:150px;margin:0px 0px 0px 457px;padding-left:0px;padding-top:170px;opacity:0.7;"></span>');
						arr.push('</div>');
						arr.push('</div>');
					}
					if(c==1){
						//学历证明签字
						arr.push('<div style="position: absolute; z-index:10;">');
						arr.push('<div style="float:left;">');
						arr.push('	<span><img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:90px;margin:-200px 0px 0px 580px;padding-left:0px;padding-top:850px;"></span>');
						arr.push('</div>');
						arr.push('</div>');
						arr.push('<div style="position: absolute; z-index:40;">');
						arr.push('<div style="float:left;">');
						arr.push('	<span><img src="images/sign_stamp.png" style="width:150px;margin:-200px 0px 0px 500px;padding-left:0px;padding-top:820px;opacity:0.7;"></span>');
						arr.push('</div>');
						arr.push('</div>');
					}
					arr.push('</div>');
				}
				// if(path>"" && c==1){
				// 	//学历证明签字
				// 	arr.push('<div style="position: relative;">');
				// 	arr.push('<div style="position: absolute; z-index:10;">');
				// 	arr.push('<div style="float:left;">');
				// 	arr.push('	<span><img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:90px;margin:-200px 0px 0px 580px;padding-left:0px;padding-top:25px;"></span>');
				// 	arr.push('</div>');
				// 	arr.push('</div>');
				// 	arr.push('<div style="position: absolute; z-index:40;">');
				// 	arr.push('<div style="float:left;">');
				// 	arr.push('	<span><img src="images/sign_stamp.png" style="width:150px;margin:-200px 0px 0px 500px;padding-left:0px;padding-top:0px;opacity:0.7;"></span>');
				// 	arr.push('</div>');
				// 	arr.push('</div>');
				// 	arr.push('</div>');
				// }
				if(i>0){
					$("#materialsCover").html(arr.join(""));
				}
			}
		});
	}
