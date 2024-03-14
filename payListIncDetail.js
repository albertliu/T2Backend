				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
						<form><label>搜索:</label>
				          <input type="text" id="txtSearchPay" name="txtSearchPay" size="10" title="姓名、身份证、课程、班级、发票" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchPay" value="查找" />&nbsp;
						  	<span id="payListLongItem1">&nbsp;
					          &nbsp;公司&nbsp;<select id="searchPayHost" style="width:80px"></select>&nbsp;&nbsp;
				          	</span>
							<span id="payListLongItem2">
					          &nbsp;部门&nbsp;<select id="searchPayDept" style="width:80px"></select>&nbsp;&nbsp;
				          	</span>
							付款&nbsp;<select id="searchPayStatus" style="width:50px"></select>&nbsp;&nbsp;
							<span id="payListLongItem6">
								课程&nbsp;<select id="searchPayCourseID" style="width:80px"></select>&nbsp;&nbsp;
							</span>
							批次&nbsp;<select id="searchPayProjectID" style="width:75px"></select>&nbsp;&nbsp;
							班级&nbsp;<select id="searchPayClassID" style="width:75px"></select>&nbsp;&nbsp;
							接收&nbsp;<select id="searchPayCheck" style="width:40px"></select>&nbsp;&nbsp;
							<span id="payListLongItem3">
							    &nbsp;收费日期&nbsp;<input type="text" id="searchPayStartDate" size="8" />-<input type="text" id="searchPayEndDate" size="8" />
							</span>
						    <span style="float:right;">
								<input class="button" type="button" name="btnDownLoad13" id="btnDownLoad13" onClick="outputFloat(102,'file')" value="下载" />
							</span>
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="payCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
