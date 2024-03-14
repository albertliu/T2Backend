	var VideoListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getComboBoxList("statusEffect","searchVideoStatus",1);
        getComboList("searchVideoCourseID","v_courseInfo","courseID","courseName1","status=0 order by courseID",1);
 
		$("#txtSearchVideo").textbox('textbox').css('background','#FFFF00');
		
		$("#btnSearchVideoAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				showVideoInfo(0,0,1,1);	//showVideoInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
			}
		});
		
		$("#searchVideoCourseID").combobox({
			onChange:function() {
				getVideoList();
			}
		});
		
		if(checkPermission("videoAdd")){
			$("#btnAddVideo").show();
		}else{
			$("#btnAddVideo").hide();
		}
	});

	function getVideoList(){
		sWhere = $("#txtSearchVideo").textbox("getValue");
		//alert((sWhere) + "&kindID=" + $("#searchVideoKind").val() + "&status=" + $("#searchVideoStatus").val() + "&agency=" + $("#searchVideoAgency").val());
		$.get("lessonControl.asp?op=getVideoList&where=" + escape(sWhere) + "&refID=" + $("#searchVideoCourseID").combobox("getValue") + "&status=" + $("#searchVideoStatus").combobox("getValue") + "&dk=15&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#VideoCover").empty();
			floatSum = "";
			arr = [];			
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='VideoTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='5%'>编号</th>");
			arr.push("<th width='25%'>视频名称</th>");
			arr.push("<th width='6%'>时长(秒)</th>");
			arr.push("<th width='6%'>类型</th>");
			arr.push("<th width='6%'>状态</th>");
			arr.push("<th width='6%'>作者</th>");
			arr.push("<th width='10%'>备注</th>");
			arr.push("<th width='6%'>登记日期</th>");
			arr.push("<th width='6%'>登记人</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			var mNew = "";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showVideoInfo(" + ar1[0] + ",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
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
			$("#videoCover").html(arr.join(""));
			arr = [];
			$('#VideoTab').dataTable({
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

	
	