	var generateStudentListLong = 0;		//0: 标准栏目  1：短栏目
	var generateStudentListChk = 0;

	$(document).ready(function (){
		var w3 = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchGenerateStudentHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		}else{
			getComList("searchGenerateStudentHost","hostInfo","hostNo","title",w3,0);
		}
		$("#searchGenerateStudentStart").click(function(){WdatePicker();});
		$("#searchGenerateStudentEnd").click(function(){WdatePicker();});
		
		$("#btnSearchGenerateStudent").click(function(){
			getGenerateStudentList();
		});
		
		$("#btnGenerateStudentAdd").click(function(){
			showGenerateStudentInfo(0,0,1,1);
		});
		
		$("#txtSearchGenerateStudent").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchGenerateStudent").val()>""){
					getGenerateStudentList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		if(!checkPermission("studentUpload")){	
			$("#btnGenerateStudentAdd").hide();
		}
		//getGenerateStudentList();
	});

	function getGenerateStudentList(){
		sWhere = $("#txtSearchGenerateStudent").val();
		//alert((sWhere) + "&host=" + $("#searchGenerateStudentHost").val() + "&fStart=" + $("#searchGenerateStudentStart").val() + "&fEnd=" + $("#searchGenerateStudentEnd").val());
		$.get("studentControl.asp?op=getGenerateStudentList&where=" + escape(sWhere) + "&host=" + $("#searchGenerateStudentHost").val() + "&fStart=" + $("#searchGenerateStudentStart").val() + "&fEnd=" + $("#searchGenerateStudentEnd").val() + "&dk=3&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#generateStudentCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='generateStudentTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='15%'>标题</th>");
			arr.push("<th width='8%'>数量</th>");
			arr.push("<th width='15%'>公司</th>");
			arr.push("<th width='9%'>说明</th>");
			arr.push("<th width='10%'>导入日期</th>");
			arr.push("<th width='9%'>操作人</th>");
			arr.push("<th width='6%'>文件</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var imgChk = "<img src='images/attachment.png' style='width:16px;'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showGenerateStudentInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					if(ar1[6]==''){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'><a href='/users" + ar1[6] + "' target='_blank'>" + imgChk + "</a></td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#generateStudentCover").html(arr.join(""));
			arr = [];
			$('#generateStudentTab').dataTable({
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
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}
