<!--#include file="js/doc.js" -->

<%
var floatKind = "";
var floatTitle = "";
var floatQuery = "";
var floatItem = "";
var floatLog = "";
var floatSum = "";
var floatMark = "";

if (String(Request.QueryString("floatKind")) != "undefined" && 
    String(Request.QueryString("floatKind")) != "" && String(Request.QueryString("floatKind")) != "null") { 
  floatKind = String(Request.QueryString("floatKind"));
}
if (String(Request.QueryString("floatTitle")) != "undefined" && 
    String(Request.QueryString("floatTitle")) != "" && String(Request.QueryString("floatTitle")) != "null") { 
  floatTitle = String(Request.QueryString("floatTitle"));
}
if (String(Request.QueryString("floatItem")) != "undefined" && 
    String(Request.QueryString("floatItem")) != "" && String(Request.QueryString("floatItem")) != "null") { 
  floatItem = unescape(String(Request.QueryString("floatItem")));
}
if (String(Request.QueryString("floatLog")) != "undefined" && 
    String(Request.QueryString("floatLog")) != "" && String(Request.QueryString("floatLog")) != "null") { 
  floatLog = unescape(String(Request.QueryString("floatLog")));
}
if (String(Request.QueryString("floatSum")) != "undefined" && 
    String(Request.QueryString("floatSum")) != "" && String(Request.QueryString("floatSum")) != "null") { 
  floatSum = unescape(String(Request.QueryString("floatSum")));
}
floatMark = Session("dk" + floatKind + "_mark");
floatKind = Session("dk" + floatKind);

if(floatMark>""){
	floatKind += floatMark;
}
floatQuery = Session(floatKind);
	//output data for excel calling
	
	rs = conn.Execute(floatQuery);
	var i = 0;
	var k = rs.Fields.Count;
	var MyArray = new Array();
	var c = "";
	
	while(!rs.EOF){
		c = i + 1;
		for(j=0; j<k; j++){
			c += "|" + rs(j).value;
		}
		MyArray[i] = c;
		rs.MoveNext();
		i += 1;
	}
	rs.Close();
	Session("floatArray") = MyArray;
	Session("floatTitle") = floatTitle;
	Session("floatItem") = floatItem;
	Session("floatLog") = floatLog;
	Session("floatSum") = floatSum;
	
	Response.Write(i);
	//Response.Write(floatKind);
%>
