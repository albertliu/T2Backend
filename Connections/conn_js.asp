<%
// 创建数据库对象
var conn = new ActiveXObject("ADODB.Connection");
var strdsn = "DSN=etrainT2;UID=sqlrw;PWD=De0penl99O53!4N#~9.";
//var strdsn = "DSN=etraining;UID=sa;PWD=Admin12345";

// 打开数据源
	conn.Open(strdsn);

var sql = "";
var rs = "";
var rsCount = 0;
%>