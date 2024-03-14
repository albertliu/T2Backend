	var diplomalastListLong = 0;		//0: 标准栏目  1：短栏目
	var diplomalastListChk = 0;

	$(document).ready(function (){
		var www = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchDiplomaLastHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			$("#diplomalastListLongItem2").hide();
		}else{
			getComList("searchDiplomaLastHost","hostInfo","hostNo","title",www,0);
			$("#diplomalastListLongItem1").hide();
			setDiplomaLastDeptList();
		}
		
		getComList("searchDiplomaLastKind","v_certificateInfo","certID","certName","status=0 and (host='" + currHost + "' or host='') order by certName",1);
		getDicList("statusExpire","searchDiplomaLastStatus",1);
		$("#searchDiplomaLastStartDate").click(function(){WdatePicker();});
		$("#searchDiplomaLastEndDate").click(function(){WdatePicker();});
		
		$("#btnSearchDiplomaLast").click(function(){
			getDiplomaLastList();
		});
		
		$("#txtSearchDiplomaLast").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchDiplomaLast").val()>""){
					getDiplomaLastList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		$("#searchDiplomaLastHost").change(function(){
			setDiplomaLastDeptList();
		});
		
		$("#searchDiplomaLastStartDate").val(currDate);
		$("#searchDiplomaLastEndDate").val(addDays(currDate,30));
		$("#searchDiplomaLastWarning").change(function(){
			if($("#searchDiplomaLastWarning").attr("checked")){
				$("#searchDiplomaLastStartDate").val(currDate);
				$("#searchDiplomaLastEndDate").val(addDays(currDate,30));
			}else{
				$("#searchDiplomaLastStartDate").val('');
				$("#searchDiplomaLastEndDate").val('');
			}
			getDiplomaLastList();
		});

		setDiplomaLastDeptList();
	});

	function getDiplomaLastList(){
		sWhere = $("#txtSearchDiplomaLast").val();
		//alert((sWhere) + "&kindID=" + $("#searchDiplomaLastKind").val() + "&status=" + $("#searchDiplomaLastStatus").val() + "&host=" + $("#searchDiplomaLastHost").val() + "&fStart=" + $("#searchDiplomaLastStartDate").val() + "&fEnd=" + $("#searchDiplomaLastEndDate").val());
		$.get("diplomaControl.asp?op=getDiplomaLastList&where=" + escape(sWhere) + "&kindID=" + $("#searchDiplomaLastKind").val() + "&status=" + $("#searchDiplomaLastStatus").val() + "&host=" + $("#searchDiplomaLastHost").val() + "&refID=" + $("#searchDiplomaLastDept").val() + "&fStart=" + $("#searchDiplomaLastStartDate").val() + "&fEnd=" + $("#searchDiplomaLastEndDate").val() + "&dk=23&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#diplomalastCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='diplomalastTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='13%'>身份证</th>");
			arr.push("<th width='7%'>姓名</th>");
			arr.push("<th width='7%'>性别</th>");
			arr.push("<th width='7%'>年龄</th>");
			arr.push("<th width='13%'>证书名称</th>");
			arr.push("<th width='12%'>证书编号</th>");
			if(currHost==""){
				arr.push("<th width='12%'>公司</th>");
			}else{
				arr.push("<th width='12%'>部门</th>");
			}
			arr.push("<th width='9%'>有效期</th>");
			arr.push("<th width='5%'>状态</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
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
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					if(currHost==""){
						arr.push("<td class='left'>" + ar1[13] + "</td>");
					}else{
						arr.push("<td class='left'>" + ar1[14] + "</td>");
					}
					arr.push("<td class='left'>" + ar1[17] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#diplomalastCover").html(arr.join(""));
			arr = [];
			$('#diplomalastTab').dataTable({
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

	function setDiplomaLastDeptList(){
		//alert($("#searchDiplomaHost").val() + ":" + currDeptID);
		if($("#searchDiplomaLastHost").val() > ""){
			if(currDeptID > 0){
				getComList("searchDiplomaLastDept","deptInfo","deptID","deptName","deptID=" + currDeptID,0);
			}else{
				getComList("searchDiplomaLastDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchDiplomaLastHost").val() + "' and pID=0)",1);
			}
		}
	}
	