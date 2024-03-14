				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
							<form>
								<input id="txtSearchGenerateDiploma" name="txtSearchGenerateDiploma" class="easyui-textbox" 
									data-options="prompt:'证书编号、备注',
												icons: [{
													iconCls:'icon-clear',
													handler: function(e){
														$(e.data.target).textbox('clear');
													}
												},{
													iconCls:'icon-search',
													handler: function(e){
														getGenerateDiplomaList();
													}
												}],
												height:22
									"
									style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
								<span>
									项目&nbsp;<select id="searchGenerateDiplomaCert" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select>&nbsp;&nbsp;
								</span>
								<span>
									&nbsp;制作日期&nbsp;<input id="searchGenerateDiplomaStartDate" class="easyui-datebox" data-options="height:22,width:100" />-<input id="searchGenerateDiplomaEndDate" class="easyui-datebox" data-options="height:22,width:100" />
								</span>
								<input class="easyui-checkbox" id="searchGenerateDiplomaPrint" value="1"/>&nbsp;未打印&nbsp;&nbsp;
								<span style="float:right;">
									<input class="button" type="button" id="btnDownLoad22" onClick="outputFloat(22,'file')" value="下载" />
								</span>
							</form>
						</div>
						<hr size="1" noshadow />
						<div id="generateDiplomaCover" style="float:top;margin:0px;background:#f8fff8;">
						</div>
					</div>
