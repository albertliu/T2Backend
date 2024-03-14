				  	<div style="width:100%;float:left;margin:0;">
							<div chartsincome="comm" align='left' style="background:#fdfdfd;">
								<form>
				          <input class="button" type="button" id="btnSearchChartsIncome" value="查询" />&nbsp;&nbsp;
					          &nbsp;课程&nbsp;<select id="searchChartsIncomeCert" style="width:120px"></select>&nbsp;&nbsp;
					          <label id="searchChartsIncomeDateItem">日期</label>&nbsp;<input type="text" id="searchChartsIncomeStartDate" size="8" />-<input type="text" id="searchChartsIncomeEndDate" size="8" />
					          &nbsp;&nbsp;销售&nbsp;<select id="searchChartsIncomeFromID" style="width:90px"></select>
							  &nbsp;&nbsp;&nbsp;&nbsp;汇总方式&nbsp;&nbsp;
								<input style="border:0px;" type="radio" id="rptChartsIncomeGroupDate1" name="rptChartsIncomeGroupDate" value="d" />日
								<input style="border:0px;" type="radio" id="rptChartsIncomeGroupDate2" name="rptChartsIncomeGroupDate" value="w" />周
								<input style="border:0px;" type="radio" id="rptChartsIncomeGroupDate3" name="rptChartsIncomeGroupDate" value="m" checked />月
								<input style="border:0px;" type="radio" id="rptChartsIncomeGroupDate4" name="rptChartsIncomeGroupDate" value="y" />年
							&nbsp;&nbsp;&nbsp;&nbsp;快速选择&nbsp;&nbsp;
								<input style="border:0px;" type="radio" id="rptChartsIncomeDate1" name="rptChartsIncomeDate" value="1" />最近一周
								<input style="border:0px;" type="radio" id="rptChartsIncomeDate2" name="rptChartsIncomeDate" value="2" />最近三个月
								<input style="border:0px;" type="radio" id="rptChartsIncomeDate3" name="rptChartsIncomeDate" value="3" checked />最近六个月
								<input style="border:0px;" type="radio" id="rptChartsIncomeDate4" name="rptChartsIncomeDate" value="4" />最近一年
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="chartsIncomeTotal" style="padding:3px; background:#f8f8f8;"></div>
							<div id="chartsIncomePie" style="float:left;margin:0px;background:#f8fff8;width: 55%;height:300px;"></div>
							<div id="chartsIncomePie1" style="float:right;margin:0px;background:#f8f8ff;width: 45%;height:300px;"></div>
							<div style="float:right;margin:0px;background:#dddddd;width: 45%;height:5px;"></div>
							<div style="float:left;margin:0px;background:#dddddd;width: 55%;height:5px;"></div>
							<div id="chartsIncomeCover" style="float:left;margin:0px;background:#f8fff8;width: 100%;height:605px;"></div>
						</div>
