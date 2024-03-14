/* Chinese initialisation for the jQuery UI date picker plugin. */ /* Written by Cloudream (cloudream@gmail.com). */ 
jQuery(function($){ 
	$.datepicker.regional['zh-CN'] = {
		closeText: 'X', 
			monthNames: ['01 ','02 ','03 ','04 ','05 ','06 ', '07 ','08 ','09 ','10 ','11 ','12 '],  
			dayNames: ['7','1','2','3','4','5','6'], 
			dayNamesShort: ['7','1','2','3','4','5','6'], 
			dayNamesMin: ['7','1','2','3','4','5','6'], 
			dateFormat: 'yy-mm-dd', 
			firstDay: 1,  
			initStatus: '«Î—°‘Ò»’∆⁄', 
			isRTL: false}; 
		$.datepicker.setDefaults($.datepicker.regional['zh-CN']); }); 