				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form>
								<a class="easyui-linkbutton" id="btnSearchCourseAdd" href="javascript:void(0)"></a>&nbsp;&nbsp;
								<input id="txtSearchCourse" name="txtSearchCourse" class="easyui-textbox" 
									data-options="prompt:'课程名称、编码',
												icons: [{
													iconCls:'icon-clear',
													handler: function(e){
														$(e.data.target).textbox('clear');
													}
												},{
													iconCls:'icon-search',
													handler: function(e){
														getCourseList();
													}
												}],
												height:22
									"
									style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
								<span>
									认证机构&nbsp;<select id="searchCourseAgency" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select>&nbsp;&nbsp;
								</span>
								<span>
									状态&nbsp;<select id="searchCourseStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
								</span>
								<span style="float:right;">
									<input class="button" type="button" name="btnDownLoad15" id="btnDownLoad15" onClick="outputFloat(15,'file')" value="下载" />
								</span>
				        		</form>
							</div>
							<hr size="1" noshadow />
							<div id="courseCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
