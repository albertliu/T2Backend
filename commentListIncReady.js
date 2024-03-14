	var ar_commentList = getSession("ar_commentList").split("|");	
	var commentListRefID = 0;
	var commentListKindID = "";
	var commentListStatus = 0;

	$(document).ready(function (){
		$("#div_searchCommentUser").hide();
		
		$("#addComment").click(function(){
			if($("#comment").val() > ""){
				//alert(commentListKindID + "&refID=" + commentListRefID + "&item=" + ($("#comment").val()));
				$.get("commentControl.asp?op=update&nodeID=0&kindID=" + commentListKindID + "&refID=" + commentListRefID + "&item=" + escape($("#comment").val()) + "&times=" + (new Date().getTime()),function(data){
					//jAlert(unescape(data));
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
	});

	function getCommentList(uID){
		//alert(ar_commentList);
		ar_commentList = getSession("ar_commentList").split("|");	
		if(ar_commentList>""){
			commentListKindID = ar_commentList[0];	//task/notice
			commentListRefID = ar_commentList[1];		//ID
			commentListStatus = ar_commentList[2];	//status:0 可编辑，1 关闭
			if(commentListStatus==1){	//处于不活动状态的任务,不可添加新内容
				$("#writeComment").hide();
			}
			//getCommentUserList();
		}
		$.get("commentControl.asp?op=getCommentList&kindID=" + commentListKindID + "&refID=" + commentListRefID + "&userID=" + uID + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//jAlert(ar);
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
		$.get("commentControl.asp?op=getCommentUserList&kindID=" + commentListKindID + "&refID=" + commentListRefID + "&times=" + (new Date().getTime()),function(data){
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
	
	