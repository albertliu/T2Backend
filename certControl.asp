<!--#include file="js/doc.js" -->

<%

if(op == "getCertList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(certName like('%" + where + "%') or certID='" + where + "')";
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
	if(kindID < 99 && kindID > ""){ // 
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

	sql = " FROM v_certificateInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT certID,certName,hours,statusName,kindName,markName,agencyName,term,memo,regDate,registerName" + sql + " order by agencyID,certID";
	sql = "SELECT top " + basket + " *" + sql + " order by agencyID, certID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("term").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("agencyID").value + "|" + rs("agencyName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		//12
		result += "|" + rs("termExt").value + "|" + rs("type").value + "|" + rs("mark").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_certificateInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("term").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("agencyID").value + "|" + rs("agencyName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		//12
		result += "|" + rs("re").value + "|" + rs("mark").value + "|" + rs("shortName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateCertificateInfo " + nodeID + ",'" + String(Request.QueryString("certID")) + "','" + unescape(String(Request.QueryString("certName"))) + "','" + unescape(String(Request.QueryString("shortName"))) + "','" + String(Request.QueryString("re")) + "','" + String(Request.QueryString("term")) + "','" + String(Request.QueryString("agencyID")) + "'," + status + "," + String(Request.QueryString("mark")) + ",'" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM certificateInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelCert " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delCertInfo '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getCertNeedMaterialListByCertID"){
	var s = "";
	//如果有分类
	if(refID > ""){ // 
		s = "certID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_certNeedMaterial " + where;
	sql = "SELECT *" + sql + " order by kindID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("kindID").value + "|" + rs("item").value + "|" + rs("description").value;
		rs.MoveNext();
	}
/**/
	result = result.substr(2);
	Response.Write(escape(result));
}	

if(op == "getCertNeedMaterialListByProjectID"){
	var s = "";
	where = " a.certID=b.certID";
	//如果有分类
	if(refID > ""){ // 
		s = "projectID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_certNeedMaterial a, projectInfo b " + where;
	sql = "SELECT a.*" + sql + " order by a.kindID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("kindID").value + "|" + rs("item").value + "|" + rs("description").value;
		rs.MoveNext();
	}
/**/
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

%>
