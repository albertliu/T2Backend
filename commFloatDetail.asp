<div valign="baseline">
	<div id="lightFloat" class="white_content" STYLE="font-family: Arial; font-size: 12px; color: black"> 
		<div align="right">
		  <span align="right" onclick="document.getElementById('lightFloat').style.display='none';document.getElementById('fadeFloat').style.display='none'"><img src="../Images/close3.gif" />
		  </span>
		</div>    
		<br>
		<div class="comm">
			<h2><span id="floatTitle" align="center"></span></h2>
			<span id="floatItem" align="left"></span>
			<div id="floatLog" align="left"></div>
			<div id="floatSum" align="left"></div>
			<input id="floatKind" type="hidden" value="">
		</div>
		<br>
		<div id="floatCover">
		</div>
		<br>
		<div class="comm" align="center">
			<input class="button" id="printFloat" type="button" onClick="outputFloat(0,'print')" value=" 打印 ">&nbsp;&nbsp;
			<input class="button" id="outputFloat" type="button" onClick="outputFloat(0,'file')" value=" 导出Excel ">
		</div>
	</div> 
	<div id="fadeFloat" class="black_overlay"></div> 
</div>
