				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
							<form><label>搜索:</label>
								<input type="text" id="txtsearchIssuedDiploma" name="txtsearchIssuedDiploma" size="14" title="姓名、身份证、证书编号" style="background:yellow;" />
								<input class="button" type="button" id="btnsearchIssuedDiploma" value="查找" />
								<span id="issuedDiplomaListLongItem1">&nbsp;&nbsp;
									&nbsp;&nbsp;公司&nbsp;<select id="searchIssuedDiplomaHost" style="width:100px"></select>&nbsp;&nbsp;
								</span>
								<span id="issuedDiplomaListLongItem2">&nbsp;&nbsp;
									&nbsp;&nbsp;部门&nbsp;<select id="searchIssuedDiplomaDept" style="width:100px"></select>&nbsp;&nbsp;
								</span>
								证书&nbsp;<select id="searchIssuedDiplomaKind" style="width:100px"></select>&nbsp;&nbsp;
								已发放&nbsp;<select id="searchIssuedDiplomaIssued" style="width:60px"></select>&nbsp;&nbsp;
								&nbsp;发放日期&nbsp;<input type="text" id="searchIssuedDiplomaStartDate" size="8" />-<input type="text" id="searchIssuedDiplomaEndDate" size="8" />
								<span style="float:right;">
									<input class="button" type="button" id="btnIssuedDiplomaSel" value="全选/取消" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnIssuedDiplomaIssue" value="发放证书" />&nbsp;&nbsp;
									<input class="button" type="button" id="btnDownLoad24" onClick="outputFloat(24,'file')" value="下载" />
								</span>
							</form>
						</div>
						<hr size="1" noshadow />
						<div id="issuedDiplomaCover" style="float:top;margin:0px;background:#f8fff8;">
						</div>
					</div>
