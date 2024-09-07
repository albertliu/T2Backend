var _feedback_certID = "";
var _at_name = "";	//@name
var _at_username = "";
$(document).ready(function (){
	$("#btn_feedback_submit").linkbutton({
		iconCls:'icon-add',
		width:70,
		height:25,
		text:'发送',
		onClick:function() {
			submit_feedback();	//showFeedbackInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		}
	});

	$("#searchFeedbackStartDate").datebox({
		onChange:function() {
			getFeedbackList();
		}
	});
	$("#searchFeedbackEndDate").datebox({
		onChange:function() {
			getFeedbackList();
		}
	});	
	$("#searchFeedbackStartDate").datebox("setValue", (new Date()).dateAdd("d",-30).format("yyyy-MM-dd"));

	getFeedbackItem();	
	_feedback_open = 1; //通知主页面定时刷新消息列表
});

function getFeedbackList(id){
	if(id){
		_feedback_certID = id;
	}
	if(_feedback_certID==""){
		return false;
	}
	$.getJSON(uploadURL + "/public/get_feedback_cert_list?username=" + currUser + "&certID=" + _feedback_certID + "&type=1&dateStart=" + $("#searchFeedbackStartDate").datebox("getValue") + "&dateEnd=" + $("#searchFeedbackEndDate").datebox("getValue") ,function(data){
		if(data>""){
			//alert(data[0]["item"]);
			var ar = Array();
			ar.push("<ul style='list-style-type:none;width:100%;margin:0px;text-align:left;'>");
			$.each(data,function(iNum,val){
				ar.push("<li style='width:100%; float:left; color:#555;background:#EEE; padding-left:5px;'" + (val["title"]!="我"?" onclick='setAtUser(\"" + val["title"] + "\",\"" + val["username"] + "\");'":"") + ">" + val["title"] + "&nbsp;&nbsp;&nbsp;&nbsp;" + val["regDate"] + (val["title"]=="我" && val["cancelAllow"]==1?"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:doCancelFeedback(" + val["ID"] + ");'>撤回</a>":"") + "</li>");
				ar.push("<li style='width:100%; word-break: break-all; font-size:1.2em;" + (val["title"]=="我"?"background:#00FF7F;":"") + "'>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + val["item"] + "</li>");
			});
			ar.push("</ul>");
			$("#feedback_list").html(ar.join(""));
			var div = document.getElementById('feedback_list');
			div.scrollTop = div.scrollHeight; 
		}else{
			$("#feedback_list").html("没有任何消息。");
		}
	});
}

function getFeedbackItem(){
	$.getJSON(uploadURL + "/public/getFeedbackItem" ,function(data){
		$("#feedback_item").empty();
		var arr = new Array();
		if(data.length>0){
			arr.push("<table>");
			let w = [];
			if(checkRole("emergency")){
				if(currHost=="fuda"){
					w = ['C15','C25','C26','C27','C98','C99'];
				}else{
					w = ['C25','C26','C27','C98','C99'];
				}
			}
			$.each(data,function(iNum,val){
				if(w.indexOf(val["certID"])==-1){
					arr.push("<tr><td style='width:85%; color:blue;' class='link1'><a href='javascript:getFeedbackList(\"" + val["certID"] + "\")' style='font-size:1.2em;text-decoration:none;'>" + val["certName"] + "</a></td><td style='width:15%; color:red; padding-left:30px; font-size:1.2em;'>" + nullNoDisp(val["qty"]) + "</td></tr>");
				}
			});
			arr.push("</table>");
			$("#feedback_item").html(arr.join(""));
		}
	});
}
	
function submit_feedback(){
	if($("#feedback_send").val()==""){
		alert("请输入要发送的信息。");
		return false;
	}
	if(_feedback_certID==""){
		alert("请选择左侧的课程项目。");
		return false;
	}
	var item = $("#feedback_send").val();
	var at = "@" + _at_name;
	if(item.indexOf(at)>=0){
		item = item.replace(at, "");
	}else{
		_at_username = "";
	}
	var params = {username:currUser, certID: _feedback_certID, item:item, type: 1, refID:0, readerID: _at_username};
	//alert(params);
	
	$.post(uploadURL + "/public/submit_feedback_cert", params ,function(data){
		getFeedbackList();
		_at_name = "";
		_at_username = "";
		$("#feedback_send").val("");
		//div.scrollTop = div.scrollHeight; 
	});
}

function doCancelFeedback(id){
	if(confirm("确定要撤回这条消息吗？")){
		$.post(uploadURL + "/public/cancel_feedback_cert", {ID:id} ,function(data){
			getFeedbackList();
			_at_name = "";
			_at_username = "";
			$("#feedback_send").val("");
			//div.scrollTop = div.scrollHeight; 
		});
	}
}
	
function setAtUser(att,atu){
	_at_username = atu;
	_at_name = att;
	$("#feedback_send").val("@" + att + " ");
	$("#feedback_send").focus();
}