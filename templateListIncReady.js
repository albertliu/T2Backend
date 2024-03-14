	var TemplateListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getComboBoxList("statusEffect","searchTemplateStatus",1);
		$("#txtSearchTemplate").textbox('textbox').css('background','#FFFF00');
	});

	function getTemplateList(){
		sWhere = $("#txtSearchTemplate").textbox("getValue");
		//alert((sWhere) + "&kindID=" + $("#searchTemplateKind").val() + "&status=" + $("#searchTemplateStatus").val() + "&agency=" + $("#searchTemplateAgency").val());
		$.get("hostControl.asp?op=getTemplateList&where=" + escape(sWhere) + "&status=" + $("#searchTemplateStatus").combobox("getValue") + "&dk=15&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#templateCover").empty();
			floatSum = "";
			arr = [];			
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='TemplateTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='25%'>文档标题</th>");
			arr.push("<th width='20%'>备注</th>");
			arr.push("<th width='6%'>状态</th>");
			arr.push("<th width='6%'>登记日期</th>");
			arr.push("<th width='6%'>登记人</th>");
			arr.push("<th width='6%'>下载</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					arr.push("<td class='left'><a href='" + ar1[4] + "?&times=" + (new Date().getTime()) + " target='_blank'>" + imgFile + "</a></td>");
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
			$("#templateCover").html(arr.join(""));
			arr = [];
			$('#TemplateTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100],
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

	
	