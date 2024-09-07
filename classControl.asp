<!--#include file="js/doc.js" -->

<%

if(op == "getClassList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(certName like('%" + where + "%') or classID='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "certID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有班主任
	if(kindID > ""){ // 
		s = "adviserID='" + kindID + "'";
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
	//如果有批次
	if(String(Request.QueryString("projectID")) > "" && String(Request.QueryString("projectID")) !="undefined"){ // 
		s = "projectID='" + String(Request.QueryString("projectID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//host
	if(host > ""){ // partner
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(currHost==""){	//不能查看合作单位的预备班
		s = "(pre=0 or host='')";
		if(String(Request.QueryString("pre"))==0){
			s += " and pre=0";
		}
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//mark=3: 当前用户为销售
	if(String(Request.QueryString("mark")) == 3){
		s = "classID in (select * from dbo.getClassListBySaler('" + currUser + "'))";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_classInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT classID,className,statusName,certName,dateStart,dateEnd,adviserName,classroom,qty,qtyApply,qtyExam,qtyPass,qtyDiploma,archiveDate,memo,regDate,registerName" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by pre desc, ID desc";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("classID").value + "|" + rs("projectID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//8
		result += "|" + rs("adviserID").value + "|" + rs("adviserName").value + "|" + rs("dateStart").value + "|" + rs("dateEnd").value + "|" + rs("classroom").value;
		//13
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("className").value + "|" + rs("timetable").value + "|" + rs("phone").value + "|" + rs("qty").value;
		//21
		result += "|" + rs("fileArchive").value + "|" + rs("archiver").value + "|" + rs("archiveDate").value + "|" + rs("qtyApply").value + "|" + rs("qtyExam").value + "|" + rs("qtyPass").value + "|" + rs("archiverName").value;
		//28
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("qtyReturn").value + "|" + rs("teacher").value + "|" + rs("scheduleDate").value + "|" + rs("courseID").value + "|" + rs("courseName").value;
		//36
		result += "|" + rs("teacherName").value + "|" + rs("host").value + "|" + rs("transaction_id").value + "|" + rs("re").value + "|" + rs("reexamineName").value + "|" + rs("kindName").value + "|" + rs("qtyDiploma").value + "|" + rs("pre").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_classInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("classID").value + "|" + rs("projectID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//8
		result += "|" + rs("adviserID").value + "|" + rs("adviserName").value + "|" + rs("dateStart").value + "|" + rs("dateEnd").value + "|" + rs("classroom").value;
		//13
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("className").value;
		//18
		result += "|" + rs("timetable").value + "|" + rs("phone").value + "|" + rs("qty").value + "|" + rs("filename").value;
		//22
		result += "|" + rs("fileArchive").value + "|" + rs("archiver").value + "|" + rs("archiveDate").value + "|" + rs("summary").value + "|" + rs("qtyApply").value + "|" + rs("qtyExam").value + "|" + rs("qtyPass").value + "|" + rs("archiverName").value;
		//30
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("qtyReturn").value + "|" + rs("teacher").value + "|" + rs("scheduleDate").value + "|" + rs("courseID").value + "|" + rs("courseName").value;
		//38
		result += "|" + rs("teacherName").value + "|" + rs("host").value + "|" + rs("transaction_id").value + "|" + rs("re").value + "|" + rs("reexamineName").value + "|" + rs("kindName").value + "|" + rs("qtyDiploma").value;
		//45
		result += "|" + rs("signatureType").value + "|" + rs("signatureTypeName").value + "|" + rs("zip").value + "|" + rs("pzip").value + "|" + rs("ezip").value + "|" + rs("pre").value;
		//execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateClassInfo " + nodeID + ",'" + unescape(String(Request.QueryString("className"))) + "','" + String(Request.QueryString("certID")) + "','" + String(Request.QueryString("courseID")) + "','" + String(Request.QueryString("projectID")) + "','" + String(Request.QueryString("adviserID")) + "','" + host + "','" + String(Request.QueryString("teacher")) + "'," + kindID + "," + status + "," + String(Request.QueryString("pre")) + ",'" + String(Request.QueryString("dateStart")) + "','" + String(Request.QueryString("dateEnd")) + "','" + unescape(String(Request.QueryString("classroom"))) + "','" + unescape(String(Request.QueryString("timetable"))) + "','" + String(Request.QueryString("archived")) + "','" + String(Request.Form("summary")) + "','" + String(Request.QueryString("transaction_id")) + "'," + String(Request.QueryString("signatureType")) + ",'" + String(Request.Form("memo")) + "','" + currUser + "'";

		rs = conn.Execute(sql);
		if(!rs.EOF){
			result = rs("re");
		}
	}
	Response.Write((result));
	//Response.Write(escape(sql));
}

if(op == "getStudentListByClassID"){
	var s = "";
	where = "";
	//如果有班级
	if(refID > ""){ // 
		s = "classID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_studentCourseList " + where;
	sql = "SELECT *, (case when host='znxf' then unit else hostName end) as unit1,cast(isnull(completion,0) as decimal(18,2)) as completion1,cast(isnull(completion*hours/100,0) as decimal(18,2)) as hoursSpend1" + sql + " order by SNo";

	result = "";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("username").value + "|" + rs("name").value + "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("SNo").value;
		//5
		result += "|" + rs("mobile").value + "|" + rs("unit1").value + "|" + rs("score").value + "|" + rs("diploma_startDate").value + "|" + rs("diplomaID").value;
		//10
		result += "|" + rs("score1").value + "|" + rs("score2").value + "|" + rs("statusName").value + "|" + rs("educationName").value;
		//14
		result += "|" + rs("hours").value + "|" + rs("completion1").value + "|" + rs("hoursSpend1").value + "|" + rs("startDate").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Session(op) = ssql;
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}	

if(op == "getClassListByProject"){
	sql = "SELECT classID,className FROM [dbo].[getClassListByProject]('" + refID + "') where status=0 order by classID desc";;

	result = "";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += ',"' + rs("classID").value + '":"' + rs("className").value + '"';
		rs.MoveNext();
	}
	result = "{" + result.substr(1) + "}";
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}	

if(op == "getClassListByClassID"){
	sql = "SELECT a.classID, a.className FROM v_classInfo a, classInfo b where b.classID='" + refID + "' and a.courseID=b.courseID and a.status=0 and a.classID<>'" + refID + "' order by a.classID desc";;

	result = "";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += ',"' + rs("classID").value + '":"' + rs("className").value + '"';
		rs.MoveNext();
	}
	result = "{" + result.substr(1) + "}";
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}	

if(op == "getClassSchedule"){
	var s = "";
	where = "";
	//如果有班级
	if(refID > ""){ // 
		s = "classID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有类别
	if(kindID > ""){ // 
		s = "mark='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有类别
	if(keyID > ""){ // 
		s = "online='" + keyID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_classSchedule " + where;
	sql = "SELECT * " + sql + " order by seq";

	result = "";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("classID").value + "|" + rs("courseID").value + "|" + rs("seq").value + "|" + rs("kindID").value + "|" + rs("typeID").value + "|" + rs("status").value;
		//7
		result += "|" + rs("hours").value + "|" + rs("period").value + "|" + rs("theDate").value + "|" + rs("theWeek").value + "|" + rs("item").value + "|" + rs("address").value + "|" + rs("teacher").value;
		//14
		result += "|" + rs("kindName").value + "|" + rs("typeName").value + "|" + rs("teacherName").value + "|" + rs("memo").value + "|" + rs("regDate").value;
		//19
		result += "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("online").value + "|" + rs("onlineName").value + "|" + rs("mark").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Session(op) = ssql;
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}	

if(op == "getClassScheduleInfo"){
	sql = "SELECT * FROM v_classSchedule where ID=" + nodeID;
	result = "";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("classID").value + "|" + rs("courseID").value + "|" + rs("seq").value + "|" + rs("kindID").value + "|" + rs("typeID").value + "|" + rs("status").value;
		//7
		result += "|" + rs("hours").value + "|" + rs("period").value + "|" + rs("theDate").value + "|" + rs("theWeek").value + "|" + rs("item").value + "|" + rs("address").value + "|" + rs("teacher").value;
		//14
		result += "|" + rs("kindName").value + "|" + rs("typeName").value + "|" + rs("teacherName").value + "|" + rs("memo").value + "|" + rs("regDate").value;
		//19
		result += "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("online").value + "|" + rs("onlineName").value + "|" + rs("mark").value;
	}
	Session(op) = ssql;
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}

if(op == "updateClassSchedule"){
	result = 0;
	//@ID int,@seq int,@kindID int,@typeID int,@hours int,@period varchar(50),@theDate varchar(50),@teacher varchar(50),@memo varchar(500),@registerID
	sql = "exec updateClassSchedule " + nodeID + "," + String(Request.QueryString("seq")) + "," + kindID + "," + refID + "," + String(Request.QueryString("online")) + "," + String(Request.QueryString("hours")) + ",'" + String(Request.QueryString("period")) + "','" + String(Request.QueryString("theDate")) + "','" + String(Request.QueryString("teacher")) + "','" + unescape(String(Request.QueryString("address"))) + "','" + item + "','" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value + "|" + rs("msg").value;
	}

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "updateStandardSchedule"){
	result = 0;	
	sql = "exec updateStandardSchedule " + nodeID + ",'" + String(Request.QueryString("courseID")) + "'," + String(Request.QueryString("seq")) + "," + kindID + "," + refID + "," + String(Request.QueryString("online")) + "," + String(Request.QueryString("hours")) + ",'" + String(Request.QueryString("period")) + "','" + item + "','" + memo + "','" + currUser + "'";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value + "|" + rs("msg").value + "|" + rs("ID").value;
	}
	/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getStandardSchedule"){
	var s = "";
	where = "";
	//
	if(refID > ""){ // 
		s = "courseID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有类别
	if(keyID > ""){ // 
		s = "online='" + keyID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_schedule " + where;
	sql = "SELECT * " + sql + " order by seq";

	result = "";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("seq").value + "|" + rs("kindID").value + "|" + rs("typeID").value + "|" + rs("status").value;
		//6
		result += "|" + rs("hours").value + "|" + rs("period").value + "|" + rs("item").value;
		//9
		result += "|" + rs("kindName").value + "|" + rs("typeName").value + "|" + rs("memo").value + "|" + rs("regDate").value;
		//13
		result += "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("online").value + "|" + rs("onlineName").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Session(op) = ssql;
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}

if(op == "getStandardScheduleInfo"){
	sql = "SELECT * FROM v_schedule where ID=" + nodeID;
	result = "";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("courseID").value + "|" + rs("seq").value + "|" + rs("kindID").value + "|" + rs("typeID").value + "|" + rs("status").value;
		//6
		result += "|" + rs("hours").value + "|" + rs("period").value + "|" + rs("item").value;
		//9
		result += "|" + rs("kindName").value + "|" + rs("typeName").value + "|" + rs("memo").value + "|" + rs("regDate").value;
		//13
		result += "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("online").value + "|" + rs("onlineName").value;
	}
	Session(op) = ssql;
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelClass " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delClassInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write(escape(sql));
}

if(op == "closeClass"){
	sql = "exec closeClassInfo '" + nodeID + "'," + refID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getStatus"){
	sql = "SELECT status FROM classInfo where classID='" + refID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value;
	}
	rs.Close();
	Response.Write((result));
}

if(op == "getRandSummary"){
	sql = "exec getRandSummary " + refID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("summary").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "generateClassSchedule"){
	sql = "exec autoSetClassSchedule '" + refID + "','" + kindID + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(escape(result));/**/
}

if(op == "getCurrScheduleList"){
	sql = "select * from [dbo].[getCurrScheduleList]('" + currHost + "') where typeID=0";
	result = "";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("title").value + "|" + rs("qty").value + "|" + rs("classID").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}

if(op == "getScheduleCheckIn"){
	sql = "exec getScheduleCheckIn " + refID;
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("qty").value + "|" + rs("qty0").value + "|" + rs("qty1").value + "|" + rs("qty2").value;
	}
	rs.Close();
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}

if(op == "delStandardSchedule"){
	sql = "exec delStandardSchedule '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write(escape(sql));
}

if(op == "cancelFaceCheckin"){
	sql = "exec cancelFaceCheckin " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write(escape(sql));
}
%>
