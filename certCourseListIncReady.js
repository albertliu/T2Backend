
	function getCertCourseList(refID){
		//alert((sWhere) + "&kindID=" + $("#searchCourseKind").val() + "&status=" + $("#searchCourseStatus").val() + "&agency=" + $("#searchCourseAgency").val());
		$.get("courseControl.asp?op=getCertCourseList&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#certCourseCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];		
			arr.push("<table cellpadding='5' cellspacing='2' border='0' id='certCourseTab' width='98%'>");
			arr.push("<tr align='center'>");
			arr.push("<td align='center' width='15%'>编号</td>");
			arr.push("<td align='center' width='70%'>课程名称</td>");
			arr.push("<td align='center' width='15%'>课时</td>");
			arr.push("</tr>");
			var i = 0;
			var c = 0;
			var mNew = "";
			var imgChk = "<img src='images/green_check.png'>";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr>");
					arr.push("<td align='center'>" + ar1[1] + "</td>");
					arr.push("<td align='center'><a href='javascript:showCourseInfo(" + ar1[0] + ",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td align='center'>" + ar1[3] + "</td>");
					arr.push("</tr>");
				});
			}
			arr.push("</table>");
			$("#certCourseCover").html(arr.join(""));
			arr = [];
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}
