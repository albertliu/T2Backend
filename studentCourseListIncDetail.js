				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
						<form><label>搜索:</label>
				          <input type="text" id="txtSearchStudentCourse" name="txtSearchStudentCourse" size="10" title="姓名、身份证" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchStudentCourse" value="查找" />
						  	<span id="studentCourseListLongItem1">&nbsp;
					          &nbsp;公司&nbsp;<select id="searchStudentCourseHost" style="width:80px"></select>&nbsp;&nbsp;
				          	</span>
							<span id="studentCourseListLongItem2">
					          &nbsp;部门&nbsp;<select id="searchStudentCourseDept" style="width:100px"></select>&nbsp;&nbsp;
				          	</span>
							<span id="studentCourseListLongItem6">
								课程&nbsp;<select id="searchStudentCourseCertID" style="width:120px"></select>&nbsp;&nbsp;
							</span>
							班级&nbsp;<select id="searchStudentCourseClassID" style="width:180px"></select>&nbsp;&nbsp;
							<span id="studentCourseListLongItem4">
								<input style="border:0px;" type="checkbox" id="searchStudentCourseShowPhoto" value="" />&nbsp;图片&nbsp;&nbsp;
								状态&nbsp;<select id="searchStudentCourseStatus" style="width:50px"></select>&nbsp;&nbsp;
								状态&nbsp;<select id="searchStudentCoursePhotoStatus" style="width:50px"></select>&nbsp;&nbsp;
								<input class="button" type="button" id="btnStudentCourseBadPhoto" value="修正通知" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnStudentCourseGoodPhoto" value="修正确认" />
							</span>
							<span id="studentCourseListLongItem3">
							    &nbsp;报名日期&nbsp;<input type="text" id="searchStudentCourseStartDate" size="7" />-<input type="text" id="searchStudentCourseEndDate" size="7" />
							</span>
						    <span style="float:right;">
								<input class="button" type="button" name="btnDownLoad13" id="btnDownLoad13" onClick="outputFloat(13,'file')" value="下载" />
							</span>
							<br />
							确认&nbsp;<select id="searchStudentCourseChecked" style="width:70px"></select>&nbsp;&nbsp;&nbsp;
							报到&nbsp;<select id="searchStudentCourseSubmited" style="width:70px"></select>&nbsp;&nbsp;&nbsp;
							计划内&nbsp;<select id="searchStudentCourseMark" style="width:70px"></select>&nbsp;&nbsp;&nbsp;
							<input class="button" type="button" id="btnStudentCourseError" value="名单检查" />&nbsp;&nbsp;
							<input class="button" type="button" id="btnStudentCourseSel" value="全选/取消" />&nbsp;&nbsp;
							<input class="button" type="button" id="btnStudentCourseCall" value="上课通知" />&nbsp;&nbsp;
							<span id="studentCourseListLongItem5">
								<input class="button" type="button" id="btnStudentCourseCheck" value="名单确认" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnStudentCourseRefuse" value="剔除" />&nbsp;&nbsp;
							</span>
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="studentCourseCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
