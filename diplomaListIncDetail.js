				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
							<form>
								<input id="txtSearchDiploma" name="txtSearchDiploma" class="easyui-textbox" 
								data-options="prompt:'姓名、身份证、证书编号',
											icons: [{
												iconCls:'icon-clear',
												handler: function(e){
													$(e.data.target).textbox('clear');
												}
											},{
												iconCls:'icon-search',
												handler: function(e){
													getDiplomaList();
												}
											}],
											height:22
								"
								style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
								<span>
									项目&nbsp;<select id="searchDiplomaCert" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select>&nbsp;&nbsp;
								</span>
								<span id="searchDiplomaPartnerItem">
									部门&nbsp;<select id="searchDiplomaPartner" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
								</span>
								<span id="searchDiplomaSalesItem">
									销售&nbsp;<select id="searchDiplomaSales" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
								</span>
								状态&nbsp;<select id="searchDiplomaStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
							    &nbsp;发证日期&nbsp;<input id="searchDiplomaStartDate" class="easyui-datebox" data-options="height:22,width:100" />-<input id="searchDiplomaEndDate" class="easyui-datebox" data-options="height:22,width:100" />
							    &nbsp;有效期&lt;=&nbsp;<input id="searchDiplomaLastDate" class="easyui-datebox" data-options="height:22,width:100" />
								<span style="float:right;">
									<input class="button" type="button" id="btnDownLoad20" onClick="outputFloat(20,'file')" value="下载" />
								</span>
								<br/>
								<hr style="margin:3px 0;" />
								<span>
									<a class="easyui-linkbutton" id="btnDiplomaSel" href="javascript:void(0)"></a>&nbsp;&nbsp;
								</span>
								<a class="easyui-linkbutton" id="btnDiplomaIssue" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnDiplomaCancel" href="javascript:void(0)"></a>
								&nbsp;&nbsp;<input class="easyui-checkbox" id="searchDiplomaDelivery" checked value="1"/>&nbsp;未领取&nbsp;
								<span>
								<label>&nbsp;&nbsp;已选记录:</label>&nbsp;<label style="color: red; padding-right:10px;" id="searchDiplomaPick"></label>
								</span>
							</form>
						</div>
						<hr size="1" noshadow />
						<div id="diplomaCover" style="float:top;margin:0px;background:#f8fff8;">
						</div>
					</div>
