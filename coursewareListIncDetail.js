				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form>
								<a class="easyui-linkbutton" id="btnSearchCoursewareAdd" href="javascript:void(0)"></a>&nbsp;&nbsp;
								<input id="txtSearchCourseware" name="txtSearchCourseware" class="easyui-textbox" 
									data-options="prompt:'课件名称、编码',
												icons: [{
													iconCls:'icon-clear',
													handler: function(e){
														$(e.data.target).textbox('clear');
													}
												},{
													iconCls:'icon-search',
													handler: function(e){
														getCoursewareList();
													}
												}],
												height:22
									"
									style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
								<span>
									课程&nbsp;<select id="searchCoursewareCourseID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:250"></select>&nbsp;&nbsp;
								</span>
								<span>
									状态&nbsp;<select id="searchCoursewareStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
								</span>
								<span style="float:right;">
									<input class="button" type="button" name="btnDownLoad15" id="btnDownLoad15" onClick="outputFloat(15,'file')" value="下载" />
								</span>
				        		</form>
							</div>
							<hr size="1" noshadow />
							<div id="coursewareCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
