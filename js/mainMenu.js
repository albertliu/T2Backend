<div style="background:#efefef;padding:5px;height:35px;">
	<ul class="dmenu">
		<li>
			<a id="homePage" href="javascript:window.parent.open('index.asp?times=' + (new Date().getTime()),'_self')">首页</a>
		</li>
		<li>
			<a id="unitPage" href="javascript:window.parent.open('unitManagementDetail.asp?times=' + (new Date().getTime()),'_self')">单位管理</a>
		</li>
		<li>
			<a id="archPage" href="javascript:window.parent.open('storeManagementDetail.asp?times=' + (new Date().getTime()),'_self')">档案管理</a>
		</li>
		<li>
			<a id="oaPage" href="javascript:window.parent.open('oaManagement.asp?times=' + (new Date().getTime()),'_self')">事务管理</a>
		</li>
		<li>
			<a id="queryPage" href="javascript:window.parent.open('queryManagement.asp?times=' + (new Date().getTime()),'_self')">日常查询</a>
		</li>
		<li>
			<a id="rptPage" href="javascript:window.parent.open('rptManagement.asp?times=' + (new Date().getTime()),'_self')">统计报表</a>
		</li>
		<li>
			<a id="userPage" href="javascript:window.parent.open('userManagement.asp?times=' + (new Date().getTime()),'_self')">用户管理</a>
		</li>
		<li>
			<a id="Page" href="javascript:window.parent.open('default.asp?times=' + (new Date().getTime()),'_self')">退出</a>
		</li>
	</ul>
	<span style="padding-left:5px;padding-top:5px;"><img src="images\user.png" width="20"></span>&nbsp;<span id="userName"><%=currUserName%></span>
	<span style="padding-left:5px;padding-top:5px;" id="alertWaitReceiveTask"><img src="images\clock_stop.png" width="20" title="未完成受托任务"></span>&nbsp;<span id="alertWaitReceiveTaskCount"></span>
	<span style="padding-left:5px;padding-top:5px;" id="alertWaitSendTask"><img src="images\clock.png" width="20" title="未完成委托任务"></span>&nbsp;<span id="alertWaitSendTaskCount"></span>
	<span style="padding-left:5px;padding-top:5px;" id="alertNewComment"><img src="images\comment.png" width="16" title="未阅读意见"></span>&nbsp;<span id="alertNewCommentCount" style="color:red;"></span>
	<span style="padding-left:5px;padding-top:5px;" id="alertToGrant"><img src="images\user0.png" width="20" title="授权"></span>&nbsp;<span id="alertToGrantCount"></span>
	<span style="padding-left:5px;padding-top:5px;" id="alertFromGrant"><img src="images\user1.png" width="20" title="被授权"></span>&nbsp;<span id="alertFromGrantCount"></span>
	<span style="padding-left:5px;padding-top:5px;" id="alertNewArticle"><img src="images\sound.png" width="20" title="未阅读通知"></span>&nbsp;<span id="alertNewArticleCount" style="color:red;"></span>
	<span style="padding-left:5px;padding-top:5px;" id="alertReCalAccount"><img src="images\exchange.png" width="20" title="待更换账单"></span>&nbsp;<span id="alertReCalAccountCount" style="color:red;"></span>
	<span style="padding-left:5px;padding-top:5px;" id="alertWaitReceiveMerge"><img src="images\green_check.png" width="20" title="待签收资料"></span>&nbsp;<span id="alertWaitReceiveMergeCount" style="color:red;"></span>
</div>
