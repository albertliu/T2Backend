				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
						<form><label>搜索:</label>
				          <input type="text" id="txtSearchInvoice" name="txtSearchInvoice" size="10" title="发票编号" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchInvoice" value="查找" />&nbsp;
							付款状态&nbsp;<select id="searchInvoiceStatus" style="width:50px"></select>&nbsp;&nbsp;
							支付方式&nbsp;<select id="searchInvoiceType" style="width:75px"></select>&nbsp;&nbsp;
							付款类别&nbsp;<select id="searchInvoiceKind" style="width:75px"></select>&nbsp;&nbsp;
							<span id="invoiceListLongItem3">
							    &nbsp;开票日期&nbsp;<input type="text" id="searchInvoiceStartDate" size="8" />-<input type="text" id="searchInvoiceEndDate" size="8" />
							</span>
							<span id="invoiceListLongItem5">
								<input class="button" type="button" id="btnPaySel" value="全选/取消" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnPayCheck" value="接收" />&nbsp;&nbsp;
							</span>
						    <span style="float:right;">
								<input class="button" type="button" name="btnDownLoad13" id="btnDownLoad13" onClick="outputFloat(103,'file')" value="下载" />
							</span>
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="invoiceCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
