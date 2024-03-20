<!--#include file="js/doc.js" -->
<%
var mode = "";
if (String(Request.QueryString("mode")) != "undefined" && 
    String(Request.QueryString("mode")) != "") { 
  mode = String(Request.QueryString("mode"));
}

var table = "";
if (String(Request.QueryString("table")) != "undefined" && 
    String(Request.QueryString("table")) != "") { 
  table = unescape(String(Request.QueryString("table")));
}
var field = "";
if (String(Request.QueryString("field")) != "undefined" && 
    String(Request.QueryString("field")) != "") { 
  field = unescape(String(Request.QueryString("field")));
}
var sName = "";
if (String(Request.QueryString("sName")) != "undefined" && 
    String(Request.QueryString("sName")) != "") { 
  sName = unescape(String(Request.QueryString("sName")));
}
var anyStr = "";
if (String(Request.QueryString("anyStr")) != "undefined" && 
    String(Request.QueryString("anyStr")) != "") { 
  anyStr = unescape(String(Request.QueryString("anyStr")));
}

if(op == "getDicList"){
	sql = "SELECT ID,item FROM dictionaryDoc WHERE kind='" + keyID + "' order by ID";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	if(result > ""){
		result = result.substr(2);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "chkUserActive"){
	chkUserActive();
}

if(op == "getComList"){
	sql = "select " + field + " as ID," + sName + " as item from " + table;
	if(where > ""){
		sql += " where " + where;
	}
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}

if(op == "getComboBoxList"){
	sql = "SELECT ID,item FROM dictionaryDoc WHERE kind='" + keyID + "' order by ID";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += ",{'ID':'" + rs("ID").value + "','item':'" + rs("item").value + "'}";
		rs.MoveNext();
	}
	if(result > ""){
		result = result.substr(1);
	}
	rs.Close();
	Response.Write(escape("[" + result + "]"));
}

if(op == "getComboList"){
	sql = "select " + field + " as ID,REPLACE(REPLACE(" + sName + ",char(13),''),char(10),'') as item from " + table;
	if(where > ""){
		sql += " where " + where;
	}
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += ",{'ID':'" + rs("ID").value + "','item':'" + rs("item").value + "'}";
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(1);
	}
	Response.Write(escape("[" + result + "]"));
}

if(op == "getComUserList"){
	sql = "select distinct ID,item from dbo.getComUserList('" + currUser + "'," + keyID + "," + refID + "," + kindID + ") order by item";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}

if(op == "getDicItem"){
	result = getDicItem(keyID, anyStr);
	Response.Write(escape(result));
}

if(op == "getDicItemByID"){
	sql = "SELECT * FROM dictionaryDoc WHERE mID=" + keyID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("mID").value + "|" + rs("ID").value + "|" + rs("item").value + "|" + rs("kind").value + "|" + rs("description").value + "|" + rs("memo").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "setDicItem"){
	sql = "update dictionaryDoc set item='" + Request.Form("item") + "',description='" + Request.Form("description") + "',memo='" + Request.Form("memo") + "' WHERE mID=" + Request.Form("mID");
	execSQL(sql);
	//Response.Write(escape(sql));
}

if(op == "getUserStatusList"){
	sql = "select * from dictionaryDoc where kind='userStatus' order by ID";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "," + rs("ID").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	result = result.substr(1);
	rs.Close();
	Response.Write(escape(result));
}

if(op == "getQuestionList"){
	sql = "SELECT * FROM question where enabled=1 order by ID";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "," + rs("ID").value + "|" + rs("title").value;
		rs.MoveNext();
	}
	result = result.substr(1);
	rs.Close();
	Response.Write(escape(result));
}

if(op == "setSession"){
	Session(sName) = String(Request.Form("anyStr"));
	Response.Write(Session(sName));
}

if(op == "getSession"){
	result = nz(Session(sName),'');
	result = result.replace("%","%25");
	Response.Write(escape(result));
}

if(op == "clearSession"){
	if(Session(sName)>""){
		Session(sName) = "";
	}
}

if(op == "getCurrParam"){
	result = currDate + "|" + currUser + "|" + Session("name_key") + "|" + currYear + "|" + currMonth + "|" + currWeek + "|" + currHost + "|" + currPartner + "|" + getSysEnv("NODE_ENV_UPLOAD_URL") + "|" + getSysEnv("NODE_ENV_BACKEND_ET") + "|" + currHostName;
	Response.Write(escape(result));
}

if(op == "delFromSession"){
	if(Session(sName)>"" && anyStr>""){
		result = Session(sName);
		//find the key value in session, if found it, remove the value and split charactor
		result = result.replace(("," + anyStr + ","),",");
		if(result == Session(sName)){
			result = result.replace((anyStr + ","),"");
		}
		if(result == Session(sName)){
			result = result.replace(("," + anyStr),"");
		}
		if(result == Session(sName)){
			result = result.replace(anyStr,"");
		}
		Session(sName) = result;
	}
	Response.Write(Session(sName));
}

if(op == "setOpLog"){
	var ar = new Array();
	ar = anyStr.split("|");
	setOpLog(ar[0],ar[1],ar[2],ar[3]);		//event,kind,memo,refID
}

if(op == "setReturnLog"){
	setReturnLog(kindID,refID);
}

if(op == "updateTabCell"){
	sql = "exec updateTabCell '" + table + "','" + field + "','" + nodeID + "','" + item + "'";
	execSQL(sql);

	Response.Write(escape(0));
}

if(op == "checkIDcard"){
	Response.Write(checkIDcard(unescape(nodeID)));
}

if(op == "turnID15218"){
	Response.Write(turnID15218(unescape(nodeID)));
}

if(op == "getReceiverListJson"){
	sql = "SELECT * FROM dbo.getReceiverList('" + kindID + "','" + refID + "')";
	rs = conn.Execute(sql);
	var c = 0;
	while (!rs.EOF){
		c += 1;
		result += ',{"id":"' + rs("userID").value + '","name":"' + rs("userName").value + '"}';
		rs.MoveNext();
	}
	if(c > 0){
		result = result.substr(1);
		result = "[" + result + "]";
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "getWorkDateAfter"){
	sql = "SELECT convert(varchar(20),dbo.getWorkDateAfter(" + refID + ",'" + keyID + "'),23) as item";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("item").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "checkExistKeyInTab"){
	result = 0;
	sql = "SELECT 1 as item from " + table + " where " + field + "='" + nodeID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("item").value;
	}
	rs.Close();
	Response.Write(result);
}	

%>