				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchTask" name="txtSearchTask" size="20" title="标题、内容" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchTask" id="btnSearchTask" value="查找">
						      &nbsp;|&nbsp;
						      <input class="button" type="button" id="btnAddTask" value="新增" />
						      &nbsp;|&nbsp;
				          <input style="border:0px;" type="radio" id="searchTaskKind0" name="searchTaskKind" value="0" />委托&nbsp;
				          <input style="border:0px;" type="radio" id="searchTaskKind1" name="searchTaskKind" value="1" checked />被委托
						      &nbsp;|&nbsp;
					        <span id="taskListLongItem1">
					          <input style="border:0px;" type="radio" id="searchTaskStatus0" name="searchTaskStatus" value="0" checked />活动&nbsp;
					          <input style="border:0px;" type="radio" id="searchTaskStatus1" name="searchTaskStatus" value="1" />完成&nbsp;
					          <input style="border:0px;" type="radio" id="searchTaskStatus2" name="searchTaskStatus" value="2" />取消&nbsp;
					          <input style="border:0px;" type="radio" id="searchTaskStatus99" name="searchTaskStatus" value="99" />全部
				          </span>
							    <div style="margin: 2px 0px 0px 0px;">
							    	<label>日期：</label>
				          	<input type="text" id="searchTaskStart" size="8" title="起始日期" style="background:#AAFFAA;" />
				          	-
				          	<input type="text" id="searchTaskEnd" size="8" title="截止日期" style="background:#AAFFAA;" />
							      <span  style="float:right;">
									    <input class="button" type="button" name="btnDownLoad15" id="btnDownLoad15" onClick="outputFloat(15,'file')" value="下载">
									    <input class="button" type="button" name="btnPrint15" id="btnPrint15" onClick="outputFloat(15,'print')" value="打印">
								    </span>
				          </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="taskCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
