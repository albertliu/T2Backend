	var teacherListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getComboBoxList("userStatus","searchTeacherStatus",1);

		$("#txtSearchTeacher").textbox('textbox').css('background','#FFFF00');
		
		$("#btnSearchTeacherAdd").linkbutton({
			iconCls:'icon-add',
			width:70,
			height:25,
			text:'添加',
			onClick:function() {
				showTeacherInfo(0,0,1,1);	//showTeacherInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
			}
		});

		$("#btnAddTeacher").hide();
		if(checkPermission("teacherAdd")){
			$("#btnAddTeacher").show();
		}
	});

	function getTeacherList(){
		sWhere = $("#txtSearchTeacher").textbox("getValue");
		//alert($("#searchTeacherStatus").val());
		$.get("userControl.asp?op=getTeacherList&where=" + escape(sWhere) + "&status=" + $("#searchTeacherStatus").combobox("getValue") + "&dk=72&times=" + (new Date().getTime()),function(data){
			// jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#teacherCover").empty();
			floatSum = "";
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='teacherTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='10%'>编号</th>");
			arr.push("<th width='12%'>姓名</th>");
			arr.push("<th width='15%'>身份证号</th>");
			arr.push("<th width='12%'>所属</th>");
			arr.push("<th width='6%'>状态</th>");
			arr.push("<th width='12%'>注册日期</th>");
			arr.push("<th width='10%'>注册人</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showTeacherInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
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
			$("#teacherCover").html(arr.join(""));
			arr = [];
			$('#teacherTab').dataTable({
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

	function pickupTeacher(p){
		var ar = getSession("teacherList").split("|");
		var ar1 = p.split("|");
		if(ar>""){
			var i = 0;
			var n = ar1.length;
			$.each(ar,function(iNum,val){
				if(i==n){i = 0;}
				alert(i);
				if(val>""){
					parent.$("#" + val).val(ar1[i]);
				}
				i += 1;
			});
		}
		parent.$.close("teacherList");
	}