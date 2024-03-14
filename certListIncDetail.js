				  	<div style="width:100%;float:left;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
							<form>
								<a class="easyui-linkbutton" id="btnSearchCertAdd" href="javascript:void(0)"></a>&nbsp;&nbsp;
								<input id="txtSearchCert" name="txtSearchCert" class="easyui-textbox" 
									data-options="prompt:'项目名称、编码',
												icons: [{
													iconCls:'icon-clear',
													handler: function(e){
														$(e.data.target).textbox('clear');
													}
												},{
													iconCls:'icon-search',
													handler: function(e){
														getCertList();
													}
												}],
												height:22
									"
									style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
								<span>
									认证机构&nbsp;<select id="searchCertAgency" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select>&nbsp;&nbsp;
								</span>
								<span>
									状态&nbsp;<select id="searchCertStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
								</span>
								<span style="float:right;">
									<input class="button" type="button" name="btnDownLoad14" id="btnDownLoad14" onClick="outputFloat(14,'file')" value="下载" />
								</span>
				        	</form>
						</div>
						<hr size="1" noshadow />
						<div id="certCover" style="float:top;margin:0px;background:#f8fff8;"></div>
					</div>
