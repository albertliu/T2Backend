				  	<div style="width:100%;float:left;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
							<form>
								<a class="easyui-linkbutton" id="btnSearchUserAdd" href="javascript:void(0)"></a>&nbsp;&nbsp;
								<input id="txtSearchUser" name="txtSearchUser" class="easyui-textbox" 
									data-options="prompt:'姓名.用户名',
												icons: [{
													iconCls:'icon-clear',
													handler: function(e){
														$(e.data.target).textbox('clear');
													}
												},{
													iconCls:'icon-search',
													handler: function(e){
														getUserList();
													}
												}],
												height:22
									"
									style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
								<span>
									状态&nbsp;<select id="searchUserStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
								</span>
								<span id="userPartnerItem">
									部门&nbsp;<select id="searchUserPartner" name="searchUserPartner" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
								</span>
								<span style="float:right;">
									<input class="button" type="button" id="btnSearchUserDownload" onClick="outputFloat(20,'file')" value="下载" />
								</span>
				        	</form>
							</div>
							<hr size="1" noshadow />
							<div id="userCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
