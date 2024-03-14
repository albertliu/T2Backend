<!--#include file="js/doc.js" -->

<%

if(op == "getStudentCourseList"){
	var s = "";
	var d = 0;
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = where.replace(/\s+/g, "");
		where = "(name like('%" + where + "%') or username='" + where + "' or unit like('%" + where + "%'))";
		d += 1;
	}
	
	s = "host='" + (host>""?host:currHost) + "'";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}

	//如果有部门
	if(String(Request.QueryString("partnerID")) > "" && String(Request.QueryString("partnerID")) != "null" && String(Request.QueryString("partnerID")) !="undefined"){ // 
		s = "partnerID='" + String(Request.QueryString("partnerID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有销售
	if(String(Request.QueryString("sales")) > "0" && String(Request.QueryString("sales")) != "null" && String(Request.QueryString("sales")) !="undefined"){ // 
		s = "sales='" + String(Request.QueryString("sales")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果候考
	if(String(Request.QueryString("pool")) == "1"){ // 
		s = "inPool=0";	//0 候考  1 非候考
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态 默认显示未退课人员
	if(status > "" && status !="undefined"){ // 
		s = "status=" + status;
	}else{
		if(String(Request.QueryString("mark")) != "2" && d == 0){	//个人信息
			s = "status<3";
		}
	}
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}

	//如果有人
	if(keyID > ""){ // 
		s = "username='" + keyID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	//课程
	if(String(Request.QueryString("courseID")) > "" && String(Request.QueryString("courseID")) !="undefined"){
		s = "courseID='" + String(Request.QueryString("courseID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//提交
	if(String(Request.QueryString("submited")) > "" && String(Request.QueryString("submited")) !="undefined"){
		s = "submited=" + String(Request.QueryString("submited"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//试读
	if(String(Request.QueryString("try")) == "1"){
		s = "try=1";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
		d += 1;
	}else{
		s = "try=0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果需开票
	if(String(Request.QueryString("needInvoice")) == "1"){ // 
		s = "needInvoice=1";	//1 需开票
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
		d += 1;
	}
	//付款
	if(String(Request.QueryString("pay")) > "" && String(Request.QueryString("pay")) !="undefined"){
		s = "pay_status=" + String(Request.QueryString("pay"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	//学习进度
	if(String(Request.QueryString("completion1")) > "" && String(Request.QueryString("completion1")) !="undefined"){
		s = "completion>=" + String(Request.QueryString("completion1"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//ID list
	var list = 0;
	if(String(Request.QueryString("list")) > "" && String(Request.QueryString("list")) !="undefined"){
		list = 1;
		s = "ID in(" + String(Request.QueryString("list")) + ")";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
		d += 1;
	}

	if(fStart > "" && fStart !="undefined" && d == 0){
		if(String(Request.QueryString("enterListDateKind"))==0){
			s = "regDate>='" + fStart + "'";
		}else{
			s = "currDiplomaDate>='" + fStart + "'";	//安监复训 复审日期
		}
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && fEnd !="undefined" && d == 0){
		if(String(Request.QueryString("enterListDateKind"))==0){
			s = "regDate<='" + fEnd + "'";
		}else{
			s = "currDiplomaDate<='" + fEnd + "'";	//安监复训 复审日期
		}
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_studentCourseList " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT SNo,username,name,sexName,age,educationName,unit,job,mobile,phone,checkName,statusName,price,pay_typeName,pay_kindName,datePay,invoice,completion,(case when examScore=0 then '' else cast(cast(examScore as int) as varchar) end),score,diplomaID,diploma_startDate,diploma_endDate,memo,regDate" + sql + " order by SNo";
	sql = "SELECT top " + basket + " * " + sql + " order by " + (list==1 ? "name" : "ID desc");
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("courseID").value + "|" + rs("status").value + "|" + rs("hours").value + "|" + rs("startDate").value + "|" + rs("endDate").value;
		//7
		result += "|" + rs("completion").value + "|" + rs("name").value + "|" + rs("age").value + "|" + rs("sex").value + "|" + rs("mobile").value + "|" + rs("sexName").value + "|" + rs("closeDate").value;
		//14
		result += "|" + rs("completionPass").value + "|" + rs("job").value + "|" + rs("checked").value + "|" + rs("checkName").value + "|" + rs("checkDate").value + "|" + rs("checker").value + "|" + rs("checkerName").value;
		//21
		result += "|" + rs("SNo").value + "|" + rs("photo_filename").value + "|" + rs("IDa_filename").value + "|" + rs("IDb_filename").value + "|" + rs("edu_filename").value + "|" + rs("cert_filename").value;
		//27
		result += "|" + rs("employe_filename").value + "|" + rs("submited").value + "|" + rs("submitDate").value + "|" + rs("submiter").value + "|" + rs("submitName").value + "|" + rs("certID").value;
		//33
		result += "|" + rs("educationName").value + "|" + rs("phone").value + "|" + rs("unit").value + "|" + rs("currDiplomaID").value + "|" + rs("reexamine").value + "|" + rs("reexamineName").value;
		//39
		result += "|" + rs("submiterName").value + "|" + rs("reExamCount").value + "|" + rs("currDiplomaDate").value + "|" + rs("sales").value + "|" + rs("signature").value + "|" + rs("signatureDate").value;
		//45
		result += "|" + rs("status_photo").value + "|" + rs("status_signature").value + "|" + rs("signatureType").value + "|" + rs("file1").value + "|" + rs("file2").value + "|" + rs("file3").value;
		//51
		result += "|" + rs("overdue").value + "|" + rs("express").value + "|" + rs("inPool").value + "|" + rs("partnerID").value + "|" + rs("diplomaID").value + "|" + rs("certName").value;
		//57
		result += "|" + rs("shortName").value + "|" + rs("re").value + "|" + rs("cancelAllow").value + "|" + rs("cards").value + "|" + rs("cardsRest").value + "|" + rs("retake").value;
		//63
		result += "|" + rs("price").value + "|" + rs("amount").value + "|" + rs("pay_kindID").value + "|" + rs("pay_type").value + "|" + rs("datePay").value + "|" + rs("invoice").value + "|" + rs("title").value;
		//70
		result += "|" + rs("dateInvoice").value + "|" + rs("dateInvoicePick").value + "|" + rs("dateRefund").value + "|" + rs("refunderID").value + "|" + rs("pay_checkDate").value + "|" + rs("pay_checker").value;
		//76
		result += "|" + rs("pay_memo").value + "|" + rs("pay_status").value + "|" + rs("score").value + "|" + rs("score1").value + "|" + rs("score2").value + "|" + rs("result").value + "|" + rs("entryForm").value;
		//83
		result += "|" + rs("resultName").value + "|" + rs("pay_kindName").value + "|" + rs("pay_typeName").value + "|" + rs("pay_statusName") + "|" + rs("courseName1") + "|" + rs("regDate") + "|" + rs("registerID");
		//90
		result += "|" + rs("partnerName") + "|" + rs("kindID").value + "|" + rs("statusName").value + "|" + rs("memo").value + "|" + rs("pay_checkerName").value + "|" + rs("refunderName").value + "|" + rs("retakeRefID").value;
		//97
		result += "|" + rs("reExamCount").value + "|" + rs("examScore").value + "|" + rs("examTimes").value + "|" + rs("sc").value + "|" + rs("file4").value + "|" + rs("photo_size").value + "|" + rs("agencyID").value + "|" + rs("salesName").value;
		//105
		result += "|" + rs("file5").value + "|" + rs("needInvoice").value + "|" + rs("scanID").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	//Response.Write(escape(result));
	Response.Write((sql));
}	

if(op == "getStudentListByClass"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "')";
	}
	//报到日期
	if(fStart > "" && fStart !="undefined"){
		s = "submitDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//预报名
	if(kindID > ""){
		s = "mark=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && fEnd !="undefined"){
		s = "submitDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//确认
	if(String(Request.QueryString("checked")) > "" && String(Request.QueryString("checked")) !="undefined"){
		s = "checked=" + String(Request.QueryString("checked"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//报到
	if(String(Request.QueryString("submited")) > "" && String(Request.QueryString("submited")) !="undefined"){
		s = "submited=" + String(Request.QueryString("submited"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM dbo.getStudentListByClass('" + refID + "','" + host + "') " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT ID,SNo,username,name,education,stationName,job,mobile,memo,expireDate,invoice,checkDate,checkerName,submitDate,submiterName,(case when mark=0 then '计划内' else '计划外' end) as kind" + sql + " order by mark,ID";
	sql = "SELECT top " + basket + " *" + sql + " order by mark,ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("SNo").value + "|" + rs("education").value + "|" + rs("job").value + "|" + rs("mobile").value;
		//7
		result += "|" + rs("mark").value + "|" + rs("stationName").value + "|" + rs("dept1").value + "|" + rs("deptName").value + "|" + rs("expireDate").value;
		//12
		result += "|" + rs("invoice").value + "|" + rs("classID").value + "|" + rs("memo").value;
		//15
		result += "|" + rs("submited").value + "|" + rs("submitDate").value + "|" + rs("submiter").value + "|" + rs("submiterName").value;
		//19
		result += "|" + rs("checked").value + "|" + rs("checkDate").value + "|" + rs("checker").value + "|" + rs("checkerName").value + "|" + rs("enterID").value;
		//24
		result += "|" + rs("fromID").value + "|" + rs("signature").value + "|" + rs("signatureDate").value + "|" + rs("status_photo").value + "|" + rs("status_signature").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
}	

if(op == "getNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_studentCourseList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("username").value + "|" + rs("courseID").value + "|" + rs("status").value + "|" + rs("hours").value + "|" + rs("startDate").value + "|" + rs("endDate").value;
		//7
		result += "|" + rs("completion").value + "|" + rs("name").value + "|" + rs("age").value + "|" + rs("sex").value + "|" + rs("mobile").value + "|" + rs("sexName").value + "|" + rs("closeDate").value;
		//14
		result += "|" + rs("completionPass").value + "|" + rs("job").value + "|" + rs("checked").value + "|" + rs("checkName").value + "|" + rs("checkDate").value + "|" + rs("checker").value + "|" + rs("checkerName").value;
		//21
		result += "|" + rs("SNo").value + "|" + rs("photo_filename").value + "|" + rs("IDa_filename").value + "|" + rs("IDb_filename").value + "|" + rs("edu_filename").value + "|" + rs("cert_filename").value;
		//27
		result += "|" + rs("employe_filename").value + "|" + rs("submited").value + "|" + rs("submitDate").value + "|" + rs("submiter").value + "|" + rs("submitName").value + "|" + rs("certID").value;
		//33
		result += "|" + rs("educationName").value + "|" + rs("phone").value + "|" + rs("unit").value + "|" + rs("currDiplomaID").value + "|" + rs("reexamine").value + "|" + rs("reexamineName").value;
		//39
		result += "|" + rs("submiterName").value + "|" + rs("reExamCount").value + "|" + rs("currDiplomaDate").value + "|" + rs("sales").value + "|" + rs("signature").value + "|" + rs("signatureDate").value;
		//45
		result += "|" + rs("status_photo").value + "|" + rs("status_signature").value + "|" + rs("signatureType").value + "|" + rs("file1").value + "|" + rs("file2").value + "|" + rs("file3").value;
		//51
		result += "|" + rs("overdue").value + "|" + rs("express").value + "|" + rs("inPool").value + "|" + rs("partnerID").value + "|" + rs("diplomaID").value + "|" + rs("certName").value;
		//57
		result += "|" + rs("shortName").value + "|" + rs("re").value + "|" + rs("cancelAllow").value + "|" + rs("cards").value + "|" + rs("cardsRest").value + "|" + rs("retake").value;
		//63
		result += "|" + rs("price").value + "|" + rs("amount").value + "|" + rs("pay_kindID").value + "|" + rs("pay_type").value + "|" + rs("datePay").value + "|" + rs("invoice").value + "|" + rs("title").value;
		//70
		result += "|" + rs("dateInvoice").value + "|" + rs("dateInvoicePick").value + "|" + rs("dateRefund").value + "|" + rs("refunderID").value + "|" + rs("pay_checkDate").value + "|" + rs("pay_checker").value;
		//76
		result += "|" + rs("pay_memo").value + "|" + rs("pay_status").value + "|" + rs("score").value + "|" + rs("score1").value + "|" + rs("score2").value + "|" + rs("result").value + "|" + rs("entryForm").value;
		//83
		result += "|" + rs("resultName").value + "|" + rs("pay_kindName").value + "|" + rs("pay_typeName").value + "|" + rs("pay_statusName") + "|" + rs("courseName1") + "|" + rs("regDate") + "|" + rs("registerID");
		//90
		result += "|" + rs("partnerName") + "|" + rs("kindID").value + "|" + rs("statusName").value + "|" + rs("memo").value + "|" + rs("pay_checkerName").value + "|" + rs("refunderName").value + "|" + rs("retakeRefID").value;
		//97
		result += "|" + rs("reExamCount").value + "|" + rs("examScore").value + "|" + rs("examTimes").value + "|" + rs("sc").value + "|" + rs("pcode").value + "|" + rs("entryform").value;
		//103
		result += "|" + rs("refund_amount").value + "|" + rs("refund_memo").value + "|" + rs("hostName").value + "|" + rs("register_signature").value + "|" + rs("host_signature").value + "|" + rs("registerName").value;
		//109
		result += "|" + rs("file4").value + "|" + rs("try").value + "|" + rs("person").value + "|" + rs("agencyID").value + "|" + rs("price1").value + "|" + rs("channel").value + "|" + rs("signatureDate1").value;
		//116
		result += "|" + rs("file5").value + "|" + rs("needInvoice").value + "|" + rs("payNow").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "update"){
	result = 0;
	if(result == 0){
		nodeID = Request.Form("ID");
		//@ID int,@username varchar(50),@courseID varchar(50),@cards int,@overdue int,@express int,@retake int,@currDiplomaID varchar(50),@currDiplomaDate varchar(50),@signatureType int,
		//@partnerID int,@sales varchar(50),@host varchar(50),@memo varchar(500),@price decimal(18,2),@amount decimal(18,2),@pay_kindID int,@pay_type int,@invoice varchar(50),
		//@title nvarchar(100),@dateInvoice varchar(50),@dateInvoicePick varchar(50),@pay_memo nvarchar(500),@registerID varchar(50)
		sql = "exec updateEnterInfo " + Request.Form("ID") + ",'" + Request.Form("student") + "','" + Request.Form("courseID") + "','" + Request.Form("needInvoice") + "','" + Request.Form("payNow") + "','" + Request.Form("cards") + "','" + Request.Form("overdue") + "','" + Request.Form("express") + "','" + Request.Form("retake") + "','" + Request.Form("currDiplomaID") + "','" + Request.Form("currDiplomaDate") + "','" + Request.Form("signatureDate") + "','" + Request.Form("signatureDate1") + "','" + Request.Form("signatureType");
		sql += "',0,'" + currPartner + "','" + Request.Form("sales") + "','" + Request.Form("channel") + "','" + currHost + "','" + Request.Form("memo") + "','" + Request.Form("price") + "','" + Request.Form("amount") + "','" + Request.Form("pay_kindID") + "','" + Request.Form("pay_type") + "','" + Request.Form("pay_status") + "','" + Request.Form("invoice");
		sql += "','" + Request.Form("title") + "','" + Request.Form("datePay") + "','" + Request.Form("dateInvoice") + "','" + Request.Form("dateInvoicePick") + "','" + Request.Form("pay_memo") + "','" + Request.Form("try") + "','" + Request.Form("person") + "','" + currUser + "'";
		
		/*rs = conn.Execute(sql);
		if (!rs.EOF){
			result = rs("re").value + "|" + rs("msg").value + "|" + rs("enterID").value;
		}
		rs.Close();*/
	}
	//Response.Write(escape(result));
	Response.Write(escape(sql));
}

if(op == "getPayList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or courseName like('%" + where + "%') or classID like('%" + where + "%') or invoice like('%" + where + "%'))";
	}
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
		//如果有部门
		if(currDeptID > 0){ // 
			s = "dept1=" + currDeptID;
			where = where + " and " + s;
		}
	}
	//如果有状态
	if(status > "" && status !="undefined"){ // 
		s = "pay_status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有人
	if(keyID > "" && keyID != "null" && keyID !="undefined"){ // 
		s = "username='" + keyID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(fStart > "" && fStart !="undefined"){
		s = "datePay>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && fEnd !="undefined"){
		s = "datePay<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//课程
	if(String(Request.QueryString("courseID")) > "" && String(Request.QueryString("courseID")) !="undefined"){
		s = "courseID='" + String(Request.QueryString("courseID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//mark=3: 当前用户为销售
	if(String(Request.QueryString("mark")) == 3){
		s = "fromID='" + currUser + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_payDetailInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT SNo,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,checkName,courseName,hours,statusName,startDate,completion,examScore,memo,regDate" + sql + " order by projectID,SNo";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("payID").value + "|" + rs("enterID").value + "|" + rs("price").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//8
		result += "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1").value + "|" + rs("dept1Name").value + "|" + rs("dept2").value + "|" + rs("dept2Name").value;
		//16
		result += "|" + rs("payID_old").value + "|" + rs("invoice").value + "|" + rs("datePay").value + "|" + rs("pay_checkDate").value + "|" + rs("pay_checkerID").value + "|" + rs("pay_checkerName").value;
		//22
		result += "|" + rs("dateInvoice").value + "|" + rs("dateInvoicePick").value + "|" + rs("dateRefund").value + "|" + rs("refunderID").value + "|" + rs("refunderName").value;
		//27
		result += "|" + rs("projectID").value + "|" + rs("projectName").value + "|" + rs("classID").value + "|" + rs("className").value + "|" + rs("SNo").value;
		//32
		result += "|" + rs("pay_kindID").value + "|" + rs("pay_kindName").value + "|" + rs("pay_type").value + "|" + rs("pay_typeName").value + "|" + rs("pay_status").value + "|" + rs("pay_statusName").value;
		//38
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("unit").value + "|" + rs("dept").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
}	

if(op == "getPayInfo"){
	result = "";
	sql = "SELECT * FROM v_payInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("invoice").value + "|" + rs("amount").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("type").value + "|" + rs("typeName").value;
		//9
		result += "|" + rs("datePay").value + "|" + rs("dateInvoice").value + "|" + rs("dateInvoicePick").value + "|" + rs("dateRefund").value + "|" + rs("refunderID").value + "|" + rs("refunderName").value;
		//15
		result += "|" + rs("checkDate").value + "|" + rs("checkerID").value + "|" + rs("checkerName").value;
		//18
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("title").value + "|" + rs("projectID").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getInvoiceList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(invoice like('%" + where + "%'))";
	}
	//如果有状态
	if(status > "" && status !="undefined"){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有
	if(kindID > "" && kindID != "null" && kindID !="undefined"){ // 
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有
	if(refID > "" && refID != "null" && refID !="undefined"){ // 
		s = "type=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > "" && fStart !="undefined"){
		s = "dateInvoice>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && fEnd !="undefined"){
		s = "dateInvoice<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//财务确认
	if(String(Request.QueryString("checked")) == 0 && String(Request.QueryString("checked")) !="undefined"){
		s = "checkDate=''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//财务确认
	if(String(Request.QueryString("checked")) == 1 && String(Request.QueryString("checked")) !="undefined"){
		s = "checkDate>''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_payInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT SNo,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,checkName,courseName,hours,statusName,startDate,completion,examScore,memo,regDate" + sql + " order by projectID,SNo";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("invoice").value + "|" + rs("amount").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("type").value + "|" + rs("typeName").value;
		//9
		result += "|" + rs("datePay").value + "|" + rs("dateInvoice").value + "|" + rs("dateInvoicePick").value + "|" + rs("dateRefund").value + "|" + rs("refunderID").value + "|" + rs("refunderName").value;
		//15
		result += "|" + rs("checkDate").value + "|" + rs("checkerID").value + "|" + rs("checkerName").value;
		//18
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("title").value + "|" + rs("projectID").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
}	

if(op == "getPayDetailInfoByEnterID"){
	result = "";
	sql = "SELECT * FROM v_payDetailInfo where enterID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("payID").value + "|" + rs("enterID").value + "|" + rs("price").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("payID_old").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getFiremanEnterInfo"){
	result = "";
	sql = "SELECT * FROM v_firemanEnterInfo where enterID=" + refID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("enterID").value + "|" + rs("area").value + "|" + rs("address").value + "|" + rs("employDate").value + "|" + rs("university").value + "|" + rs("gradeDate").value + "|" + rs("profession").value + "|" + rs("area_now").value;
		//9
		result += "|" + rs("kind1").value + "|" + rs("kind2").value + "|" + rs("kind3").value + "|" + rs("kind4").value + "|" + rs("kind5").value + "|" + rs("kind6").value + "|" + rs("kind7").value + "|" + rs("kind8").value + "|" + rs("kind9").value + "|" + rs("kind10").value + "|" + rs("kind11").value + "|" + rs("kind12").value;
		//21
		result += "|" + rs("materials").value + "|" + rs("materials1").value + "|" + rs("zip").value + "|" + rs("memo").value + "|" + rs("registerID").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentListByClassCheck"){
	result = "";
	sql = "SELECT name,username,dbo.getClassRefrence(username,classID) as item FROM dbo.getStudentListByClass('" + refID + "','" + host + "') where dbo.getClassRefrence(username,classID)>''";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("name").value + "|" + rs("username").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentListByProjectCheck"){
	result = "";
	sql = "SELECT name,username,(courseName1 + ', ' + courseName2) as item FROM dbo.getProjectRefrence('" + refID + "')";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("name").value + "|" + rs("username").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentExamStat"){
	result = "";
	sql = "EXEC getStudentExamStat " + refID;
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("regDate").value + "|" + rs("knowpointName").value + "|" + rs("kindName").value + "|" + rs("score").value + "|" + rs("qty").value + "|" + rs("qtyYes").value + "|" + rs("seq").value + "|" + rs("examID").value + "|" + rs("examName").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getClassExamStat"){
	result = "";
	sql = "EXEC getClassExamStat '" + refID + "'";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("examID").value + "|" + rs("examName").value + "|" + rs("knowPointName").value + "|" + rs("kindName").value + "|" + rs("qty").value + "|" + rs("qtyYes").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentSMSList"){
	result = "";
	s = "";
	//如果有username
	if(nodeID > "" && nodeID != "null" && nodeID !="undefined"){ // 
		s = "username='" + nodeID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where > ""){
		where = " where " + where;
	}
	sql = "select kind,message,regDate,registerName,mobile from v_log_sendsms " + where;
	sql += " union select '系统消息',item,regDate,registerName,'' from v_studentMessageInfo " + where + " order by regDate desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("kind").value + "|" + rs("message").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("mobile").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentExamList"){
	result = "";
	s = "";
	//如果有username
	if(nodeID > "" && nodeID != "null" && nodeID !="undefined"){ // 
		s = "username='" + nodeID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where > ""){
		where = " where " + where;
	}
	sql = "select enterID, certName, startDate as examDate, iif(status>0,cast(score as varchar),'') as score, iif(status>0,resultName,'待考') as resultName, diplomaID, 1 as kindID from v_passcardInfo" + where;
	sql += " union select enterID, courseName, examDate, cast(score as varchar) + (case when sc=1 then '/' + cast(score1 as varchar) else '' end) , resultName, diplomaID, 0 from v_studentApplyList" + where;
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("enterID").value + "|" + rs("certName").value + "|" + rs("examDate").value + "|" + rs("score").value + "|" + rs("resultName").value + "|" + rs("diplomaID").value + "|" + rs("kindID").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getStudentOpList"){
	result = "";
	s = "";
	sql = "select opLogID,event,convert(varchar(20),opDate,120) as opDate,operator from userOpLog where refID='" + nodeID + "'";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("opLogID").value + "|" + rs("event").value + "|" + rs("opDate").value + "|" + rs("operator").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getStudentSignList"){
	result = "";
	s = "";
	//如果有enterID
	if(nodeID > "" && nodeID != "null" && nodeID !="undefined"){ // 
		s = "enterID=" + nodeID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where > ""){
		where = " where " + where;
	}
	sql = "select enterID, courseName, regDate, regDateTime, teacherName from v_driver_sign_in" + where;
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("enterID").value + "|" + rs("courseName").value + "|" + rs("regDate").value + "|" + rs("teacherName").value + "|" + rs("regDateTime").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getStudentLessonList"){
	result = "";
	sql = "select *, dbo.getVideoShots(ID) as shots from v_studentLessonList where refID=" + refID + " order by seq";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("lessonName").value + "|" + rs("hours").value + "|" + rs("completion").value + "|" + rs("shots").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getFaceList"){
	result = "";
	sql = "select * from v_faceDetectInfo where refID in(select ID from studentVideoList where refID=" + refID + " and kindID=0) order by regDate";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += ",{'ID':'" + rs("ID").value + "','file1':'" + rs("file1").value + "','file2':'" + rs("file2").value + "','status':'" + rs("status").value + "','statusName':'" + rs("statusName").value + "','regDate':'" + rs("regDate").value + "'}";
		rs.MoveNext();
	}
	rs.Close();
	if(result>""){
		result = result.substr(1);
	}
	Response.Write(escape("{'list':[" + result + "]}"));
	//Response.Write(escape(sql));
}

if(op == "getFeedbackCertList"){
	result = "";
	sql = "select * from dbo.getFeedbackCertList('" + refID + "') order by ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("title").value + "|" + rs("item").value + "|" + rs("shots").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "enterRefund"){
	//@enterID int,@amount decimal(18,2),@memo nvarchar(500), @registerID varchar(50)
	sql = "exec enterRefund " + nodeID + ",'" + String(Request.QueryString("amount")) + "','" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	Response.Write(escape(0));
	//Response.Write(escape(sql));
}

if(op == "enterPay"){
	//@enterID int,@amount decimal(18,2),@pay_kind int,@pay_type int,@memo nvarchar(500), @registerID
	sql = "exec enterPay " + nodeID + ",'" + String(Request.QueryString("amount")) + "'," + kindID + "," + refID + ",'" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	Response.Write(escape(0));
	//Response.Write(escape(sql));
}

if(op == "updateFiremanEnterInfo"){
	//enterID,area,address,employDate,university,gradeDate,profession,area_now,kind1,kind2,kind3,kind4,kind5,kind6,kind7,kind8,kind9,kind10,kind11,kind12,memo,registerID
	result = "";
	sql = "exec updateFiremanEnterInfo " + refID + ",'" + unescape(String(Request.QueryString("area"))) + "','" + unescape(String(Request.QueryString("address"))) + "','" + String(Request.QueryString("employDate")) + "','" + unescape(String(Request.QueryString("university"))) + "','" + String(Request.QueryString("gradeDate")) + "','" + unescape(String(Request.QueryString("profession"))) + "','" + unescape(String(Request.QueryString("area_now"))) + "','" + String(Request.QueryString("kind1")) + "','" + String(Request.QueryString("kind2")) + "','" + String(Request.QueryString("kind3")) + "','" + String(Request.QueryString("kind4")) + "','" + String(Request.QueryString("kind5")) + "','" + String(Request.QueryString("kind6")) + "','" + String(Request.QueryString("kind7")) + "','" + String(Request.QueryString("kind8")) + "','" + String(Request.QueryString("kind9")) + "','" + String(Request.QueryString("kind10")) + "','" + String(Request.QueryString("kind11")) + "','" + String(Request.QueryString("kind12")) + "','" + memo + "','" + currUser + "'";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value + "|" + rs("msg").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
	/**/
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	result = "";
	sql = "exec delEnter '" + nodeID + "','" + where + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value + "|" + rs("msg").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "doReturn"){
	result = "";
	sql = "exec returnEnter '" + nodeID + "','" + where + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value + "|" + rs("msg").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "doStudentCourse_check"){
	sql = "exec doStudentCourse_check " + status + ",'" + refID + "','" + keyID + "','" + host + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
	//Response.Write(sql);
}	

if(op == "doStudentPre_check"){
	sql = "exec doStudentPre_check " + status + ",'" + keyID + "','" + host + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
	//Response.Write(sql);
}	

if(op == "pick_students4class"){
	result = "";
	sql = "exec pickStudents4Class '" + String(Request.Form("batchID")) + "','" + String(Request.Form("selList")) + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(result);
}

if(op == "set_students_express"){
	result = "";
	sql = "exec set_students_express '" + String(Request.Form("selList")) + "','" + currUser + "'";
	rs = conn.Execute(sql);
	//if (!rs.EOF){
		//result = rs("re").value;
		//execSQL(sql);
	//}
	rs.Close();
	Response.Write(1);
}

if(op == "doStudentCourse_submit"){
	sql = "exec doStudentCourse_submit '" + refID + "'," + status + ",'" + keyID + "','" + host + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "doStudentMaterial_resubmit"){
	sql = "exec doStudentMaterial_resubmit " + status + ",'" + keyID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "doMaterial_check"){
	sql = "exec doMaterial_check " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "doMaterial_check_batch"){
	sql = "exec doMaterial_check_batch '" + keyID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "updatePayPrice"){
	sql = "exec updatePayPrice " + nodeID + "," + refID;
	execSQL(sql);
	Response.Write(0);
}	

if(op == "updateEnterClass"){
	sql = "exec updateEnterClass " + nodeID + ",'" + refID + "','" + keyID + "','" + String(Request.QueryString("currDiplomaID")) + "','" + String(Request.QueryString("currDiplomaDate")) + "'," + String(Request.QueryString("overdue")) + ",'" + String(Request.QueryString("fromID")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "doEnter"){
	//@username varchar(50),@classID varchar(50),@price int,@invoice varchar(50),@projectID varchar(50),@kindID varchar(50),@type int,@status int,@datePay varchar(50),@dateInvoice varchar(50),@dateInvoicePick varchar(50),@memo,@registerID
	sql = "exec doEnter '" + nodeID + "','" + String(Request.QueryString("classID")) + "','" + String(Request.QueryString("price")) + "','" + String(Request.QueryString("invoice")) + "','" + String(Request.QueryString("projectID")) + "','" + item + "'," + kindID + "," + String(Request.QueryString("type")) + "," + status + ",'" + String(Request.QueryString("datePay")) + "','" + String(Request.QueryString("dateInvoice")) + "','" + String(Request.QueryString("dateInvoicePick")) + "','" + String(Request.QueryString("currDiplomaID")) + "','" + String(Request.QueryString("currDiplomaDate")) + "'," + String(Request.QueryString("overdue")) + ",'" + String(Request.QueryString("fromID"))  + "',0,'" + memo + "','" + currUser + "'";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value + "|" + rs("msg").value + "|" + rs("payID").value + "|" + rs("enterID").value;
	}
	rs.Close();/**/
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "closeStudentCourse"){
	result = "";
	sql = "exec closeStudentCourse '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "reviveStudentCourse"){
	result = "";
	sql = "exec reviveStudentCourse '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "rebuildStudentLesson"){
	result = "";
	sql = "exec rebuildStudentLesson '" + nodeID + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "reset_sign"){
	result = "";
	sql = "exec reset_sign '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "jiang2feng"){
	result = "";
	sql = "exec jiang2feng '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "feng2jiang"){
	result = "";
	sql = "exec feng2jiang '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "zeroPay"){
	sql = "exec zeroPay " + nodeID + ",'" + memo + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "checkin"){
	result = 0;
	if(result == 0){
		sql = "exec checkin " + Request.Form("enterID") + ",'" + Request.Form("teacherID") + "','" + Request.Form("memo") + "'";
		rs = conn.Execute(sql);
		if (!rs.EOF){
			result = rs("re").value;
		}
		rs.Close();/**/
	}
	Response.Write(result);
}

if(op == "checkRetake"){
	result = 0;
	if(result == 0){
		sql = "exec checkRetake '" + keyID + "','" + refID + "'";
		rs = conn.Execute(sql);
		if (!rs.EOF){
			result = rs("re").value;
		}
		rs.Close();/**/
	}
	Response.Write(result);
}

%>
