<!--#include file="js/doc.js" -->
<!doctype html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>教学班级考勤</title>
  <link rel="stylesheet" href="assets/demo.css">

  
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
  <script src="js/jquery-2.1.1.min.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.0"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
  <script src="js/tracking.js/tracking.js"></script>
  <script src="js/tracking.js/data/face.js"></script>
  <script src="js/tracking.js/data/eye.js"></script>
  <script src="js/tracking.js/data/mouth.js"></script>

  <style>
    video {
      margin-left: 230px;
      margin-top: 60px;
      position: absolute;
      transform: rotateY(180deg);
      -webkit-transform: rotateY(180deg);
      -moz-transform: rotateY(180deg);
    }
    canvas {
      margin-left: 230px;
      margin-top: 60px;
      position: absolute;
    }

    .tip-box {
        margin: 10px;
        font-size: 1em;
    }
  </style>
  <script>
	  <!--#include file="js/commFunction.js"-->
    var tipFlag = false // 是否检测
    var faceflag = false // 是否进行拍照
    var quality = 0.2;  // 0.2-0.5之间，控制压缩率。越小压缩越大，0.2可以在保证质量的情况下达到最大压缩率。
    var video = "";
    var canvas = "";
    var context = "";
    var tra = "";

    $(document).ready(function (){
      video = document.getElementById('video');
      canvas = document.getElementById('canvas');
      context = canvas.getContext('2d');

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

      tra = tracking.track('#video', tracker, { camera: true });
      var timer = null;
      tracker.on('track', function(event) {
        if (!tipFlag) {
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
              // $("#tip1").html(faceflag + ":" + rect?rect.x + ":" + video.clientWidth * 0.3 + ":" + video.clientWidth * 0.7:"");
                  $("#tip").html('识别中，请勿乱动~');
                  faceflag = true;
                  tipFlag = true;
                  setTimeout(() => {
                      let base64Data = tackPhoto();
                      //upload photo for compare
                      $.post(uploadURL + "/alis/searchFace", {base64Data: base64Data, refID: 1} ,function(data){
                        let msg = data.msg;
                        speak({text: msg});
                        showDialog(msg, data.status);
                        if(data.status==0){
                          // alert(msg);
                        }
                      });
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
    });

    function tackPhoto() {
        // 第二种方式	
        context.drawImage(video, 0, 0, video.clientWidth, video.clientHeight);
        var snapData = canvas.toDataURL('image/jpeg', quality);
        // var imgSrc = "data:image/jepg;" + snapData;
        stop();
        return snapData;
    }

    function stop() {
        video.srcObject.getTracks().forEach(track => track.stop());
        // 取消监听
        tra.stop();
    }

    function showDialog(text, mark) {
      if(mark==0){
        $("#dialog").css('background-color','green');
      }else{
        $("#dialog").css('background-color','red');
      }
      $("#msg").html(text);
      setTimeout(() => {
        $("#msg").html("");
      }, 2000);
    }

/**
 * @description 文字转语音方法
 * @public
 * @param { text, rate, lang, volume, pitch } object
 * @param  text 要合成的文字内容，字符串
 * @param  rate 读取文字的语速 0.1~10  正常1
 * @param  lang 读取文字时的语言
 * @param  volume  读取时声音的音量 0~1  正常1
 * @param  pitch  读取时声音的音高 0~2  正常1
 * @returns SpeechSynthesisUtterance
 */
function speak({ text, speechRate, lang, volume, pitch }, endEvent, startEvent) {
    if (!window.SpeechSynthesisUtterance) {
        console.warn('当前浏览器不支持文字转语音服务')
        return;
    }

    if (!text) {
        return;
    }

    const speechUtterance = new SpeechSynthesisUtterance();
    speechUtterance.text = text;
    speechUtterance.rate = speechRate || 1;
    speechUtterance.lang = lang || 'zh-CN';
    speechUtterance.volume = volume || 1;
    speechUtterance.pitch = pitch || 1;
    speechUtterance.onend = function() {
        endEvent && endEvent();
    };
    speechUtterance.onstart = function() {
        startEvent && startEvent();
    };
    speechSynthesis.speak(speechUtterance);
    
    return speechUtterance;
}

  </script>
</head>
<body>
  <div class="demo-title">
    <p>人脸考勤</p>
  </div>

  <div class="demo-frame">
    <div id="dialog" style="width:600px; height:200px;">
      <p id="msg" style="font-size:2em;"></p>
    </div>
    <div class="demo-container">
      <div id="tip" class="tip-box"></div>
      <div id="tip1"></div>
      <video id="video" width="320" height="240" preload autoplay loop muted></video>
      <canvas id="canvas" width="320" height="240"></canvas>
    </div>
  </div>
</body>
</html>
