    var $tds = $("tbody td");  
    // 给$tds注册点击事件  
    $tds.click(function() {
      // 获取被点击的td  
      var $td = $(this);
      var tear = $td.attr("alt").split("|");	//记录了该数据的表名、字段名、ID以及是否可编辑. tabName|fieldName|ID|mark  mark: 0 不可编辑  1 可编辑
      // 检测此td是否已经被替换了，如果被替换直接返回，如果没有权限也返回。 
      if ($td.children("input").length > 0 || tear[3] != 1 || $td.attr("class") != "editable") {  
          return false;  
      }

      // 获取$td中的文本内容  
      var text = $td.text();  

      // 创建替换的input 对象  
      var $input = $("<input type='text'>").css("background-color",  
              $td.css("background-color")).width($td.width());  
      // 设置value值  
      $input.val(text);  

      // 清除td中的文本内容  
      $td.html("");  
      $td.append($input);  

      // 处理enter事件和esc事件  
      $input.keyup(function(event) {  
        // 获取当前按下键盘的键值  
        var key = event.which;  
        // 处理回车的情况  
        if (key == 13) {  
          // 获取当当前文本框中的内容  
          var value = $input.val();  
          // 将td中的内容修改成获取的value值  
          $td.html(value);
          updateTabCell(tear[0],tear[1],tear[2],value);
        }
        if (key == 27) {  
          // 将td中的内容还原
          $td.html(text);  
        }  
      });  
    });
