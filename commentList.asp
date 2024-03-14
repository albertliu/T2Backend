<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link rel="stylesheet" type="text/css" href="css/comment.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>

<script language="javascript">
	var kindID = "";
	var refID = "";
	var item = "";
	var cUser = "";
	$(document).ready(function (){
		
		$("#addComment").click(function(){
			if($("#comment").val() > ""){
				$.get("commentControl.asp?op=addNew&kindID=" + kindID + "&refID=" + refID + "&item=" + escape($("#comment").val()) + "&times=" + (new Date().getTime()),function(data){
					jAlert("发布成功!");
					getCommentList("");
					$("#comment").val("");
				});
			}else{
				jAlert("请填写内容");
			}
		});
		
		$("#searchCommentUserList").change(function(){
			getCommentList($("#searchCommentUserList").val());
		});

		$.get("commonControl.asp?op=getSession&sName=pagePara" + "&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = unescape(re).split("|");
			kindID = ar[0];
			refID = ar[1];
			item = ar[2];
			if(ar[3]>0){	//不处于活动状态的任务
				$("#writeComment").hide();
			}
			$("#item").html("主题：" + item);
			getCommentUserList();
			getCommentList("");
		});
	});

	function getCommentList(userID){
		$.get("commentControl.asp?op=getCommentList&kindID=" + kindID + "&refID=" + refID + "&userID=" + userID + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#commentList").empty();
			var s = "";
			var c = 0;
			var mNew = "";
			if(ar>""){
				$.each(ar,function(iNum,val){
					c += 1;
					var ar1 = new Array();
					ar1 = val.split("|");
					if(ar1[4]==0){
						mNew = "&nbsp;<img src='images/new.gif'>&nbsp;";
					}else{
						mNew = "";
					}
					s += "<li><p class='comments_head'><cite>" + ar1[1] + mNew + ":</cite> <span class='timestamp'>" + ar1[2] + "</span></p>";
					s += "<div class='comments_body'><p>" + ar1[3] + "</p></div></li>";
				});
				$("#commentList").html(s);
				setConfig();
			}
			$("#commentCount").html(c);
		});
	}
	
	function getCommentUserList(){
		$.get("commentControl.asp?op=getCommentUserList&kindID=" + kindID + "&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//alert(ar);
			$("#searchCommentUserList").empty();
			$("<option value=''>全部内容</option>").appendTo("#searchCommentUserList");
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#searchCommentUserList");
				});
			}
		});
	}

	function setConfig(){
		//hide comments_body after the first one
		$(".comments_list .comments_body:gt(0)").hide();
				
		//hide comments li after the 5th
		$(".comments_list li:gt(4)").hide();
		
		//toggle comments_body
		$(".comments_head").click(function(){
			$(this).next(".comments_body").slideToggle(500);
			return false;
		});
	
		//collapse all comments
		$(".collapse_all_comments").click(function(){
			$(this).hide();
			$(".expand_all_comments").show();
			$(".comments_body").slideUp(500);
			return false;
		});
		
		//expand all comments
		$(".expand_all_comments").click(function(){
			$(this).hide();
			$(".collapse_all_comments").show();
			$(".comments_body").slideDown(500);
			return false;
		});
	
		//show all comments
		$(".show_all_comments").click(function(){
			$(this).hide();
			$(".show_recent_only").show();
			$(".comments_list li:gt(4)").slideDown();
			return false;
		});
	
		//show recent comments only
		$(".show_recent_only").click(function(){
			$(this).hide();
			$(".show_all_comments").show();
			$(".comments_list li:gt(4)").slideUp();
			return false;
		});
	}
</script>

</head>

<body>
<div id='layout' align='left'>	
	<div>
		<span id="item" style="color:blue;margin:2px;padding:5px;float:left;"></span>
		<span style="float:right;">按发布人查看：<select id="searchCommentUserList" style="margin:2px;padding:5px;width:150px"></select></span>
	</div>
	<div id="writeComment">
		<form class="comm" style="margin:0px;">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" style="line-height:10px;text-align: center;">
				<tr>
					<td><div style="color:orange;margin:0;padding:5px;text-align:center;">意见内容</div></td>
				</tr>
				<tr>
					<td><textarea id="comment" name="comment" style="width:383px;" ></textarea></td>
				</tr>
				<tr>
					<td>
						<input class="button" type="button" id="addComment" name="addComment" value="发布" />&nbsp;&nbsp;
						<input class="button" type="reset"  value="重写" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<hr size="1" color="#eeeeee" noshadow>
	<ul id="commentList" class="comments_list">
	</ul>
	<p class="collapse_buttons"><a href="#" class="show_all_comments">显示所有评论(<span id="commentCount"></span>)</a> <a href="#" class="show_recent_only">只显示最近五条评论</a> <a href="#" class="collapse_all_comments">收起评论</a> <a href="#" class="expand_all_comments">展开评论</a></p>
</div>
</body>
