	var generatePasscardListLong = 0;		//0: 标准栏目  1：短栏目
	var generatePasscardListChk = 0;

	$(document).ready(function (){
		getComList("searchGeneratePasscardCert","v_certificateInfo","certID","certName","status=0 and type=0 and agencyID=4 order by certName",1);
		getComList("searchGeneratePasscardRegister","v_examRegister","registerID","registerName","1=1 order by ID desc",1);
		getDicList("planStatus","searchGeneratePasscardStatus",1);
		$("#searchGeneratePasscardStart").click(function(){WdatePicker();});
		$("#searchGeneratePasscardEnd").click(function(){WdatePicker();});
		
		$("#btnSearchGeneratePasscard").click(function(){
			getGeneratePasscardList();
		});
		
		$("#searchGeneratePasscardRegister").change(function(){
			getGeneratePasscardList();
		});
		
		$("#txtSearchGeneratePasscard").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchGeneratePasscard").val()>""){
					getGeneratePasscardList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		if(!checkPermission("examOpen")){
			$("#btnSearchGeneratePasscardAdd").hide();
		}
		
		$("#btnSearchGeneratePasscardAdd").click(function(){
			showGeneratePasscardInfo(0,0,1,1);
		});
		//getGeneratePasscardList();
	});

	function getGeneratePasscardList(){
		sWhere = $("#txtSearchGeneratePasscard").val();
		//alert((sWhere) + "&kindID=" + $("#searchGeneratePasscardCert").val() + "&host=" + $("#searchGeneratePasscardHost").val() + "&keyID=" + photo);
		$.get("diplomaControl.asp?op=getGeneratePasscardList&where=" + escape(sWhere) + "&kindID=" + $("#searchGeneratePasscardCert").val() + "&refID=" + $("#searchGeneratePasscardRegister").val() + "&status=" + $("#searchGeneratePasscardStatus").val() + "&fStart=" + $("#searchGeneratePasscardStart").val() + "&fEnd=" + $("#searchGeneratePasscardEnd").val() + "&dk=104&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#generatePasscardCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='generatePasscardTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='16%'>考试场次</th>");
			arr.push("<th width='10%'>考试日期</th>");
			arr.push("<th width='6%'>类型</th>");
			arr.push("<th width='6%'>人数</th>");
			arr.push("<th width='8%'>结果统计</th>");
			arr.push("<th width='5%'>证书</th>");
			arr.push("<th width='6%'>状态</th>");
			arr.push("<th width='8%'>考试通知</th>");
			arr.push("<th width='8%'>成绩通知</th>");
			arr.push("<th width='12%'>备注</th>");
			arr.push("<th width='6%'>制作</th>");
			arr.push("<th width='6%'>准考</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var k = "";
				var h = "";
				var imgChk = "<img src='images/printer1.png'>";
				var imgChk1 = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + ar1[0] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showGeneratePasscardInfo(" + ar1[0] + ",0,0,1);'>" + ar1[3] + "</a></td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					k = ar1[27];
					if(k=="线下"){
						k = "";
					}
					arr.push("<td class='left'>" + k + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					if(ar1[19]==''){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='left' title='合格/不合格/缺考'>" + ar1[23] + "/" + ar1[24] + "/" + ar1[25] + "</td>");
					}
					if(ar1[19]==''){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						k = "";
						if(parseInt(ar1[23]) > parseInt(ar1[28])){
							k = " style='background-color:#FFFF00;'";
						}
						arr.push("<td class='left' title='合格/证书'" + k + ">" + ar1[23] + "/" + ar1[28] + "</td>");
					}
					arr.push("<td class='center'>" + ar1[18] + "</td>");
					arr.push("<td class='left'>" + ar1[15] + "</td>");
					arr.push("<td class='left'>" + ar1[21] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[12] + "</td>");
					if(ar1[9]==''){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'><a href='/users" + ar1[9] + "?t=" + (new Date().getTime()) + "' target='_blank'>" + imgChk + "</a></td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#generatePasscardCover").html(arr.join(""));
			arr = [];
			$('#generatePasscardTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"iDisplayLength": 50,
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
