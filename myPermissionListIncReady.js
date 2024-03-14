	var permissionListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		if(permissionListLong == 0){
			$("#permissionListLongItem1").show();
		}else{
			$("#permissionListLongItem1").hide();
		}
		
		getPermissionListByUser();
	});

	function getPermissionListByUser(){
		//alert("<%=nodeID%>");
		$.get("permissionControl.asp?op=getPermissionListByUser&userID=" + "<%=nodeID%>" + "&dk=101&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#permissionCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='permissionTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='15%'>代码</th>");
			arr.push("<th width='25%'>权限名称</th>");
			arr.push("<th width='45%'>权限范围</th>");
			if(permissionListLong == 0){
				arr.push("<th width='10%'>操作</th>");
			}
			if(permissionListLong == 1){
				arr.push("<th width='10%'>选择</th>");
			}
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='5%' class='center'>" + i + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='25%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='45%' class='left'>" + ar1[4] + "</td>");
					if(permissionListLong == 0){
						arr.push("<td width='10%' class='left'>&nbsp;</td>");
					}
					if(permissionListLong == 1){
						var p = ar1[0] + "|" + ar1[1] + "|" + ar1[3] + "|" + ar1[4];
						arr.push("<td width='10%' class='link1'>" + "<a href='javascript: pickupPermission(\"" + p + "\");'><img src='images/hand.png' border='0'></a></td>");
					}
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
			if(permissionListLong == 0){
				arr.push("<th>&nbsp;</th>");
			}
			if(permissionListLong == 1){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#permissionCover").html(arr.join(""));
			arr = [];
			$('#permissionTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currPermissionName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}

	function pickupPermission(p){
		var ar = getSession("myPermissionList").split("|");
		var ar1 = p.split("|");
		if(ar>""){
			$.each(ar,function(iNum,val){
				if(val>""){
					parent.$("#" + val).val(ar1[iNum]);
				}
			});
		}
		parent.$.close("myPermissionList");
	}