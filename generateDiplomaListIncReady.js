	var generateDiplomaListLong = 0;		//0: 标准栏目  1：短栏目
	var generateDiplomaListChk = 0;

	$(document).ready(function (){
		getComboList("searchGenerateDiplomaCert","v_certificateInfo","certID","shortName","status=0 and mark=1",1);
		
		$("#txtSearchGenerateDiploma").textbox('textbox').css('background','#FFFF00');
		//getGenerateDiplomaList();
	});

	function getGenerateDiplomaList(){
		sWhere = $("#txtSearchGenerateDiploma").textbox("getValue");
		//alert((sWhere) + "&kindID=" + $("#searchGenerateDiplomaCert").combobox("getValue"));
		$.get("diplomaControl.asp?op=getGenerateDiplomaList&where=" + escape(sWhere) + "&kindID=" + $("#searchGenerateDiplomaCert").combobox("getValue") + "&fStart=" + $("#searchGenerateDiplomaStartDate").datebox("getValue") + "&fEnd=" + $("#searchGenerateDiplomaEndDate").datebox("getValue") + "&dk=22&times=" + (new Date().getTime()),function(data){
			// jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#generateDiplomaCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='generateDiplomaTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='15%'>证书名称</th>");
			arr.push("<th width='6%'>数量</th>");
			arr.push("<th width='6%'>样式</th>");
			arr.push("<th width='16%'>编号范围</th>");
			arr.push("<th width='8%'>打印日期</th>");
			arr.push("<th width='8%'>发放日期</th>");
			arr.push("<th width='20%'>说明</th>");
			arr.push("<th width='10%'>证书制作</th>");
			arr.push("<th width='4%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/printer1.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + ar1[0] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showGenerateDiplomaInfo1(\"" + ar1[0] + "\",0,0,0,\"\",0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[21] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + " ~ " + ar1[9] + "</td>");
					arr.push("<td class='left'>" + ar1[14] + "</td>");
					arr.push("<td class='left'>" + ar1[16] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + ar1[12] + "</td>");
					if(ar1[7]==''){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'><a href='/users" + ar1[7] + "?t=" + (new Date().getTime()) + "' target='_blank'>" + imgChk + "</a></td>");
						// arr.push("<td class='center'><a href='javascript:showDiplomaCards(\"" + ar1[0] + "," + currHost + "\");'>" + imgChk + "</a></td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#generateDiplomaCover").html(arr.join(""));
			arr = [];
			$('#generateDiplomaTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"iDisplayLength": 30,
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
