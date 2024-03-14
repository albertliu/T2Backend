<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<!--#include file="Inc/upload_wj.inc"-->
<!--#include file="Connections/labour.asp" -->
<%
dim groupID,operaType,kindID,filePath,docItem
Dim rsRpt,rsRpt1,rsRpt001,rptItem,rsRptSum001
Dim rsRpt_numRows
dim rsTemp,Sql,whereMark,tblMark,force
dim sourceHome
  
groupID = 1
operaType = ""
kindID = "1"
force = 0
sourceHome = "reports\loadData\"

operaType = Request("type")

if Request("groupID")>"" and isNull(Request("groupID"))=false then
	groupID = Request("groupID")
end if

force = Request("force")
filePath = Request("filePath")
whereMark = replace(Request("whereMark"),"!~","%")
docItem = Request("docItem")
tblMark = replace(Request("tblMark"),"!~","%")

Set rsTemp = Server.CreateObject("ADODB.Recordset")
rsTemp.ActiveConnection = MM_labour_STRING
rsTemp.CursorType = 0
rsTemp.CursorLocation = 2
rsTemp.LockType = 1

Set rsRpt = Server.CreateObject("ADODB.Recordset")
rsRpt.ActiveConnection = MM_labour_STRING
'rsRpt.Source = "SELECT * FROM dbo.inputDataRpt_001"
'rsRpt.Open()
rsRpt.CursorType = 0
rsRpt.CursorLocation = 2
rsRpt.LockType = 1

Set rptItem = Server.CreateObject("ADODB.Recordset")
rptItem.ActiveConnection = MM_labour_STRING
rptItem.Source = "SELECT * FROM dbo.v_rptItemList WHERE ID = " & groupID
rptItem.CursorType = 0
rptItem.CursorLocation = 2
rptItem.LockType = 1
rptItem.Open()
kindID = rptItem("kindID")

function ifDateNull(mDate)
	if isnull(mDate) or mDate="" or mid(mDate,1,4)>"2100" or mid(mDate,1,4)<"1800" then
		ifDateNull = "null"
	else
		ifDateNull = "'" & mDate & "'"
	end if
end function

Dim   Conn,Driver,DBPath,Rs
  '   建立Connection对象   
  Set   Conn   =   Server.CreateObject("ADODB.Connection")   
  Driver   =   "Driver={Microsoft Excel Driver (*.xls)};"  
  
if operaType = "upload" then
	dim upload, file, formName, path, titles, i, title, re
	
	set upload = new upload_file
	
	Set re = New RegExp
	re.Pattern = "[\\/:*?""<>|]"
	re.Global = True
	
	i = 0
	
	for each formName in upload.file
		set file = upload.file(formName)
		if file.FileSize>0 then
	
			'title = file.FileName
			title = "sourceRpt" & groupID & ".xls"
			path = sourceHome & title
			file.SaveToFile Server.mappath(path)
			
			i = i + 1
		end if
		set file = nothing
	next
	
	set upload = nothing
	response.write(path)
end if
  
if operaType = "emptyData" then
	delRptData()  '清空报表数据
	setSubStatus(0)
end if
if operaType = "loadData" then
	dim result
	result = inputRptData()  '导入新的报表数据
	setSubStatus(1)
	response.write(filePath)
	'Response.Write(result)
end if
if operaType = "delData" then
	delRptData()  '删除报表数据
end if
if operaType = "disData" then
	Sql = "update inputDataRpt_001 set dealStatus = 0,dealDate=null,changeMark=dbo.getRpt1ChangeItem(techID,jobID,salaryID,education) where groupID=" & groupID   
	rsTemp.Source = Sql
	rsTemp.Open()    '将数据状态设置为可编辑状态
	setSubStatus(2)  '分发报表数据
end if
if operaType = "calData" then
	if(force=0) then
		Sql = "select count(*) as count from inputDataRpt_001 where dealStatus<1 and groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    '检查是否有未完成的数据
		if(rsTemp("count")>0) then
			'报警并终止统计
			Response.Write(rsTemp("count"))
		else
			force = 1
		end if
	end if
	if(force=1) then
		'继续统计
		Sql = "delete from proDataRpt_001 where groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    '删除旧的统计数据
		Sql = "delete from tempDataRpt_001 where groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    '删除旧的统计数据
		Sql = "insert into proDataRpt_001(ID,groupID,cardID,jobRegDate) select ID," & groupID & ",cardID,jobRegDate from inputDataRpt_001 where (effectCount = 1) AND jobRegDate between '" & rptItem("Date0") & "' AND '" & rptItem("Date1") & "'"
		rsTemp.Source = Sql
		rsTemp.Open()    '将就业数据导入
		Sql = "insert into tempDataRpt_001(ID,groupID,cardID,jobQuitDate) select ID," & groupID & ",cardID,jobQuitDate from inputDataRpt_001 where (effectCount = -1) AND jobQuitDate between '" & rptItem("Date0") & "' AND '" & rptItem("Date1") & "' and cardID in(select cardID from proDataRpt_001 where groupID=" & groupID & ")"
		rsTemp.Source = Sql
		rsTemp.Open()    '将退工数据导入
		Sql = "update proDataRpt_001 set mark=1 from proDataRpt_001 a, tempDataRpt_001 b where a.cardID=b.cardID and a.groupID=b.groupID and a.jobRegDate<b.jobQuitDate and a.groupID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    '标记有退工记录的就业数据
		Sql = "delete from proDataRpt_001 where mark=1 and groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    '删除无效的就业数据（在本统计期间先就业后退工）
		Sql = "delete from tempDataRpt_001 where groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    '删除旧的统计数据
		
		Sql = "delete from rptLastData_001 where groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    '删除旧的统计数据
		Sql = "insert into rptLastData_001(groupID,f0,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,f21,f22,f23,f24,f25,f26,f27,f28,f29,f30,f31,f32,f33,f34,f35) select groupID,f0,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,f21,f22,f23,f24,f25,f26,f27,f28,f29,f30,f31,f32,f33,f34,f35 from v_rptGen_001 where groupID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    '插入统计数据
		Sql = "insert into rptLastData_001(groupID,f0) select " & groupID & ",jd from rpt001_jdList where jd not in (select f0 from rptLastData_001 where groupID=" & groupID & ")"   
		rsTemp.Source = Sql
		rsTemp.Open()    '补充空值的乡镇
		Sql = "update rptLastData_001 set indexID=b.ID from rptLastData_001 a,rpt001_jdList b where a.f0=b.jd and a.groupID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    '为乡镇确定顺序
		Sql = "update rptItemList set status=0,editorID=null,editDate=null,checkerID=null,checkDate=null,deployerID=null,deployDate=null where ID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    '将报表状态置为初始值
		Sql = "delete from docAppendixList where docID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    '将报表的附件删除
		setSubStatus(3)  '统计报表数据
		'Response.Write("OK")
	end if
end if
if operaType = "closeData" then
	setSubStatus(4)  '关闭报表数据
end if
if operaType = "addRpt" then
	addRptItem()  '添加新的报表项目
end if
if operaType = "delRpt" then
	delRptItem()  '删除报表项目
end if

   if operaType = "analyseQx" then
	  Sql = "update inputDataRpt_001 set jw=left(jw,len(jw)-1) where jw like '%居委会' and groupID=" & groupID 
	  rsTemp.Source = Sql
	  rsTemp.Open()   '将居委会名称规范处理
	  Sql = "update inputDataRpt_001 set jw=b.itemSys from inputDataRpt_001 a,rptDataItemCompare b where a.jw=b.itemOut and b.kind='jw' and a.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '将居委会名称规范处理
	  Sql = "update inputDataRpt_001 set jd=b.itemSys from inputDataRpt_001 a,rptDataItemCompare b where a.jd=b.itemOut and b.kind='jd' and a.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '将街道名称规范处理
	  Sql = "update inputDataRpt_001 set education=dbo.transEducation2Rpt1(b.文化程度),qx=b.管理权限,jd=b.户口街道,jw=b.户口居委会,noJobFamily=(case 零就业 when '是' then 1 else 0 end),jobHard=(case b.双困 when '是' then 1 else 0 end),newGrade=(case when convert(integer,getdate(),23)-convert(integer,b.gradeDate,23)<180 then 1 else 0 end),flag=b.flag from inputDataRpt_001 a,dbf_main b where a.cardID=b.身份证号码 and a.groupID=" & groupID   
	  rsTemp.Source = Sql
	  rsTemp.Open()   '按照系统内已有信息填充一些项目，以身份证为条件匹配
	  Sql = "update inputDataRpt_001 set newOne=1 where qx is null and groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '标记出系统内未注册的人员
	  Sql = "update inputDataRpt_001 set qx=b.qx from inputDataRpt_001 a,qx b where a.jw=b.jw and a.qx is null and a.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '对系统内没有注册的人员，按照居委会分配数据
	  Sql = "update inputDataRpt_001 set qx=b.qx from inputDataRpt_001 a,qx b where a.jd=b.jd and a.qx is null and b.jw is null and a.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '对于无法对应居委会的，按照街道分配数据
	  Sql = "update inputDataRpt_001 set effectCount=-1 where jobQuitDate is not null and groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '退工的有效数量为-1，就业的有效数量为1.
	  Sql = "delete from inputDataRpt_001 where groupID=" & groupID & " and flag<>'N'"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '将非有效的人员排除（迁出、死亡、退休）.
	Response.Write("analyseQx Over")
   end if
   if operaType = "analyseIsLand" then
	  Sql = "update inputDataRpt_001 set isLand=1 where groupID=" & groupID & " and charindex('嘉定',jobRegLocation)+charindex('卢湾',jobRegLocation)+charindex('徐汇',jobRegLocation)+charindex('黄浦',jobRegLocation)+charindex('静安',jobRegLocation)+charindex('奉贤',jobRegLocation)+charindex('松江',jobRegLocation)+charindex('宝山',jobRegLocation)+charindex('长宁',jobRegLocation)+charindex('浦东',jobRegLocation)+charindex('闵行',jobRegLocation)+charindex('杨浦',jobRegLocation)+charindex('虹口',jobRegLocation)+charindex('金山',jobRegLocation)+charindex('闸北',jobRegLocation)+charindex('普陀',jobRegLocation)+charindex('青浦',jobRegLocation)+charindex('市',jobRegLocation)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业登记地名称分析岛内岛外.所有包含其他区县名称和”市“名称的登记，均视为岛外。
	  Sql = "update inputDataRpt_001 set isLand=1 where groupID=" & groupID & " and isLand=0 and charindex('嘉定',unitName)+charindex('卢湾',unitName)+charindex('徐汇',unitName)+charindex('黄浦',unitName)+charindex('静安',unitName)+charindex('奉贤',unitName)+charindex('松江',unitName)+charindex('宝山',unitName)+charindex('长宁',unitName)+charindex('浦东',unitName)+charindex('闵行',unitName)+charindex('杨浦',unitName)+charindex('虹口',unitName)+charindex('金山',unitName)+charindex('闸北',unitName)+charindex('普陀',unitName)+charindex('青浦',unitName)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业单位名称分析岛内岛外..所有包含其他区县名称的单位，均视为岛外。
   end if
   if operaType = "analyseJob" then
	  Sql = "update inputDataRpt_001 set jobID=2 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('保安',jobKind)+charindex('保卫',jobKind)+charindex('安保',jobKind)+charindex('门卫',jobKind)+charindex('营业员',jobKind)+charindex('超市',jobKind)+charindex('厨工',jobKind)+charindex('保洁',jobKind)+charindex('勤杂',jobKind)+charindex('清洁',jobKind)+charindex('办事',jobKind)+charindex('文员',jobKind)+charindex('行政',jobKind)+charindex('秘',jobKind)+charindex('服务员',jobKind)+charindex('护士',jobKind)+charindex('贸',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛内对应的统计行业. 2 商业服务
	  Sql = "update inputDataRpt_001 set jobID=1 where groupID=" & groupID & " and isLand=0 and jobID=0 and (charindex('销售',jobKind)+charindex('业务',jobKind)+charindex('营销',jobKind)+charindex('采购',jobKind)+charindex('推销',jobKind)+charindex('生产',jobKind)+charindex('辅助',jobKind)+charindex('操作',jobKind)+charindex('会计',jobKind)+charindex('财务',jobKind)+charindex('统计',jobKind)+charindex('出纳',jobKind)>0 or jobKind like '%工')"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛内对应的统计行业. 1 工业企业
	  Sql = "update inputDataRpt_001 set jobID=3 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('导游',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛内对应的统计行业. 3 旅游服务
	  Sql = "update inputDataRpt_001 set jobID=4 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('种植',jobKind)+charindex('养殖',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛内对应的统计行业. 4 农业企业
	  Sql = "update inputDataRpt_001 set jobID=5 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('出租',jobKind)+charindex('驾驶员',jobKind)+charindex('公交',jobKind)+charindex('汽车',jobKind)+charindex('列车',jobKind)+charindex('运输',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛内对应的统计行业. 5 交通运输
	  Sql = "update inputDataRpt_001 set jobID=6 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('体力',jobKind)+charindex('工程',jobKind)+charindex('施工',jobKind)+charindex('建筑',jobKind)+charindex('架子',jobKind)+charindex('装饰',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛内对应的统计行业. 6 建筑业
	  Sql = "update inputDataRpt_001 set jobID=9 where groupID=" & groupID & " and isLand=0 and jobID=0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛内对应的统计行业. 9 其他
	  Sql = "update inputDataRpt_001 set jobID=11 where groupID=" & groupID & " and isLand=1 and jobID=0 and charindex('出租',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛外对应的统计行业. 11 出租车
	  Sql = "update inputDataRpt_001 set jobID=15 where groupID=" & groupID & " and isLand=1 and jobID=0 and charindex('驾驶员',jobKind)+charindex('公交',jobKind)+charindex('汽车',jobKind)+charindex('列车',jobKind)+charindex('运输',jobKind)+charindex('体力',jobKind)+charindex('工程',jobKind)+charindex('施工',jobKind)+charindex('建筑',jobKind)+charindex('架子',jobKind)+charindex('装饰',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛外对应的统计行业. 15 建筑 交通运输
	  Sql = "update inputDataRpt_001 set jobID=12 where groupID=" & groupID & " and isLand=1 and jobID=0 and charindex('保安',jobKind)+charindex('保卫',jobKind)+charindex('安保',jobKind)+charindex('门卫',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛外对应的统计行业. 12 家政保安
	  Sql = "update inputDataRpt_001 set jobID=13 where groupID=" & groupID & " and isLand=1 and jobID=0 and (charindex('销售',jobKind)+charindex('业务',jobKind)+charindex('营销',jobKind)+charindex('采购',jobKind)+charindex('推销',jobKind)+charindex('生产',jobKind)+charindex('辅助',jobKind)+charindex('操作',jobKind)+charindex('会计',jobKind)+charindex('财务',jobKind)+charindex('统计',jobKind)+charindex('出纳',jobKind)+charindex('办事',jobKind)+charindex('文员',jobKind)+charindex('行政',jobKind)+charindex('秘',jobKind)+charindex('计算机',jobKind)+charindex('技术',jobKind)+charindex('工程师',jobKind)+charindex('技师',jobKind)>0 or jobKind like '%工')"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛外对应的统计行业. 13 工业企业
	  Sql = "update inputDataRpt_001 set jobID=14 where groupID=" & groupID & " and isLand=1 and jobID=0 and charindex('营业员',jobKind)+charindex('超市',jobKind)+charindex('厨工',jobKind)+charindex('保洁',jobKind)+charindex('勤杂',jobKind)+charindex('清洁',jobKind)+charindex('服务员',jobKind)+charindex('护士',jobKind)+charindex('贸',jobKind)+charindex('导游',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛外对应的统计行业. 14 商贸服务
	  Sql = "update inputDataRpt_001 set jobID=17 where groupID=" & groupID & " and isLand=1 and jobID=0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '根据就业岗位分析岛外对应的统计行业. 17 其他
   end if
   if operaType = "analyseTech" then
   	'根据就业岗位分析技能水平
	  Sql = "update inputDataRpt_001 set techID=3 where groupID=" & groupID & " and techID=0 and charindex('会计',jobKind)+charindex('财务',jobKind)+charindex('统计',jobKind)+charindex('出纳',jobKind)+charindex('计算机',jobKind)+charindex('技术',jobKind)+charindex('师',jobKind)+charindex('经理',jobKind)+charindex('保育',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update inputDataRpt_001 set techID=2 where groupID=" & groupID & " and techID=0 and charindex('销售',jobKind)+charindex('业务',jobKind)+charindex('营销',jobKind)+charindex('采购',jobKind)+charindex('推销',jobKind)+charindex('办事',jobKind)+charindex('文员',jobKind)+charindex('行政',jobKind)+charindex('秘',jobKind)+charindex('养殖',jobKind)+charindex('种植',jobKind)+charindex('公交',jobKind)+charindex('汽车',jobKind)+charindex('列车',jobKind)+charindex('导游',jobKind)+charindex('贸易',jobKind)+charindex('外贸',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update inputDataRpt_001 set techID=1 where groupID=" & groupID & " and techID=0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   	
   	'根据学历分析技能水平
	  Sql = "update inputDataRpt_001 set techID=2 where groupID=" & groupID & " and techID=1 and education=3"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   end if
   if operaType = "analyseSalary" then
   	'根据就业岗位分析工资水平
	  Sql = "update inputDataRpt_001 set salaryID=3 where groupID=" & groupID & " and salaryID=0 and charindex('出租',jobKind)+charindex('财务',jobKind)+charindex('统计',jobKind)+charindex('计算机',jobKind)+charindex('技术',jobKind)+charindex('师',jobKind)+charindex('经理',jobKind)+charindex('保育',jobKind)+charindex('导游',jobKind)+charindex('贸易',jobKind)+charindex('外贸',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update inputDataRpt_001 set salaryID=2 where groupID=" & groupID & " and salaryID=0 and (charindex('销售',jobKind)+charindex('业务',jobKind)+charindex('营销',jobKind)+charindex('采购',jobKind)+charindex('推销',jobKind)+charindex('办事',jobKind)+charindex('文员',jobKind)+charindex('行政',jobKind)+charindex('秘',jobKind)+charindex('生产',jobKind)+charindex('辅助',jobKind)+charindex('操作',jobKind)+charindex('会计',jobKind)+charindex('出纳',jobKind)+charindex('公交',jobKind)+charindex('汽车',jobKind)+charindex('列车',jobKind)+charindex('运输',jobKind)>0 or jobKind like '%工')"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update inputDataRpt_001 set salaryID=1 where groupID=" & groupID & " and salaryID=0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   	
   	'根据学历分析工资水平
	  Sql = "update inputDataRpt_001 set salaryID=2 where groupID=" & groupID & " and salaryID=1 and education=3"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   end if
   if operaType = "analyseEducation" then
   	'根据工资水平对系统内未注册的人员进行学历估计。
	  Sql = "update inputDataRpt_001 set education=salaryID where groupID=" & groupID & " and education=0 and newOne=1"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   end if
   if operaType = "updateJobStatus" then
   	'由导入的就业数据，更新系统内对应人员的就业状态。
	  Sql = "update inputDataRpt_001 set jobStatus='农村富余' where groupID=" & groupID & " and jobStatus='农村就业'"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update dbf_main set 人员类别=b.jobStatus from dbf_main a,inputDataRpt_001 b where b.cardID=a.身份证号码 and b.effectCount=-1 and b.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '失业 无业 农村富余 养老
	  Sql = "update dbf_main set 人员类别=b.jobStatus from dbf_main a,inputDataRpt_001 b where b.cardID=a.身份证号码 and b.effectCount=1 and b.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '就业
   end if

if operaType = "createExcel" then
	Set rsRpt001 = Server.CreateObject("ADODB.Recordset")
	rsRpt001.ActiveConnection = MM_labour_STRING
	rsRpt001.Source = "SELECT * FROM dbo.rptLastData_00" & rptItem("kindID") & " WHERE groupID = " & groupID & " order by indexID"
	rsRpt001.CursorType = 0
	rsRpt001.CursorLocation = 2
	rsRpt001.LockType = 1
	rsRpt001.Open()
	
	Set rsRptSum001 = Server.CreateObject("ADODB.Recordset")
	rsRptSum001.ActiveConnection = MM_labour_STRING
	rsRptSum001.Source = "SELECT * FROM dbo.v_rptLastDataSum_00" & rptItem("kindID") & " WHERE groupID = " & groupID
	rsRptSum001.CursorType = 0
	rsRptSum001.CursorLocation = 2
	rsRptSum001.LockType = 1
	rsRptSum001.Open()
	
	dim f1,f2,newFileName
	newFileName = "rptExcel" & rptItem("kindID") & "_" & groupID & ".xls"
	f1=Server.MapPath("reports\Template\Excel\rpt" & rptItem("kindID") & ".xls")
	f2=Server.MapPath("reports\excel\" & newFileName)
	Set fso = CreateObject("Scripting.FileSystemObject")
	fso.CopyFile f1,f2
	
	if fillExcel(f2) then
		'Response.write("OK")
		Sql = "delete from docAppendixList where docID=" & groupID & " and type='rpt'"
		rsTemp.Source = Sql
		rsTemp.Open()   
		Sql = "insert into docAppendixList(docID,type,url,fileType,uploaderID,memo) values(" & groupID & ",'rpt','" & "reports\excel\" & newFileName & "','xls','" & Session("user_key") & "','登记就业统计')"
		rsTemp.Source = Sql
		rsTemp.Open()   
	end if

	rsRpt001.Close()
	Set rsRpt001 = Nothing
	rsRptSum001.Close()
	Set rsRptSum001 = Nothing
end if

if operaType = "createUserTempExcel" then
	dim f3,f4
	f3=Server.MapPath("reports\Template\Excel\blank.xls")
	f4=Server.MapPath(filePath)
	Set fso = CreateObject("Scripting.FileSystemObject")
	fso.CopyFile f3,f4

	response.write(createUserTempExcel(f4))
	'response.write(whereMark)
end if

function createUserTempExcel(fd)
    Dim oConn,result,i,m,c,k
	c = 0 '数据列数
	k = 0 '序号

    Set oConn = Server.CreateObject("ADODB.Connection")
    oConn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & fd & ";Extended Properties=""Excel 8.0;HDR=NO;"""
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.Open "Select  *  From [sheet1$]", oConn, 2, 2

	Set rsTemp = Server.CreateObject("ADODB.Recordset")
	rsTemp.ActiveConnection = MM_labour_STRING
	rsTemp.Source = tblMark & whereMark
	rsTemp.CursorType = 0
	rsTemp.CursorLocation = 2
	rsTemp.LockType = 1
	rsTemp.Open()
	
	if rsTemp.Eof = false then
		c = rsTemp.fields.count

		rs.Fields(0).Value = docItem	'第1行标题
		rs.movenext
		rs.Fields(0).Value = "统计时间:  " & now()
		rs.Fields(4).Value = "统计人:  " & session("name_key")
		rs.movenext			'第2行
		rs.movenext			'第3行空
		    
		rs.fields(0).Value = "序号"
	    for i = 1 to c
	    	rs.fields(i).Value = rsTemp.fields(i-1).Name
		next
	    rs.movenext			'第5行  表头
		
		do while not rsTemp.eof
			k = k + 1
			for i = 1 to c
				rs.Fields(0).Value = k
				rs.Fields(i).Value = rsTemp.Fields(i-1).Value
			next
			rsTemp.movenext
			rs.movenext
		loop
	end if
    createUserTempExcel = k
    rs.Close
	oConn.Close
    Set oConn = Nothing
end function

function inputRptData() 
  dim result
  Dim Conn1,Driver,DBPath,Rs
  DBPath   =   "DBQ=" & Server.MapPath(filePath)   
  Driver = "Driver={Microsoft Excel Driver (*.xls)}; ReadOnly=1; "
  Set Conn1 = Server.CreateObject("ADODB.Connection")
  '调用Open   方法打开数据库   
  Conn1.Open   Driver & DBPath   
  'DSN连接方式   
  'Conn1.Open   "Dsn=test"   
  '注意   表名一定要以下边这种格试   "[表名$]"   书写   
  'Sql = "Select * From [ListView$];"  
  Sql = "Select * From [招工$];"   
  Set Rs = Conn1.Execute(Sql)   
  'Set   Rs   =   Server.CreateObject("ADODB.Recordset")     
  'Sql = "select * from [ListView]"   
  'Rs.Open Sql, Conn, 1, 1   
  
  IF   Rs.Eof   And   Rs.Bof   Then   
      Response.write   "没有找到您需要的数据!!"   
      result = 0
  Else   
	  Sql = "delete from inputDataRpt_001 where groupID=" & groupID & ";"   
	  rsTemp.Source = Sql
	  rsTemp.Open()   '删除以前可能存在的数据
      dim k
      Do While (Not Rs.EOF)
	  	if (len(Rs("证件号码")) > 14)  then
			Sql = "INSERT INTO inputDataRpt_001(groupID, indexID, name, sex, cardKind, cardID, unitName, jobType, jobKind, jobRegDate, jobQuitDate, jobRegLocation, jobRegister, jobStartDate, jobEndDate, jobStatus, docLocation, docLocationMemo, jd, jw, address,education,jobID,techID,salaryID,effectCount)"
			Sql = Sql & " values(" & groupID & ",'" & Rs("序号") & "','" & Rs("姓名") & "','" & Rs("性别") & "','" & Rs("证件类型") & "','" & Rs("证件号码") & "','" & Rs("单位名称") & "','" & Rs("就业类型") & "','" & Rs("职业工种") & "'," & ifDateNull(Rs("就业登记日期")) & "," & ifDateNull(Rs("退工登记日期")) & ",'" & Rs("就业登记所在地") & "','" & Rs("就业登记操作员工号") & "'," & ifDateNull(Rs("就业开始日期")) & "," & ifDateNull(Rs("工作结束日期")) & ",'" & Rs("就业状态") & "','" & Rs("档案所在地") & "','" & Rs("档案所在地备注") & "','" & Rs("户口所属街道") & "','" & Rs("居委会") & "','" & Rs("户口地址") & "',0,0,0,0,1)"
			rsRpt.Source = Sql
			rsRpt.Open()
    	end if
      Rs.MoveNext   
      Loop
      
	  Sql = "update inputDataRpt_001 set bailerID='" & Session("user_key") & "',bailDate=getDate(),age=(year(getdate())*10000+month(getdate())*100+day(getdate())-substring(cardID,7,8))/10000 where groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '标记委托人
	  result = 1
  End IF   
    
  Rs.Close   
  Set Rs=nothing   
  Conn1.Close   
  Set Conn1=Nothing
  inputRptData = result
end function
  
function delRptData() 
	'if (groupID > 0)  then
		Sql = "delete from inputDataRpt_001 where groupID = " & groupID
		rsTemp.Source = Sql
		rsTemp.Open()
    'end if
end function
  
function setSubStatus(id) 
	if (groupID > 0)  then
		Sql = "update rptItemList set subStatus=" & id & " where ID = " & groupID
		rsTemp.Source = Sql
		rsTemp.Open()
    end if
end function
  
function addRptItem() 
	if (kindID > "")  then
		Sql = "select * from rptKindList where kindID='" & kindID & "'"
		rsRpt.Source = Sql
		rsRpt.Open()
		Sql = "insert into rptItemList(kindID,item,inputDate,inputOperator) values('0001','" & rsRpt("sourceItem") & "' + '(20年月日 - 20年月日)',getDate(),'" & Session("user_key") & "')"
		rsRpt.Source = Sql
		rsRpt.Open()
    end if
end function
  
function delRptItem() 
	if (groupID > 0)  then
		Sql = "delete from rptItemList where ID = " & groupID
		rsRpt.Source = Sql
		rsRpt.Open()
    end if
end function

function copyFile(fs,fd)
	Set fso = CreateObject("Scripting.FileSystemObject")
	fso.CopyFile fs,fd
end function

function fillExcel(fd)        
    Dim oConn,result,i,j,m,c
	m = 28 '数据行数
	c = 0 '数据列数
	if kindID="1" then
		c = 36
	end if
	if kindID="2" then
		c = 37
	end if
    Set oConn = Server.CreateObject("ADODB.Connection")
    oConn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & fd & ";Extended Properties=""Excel 8.0;HDR=NO;"""
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.Open "Select  *  From [sheet1$]", oConn, 2, 2
	if rsRpt001.bof and rsRpt001.Eof then
		result = false
	else
		result = true
	    rs.Fields(0).Value = rptItem("kindName")	'第1行标题
	    rs.movenext
	    rs.Fields(31).Value = "截止:  " & Year(rptItem("endDate")) & "年" & Month(rptItem("endDate")) & "月"
	    rs.movenext			'第2行
	    rs.movenext			'第3行空
	    rs.movenext			'第4行空
	    rs.movenext			'第5行空  表头完
		m = m - 5
		do while not rsRpt001.eof
			for i = 0 to c
				if kindID="1" then
					rs.Fields(i).Value = rsRpt001("f" & i)
				end if
				
				if kindID="2" then
					if i<14 then
						rs.Fields(i).Value = rsRpt001("f" & i)
					end if
					if i=14 then
						rs.Fields(14).Value = rsRpt001("f37")
					end if
					if i>14 then
						rs.Fields(i).Value = rsRpt001("f" & i-1)
					end if
				end if
			next
			rsRpt001.movenext
			rs.movenext
			m = m - 1
		loop
		
		for j=1 to m - 1
			rs.movenext
		next
		for i = 1 to c-1     '汇总
				if kindID="1" then
					rs.Fields(i).Value = rsRptSum001("f" & i)
				end if
				
				if kindID="2" then
					if i<14 then
						rs.Fields(i).Value = rsRptSum001("f" & i)
					end if
					if i=14 then
						rs.Fields(14).Value = rsRptSum001("f37")
					end if
					if i>14 then
						rs.Fields(i).Value = rsRptSum001("f" & i-1)
					end if
				end if
		next
		rs.movenext
		rs.Fields(1).Value = rptItem("deployerName")     '发布人
		rs.Fields(6).Value = rptItem("deployDate")     '发布日期
		rs.Fields(11).Value = rptItem("kindID")   		 '报表类别
		rs.Fields(14).Value = rptItem("ID")    			 '报表编号
		rs.movenext
	end if
    rs.Close
	oConn.Close
    Set oConn = Nothing
	fillExcel = result
end function

'rsRpt.Close()
'Set rsRpt = Nothing
rptItem.Close()
Set rptItem = Nothing
%>