				  	<div style="width:100%;float:right;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索:</label>
				          <input type="text" id="txtSearchStudent" name="txtSearchStudent" size="14" title="姓名、身份证" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchStudent" value="查找" />&nbsp;&nbsp;
				          <input class="button" type="button" id="btnSearchStudentAdd" value="添加" />
					        <span id="studentListLongItem1">
					          &nbsp;&nbsp;公司&nbsp;<select id="searchStudentHost" style="width:100px"></select>&nbsp;&nbsp;
					          类别&nbsp;<select id="searchStudentKind" style="width:50px"></select>&nbsp;&nbsp;
							  年龄&nbsp;<input type="text" id="searchStudentOld" name="searchStudentOld" size="2" title="以上" />&nbsp;&nbsp;
							  缺项&nbsp;<select id="searchStudentMaterial" style="width:50px"></select>&nbsp;&nbsp;
					          批次&nbsp;<select id="searchStudentProjectID" style="width:75px"></select>&nbsp;&nbsp;
				          </span>
							    &nbsp;注册日期&nbsp;<input type="text" id="searchStudentStartDate" size="7" />-<input type="text" id="searchStudentEndDate" size="7" />
						      <span style="float:right;">
								    <input class="button" type="button" id="btnDownLoad11" onClick="outputFloat(11,'file')" value="下载" />
							    </span>
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="studentCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
