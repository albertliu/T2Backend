<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<script language="javascript" runat="server">
	var ar = new Array();
	for(i=0; i<Session("floatArray").length; i++){
		ar[i] = Session("floatArray")[i];
	}
</script>

<SCRIPT LANGUAGE="VBSCRIPT" RUNAT="SERVER">

	'fetch data from array in session
	'copy a word file from special model file
	'write the data to the new word file
	'return the new word name to program which call this function
	'the session data had be saved with writeWord.asp by other program before
	
	  Dim sSource, sDest, LocalArray, arr, user, floatKind, tempFile, i, j, floatTitle, floatItem, floatLog, floatSum
	  
		floatKind = request("floatKind")
		user = Session("user_key")
    'tempFile = "\temp\" & user & floatKind & ".doc"
    tempFile = "\temp\" & user & getDateTime & ".doc"
    
    sSource = Server.MapPath(".") & "\output\output" & floatKind & ".doc"
    sDest = Server.MapPath(".") & tempFile
    
    'Copy the source workbook file (the "template") to the destination filename
    Dim fso
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    fso.GetFile(sSource).Copy sDest
    Set fso = Nothing
    
    '--start to write to word document with data from session
    LocalArray = ar.join("%")
    LocalArray = split(LocalArray,"%",-1,1)
		set wordApp = CreateObject("Word.Application")
		wordapp.Visible = false
		set doc = wordApp.Documents.Open(sDest)
		'doc.Bookmarks("m0").range.text = "testing"
	  for i=0 to ubound(LocalArray)
		    arr = split(LocalArray(i),"|",-1,1)
		    if arr(1)>"" then
		    	doc.Bookmarks(arr(0)).range.text = arr(1)
		    end if
	  next
		doc.Save   
		wordApp.Quit    
		set wordApp=nothing      
    
    '--end write
    
    Response.Write(tempFile)

	function getDateTime()
		getDateTime = year(now()) & month(now()) & day(now()) & hour(now()) & minute(now()) & second(now())
	end function
</script>
