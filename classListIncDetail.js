				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchClass" name="txtSearchClass" size="15" title="班级编号、课程名称" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchClass" id="btnSearchClass" value="查找" />
						      <input class="button" type="button" id="btnAddClass" name="btnAddClass" value="新增" />
						      &nbsp;|&nbsp;
							  班主任&nbsp;<select id="searchClassAdviser" style="width:90px"></select>&nbsp;&nbsp;
					          &nbsp;课程&nbsp;<select id="searchClassCert" style="width:120px"></select>&nbsp;
					          &nbsp;批次&nbsp;<select id="searchClassProject" style="width:120px"></select>&nbsp;
							  状态&nbsp;<select id="searchClassStatus" style="width:50px"></select>&nbsp;
							  属性&nbsp;<select id="searchClassPartner" style="width:90px"></select>&nbsp;
						      	<span style="float:right;">
								  	<input class="button" type="button" id="btnCheckStudent" value="核对学员信息" />&nbsp;&nbsp;
									<a href="output/学员信息核对模板.xlsx">模板下载</a>&nbsp;&nbsp;
								    <input class="button" type="button" onClick="outputFloat(91,'file')" value="下载" />
								</span>
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="classCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
