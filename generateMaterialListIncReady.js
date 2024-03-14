	var generateMaterialListLong = 0;		//0: 标准栏目  1：短栏目
	var generateMaterialListChk = 0;

	$(document).ready(function (){
		var w1 = "status=0 and hostNo='" + currHost + "'";
		var w2 = "status=0 and (kindID=0 or host='" + currHost + "')";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchGenerateMaterialHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		}else{
			getComList("searchGenerateMaterialHost","hostInfo","hostNo","title",w1,0);
		}
		//getDicList("material","searchGenerateMaterialKind",1);
		getComList("searchGenerateMaterialKind","dictionaryDoc","memo","item","kind='material'",1);
		$("#searchGenerateMaterialStart").click(function(){WdatePicker();});
		$("#searchGenerateMaterialEnd").click(function(){WdatePicker();});
		
		$("#btnSearchGenerateMaterial").click(function(){
			getGenerateMaterialList();
		});
		$("#btnSearchGenerateMaterialAdd").click(function(){
			//etc. ("student_photo","310102199209090021","student","spc"),  ("student_photo","0","mulitple","spc")
			// --(nodeID,refID,op,mark,keyID)/(op,nodeID,refID,keyID)/(loadOp,loadID,mark,p_host)/
			showCommLoadFile(0,"mulitple","student_photo",1,"");
		});
		
		$("#txtSearchGenerateMaterial").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchGenerateMaterial").val()>""){
					getGenerateMaterialList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		if(!checkPermission("studentUpload")){
			$("#btnSearchGenerateMaterialAdd").hide();
		}
		//getGenerateMaterialList();
	});

	function getGenerateMaterialList(){
		sWhere = $("#txtSearchGenerateMaterial").val();
		//alert("&kindID=" + $("#searchGenerateMaterialKind").val() + "&host=" + $("#searchGenerateMaterialHost").val());
		$.get("diplomaControl.asp?op=getGenerateMaterialList&where=" + escape(sWhere) + "&kindID=" + $("#searchGenerateMaterialKind").val() + "&host=" + $("#searchGenerateMaterialHost").val() + "&fStart=" + $("#searchGenerateMaterialStart").val() + "&fEnd=" + $("#searchGenerateMaterialEnd").val() + "&dk=33&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#generateMaterialCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='generateMaterialTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='15%'>材料名称</th>");
			arr.push("<th width='8%'>数量</th>");
			arr.push("<th width='15%'>公司</th>");
			arr.push("<th width='9%'>说明</th>");
			arr.push("<th width='10%'>上传日期</th>");
			arr.push("<th width='9%'>操作人</th>");
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
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showGenerateMaterialInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
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
			$("#generateMaterialCover").html(arr.join(""));
			arr = [];
			$('#generateMaterialTab').dataTable({
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
