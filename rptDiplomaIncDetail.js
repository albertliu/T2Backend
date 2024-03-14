				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
							<table style="width:100%;"><tr>
							<td style="float:left;">
								&nbsp;&nbsp;公司&nbsp;<select id="rptDiplomaHost" style="width:100px"></select>&nbsp;&nbsp;
								类别&nbsp;<select id="rptDiplomaKind" style="width:60px"></select>&nbsp;&nbsp;
								认证机构&nbsp;<select id="rptDiplomaAgency" style="width:50px"></select>&nbsp;&nbsp;
								证书&nbsp;<select id="rptDiplomaCert" style="width:100px"></select>&nbsp;&nbsp;
								状态&nbsp;<select id="rptDiplomaStatus" style="width:50px"></select>&nbsp;&nbsp;
								&nbsp;发证日期&nbsp;<input type="text" id="rptDiplomaStartDate" size="8" />-<input type="text" id="rptDiplomaEndDate" size="8" />
							</td>
							<td rowspan="2">
								<div style="float:right;padding-left:15px;">
								<input class="button" type="button" id="btnRptDiploma" value="报表预览" style="padding:2px;height:28px;">&nbsp;&nbsp;
								<input class="button" type="button" id="btnRptDiplomaDownLoad" value="报表下载" style="padding:2px;height:28px;">
								</div>
							</td></tr>
							<tr>
							<td style="float:left;">
								汇总项目&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaGroupHost" value="">&nbsp;公司&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaGroupDept" value="">&nbsp;部门&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaGroupKind" value="">&nbsp;类别&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaGroupAgency" value="">&nbsp;认证机构&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaGroupCert" value="">&nbsp;证书&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptDiplomaGroupStatus" value="">&nbsp;状态&nbsp;&nbsp;
								<input style="border:0px;" type="radio" id="rptDiplomaGroupDate1" name="rptDiplomaGroupDate" value="month" />月度
								<input style="border:0px;" type="radio" id="rptDiplomaGroupDate2" name="rptDiplomaGroupDate" value="quarter" />季度
								<input style="border:0px;" type="radio" id="rptDiplomaGroupDate3" name="rptDiplomaGroupDate" value="year" checked />年度
							</td>
							</tr></table>
				        </form>
					</div>
					<hr size="1" noshadow>
					<div id="rptDiplomaCover" style="float:top;margin:0px;background:#f8fff8;"></div>
				</div>
