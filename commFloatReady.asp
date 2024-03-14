		$("#outputFloat").click(function(){
			outputFloat();
		});

		$("#printFloat").click(function(){
			if(floatCount>0){
				//alert("writeExcel.asp?floatKind=" + floatKind + "&floatQuery=" + floatQuery);
				$.get("writeExcel.asp?floatKind=" + floatKind + "&floatQuery=" + floatQuery + "&floatItem=" + escape(floatItem) + "&floatLog=" + escape(floatLog) + "&floatSum=" + escape(floatSum) + "&times=" + (new Date().getTime()),function(re){
					//alert(re);
					if(re>0){
						$.get("gin.asp?floatKind=" + floatKind + "&times=" + (new Date().getTime()),function(data){
							//alert(data);
							//window.open(data,"_blank");   //open an excel file in a new window
							printExcel(data);
						});
					}
				});
			}else{
				jAlert("没有数据!");
			}
		});
