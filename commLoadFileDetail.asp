<script language="javascript">
	var username = "";
	var action = uploadURL + "/outfiles/uploadSingle";
	var host = "";
	var para = "";
	var commMark = "";
	//alert(action);
	//mark:student,host,course
	//etc. ("student_photo","310102199209090021","student","spc"),  ("student_photo","0","mulitple","spc")
	function showLoadFile(loadOp,loadID,mark,p_host,par){
		username = loadID;
		host = p_host;
		arr = [];
		para = par;
		commMark = mark;
		if(host > ""){
			$("#commLoadFileHost").val(host);
		}
		if(mark=="studentList"){
			$("#commLoadFileHost").attr("disabled",true);
		}
		//alert(action + ":" + loadID + ":" + loadOp);
		//$("#formUpload").attr("action", action + "?upID=" + loadOp + "&username=" + loadID + "&currUser=" + currUser);
		
		if(mark=='student'){
			//student material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="student_photo" />学员照片&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="student_IDcardA" />身份证正面&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind2" name="uploadKind" value="student_IDcardB" />身份证背面&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind3" name="uploadKind" value="student_education" />学历证书&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind5" name="uploadKind" value="student_employment" />工作证明&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind6" name="uploadKind" value="student_jobCertificate" />居住证&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind8" name="uploadKind" value="student_social" />社保证明&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind4" name="uploadKind" value="student_CHESICC" />学信网认证&nbsp;');
		}
		if(mark=='host'){
			//host material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="host_logo" />LOGO&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="host_QR" />登录二维码&nbsp;');
		}
		if(mark=='course'){
			//course material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="course_video" />视频&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="course_courseware" />课件');
		}
		if(mark=='diploma'){
			//diploma material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="student_diploma" />认证证书&nbsp;');
		}
		if(mark=='project'){
			//project material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="project_brochure" />招生简章&nbsp;');
		}
		if(mark=='studentList'){
			//student material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="student_list" />学员报名表&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="score_list" />考试成绩单&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind2" name="uploadKind" value="apply_list" />申报结果&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind3" name="uploadKind" value="apply_score_list" />申报成绩和证书&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind4" name="uploadKind" value="ref_student_list" />预报名表&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind5" name="uploadKind" value="check_student_list" />学员信息核对&nbsp;');
		}
		if(mark=='mulitple'){
			//student material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="student_photo" />学员照片&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="student_IDcardA" />身份证正面&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind2" name="uploadKind" value="student_IDcardB" />身份证背面&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind3" name="uploadKind" value="student_education" />学历证书&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind4" name="uploadKind" value="student_diploma" />认证证书&nbsp;');
			$("#avatar").attr("multiple","mulitple");
			action = uploadURL + "/outfiles/uploadMultiple";
		}
		$("#radioCover").html(arr.join(""));
		$("input[value='" + loadOp + "']").attr("checked",true);

		document.getElementById("lightLoadFile").style.display="block";
		document.getElementById("fadeLoadFile").style.display="block";
	}

</script>
<div valign="baseline">
	<div id="lightLoadFile" class="white_content" STYLE="font-family: Arial; font-size: 12px; color: black"> 
		<div style="align:right;">
		  <span style="align:right;" onclick="document.getElementById('lightLoadFile').style.display='none';document.getElementById('fadeLoadFile').style.display='none'"><img src="../Images/close3.gif" />
		  </span>
		</div>   
		<div>公司&nbsp;<select id="commLoadFileHost" style="width:200px"></select></div> 
		<br>
		<div id="upload" align="left" style="border:solid 1px #e0e060;background:#ffffff;width:500;height:300;">
			<div align="center" style="background:#f0f0f0;vertical-align:middle;height:9;">文件上传</div>
			<div id="radioCover" style="margin: 10px;"></div>
			<form class="comm" action="" id="formUpload" name="formUpload" encType="multipart/form-data"  method="post" target="hidden_frame" >
				<div style="margin: 10px;">
					<input type="file" id="avatar" name="avatar" style="width:300px;height:28px;padding:2px;">
					&nbsp;&nbsp;<input name="restore" type="button"  id="restore" value="上传" style="cursor:hand;margin:10px;">
				</div>
			</form>
		</div>
	</div> 
	<div id="fadeLoadFile" class="black_overlay"></div> 
</div>
