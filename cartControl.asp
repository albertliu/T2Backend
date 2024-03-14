<!--#include file="js/doc.js" -->

<%

if(op == "getCartList"){
	var s = "";
	where = "registerID='" + currUser + "'";
	//如果有分类
	if(kindID > ""){ // 
		s = "kindID='" + kindID + "'";
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

	sql = " FROM v_cartBill " + where;
	sql = "SELECT *" + sql + " order by ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("refID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("kindID").value + "|" + rs("status").value;
		//6
		result += "|" + rs("mobile").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		//11
		result += "|" + rs("unit").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("shortName").value;
		rs.MoveNext();
	}
/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_cartInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result =  rs("ID").value + "|" + rs("cartID").value + "|" + rs("cartName").value + "|" + rs("hours").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//7
		result += "|" + rs("courseID").value + "|" + rs("seq").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateCartInfo " + nodeID + ",'" + String(Request.QueryString("cartID")) + "','" + unescape(String(Request.QueryString("cartName"))) + "','" + String(Request.QueryString("hours")) + "','" + String(Request.QueryString("courseID")) + "'," +  + String(Request.QueryString("seq")) + "," + kindID + "," + status + ",'" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM cartInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "add2cart"){
	//sql = "exec add2cart '" + kindID + "','" + item + "','" + memo + "','" + currUser + "'";
	sql = "exec add2cart '" + String(Request.Form("kindID")) + "','" + String(Request.Form("item")) + "','" + String(Request.Form("memo")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "getCartCount"){
	sql = "SELECT count(*) as count FROM cartBill where kindID='" + kindID + "' and registerID='" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result =  rs("count").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write((result));
}

if(op == "pickExamer4cart"){
	sql = "exec pickExamer4cart '" + refID + "','" + String(Request.Form("item")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
	//Response.Write(sql);
}

if(op == "pickApplyer4cart"){
	sql = "exec pickApplyer4cart '" + refID + "','" + String(Request.Form("item")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
	//Response.Write(sql);
}

if(op == "remove4cart"){
	sql = "exec remove4cart '" + kindID + "','" + item + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "emptyCart"){
	sql = "exec setCartEmpty '" + kindID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}
%>
