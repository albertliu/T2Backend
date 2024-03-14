<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<!--#include file="../Connections/conn_js.asp" -->
<%

if (String(Request.QueryString("public")) != "undefined" && 
    String(Request.QueryString("public")) != "") { 
  Session("public") = String(Request.QueryString("public"));
}

chkUserActive();
var currUser = Session("user_key");
var currUserName = Session("name_key");
var basket = getDicItem(0,"basket");
var pageItem = 0;
var pageModel = "window";
var pageTitle = "特种作业在线学习系统";
var mobile_url = "http://021edu.net:3000";
var dk = 0;
var dmark = "";
var dKind = "";
var ssql = "";
var result = "";
var op = "";
var nodeID = 0;
var status = 0;
var keyID = "";
var kindID = "";
var refID = "";
var fStart = "";
var fEnd = "";
var where = "";
var item = "";
var memo = "";
var mySection = 0;	//本区编号
var currHost = Session("user_host");
var currPartner = Session("user_partner");
var currHostName = Session("user_hostName");
var host = "";


if (String(Request.QueryString("pageItem")) != "undefined" && 
    String(Request.QueryString("pageItem")) != "") { 
  pageItem = String(Request.QueryString("pageItem"));
}
if (String(Request.QueryString("pageModel")) != "undefined" && 
    String(Request.QueryString("pageModel")) != "") { 
  pageModel = String(Request.QueryString("pageModel"));
}
if (String(Request.QueryString("dk")) != "undefined" && 
    String(Request.QueryString("dk")) != "") { 
  dk = String(Request.QueryString("dk"));
}
if (String(Request.QueryString("op")) != "undefined" && 
    String(Request.QueryString("op")) != "") { 
  op = String(Request.QueryString("op"));
}
if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "") { 
  nodeID = String(Request.QueryString("nodeID"));
}
if (String(Request.QueryString("keyID")) != "undefined" && 
    String(Request.QueryString("keyID")) != "") { 
  keyID = String(Request.QueryString("keyID"));
}
if (String(Request.QueryString("refID")) != "undefined" && 
    String(Request.QueryString("refID")) != "") { 
  refID = String(Request.QueryString("refID"));
}
if (String(Request.QueryString("kindID")) != "undefined" && 
    String(Request.QueryString("kindID")) != "") { 
  kindID = String(Request.QueryString("kindID"));
}
if (String(Request.QueryString("status")) != "undefined" && 
    String(Request.QueryString("status")) != "") { 
  status = String(Request.QueryString("status"));
}
if (String(Request.QueryString("fStart")) != "undefined" && 
    String(Request.QueryString("fStart")) != "") { 
  fStart = String(Request.QueryString("fStart"));
}
if (String(Request.QueryString("fEnd")) != "undefined" && 
    String(Request.QueryString("fEnd")) != "") { 
  fEnd = String(Request.QueryString("fEnd"));
}
if (String(Request.QueryString("item")) != "undefined" && 
    String(Request.QueryString("item")) != "") { 
  item = unescape(String(Request.QueryString("item")));
}
if (String(Request.QueryString("memo")) != "undefined" && 
    String(Request.QueryString("memo")) != "") { 
	memo = unescape(String(Request.QueryString("memo")));
}
if (String(Request.QueryString("where")) != "undefined" && 
    String(Request.QueryString("where")) != "") { 
  where = unescape(String(Request.QueryString("where")));
}
if (String(Request.QueryString("host")) != "undefined" && 
    String(Request.QueryString("host")) != "") { 
	host = String(Request.QueryString("host"));
}
Session("dk" + dk) = op;

Date.prototype.format = function(format) //author: meizz 
{ 
  var o = { 
    "M+" : this.getMonth()+1, //month 
    "d+" : this.getDate(),    //day 
    "h+" : this.getHours(),   //hour 
    "m+" : this.getMinutes(), //minute 
    "s+" : this.getSeconds(), //second 
    "q+" : Math.floor((this.getMonth()+3)/3),  //quarter 
    "S" : this.getMilliseconds() //millisecond 
  } 
  if(/(y+)/.test(format)) format=format.replace(RegExp.$1, 
    (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
  for(var k in o)if(new RegExp("("+ k +")").test(format)) 
    format = format.replace(RegExp.$1, 
      RegExp.$1.length==1 ? o[k] : 
        ("00"+ o[k]).substr((""+ o[k]).length)); 
  return format; 
} 
//alert(new Date().format("yyyy-MM-dd"));
var currDate = new Date().format("yyyy-MM-dd");
var currYear = new Date().format("yyyy");
var currMonth = new Date().getMonth() + 1;
sql = "select datename(week,getDate()) as week";
rs = conn.Execute(sql);
var currWeek = rs("week").value;
rs.close();

function execSQL(strSQL){
    // execute any SQL statment
    var rs_comm = conn.Execute(strSQL);
    //rs_comm.Close();
}
  
function setReadLog(docID,docType){
		//写阅读日志
		sql = "select * from docReaderList where docID=" + docID + " and type='" + docType + "' and readerID='" + Session("user_key") + "'";
		var rsTemp = conn.Execute(sql);

		if (rsTemp.EOF){
			var sql = "INSERT INTO docReaderList(docID,Reader,ReaderID,Jd,Jw,type) VALUES(" + docID + ",'" + Session("name_key") + "','" + Session("user_key") + "','" + Session("jd_key") + "','" + Session("jw_key") + "','" + docType + "')";
			execSQL(sql);
		}
		rsTemp.Close();
}

function setReturnLog(kindID,refID){
		//写回执
		var sql="exec setReturnLog '" + kindID + "','" + refID + "','" + currUser + "','" + currHost + "'";
		execSQL(sql);
}

function setOpLog(event,kind,memo,refID){
	//写操作日志 writeOpLog @event varchar(50),@kind int,@operator varchar(50),@memo varchar(500),@refID varchar(50)
	var sql="exec writeOpLog '" + event + "','" + kind + "','" + currUser + "','" + memo + "','" + refID + "'";
	execSQL(sql);
}

function setLoginLog(re){
		//写登录日志
		var sql="insert into userLoginLog(userName,result) values('" + currUser + "'," + re;
		execSQL(sql);
}
  
function userHasPermission(userID,permissionID){
		//查询用户是否有某项权限
		var i = 0;
		sql = "select dbo.userHasPermission('" + userID + "','" + permissionID + "') as count";
		var rsTemp = conn.Execute(sql);
		if (!rsTemp.EOF){
			i = rsTemp("count").value;
		}
		rsTemp.Close();
		return i;
}

function gb2312(key)
              {
                    var r = "";
                    for(var i=0;i<key.length;i++)
                    {
                            var t = key.charCodeAt(i);
                            if(t>=0x4e00 || t==0x300A || t==0x300B)
                            {
                                    try
                                    {
                                    execScript("ascCode=hex(asc(\""+key.charAt(i)+"\"))", "vbscript"); r += ascCode.replace(/(.{2})/g, "%$1"); }
                                    catch(e)
                                     {}
                             }
                            else{r += escape(key.charAt(i))}
                       }
                    return r;
               }

function getUserActive(){
	var user = Session("user_key");
	if(user == null || user == "undifined" || user == ""){
		//Response.Redirect("default.asp");
		Response.Write("<script> top.location.href='default.asp'; </script>");
		return null;
	}else{
		return user;
	}
}

function chkUserActive(){
	var user = Session("user_key");
	var public = Session("public");
	if((user == null || user == "undifined" || user == "") && public !=1){
		//Response.Redirect("default.asp?msg=对不起，您的操作已经超时，请重新登录。");
		Response.Write("<script>top.location='default.asp?event=logout&msg=" + escape("对不起，您的操作已经超时，请重新登录。") + "'</script>");
	}
	return false;
}

function chkPageActive(){
	var user = Session("user_key");
	if(user == null || user == "undifined" || user == ""){
		return false;
	}else{
		return true;
	}
}

//javascript去空格函数 
/*
function trim(str){  //删除左右两端的空格    
	return str.replace(/(^\s*)|(\s*$)/g, "");    
}    
function ltrim(str){  //删除左边的空格    
	return str.replace(/(^\s*)/g,"");    
}    
function rtrim(str){  //删除右边的空格    
	return str.replace(/(\s*$)/g,"");    
}    
*/


String.prototype.Trim = function()
{
	return this.replace(/(^s*)|(s*$)/g, "");
}
String.prototype.LTrim = function()
{
	return this.replace(/(^s*)/g, "");
}
String.prototype.Rtrim = function()
{
	return this.replace(/(s*$)/g, "");
}
//Example: $.trim(" hello, how are you? ");

function userHasRole(userID,roleID){
	var i = 0;
	sql = "select dbo.userHasRole('" + userID + "','" + roleID + "') as count";
	var rsTemp = conn.Execute(sql);
	if (!rsTemp.EOF){
		i = rsTemp("count").value;
	}
	rsTemp.Close();
	return i;
}

function nz(strIn,strOut){
	var result = strIn;
	//if(strIn.length < 1 || strIn == "null" || strIn == null){
	if(! strIn){
		result = strOut;
	}
	return result;
}

//fillFormat("1",3,"0",0) = "001"
function fillFormat(strIn,intLng,strFill,location){
	var result = String(strIn);
	while(result.length < intLng){
		if(location==0){//填充在前面
			result = strFill + result;
		}else{
			result = result + strFill;
		}
	}
	return result;
}

function zeroNoDisp(m){
	var s = "&nbsp;";
	if(m > 0){
		s = m;
	}
	return s;
}

function nullNoDisp(m){
	var s = "&nbsp;";
	if(m != null && m > "" && m != "null"){
		s = m;
	}
	return s;
}

function nullDateUpdate(d){
	//在更新数据库中日期字段时，页面上空的日期用NULL代替。
	var s = "null";
	if(d != null && d > "" && d != "null"){
		s = "'" + d + "'";
	}
	return s;
}

/* 
功能：判断是否为日期(格式:yyyy年MM月dd日,yyyy-MM-dd,yyyy/MM/dd,yyyyMMdd) 
提示信息：未输入或输入的日期格式错误！ 
使用：f_check_date(obj) 
返回：bool 
*/ 
function f_check_date(obj)   
{   
    var date = Trim(obj.value);   
    var dtype = obj.eos_datatype;   
    var format = dtype.substring(dtype.indexOf("(")+1,dtype.indexOf(")"));  //日期格式   
    var year,month,day,datePat,matchArray;   
  
    if(/^(y{4})(-|\/)(M{1,2})\2(d{1,2})$/.test(format))   
        datePat = /^(\d{4})(-|\/)(\d{1,2})\2(\d{1,2})$/;   
    else if(/^(y{4})(年)(M{1,2})(月)(d{1,2})(日)$/.test(format))   
        datePat = /^(\d{4})年(\d{1,2})月(\d{1,2})日$/;   
    else if(format=="yyyyMMdd")   
        datePat = /^(\d{4})(\d{2})(\d{2})$/;   
    else  
    {   
        f_alert(obj,"日期格式不对");   
        return false;   
    }   
    matchArray = date.match(datePat);   
    if(matchArray == null)    
    {   
        f_alert(obj,"日期长度不对,或日期中有非数字符号");   
        return false;   
    }   
    if(/^(y{4})(-|\/)(M{1,2})\2(d{1,2})$/.test(format))   
    {   
        year = matchArray[1];   
        month = matchArray[3];   
        day = matchArray[4];   
    } else  
    {   
        year = matchArray[1];   
        month = matchArray[2];   
        day = matchArray[3];   
    }   
    if (month < 1 || month > 12)   
    {                
        f_alert(obj,"月份应该为1到12的整数");   
        return false;   
    }   
    if (day < 1 || day > 31)   
    {   
        f_alert(obj,"每个月的天数应该为1到31的整数");   
        return false;   
    }        
    if ((month==4 || month==6 || month==9 || month==11) && day==31)   
    {   
        f_alert(obj,"该月不存在31号");   
        return false;   
    }        
    if (month==2)   
    {   
        var isleap=(year % 4==0 && (year % 100 !=0 || year % 400==0));   
        if (day>29)   
        {                  
            f_alert(obj,"2月最多有29天");   
            return false;   
        }   
        if ((day==29) && (!isleap))   
        {                  
            f_alert(obj,"闰年2月才有29天");   
            return false;   
        }   
    }   
    return true;   
}   

//校验身份证号码
function checkIDcard(idcard){ 
/*
var Errors=new Array( 
"验证通过!", 
"身份证号码位数不对!", 
"身份证号码出生日期超出范围或含有非法字符!", 
"身份证号码校验错误!", 
"身份证地区非法!" 
); 
*/
	var Errors=new Array(1,2,3,4,5); 
	var area={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"}  
	var idcard,Y,JYM; 
	var S,M; 
	var idcard_array = new Array(); 
	idcard_array = idcard.split(""); 
	//地区检验 
	if(area[parseInt(idcard.substr(0,2))]==null) return Errors[4]; 
	//身份号码位数及格式检验 
	switch(idcard.length){ 
		case 15: 
			if ( (parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 )){ 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//测试出生日期的合法性 
			} else { 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//测试出生日期的合法性 
			} 
			if(ereg.test(idcard)) return Errors[0]; 
			else return Errors[2]; 
			break; 
		case 18: 
		//18位身份号码检测 
		//出生日期的合法性检查  
		//闰年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
		//平年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
		if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
			ereg=/^[1-9][0-9]{5}[1-9][0-9][0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式 
		} else { 
			ereg=/^[1-9][0-9]{5}[1-9][0-9][0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式 
		} 
		if(ereg.test(idcard)){//测试出生日期的合法性 
			//计算校验位 
			S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 
			+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9 
			+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 
			+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 
			+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8 
			+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 
			+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 
			+ parseInt(idcard_array[7]) * 1  
			+ parseInt(idcard_array[8]) * 6 
			+ parseInt(idcard_array[9]) * 3 ; 
			Y = S % 11; 
			M = "F"; 
			JYM = "10X98765432"; 
			M = JYM.substr(Y,1);//判断校验位 
			if(M == idcard_array[17]) return Errors[0]; //检测ID的校验位 
			else return Errors[3]; 
		} 
		else return Errors[2]; 
		break; 
		default: 
		return Errors[1]; 
		break; 
	} 
} 

//将15位身份证转成18位，非法号码不予转换
function turnID15218(num){ 
//校验位按照ISO 7064:1983.MOD 11-2的规定生成，X可以认为是数字10。
	if(checkIDcard(num)==1){
		var arrInt = new Array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2);
	  var arrCh = new Array('1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2');
	  var nTemp = 0, i;  
	  num = num.substr(0, 6) + '19' + num.substr(6, num.length - 6);
	  for(i = 0; i < 17; i ++){
	     nTemp += num.substr(i, 1) * arrInt[i];
	  }
	  num += arrCh[nTemp % 11];  
	}
  return num;  
}

//根据身份证信息获得生日、性别、年龄信息
function getIDinfo(id,key){
	var result = "";
	if(id.length==18){
		if(key==1){  //生日
			result = id.substr(6,4) + "-" + id.substr(10,2) + "-" + id.substr(12,2);
		}
		if(key==2){  //性别
			result = "男";
			if(parseInt(id.substr(16,1))%2==0){
				result = "女";
			}
		}
		if(key==3){  //年龄
			var d = new Date();
			var today = d.getYear()*10000 + (d.getMonth()+1)*100 + d.getDate();
			var birthday = parseInt(id.substr(6,4))*10000 + parseInt(id.substr(10,2))*100 + parseInt(id.substr(12,2));
			result = Math.floor((today - birthday)/10000);
		}
	}
	return escape(result);
}

//根据身份证信息获得生日、性别、年龄信息
function getIDdetail(id){
	var result = "";
	if(id.length==18){
		//生日
			result = id.substr(6,4) + "-" + id.substr(10,2) + "-" + id.substr(12,2);
			if(parseInt(id.substr(16,1))%2==0){
				result += "|0";  //女
			}else{
				result += "|1";  //男
			}
			var d = new Date();
			var today = d.getYear()*10000 + (d.getMonth()+1)*100 + d.getDate();
			var birthday = parseInt(id.substr(6,4))*10000 + parseInt(id.substr(10,2))*100 + parseInt(id.substr(12,2));
			result += "|" + Math.floor((today - birthday)/10000);  //年龄
	}
	return result;
}


//根据给定关键字查询指定记录是否存在
function recordExist(table,field,keyID){
	var result = 0;
	sql = "select * from " + table + " where " + field + "='" + keyID + "'";
	var rsTemp = conn.Execute(sql);

	if (!rsTemp.EOF){
		result = 1;
	}
	rsTemp.Close();
	return result;
}

//根据给定的日期计算年月，可以增加指定的月数，得到的格式为"YYYY-MM"，getYM('2010-11-18',-2) = '2010-09'
function getYM(theDate,addMonth){
	var myDate = theDate;
	var strMonth = "";
	myDate.setMonth(myDate.getMonth() + addMonth);
	myDate.setDate(1);
	var strYear = myDate.getYear();
	if(strYear<=1000){strYear=strYear+1900;}
	if(myDate.getMonth()+1<10){strMonth = myDate.getMonth()+1;strMonth = "0" +strMonth;}
	else{strMonth = myDate.getMonth()+1;}
	
	return 	strYear + "-" + strMonth;
}

function getDicItem(keyID,kind){
	var result = "";
	sql = "SELECT item FROM dictionaryDoc WHERE ID=" + keyID + " and kind='" + kind + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("item").value;
	}
	rs.Close();
	return result;
}

function getBasketTip(sqlStr,sumStr){
	var re = "";
	var s = "";
	if(sumStr == ""){
		s = "select count(*) as count,0 as sums";
	}else{
		s = "select count(*) as count,sum(" + sumStr + ") as sums";
	}
	var rsTemp = conn.Execute(s + sqlStr);
	if (!rsTemp.EOF){
		rsCount = rsTemp("count").value;
		re = rsCount + "|" + rsTemp("sums").value + "%%总共有" + rsCount + "条记录";
		if(rsCount > basket){
			re += "，在此只显示" + basket + "条，其余进行搜索或下载后查看全部记录。";
		}
	}else{
		re = "0|0";
	}
	rsTemp.close();
	return re;
}

function getSysEnv(env){
	var WshShell = new ActiveXObject("WScript.Shell");  
	var strRet =  WshShell.Environment("system").item(env);
	return strRet;
}
%>
