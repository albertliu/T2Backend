<!--#include file="js/doc.js" -->

<%
var userNo = 0;
var uID = 0;
var userName = "";
var userList = "";

if (String(Request.QueryString("uID")) != "undefined" && 
    String(Request.QueryString("uID")) != "") { 
  uID = String(Request.QueryString("uID"));
}
if (String(Request.QueryString("userNo")) != "undefined" && 
    String(Request.QueryString("userNo")) != "") { 
  userNo = unescape(String(Request.QueryString("userNo")));
}
if (String(Request.QueryString("userName")) != "undefined" && 
    String(Request.QueryString("userName")) != "") { 
  userName = unescape(String(Request.QueryString("userName")));
}
if (String(Request.QueryString("userList")) != "undefined" && 
    String(Request.QueryString("userList")) != "") { 
  userList = String(Request.QueryString("userList"));
}

if(op == "getUserRole"){
	sql = "SELECT role FROM users where userName='" + userName + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("role").value;
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getUserInfoByName"){
	sql = "SELECT ID,status,userName,realName,passwd,isnull(moveUser,'') as moveUser,isnull(description,'') as description FROM users where userName='" + userName + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("status").value + "|" + rs("userName").value + "|" + rs("realName").value + "|" + rs("passwd").value + "|" + rs("moveUser").value + "|" + rs("description").value + "|" + rs("ID").value;
	}
	rs.Close();
	Response.Write(result);
}	

if(op == "getUserListByUnit"){
	if(uID==0){
		sql = "SELECT * FROM v_userInfo where pID is null";
	}else{
		sql = "SELECT * FROM v_userInfo where deptID=" + uID;
	}
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "," + rs("status") + "|" + rs("userName") + "|" + rs("realName") + "|" + rs("unitName") + "|" + rs("empID") + "|" + rs("limitedDate") + "|" + rs("acsGroup") + "|" + rs("userStatus") + "|" + rs("email");
		result += "|" + rs("reason") + "|" + rs("createDate") + "|" + rs("createrID") + "|" + rs("loginDate") + "|" + rs("loginCount") + "|" + rs("lockCount");
		rs.MoveNext();
	}
	result = result.substr(1);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getUserList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(realName like('%" + where + "%') or userName like('%" + where + "%'))";
	}
	//如果有公司
	s = "(host='" + currHost + "' or partnerID>'')";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}
	if(currPartner > ""){ // 
		s = "partnerID=" + currPartner;
		where = where + " and " + s;
	}
	//如果有部门
	if(String(Request.QueryString("partnerID")) > "0" && String(Request.QueryString("partnerID")) != "null" && String(Request.QueryString("partnerID")) !="undefined"){ // 
		s = "partnerID=" + String(Request.QueryString("partnerID"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态，按照状态查询
	if(status > ""){ // 有分类
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
	
	sql = " FROM v_userInfo " + where + " and status<9";	//不显示被删除的用户
	result = getBasketTip(sql,"");
	ssql = "SELECT userNo,realName,deptName,limitedDate,statusName,phone,email,memo,regDate,registerName" + sql + " order by userNo";
	sql = "SELECT top " + basket + " *" + sql + " order by userNo";
	
	rs = conn.Execute(sql);
	var c = 0;
	while (!rs.EOF){
		c += 1;
		result += "%%" + rs("userID") + "|" + rs("userNo") + "|" + rs("userName") + "|" + rs("realName") + "|" + rs("status") + "|" + rs("statusName") + "|" + rs("partnerID") + "|" + rs("partnerName") + "|" + rs("host");
		//9
		result += "|" + rs("kindID") + "|" + rs("limitedDate") + "|" + rs("phone") + "|" + rs("email") + "|" + rs("memo") + "|" + rs("regDate") + "|" + rs("registerID") + "|" + rs("registerName") + "|" + rs("kindName");
		rs.MoveNext();
	}
	//result = result.substr(2);
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getUserListShort"){
	sql = "SELECT status,userName,realName,deptID,deptName FROM v_userInfo where status=0 order by realName";
	
	rs = conn.Execute(sql);
	var c = 0;
	while (!rs.EOF){
		c += 1;
		result += "%%" + rs("userName").value + "|" + rs("realName").value + "|" + rs("status").value + "|" + rs("deptID").value + "|" + rs("deptName").value;
		rs.MoveNext();
	}
	if(result > ""){
		result = result.substr(2);
	}
	rs.Close();
	Response.Write(escape(result));
	
	//Response.Write(escape(sql));
}	

if(op == "getUserListJson"){
	sql = "SELECT status,userName,realName,deptID,deptName FROM v_userInfo where status=0 order by realName";
	
	rs = conn.Execute(sql);
	var c = 0;
	while (!rs.EOF){
		c += 1;
		result += ',{"id":"' + rs("userName").value + '","name":"' + rs("realName").value + '","dept":"' + rs("deptName").value + '"}';
		rs.MoveNext();
	}
	if(c > 0){
		result = result.substr(1);
		result = "[" + result + "]";
	}
	rs.Close();
	Response.Write(escape(result));
	
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_userInfo where userID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("userID") + "|" + rs("userNo") + "|" + rs("userName") + "|" + rs("realName") + "|" + rs("status") + "|" + rs("statusName") + "|" + rs("partnerID") + "|" + rs("partnerName") + "|" + rs("host");
		//9
		result += "|" + rs("kindID") + "|" + rs("limitedDate") + "|" + rs("phone") + "|" + rs("email") + "|" + rs("memo") + "|" + rs("regDate") + "|" + rs("registerID") + "|" + rs("registerName") + "|" + rs("kindName");
		//18
		result += "|" + rs("signature")
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	sql = "SELECT userName FROM userInfo where userID<>" + nodeID + " and userName='" + userName + "'";
	var rs1 = conn.Execute(sql);
	if (!rs1.EOF){
		//同名的用户已经存在
		result = 1;
	}
	rs1.close();
	if(result==0 && userName == ""){       
		//用户名不能为空
		result = 2;   
	}   
	if(result==0 && unescape(String(Request.QueryString("realName"))) == ""){       
		//姓名不能为空
		result = 3;   
	}
	if(result == 0){
		sql = "exec updateUserInfo " + nodeID + ",'" + userName + "','" + unescape(String(Request.QueryString("realName"))) + "','" + String(Request.QueryString("status")) + "','" + String(Request.QueryString("partnerID")) + "','";
		sql += unescape(String(Request.QueryString("phone"))) + "','" + String(Request.QueryString("limitedDate")) + "','" + currHost + "','" + memo + "','" + currUser + "'";
		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT userID as maxID FROM userInfo where userName='" + userName + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delUserInfo " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "resetPasswd"){
	sql = "exec resetUserPasswd " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getUserNameListByWhere"){
	sql = "SELECT * FROM v_userInfo where " + where;
	rs = conn.Execute(sql);
	var c = 0;
	while (!rs.EOF){
		c += 1;
		result += "," + rs("userName").value;
		rs.MoveNext();
	}
	result = result.substr(1);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getOperatorList"){
	sql = "SELECT userName,realName FROM users where deptID<>0 or deptID is null";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "," + rs("userName").value + "|" + rs("realName").value;
		rs.MoveNext();
	}
	result = result.substr(1);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getRoleListByUser"){
	sql = "select a.ID,b.roleName,isnull(b.description,'') as description from roleUserList a,roleInfo b where a.roleID=b.roleID and a.userName='" + userName + "'";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("roleName").value + "|" + rs("description").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getRoleList"){
	sql = "select roleID,roleName,isnull(description,'') as description from roleInfo where roleID not in(select roleID from roleUserList where userName='" + userName + "')";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("roleID").value + "|" + rs("roleName").value + "|" + rs("description").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getPermissionListByUser"){
	sql = "select a.permissionID,b.permissionName,b.description from userPermissionList a, dbo.getPermissionListByUser('" + userName + "') b where a.permissionID=b.permissionID and a.userName='" + userName + "' order by b.permissionName";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("permissionID").value + "|" + rs("permissionName").value + "|" + rs("description").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getPermissionList"){
	sql = "select permissionID,permissionName,description from dbo.getWantPermissionListByUser('" + userName + "') order by permissionName";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("permissionID").value + "|" + rs("permissionName").value + "|" + rs("description").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getAllPermissionListByUser"){
	sql = "select permissionID,permissionName,description from dbo.getPermissionListByUser('" + userName + "') order by permissionName";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("permissionID").value + "|" + rs("permissionName").value + "|" + rs("description").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "edit"){
	result = checkForm();
	if(result == 0){
		sql = "update users set passwd='" + String(Request.Form("passwd")) + "'";
		sql = sql + " where ID=" + Request.Form("ID");
		execSQL(sql);
	}
	Response.Write(result);
}

if(op == "editUser"){
	sql = "update users set answer1='" + unescape(String(Request.QueryString("answer1"))) + "',answer2='" + unescape(String(Request.QueryString("answer2"))) + "'";
	sql += " where ID=" + userNo;
	execSQL(sql);
	//Response.Write(escape(sql));
}

if(op == "addRole2User"){
	sql = "insert into roleUserList(roleID,userName,host) values('" + uID + "','" + userName + "','" + currHost + "')";
	execSQL(sql);
	Response.Write("0");
}	

if(op == "removeRole4User"){
	sql = "delete from roleUserList where ID=" + uID;
	execSQL(sql);
	Response.Write("0");
}	

if(op == "addPermission2User"){
	sql = "insert into userPermissionList(permissionID,userName,registerID) values('" + kindID + "','" + userName + "','" + currUser + "')";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "removePermission4User"){
	sql = "delete from userPermissionList where permissionID='" + kindID + "' and userName='" + userName + "'";
	execSQL(sql);
	Response.Write("0");
}	

if(op == "getCourseListByTeacher"){
	sql = "select ID,courseID,shortName from v_courseTeacherList where teacherID='" + refID + "'";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("shortName").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getTeacherCourseList"){
	sql = "select certID,certName from dbo.getTeacherCourseList('" + refID + "')";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("certID").value + "|" + rs("certName").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "addCourse2Teacher"){
	sql = "insert into courseTeacherList(courseID,teacherID,registerID) values('" + nodeID + "','" + refID + "','" + currUser + "')";
	execSQL(sql);
	Response.Write("0");
}	

if(op == "removeCourse4Teacher"){
	sql = "delete from courseTeacherList where ID=" + nodeID;
	execSQL(sql);
	Response.Write("0");
}	

if(op == "getTeacherList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(teacherName like('%" + where + "%') or teacherID like('%" + where + "%'))";
	}
	//如果有公司
	s = "host='" + currHost + "'";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}
	//如果有状态，按照状态查询
	if(status > "" && status !="undefined" && status !="null"){ // 有分类
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

	sql = " FROM v_teacherInfo " + where
	ssql = "SELECT teacherID,teacherName,statusName,host,memo,regDate,registerName" + sql + " order by teacherID";
	sql = "SELECT *" + sql + " order by teacherID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID") + "|" + rs("teacherID") + "|" + rs("teacherName") + "|" + rs("status") + "|" + rs("statusName") + "|" + rs("host");
		//6
		result += "|" + rs("hostName") + "|" + rs("memo") + "|" + rs("regDate") + "|" + rs("registerID") + "|" + rs("registerName");
		rs.MoveNext();
	}
	result = result.substr(2);
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getTeacherInfo"){
	sql = "SELECT * FROM v_teacherInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID") + "|" + rs("teacherID") + "|" + rs("teacherName") + "|" + rs("status") + "|" + rs("statusName") + "|" + rs("host");
		//6
		result += "|" + rs("hostName") + "|" + rs("memo") + "|" + rs("regDate") + "|" + rs("registerID") + "|" + rs("registerName");
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "updateTeacherInfo"){
	result = 0;
	sql = "exec updateTeacherInfo " + Request.Form("ID") + ",'" + Request.Form("teacherID") + "','" + Request.Form("teacherName") + "','" + Request.Form("status") + "','" + Request.Form("memo") + "','" + currHost + "','" + currUser + "'";

	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re");
	}
/**/
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "findPwd1"){
	//根据密码问题验证用户身份
	var answer1 = unescape(String(Request.QueryString("answer1")));
	var answer2 = unescape(String(Request.QueryString("answer2")));
	if(answer1 == "" || answer2 == ""){
		result = 1 + "|" + "答案不能为空!";
	}else{
		sql = "select answer1,answer2,passwd from users where userName='" + userName + "'";
		rs = conn.Execute(sql);
		if(!rs.EOF){
			result = 0 + "|" + "通过验证，请记住您的密码: [ " + rs("passwd").value + " ]";
			if(rs("answer1") != answer1){
				result = 2 + "|" + "第一个答案不对，请重新输入。";
			}else{
				if(rs("answer2") != answer2){
					result = 3 + "|" + "第二个答案不对，请重新输入。";
				}
			}
		}
		rs.close();
	}
	Response.Write(escape(result));
}

if(op == "findPwd2"){
	//将密码发送到两个邮箱
	result = 9 + "|" + "密码已成功发送到您的邮箱，请查收!";
	
	sql = "exec sendMail_tellPwd @userName='" + userName + "'";
	execSQL(sql);
	sql = "insert into userLog(username,event) values('" + userName + "','feedBackPwd')";
	execSQL(sql);

	Response.Write(escape(result));
}

if(op == "accountActive"){
	//激活列表中的用户
	setUserList();
	sql = "exec accountActive @userList='" + userList + "',@editor='" + Session("user_key") + "'";
	execSQL(sql);
}

if(op == "accountClose"){
	//禁用列表中的用户
	setUserList();
	sql = "exec accountClose @userList='" + userList + "',@editor='" + Session("user_key") + "'";
	execSQL(sql);
}

if(op == "accountOpen"){
	//启用列表中的用户
	setUserList();
	sql = "exec accountOpen @userList='" + userList + "',@editor='" + Session("user_key") + "'";
	execSQL(sql);
}

if(op == "accountDel"){
	//删除列表中的用户
	setUserList();
	sql = "exec accountDel @userList='" + userList + "',@editor='" + Session("user_key") + "'";
	execSQL(sql);
}

function setUserList(){
	if(userList == ""){
		userList = Session("userCart");
	}
}

function  checkForm(){
  var r = 0;   
	sql = "SELECT userName FROM users where ID<>" + userNo + " and userName='" + userName + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		//同名的用户已经存在
		r = 1;
	}
  if(userName == "" || String(Request.QueryString("passwd")) == "" || String(Request.QueryString("realName")) == "")   
  {       
      //用户名\密码\姓名不能为空
      r = 2;   
  }   
  return  r;   
}   

if(op == "chkUserName"){
	result = 0;
	sql = "SELECT userName FROM users where ID<>" + userNo + " and userName='" + userName + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = 1;
	}
	rs.close();
	Response.Write(result);
}	

if(op == "chkUser"){
	result = 0;
	sql = "SELECT userName FROM userInfo where userID<>" + nodeID + " and userNo='" + userNo + "' and host='" + currHost + "'";
	var rs1 = conn.Execute(sql);
	if (!rs1.EOF){
		//同名的用户已经存在
		result = 1;
	}
	rs1.close();
	Response.Write(result);
}	

if(op == "changePasswd"){
	sql = "update userInfo set password='" + String(Request.QueryString("passwd")) + "'";
	sql = sql + " where userName='" + userName + "'";
	execSQL(sql);
	Response.Write(0);
}
%>
