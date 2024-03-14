				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
							<form>
								<a class="easyui-linkbutton" id="btnAgencyAdd" href="javascript:void(0)"></a>&nbsp;&nbsp;
								<input id="txtSearchAgency" name="txtSearchAgency" class="easyui-textbox" 
									data-options="prompt:'姓名.用户名',
												icons: [{
													iconCls:'icon-clear',
													handler: function(e){
														$(e.data.target).textbox('clear');
													}
												},{
													iconCls:'icon-search',
													handler: function(e){
														getAgencyList();
													}
												}],
												height:22
									"
								style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
								<span>
									状态&nbsp;<select id="searchAgencyStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
								</span>
				        	</form>
						</div>
						<hr size="1" noshadow />
						<div id="agencyCover" style="float:top;margin:0px;background:#f8fff8;">
						</div>
					</div>
