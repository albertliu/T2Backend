				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
							<a class="easyui-linkbutton" id="btnSearchEnterAdd" href="javascript:void(0)"></a>&nbsp;&nbsp;
						  	<input id="txtSearchEnter" name="txtSearchEnter" class="easyui-textbox" 
								data-options="prompt:'姓名.身份证.单位...',
											icons: [{
												iconCls:'icon-clear',
												handler: function(e){
													$(e.data.target).textbox('clear');
												}
											},{
												iconCls:'icon-search',
												handler: function(e){
													getEnterList();
												}
											}],
											height:22
								"
								style="width:180px;background:#FFFF00;"></input>&nbsp;&nbsp;
							<span>
								类别&nbsp;<select id="searchEnterAgencyID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
							</span>
							<span>
								课程&nbsp;<select id="searchEnterCourseID" name="searchEnterCourseID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:180"></select>&nbsp;&nbsp;
							</span>
							<span id="enterStatusItem">
								状态&nbsp;<select id="searchEnterStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
							</span>
							<span id="enterPartnerItem">
					            部门&nbsp;<select id="searchEnterPartner" name="searchEnterPartner" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:90"></select>&nbsp;&nbsp;
				          	</span>
							<span id="enterHostCheckItem">
								<input class="easyui-checkbox" id="searchEnterHostCheck" name="searchEnterHostCheck" value="1"/>&nbsp;
							</span>
							<span id="enterHostItem">
					            主管&nbsp;<select id="searchEnterHost" name="searchEnterHost" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:90"></select>&nbsp;&nbsp;
				          	</span>
							<span id="enterSalesItem">
								销售&nbsp;<select id="searchEnterSales" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
							</span>
							<span id="enterPayItem">
								付款&nbsp;<select id="searchEnterPay" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
							</span>
							<span id="enterSubmitItem">
								已提交&nbsp;<select id="searchEnterSubmit" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:80"></select>&nbsp;&nbsp;
							</span>
							<span>
							    <label id="searchEnterDateLabel" style="font-family: 幼圆; color: green;">报名日期</label>&nbsp;<input type="text" id="searchEnterStartDate" class="easyui-datebox" data-options="height:22,width:100" />-<input type="text" id="searchEnterEndDate" class="easyui-datebox" data-options="height:22,width:100" />
							</span>
							<span>
								<input class="easyui-checkbox" id="searchEnterPool" name="searchEnterPool" checked value="1"/>&nbsp;候考&nbsp;
								<input class="easyui-checkbox" id="searchEnterTry" name="searchEnterTry" value="1"/>&nbsp;试读&nbsp;
								<input class="easyui-checkbox" id="searchEnterInvoice" name="searchEnterInvoice" value="1"/>&nbsp;需开票&nbsp;
							</span>
							<br/>
							<hr style="margin:3px 0;" />
							<span>
								<a class="easyui-linkbutton" id="btnEnterSel" href="javascript:void(0)"></a>&nbsp;&nbsp;
							</span>
							<a class="easyui-linkbutton" id="btnEnterStudentImport" href="javascript:void(0)"></a>
							<a class="easyui-linkbutton" id="btnEnterReturn" href="javascript:void(0)"></a>
							<span id="enterApplyItem">
								<a class="easyui-linkbutton" id="btnEnterApply" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnEnterApplyByExcel" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnEnterApplyImport1" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnEnterApplyImport2" href="javascript:void(0)"></a>
								&nbsp;&nbsp;进度&nbsp;&gt;=&nbsp;<input type="text" id="searchEnter_completion1" class="easyui-textbox" data-options="height:22,width:40" />%&nbsp;&nbsp;
							</span>
							<a class="easyui-linkbutton" id="btnEnterSubmit" href="javascript:void(0)"></a>
							<a class="easyui-linkbutton" id="btnEnterSort" href="javascript:void(0)"></a>
							&nbsp;&nbsp;<input class="easyui-checkbox" id="searchEnterShowPhoto" name="searchEnterShowPhoto" value="1"/>&nbsp;显示照片&nbsp;
							<span id="enterPhotoItem">
								<a class="easyui-linkbutton" id="btnAttentionPhoto" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnAttentionSignature" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnAttentionPhotoClose" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnAttentionSignatureClose" href="javascript:void(0)"></a>
							</span>
							<span>
							<label>&nbsp;&nbsp;已选记录:</label>&nbsp;<label style="color: red; padding-right:10px;" id="searchEnterPick"></label>
							</span>
							<span id="enterQRItem" style="align:center; padding:10px;"><a class="easyui-linkbutton" id="btnSearchQR" href="javascript:void(0)"></a></span>
				        </form>
							</div>
							<hr style="margin:3px 0;" noshadow />
							<div id="enterCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
