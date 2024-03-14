				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
					<form>
						<a class="easyui-linkbutton" id="btnSearchGenerateApplyAdd" href="javascript:void(0)"></a>&nbsp;&nbsp;
						<input id="txtSearchGenerateApply" name="txtSearchGenerateApply" class="easyui-textbox" 
							data-options="prompt:'请输入课程、批号、标题...',
										icons: [{
											iconCls:'icon-clear',
											handler: function(e){
												$(e.data.target).textbox('clear');
											}
										},{
											iconCls:'icon-search',
											handler: function(e){
												getGenerateApplyList();
											}
										}],
										height:22
							"
							style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
						<span>
							课程&nbsp;<select id="searchGenerateApplyCourseID" name="searchGenerateApplyCourseID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select>&nbsp;&nbsp;
						</span>
						<span>
							状态&nbsp;<select id="searchGenerateApplyStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
						</span>
						<span>
							补考&nbsp;<select id="searchGenerateApplyKindID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
						</span>
						<span id="applyPartnerItem">
							部门&nbsp;<select id="searchGenerateApplyPartner" name="searchGenerateApplyPartner" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
						</span>
						<span id="applySalesItem">
							销售&nbsp;<select id="searchGenerateApplySales" name="searchGenerateApplySales" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
						</span>
						<span>
							经办人&nbsp;<select id="searchGenerateApplyRegister" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
						</span>
						<span>
							申报日期&nbsp;<input id="searchGenerateApplyStart" class="easyui-datebox" data-options="height:22,width:100" />-<input id="searchGenerateApplyEnd" class="easyui-datebox" data-options="height:22,width:100" />
						</span>
						<span>
							<a class="easyui-linkbutton" id="searchGenerateApplyImportScore" href="javascript:void(0)"></a>
						</span>
					</form>
					</div>
					<hr style="margin:3px 0;" noshadow />
					<div id="generateApplyCover" style="float:top;margin:0px;background:#f8fff8;">
					</div>
				</div>
