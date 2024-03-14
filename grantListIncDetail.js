				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchGrant" name="txtSearchGrant" size="20" title="标题、内容" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchGrant" id="btnSearchGrant" value="查找">
						      &nbsp;|&nbsp;
						      <input class="button" type="button" id="btnAddGrant" value="新增" />
						      &nbsp;|&nbsp;
				          <input style="border:0px;" type="radio" id="searchGrantKind0" name="searchGrantKind" value="0" checked />授权&nbsp;
				          <input style="border:0px;" type="radio" id="searchGrantKind1" name="searchGrantKind" value="1" />被授权
						      &nbsp;|&nbsp;
					        <span id="grantListLongItem1">
					          <input style="border:0px;" type="radio" id="searchGrantStatus0" name="searchGrantStatus" value="0" checked />有效&nbsp;
					          <input style="border:0px;" type="radio" id="searchGrantStatus1" name="searchGrantStatus" value="1" />关闭&nbsp;
					          <input style="border:0px;" type="radio" id="searchGrantStatus99" name="searchGrantStatus" value="99" />全部
				          </span>
							    <div style="margin: 2px 0px 0px 0px;">
							    	<label>日期：</label>
				          	<input type="text" id="searchGrantStart" size="8" title="起始日期" style="background:#AAFFAA;" />
				          	-
				          	<input type="text" id="searchGrantEnd" size="8" title="截止日期" style="background:#AAFFAA;" />
							      <span  style="float:right;">
									    <input class="button" type="button" name="btnDownLoad14" id="btnDownLoad14" onClick="outputFloat(14,'file')" value="下载">
									    <input class="button" type="button" name="btnPrint14" id="btnPrint14" onClick="outputFloat(14,'print')" value="打印">
								    </span>
				          </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="grantCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
