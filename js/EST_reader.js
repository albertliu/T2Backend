
var socket;
function openReader() {
	var host = "ws://127.0.0.1:33666"; //客户端电脑本地IP，非服务器IP，无需修改
	if(socket == null){
		socket = new WebSocket(host);
	}else{
		resultMsg("已初始化.");
	}
	try {
		socket.onopen = function () {
			resultMsg("初始化成功."); //可以注释
			getVersion(); //可以注释：控件版本号
			//readSAMID(); //可以注释：读卡器芯片号，全球唯一，通常可用来授权管理，只支持EST-100GS，不支持其他型号
			//autoReadIDCard(); //自动读卡可以放这里，自动读卡放身份证的间隔要>300ms，否则会不读卡
		};
		socket.onclose = function () {
			resultMsg("读卡服务已经断开.");
		};
		socket.onerror = function(){
			resultMsg("请检查控件是否正常安装，下载地址：...");
		};
		socket.onmessage = function (msg) {
			if (typeof msg.data == "string") {
				var msgM=msg.data+"";
				var msgJson = JSON.parse(msgM);
				//resultMsg(msgM);        
				switch(msgJson.fun) {

					case "EST_GetVersion#":
							resultMsg("版本号："+msgJson.errMsg);
					break;

					case "EST_Reader_ReadIDCard#":
						if (msgJson.rCode == "0") {
							dealResponse(msgJson);
							// document.getElementById("text_name").value = msgJson.name;  //姓名  
							// document.getElementById("text_sex").value = msgJson.sex;  //性别             
							// document.getElementById("text_nation").value = msgJson.nation;  //民族                      
							// document.getElementById("text_birthday").value = msgJson.birth; //出生日期                  
							// document.getElementById("text_address").value = msgJson.address; //住址  
							// document.getElementById("text_idNum").value = msgJson.certNo; //身份证号码      
							// document.getElementById("text_dept").value = msgJson.department;  //签发机关    
							// document.getElementById("text_effDate").value = msgJson.effectData; //有效期开始
							// document.getElementById("text_expDate").value = msgJson.expire; //有效期结束
							// document.getElementById("PhotoID").src = "data:image/jpeg;base64,"+msgJson.base64Data;  //身份证头像，base64格式数据，实际尺寸：102x126px
							// document.getElementById("PhotoIDFront").src = "data:image/jpeg;base64,"+msgJson.imageFront; //身份证正面照片，实际尺寸：540x340px，如无需使用，建议注释掉
							// document.getElementById("PhotoIDBack").src = "data:image/jpeg;base64,"+msgJson.imageBack; //身份证反面照片，实际尺寸：540x340px，如无需使用，建议注释掉
							posBeep();
							//ReadCertID();  //身份证物理ID，如无需使用，建议注释掉
							resultMsg(msgJson.errMsg);
						}
						else if(msgJson.rCode == "1"){
							resultMsg("已停止自动读卡");
						}
						else if(msgJson.rCode == "-2"){
							resultMsg("请放身份证");
						}
						else {
							resultMsg(msgJson.errMsg);
						}
						break;

					case "EST_ReadCertID#":  //身份证物理ID
						if (msgJson.rCode == "0") {
							document.getElementById("text_ID").value = msgJson.UID;  
							//posBeep();
						}
						else {
							resultMsg(msgJson.errMsg);
						}
					break;
					
					case "EST_ReadBankCard#":  //银行卡卡号
						if (msgJson.rCode == "0") {
							document.getElementById("text_Bank_ID").value = msgJson.bankCard;
							posBeep();
						}
						else {
							resultMsg(msgJson.errMsg);
						}
						break;

					case "EST_ReadM1Card#":  //IC卡卡号
						if (msgJson.rCode == "0") {
							document.getElementById("text_IC_ID").value = msgJson.UID;
							posBeep();
						}
						else {
							resultMsg(msgJson.errMsg);
						}
						break;

					case "EST_ReadSocialCard#":   //社保卡信息，个别地区社保卡不按国家规范来的，会读取信息不全
						if (msgJson.rCode == "0") { 
							posBeep();
							document.getElementById("S_text_name").value = msgJson.XM;  //社保卡姓名  
							document.getElementById("S_text_sex").value = msgJson.XB;  //社保卡性别             
							document.getElementById("S_text_nation").value = msgJson.MZ;  //社保卡民族                      
							document.getElementById("S_text_birthday").value = msgJson.CSRQ; //社保卡出生日期                  
							document.getElementById("S_text_idNum").value = msgJson.SHBZHM; //社保卡身份证号      
							document.getElementById("S_text_effDate").value = msgJson.FKRQ; //社保卡有效期开始
							document.getElementById("S_text_expDate").value = msgJson.KYXQ; //社保卡有效期结束
							document.getElementById("S_text_kahao").value = msgJson.SBKH; //社保卡卡号
						}
						else {
							resultMsg(msgJson.errMsg);
						}
						break;


					case "EST_FindCardM1#":
							if (msgJson.rCode == "0") {
								resultMsg("寻卡成功，M1卡UID：" + msgJson.Uid);
							}
							else {
								resultMsg(msgJson.errMsg);
							}
					break;

					case "EST_VerifyKeyM1#":
							if (msgJson.rCode == "0") {
								resultMsg("秘钥认证成功");
							}
							else {
								resultMsg(msgJson.errMsg);
							}
					break;

					case "EST_ReadCardM1#":
							if (msgJson.rCode == "0") {
								resultMsg("读卡成功，数据为：" + msgJson.readData);
							}
							else {
								resultMsg(msgJson.errMsg);
							}
					break;

					case "EST_WriteCardM1#":
							if (msgJson.rCode == "0") {
								resultMsg("写卡成功");
							}
							else {
								resultMsg(msgJson.errMsg);
							}
					break;

					case "EST_PowerOnCpu#": //非接CPU卡上电信息
							if (msgJson.rCode == "0") {
								resultMsg("复位信息：" + msgJson.ATR);
							}
							else {
								resultMsg(msgJson.errMsg);
							}
					break;

					case "EST_WriteCpu#": //非接CPU卡APDU指令响应信息
							if (msgJson.rCode == "0") {
								resultMsg("响应数据：" + msgJson.Resp);
							}
							else {
								resultMsg(msgJson.errMsg);
							}
					break;

					case "EST_ReaderGertSAMID#": //获得读卡器芯片系列号，读卡器授权可以放这里来判断
							if (msgJson.rCode == "0") {
								resultMsg("系列号：" + msgJson.SAMID);
							}
							else {
								resultMsg(msgJson.errMsg);
							}
					break;

					default:
						break;
				}
			}
			else{
				alert("连接异常,请检查是否成功安装控件.");
			}
		};
	}
	catch (ex) {
		alert("连接异常,请检查是否成功安装控件.");
	}
}

//提示信息
function resultMsg(msg) {
   document.getElementById("text_result").value += "\r\n" + msg;
}

//清空文本框信息
function clearinput()
{
}

//控件版本号
function getVersion() {        
	socket.send("EST_GetVersion#");
}

//蜂鸣器控制，可以自己选择是否蜂鸣
function posBeep() {
	if (socket.readyState == 1) {
			socket.send("EST_PosBeep#");
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
}

//单次读取身份证信息
function readIDCard() {
	try {
		if (socket.readyState == 1) {
			socket.send("EST_Reader_ReadIDCard#");
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}

//自动读取身份证信息，外部轮询实现，身份证不拿开会一直读
function autoReadIDCard2(){ 
    readIDCard(); 
    setInterval("readIDCard()", 1000); 
} 

//自动读取身份证信息，内部轮询实现
function autoReadIDCard() {
	try {
		if (socket.readyState == 1) {
			socket.send("EST_Reader_ReadIDCard#|1");
			resultMsg("自动读卡，请放身份证...");
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}

//停止连续读取身份证信息
function stopAutoReadIDCard() {
	try {
		if (socket.readyState == 1) {
			socket.send("EST_StopReadIDCard#");
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}


//读取身份证物理ID，16位16进制数据，一般情况用不到，可以注释掉
function ReadCertID() {
	try { 
		if (socket.readyState == 1) {
			socket.send("EST_ReadCertID#"); 
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}

//读取IC卡号，包括M1、CPU卡，8位16进制数据
function readM1Card() {
	try { 
		if (socket.readyState == 1) {
			socket.send("EST_ReadM1Card#"); 
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}

//读取银行卡号，支持QUICK PASS闪付银行卡，大部分卡支持，少部分地方性银行会读取失败
function readBankCard() {
	try {
		if (socket.readyState == 1) {
			socket.send("EST_ReadBankCard#");  
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}

//读社保卡，支持二代芯片社保卡，三代卡无秘钥不能读取
function readSocialCard() {
	try {
		if (socket.readyState == 1) {
			socket.send("EST_ReadSocialCard#");  
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}


//IC卡读写操作函数，包括M1卡读写、CPU卡读写等功能，详细指令见开发文档中3.2.11 IC卡操作函数部分
function cardOperate() {
	try {
		if (socket.readyState == 1) {
			socket.send(document.getElementById("S_text_kacaozuo").value);  
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}



//M1寻卡
function cardOperate1() {
	try {
		if (socket.readyState == 1) {
			socket.send("EST_FindCardM1#");  
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}

//M1认证秘钥，自己改参数15和秘钥FFFFFFFFFFFF，具体含义见开发文档
function cardOperate2() {
	try {
		if (socket.readyState == 1) {
			socket.send("EST_VerifyKeyM1#|Key_A|15|FFFFFFFFFFFF");  
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}

//M1读卡，自己改参数61，具体含义见开发文档
function cardOperate3() {
	try {
		if (socket.readyState == 1) {
			socket.send("EST_ReadCardM1#|61");  
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}


//获得读卡器芯片系列号，全球唯一，通常可用来授权管理
function readSAMID() {
	try {
		if (socket.readyState == 1) {
			socket.send("EST_ReaderGertSAMID#");  
		}
		else {
			resultMsg("未找到控件，请检查控件是否安装.");
		}
	}
	catch (ex) {
		resultMsg("连接异常,请检查是否成功安装控件.");
	}
}
//关闭soket
function closeSocket() {
	try {
		if(socket != null){
			socket.close();
			socket = null;
		}
	}
	catch (ex) {
	}
};

// 默认页面打开，就自动打开设备
window.onload=openReader();    
setTimeout("autoReadIDCard2()","2000"); 