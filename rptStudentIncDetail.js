				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
						<table style="width:100%;"><tr>
							<td style="float:left;">
								&nbsp;&nbsp;公司&nbsp;<select id="rptStudentHost" style="width:100px"></select>&nbsp;&nbsp;
								类别&nbsp;<select id="rptStudentKind" style="width:60px"></select>&nbsp;&nbsp;
								&nbsp;注册日期&nbsp;<input type="text" id="rptStudentStartDate" size="8" />-<input type="text" id="rptStudentEndDate" size="8" />
								</td>
							<td rowspan="2">
								<div style="float:right;padding-left:15px;">
								<input class="button" type="button" id="btnRptStudent" value="报表预览" style="padding:2px;height:28px;">&nbsp;&nbsp;
								<input class="button" type="button" id="btnRptStudentDownLoad" value="报表下载" style="padding:2px;height:28px;">
								</div>
							</td></tr>
							<tr>
							<td style="float:left;">
								汇总项目&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptStudentGroupHost" value="">&nbsp;公司&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptStudentGroupDept" value="">&nbsp;部门&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptStudentGroupKind" value="">&nbsp;类别&nbsp;&nbsp;
								<input style="border:0px;" type="radio" id="rptStudentGroupDate1" name="rptStudentGroupDate" value="month" />月度
								<input style="border:0px;" type="radio" id="rptStudentGroupDate2" name="rptStudentGroupDate" value="quarter" />季度
								<input style="border:0px;" type="radio" id="rptStudentGroupDate3" name="rptStudentGroupDate" value="year" checked />年度
							</td>
							</tr></table>
				        </form>
					</div>
					<hr size="1" noshadow>
					<div id="rptStudentCover" style="float:top;margin:0px;background:#f8fff8;"></div>
				</div>
