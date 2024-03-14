				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form><label>搜索:</label>
				          <input type="text" id="txtSearchGenerateScore" name="txtSearchGenerateScore" size="14" title="标题" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchGenerateScore" value="查找">&nbsp;&nbsp;
				          <input class="button" type="button" id="btnGenerateScoreAdd" value="添加">
					          &nbsp;&nbsp;鉴定项目&nbsp;<select id="searchGenerateScoreCert" style="width:100px"></select>&nbsp;&nbsp;
							  &nbsp;&nbsp;<label>导入日期</label>
				          	<input type="text" id="searchGenerateScoreStart" size="8" title="起始日期" style="background:#AAFFAA;" />
				          	-
				          	<input type="text" id="searchGenerateScoreEnd" size="8" title="截止日期" style="background:#AAFFAA;" />
						    <span style="float:right;">
								<input class="button" type="button" id="btnDownLoad4" onClick="outputFloat(4,'file')" value="下载">
							</span>
				        </form>
					</div>
					<hr size="1" noshadow>
					<div id="generateScoreCover" style="float:top;margin:0px;background:#f8fff8;"></div>
				</div>
