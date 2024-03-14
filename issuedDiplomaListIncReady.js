	var issuedDiplomaListLong = 0;		//0: 标准栏目  1：短栏目
	var issuedDiplomaListChk = 0;

	$(document).ready(function (){
		var w = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchIssuedDiplomaHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			$("#issuedDiplomaListLongItem2").hide();
		}else{
			getComList("searchIssuedDiplomaHost","hostInfo","hostNo","title",w,0);
			$("#issuedDiplomaListLongItem1").hide();
			getComList("searchIssuedDiplomaDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchIssuedDiplomaHost").val() + "' and pID=0)",1);
		}
		
		getComList("searchIssuedDiplomaKind","v_certificateInfo","certID","certName","status=0 and host='" + currHost + "' order by certName",1);
		getDicList("statusNo","searchIssuedDiplomaIssued",1);
		$("#searchIssuedDiplomaStartDate").click(function(){WdatePicker();});
		$("#searchIssuedDiplomaEndDate").click(function(){WdatePicker();});
		
		$("#btnsearchIssuedDiploma").click(function(){
			getIssuedDiplomaList();
		});
		
		$("#btnIssuedDiplomaSel").click(function(){
			setSel("visitstockchkIssued");
		});
		
		$("#txtsearchIssuedDiploma").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtsearchIssuedDiploma").val()>""){
					getIssuedDiplomaList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		$("#btnIssuedDiplomaIssue").click(function(){
			getSelCart("visitstockchkIssued");
			if(selCount==0){
				jAlert("请选择要发放证书的清单。");
				return false;
			}
			jConfirm("确定要发放证书(" + selCount + "个)吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					//jAlert(selList);
					$.get("diplomaControl.asp?op=issueDiploma&host=" + $("#searchIssuedDiplomaHost").val() + "&kindID=0&item=" + selList ,function(data){
						if(data>""){
							jAlert("证书发放成功。");
							getIssuedDiplomaList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});

		if(!checkPermission("diplomaAdd")){
			$("#btnIssuedDiplomaIssue").hide();
		}
		
		$("#searchIssuedDiplomaIssued").val(0);
		//getIssuedDiplomaList();
	});

	function getIssuedDiplomaList(){
		sWhere = $("#txtsearchIssuedDiploma").val();
		//alert((sWhere) + "&kindID=" + $("#searchIssuedDiplomaKind").val() + "&status=" + $("#searchIssuedDiplomaStatus").val() + "&host=" + $("#searchIssuedDiplomaHost").val() + "&fStart=" + $("#searchIssuedDiplomaStartDate").val() + "&fEnd=" + $("#searchIssuedDiplomaEndDate").val());
		$.get("diplomaControl.asp?op=getDiplomaList&where=" + escape(sWhere) + "&kindID=" + $("#searchIssuedDiplomaKind").val() + "&host=" + $("#searchIssuedDiplomaHost").val() + "&refID=" + $("#searchIssuedDiplomaDept").val() + "&issuedStartDate=" + $("#searchIssuedDiplomaStartDate").val() + "&issuedEndDate=" + $("#searchIssuedDiplomaEndDate").val() + "&keyID=" + $("#searchIssuedDiplomaIssued").val() + "&dk=24&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#issuedDiplomaCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='issuedDiplomaTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='15%'>身份证</th>");
			arr.push("<th width='8%'>姓名</th>");
			arr.push("<th width='16%'>证书名称</th>");
			arr.push("<th width='14%'>证书编号</th>");
			if(currHost==""){
				arr.push("<th width='18%'>公司</th>");
			}else{
				arr.push("<th width='18%'>部门</th>");
			}
			arr.push("<th width='10%'>发放日期</th>");
			arr.push("<th width='8%'>发放</th>");
			arr.push("<th width='5%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					h = ar1[13];	//公司用户显示部门1名称
					if(ar1[9]>=55){c = 2;}	//55岁红色
					if(currHost==""){h = ar1[12];}	//系统用户显示公司名称
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showDiplomaInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					if(currHost==""){
						arr.push("<td class='left'>" + ar1[13] + "</td>");
					}else{
						arr.push("<td class='left'>" + ar1[14] + "</td>");
					}
					arr.push("<td class='left'>" + ar1[26] + "</td>");
					if(ar1[25]==0){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'>" + imgChk + "</td>");
					}
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkIssued'>" + "</td>");
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#issuedDiplomaCover").html(arr.join(""));
			arr = [];
			$('#issuedDiplomaTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"iDisplayLength": 100,
				"bInfo": true,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}
	