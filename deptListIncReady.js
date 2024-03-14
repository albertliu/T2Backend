	var deptListLong = 0;		//0: 标准栏目  1：短栏目
	var deptListChk = 0;
	var deptRoot = 0;

	$(document).ready(function (){
		var w = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchDeptHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		}else{
			getComList("searchDeptHost","hostInfo","hostNo","title",w,1);
			getDeptList(currHost);
		}
		if(!checkPermission("deptAdd")){
			$("#btnMergeDepts").hide();
		}

		$("#searchDeptHost").change(function(){
			getDeptList($("#searchDeptHost").val());
		});

		$("#searchDeptHostIndexByDate").change(function(){
			getDeptList($("#searchDeptHost").val());
		});
		
		$("#btnMergeDepts").click(function(){
			var x = new Array();
			x = $("#tree1").treeview('getChecked');
			if(x.length>1){
				//alert(x[0]['id']);
				var k = x[0]['kindID'];
				var p = x[0]['pID'];
				var n = 0;
				var a = new Array();
				var b = new Array();
				var t = "";
				for(var i in x){
					if(k !== x[i]['kindID'] || p !== x[i]['pID']){
						n += 1;
					}
					if(x[i]["text"].length > t.length){
						t = x[i]["text"];	//deptName
					}
					a.push(x[i]['id']);
					b.push('<li>' + x[i]['text'].replace("*","") + '</li>');
				}
				if(n==0){
					//合并
					t = t.replace("*","");
					jPrompt('请确认合并后的部门名称:<br />', t, '合并确认', function (r) {
						if(r){
							if(t.length<2){
								jAlert("请填写合并后的部门名称");
								return false;
							}
							jConfirm('确定要将以下' + x.length + '个部门合并为[<a style="color:red;">' + t + '</a>]吗？<hr><ul style="color:green;">' + b.join("") + "</ul>", '合并确认', function (z) {
								if(z){
									//alert(r + ":" + a.join(","));
									$.get("deptControl.asp?op=mergeDepts&nodeID=" + a.join(",") + "&item=" + escape(t) + "&times=" + (new Date().getTime()),function(re){
										if(re==0){
											jAlert("合并成功。");
											getDeptList(deptRoot);
										}
									});/**/
								}
							});
						}
					});
				}else{
					jAlert("要合并的部门必须具有相同类别和相同上级部门。");
				}
			}else{
				jAlert("请选择至少2个要合并的部门。");
			}
			
		});
	});

	function getDeptList(host){
		if(host==""){
			host = currHost;
		}
		$.get("deptControl.asp?op=getRootDeptByHost&refID=" + host + "&times=" + (new Date().getTime()),function(re){
			if(re>0){
				deptRoot = host;
				//getDeptList(re);
				if(currDeptID > 0){
					re = currDeptID;
				}
				var idx = 0;
				if($("#searchDeptHostIndexByDate").attr("checked")){idx = 1;}
				var dtree = getDeptTree(re,idx);
				//jAlert(dtree);
				$("#tree1").treeview({
					data: dtree,
					showCheckbox: true,
					onNodeSelected: function(event, data) {
						//alert(data.id);
						showDeptInfo(data.id,data.pID,0,1,host);
					},
					onNodeChecked: function(event, data) {
						//alert(data.id);
					}
				});
			}
		});
	}
	