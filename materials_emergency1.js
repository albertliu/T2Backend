	//path: 签名文件 p: 1 打印学历证明 0 不打印  k: 1 打印从事特种作业情况说明（在职证明） 0 不打印  s: 1 打印身份证 0 不打印
	function getMaterials1(username,path,p,k,s,d){
		$.getJSON(uploadURL + "/public/getStudentMaterials?username=" + username + "&IDcard=0",function(data){
			//jAlert(unescape(data));
			var c1 = 0;
			var c2 = 0;
			var i = 0;
			$("#materialsCover1").empty();
			var arr = new Array();
			if(data.length>0){
				if(d!=1){	//页面打印keyID=1
					arr.push('<div style="page-break-after:always">&nbsp;</div>');
				}
				arr.push('<div style="float:left;width:100%;text-align:center;">');
				$.each(data,function(iNum,val){
					if(s==1 && (val["kindID"]==1 || val["kindID"]==2)){	//身份证正反面
						c1 += 1;
						i += 1;
						arr.push('	<div><img src="users' + val["filename"] + '?times=' + (new Date().getTime()) + '" style="max-width:300px;max-height:300px;padding-top:20px;"></div>');
					}
					if(p==1 && val["kindID"]==3){	//学历证明
						c2 = 1;
						i += 1;
						arr.push('<tr>');
						arr.push('<td align="center" style="width:100%;">');
						arr.push('	<img src="users' + val["filename"] + '?times=' + (new Date().getTime()) + '" style="max-width:450px;max-height:800px;padding-top:20px;">');
						arr.push('</td>');
						arr.push('</tr>');
					}
				});
				arr.push('</div>');
				if(path > "" && i>0){
					arr.push('<div style="position: relative;width:100%;height:100%;">');
					if(c1>0){
						//身份证签字
						arr.push('<div style="position: absolute; z-index:20;">');
						arr.push('<div style="float:left;">');
						arr.push('	<span><img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:90px;margin:0px 0px 0px 550px;padding-left:0px;padding-top:230px;"></span>');
						arr.push('</div>');
						arr.push('</div>');
						arr.push('<div style="position: absolute; z-index:40;">');
						arr.push('<div style="float:left;">');
						arr.push('	<span><img src="images/sign_stamp.png" style="width:150px;margin:0px 0px 0px 470px;padding-left:0px;padding-top:200px;opacity:0.6;"></span>');
						arr.push('</div>');
						arr.push('</div>');
					}
					if(c2==1){
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
					if(i>0){
						$("#materialsCover1").html(arr.join(""));
					}
				}
			}
		});
	}
