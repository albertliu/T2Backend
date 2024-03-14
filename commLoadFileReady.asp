
		document.getElementById("lightLoadFile").style.display="none";
		document.getElementById("fadeLoadFile").style.display="none";

		var commw1 = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("commLoadFileHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			$("#commLoadFileHost").val("znxf");
		}else{
			getComList("commLoadFileHost","hostInfo","hostNo","title",commw1,0);
		}

		$("#restore").click(function(){
			if($("#commLoadFileHost").val()==""){
				alert("请选择一个公司。");
				return false;
			}
            var form = new FormData(document.getElementById("formUpload"));
			var key = $("input[name='uploadKind']:checked").val();
			var act = action + "?upID=" + key + "&username=" + username + "&currUser=" + currUser + "&host=" + $("#commLoadFileHost").val() + "&commMark=" + commMark + "&para=" + para;
            $.ajax({
                url: act,
                type:"post",
                data:form,
                processData:false,
                contentType:false,
                success:function(data){
					if(key == "check_student_list"){
						//学员信息核对，返回结果列表excel
						if(data.file>""){
							asyncbox.alert("核对结果已生成 <a href='" + data.file + "' target='_blank'>下载文件</a>",'核对完成',function(action){
							　　//alert 返回action 值，分别是 'ok'、'close'。
							　　if(action == 'ok'){
							　　}
							　　if(action == 'close'){
							　　　　//alert('close');
							　　}
							});
						}else{
							alert("没有可供处理的数据。");
						}
					}else{
						var msg = data.msg;
						if(msg == ""){
							if(data.count>0){
								msg = "成功上传" + data.count + "个文件。";
							}else{
								msg = "没有上传有效文件。\n";
							}
							if(data.err_msg > ""){
								msg += data.err_msg;
							}
							if(data.exist_msg > ""){
								msg += data.exist_msg;
							}
							alert(msg, "上传结果");
						}else{
							alert(msg, "上传结果");
						}
					}
					if(commMark != "mulitple"){
						document.getElementById("lightLoadFile").style.display="none";
						document.getElementById("fadeLoadFile").style.display="none";
						getNodeInfo(nodeID);
					}
	                updateCount += 1;
                },
                error:function(e){
					document.getElementById("lightLoadFile").style.display="none";
					document.getElementById("fadeLoadFile").style.display="none";
					getNodeInfo(nodeID);
					//alert(e);
                }
            });        
		});

