<!--#include file="js/doc.js" -->

<%
var docName = "";
var docTitle = "";

if (String(Request.QueryString("docName")) != "undefined" && 
    String(Request.QueryString("docName")) != "") { 
  docName = unescape(String(Request.QueryString("docName")));
}
if (String(Request.QueryString("docTitle")) != "undefined" && 
    String(Request.QueryString("docTitle")) != "") { 
  docTitle = unescape(String(Request.QueryString("docTitle")));
}

if(op == "getListByRef"){
	sql = "SELECT * FROM v_uploadFile";
	if(refID>"" && kindID>""){
		sql += " where refID='" + refID + "' and refKind='" + kindID + "'";
		
		rs = conn.Execute(sql);
		var c = 0;
		
		while (!rs.EOF){
			c += 1;
			result += "%%" + rs("docID").value + "|" + rs("docName").value + "|" + rs("docTitle").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("docStatus").value;
			rs.MoveNext();
		}
		rs.Close();
		
		if(result > ""){
			result = result.substr(2);
		}
	}
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "addDoc"){
	result = 0;
	if(docName == ""){
		result = 1;  //没有选择要上传的文件
	}
	if(refID == "" || refID == "0"){
		result = 2;  //请先选择一个主体再上传附件
	}
	if(docTitle == ""){
		result = 3;  //附件标题不能为空
	}
	
	if(result == 0){
		sql = "exec updateUploadFile 0,'" + docName + "','" + docTitle + "','" + refID + "','" + kindID + "','" + currUser + "'";
		execSQL(sql);
	}
	Response.Write(result);
	//Response.Write(sql);
}

if(op == "delDoc"){
	sql = "delete FROM uploadFile where docID=" + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}
%>
