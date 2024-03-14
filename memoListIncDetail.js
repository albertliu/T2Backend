				  	<div style="width:100%;float:left;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
							<a class="easyui-linkbutton" id="btnAddMemo" href="javascript:void(0)"></a>&nbsp;&nbsp;
						  	<input id="txtSearchMemo" name="txtSearchMemo" class="easyui-textbox" 
								data-options="prompt:'请输入标题...',
											icons: [{
												iconCls:'icon-clear',
												handler: function(e){
													$(e.data.target).textbox('clear');
												}
											},{
												iconCls:'icon-search',
												handler: function(e){
													getMemoList();
												}
											}],
											height:22
								"
								style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
							<span>
								类型&nbsp;<select id="searchMemoKind" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:90"></select>&nbsp;&nbsp;
							</span>
							<span>
							    日期&nbsp;<input type="text" id="searchMemoStart" class="easyui-datebox" data-options="height:22,width:100" />-<input type="text" id="searchMemoEnd" class="easyui-datebox" data-options="height:22,width:100" />
							</span>
							<input class="easyui-checkbox" id="searchMemoStatus" checked value="1"/>&nbsp;有效&nbsp;&nbsp;
						    <span style="float:right;">
								<input class="button" type="button" id="btnSearchMemoDownload" value="下载" />
							</span>
				        </form>
						</div>
						<hr style="margin:3px 0;" noshadow />
						<div id="memoCover" style="float:top;margin:0px;background:#f8fff8;">
						</div>
					</div>
