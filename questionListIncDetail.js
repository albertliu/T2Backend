				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form>
									<a class="easyui-linkbutton" id="btnSearchQuestionAdd" href="javascript:void(0)"></a>&nbsp;&nbsp;
									<input id="txtSearchQuestion" name="txtSearchQuestion" class="easyui-textbox" 
										data-options="prompt:'题目编号、内容、知识点名称...',
													icons: [{
														iconCls:'icon-clear',
														handler: function(e){
															$(e.data.target).textbox('clear');
														}
													},{
														iconCls:'icon-search',
														handler: function(e){
															getQuestionList();
														}
													}],
													height:22
										"
										style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
									知识点&nbsp;<select id="searchQuestionKnowPoint" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select>&nbsp;&nbsp;
									题型&nbsp;<select id="searchQuestionKind" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
									状态&nbsp;<select id="searchQuestionStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
								</form>
							</div>
							<hr size="1" noshadow />
							<div id="questionCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
