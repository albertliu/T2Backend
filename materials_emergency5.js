	//path: 签名文件 p: 1 打印学历证明 0 不打印  k: 1 打印从事特种作业情况说明（在职证明） 0 不打印  s: 1 打印身份证 0 不打印
	function getMaterials5(username,path,p,k,s,d){
		$.getJSON(uploadURL + "/public/getStudentMaterials?username=" + username + "&IDcard=0",function(data){
			//jAlert(unescape(data));
			var c = 0;
			var i = 0;
			$("#materialsCover5").empty();
			var arr = new Array();
			if(data.length>0){
				if(d!=1){	//页面打印keyID=1
					arr.push('<div style="page-break-after:always">&nbsp;</div>');
				}
				arr.push('<div style="float:left;width:100%;text-align:center;">');
				$.each(data,function(iNum,val){
					if(k==1 && val["kindID"]==5){	//在职证明
						i += 1;
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:450px;max-height:600px;padding-top:20px;">');
					}
				});
				arr.push('</div>');
				if(i>0){
					$("#materialsCover5").html(arr.join(""));
				}
			}
		});
	}
