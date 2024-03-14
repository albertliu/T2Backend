				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
						  <input id="txtSearchStudentNeedDiploma" name="txtSearchStudentNeedDiploma" class="easyui-textbox" 
							data-options="prompt:'姓名、身份证、证书名称...',
										icons: [{
											iconCls:'icon-clear',
											handler: function(e){
												$(e.data.target).textbox('clear');
											}
										},{
											iconCls:'icon-search',
											handler: function(e){
												getStudentNeedDiplomaList();
											}
										}],
										height:22
							"
							style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
							<span>
					          	项目&nbsp;<select id="searchStudentNeedDiplomaCert" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select>&nbsp;&nbsp;
							</span>
							<span id="searchStudentNeedDiplomaPartnerItem">
					            部门&nbsp;<select id="StudentNeedDiplomaPartner" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
				          	</span>
							<span id="searchStudentNeedDiplomaSalesItem">
								销售&nbsp;<select id="StudentNeedDiplomaSales" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
							</span>
							<span id='searchStudentNeedDiplomaPhotoItem'>
								有照片&nbsp;<select id="searchStudentNeedDiplomaHavePhoto" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
							</span>
							<span id="searchStudentNeedDiplomaItem1">
							    &nbsp;考试日期&nbsp;<input id="searchStudentNeedDiplomaStartDate" class="easyui-datebox" data-options="height:22,width:100" />-<input id="searchStudentNeedDiplomaEndDate" class="easyui-datebox" data-options="height:22,width:100" />
							</span>
							<input class="easyui-checkbox" id="searchStudentNeedDiplomaRefuse" value="1"/>&nbsp;拒绝申请&nbsp;&nbsp;
						    <span style="float:right;">
								<input class="button" type="button" id="btnSearchStudentNeedDiplomaDownload" value="下载" />
							</span>
							<br/>
							<hr style="margin:3px 0;" />
							<span>
								<a class="easyui-linkbutton" id="btnStudentNeedDiplomaSel" href="javascript:void(0)"></a>&nbsp;&nbsp;
							</span>
						    <span id="studentNeedDiplomaDoItem">
								<a class="easyui-linkbutton" id="btnStudentNeedDiplomaIssue" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnStudentNeedDiplomaCancel" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnStudentNeedDiplomaOk" href="javascript:void(0)"></a>
							</span>
							&nbsp;&nbsp;<input class="easyui-checkbox" id="searchStudentNeedDiplomaShowPhoto" checked value="1"/>&nbsp;显示照片&nbsp;
							<span id="studentNeedDiplomaPhotoItem">
								<a class="easyui-linkbutton" id="btnStudentNeedDiplomaAttentionPhoto" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnStudentNeedDiplomaAttentionPhotoClose" href="javascript:void(0)"></a>
							</span>
						    <span>
								<label>&nbsp;&nbsp;已选记录:</label>&nbsp;<label style="color: red; padding-right:10px;" id="searchStudentNeedDiplomaPick"></label>
							</span>
				        </form>
					</div>
					<hr style="margin:3px 0;" noshadow />
					<div id="studentNeedDiplomaCover" style="float:top;margin:0px;background:#f8fff8;">
					</div>
				</div>
