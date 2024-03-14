<!--#include file="js/doc.js" -->

<%

if(op == "getProjectList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(projectName like('%" + where + "%') or projectID='" + where + "')";
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
			s = "dbo.pf_inStrArray(dept,','," + currDeptID + ")=1";
			where = where + " and " + s;
		}
	}
	//如果有部门
	if(keyID > 0){ // 
		s = "dbo.pf_inStrArray(dept,','," + keyID + ")=1";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有起始日期
	if(fStart > ""){ // 
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有截止日期
	if(fEnd > ""){ // 
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类
	if(kindID < 99 && kindID > ""){ // 
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有认证项目
	if(refID > ""){ // 
		s = "certID='" + refID + "'";
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
		where = " where " + where + " and hide=0";
	}

	sql = " FROM v_projectInfo " + where;
	/**/
	result = getBasketTip(sql,"");
	ssql = "SELECT projectID,projectName,statusName,certName,address,object,deadline,hostName,memo,regDate,registerName" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("projectID").value + "|" + rs("projectName").value + "|" + rs("certID").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("object").value + "|" + rs("certName").value + "|" + rs("statusName").value;
		//9
		result += "|" + rs("address").value + "|" + rs("deadline").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("qtyCheck").value;
		//18
		result += "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("qty").value + "|" + rs("filename").value + "|" + rs("entryform").value + "|" + rs("dept").value + "|" + rs("linker").value + "|" + rs("mobile").value + "|" + rs("qtySubmit").value + "|" + rs("qtyRefuse").value;
		//28
		result += "|" + rs("price").value + "|" + rs("payKind").value + "|" + rs("payGroup").value + "|" + rs("reexamine").value + "|" + rs("reexamineName").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("qtyWaitCheck").value;
		rs.MoveNext();
	}
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	
/**/
if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_projectInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("projectID").value + "|" + rs("projectName").value + "|" + rs("certID").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("object").value + "|" + rs("certName").value + "|" + rs("statusName").value;
		//9
		result += "|" + rs("address").value + "|" + rs("deadline").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("qtyCheck").value;
		//18
		result += "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("qty").value + "|" + rs("filename").value + "|" + rs("entryform").value + "|" + rs("dept").value + "|" + rs("linker").value + "|" + rs("mobile").value + "|" + rs("qtySubmit").value + "|" + rs("qtyRefuse").value;
		//28
		result += "|" + rs("price").value + "|" + rs("payKind").value + "|" + rs("payGroup").value + "|" + rs("reexamine").value + "|" + rs("reexamineName").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("qtyWaitCheck").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateProjectInfo " + nodeID + ",'" + keyID + "','" + item + "','" + refID + "','" + unescape(String(Request.QueryString("object"))) + "','" + unescape(String(Request.QueryString("address"))) + "','" + String(Request.QueryString("deadline")) + "'," + kindID + ",'" + unescape(String(Request.QueryString("linker"))) + "','" + unescape(String(Request.QueryString("mobile"))) + "','" + unescape(String(Request.QueryString("phone"))) + "','" + unescape(String(Request.QueryString("email"))) + "','" + String(Request.QueryString("price")) + "','" + String(Request.QueryString("payKind")) + "','" + String(Request.QueryString("payGroup")) + "','" + host + "','" + String(Request.QueryString("dept")) + "','" + memo + "','" + currUser + "'";
		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM projectInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "setProjectStatus"){
	sql = "exec setProjectStatus " + nodeID + "," + status + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getStatus"){
	sql = "SELECT status FROM projectInfo where projectID='" + refID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value;
	}
	rs.Close();
	Response.Write((result));
}

if(op == "getPrice"){
	sql = "SELECT price,payKind FROM projectInfo where projectID='" + refID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("price").value + "|" + rs("payKind").value;
	}
	rs.Close();
	Response.Write((result));
}

%>
