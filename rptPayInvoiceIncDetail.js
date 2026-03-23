				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
							<span>
								&nbsp;收费日期&nbsp;<input id="rptPayInvoiceStartDate" class="easyui-datebox" data-options="height:22,width:100" />-<input id="rptPayInvoiceEndDate" class="easyui-datebox" data-options="height:22,width:100" />
								&nbsp;开票日期&nbsp;<input id="rptPayInvoiceStartDate1" class="easyui-datebox" data-options="height:22,width:100" />-<input id="rptPayInvoiceEndDate1" class="easyui-datebox" data-options="height:22,width:100" />
								&nbsp;&nbsp;<input class="easyui-checkbox" id="rptPayInvoiceAutoPay" name="rptPayInvoiceAutoPay" value="1"/>&nbsp;自助收费&nbsp;
								<input class="easyui-checkbox" id="rptPayInvoiceAutoInvoice" name="rptPayInvoiceAutoInvoice" value="1"/>&nbsp;自助开票&nbsp;
							</span>
							<span id="rptPayInvoiceItem1">
								<input class="easyui-checkbox" id="rptPayInvoiceReceivable" name="rptPayInvoiceReceivable" value="1"/>&nbsp;应收款&nbsp;
								<input class="easyui-checkbox" id="rptPayInvoiceReceived" name="rptPayInvoiceReceived" value="1"/>&nbsp;已收款&nbsp;
								<input class="button" type="button" id="btnRptPayInvoiceReceive" value="应收确认" />&nbsp;
							</span>
							<span style="padding-left:50px;">
								<a class="easyui-linkbutton" id="btnRptPayInvoice" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnRptPayInvoiceDownLoad" href="javascript:void(0)"></a>
							</span>
				        </form>
					</div>
					<hr size="1" noshadow />
					<div style="width:100%;">
						<div id="rptPayInvoiceCover" style="margin:0px;background:#f8fff8;"></div>
					</div>
				</div>
