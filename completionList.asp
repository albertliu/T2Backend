<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link href="css/datatables.min.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="js/jquery-3.7.0.min.js"></script>
<script language="javascript" type="text/javascript" src="js/datatables.min.js"></script>
    <style>
        td.details-control {
            /* Image in the first column to
                indicate expand*/
            background: #yellow;
                  
            cursor: pointer;
        }
  
        tr.shown td.details-control {
            background: #fff;
        }
    </style>

<script language="javascript">
	<!--#include file="js/commFunction.js"-->
	var table = "";
	$(document).ready(function (){
		refID = "<%=refID%>";	//enterID
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 

		getStudentLessonList();
	});

	async function getStudentLessonList(){
		//alert(refID + ":" + nodeID);
		$.get("studentCourseControl.asp?op=getStudentLessonList&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' style='width:100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='50%'>课节名称</th>");
			arr.push("<th width='15%'>额定课时</th>");
			arr.push("<th width='15%'>完成率%</th>");
			arr.push("<th width='15%'>人脸检测</th>");
			arr.push("<th width='0%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='details-control' style='color:blue;text-align:center;'>" + nullNoDisp(ar1[4]) + "</td>");
					arr.push("<td class='left'>" + ar1[0] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			table = $('#cardTab').DataTable({
				//配置相应部分的中文显示(废话，不然就显示英文了)
				"language": {
					"lengthMenu": "每页 _MENU_ 条记录",
					"zeroRecords": "没有找到记录",
					"info": "第 _PAGE_ 页 ( 总共 _PAGES_ 页 )",
					"infoEmpty": "无记录",
					"paginate": {
						"first": "第一页",
						"last": "最后一页",
						"next": "后一页",
						"previous": "上一页"
					},
				},
			
				"pageLength": 20,           //默认每页条数
				"lengthChange": false,      //禁掉表格自带的选择每页条数的下拉框
				"searching": false,
				"columnDefs": [
					{ "visible": false, "targets": [5] }
				]
			});

			$('#cardTab tbody').on('click', 'td.details-control', function () {
				var tr =$(this).closest('tr');
				var row = table.row(tr);

				if (row.child.isShown()) {

					// Closing the already opened row           
					row.child.hide();

					// Removing class to hide
					tr.removeClass('shown');
				}
				else {

					// Show the child row for detail
					// information
					getChildRow(row.data()[5], function(data){
						row.child(data).show();
					});

					// To show details,add the below class
					tr.addClass('shown');
				}
			});
		});
	}

	function getChildRow(id, callback) {
		$.get("studentCourseControl.asp?op=getFaceList&refID=" + id + "&times=" + (new Date().getTime()),function(re){
			var ar = eval("(" + unescape(re) + ")").list;
			var x = "<div>没有找到数据</div>";
			if(ar>""){
				var bg = "";
				var x = '<table cellpadding="5" cellspacing="0"'
					+ ' style="padding-left:50px;width:80%;">' +
					'<tr><td style="width:30%;">检测日期</td><td style="width:25%;">参考图片</td><td style="width:25%;">拍摄图片</td><td style="width:20%;">比对结果</td></tr>'
				$.each(ar,function(iNum,val){
					$.get(uploadURL + "/alis/get_OSS_file_base64?filename=" + val.file1,function(re1){
						//alert(re.status);
						x += '<tr>' +
						'<td>' + val.regDate + '</td>' +
						'<td><img src="/users' + val.file2 + '" style="max-width:50px;" /></td>' +
						'<td>' + (re1>'' ? '<img src="data:image/png;base64,' + re1 + '" style="max-width:50px;" />' : '') + '</td>';
						bg = "";
						if(val.status==1){
							bg = ' style="color: green;"';
						}
						if(val.status==2){
							bg = ' style="color: red;"';
						}
						x += '<td' + bg + '>' + val.statusName + '</td>' +
						'</tr>'
					});
				});
				x += '</table>';
			}
			callback(x);
		});
	}

</script>

</head>

<body>

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div id="cover" style="float:left;width:100%;">
	</div>
</div>
</body>
