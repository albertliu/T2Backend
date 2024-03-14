	//path: 签名文件 p: 1 打印学历证明 0 不打印  k: 1 打印从事特种作业情况说明（在职证明） 0 不打印  s: 1 打印身份证 0 不打印
	function getMaterials3(username,path,p,k,s,d){
		$.getJSON(uploadURL + "/public/getStudentMaterials?username=" + username + "&IDcard=0",function(data){
			//jAlert(unescape(data));
			var c = 0;
			var i = 0;
			$("#materialsCover3").empty();
			var arr = new Array();
			if(data.length>0){
				if(d!=1){	//页面打印keyID=1
					arr.push('<div style="page-break-after:always">&nbsp;</div>');
				}
				arr.push('<div style="float:left;width:100%;text-align:center;">');
				$.each(data,function(iNum,val){
					if(p==1 && (val["kindID"]==3)){	//学历证明
						i += 1;
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:450px;max-height:400px;padding-top:20px;">');
					}
				});
				arr.push('</div>');
				if(i>0){
					if(path>""){
						//学历证明签字
						arr.push('<div style="position: relative;width:100%;height:100%;">');
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
					$("#materialsCover3").html(arr.join(""));
				}
			}
		});
	}
