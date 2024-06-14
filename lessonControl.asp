<!--#include file="js/doc.js" -->

<%

if(op == "getLessonList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(lessonName like('%" + where + "%') or lessonID='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "lessonID in(select lessonID from courseLessonList where courseID='" + refID + "')";
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

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_lessonInfo " + where;
	sql = "SELECT *" + sql + " order by ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("lessonID").value + "|" + rs("lessonName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//5
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_lessonInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result =  rs("ID").value + "|" + rs("lessonID").value + "|" + rs("lessonName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//5
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateLessonInfo " + nodeID + ",'" + String(Request.QueryString("lessonID")) + "','" + unescape(String(Request.QueryString("lessonName"))) + "'," + status + ",'" + memo + "','" + currUser + "'";

		rs = conn.Execute(sql);
		if (!rs.EOF){
			result =  rs("re").value;
		}
		rs.Close();
	}
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "getCourseLessonList"){
	var s = "";
	//如果有课程
	if(refID > ""){ // 
		s = "courseID='" + refID + "'";
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

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_courseLessonList " + where;
	sql = "SELECT *" + sql + " order by seq,ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("lessonID").value + "|" + rs("lessonName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("seq").value + "|" + rs("hours").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getCourseLessonNodeInfo"){
	sql = "SELECT * FROM v_courseLessonList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result =  rs("ID").value + "|" + rs("courseID").value + "|" + rs("lessonID").value + "|" + rs("lessonName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("seq").value + "|" + rs("hours").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "updateCourseLessonList"){
	result = 0;
	if(result == 0){
		sql = "exec updateCourseLessonList " + nodeID + ",'" + String(Request.QueryString("courseID")) + "','" + String(Request.QueryString("lessonID")) + "','" + String(Request.QueryString("hours")) + "','" + String(Request.QueryString("seq")) + "'," + status + ",'" + memo + "','" + currUser + "'";
		rs = conn.Execute(sql);
		if (!rs.EOF){
			result =  rs("re").value;
		}
		rs.Close();
	}
	Response.Write(result);
	//Response.Write((sql));
}

if(op == "delCourseLessonNode"){
	sql = "exec delCourseLessonInfo " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getLessonVideoList"){
	var s = "";
	//如果有课程
	if(refID > ""){ // 
		s = "lessonID='" + refID + "'";
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

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_lessonVideoList " + where;
	sql = "SELECT *" + sql + " order by seq,ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("lessonID").value + "|" + rs("videoID").value + "|" + rs("videoName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("seq").value + "|" + rs("proportion").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("minutes").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getLessonVideoNodeInfo"){
	sql = "SELECT * FROM v_lessonVideoList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result =  rs("ID").value + "|" + rs("lessonID").value + "|" + rs("videoID").value + "|" + rs("videoName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("seq").value + "|" + rs("proportion").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("minutes").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write((sql));
}

if(op == "updateLessonVideoList"){
	result = 0;
	if(result == 0){
		sql = "exec updateLessonVideoList " + nodeID + ",'" + String(Request.QueryString("lessonID")) + "','" + String(Request.QueryString("videoID")) + "','" + String(Request.QueryString("proportion")) + "','" + String(Request.QueryString("seq")) + "'," + status + ",'" + memo + "','" + currUser + "'";
		rs = conn.Execute(sql);
		if (!rs.EOF){
			result =  rs("re").value;
		}
		rs.Close();
	}
	Response.Write(result);
	//Response.Write((sql));
}

if(op == "delLessonVideoNode"){
	sql = "exec delLessonVideoInfo " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getLessonCoursewareList"){
	var s = "";
	//如果有课程
	if(refID > ""){ // 
		s = "lessonID='" + refID + "'";
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

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_lessonCoursewareList " + where;
	sql = "SELECT *" + sql + " order by seq,ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("lessonID").value + "|" + rs("coursewareID").value + "|" + rs("coursewareName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("seq").value + "|" + rs("proportion").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("pages").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getLessonCoursewareNodeInfo"){
	sql = "SELECT * FROM v_lessonCoursewareList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result =  rs("ID").value + "|" + rs("lessonID").value + "|" + rs("coursewareID").value + "|" + rs("coursewareName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("seq").value + "|" + rs("proportion").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("pages").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "updateLessonCoursewareList"){
	result = 0;
	if(result == 0){
		sql = "exec updateLessonCoursewareList " + nodeID + ",'" + String(Request.QueryString("lessonID")) + "','" + String(Request.QueryString("coursewareID")) + "','" + String(Request.QueryString("proportion")) + "','" + String(Request.QueryString("seq")) + "'," + status + ",'" + memo + "','" + currUser + "'";
		rs = conn.Execute(sql);
		if (!rs.EOF){
			result =  rs("re").value;
		}
		rs.Close();
	}
	Response.Write(result);
	//Response.Write((sql));
}

if(op == "delLessonCoursewareNode"){
	sql = "exec delLessonCoursewareInfo " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getVideoList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(videoName like('%" + where + "%') or videoID='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "videoID in(select videoID from lessonVideoList where lessonID in(select lessonID from [courseLessonList] where courseID='" + refID + "'))";
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

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_videoInfo " + where;
	sql = "SELECT *" + sql + " order by ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("videoID").value + "|" + rs("videoName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("minutes").value;
		//6
		result += "|" + rs("author").value + "|" + rs("type").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("vod").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getVideoNodeInfo"){
	sql = "SELECT * FROM v_videoInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result =  rs("ID").value + "|" + rs("videoID").value + "|" + rs("videoName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("minutes").value;
		//6
		result += "|" + rs("author").value + "|" + rs("type").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("vod").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "updateVideoInfo"){
	result = 0;
	if(result == 0){
		sql = "exec updateVideoInfo " + nodeID + ",'" + String(Request.QueryString("videoID")) + "','" + unescape(String(Request.QueryString("videoName"))) + "','" + String(Request.QueryString("minutes")) + "','" + String(Request.QueryString("type")) + "','" + String(Request.QueryString("author")) + "'," + status + ",'" + String(Request.QueryString("vod")) + "','" + memo + "','" + currUser + "'";
		rs = conn.Execute(sql);
		if (!rs.EOF){
			result =  rs("re").value;
		}
		rs.Close();
	}
	Response.Write(result);
	//Response.Write((sql));
}

if(op == "delVideoNode"){
	sql = "exec delVideoInfo " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getCoursewareList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(coursewareName like('%" + where + "%') or coursewareID='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "coursewareID in(select coursewareID from lessonCoursewareList where lessonID in(select lessonID from lessonInfo where courseID='" + refID + "'))";
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

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_coursewareInfo " + where;
	sql = "SELECT *" + sql + " order by ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("coursewareID").value + "|" + rs("coursewareName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("pages").value;
		//6
		result += "|" + rs("author").value + "|" + rs("type").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getCoursewareNodeInfo"){
	sql = "SELECT * FROM v_coursewareInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result =  rs("ID").value + "|" + rs("coursewareID").value + "|" + rs("coursewareName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("pages").value;
		//6
		result += "|" + rs("author").value + "|" + rs("type").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "updateCoursewareInfo"){
	result = 0;
	if(result == 0){
		sql = "exec updateCoursewareInfo " + nodeID + ",'" + String(Request.QueryString("coursewareID")) + "','" + unescape(String(Request.QueryString("coursewareName"))) + "','" + String(Request.QueryString("pages")) + "','" + String(Request.QueryString("type")) + "','" + String(Request.QueryString("author")) + "'," + status + ",'" + unescape(String(Request.QueryString("filename"))) + "','" + memo + "','" + currUser + "'";
		rs = conn.Execute(sql);
		if (!rs.EOF){
			result =  rs("re").value;
		}
		rs.Close();
	}
	Response.Write(result);
	//Response.Write((sql));
}

if(op == "delCoursewareNode"){
	sql = "exec delCoursewareInfo " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "closeNode"){
	sql = "exec closeLessonInfo " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delLessonInfo " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
