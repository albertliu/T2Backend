<!--#include file="js/doc.js" -->

<%

if(op == "getDiplomaList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = where.replace(/\s+/g, "");
		where = "(name like('%" + where + "%') or username='" + where + "' or diplomaID='" + where + "')";
	}
	//如果有公司
	s = "host='" + currHost + "'";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}
	if(currPartner > 0){ // 
		s = "partnerID=" + currPartner;
		where = where + " and " + s;
	}
	//如果有部门
	if(String(Request.QueryString("partnerID")) > "0" && String(Request.QueryString("partnerID")) != "null" && String(Request.QueryString("partnerID")) !="undefined"){ // 
		s = "partnerID=" + String(Request.QueryString("partnerID"));
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
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类(证书类型)
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有发放标识
	if(keyID > ""){ // 
		s = "issued=" + keyID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "startDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "startDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(String(Request.QueryString("lastDate")) > "" && String(Request.QueryString("lastDate")) != "undefined"){
		s = "endDate<='" + String(Request.QueryString("lastDate")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//未发放
	if(String(Request.QueryString("nodelivery")) == "1"){
		s = "issued=0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	
	sql = " FROM v_diplomaInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT diplomaID,certName,statusName,term,startDate,endDate,agencyName,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,memo,issueDate,issuerName,regDate,registerName" + sql + " order by diplomaID";
	sql = "SELECT top " + basket + " *" + sql + " order by diplomaID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("diplomaID").value;
		//8
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("email").value + "|" + rs("host").value + "|" + rs("unit").value + "|" + rs("issuer").value + "|" + rs("issuerName").value;
		//16
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("term").value + "|" + rs("memo").value + "|" + rs("agencyName").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
		//25
		result += "|" + rs("issued").value + "|" + rs("issueDate").value + "|" + rs("issueType").value + "|" + rs("issuedName").value + "|" + rs("salesName").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getDiplomaLastList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or diplomaID='" + where + "' or certName like('%" + where + "%'))";
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
	//如果有部门
	if(refID > ""){ // 
		s = "dept1=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类(证书类型)
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "endDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "endDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_diplomaLastInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT diplomaID,certName,statusName,term,startDate,endDate,agencyName,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,memo,regDate,registerName" + sql + " order by diplomaID";
	sql = "SELECT top " + basket + " *" + sql + " order by diplomaID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("diplomaID").value;
		//8
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("email").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value;
		//16
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("term").value + "|" + rs("memo").value + "|" + rs("agencyName").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getDiplomaListByBatch"){
	//sql = "select a.*,c.SNo from v_diplomaInfo a, studentCertList b, v_studentCourseList c where b.ID=c.refID and a.diplomaID=b.diplomaID and a.batchID=" + refID + " order by c.SNo";
	sql = "SELECT * FROM v_diplomaInfo where batchID=" + refID;
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("unit").value + "|" + rs("stamp").value + "|" + rs("photo_filename").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("diplomaID").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_diplomaInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("diplomaID").value;
		//8
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("email").value + "|" + rs("host").value + "|" + rs("unit").value;
		//14
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("term").value + "|" + rs("memo").value + "|" + rs("agencyName").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
		//25
		result += "|" + rs("issued").value + "|" + rs("issueDate").value + "|" + rs("issueType").value + "|" + rs("issuedName").value + "|" + rs("issuer").value + "|" + rs("issuerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfoShort"){
	result = "";
	sql = "SELECT * FROM v_diplomaInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("name").value + "|" + rs("certName").value + "|" + rs("diplomaID").value + "|" + rs("dept1Name").value + "|" + rs("job").value;
		//5
		result += "|" + rs("startDate").value + "|" + rs("term").value + "|" + rs("title").value + "|" + rs("photo_filename").value + "|" + rs("logo").value + "|" + rs("certID").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentNeedDiplomaList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or certName like('%" + where + "%') or unit like('%" + where + "%'))";
	}
	//如果有公司
	s = "host='" + currHost + "' and result=1 and mark=1 and closed=0";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}
	if(currPartner > 0){ // 
		s = "partnerID=" + currPartner;
		where = where + " and " + s;
	}
	//如果有部门
	if(String(Request.QueryString("partnerID")) > "0" && String(Request.QueryString("partnerID")) != "null" && String(Request.QueryString("partnerID")) !="undefined"){ // 
		s = "partnerID=" + String(Request.QueryString("partnerID"));
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
	//如果有证书类型
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//考试日期
	if(fStart > ""){
		s = "endDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "endDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有照片
	if(keyID == "0"){ // 
		s = "photo_filename>''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果无照片
	if(keyID == "1"){ // 
		s = "photo_filename=''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果显示拒绝申请的人员
	if(refID == 1){ // 
		s = "diplomaID='*'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}else{
		s = "diplomaID=''";
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
	ssql = "SELECT a.username,b.name,b.sexName,b.age,a.certName,b.dept1Name,b.dept2Name,b.job,b.mobile" + sql + " order by b.dept1Name";
	sql = "SELECT top " + basket + " *" + sql + " order by endDate desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("certID").value + "|" + rs("certName").value;
		//5
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("host").value + "|" + rs("partnerID").value + "|" + rs("unit").value;
		//10
		result += "|" + rs("job").value + "|" + rs("endDate").value + "|" + rs("photo_filename").value + "|" + rs("educationName").value;
		//14
		result += "|" + rs("pay_statusName").value + "|" + rs("pay_status").value + "|" + rs("mobile").value;
		//17
		result += "|" + rs("signature").value + "|" + rs("signatureDate").value + "|" + rs("status_photo").value + "|" + rs("status_signature").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	//result = sql;
	Response.Write(escape(result));
}	

if(op == "getNeedDiplomaNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_studentCourseList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("certID").value + "|" + rs("certName").value;
		//5
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("host").value + "|" + rs("unit").value + "|" + rs("diplomaID").value;
		//10
		result += "|" + rs("job").value + "|" + rs("endDate").value + "|" + rs("educationName").value + "|" + rs("photo_filename").value + "|" + rs("mobile").value + "|" + rs("memo").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGenerateDiplomaList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "((firstID <= '" + where + "' and lastID >= '" + where + "') or memo like('%" + where + "%'))";
	}

	s = "host='" + currHost + "'";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}

	//如果有分类(证书类型)
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(fStart > ""){
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(fEnd > ""){
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}

	sql = " FROM v_generateDiplomaInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT certName,qty,firstID,lastID,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//8
		result += "|" + rs("firstID").value + "|" + rs("lastID").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		//13
		result += "|" + rs("printed").value + "|" + rs("printDate").value + "|" + rs("delivery").value + "|" + rs("deliveryDate").value + "|" + rs("startDate").value + "|" + rs("photo").value + "|" + rs("photoDate").value;
		//20
		result += "|" + rs("styleID").value + "|" + rs("styleName").value;
		rs.MoveNext();
	}
	rs.Close();/**/
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGenerateDiplomaNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateDiplomaInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//8
		result += "|" + rs("firstID").value + "|" + rs("lastID").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		//13
		result += "|" + rs("printed").value + "|" + rs("printDate").value + "|" + rs("delivery").value + "|" + rs("deliveryDate").value + "|" + rs("startDate").value;
		//18
		result += "|" + rs("class_startDate").value + "|" + rs("class_endDate").value + "|" + rs("photo").value + "|" + rs("photoDate").value + "|" + rs("kindID").value;
		//23
		result += "|" + rs("styleID").value + "|" + rs("styleName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGenerateMaterialList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(kindName like('%" + where + "%'))";
	}
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类
	if(kindID > ""){ // 
		s = "kindID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_generateMaterialInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getGenerateMaterialNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateMaterialInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGeneratePasscardList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(className like('%" + where + "%'))";
	}
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有课程
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有经办人
	if(refID > ""){ // 
		s = "registerID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "startDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "startDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_generatePasscardInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by startDate desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("classID").value + "|" + rs("className").value + "|" + rs("title").value + "|" + rs("qty").value + "|" + rs("startTime").value + "|" + rs("address").value;
		//7
		result += "|" + rs("notes").value + "|" + rs("startDate").value + "|" + rs("filename").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("startNo").value;
		//14
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filescore").value;
		//20
		result += "|" + rs("sendScore").value + "|" + rs("sendScoreDate").value + "|" + rs("senderScoreName").value + "|" + rs("qtyYes").value + "|" + rs("qtyNo").value + "|" + rs("qtyNull").value;
		//26
		result += "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("qtyDiploma").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getPasscardListByExam"){
	result = "";
	var s = "";
	//如果有考试场次
	if(refID > ""){ // 
		s = "refID=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有补考
	if(keyID > ""){
		s = "resit>=" + keyID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果需要补考
	if(String(Request.QueryString("needResit"))==1){ // 
		s = "status<>1";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_passcardInfo " + where;
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT *" + sql + " order by passNo, ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("refID").value + "|" + rs("enterID").value + "|" + rs("passNo").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("mobile").value;
		//7
		result += "|" + rs("score").value + "|" + rs("reExamCount").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		//14
		result += "|" + rs("unit").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("kind").value + "|" + rs("SNo").value + "|" + rs("diplomaID").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getPasscardExamList"){
	result = "";
	var s = "";
	//如果有考试场次
	if(refID > ""){ // 
		s = "a.refID=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	sql = " FROM v_passcardInfo a, v_studentExamList b where a.ID=b.refID and " + where;
	sql = "SELECT a.ID,a.enterID,a.username,a.name,a.SNo,a.unit,a.dept1Name,a.dept2Name,a.mobile, b.score, b.status,b.statusName,b.startDate,b.endDate,b.secondRest/60 as secondRest" + sql + " order by passNo, ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("mobile").value;
		//4
		result += "|" + rs("score").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("secondRest").value;
		//10
		result += "|" + rs("unit").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("SNo").value + "|" + rs("enterID").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
    //Response.Write(escape(sql));
}	

if(op == "getGeneratePasscardNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generatePasscardInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("title").value + "|" + rs("qty").value + "|" + rs("startTime").value + "|" + rs("address").value;
		//7
		result += "|" + rs("notes").value + "|" + rs("startDate").value + "|" + rs("filename").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("startNo").value;
		//14
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filescore").value;
		//20
		result += "|" + rs("sendScore").value + "|" + rs("sendScoreDate").value + "|" + rs("senderScoreName").value + "|" + rs("qtyYes").value + "|" + rs("qtyNo").value + "|" + rs("qtyNull").value;
		//26
		result += "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("closeDate").value + "|" + rs("minutes").value + "|" + rs("scorePass").value + "|" + rs("sync").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "updateGeneratePasscardInfo"){
	//@ID int,@certID varchar(50),@title nvarchar(100),@startNo int,@startDate varchar(100),@startTime varchar(100),@address nvarchar(100),@notes nvarchar(500),@memo nvarchar(500),@registerID
	sql = "exec updateGeneratePasscardInfo1 " + nodeID + ",'" + refID + "','" + item + "','" + keyID + "','" + kindID + "','" + String(Request.QueryString("startDate")) + "','" + String(Request.QueryString("startTime")) + "','" + unescape(String(Request.QueryString("address"))) + "','" + unescape(String(Request.QueryString("notes"))) + "'," + String(Request.QueryString("sync")) + ",'" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "updateGenerateDiplomaInfo"){
	//@ID int,@classID varchar(50),@title nvarchar(100),@qty int,@startTime varchar(100),@address nvarchar(100),@notes nvarchar(500),@memo nvarchar(500),@registerID
	sql = "exec updateGenerateDiplomaInfo " + nodeID + ",'','','','" + String(Request.QueryString("printed")) + "','" + String(Request.QueryString("printDate")) + "','" + String(Request.QueryString("delivery")) + "','" + String(Request.QueryString("deliveryDate")) + "','','" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	Response.Write(escape(0));
	//Response.Write(escape(sql));
}

if(op == "updateGenerateDiplomaMemo"){
	//@ID int,@classID varchar(50),@title nvarchar(100),@qty int,@startTime varchar(100),@address nvarchar(100),@notes nvarchar(500),@memo nvarchar(500),@registerID
	sql = "exec updateGenerateDiplomaMemo " + nodeID + ",'" + String(Request.QueryString("startDate")) + "','" + String(Request.QueryString("class_startDate")) + "','" + String(Request.QueryString("class_endDate")) + "','" + String(Request.QueryString("photo")) + "','" + String(Request.QueryString("photoDate")) + "','" + String(Request.QueryString("printed")) + "','" + String(Request.QueryString("printDate")) + "','" + String(Request.QueryString("delivery")) + "','" + String(Request.QueryString("deliveryDate")) + "'," + kindID + "," + keyID + ",'" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	Response.Write(escape(0));
	//Response.Write(escape(sql));
}

if(op == "issueDiploma"){
	result = 0;
	if(result == 0){
		sql = "exec issueDiploma '" + String(Request.Form("selList")) + "','" + String(Request.Form("memo")) + "','" + currHost + "','" + currUser + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "setMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setNeedDiplomaMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setNeedDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setNeedDiplomaCancel"){
	result = 0;
	if(result == 0){
		sql = "exec setNeedDiplomaCancel " + nodeID + ",'" + item + "'," + kindID + ",'" + currUser + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setGenerateDiplomaMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setGenerateDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setGenerateMaterialMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setGenerateMaterialMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "delNode"){
	sql = "exec delDiplomaList '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delGeneratePasscard"){
	sql = "exec delGeneratePasscard '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "closeGeneratePasscard"){
	sql = "exec closeGeneratePasscard " + nodeID + "," + refID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "remove4GeneratePasscard"){
	sql = "exec changeExamer " + nodeID + ",'" + String(Request.Form("selList")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write(sql);
}

if(op == "remove4GenerateApply"){
	sql = "exec removeApply " + refID + ",'" + String(Request.Form("selList")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write(sql);
}

if(op == "shutdown4GenerateApply"){
	sql = "exec shutdownGenerateApply " + refID + ",'" + String(Request.Form("selList")) + "','放弃终止','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write(sql);
}

if(op == "retake4GenerateApply"){
	sql = "exec retakeGenerateApply " + refID + ",'" + keyID + "','" + String(Request.Form("selList")) + "','" + currUser + "'";
	execSQL(sql);
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();/**/
	Response.Write(result);
	//Response.Write(sql);
}

if(op == "getGenerateApplyList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(title like('%" + where + "%') or courseName like('%" + where + "%') or applyID like('%" + where + "%'))";
	}
	s = "host='" + currHost + "'";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有课程
	if(String(Request.QueryString("courseID")) > "" && String(Request.QueryString("courseID")) !="undefined"){
		s = "courseID='" + String(Request.QueryString("courseID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	//如果有部门
	if(String(Request.QueryString("partnerID")) > "0" && String(Request.QueryString("partnerID")) != "null" && String(Request.QueryString("partnerID")) !="undefined"){ // 
		s = "[dbo].[partnerInApply](ID," + String(Request.QueryString("partnerID")) + ")=1";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	//如果有销售
	if(String(Request.QueryString("sales")) > "" && String(Request.QueryString("sales")) != "null" && String(Request.QueryString("sales")) !="undefined"){ // 
		s = "[dbo].[salesInApply](ID,'" + String(Request.QueryString("sales")) + "')=1";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//类型
	if(kindID > ""){ // 
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有经办人
	if(refID > ""){ // 
		s = "registerID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_generateApplyInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("title").value + "|" + rs("qty").value + "|" + rs("applyID").value;
		//6
		result += "|" + rs("startDate").value + "|" + rs("filename").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("address").value;
		//12
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filescore").value;
		//18
		result += "|" + rs("sendScore").value + "|" + rs("sendScoreDate").value + "|" + rs("senderScoreName").value + "|" + rs("qtyYes").value + "|" + rs("qtyNo").value + "|" + rs("qtyNull").value;
		//24
		result += "|" + rs("reexamineName").value + "|" + rs("importApplyDate").value + "|" + rs("importScoreDate").value + "|" + rs("diplomaStartDate").value + "|" + rs("diplomaEndDate").value + "|" + rs("diplomaTerm").value;
		//30
		result += "|" + rs("qtyCheck").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("endDate").value + "|" + rs("zip").value + "|" + rs("pzip").value + "|" + rs("ezip").value;
		//37
		result += "|" + rs("qtyApply").value + "|" + rs("adviserID").value + "|" + rs("adviserName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getApplyListByBatch"){
	result = "";
	var s = "";
	//如果有批次
	if(refID > ""){ // 
		s = "refID=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态
	if(status > ""){ // 
		s = "statusApply=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有补申
	if(keyID > ""){
		s = "resit>=" + keyID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果需要补申
	if(String(Request.QueryString("needResit"))==1){ // 
		s = "status=2";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果需要付费重修(初考)
	if(String(Request.QueryString("needRetake"))==1){ // 
		s = "status=3";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果需要付费重修(补考)
	if(String(Request.QueryString("needRetake"))==2){ // 
		s = "status>1";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果未关闭
	if(String(Request.QueryString("noclosed"))==1){ // 
		s = "closed=0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果未报名
	if(String(Request.QueryString("wait"))==1){ // 
		s = "step <> '已报名'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果未上传
	if(String(Request.QueryString("upload"))==1){ // 
		s = "upload=0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//
	if(currPartner > 0){ // 
		s = "partnerID=" + currPartner;
		where = where + " and " + s;
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_applyInfo " + where;
	//ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT *" + sql + " order by ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("refID").value + "|" + rs("enterID").value + "|" + rs("passNo").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("mobile").value;
		//7
		result += "|" + rs("resit").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		//13
		result += "|" + rs("unit").value + "|" + rs("host").value + "|" + rs("courseName").value + "|" + rs("statusApply").value + "|" + rs("statusApplyName").value + "|" + rs("examDate").value;
		//19
		result += "|" + rs("score").value + "|" + rs("score1").value + "|" + rs("score2").value + "|" + rs("applyNo").value;
		//23
		result += "|" + rs("certID").value + "|" + rs("file1").value + "|" + rs("file2").value + "|" + rs("file3").value + "|" + rs("sc").value + "|" + rs("step").value + "|" + rs("entryForm").value;
		//30
		result += "|" + rs("photo_filename").value + "|" + rs("signature").value + "|" + rs("photo_size").value + "|" + rs("person").value + "|" + rs("after").value + "|" + rs("signatureDate").value;
		//36
		result += "|" + rs("signatureDate1").value + "|" + rs("upload").value + "|" + rs("memo1").value + "|" + rs("currDiplomaDate").value + "|" + rs("currDiplomaChecked").value + "|" + rs("currDiplomaChecker").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Session(op) = ssql;/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGenerateApplyNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateApplyInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("title").value + "|" + rs("qty").value + "|" + rs("applyID").value;
		//6
		result += "|" + rs("startDate").value + "|" + rs("filename").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("address").value;
		//12
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filescore").value;
		//18
		result += "|" + rs("sendScore").value + "|" + rs("sendScoreDate").value + "|" + rs("senderScoreName").value + "|" + rs("qtyYes").value + "|" + rs("qtyNo").value + "|" + rs("qtyNull").value;
		//24
		result += "|" + rs("reexamineName").value + "|" + rs("importApplyDate").value + "|" + rs("importScoreDate").value + "|" + rs("diplomaStartDate").value + "|" + rs("diplomaEndDate").value;
        //29
		result += "|" + rs("diplomaTerm").value + "|" + rs("qtyCheck").value + "|" + rs("certID").value + "|" + rs("host").value + "|" + rs("zip").value + "|" + rs("pzip").value + "|" + rs("ezip").value;
		//36
		result += "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("endDate").value + "|" + rs("price").value + "|" + rs("price1").value + "|" + rs("agencyID").value;
		//42
		result += "|" + rs("azip").value + "|" + rs("tzip").value + "|" + rs("reexamine").value + "|" + rs("adviserID").value + "|" + rs("adviserName").value;
		//47
		result += "|" + rs("teacher").value + "|" + rs("classroom").value + "|" + rs("scheduleDate").value + "|" + rs("mark").value + "|" + rs("checkinMark").value + "|" + rs("uploadScheduleDate").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "updateGenerateApplyInfo"){
	nodeID = Request.Form("ID");
	//@ID int,@courseID varchar(50),@applyID varchar(50),@kindID int,@title nvarchar(100),@startDate varchar(100),@address nvarchar(100),@host varchar(50),@memo nvarchar(500),@registerID
	sql = "exec updateGenerateApplyInfo " + Request.Form("ID") + ",'" + Request.Form("courseID") + "','" + Request.Form("applyID") + "','" + Request.Form("kindID") + "','" + Request.Form("title");
	sql += "','" + Request.Form("startDate") + "','" + Request.Form("endDate") + "','" + Request.Form("address") + "','" + Request.Form("teacher") + "','" + Request.Form("classroom") + "','" + Request.Form("adviserID") + "','" + currHost + "','" + Request.Form("memo") + "','" + currUser + "'";
	
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value + "|" + rs("msg").value;
	}
	rs.Close();/**/
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "getStudentListByClassID"){
	var s = "";
	where = "";
	//如果有班级
	if(refID > ""){ // 
		s = "refID=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_applyInfo " + where;
	sql = "SELECT username,name,sexName,hours,completion,cast(isnull(completion*hours/100,0) as decimal(18,2)) as hoursSpend" + sql + " order by ID";

	result = "";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("username").value + "|" + rs("name").value + "|" + rs("sexName").value + "|" + rs("hours").value + "|" + rs("completion").value + "|" + rs("hoursSpend").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Session(op) = ssql;
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}

if(op == "delGenerateApply"){
	sql = "exec delGenerateApplyInfo '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "closeGenerateApply"){
	sql = "exec closeGenerateApplyInfo " + nodeID + "," + refID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "adjustClassDate"){
	sql = "exec adjustEnterDate4class '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getLastExamAddress"){
	sql = "select top 1 address, notes from v_generatePasscardInfo where certID='" + refID + "' and kindID=" + kindID + " order by ID desc";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("address").value + "|" + rs("notes").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getLastApplyAddress"){
	sql = "select top 1 address from v_generateApplyInfo where courseID='" + refID + "' order by ID desc";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("address").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "closeExam"){
	sql = "exec closeExam " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "cancelDiploma"){
	sql = "exec cancelDiploma '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
