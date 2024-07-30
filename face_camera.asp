<!--#include file="js/doc.js" -->
<!doctype html>
<html>
<head>
  <title>教学考勤</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
	<link href="css/jquery-confirm.min.css" rel="stylesheet" type="text/css" media="screen" />
	<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
  <link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.21">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">

  <script src="js/jquery-3.3.1.min.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
  <script src="js/tracking.js/tracking.js"></script>
  <script src="js/tracking.js/data/face.js"></script>
  <script src="js/tracking.js/data/eye.js"></script>
  <script src="js/tracking.js/data/mouth.js"></script>
	<script src="js/jquery-confirm.min.js" type="text/javascript"></script>
  <script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js?v=1.0"></script>
  <script src="js/jquery.alerts.js" type="text/javascript"></script>

  <style>
    video {
      margin-left: 1px;
      margin-top: 1px;
      /* top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto; */
      position: absolute;
      transform: rotateY(180deg);
      -webkit-transform: rotateY(180deg);
      -moz-transform: rotateY(180deg);
    }
    canvas {
      margin-left: 1px;
      margin-top: 1px;
      /* top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto; */
      position: absolute;
    }
    .tip-box {
        font-size: 2em;
        color: blue;
        font-weight: bold;
        margin: 10px;
        text-align: center;
    }
    .tip-box1 {
        font-size: 1.5em;
        color: red;
        font-weight: bold;
        margin: 10px;
        text-align: center;
    }
    .tip {
        font-size: 1.5em;
    }
    .tip1 {
        font-size: 1.5em;
        color: blue;
        background-color: #eee;
        width: 100%;
    }
    .combobox-item{
      font-weight:bold;
      font-size: 1.5em;
    }
    .vbox{
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto;
    }
    .combobox-item-selected{
      font-weight:bold;
      color: blue;
      font-size: 1.5em;
    }
    .textbox .textbox-text{
      font-weight:bold;
      font-size: 1.5em;
    }
    .left{
      font-size: 16px;
    }
    .datagrid-header-row { 
      height: 30px;
    }
    .datagrid-row { 
      height: 'auto';
      font-size: 16px;
    }
  </style>
  <script>
	  <!--#include file="js/commFunction.js"-->
    var tipFlag = false // 是否检测
    var faceflag = false // 是否进行拍照
    var quality = 0.2;  // 0.2-0.5之间，控制压缩率。越小压缩越大，0.2可以在保证质量的情况下达到最大压缩率。
    var start = 0;
    let refID = 0;

    $(document).ready(function (){
      $("#confidence").numberbox("setValue", 65);
		
      $("#confidence").numberbox({
        onChange:function(val) {
          if(val > 75 || val < 45){
            $.messager.alert("提示","识别参数应该在45-75范围内。","warning");
            $("#confidence").numberbox("setValue", 66);
            return false;
          }
        }
      });
		
      $("#btnStart").linkbutton({
        iconCls:'icon-ok',
        width:120,
        height:30,
        text:'<span style="font-size:18px">开始考勤</span>',
        onClick:function() {
          getSelCart("");
          if(selCount==0){
            $.messager.alert("提示","请选择课程。","warning");
            return false;
          }else{
            start = 1;
            $("#tip").html('考勤已开始。');
            // getScheduleCheckIn();
            // getCheckinList();
          }
        }
      });
		
      $("#btnStop").linkbutton({
        iconCls:'icon-cancel',
        width:120,
        height:30,
        text:'<span style="font-size:18px">结束考勤</span>',
        onClick:function() {
          start = 0;
          $("#tip").html('考勤已结束。');
        }
      });

      $('#dg1').datagrid({
          url:'',
          columns:[[
              {field:'username',title:'身份证号',width:'50%',formatter: function(value,row,index){
									return "<span style='font-size:16px;'>" + value + "</span>";
								}
              },
              {field:'name',title:'姓名',width:'30%',align:'left',formatter: function(value,row,index){
									return "<span style='font-size:16px;'>" + value + "</span>";
								}
              },
              {field:'classID',title:'班级',width:'30%',formatter: function(value,row,index){
									return "<span style='font-size:16px;'>" + value + "</span>";
								}
              }
          ]],
          onDblClickRow: function(index, row){
            //取消签到
            $.messager.prompt('取消签到', '请输入验证码：', function(r){
                if (r=="1357"){
                    //取消此人的签到
                    $.get("classControl.asp?op=cancelFaceCheckin&nodeID=" + row.ID + "&times=" + (new Date().getTime()),function(re){
                      jAlert("已取消。");
                      getCheckinList(refID);
                    });
                }
            });
          }
      });
      $('#dg2').datagrid({
          url:'',
          columns:[[
              {field:'name',title:'姓名',width:'50%',align:'left',formatter: function(value,row,index){
									return "<span style='font-size:16px;'>" + value + "</span>";
								}
              },
              // {field:'classID',title:'班级',width:'30%'},
	            {field:'photo_filename',title:'照片',width:'50%',align:'center',formatter: function(value,row,index){
									var s = "";
									if(row.photo_filename > ""){
										s = '<img style="width:40px;" src="users' + row.photo_filename + '?times=' + (new Date().getTime()) + '"></a>';
									}
									return s;
								}
        			}
          ]]
      });
      //更改的是datagrid中的数据
      $('.datagrid-cell').css('font-size','16px');
      //datagrid中的列名称
      $('.datagrid-header .datagrid-cell span ').css('font-size','16px');
      //标题
      $('.panel-title ').css('font-size','36px'); 
      // $('.datagrid-row').css('height','50px');
      //分页工具栏
      // $('.datagrid-pager').css('display','none');
      var video = document.getElementById('video');
      var canvas = document.getElementById('canvas');
      var context = canvas.getContext('2d');

      canvas.width = canvas.clientWidth;
      canvas.height = canvas.clientHeight;
      
      var videoWidth = videoHeight = 0
      video.addEventListener('canplay', function() {
          videoWidth = this.videoWidth;
          videoHeight = this.videoHeight;
      });

      var tracker = new tracking.ObjectTracker(['face', 'eye', 'mouth']);
      // 每次打开弹框先清除canvas没拍的照片
      context.clearRect(0, 0, canvas.width, canvas.height);
      tracker.setInitialScale(4);
      tracker.setStepSize(2);
      tracker.setEdgesDensity(0.1);

      var tra = tracking.track('#video', tracker, { camera: true });
      var timer = null;
      tracker.on('track', function(event) {
        if (start>0 && !tipFlag) {
          context.clearRect(0, 0, canvas.width, canvas.height);

          if (event.data.length === 0) {
            //未检测到人脸
            if (!faceflag && !timer) {
                timer = setTimeout(() => {
                  $("#tip").html('未检测到人脸');
                }, 500)
            }
          } else if (event.data.length === 1) { // 长度为多少代表检测到几张人脸
            window.clearTimeout(timer);
            timer = null;
            $("#tip").html('请将脸部置于屏幕中央');
            //检测到一张人脸
            if (!tipFlag) {
              event.data.forEach(function(rect) {
                context.strokeStyle = '#a64ceb';
                context.strokeRect(rect.x, rect.y, rect.width, rect.height);
                context.font = '11px Helvetica';
                context.fillStyle = "#fff";
                context.fillText('x: ' + rect.x + 'px', rect.x + rect.width + 5, rect.y + 11);
                context.fillText('y: ' + rect.y + 'px', rect.x + rect.width + 5, rect.y + 22);
              });
              let rect = event.data[0];
              //判断脸部是否在屏幕中间
              // alert(rect1?rect1.x:"");
              if (!faceflag && rect && rect.x > video.clientWidth * 0.2 && rect.x < video.clientWidth * 0.8) { // 检测到人脸进行拍照，延迟0.5秒
                  $("#tip").html('识别中，请勿晃动~');
                  faceflag = true;
                  tipFlag = true;
                  setTimeout(() => {
                      // 拍照
                      let base64Data = tackPhoto();
                      if(base64Data){
                        //upload photo for compare
                        // alert(uploadURLS + "/alis/searchFace")
                        $.post(uploadURLS + "/alis/searchFace", {base64Data: base64Data, selList: selList, confidence: $("#confidence").numberbox("getValue")} ,function(data){
                          // alert(data)
                          if(data.status < 9){
                            showResultMsg(data.status, data.name, data.msg);
                          }
                          $("#res").html(data.name + data.msg);
                          // getScheduleCheckIn();
                          getCheckinList(refID);
                        });
                      }
                      faceflag = false;
                      tipFlag = false;
                  }, 1000);
              }
            }
          } else {
            //检测到多张人脸
            if (!faceflag) {
              $("#tip").html('只可一人进行人脸识别！');
            }
          }
        }
      });

      function tackPhoto() {
          // 第二种方式	
          context.drawImage(video, 0, 0, video.clientWidth, video.clientHeight);
          var snapData = canvas.toDataURL('image/jpeg', quality);
          // var imgSrc = "data:image/jepg;" + snapData;
          // $("#imgShot").src = snapData;
          return snapData

          // sessionStorage.setItem("faceImage", imgSrc);
          // history.go(-1);
          // history.back()
          // video.srcObject.getTracks().forEach(track => track.stop());
          // 取消监听
          // tra.stop();
      }

      getScheduleList();
    });

    function showResultMsg(kind, name, msg){
      let c = ["green", "red", "orange"];
      //根据不同标识，显示不同风格（字体颜色）。1秒后自动关闭
      let jc = $.dialog({
          title: false,
          content: '<div style="font-size: 15em; font-weight:bold; text-align:center; color:' + c[kind] + ';">' + name + '<br />' + msg + '</div>',
          autoClose: '|500',
          animation: 'scale',
          closeAnimation: 'zoom'
      });
      setTimeout(() => {
          jc.close();
      }, 1000);    		
      var utterThis = new window.SpeechSynthesisUtterance(name+msg);
      window.speechSynthesis.cancel();
		  window.speechSynthesis.speak(utterThis);
    }

    function getScheduleList(){
      $.get("classControl.asp?op=getCurrScheduleList&dk=101&times=" + (new Date().getTime()),function(data){
        // alert(unescape(data))
        var ar = new Array();
        ar = (unescape(data)).split("%%");
        $("#cover").empty();
        arr = [];	
        arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='enterTab' width='100%'>");
        arr.push("<thead>");
        arr.push("<tr align='center'>");
        // arr.push("<th width='1%'></th>");
        arr.push("<th width='50%' class='left'>课程名称</th>");
        arr.push("<th width='12%' class='left'>人数</th>");
        arr.push("<th width='12%' class='left'>签到</th>");
        arr.push("<th width='12%' class='left'>本班</th>");
        arr.push("<th width='12%' class='left'>其他</th>");
        arr.push("<th width='2%'></th>");
        arr.push("</tr>");
        arr.push("</thead>");
        arr.push("<tbody id='tbody'>");
        if(ar>""){
          var i = 0;
          $.each(ar,function(iNum,val){
            var ar1 = new Array();
            ar1 = val.split("|");
            i += 1;
            arr.push("<tr class='grade0'>");
            // arr.push("<td class='center'>" + i + "</td>");
            arr.push("<td class='left'><a style='text-decoration: none; font-size:16px;' href='javascript:getCheckinList(" + ar1[0] + "," + ar1[4] + ");'>" + ar1[4] + "." + ar1[2] + "</a></td>");
            let ar2 = ar1[3].split("**");
            arr.push("<td class='left'>" + ar2[0] + "</td>");
            arr.push("<td class='left'>" + ar2[1] + "</td>");
            arr.push("<td class='left'>" + ar2[2] + "</td>");
            arr.push("<td class='left'>" + ar2[3] + "</td>");
            arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchk' />" + "</td>");
            arr.push("</tr>");
          });
        }
        arr.push("</tbody>");
        arr.push("<tfoot>");
        arr.push("<tr>");
        // arr.push("<th>&nbsp;</th>");
        arr.push("<th>&nbsp;</th>");
        arr.push("<th>&nbsp;</th>");
        arr.push("<th>&nbsp;</th>");
        arr.push("<th>&nbsp;</th>");
        arr.push("<th>&nbsp;</th>");
        arr.push("<th>&nbsp;</th>");
        arr.push("</tr>");
        arr.push("</tfoot>");
        arr.push("</table>");
        $("#cover").html(arr.join(""));
        arr = [];
        $('#enterTab').dataTable({
          "aaSorting": [],
          "bFilter": false,
          "bPaginate": false,
          "bLengthChange": false,
          "bInfo": false,
          "aoColumnDefs": []
        });
        // setSel("");
		  });
    }

		function getCheckinList(id, classID){
      if(id>0){
        refID = id;
        $.getJSON(uploadURLS + "/public/getScheduleCheckInList?selList=" + id + "&times=" + (new Date().getTime()),function(re){
          $("#dg1").datagrid("loadData",re);
        });
        $.getJSON(uploadURLS + "/public/getScheduleNoCheckInList?selList=" + id + "&times=" + (new Date().getTime()),function(re){
          $("#dg2").datagrid("loadData",re);
        });
        $("#title_1").html(classID + "班已签到人员：");
        $("#title_2").html(classID + "班未签到人员：");
      }
		}

  </script>
</head>
<body>
  <div>
    <table style="width:100%;">
    <tr>
      <td colspan="3">
        <div>
          <span><a class="easyui-linkbutton" id="btnStart" href="javascript:void(0)"></a></span>&nbsp;&nbsp;
          <span><a class="easyui-linkbutton" id="btnStop" href="javascript:void(0)"></a></span>&nbsp;&nbsp;
          <span class="tip">识别参数：<input id="confidence" name="confidence" class="easyui-numberbox" data-options="min:0,height:22,width:50" />&nbsp;45-75&nbsp;&nbsp;</span>&nbsp;&nbsp;
          <span id="res" class="tip-box1" style="padding-left: 50px;"></span>
        </div>
     </td>
    </tr>
    <tr>
        <td style="width:44%;" valign="top">
          <div id="cover" style="float:top;margin:0px;background:#f8fff8;">
          </div>
          <div class="tip" id="title_1">已签到人员：</div>
          <div><table id="dg1" style="font-size:1.3em;"></table></div>
        </td>
        <td style="width:40%;" valign="top">
          <div>
            <div id="tip" class="tip-box"></div>
            <video id="video" width="440" height="360" preload autoplay loop muted></video>
            <canvas id="canvas" width="440" height="360"></canvas>
          </div>
        </td>
        <td style="width:15%;" valign="top">
          <div class="tip" id="title_2">未签到人员：</div>
          <div><table id="dg2" style="font-size:1.3em;"></table></div>
        </td>
    </tr>
    </table>
  </div>

</body>
</html>
