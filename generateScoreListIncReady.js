	var generateScoreListLong = 0;		//0: 标准栏目  1：短栏目
	var generateScoreListChk = 0;

	$(document).ready(function (){
		var w3 = "status=0 and hostNo='" + currHost + "'";
		var w4 = "status=0 and (kindID=0 or host='" + currHost + "')";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchGenerateScoreCert","certificateInfo","certID","certName","status=0 and agencyID=4 order by certID",1);
		}else{
			getComList("searchGenerateScoreCert","certificateInfo","certID","certName",w4,1);
		}
		$("#searchGenerateScoreStart").click(function(){WdatePicker();});
		$("#searchGenerateScoreEnd").click(function(){WdatePicker();});
		
		$("#btnSearchGenerateScore").click(function(){
			getGenerateScoreList();
		});
		
		$("#btnGenerateScoreAdd").click(function(){
			showGenerateScoreInfo(0,0,1,1);
		});
		
		$("#txtSearchGenerateScore").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchGenerateScore").val()>""){
					getGenerateScoreList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		if(!checkPermission("diplomaUpload")){	
			$("#btnGenerateScoreAdd").hide();
		}
		//getGenerateScoreList();
	});

	function getGenerateScoreList(){
		sWhere = $("#txtSearchGenerateScore").val();
		//alert((sWhere) + "&kindID=" + $("#searchGenerateScoreCert").val() + "&host=" + $("#searchGenerateScoreHost").val() + "&fStart=" + $("#searchGenerateScoreStart").val() + "&fEnd=" + $("#searchGenerateScoreEnd").val());
		$.get("studentControl.asp?op=getGenerateScoreList&where=" + escape(sWhere) + "&kindID=" + $("#searchGenerateScoreCert").val() + "&fStart=" + $("#searchGenerateScoreStart").val() + "&fEnd=" + $("#searchGenerateScoreEnd").val() + "&dk=4&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#generateScoreCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='generateScoreTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='25%'>标题</th>");
			arr.push("<th width='15%'>证书名称</th>");
			arr.push("<th width='8%'>人数</th>");
			arr.push("<th width='8%'>说明</th>");
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
					arr.push("<td class='link1'><a href='javascript:showGenerateScoreInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
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
			$("#generateScoreCover").html(arr.join(""));
			arr = [];
			$('#generateScoreTab').dataTable({
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
