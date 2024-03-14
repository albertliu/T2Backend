<div style="width:100%;margin:0;">
	<div class="comm" style="background:#f5f5f5; width:300px; float:left; height:800px;">
		<div id="feedback_item" style="padding:20px; width:260px;background:#fff; height:780px;"></div>
	</div>
	<div class="comm" style="background:#f5f5f5; height:800px;">
		<form id="feedback" style="width:98%;margin:1px;padding-left:2px;background:#fff;">
		<table>
		<tr>
			<td align="center" colspan="2" style="width:100%;">
				<label style="font-family: 幼圆; color: green; padding-left:30px;">日期</label>&nbsp;&nbsp;<input type="text" id="searchFeedbackStartDate" class="easyui-datebox" data-options="height:22,width:100" />&nbsp;&nbsp;至&nbsp;&nbsp;<input type="text" id="searchFeedbackEndDate" class="easyui-datebox" data-options="height:22,width:100" />
			</td>
		</tr>
		<tr>
			<td align="right" colspan="2" style="width:100%;"><div id="feedback_list" style="width:500px; height:710px;float:left; border:2px solid #888;padding:5px 10px;overflow:auto;"></div></td>
		</tr>
		<tr>
			<td style="padding-top:10px;"><input class="mustFill" type="text" id="feedback_send" style="width:400px; height:30px; font-size:1.2em;" /></td>
			<td style="padding-top:10px;"><a class="easyui-linkbutton" id="btn_feedback_submit" style="padding-left:10px;" href="javascript:void(0)"></a></td>
		</tr>
		</table>
		</form>
	</div>
</div>