				  	<div style="width:100%;float:left;margin:0;">
							<div id="div_searchCommentUser">
								<span style="float:right;">按发布人查看：<select id="searchCommentUserList" style="margin:2px;padding:1px 5px;width:150px"></select></span>
							</div>
							<div id="writeComment">
								<form class="comm" style="margin:0px;">
									<table border="0" cellpadding="0" cellspacing="0" width="100%" style="line-height:10px;text-align: center;">
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
