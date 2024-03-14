				  	<div style="width:100%;float:left;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
							<form>
								<a class="easyui-linkbutton" id="btnSearchPartnerAdd" href="javascript:void(0)"></a>&nbsp;&nbsp;
									<input id="txtSearchPartner" name="txtSearchPartner" class="easyui-textbox" 
										data-options="prompt:'名称',
													icons: [{
														iconCls:'icon-clear',
														handler: function(e){
															$(e.data.target).textbox('clear');
														}
													},{
														iconCls:'icon-search',
														handler: function(e){
															getPartnerList();
														}
													}],
													height:22
										"
									style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
								<span>
									状态&nbsp;<select id="searchPartnerStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
									&nbsp;&nbsp;<a class="easyui-linkbutton" id="btnSearchUserHost" href="javascript:void(0)"></a>
									&nbsp;&nbsp;<a class="easyui-linkbutton" id="btnSearchUserCheckin" href="javascript:void(0)"></a>
								</span>
								<span id="partnerListLongItem1">
									&nbsp;&nbsp;<input class="button" type="button" name="btnDownLoadPartner" id="btnDownLoadPartner" onClick="outputFloat(63,'file')" value="下载" />
								</span>
				        	</form>
						</div>
						<hr size="1" noshadow />
						<div id="partnerCover" style="float:top;margin:0px;background:#f8fff8;">
						</div>
					</div>
