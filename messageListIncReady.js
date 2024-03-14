	var messageListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		var w_message = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchMessageHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		}else{
			getComList("searchMessageHost","hostInfo","hostNo","title",w_message,0);
		}
		$("#searchMessageStart").click(function(){WdatePicker();});
		$("#searchMessageEnd").click(function(){WdatePicker();});
		getDicList("message","searchMessageKind",1);
		getDicList("readStatus","searchMessageStatus",1);

		$("#btnSearchMessage").click(function(){
			getMessageList();
		});
		
		if(messageListLong == 0){
			$("#messageListLongItem1").show();
		}else{
			$("#messageListLongItem1").hide();
		}
		
		//getMessageList();
	});

	function getMessageList(){
		sWhere = $("#txtSearchMessage").val();
		//alert("&fStart=" + $("#searchMessageStart").val() + "&fEnd=" + $("#searchMessageEnd").val() + "&kindID=" + $("#searchMessageKind").val() + "&status=" + $("#searchMessageStatus").val() + "&host=" + $("#searchMessageHost").val());
		$.get("messageControl.asp?op=getMessageList&where=" + escape(sWhere) + "&fStart=" + $("#searchMessageStart").val() + "&fEnd=" + $("#searchMessageEnd").val() + "&kindID=" + $("#searchMessageKind").val() + "&status=" + $("#searchMessageStatus").val() + "&host=" + $("#searchMessageHost").val() + "&dk=15&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#messageCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			var a1 = "公司";
			var a2 = "";
			var a3 = "";
			if(currHost > ""){	//公司用户看部门，系统用户看公司
				a1 = "部门";
			}
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='messageTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='36%'>消息内容</th>");
			arr.push("<th width='10%'>接收人</th>");
			arr.push("<th width='13%'>" + a1 + "</th>");
			arr.push("<th width='12%'>发送日期</th>");
			arr.push("<th width='10%'>发送人</th>");
			arr.push("<th width='8%'>阅读</th>");
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
					if(currHost==""){	//公司用户看部门，系统用户看公司
						a2 = ar1[15].substr(0,8);
					}else{
						a2 = ar1[13].substr(0,8);
					}
					if(ar1[5]==1){
						a3 = imgChk;
					}else{
						a3 = "&nbsp;";
					}
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showMessageInfo(" + ar1[0] + "," + ar1[1] + ",0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[18] + "</td>");
					arr.push("<td class='left'>" + a2 + "</td>");
					arr.push("<td class='left'>" + ar1[17].substr(0,10) + "</td>");
					arr.push("<td class='left'>" + ar1[20] + "</td>");
					arr.push("<td class='left'>" + a3 + "</td>");
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
			$("#messageCover").html(arr.join(""));
			arr = [];
			$('#messageTab').dataTable({
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

	
	