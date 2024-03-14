	var certListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getComboBoxList("statusEffect","searchCertStatus",1);
        getComboList("searchCertAgency","agencyInfo","agencyID","agencyName","status=0 order by agencyID",1);
 
		$("#txtSearchCert").textbox('textbox').css('background','#FFFF00');
		
		$("#btnSearchCertAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				showCertInfo(0,0,1,1);	//showCertInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
			}
		});
		
		$("#searchCertAgency").combobox({
			onChange:function() {
				getCertList();
			}
		});
		
		if(checkPermission("courseAdd")){
			$("#btnAddCert").show();
		}else{
			$("#btnAddCert").hide();
		}/**/
	});

	function getCertList(){
		sWhere = $("#txtSearchCert").textbox("getValue");
		//alert((sWhere) + "&kindID=" + $("#searchCertKind").val() + "&status=" + $("#searchCertStatus").val() + "&agency=" + $("#searchCertAgency").val());
		$.get("certControl.asp?op=getCertList&where=" + escape(sWhere) + "&status=" + $("#searchCertStatus").combobox("getValue") + "&agency=" + $("#searchCertAgency").combobox("getValue") + "&dk=14&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#certCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='certTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='9%'>编号</th>");
			arr.push("<th width='22%'>证书名称</th>");
			arr.push("<th width='22%'>发证机构</th>");
			arr.push("<th width='9%'>期限</th>");
			arr.push("<th width='9%'>状态</th>");
			arr.push("<th width='9%'>备注</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			var mNew = "";
			var imgChk = "<img src='images/green_check.png'>";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showCertInfo(" + ar1[0] + ",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "年</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#certCover").html(arr.join(""));
			arr = [];
			$('#certTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100],
				"iDisplayLength": 50,
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

	
	