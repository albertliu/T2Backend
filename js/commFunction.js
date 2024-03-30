
	$.ajaxSetup({ async: false });
		
	var arr = new Array();
	var hArr = new Array();
	var hostURL = "";
	var localTemp = "";
	var currDate = "";
	var currYear = "";
	var currMonth = "";
	var currWeek = "";
	var currUser = "";
	var currUserName = "";
	var currHost = "";
	var currPartner = "";
	var currHostName = "";
	let _host = getSession("_host");
	let _partner = getSession("_partner");
	var floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
	var floatItem = "";		//write to excel file's 2nd row
	var floatLog = "";		//write to excel file's 3rd row
	var floatKind = new Array();		//a mark point some special thing in target program
	var floatKey = "";		//
	var floatContent = "";	//records data for output
	var floatSum = "";		//recordset's sum items
	var floatCount = 0;		//recordset's count
	var floatModel = 0;		//output file's summary type
	var idTmr = "";
	var pageItem = "<%=pageItem%>";
	var pageModel = "<%=pageModel%>";
	var visitobj = true;
	var selList = "";
	var selList1 = "";
	var selCount = 0;
	var selCount1 = 0;
	var currPage = "";
	var uploadURL = "";
	var backendURL = "";
	var token_user = new Array();
	var ctree = 0;
	var imgChk = "<img src='images/green_check.png' />";
	var imgChkWrong = "<img src='images/wrong_check.png' style='width:15px;' />";
	var imgFile = "<img src='images/attachment.png' style='width:15px;' />";
	
	var pickupID = 0;			//选择项目编号
	var pickupName = "";	//选择项目名称

	var colorReadOnly = "#e8e8e8";
	var colorNormal = "#fcfcfc";
	var extImg = "&nbsp;<img src='images/star.png' border='0' width='11' height='11' title='超期'>";

	// $.get("commonControl.asp?op=getDicItem&keyID=0&anyStr=hostURL&times=" + (new Date().getTime()),function(re){
	// 	hostURL = unescape(re);
	// });

	// $.get("commonControl.asp?op=getDicItem&keyID=0&anyStr=localTemp&times=" + (new Date().getTime()),function(re){
	// 	localTemp = unescape(re);
	// });
	
	$.get("commonControl.asp?op=getCurrParam&times=" + (new Date().getTime()),function(data){
		var ar = unescape(data).split("|");
		currDate = ar[0];
		currUser = ar[1];
		currUserName = ar[2];
		currYear = ar[3];
		currMonth = ar[4];
		currWeek = ar[5];
		currHost = ar[6];
		currPartner = ar[7];
		uploadURL = ar[8];
		backendURL = ar[9];
		currHostName = ar[10];
	});
		
	function chkUserActive(){
		$.get("commonControl.asp?op=chkUserActive&times=" + (new Date().getTime()),function(re){
		});
	}
		
	function checkPermission(pID){
		//alert(pID);
		var result = false;
		//alert("1:"+pID);
		$.get("permissionControl.asp?op=checkPermission&permissionID=" + pID + "&times=" + (new Date().getTime()),function(re){
			//alert("2:"+re);
			if(re>0){
				result = true;
			}
		});
		return result;
	}
		
	function checkRole(pID){
		//alert(pID);
		var result = false;
		//alert("1:"+pID);
		$.get("permissionControl.asp?op=checkRole&roleID=" + pID + "&times=" + (new Date().getTime()),function(re){
			//alert("2:"+re);
			if(re>0){
				result = true;
			}
		});
		return result;
	}
	
	//确定当前用户是否为有任何审批权限的人，如果返回0表示不是，1表示是
	function imChecker(id){
		var result = 0;
		$.get("permissionControl.asp?op=imChecker&refID=" + id + "&times=" + (new Date().getTime()),function(re){
			result = re;
		});
		return result;
	}
	
	//确定给定的身份证号码是否已有学生注册，如果返回0表示没有，>0 为有，且返回其userID
	function studentExist(id){
		var result = 0;
		$.get("studentControl.asp?op=studentExist&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			result = re;
		});
		return result;
	}
	
	//判断给定用户所属的街道，如果不属于街道，返回0，否则返回街道编号
	function getUserStreet(id){
		var result = 0;
		$.get("userControl.asp?op=getUserStreet&userID=" + id + "&times=" + (new Date().getTime()),function(re){
			result = re;
		});
		return result;
	}
		
	//向指定的下拉框填充空值
	//obj：填充目标
	function emptyList(obj){
		$("#" + obj).empty();
		$("<option value=''></option>").appendTo("#" + obj);
	}
	
	//向指定的下拉框填充列表
	//obj：填充目标, 如果为空则取kind相同名称  mark: 0 照实填充  1 第一行增加一个空行
	function getDicList(kind,obj,mark){
		$.get("commonControl.asp?op=getDicList&keyID=" + kind + "&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = (unescape(re)).split("%%");
			if(obj==""){
				obj = kind;	
			}
			$("#" + obj).empty();
			if(ar>""){
				if(mark == 1){
					$("<option value=''></option>").appendTo("#" + obj);
				}
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#" + obj);
				});
			}
		});
	}
	
	//向指定的下拉框填充列表
	//objCombox: 填充目标  tblName：表名  id/item：字段名   where: 过滤条件   mark: 0 照实填充  1 第一行增加一个空行
	function getComList(objCombox,tblName,id,item,where,mark){
		//alert(tblName + "&field=" + id + "&sName=" + item + "&where=" + (where));
		$.get("commonControl.asp?op=getComList&table=" + escape(tblName) + "&field=" + id + "&sName=" + item + "&where=" + escape(where) + "&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = (unescape(re)).split("%%");
			$("#" + objCombox).empty();
			if(ar>""){
				if(mark == 1){
					$("<option value=''></option>").appendTo("#" + objCombox);
				}
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#" + objCombox);
				});
			}
		});
	}
	
	//向指定的下拉框填充列表
	//obj：填充目标, 如果为空则取kind相同名称  mark: 0 照实填充  1 第一行增加一个空行
	function getComboBoxList(kind,obj,mark){
		$.get("commonControl.asp?op=getComboBoxList&keyID=" + kind + "&times=" + (new Date().getTime()),function(re){
			var ar = eval("(" + unescape(re) + ")");
			if(obj==""){
				obj = kind;	
			}
			$("#" + obj).empty();
			if(mark == 1){
				ar.unshift({'ID':'','item':''});
			}
			$("#" + obj).combobox({
				valueField: "ID",
				textField: "item"
			}).combobox("loadData",ar);
		});
	}

	//向指定的下拉框填充列表
	//obj: 填充目标  tblName：表名  id/item：字段名   where: 过滤条件   mark: 0 照实填充  1 第一行增加一个空行
	function getComboList(obj,tblName,id,item,where,mark){
		//alert(tblName + "&field=" + id + "&sName=" + item + "&where=" + (where));
		$.get("commonControl.asp?op=getComboList&table=" + tblName + "&field=" + id + "&sName=" + item + "&where=" + escape(where) + "&times=" + (new Date().getTime()),function(re){
			var ar = eval("(" + unescape(re) + ")");
			$("#" + obj).empty();
			if(mark == 1){
				ar.unshift({'ID':'','item':''});
			}
			$("#" + obj).combobox({
				valueField: "ID",
				textField: "item"
			}).combobox("loadData",ar);
			if(mark == 0){
				$("#" + obj).combobox("select", ar[0].ID);	//自动选择第一项
			}
		});
	}

	//向指定的下拉框填充列表
	//obj: 填充目标  tblName：表名  id/item：字段名   where: 过滤条件   mark: 0 照实填充  1 第一行增加一个空行
	function checkExistKeyInTab(obj,tblName,id,val){
		$.get("commonControl.asp?op=checkExistKeyInTab&table=" + tblName + "&field=" + id + "&nodeID=" + val + "&times=" + (new Date().getTime()),function(re){
			if(re==1){
				jAlert("该编码(" + val + ")已存在，请核实。");
				$("#" + obj).textbox("setValue", "");
			}
		});
	}
	
	//向指定的下拉框填充有权限查看的用户列表
	//objCombox: 填充目标  eID：工程编号   pID: 项目编号   mark: 0 包括自己（第一行） 1 不包括自己  blank: 0 没有空行  1 第一行为空
	function setComUserList(objCombox,eID,pID,mark,blank){
		$.get("commonControl.asp?op=getComUserList&keyID=" + eID + "&refID=" + pID + "&kindID=0&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = (unescape(re)).split("%%");
			$("#" + objCombox).empty();
			if(blank == 1){
				$("<option value=''></option>").appendTo("#" + objCombox);
			}
			if(mark == 0){
				$("<option value='" + currUser + "'>" + currUserName + "</option>").appendTo("#" + objCombox);
			}
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#" + objCombox);
				});
			}
		});
	}
	
	function getDicItem(keyID,kind){
		var result = "";
		$.get("commonControl.asp?op=getDicItem&keyID=" + keyID + "&anyStr=" + kind + "&times=" + (new Date().getTime()),function(re){
			result = unescape(re);
		});
		return result;
	}
	
	function updateTabCell(tName,fName,nID,val){
		var result = "";
		//alert("nodeID=" + nID + "&item=" + (val) + "&table=" + (tName) + "&field=" + (fName));
		$.get("commonControl.asp?op=updateTabCell&nodeID=" + nID + "&item=" + escape(val) + "&table=" + escape(tName) + "&field=" + escape(fName) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			result = unescape(re);
		});
		return result;
	}
	
	//根据请求，返回附件的超链接
	function putAppendix(valList){
		var re = "";
		var ar = valList.split(",");
		if(ar>""){
			$.each(ar,function(iNum,val){
				var ar1 = val.split("*");
				if(val>""){
					re += "<a href='" + ar1[1] + "' target='_blank'>&nbsp;<img src='images/attachment.png' width='15' border='0' title='" + ar1[0] + "' /></a>";
				}
			});
		}
		return re;
	}
	
	function printBarCode(nodeID){
		$.get("archivesControl.asp?op=printBarCodeByArchiveID&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			jAlert("已提交打印","信息提示");
		});
	}

	//执行预先制定的语句，输出为excel文件
	//key: file/print
	function outputExcelBySQL(id,key,p1,p2,p3,p4){
		//alert(id);
		var sql = "";
		var p = "";
		if(id=='x01'){
			p = "getExamerList";
			floatModel = 2;
			sql = "select courseName,'','',passNo,'',password,name,sexName from v_passcardInfo where refID=" + p1 + " order by passNo";
		}
		if(id=='x02'){
			p = "getExamerSignList";
			floatModel = 3;
			sql = "select passNo,name,dept2Name,mobile from v_passcardInfo where refID=" + p1 + " order by passNo";
		}
		if(id=='x03'){
			p = "getExamerScoreList";
			floatModel = 2;
			sql = "select passNo,name,username,(case when kindID=1 then cast(score as varchar) else '' end) as score from v_passcardInfo where refID=" + p1 + " order by passNo";
		}
		if(id=='x04'){
			p = "getDiplomaIssueList";
			floatModel = 5;
			sql = "select a.name,(case when a.host='znxf' then a.unit else a.dept1Name end) as dept1Name,a.dept2Name,a.diplomaID,a.username,a.mobile,a.educationName,c.className,c.submitDate,c.SNo from v_diplomaInfo a, studentCertList b, v_studentCourseList c where b.ID=c.refID and a.diplomaID=b.diplomaID and a.batchID=" + p1 + " order by a.diplomaID";
		}
		if(id=='x05'){
			floatTitle = p2;
			floatItem = p3;
			if(p4==7){
				//住建委，无表头
				floatModel = 2;
				p = "getApplyListA";
				sql = "select username,name,sexName,ethnicity+'族',birthday,IDaddress,'' as address,bureau,IDdateStart,(case when IDdateStart>'' and IDdateEnd='' then '长期' else IDdateEnd end) as IDdateEnd,enterDate from v_applyInfo where refID=" + p1 + " order by passNo,ID";
			}else{
				floatModel = 5;
				p = "getApplyList";
				sql = "select name,sexName,educationName,username,mobile,unit,job,link_address,IDdateStart,IDdateEnd from v_applyInfo where refID=" + p1 + " order by passNo,ID";
			}
		}
		if(id=='x06'){
			p = "getDiplomaIssueList3rd";
			floatModel = 5;
			floatTitle = p2;
			floatItem = p3;
			sql = "select unit,a.name,left(c.examDate,10),(case when b.certID='C12' or b.certID='C14' or b.certID='C15' or b.certID='C24' or b.certID='C25' or b.certID='C26' or b.certID='C25B' or b.certID='C26B' then cast(c.score1 as varchar) + '/' + cast(c.score2 as varchar) else cast(c.score as varchar) end),a.diplomaID,a.mobile from v_diplomaInfo a, v_generateApplyInfo b, v_applyInfo c where a.batchID=b.ID and a.certID=b.certID and b.ID=c.refID and a.username=c.username and a.batchID=" + p1 + " order by a.dept1Name,a.diplomaID";
		}
		if(id=='x07'){
			p = "getStudentExamStatByClass";
			floatModel = 3;
			sql = "select username,name,examName,startDate,endDate,score1,scorePer1,score2,scorePer2,score3,scorePer3,score,scorePer from dbo.getStudentExamStatByClass('" + p1 + "')";
		}
		if(id=='x08'){
			p = "getSignListByClass";
			floatModel = 4;
			floatTitle = p2;
			sql = "select name from v_studentCourseList where classID='" + p1 + "' order by SNo";
		}
		if(id=='x09'){
			p = "getSign1ListByClass";
			floatModel = 4;
			floatTitle = p2;
			sql = "select name from v_studentCourseList where classID='" + p1 + "' order by SNo";
		}
		if(id=='x10'){
			p = "getOnlineHoursByClass";
			floatModel = 4;
			floatTitle = p2;
			sql = "select name,username,sexName,hours,completion,cast(isnull(completion*hours/100,0) as decimal(18,2)) as hoursSpend from v_applyInfo where refID='" + p1 + "' order by ID";
			// alert(p1+":"+p2+":"+sql)
		}
		setSession(p, sql);
		setSession("dk" + id, p);
		setSession("dk" + id + "_count", 60);
		//alert(sql);
		outputFloat(id,key);
	}
		
	function outputFloat(id,key){
		var m = getSession("dk" + id + "_count");
		//alert(floatCount);
		if(m>""){
			floatCount = m;
		}
		if(floatCount>0){
			// alert("floatKind=" + id + "&floatTitle=" + (floatTitle) + "&floatItem=" + (floatItem.replace(/&nbsp;/g,' ')) + "&floatLog=" + (floatLog.replace(/&nbsp;/g,' ')) + "&floatSum=" + (floatSum.replace(/&nbsp;/g,' ')));
			//$.get("writeExcel.asp?floatKind=" + floatKind[id] + "&floatTitle=" + escape(floatTitle) + "&floatItem=" + escape(floatItem.replace(/&nbsp;/g,' ')) + "&floatLog=" + escape(floatLog.replace(/&nbsp;/g,' ')) + "&floatSum=" + escape(floatSum.replace(/&nbsp;/g,' ')) + "&times=" + (new Date().getTime()),function(re){
			$.get("writeExcel.asp?floatKind=" + id + "&floatTitle=" + escape(floatTitle) + "&floatItem=" + escape(floatItem.replace(/&nbsp;/g,' ')) + "&floatLog=" + escape(floatLog.replace(/&nbsp;/g,' ')) + "&floatSum=" + escape(floatSum.replace(/&nbsp;/g,' ')) + "&times=" + (new Date().getTime()),function(re){
				// alert("re:" + re);
				if(re>0){
					// alert("gin.asp?floatKind=" + id + "&floatModel=" + floatModel);
					$.get("gin.asp?floatKind=" + id + "&floatModel=" + floatModel + "&times=" + (new Date().getTime()),function(data){
						alert(data);
						if(key=="file"){
							window.open(data);   //open an excel file in a new window
						}
						if(key=="print"){
							printExcel(data);
						}
					});
				}else{
					jAlert("导出失败!");
				}
			});
		}else{
			jAlert("没有数据!");
		}
		return true;
	}

	function  printExcel(obj)   
	{   
	  var xlsApp = null;       
    try{           
        xlsApp = new ActiveXObject('Excel.Application');    }catch(e)    
    {    
        alert(e+', 原因分析: 浏览器安全级别较高导致不能创建Excel对象或者客户端没有安装Excel软件');    
          return;    
    }     
    var xlBook = xlsApp.Workbooks.Open(hostURL + obj.replace(/\\/g,"/"));   
    var xlsheet = xlBook.Worksheets(1);   
    xlsApp.Application.Visible = false;    
    xlsApp.visible = false;    
    xlsheet.Printout; 
    //xlsheet.PrintPreview;   
    xlsApp.Quit();    
    xlsApp=null; 
    idTmr = window.setInterval("Cleanup();",1000);  //防Excel死进程的关键！
	} 
	
	function  printWord(obj)   
	{   
	  var wordApp = null; 
    try{           
        wordApp = new ActiveXObject('Word.Application');    }catch(e)    
    {    
        alert(e+', 原因分析: 浏览器安全级别较高导致不能创建Word对象或者客户端没有安装Word软件');    
        return;    
    }       
    //alert(hostURL + obj.replace(/\\/g,"/"));
    var Doc=wordApp.Documents.Open(hostURL + obj.replace(/\\/g,"/"));   
    wordApp.Application.Visible = false;    
    wordApp.visible = false;   
    wordApp.ActiveDocument.printout();   
    wordApp.ActiveDocument.close();    
    wordApp.Quit();    
    wordApp=null;       
    idTmr = window.setInterval("Cleanup();",1000);  //防Word死进程的关键！
	}   
	
	function  openWord(kind,nodeID,key)   
	{   
		$.get("writeWord.asp?kindID=" + kind + "&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			//alert(re);
			if(re>0){
				$.get("ginWord.asp?floatKind=" + kind + "&times=" + (new Date().getTime()),function(data){
					//alert(data);
					if(key=="file"){
							window.open(data);   //open an excel file in a new window
					}
					if(key=="print"){
							printWord(data);
					}
					if(key=="download"){
							copyRemoteFile2Local(hostURL + data.replace(/\\/g,"/"),localTemp.replace(/\\/g,"/") + "/" + nodeID + ".doc");
					}
				});
			}else{
				jAlert("缺少必要的数据");
			}
		});
	}  
	 
	function copyFile2Local(strRemoteURL,strLocalURL) 
	{ //alert(strRemoteURL + "-----" + strLocalURL);
		var fso = new ActiveXObject( "Scripting.FileSystemObject"); 
		fso.CopyFile(strRemoteURL,strLocalURL);   
	}	
	 
	function copyRemoteFile2Local(strRemoteURL,strLocalURL) 
	{ alert(strRemoteURL.toLowerCase() + "-----" + strLocalURL.toLowerCase());
		var sGet = new ActiveXObject("ADODB.Stream"); 
		
		var xGet = false; 
				try { 
					xGet = new ActiveXObject("Microsoft.XMLHTTP"); 
				} 
					catch (failed) { 
					xGet = false; 
				} 
		xGet.Open ("GET",strRemoteURL.toLowerCase(),false); 
		xGet.Send(); 
		//alert(xGet.readyState + " -- " + xGet.Status);
		
		
		sGet.Mode=3; 
		sGet.Type=1; 
		sGet.Open(); 
		alert(0);
		//sGet.LoadFromFile("d:/temp/111.txt"); 
		sGet.Write(xGet.responseBody); 
		//alert(xGet.ResponseBody);
		alert(1);
		sGet.SaveToFile(strLocalURL.toLowerCase(),2); 
		alert(2);
		sGet.Close(); 
		delete sGet; 
		sGet = null; 
		xGet.Close();
		xGet = null;
	}	
	
	function Cleanup(){
		window.clearInterval(idTmr);
		CollectGarbage();
	}
	
	function nullNoDisp(m){
		var s = "";
		if(m != null && m != "" && m != "null" && m != "0" && m != "0.00"){
			s = m;
		}
		return s;
	}
	
	function showWaitMsg(){
		$.blockUI({ 
			message: "<img src='images/waiting.gif' border='0' width='16'> 请稍候..." 
		});
	}
	
	function hideWaitMsg(){
		$.unblockUI();
	}

	function setOpLog(event,kind,memo,refID){
		$.get("commonControl.asp?op=setOpLog&anyStr=" + escape(event + "|" + kind + "|" + memo + "|" + refID) + "&times=" + (new Date().getTime()),function(re){
		});
	}

	function setUnitOpLog(unitCode,event,kind,opDate,operator,memo,refID){
		$.get("commonControl.asp?op=setArchUnitLog&anyStr=" + escape(unitCode + "|" + event + "|" + kind + "|" + opDate + "|" + operator + "|" + memo + "|" + refID) + "&times=" + (new Date().getTime()),function(re){
		});
	}

	function setReturnLog(kind,refID){
		//alert(kind + ":" + refID)
		$.get("commonControl.asp?op=setReturnLog&kindID=" + kind + "&refID=" + refID + "&times=" + (new Date().getTime()),function(re){
			$("#new" + kind + refID).hide();
		});
	}

	function setSession(sName,sValue){
		$.post("commonControl.asp?op=setSession&sName=" + escape(sName),{"anyStr":sValue},function(re){
			//alert(re);
		});
	}

	function getSession(sName){
		var result = "";
		$.get("commonControl.asp?op=getSession&sName=" + escape(sName) + "&times=" + (new Date().getTime()),function(re){
			result = unescape(re);
		});
		return result;
	}
	
	//nodeID: unitID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 返回单位编码
	function showUnitInfo(nodeID,op,mark){
		asyncbox.open({
			url:'unitInfo.asp?nodeID=' + nodeID + '&op=' + op + '&p=1&times=' + (new Date().getTime()),
			title: '单位信息明细',
			width : 880,
			height : 600,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getUnitList();
				}
				if(re>0 && mark==2){
					getUnitList();
				}
　　　}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表
	function showLinkerInfo(nodeID,unitID,projectID,engineeringID,op,mark){
		//alert(nodeID + "&unitID=" + unitID + "&projectID=" + projectID + "&engineeringID=" + engineeringID + "&op=" + op);
		asyncbox.open({
			url:"linkerInfo.asp?nodeID=" + nodeID + "&unitID=" + unitID + "&projectID=" + projectID + "&engineeringID=" + engineeringID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "联系人信息明细",
			width: 600,
			height: 400,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getLinkerList();
				}
　　　}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表
	function showPlanInfo(nodeID,op,mark){
		asyncbox.open({
			url:'planInfo.asp?nodeID=' + nodeID + '&op=' + op + '&p=1&times=' + (new Date().getTime()),
			title: '工作计划明细',
			width: 700,
			height: 480,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getPlanList();
				}
　　　}
		});
	}
	
	//nodeID: ID; ref: unitID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表 2 退出时刷新newsList  3 有修改时刷新日历
	function showMemoInfo(nodeID,ref,op,mark){
		asyncbox.open({
			url:"memoInfo.asp?nodeID=" + nodeID + "&refID=" + ref + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: '备忘录明细',
			width: 580,
			height: 280,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getMemoList();
					if(memoListLong==0){
						iEditMemo += 1;
					}
				}
				if(mark==2){
					getNewsList();
				}
				if(re>0 && mark==3){
					$("#calendar").fullCalendar("refetchEvents");
				}
　　　}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表
	function showWorkLogInfo(nodeID,op,mark){
		asyncbox.open({
			url:'workLogInfo.asp?nodeID=' + nodeID + '&op=' + op + '&p=1&times=' + (new Date().getTime()),
			title: '工作日志明细',
			width: 700,
			height: 480,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getWorkLogList();
				}
　　　}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 退出时刷新newsList
	function showGrantInfo(nodeID,op,mark){
		asyncbox.open({
			url:'grantInfo.asp?nodeID=' + nodeID + '&op=' + op + '&p=1&times=' + (new Date().getTime()),
			title: '授权明细',
			width: 580,
			height: 550,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("grant",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getGrantList();
				}
				if(mark==2){
					getNewsList();
				}
　　　}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 退出时刷新newsList
	function showTaskInfo(nodeID,op,mark){
		asyncbox.open({
			id: "task",
			url:'taskInfo.asp?nodeID=' + nodeID + '&op=' + op + '&p=1&times=' + (new Date().getTime()),
			title: '任务明细',
			width: 580,
			height: 550,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("task",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getTaskList();
				}
				if(mark==2){
					getNewsList();
				}
　　　}
		});
	}
	
	//nodeID: ID; refID: unit ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showFeedbackInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "feedback",
			url:"feedbackInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "学员反馈信息",
			width: 660,
			height: 440,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getFeedbackList();
				}
				if(re>0 && mark==2){
					setObjValue("feedback",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; refID: unit ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象  source:启动该窗口的母窗体
	function showStudentInfo(nodeID,refID,op,mark,source){
		asyncbox.open({
			id: "student",
			url:"studentInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "学员信息",
			width: 880,
			height: 800,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					if(source=="student"){
						getStudentList();
					}
					if(source=="enter"){
						getEnterList();
					}
				}
　　　		}
		});
	}
	
	//nodeID: ID; refID: unit ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showStudentCourseInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "studentCourse",
			url:"studentCourseInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "学员培训课程",
			width: 640,
			height: 400,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getStudentCourseList();
				}
				if(re>0 && mark==2){
					setObjValue("studentCourse",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showMessageInfo(nodeID,refID,op,mark,keyID){
		asyncbox.open({
			id: "message",
			url:"messageInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&keyID=" + keyID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "消息",
			width: 590,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("message",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getMessageList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("message",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showCertInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "cert",
			url:"certInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "证书",
			width: 600,
			height: 500,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("cert",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getCertList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("cert",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showCourseInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "course",
			url:"courseInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "课程",
			width: 800,
			height: 780,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("course",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getCourseList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("course",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; 
	function showVideoInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "video",
			url:"videoInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "视频",
			width: 700,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getVideoList();
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showCoursewareInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "courseware",
			url:"coursewareInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "课件",
			width: 700,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getCoursewareList();
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showLessonInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "lesson",
			url:"lessonInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "课节",
			width: 800,
			height: 580,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getLessonList(refID);
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showCourseLessonInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "courseLesson",
			url:"courseLessonInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "课节",
			width: 600,
			height: 300,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getCourseLessonList();
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showLessonVideoInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "lessonVideo",
			url:"lessonVideoInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "课节视频",
			width: 600,
			height: 300,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getLessonVideoList();
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showLessonCoursewareInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "lessonCourseware",
			url:"lessonCoursewareInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "课节课件",
			width: 600,
			height: 300,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getLessonCoursewareList();
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showKnowPointInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "knowPoint",
			url:"knowPointInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "知识点",
			width: 600,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("knowPoint",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getKnowPointList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("knowPoint",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showQuestionInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "question",
			url:"questionInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "题目",
			width: 830,
			height: 760,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("question",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getQuestionList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("question",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showDiplomaInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "diploma",
			url:"diplomaInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "证书",
			width: 620,
			height: 400,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("diploma",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getDiplomaList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("diploma",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; keyID: student's username
	function showDeptInfo(nodeID,refID,op,mark,host){
		asyncbox.open({
			id: "dept",
			url:"deptInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "部门信息",
			width: 600,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("dept",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getDeptList(host);
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("dept",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showHostInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "host",
			url:"hostInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "单位信息",
			width: 600,
			height: 600,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("host",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getHostList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("host",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showCheckInfo(){
		asyncbox.open({
			id: "checkinfo",
			url:"checkinfo.asp?p=1&times=" + (new Date().getTime()),
			title: "签到二维码",
			width: 600,
			height: 600,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showAgencyInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "agency",
			url:"agencyInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "认证机构信息",
			width: 600,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("agency",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getAgencyList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("agency",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showStudentNeedDiplomaInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "studentNeedDiploma",
			url:"studentNeedDiplomaInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "证书制作信息",
			width: 640,
			height: 400,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("studentNeedDiploma",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getStudentNeedDiplomaList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("studentNeedDiploma",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showGenerateDiplomaInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "generateDiploma",
			url:"generateDiplomaInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "发放证书",
			width: 600,
			height: 800,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("generateDiploma",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getGenerateDiplomaList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("generateDiploma",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; kindID:certID; refID: selList; mark: 0 不动作  1 有修改时刷新列表;
	function showGenerateDiplomaInfo1(nodeID,kindID,refID,keyID,item,op,mark){
		asyncbox.open({
			id: "generateDiploma1",
			url:"generateDiplomaInfo1.asp?nodeID=" + nodeID + "&kindID=" + kindID + "&keyID=" + keyID + "&refID=" + refID + "&op=" + op + "&item=" + escape(item) + "&p=1&times=" + (new Date().getTime()),
			title: "证书制作",
			width: 600,
			height: 800,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("generateDiploma1",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getGenerateDiplomaList();
					getStudentNeedDiplomaList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("generateDiploma",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showGenerateStudentInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "generateStudent",
			url:"generateStudentInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "报名表",
			width: 600,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("generateStudent",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getGenerateStudentList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("generateStudent",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showGenerateScoreInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "generateScore",
			url:"generateScoreInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "成绩单",
			width: 600,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("generateScore",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getGenerateScoreList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("generateScore",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showGenerateMaterialInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "generateMaterial",
			url:"generateMaterialInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "学员材料",
			width: 600,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("generateMaterial",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getGenerateMaterialList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("generateMaterial",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showExamInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "exam",
			url:"examInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "试卷",
			width: 600,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("exam",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getExamList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("exam",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showExamRuleInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "examRule",
			url:"examRuleInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "组卷规则",
			width: 600,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("examRule",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getExamRuleList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("examRule",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showProjectInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "project",
			url:"projectInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "招生信息发布",
			width: 680,
			height: 540,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("project",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getProjectList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("project",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showClassSchedule(nodeID,refID,op,mark){
		asyncbox.open({
			id: "class_schedule",
			url:"class_schedule.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "授课计划表",
			width: 880,
			height: 780,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					//getClassScheduleList();
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showScheduleInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "schedule",
			url:"scheduleInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "授课计划",
			width: 680,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getClassScheduleList();
				}
			}
		});
	}
	
	//nodeID: ID; refID: username; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表; re:0 from studentInfo  1 big window  
	function showEnterInfo(nodeID,refID,op,mark,courseID,after){
		var w = 780;
		var h = 750;
		asyncbox.open({
			id: "enterInfo",
			url:"enterInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&keyID=" + courseID + "&p=1&times=" + (new Date().getTime()),
			title: "报名信息",
			width: w,
			height: h,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//setReturnLog("enter",iframe.nodeID);	
				var re = iframe.updateCount;
				if(nodeID==0 && iframe.keyID > ""){
					//前台报名
					lastCourseID = iframe.keyID;
				}
				var reDo = iframe.reDo;
				if(re>0 && mark==1 && after>""){
					eval('(' + after + ')');	//执行指定的操作
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showMaterialsInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "materialsInfo",
			url:"materialsInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "报名材料",
			width: 650,
			height: 720,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("materials",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					//getStudentCourseList(refID);
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("enter",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ;
	function showUseCardInfo(){
		asyncbox.open({
			id: "useCard",
			url:"useCardInfo.asp?p=1&times=" + (new Date().getTime()),
			title: "身份证信息",
			width: 500,
			height: 500,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.getUpdateCount();
				fromCard = 1;
				if(re>0){
					replaceImgFromCard(iframe.selList);
					saveNode();
				}else{
					saveNode();
				}
			}
		});
	}
	
	//nodeID: ;
	function showQRshowInfo(){
		asyncbox.open({
			id: "qrShow",
			url:"qrShow.asp?times=" + (new Date().getTime()),
			title: "登录二维码",
			width: 800,
			height: 600,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//
			}
		});
	}
	
	//nodeID: ;
	function showCompletionList(refID){
		asyncbox.open({
			id: "completionList",
			url:"completionList.asp?refID=" + refID + "&times=" + (new Date().getTime()),
			title: "在线课程进度",
			width: 730,
			height: 700,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showGeneratePasscardInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "generatePasscard",
			url:"generatePasscardInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "考试场次信息",
			width: 1150,
			height: 880,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getGeneratePasscardList();
					setCartNum("examer");
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("generatePasscard",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showGenerateApplyInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "generateApply",
			url:"generateApplyInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "申报批次信息",
			width: 1440,
			height: 980,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getGenerateApplyList();
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showPartnerInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "partner",
			url:"partnerInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "部门信息",
			width: 600,
			height: 450,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getPartnerList();
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showDiplomaCards(nodeID){
		asyncbox.open({
			id: "diplomacards",
			url:"diplomaCards.asp?refID=" + nodeID + "&p=1&times=" + (new Date().getTime()),
			title: "证书打印",
			width: 380,
			height: 880,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//alert(3);
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增; mark: 0 不动作  1 有修改时刷新列表;
	function showCommLoadFile(nodeID,refID,op,mark,keyID){
		asyncbox.open({
			id: "commLoadFile",
			url:"commLoadFile.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&keyID=" + keyID + "&p=1&times=" + (new Date().getTime()),
			title: "图片批量上传",
			width: 600,
			height: 380,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("commLoadFile",iframe.nodeID);	
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getGenerateMaterialList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("commLoadFile",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}

	//nodeID: ID; refID: project ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showAttachDocInfo(nodeID,refID,kindID,op,mark){
		//alert(nodeID+":"+refID+":"+kindID+":"+op+":"+mark);
		asyncbox.open({
			id: "attachDoc",
			url:"attachDocInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&kindID=" + kindID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "项目资料",
			width: 620,
			height: 450,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//setReturnLog("attachDoc",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getAttachDocList();
				}
				if(re>0 && mark==2){
					setObjValue("attachDoc",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showUserInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "user",
			url:"userInfo.asp?nodeID=" + nodeID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "用户信息",
			width: 780,
			height: 660,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//setReturnLog("user",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getUserList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("doc",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showStudentExamStat(nodeID,refID,op,mark){
		asyncbox.open({
			id: "studentExamStat",
			url:"studentExamStat.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "学员模拟练习情况",
			width: 1080,
			height: 780,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showSignatureInfo(nodeID,refID,op,mark,after){
		asyncbox.open({
			id: "wsignature",
			url:"hand_signature.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "签字",
			width: 440,
			height: 350,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	        },
			btnsbar : false,
			callback : function(action,iframe){	
				var re = iframe.updateCount;
				var reDo = iframe.reDo;
				if(re>0 && mark==1 && after>""){
					eval('(' + after + ')');	//执行指定的操作
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showImage(nodeID,refID,op,mark){
		let w = (refID+1) * 400;
		let h = (op+1) * 250;
		asyncbox.open({
			id: "imgShow",
			url:"imgShow.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "图片",
			width: w,
			height: h,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	        },
			btnsbar : false
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showPDF(nodeID,refID,op,mark){
		asyncbox.open({
			id: "pdfShow",
			url:"pdfShow.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "PDF文档",
			width: 600,
			height: 600,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	        },
			btnsbar : false
		});
	}
	
	//txt: 要显示的内容
	function showMsg(title, txt){
		title = title>""?title:'详细内容'
		$.messager.show({
			title:title,
			msg: txt,
			showType:'fade',
			style:{
				right:'',
				bottom:''
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象  k 来源标识  kindID:photo,education...
	function showCropperInfo(nodeID,refID,kindID,k,op,mark){
		asyncbox.open({
			id: "cropper",
			url:"imageCropper.asp?nodeID=" + nodeID + "&refID=" + refID + "&kindID=" + kindID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "照片裁剪",
			width: 580,
			height: 640,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	        },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					if(k.length>1){
						$("#" + k).prop("src", nodeID + "?times=" + (new Date().getTime()));
					}else{
						$("#" + kindID + k + refID).prop("src", nodeID + "?times=" + (new Date().getTime()));
					}
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showTeacherInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "teacherInfo",
			url:"teacherInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "教师信息",
			width: 780,
			height: 780,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//setReturnLog("user",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getTeacherList();
				}
			}
		});
	}
	
	//nodeID: ID; mark: 0 不动作; kindID: 0 初考 1 补考； 1 有修改时刷新列表  2 有修改时刷新对象
	function showApplyPicker(nodeID,refID,kindID,after,mark){
		asyncbox.open({
			id: "applyPicker",
			url:"applyPicker.asp?nodeID=" + nodeID + "&refID=" + refID + "&kindID=" + kindID + "&p=1&times=" + (new Date().getTime()),
			title: "申报名单",
			width: 600,
			height: 600,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//setReturnLog("user",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				var reDo = iframe.reDo;
				if(re>0 && mark==1 && after>""){
					eval('(' + after + ')');	//执行指定的操作
				}
			}
		});
	}
	
	//nodeID: ID; mark: 0 不动作 1 有修改时刷新列表  2 有修改时刷新对象; after:关闭后执行的操作；key:0 仅上传  1 上传后需要处理  memo:在上传页面显示的title
	function showUploadFile(nodeID,refID,kindID,item,after,key,mark,memo){
		asyncbox.open({
			id: "fileUpload",
			url:"fileUpload.asp?nodeID=" + nodeID + "&refID=" + refID + "&kindID=" + kindID + "&item=" + item + "&keyID=" + key + "&memo=" + memo + "&times=" + (new Date().getTime()),
			title: "上传文件",
			width: 600,
			height: 700,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//setReturnLog("user",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				var reDo = iframe.reDo;
				if(re>0 && mark==1 && after>""){
					eval('(' + after + ')');	//执行指定的操作
				}
			}
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showClassExamStat(nodeID,refID,op,mark){
		asyncbox.open({
			id: "classExamStat",
			url:"classExamStat.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "班级模拟练习情况",
			width: 1080,
			height: 780,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showStudentSmsList(nodeID,refID,op,mark){
		asyncbox.open({
			id: "studentSmsList",
			url:"studentSmsList.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "向学员发送的短信通知",
			width: 740,
			height: 700,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showStudentExamList(nodeID,refID,op,mark){
		asyncbox.open({
			id: "studentExamList",
			url:"studentExamList.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "学员参加的考试情况",
			width: 740,
			height: 700,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showStudentOpList(nodeID,refID,op,mark){
		asyncbox.open({
			id: "studentOpList",
			url:"studentOpList.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "报名操作情况",
			width: 740,
			height: 700,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showStudentSignList(nodeID,refID,op,mark){
		asyncbox.open({
			id: "studentSignList",
			url:"studentSignList.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "学员签到情况",
			width: 540,
			height: 500,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false
		});
	}
	
	//nodeID: ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showStudentExamPaper(nodeID,refID){
		asyncbox.open({
			id: "studentExamPaper",
			url:"studentExamPaper.asp?nodeID=" + nodeID + "&refID=" + refID + "&p=1&times=" + (new Date().getTime()),
			title: "在线试卷信息",
			width: 710,
			height: 650,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false
		});
	}
	
	//nodeID: ID; kindID: kind ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showDocInfo(nodeID,kindID,op,mark){
		asyncbox.open({
			id: "doc",
			url:"docInfo.asp?nodeID=" + nodeID + "&kindID=" + kindID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "通知公告资料信息",
			width: 800,
			height: 600,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				setReturnLog("doc",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getDocList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("doc",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　}
		});
	}
	
	//nodeID: ID; refID: project ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showDocResultInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "docResult",
			url:"docResultInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "成果包信息",
			width: 750,
			height: 590,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//setReturnLog("docResult",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getDocResultList();
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("docResult",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　}
		});
	}
	
	//根据单位、项目代码返回联系人列表. unitID: 单位代码，如果为0不予处理并提示；projectID: 项目代码，如果为0表示所有联系人；engineeringID: 工程代码，如果为0表示所有联系人；long: 0 标准栏目  1 缩短栏目；mark: 0 不动作  1 有修改时刷新列表
	// item: "unit" 指定单位人员;"project" 指定项目人员; "engineering" 指定工程人员;
	function showLinkerList(objID,objName,unitID,projectID,engineeringID,long,item,mark){
		//alert("keyID=" + objID + "&refID=" + objName + "&unitID=" + unitID + "&projectID=" + projectID + "&engineeringID=" + engineeringID + "&kindID=" + long + "&item=" + item);
		if(unitID==0){
			jAlert("未选定单位，如果是新增单位请保存以后再操作。");
		}else{
			asyncbox.open({
				id: "linkerList",
				url:"linkerList.asp?keyID=" + objID + "&refID=" + objName + "&unitID=" + unitID + "&projectID=" + projectID + "&engineeringID=" + engineeringID + "&kindID=" + long + "&item=" + item + "&p=1&times=" + (new Date().getTime()),
				title: '联系人列表',
				width : 630,
				height : 470,
				cover : {
		          //透明度
		          opacity : 0,
		          //背景颜色
		           background : '#000'
		          },
	
				btnsbar : false,
				callback : function(action,iframe){
					//alert(objName + "  " + iframe.arBasket);
					if(iframe.linkerListLong==2 && mark==1){
						$("#" + objName).val(iframe.arBasket.join("  "));
					}
	　　　}
			});
		}
	}
	
	//如果有选中的记录，则显示在指定栏目内(objID,objName)。kind: 单位类别：0 '建设单位'  1 '施工单位'  2 '监理单位'
	function showUnitList(kind,objID,objName){
		asyncbox.open({
			id: "unitList",
			url:"unitList.asp?nodeID=1&keyID=" + objID + "&refID=" + objName + "&kindID=" + kind + "&p=1&times=" + (new Date().getTime()),
			title: "单位信息列表",
			width: 750,
			height: 540,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : "#000"
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//alert(iframe.pickupID + " :  " + iframe.pickupName);
				if(iframe.pickupID>0){		
					//$("#" + objID).val(iframe.pickupID);
					//$("#" + objName).val(iframe.pickupName);
				}
　　　}
		});
	}
	
	//如果有选中的记录，则显示在指定栏目内(objID,objName)。
	function showUserList(){
		asyncbox.open({
			id: "userList",
			url:"userList.asp?nodeID=1&p=1&times=" + (new Date().getTime()),
			title: "员工信息列表",
			width: 500,
			height: 500,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : "#000"
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//alert(iframe.pickupID + " :  " + iframe.pickupName);
				if(iframe.pickupID>0){		
					//$("#" + objID).val(iframe.pickupID);
					//$("#" + objName).val(iframe.pickupName);
				}
　　　}
		});
	}
	
	//refID: order... ID; kindID: order ... ; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showAttachDocList(refID,kindID,mark){
		asyncbox.open({
			id: "attachDocList",
			url:"attachDocList.asp?nodeID=1&refID=" + refID + "&kindID=" + kindID + "&p=1&times=" + (new Date().getTime()),
			title: "附属资料信息列表",
			width: 700,
			height: 500,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : "#000"
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					//getAttachDocList();
					getNodeInfo(refID);
				}
				if(mark==2){
					setObjValue("attachDocList",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　}
		});
	}
	
	//refID: project ID; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showPlanList(mark){
		asyncbox.open({
			id: "planList",
			url:"planList.asp?nodeID=1&p=1&times=" + (new Date().getTime()),
			title: "工作计划信息列表",
			width: 830,
			height: 580,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : "#000"
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getPlanList();
				}
				if(mark==2){
					setObjValue("planList",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
				setSession("ar_planList","");
　　　}
		});
	}
	
	//ref: unitID; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showMemoList(ref,mark){
		asyncbox.open({
			id: "memoList",
			url:"memoList.asp?nodeID=1&p=1&times=" + (new Date().getTime()),
			title: "备忘录信息列表",
			width: 830,
			height: 550,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : "#000"
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(ref>0 && mark==1){
					getNodeInfo(ref);
				}
				if(re>0 && mark==1){
					//getMemoList();
				}
				if(mark==2){
					setObjValue("memoList",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
				setSession("ar_memoList","");
　　　}
		});
	}
	
	//refID: project ID; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showWorkLogList(mark){
		asyncbox.open({
			id: "workLogList",
			url:"workLogList.asp?nodeID=1&p=1&times=" + (new Date().getTime()),
			title: "工作日志信息列表",
			width: 830,
			height: 580,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : "#000"
	          },

			btnsbar : false,
			callback : function(action,iframe){
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					getWorkLogList();
				}
				if(mark==2){
					setObjValue("workLogList",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
				setSession("ar_workLogList","");
　　　}
		});
	}
	
	//显示指定类型(kindID)的消息列表。
	function showNewsList(kindID){
		asyncbox.open({
			id: "newsList",
			url:"newsList.asp?kindID=" + kindID + "&p=1&times=" + (new Date().getTime()),
			title: "用户提示信息列表",
			width: 850,
			height: 620,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : "#000"
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//alert(iframe.pickupID + " :  " + iframe.pickupName);
				//if(iframe.pickupID>0){		
					//$("#" + objID).val(iframe.pickupID);
					//$("#" + objName).val(iframe.pickupName);
				//}
　　　}
		});
	}
	
	//显示指定用户的权限列表。
	function showMyPermissionList(userID){
		asyncbox.open({
			id: "myPermissionList",
			url:"myPermissionList.asp?nodeID=" + userID + "&p=1&times=" + (new Date().getTime()),
			title: "用户权限列表",
			width: 500,
			height: 500,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : "#000"
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//alert(iframe.pickupID + " :  " + iframe.pickupName);
				//if(iframe.pickupID>0){		
					//$("#" + objID).val(iframe.pickupID);
					//$("#" + objName).val(iframe.pickupName);
				//}
　　　}
		});
	}

	function getDeptTree(id,idx){
		ctree = 0;
		var bk = [];
		//$.get("deptControl.asp?op=getDeptJson&qf=0&nodeID=" + id + "&dk=0&times=" + (new Date().getTime()),function(re){
		//alert(uploadURL);
		$.get(uploadURL + "/public/getDeptTreeJson?nodeID=" + id + "&indexByDate=" + idx,function(re){
			//jAlert(re);
			//var dt = eval("(" + re + ")");
			//bk = getDeptJsonTree(dt.list,id);
			//bk = transTreeData(dt.list, 'id', 'pID', 'nodes');
			bk = transTreeData(re, 'id', 'pID', 'nodes');
		});
		return bk;
	}
	
	function getDeptJsonTree(data,parentId){
	  var itemArr = [];
	  for(var i=0;i<data.length;i++){ 
		var node=data[i];
		//data.splice(i, 1)
		if(node.pID==parentId && ctree<data.length){ 
			ctree += 1;
			var newNode={id:node.id,text:node.text,pid:node.pID,chindren:getDeptJsonTree(data,node.id)};
			itemArr.push(newNode);              
		}
	  }
	  return itemArr;
	}

	//将给定的转换成json数据，用于tree
	//var jsonData = eval('[{"belongsname":"","id":901,"isleaf":0,"name":"XJBHX-2标项目部","pid":"","type":""},{"belongsname":"","id":902,"isleaf":1,"name":"综合部(办公室)","pid":"901","type":""},{"belongsname":"","id":903,"isleaf":1,"name":"工程部(工技部/技术部)","pid":"901","type":""},{"belongsname":"","id":904,"isleaf":1,"name":"安质部","pid":"901","type":""},{"belongsname":"","id":905,"isleaf":1,"name":"计财部","pid":"901","type":""},{"belongsname":"","id":906,"isleaf":1,"name":"物设部(物机部)","pid":"901","type":""},{"belongsname":"","id":907,"isleaf":1,"name":"中心试验室","pid":"901","type":""}]');
	//绑定的字段
	//var jsonDataTree = transTreeData(jsonData, 'id', 'pid', 'chindren');
	function transTreeData(a, idStr, pidStr, chindrenStr) {
		var r = [], hash = {}, id = idStr, pid = pidStr, children = chindrenStr, i = 0, j = 0, len = a.length;
		for (; i < len; i++) {
			hash[a[i][id]] = a[i];
		}
		for (; j < len; j++) {
			var aVal = a[j], hashVP = hash[aVal[pid]];
			if (hashVP) {
				!hashVP[children] && (hashVP[children] = []);
				hashVP[children].push(aVal);
			} else {
				r.push(aVal);
			}
		}
		return r;
	}

	function showUserPasswdInfo(){
		asyncbox.open({
			url:'userPasswordInfo.asp?nodeID=" + currUser + "&p=1&times=' + (new Date().getTime()),
			title: '修改用户密码',
			width : 380,
			height : 350,
			cover : {
				//透明度
				opacity : 0,
				//背景颜色
				background : '#000'
			},

			btnsbar : false,
			callback : function(action,iframe){
				if(action == 'ok'){
					//iframe.saveNode();
					//jAlert("密码修改成功。","信息提示");
		　　　　}
		　　}
		});
	}

	function setCurrMenuItem(){
		$("#" + currPage).css("color","#305998");
		$("#" + currPage).css("background","#E0E0E0");
	}
	
	//根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
	function setObjValue(objList,valList,mark,loc){
		var ar = getSession(objList).split("|");
		var ar1 = valList.toString().split("|");
		if(ar>""){
			$.each(ar,function(iNum,val){
				if(val>""){
					if(loc==0){
						$("#" + val).val(ar1[iNum]);
					}else{
						parent.$("#" + val).val(ar1[iNum]);
					}
				}
			});
		}
		if(mark==1){
			if(loc==0){
				$.close(objList);
			}else{
				parent.$.close(objList);
			}
		}
	}
	
	//根据请求，对任意个数的object设置readOnly属性。objList:传入的Object列表；mark：0 false 1 true；blank：1 如果是空值则修改属性，否则不修改 0 不考虑
	function setObjReadOnly(objList,mark,blank){
		var ar = objList.split("|");
		var aType = "";
		if(ar>""){
			$.each(ar,function(iNum,val){
				//aType = $("#" + val).attr("type");
				aType = $("#" + val)[0].type;
				//if(val=="unitCode"){alert(aType);}
				//if(val=="kind"){alert(aType);}
				if(mark==0 &&(blank==0 || (blank==1 && $("#" + val).val()>""))){
					if(aType=="text"){
						$("#" + val).attr("readOnly",false);
						$("#" + val).attr("class","");
					}
					if(aType=="select-one"){
						$("#" + val).attr("disabled",false);
					}
				}
				if(mark==1 &&(blank==0 || (blank==1 && $("#" + val).val()>""))){
					if(aType=="text"){
						$("#" + val).attr("readOnly",true);
						$("#" + val).attr("class","readOnly");
					}
					if(aType=="select-one"){
						$("#" + val).attr("disabled",true);
					}
				}
			});
		}
	}
	
	//根据请求，对任意个数的object设置mustFill属性。objList:传入的Object列表；mark：0 false 1 true；
	function setObjMustFill(objList,mark){
		var ar = objList.split("|");
		var aType = "";
		if(ar>""){
			$.each(ar,function(iNum,val){
				aType = $("#" + val)[0].type;
				if(mark==0){
					if(aType=="text"){
						$("#" + val).attr("class","");
					}
				}
				if(mark==1){
					if(aType=="text"){
						$("#" + val).attr("class","mustFill");
					}
				}
			});
		}
	}
			
	function showFloatCover(){
		if(floatCount > 0){
			//$("#floatCover").empty();
			//$("#floatCover").html(floatContent);
			$("#floatTitle").html(floatTitle);
			$("#floatItem").html(floatItem);
			$("#floatLog").html(floatLog);
			$("#floatSum").html(floatSum);
			/*
			$('#floatTab').dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aoColumnDefs": []
			});
			*/
			document.getElementById("lightFloat").style.display="block";
			document.getElementById("fadeFloat").style.display="block";
		}else{
			jAlert("抱歉，没有查到相关数据。","提示信息");
		}
	}
	
	//弹出窗口显示指定DIV的内容，关闭后将窗口内容写回DIV
	function showDescriptionGlass(obj){
		var s = $("#" + obj).val();
		//if(s > ""){
			asyncbox.open({
				html: "<textarea id='openDesc' style='background:#fdfcff; padding:5px;' cols='83' rows='22'>" + s + "</textarea>",
				title: "内容",
	　　　width : 550,
	　　　height : 365,
	　　　callback : function(action){
　　　　　if(action == "close"){
						$("#" + obj).val($("#openDesc").val());
　　　　　}
	　　　}
			});
		//}
	}
	
	//页面上的某组复选框全部选中或取消，在指定位置显示选中数量
	function setSel(chkName,cart){
		if(chkName == ""){chkName = "visitstockchk";}
		var chkother= document.getElementsByName(chkName);
		visitobj = selCount == 0 ? true : false;
		for (var i=0;i<chkother.length;i++)
			chkother[i].checked = visitobj; 
		visitobj = visitobj == true ? false : true;
		getSelCart(chkName,cart);
	}
	
	//页面上的某组复选框全部选中或取消，在指定位置显示选中数量
	function setSel1(chkName,cart){
		if(chkName == ""){chkName = "visitstockchk";}
		var chkother= document.getElementsByName(chkName);
		visitobj = selCount1 == 0 ? true : false;
		for (var i=0;i<chkother.length;i++)
			chkother[i].checked = visitobj; 
		visitobj = visitobj == true ? false : true;
		getSelCart1(chkName,cart);
	}
	
	function getSelCart(chkName,cart)
	{
		if(chkName == ""){chkName = "visitstockchk";}
		var count = 0;
		var strSQL = "";
		selList = "";
		selCount = 0;
		arr = [];
		var chkother = document.getElementsByName(chkName); 
		for (var i = 0;i < chkother.length;i++)
		{
		  if(chkother[i].checked == true){
		    count++;
				//strSQL += "," + chkother[i].value;
				arr.push("," + chkother[i].value);
			}
		}
		if(count>0)
		{
			//selList = strSQL.substr(1);
			selList = arr.join("").substr(1);
			selCount = count;
		}else{
			if(cart==""){
					jAlert("您还没有选中任何项目。");
			}
		}
		if(cart>""){
			setCartNum(cart);
		}
		arr = [];
	}
	
	function getSelCart1(chkName,cart)
	{
		if(chkName == ""){chkName = "visitstockchk";}
		var count = 0;
		var strSQL = "";
		selList1 = "";
		selCount1 = 0;
		arr = [];
		var chkother = document.getElementsByName(chkName); 
		for (var i = 0;i < chkother.length;i++)
		{
		  if(chkother[i].checked == true){
		    count++;
				//strSQL += "," + chkother[i].value;
				arr.push("," + chkother[i].value);
			}
		}
		if(count>0)
		{
			//selList = strSQL.substr(1);
			selList1 = arr.join("").substr(1);
			selCount1 = count;
		}else{
			if(cart==""){
					jAlert("您还没有选中任何项目。");
			}
		}
		arr = [];
	}
	
	function add2Cart(chkName,cart,memo)
	{
		if(chkName == ""){chkName = "visitstockchk";}
		var count = 0;
		var strSQL = "";
		selList = "";
		selCount = 0;
		arr = [];
		var chkother = document.getElementsByName(chkName); 
		for (var i = 0;i < chkother.length;i++)
		{
		  if(chkother[i].checked == true){
		    count++;
				//strSQL += "," + chkother[i].value;
				arr.push("," + chkother[i].value);
			}
		}
		if(count>0)
		{
			//selList = strSQL.substr(1);
			selList = arr.join("").substr(1);
			//$.get("cartControl.asp?op=add2cart&kindID=" + cart + "&item=" + escape(selList) + "&memo=" + escape(memo) + "&times=" + (new Date().getTime()),function(re){
			$.post("cartControl.asp?op=add2cart", {"kindID":cart, "item":selList,"memo":memo},function(re){
				setCartNum(cart);
				jAlert("添加成功。");
			});
		}else{
			jAlert("您还没有选中任何数据。");
		}
		arr = [];
	}

	//清空购物车
	function emptyCart(chkName,cart){
		var chkother = document.getElementsByName(chkName); 
		for (var i = 0;i < chkother.length;i++)
		{
		  if(chkother[i].checked == true){
		    chkother[i].checked = false;
			}
		}
		selList = "";
		selCount = 0;
		if(cart>""){
			setCartNum(cart);
		}
	}

	//为购物车设置显示数量
	function setCartNum(cart){
		$.get("cartControl.asp?op=getCartCount&kindID=" + cart + "&times=" + (new Date().getTime()),function(re){
			if(cart>""){
				$("#cart_" + cart).html(re);
				$("#cart_" + cart).css({'padding-right': '3px', 'font-size': '16px', 'color':'red'});
			}
		});
	}
	
	//nodeID: ID; refID: project ID; op: 0 浏览 1 新增  2 编辑  3 删除  4 审批; mark: 0 不动作  1 有修改时刷新列表  2 有修改时刷新对象
	function showCartInfo(nodeID,refID,op,mark){
		asyncbox.open({
			id: "cart",
			url:"cartInfo.asp?nodeID=" + nodeID + "&refID=" + refID + "&op=" + op + "&p=1&times=" + (new Date().getTime()),
			title: "购物车信息",
			width: 800,
			height: 800,
			cover : {
	          //透明度
	          opacity : 0,
	          //背景颜色
	           background : '#000'
	          },

			btnsbar : false,
			callback : function(action,iframe){
				//setReturnLog("docResult",iframe.nodeID);	//写回执（审批件）
				var re = iframe.updateCount;
				if(re>0 && mark==1){
					setCartNum(nodeID);
				}
				//alert(re + ":" + mark);
				if(re>0 && mark==2){
					//alert(iframe.getValList());
					setObjValue("cart",iframe.getValList(),0,0);  //根据请求，返回任意个数的项目，为相应的对象赋值。objList:传入的Object列表；valList：输出的值；mark：0 不动作 1 关闭本窗口（与objList同名）; loc: 0 同级别  1 父窗体
				}
　　　		}
		});
	}

	function gotoPage(url,item,model){
		if(model=="div"){
			//$("#modalDiv").load(url+"?pageItem=" + item);
			var tmp=window.open("about:blank","","fullscreen=1,toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0");
			tmp.moveTo(100,100);
			tmp.resizeTo(600,400);
			tmp.focus();
			tmp.location="modalDiv.asp?url=" + url +"&pageItem=" + item;
		}
		if(model=="window"){
			window.open(url+"?pageItem=" + item,"_self");
		}
	}

	//清除指定对象内容
	function closeObj(obj){
		$("#" + obj).empty();
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
	
	function turnID15218(strID){
		var result = strID;
		if(strID.length==15){		//转换15位身份证
			$.get("commonControl.asp?op=turnID15218&nodeID=" + escape(strID) + "&times=" + (new Date().getTime()),function(re){
				result = re;
			});
		}
		return result;
	}
	
/*
1."验证通过!", 
2."身份证号码位数不对!", 
3."身份证号码出生日期超出范围或含有非法字符!", 
4."身份证号码校验错误!", 
5."身份证地区非法!" 
*/
	function checkIDcard(strID){
		var result = 0;
		$.get("commonControl.asp?op=checkIDcard&nodeID=" + escape(strID) + "&times=" + (new Date().getTime()),function(re){
			result = re;
		});

		return result;
	}
	
	function getWorkDateAfter(d,idate){
		var result = 0;
		$.get("commonControl.asp?op=getWorkDateAfter&refID=" + d + "&keyID=" + idate + "&times=" + (new Date().getTime()),function(re){
			result = unescape(re);
		});

		return result;
	}
	
	//检查所给对象值是否合法数字，如果不是则清零，并提示
	function checkNum(objID){
		if(isNaN($("#" + objID).val())){
			jAlert("非法数字，请核实。");
			$("#" + objID).val(0);
			$("#" + objID).focus();
			return false;
		}
	}

//验证字符串是否是非零正整数
function checkNumber(theObj) {
	var reg = /^[1-9][0-9]*$/;
	if (reg.test(theObj)) {
		return true;
	}else{
		return false;
	}
  }

Date.prototype.format = function(format) //author: meizz 
{ 
	//alert(new Date().format("yyyy-MM-dd"));
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
 
//判断日期是否合法 
/*
本方法能够有效的验证闰年，支持的日期格式有：2009-01-01、2009/01/01两种格式。
use case:
	if(isDate("2010-02-03")){
		alert("非法日期!");
	} 
*/
function isDate(strDate) { 
	var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$"); 
	if (!regex.test(strDate)) { 
		return false; 
	}else{
		return true;
	}
}

//判断文本框中的日期是否合法 
/*
本方法能够有效的验证闰年，支持的日期格式有：2009-01-01、2009/01/01两种格式。
use case:
<input type="text" id="sDate" /> 
$("#sDate").blur(function() {IsDate($(this)[0]);}) 
*/
function IsDateOfTextBox(oTextbox) { 
	var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$"); 
	var dateValue = oTextbox.value; 
	if (!regex.test(dateValue)) { 
		alert("日期有误！"); 
		dateValue = ""; 
		this.focus(); 
		return; 
	} 
}

//两个日期的差值(d1 - d2).
function dateDiff(d1,d2){
  var day = 24 * 60 * 60 *1000;
	try{    
	   var dateArr = d1.split("-");
	   var checkDate = new Date();
	        checkDate.setFullYear(dateArr[0], dateArr[1]-1, dateArr[2]);
	   var checkTime = checkDate.getTime();
	  
	   var dateArr2 = d2.split("-");
	   var checkDate2 = new Date();
	        checkDate2.setFullYear(dateArr2[0], dateArr2[1]-1, dateArr2[2]);
	   var checkTime2 = checkDate2.getTime();
	    
	   var cha = (checkTime - checkTime2)/day;  
	        return cha;
	}catch(e){
	   return false;
	}
}//end fun

//日期加上天数后的新日期.
function addDays(date,days){
	var nd = new Date(date);
  nd = nd.valueOf();
  nd = nd + days * 24 * 60 * 60 * 1000;
  nd = new Date(nd);
  //alert(nd.getFullYear() + "年" + (nd.getMonth() + 1) + "月" + nd.getDate() + "日");
	var y = nd.getFullYear();
	var m = nd.getMonth()+1;
	var d = nd.getDate();
	if(m <= 9) m = "0"+m;
	if(d <= 9) d = "0"+d; 
	var cdate = y+"-"+m+"-"+d;
	return cdate;
}

//获得某月的最后一天,输入日期格式为"2013-04-23"
function getLastDay(theDate) { 
	 //取年
	 var ar = new Array();
	 ar = theDate.split("-");
	 var new_year = ar[0];
	 //取到下一个月的第一天,注意这里传入的month是从1～12 
	 var new_month = ar[1];
	 //如果当前是12月，则转至下一年
	 var new_date = new Date(new_year,new_month,0);
	 return new_year + "-" + new_month + "-" + new_date.getDate();
}

//myDate.dateAdd("d",5)
Date.prototype.dateAdd = function (strInterval, number) {
    //y年 q季度 m月 d日 w周 h小时 n分钟 s秒 ms毫秒
    var dtTmp = this;
    switch (strInterval) {
    case 's': return new Date(Date.parse(dtTmp) + (1000 * number));
    case 'n': return new Date(Date.parse(dtTmp) + (60000 * number));
    case 'h': return new Date(Date.parse(dtTmp) + (3600000 * number));
    case 'd': return new Date(Date.parse(dtTmp) + (86400000 * number));
    case 'w': return new Date(Date.parse(dtTmp) + ((86400000 * 7) * number));
    case 'q': return new Date(dtTmp.getFullYear(), (dtTmp.getMonth()) + number * 3, dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
    case 'm': return new Date(dtTmp.getFullYear(), (dtTmp.getMonth()) + number, dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
    case 'y': return new Date((dtTmp.getFullYear() + number), dtTmp.getMonth(), dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
    }
}

//要求字符串必须包含数字和字母
function isAlphaDigit(str){
  var reg=new RegExp(/[A-Za-z].*[0-9]|[0-9].*[A-Za-z]/);
  if(reg.test(str)){
  	return true;
  }else{
  	return false;
  }
}

//检查字符串是否只包含特定内容
//type: 0 数字  1 字母  2 数字和字母  3 数字字母和横线  4 数字字母和下划线  5 Email字符  6 数字和小数点
function check_str(type,pStr) 
{ 
	var v_test= "";
	if(type==0){
		v_test= "0123456789";
	}
	if(type==1){
		v_test= "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
	}
	if(type==2){
		v_test= "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	}
	if(type==3){
		v_test= "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-";
	}
	if(type==4){
		v_test= "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";
	}
	if(type==5){
		v_test= "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-.@";
	}
	if(type==6){
		v_test= "0123456789.";
	}

	for(i=0;i <pStr.length;i++){
		if(v_test.indexOf(pStr.charAt(i))==-1){ 
			return false; 
		} 
	} 
	return true; 
} 

//全角转半角
function dbc2sbc(sStr){ 
	var dbc2sbc = sStr; 
	for (var i = 65281; i < 65375; i++) { 
		var re = new RegExp(String.fromCharCode(i), "g"); 
		var va = String.fromCharCode(i - 65248); 
		dbc2sbc = dbc2sbc.replace(re, va); 
	} 
	dbc2sbc = dbc2sbc.replace(/　/g, ' '); 
	return dbc2sbc; 
}

/*
===========================================
//得到左边的字符串
===========================================
*/
String.prototype.Left = function(len)
{

        if(isNaN(len)||len==null)
        {
                len = this.length;
        }
        else
        {
                if(parseInt(len)<0||parseInt(len)>this.length)
                {
                        len = this.length;
                }
        }
       
        return this.substr(0,len);
}


/*
===========================================
//得到右边的字符串
===========================================
*/
String.prototype.Right = function(len)
{

        if(isNaN(len)||len==null)
        {
                len = this.length;
        }
        else
        {
                if(parseInt(len)<0||parseInt(len)>this.length)
                {
                        len = this.length;
                }
        }
       
        return this.substring(this.length-len,this.length);
}

//首字母大写
function initialCapital(str){ 
	var reg = /\b(\w)|\s(\w)/g; 
	str = str.toLowerCase(); 
	return str.replace(reg,function(m){return m.toUpperCase()}) 
}

/** 数字金额大写转换(可以处理整数,小数,负数) */ 
function num2chinese(n)  
{ 
    var fraction = ['角', '分']; 
    var digit = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖']; 
    var unit = [ ['元', '万', '亿'], ['', '拾', '佰', '仟']  ]; 
    var head = n < 0? '欠': ''; 
    n = Math.abs(n); 
   
    var s = ''; 
   
    for (var i = 0; i < fraction.length; i++)  
    { 
        s += (digit[Math.floor(n * 10 * Math.pow(10, i)) % 10] + fraction[i]).replace(/零./, ''); 
    } 
    s = s || '整'; 
    n = Math.floor(n); 
   
    for (var i = 0; i < unit[0].length && n > 0; i++)  
    { 
        var p = ''; 
        for (var j = 0; j < unit[1].length && n > 0; j++)  
        { 
            p = digit[n % 10] + unit[1][j] + p; 
            n = Math.floor(n / 10); 
        } 
        s = p.replace(/(零.)*零$/, '').replace(/^$/, '零')  + unit[0][i] + s; 
    } 
    return head + s.replace(/(零.)*零元/, '元').replace(/(零.)+/g, '零').replace(/^整$/, '零元整'); 
}

//等比压缩图片工具 -- by xqs
//调用
//var imgArr = $(".newsMsg dt").find("img");
//proDownImage(imgArr); 
var proDownImage = function(imgObj){
	imgObj = (typeof imgObj == "string") ? $(imgObj) : imgObj;
	$.each(imgObj,function(){
		var img = $(this);
		var setSize = {};
		var obj = {
			width : img.parent().width(),
			height : img.parent().height()   //外容器宽高
		};
		var image = new Image();
		image.src = img.attr("src");    //图片路径
		image.onload = function() { // 当加载状态改变时执行此方法,因为img的加载有延迟
			if (image.complete == true) { // 当加载状态为完全结束时进入
				if (image.width > 0 && image.height > 0) {
					var ww = obj.width / image.width;
					var hh = obj.height / image.height;
					var rate = (ww > hh) ? ww: hh;
					if (rate <= 1) {
						setSize.width = image.width * rate;
						setSize.height = image.height * rate;
					} else {
						setSize.width = image.width;
						setSize.height = image.height;
					}
				}
				//设置样式
				img.attr({"width":setSize.width,"height":setSize.height});
				//居中显示
				img.css({'margin-left':(-(setSize.width - obj.width) / 2)+'px'});
				img.css({'margin-top':(-(setSize.height - obj.height) / 2)+'px'});
			}
		};
	});
};