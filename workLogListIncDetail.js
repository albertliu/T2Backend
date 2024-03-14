				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchWorkLog" name="txtSearchWorkLog" size="20" title="名称" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchWorkLog" id="btnSearchWorkLog" value="查找">
						      &nbsp;|&nbsp;
						      <input class="button" type="button" id="btnAddWorkLog" value="新增" />
						      &nbsp;|&nbsp;
					        <span id="workLogListLongItem1">
					          <input style="border:0px;" type="radio" id="searchWorkLogStatus0" name="searchWorkLogStatus" value="0" checked />活动&nbsp;
					          <input style="border:0px;" type="radio" id="searchWorkLogStatus1" name="searchWorkLogStatus" value="1" />关闭&nbsp;
					          <input style="border:0px;" type="radio" id="searchWorkLogStatus99" name="searchWorkLogStatus" value="99" />全部
				          </span>
						      &nbsp;|&nbsp;
					        <label>范围&nbsp;</label><select id="searchWorkLogPrivate" style="width:50px"></select>
						      &nbsp;|&nbsp;
						    	<label>日期：</label>
			          	<input type="text" id="searchWorkLogStart" size="8" title="起始日期" style="background:#AAFFAA;" />
			          	-
			          	<input type="text" id="searchWorkLogEnd" size="8" title="截止日期" style="background:#AAFFAA;" />
							    <div style="margin: 2px 0px 0px 0px;">
					          <input style="border:0px;" type="radio" id="searchWorkLogKind0" name="searchWorkLogKind" value="0" />普通&nbsp;
					          <input style="border:0px;" type="radio" id="searchWorkLogKind1" name="searchWorkLogKind" value="1" />工程&nbsp;
							      <input style="border:0px;" type="radio" id="searchWorkLogKind2" name="searchWorkLogKind" value="2" />项目&nbsp;
					          <input style="border:0px;" type="radio" id="searchWorkLogKind99" name="searchWorkLogKind" value="99" checked />全部
							      &nbsp;|&nbsp;
					          工程&nbsp;<select id="searchWorkLogEngineering" style="width:100px"></select>&nbsp;&nbsp;
					          项目&nbsp;<select id="searchWorkLogProject" style="width:100px"></select>&nbsp;&nbsp;
					          人员&nbsp;<select id="searchWorkLogUser" style="width:100px"></select>
							      <span  style="float:right;">
									    <input class="button" type="button" name="btnDownLoad12" id="btnDownLoad12" onClick="outputFloat(12,'file')" value="下载">
									    <input class="button" type="button" name="btnPrint12" id="btnPrint12" onClick="outputFloat(12,'print')" value="打印">
								    </span>
				          </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="workLogCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
