<!--#include file="js/doc.js" -->

<%

if(op == "getCourseList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(courseName like('%" + where + "%') or courseID='" + where + "')";
	}
	//如果有机构
	if(String(Request.QueryString("agency")) > ""){ // 
		s = "agencyID='" + String(Request.QueryString("agency")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类
	if(kindID > ""){ // 
		s = "kindID=" + kindID;
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

	sql = " FROM v_courseInfo a left outer join v_courseScheduleQty b on a.courseID=b.courseID " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT a.courseID,courseName,hours,statusName,markName,memo,regDate,registerName" + sql + " order by a.courseID";
	sql = "SELECT top " + basket + " a.*, isnull(b.qty,0) as qty" + sql + " order by a.courseID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("hours").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//7
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("certID").value + "|" + rs("mark").value + "|" + rs("sc").value;
		//14
		result += "|" + rs("price").value + "|" + rs("price1").value + "|" + rs("reexamine").value + "|" + rs("reexamineName").value + "|" + rs("entryForm").value + "|" + rs("completionPass").value + "|" + rs("cards").value;
		//21
		result += "|" + rs("courseName1").value + "|" + rs("seq").value + "|" + rs("qty").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getCertCourseList"){
	sql = "SELECT ID,courseID,courseName,hours FROM v_courseInfo where certID='" + refID + "' order by courseID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("hours").value;
		rs.MoveNext();
	}
/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT *, [dbo].[getCoursePrice](courseID,'" + currHost + "') as priceX, [dbo].[getCoursePrice1](courseID,'" + currHost + "') as priceX1 FROM v_courseInfo where ID=" + nodeID + " or courseID='" + refID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("hours").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//7
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("host").value + "|" + rs("cards").value + "|" + rs("certID").value;
		//14
		result += "|" + rs("completionPass").value + "|" + rs("deadline").value + "|" + rs("price").value + "|" + rs("sc").value + "|" + rs("mark").value + "|" + rs("re").value;
		//20
		result += "|" + rs("price1").value + "|" + rs("reexamine").value + "|" + rs("reexamineName").value + "|" + rs("shortName").value + "|" + rs("entryform").value + "|" + rs("priceX").value;
		//26
		result += "|" + rs("priceX1").value + "|" + rs("seq").value + "|" + rs("agencyID").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
	//@ID int,@courseID varchar(50),@certID varchar(50),@reexamine int,@hours int,@completionPass int,@sc int,@cards int,@status int,@mark int,@price int,@price1 int,@entryForm varchar(50),@memo nvarchar(500),@registerID varchar(50)
		sql = "exec updateCourseInfo " + nodeID + ",'" + String(Request.QueryString("courseID")) + "','" + refID + "','" + String(Request.QueryString("reexamine")) + "','" + String(Request.QueryString("hours")) + "','" + String(Request.QueryString("completionPass")) + "','" + String(Request.QueryString("sc")) + "','" + String(Request.QueryString("cards")) + "'," + status + "," + String(Request.QueryString("mark")) + ",'" + String(Request.QueryString("price")) + "','" + String(Request.QueryString("price1")) + "','" + String(Request.QueryString("entryForm")) + "','" + String(Request.QueryString("seq")) + "','" + memo + "','" + currHost + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT ID as maxID FROM courseInfo where courseID='" + String(Request.QueryString("courseID")) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}/**/
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getCoursePrice"){
	sql = "SELECT dbo.getCoursePrice('" + nodeID + "','" + refID + "','" + host + "'," + keyID + ") as price";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("price").value;
	}
	rs.Close();
	Response.Write((result));
}

if(op == "cancelNode"){
	sql = "exec doCancelCourse " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delCourseInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
