				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
						<form><label>搜索:</label>
				          <input type="text" id="txtSearchGeneratePasscard" name="txtSearchGeneratePasscard" size="14" title="课程、班级名称" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchGeneratePasscard" value="查找" />
				          <input class="button" type="button" id="btnSearchGeneratePasscardAdd" value="添加" />
					          &nbsp;&nbsp;经办人&nbsp;<select id="searchGeneratePasscardRegister" style="width:100px"></select>&nbsp;&nbsp;
					          &nbsp;&nbsp;课程&nbsp;<select id="searchGeneratePasscardCert" style="width:100px"></select>&nbsp;&nbsp;
					          状态&nbsp;<select id="searchGeneratePasscardStatus" style="width:80px"></select>&nbsp;&nbsp;
							  &nbsp;&nbsp;<label>考试日期</label>
				          	<input type="text" id="searchGeneratePasscardStart" size="8" title="起始日期" style="background:#AAFFAA;" />
				          	-
				          	<input type="text" id="searchGeneratePasscardEnd" size="8" title="截止日期" style="background:#AAFFAA;" />
						    <span style="float:right;">
								<input class="button" type="button" onClick="outputFloat(104,'file')" value="下载" />
							</span>
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="generatePasscardCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
