				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
							<table style="width:100%;"><tr>
							<td style="float:left;">
								&nbsp;&nbsp;公司&nbsp;<select id="rptDiplomaLastHost" style="width:100px"></select>&nbsp;&nbsp;
								类别&nbsp;<select id="rptDiplomaLastKind" style="width:60px"></select>&nbsp;&nbsp;
								认证机构&nbsp;<select id="rptDiplomaLastAgency" style="width:50px"></select>&nbsp;&nbsp;
								证书&nbsp;<select id="rptDiplomaLastCert" style="width:100px"></select>&nbsp;&nbsp;
								状态&nbsp;<select id="rptDiplomaLastStatus" style="width:50px"></select>&nbsp;&nbsp;
								&nbsp;有效日期&nbsp;<input type="text" id="rptDiplomaLastStartDate" size="8" />-<input type="text" id="rptDiplomaLastEndDate" size="8" />
							</td>
							<td rowspan="2">
								<div style="float:right;padding-left:15px;">
								<input class="button" type="button" id="btnRptDiplomaLast" value="报表预览" style="padding:2px;height:28px;">&nbsp;&nbsp;
								<input class="button" type="button" id="btnRptDiplomaLastDownLoad" value="报表下载" style="padding:2px;height:28px;">
								</div>
							</td></tr>
							<tr>
							<td style="float:left;">
								汇总项目&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaLastGroupHost" value="">&nbsp;公司&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaLastGroupDept" value="">&nbsp;部门&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaLastGroupKind" value="">&nbsp;类别&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaLastGroupAgency" value="">&nbsp;认证机构&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaLastGroupCert" value="">&nbsp;证书&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaLastGroupStatus" value="">&nbsp;状态&nbsp;&nbsp;
								<input style="border:0px;" type="radio" id="rptDiplomaLastGroupDate1" name="rptDiplomaLastGroupDate" value="month" />月度
								<input style="border:0px;" type="radio" id="rptDiplomaLastGroupDate2" name="rptDiplomaLastGroupDate" value="quarter" />季度
								<input style="border:0px;" type="radio" id="rptDiplomaLastGroupDate3" name="rptDiplomaLastGroupDate" value="year" checked />年度
							</td>
							</tr></table>
				        </form>
					</div>
					<hr size="1" noshadow>
					<div id="rptDiplomaLastCover" style="float:top;margin:0px;background:#f8fff8;"></div>
				</div>
