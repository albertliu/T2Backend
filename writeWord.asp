<!--#include file="js/doc.js" -->

<%
var rs
var op = "";
var kindID = 0;
var nodeID = 0;
var result = "";

if (String(Request.QueryString("op")) != "undefined" && 
    String(Request.QueryString("op")) != "") { 
  op = String(Request.QueryString("op"));
}
if (String(Request.QueryString("kindID")) != "undefined" && 
    String(Request.QueryString("kindID")) != "") { 
  kindID = String(Request.QueryString("kindID"));
}
if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "") { 
  nodeID = String(Request.QueryString("nodeID"));
}

//if (kindID=="0"){	
	//output contract information for word calling
	sql = "select * from dbo.getWordOutput(" + kindID + ",'" + nodeID + "')";
	rs = conn.Execute(sql);
	var k = rs.Fields.Count;
	var MyArray = new Array();
	var i = 0;
	
	if(!rs.EOF){
		for(j=0; j<k; j++){
			c = rs(j).name + "|" + rs(j).value;
			MyArray[j] = c;
		}
		rs.Close();
		i = k;
	}
	Session("floatArray") = MyArray;
	Response.Write(i);
//}

%>
