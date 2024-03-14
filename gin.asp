<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<script language="javascript" runat="server">
	var ar = new Array();
	for(i=0; i<Session("floatArray").length; i++){
		ar[i] = Session("floatArray")[i].replace(/,/g, '\/');
	}
</script>
<SCRIPT LANGUAGE="VBSCRIPT" RUNAT="SERVER">
	'fetch data from array in session
	'copy a excel file from special model file
	'write the data to the new excel file
	'return the new excel name to program which call this function
	'the session data had be saved with writeExcel.asp by other program before
	
  Dim sSourceXLS, sDestXLS, LocalArray, arr, user, floatKind, tempFile, i, j, floatTitle, floatItem, floatLog, floatSum, model
	'floatKind = request("floatKind")
	floatKind = Session("dk" & request("floatKind"))
	floatMark = Session("dk" & request("floatKind") & "_mark")
	if floatMark > "" then 
		floatKind = floatKind + floatMark
	end if
	model = request("floatModel")
	floatTitle = Session("dk" & request("floatKind") & "_title")
	if floatTitle = "" then 
		floatTitle = Session("floatTitle")
	end if
	floatItem = Session("floatItem")
	floatLog = Session("dk" & request("floatKind") & "_log")
	if floatLog = "" then 
		floatLog = Session("floatLog")
	end if
	floatSum = Session("floatSum")
	user = Session("user_key")

    LocalArray = ar.join("%%")
    LocalArray = split(LocalArray,"%%",-1,1)
    tempFile = "\temp\" & user & "_" & floatKind
    
	sSourceXLS = Server.MapPath(".") & "\output\output" & "_" & floatKind
	if floatKind = "getExamerList" then
		sSourceXLS = sSourceXLS  & ".xls"
		tempFile = tempFile & ".xls"
	else
		sSourceXLS = sSourceXLS  & ".xlsx"
		tempFile = tempFile & ".xlsx"
	end if
    sDestXLS = Server.MapPath(".") & tempFile
    
    
    'Copy the source workbook file (the "template") to the destination filename
    Dim fso
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    fso.GetFile(sSourceXLS).Copy sDestXLS
    Set fso = Nothing

    'Open the ADO connection to the Excel workbook
    Dim oConn
    Set oConn = Server.CreateObject("ADODB.Connection")
    'oConn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & sDestXLS & ";Extended Properties=""Excel 8.0;HDR=NO;"""
    oConn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & sDestXLS & ";Extended Properties=""Excel 12.0 Xml;HDR=NO;"""
        
    Set rs = Server.CreateObject("ADODB.Recordset")
	if floatKind = "getExamerList" then
    	rs.Open "Select  *  From [用户$]", oConn, 2, 2
	else
    	rs.Open "Select  *  From [sheet1$]", oConn, 2, 2
	end if
    
    i = 0
       
    if model = 0 then		'汇总行在表头
    	if floatTitle > "" then
		    rs(0)	= floatTitle
		    rs.movenext
    	else
		    rs.movenext			'第1行空
    	end if
    	if floatItem > "" then
		    rs(0)	= floatItem
		    rs.movenext
    	else
		    rs.movenext			'第2行空
    	end if
    	if floatLog > "" then
		    rs(0)	= floatLog
		    rs.movenext
    	else
		    rs.movenext			'第3行空
    	end if
    	if floatSum > "" then
		    rs(0)	= floatSum
		    rs.movenext
    	else
		    rs.movenext			'第4行空
    	end if
	    rs.movenext			'第5行空
	    rs.movenext			'第6行表头
	    '第7行开始为正式数据
	    
	    for i=0 to ubound(LocalArray)
		    arr = split(LocalArray(i),"|",-1,1)
		    j = 0
		    for j=0 to ubound(arr)
			    rs(j) = arr(j)
				next
		    rs.movenext
	    next
	    
	    do while rs(0)<6300
	    	i = rs(0)
		    for j=0 to ubound(arr)
			    rs(j) = ""
				next
	    	rs.movenext
			loop
		
			for j=0 to ubound(arr)
				rs(j) = ""
			next
		  rs.movenext
    end if
    
    if model = 1 then		'汇总行在末尾
    	model = 1
    	if floatTitle > "" then
		    rs(0)	= floatTitle
		    rs.movenext
    	else
		    rs.movenext			'第1行空
    	end if
	   	if floatItem > "" then
		    rs(0)	= floatItem
		    rs.movenext
    	else
		    rs.movenext			'第2行空
    	end if
    	if floatLog > "" then
		    rs(0)	= floatLog
		    rs.movenext
    	else
		    rs.movenext			'第3行空
    	end if
	    rs.movenext			'第4行空
	    rs.movenext			'第5行空
	    rs.movenext			'第6行表头
	    '第7行开始为正式数据
	    
	    for i=0 to ubound(LocalArray)
		    arr = split(LocalArray(i),"|",-1,1)
		    j = 0
		    for j=0 to ubound(arr)
			    rs(j) = arr(j)
				next
		    rs.movenext
	    next
	    
			for j=0 to ubound(arr)	'空一行
				rs(j) = ""
			next
		  rs.movenext
			for j=0 to ubound(arr)	'空一行
				rs(j) = ""
			next
		  rs.movenext
		  
	    rs(0)	= ""				
	    rs(1)	= floatSum				'写签收栏
			for j=2 to ubound(arr)	
				rs(j) = ""
			next
	    rs.movenext
	    
	    do while rs(0)<6300
	    	i = rs(0)
		    for j=0 to ubound(arr)
			    rs(j) = ""
				next
	    	rs.movenext
			loop
		
			for j=0 to ubound(arr)
				rs(j) = ""
			next
		  rs.movenext
    end if 
       
    if model = 2 then		'没有表头
	    rs.movenext			'第1行表头
	    '第2行开始为正式数据
	    
	    for i=0 to ubound(LocalArray)
		    arr = split(LocalArray(i),"|",-1,1)
		    j = 0
		    for j=0 to ubound(arr)
			    rs(j) = arr(j)
				next
		    rs.movenext
	    next
	    
	    do while rs(0)<6300
	    	i = rs(0)
		    for j=0 to ubound(arr)
			    rs(j) = ""
				next
	    	rs.movenext
			loop
		
			for j=0 to ubound(arr)
				rs(j) = ""
			next
		  rs.movenext
    end if
       
    if model = 3 then		'没有表头
	    rs.movenext			'第1行标题
	    rs.movenext			'第2行表头
	    '第3行开始为正式数据
	    
	    for i=0 to ubound(LocalArray)
		    arr = split(LocalArray(i),"|",-1,1)
		    j = 0
		    for j=0 to ubound(arr)
			    rs(j) = arr(j)
				next
		    rs.movenext
	    next
	    
	    do while rs(0)<6300
	    	i = rs(0)
		    for j=0 to ubound(arr)
			    rs(j) = ""
				next
	    	rs.movenext
			loop
		
			for j=0 to ubound(arr)
				rs(j) = ""
			next
		  rs.movenext
    end if
       
    if model = 4 then		'没有表头
	    rs.movenext			'第1行标题
	   	if floatTitle > "" then
		    rs(1)	= floatTitle
    	end if
	    rs.movenext			'第2行表头
	    rs.movenext			'第3行标题
	    '第4行开始为正式数据
	    
	    for i=0 to ubound(LocalArray)
		    arr = split(LocalArray(i),"|",-1,1)
		    j = 0
		    for j=0 to ubound(arr)
			    rs(j) = arr(j)
				next
		    rs.movenext
	    next
	    
	    do while rs(0)<6300
	    	i = rs(0)
		    for j=0 to ubound(arr)
			    rs(j) = ""
				next
	    	rs.movenext
			loop
		
			for j=0 to ubound(arr)
				rs(j) = ""
			next
		  rs.movenext
    end if
       
    if model = 5 then		'没有表头
	    rs.movenext			'第1行标题
	    rs.movenext			'第2行表头
	   	if floatTitle > "" then
		    rs(5)	= floatTitle
    	end if
	   	if floatItem > "" then
		    rs(8)	= floatItem
    	end if
	    rs.movenext			'第1行标题
	    rs.movenext			'第2行表头
	    '第5行开始为正式数据
	    
	    for i=0 to ubound(LocalArray)
		    arr = split(LocalArray(i),"|",-1,1)
		    j = 0
		    for j=0 to ubound(arr)
			    rs(j) = arr(j)
				next
		    rs.movenext
	    next
	    
	    do while rs(0)<6300
	    	i = rs(0)
		    for j=0 to ubound(arr)
			    rs(j) = ""
				next
	    	rs.movenext
			loop
		
			for j=0 to ubound(arr)
				rs(j) = ""
			next
		  rs.movenext
    end if
    
	rs.Close
    oConn.Close
    Set oConn = Nothing

    Response.Write(tempFile)
 
</script>
