<!--#include file="js/doc.js" -->
<!doctype html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>教学班级考勤</title>
  <link rel="stylesheet" href="assets/demo.css">

  <script src="js/jquery-3.3.1.min.js"></script>
  <script src="js/tracking.js/tracking.js"></script>
  <script src="js/tracking.js/data/face.js"></script>
  <script src="js/tracking.js/data/eye.js"></script>
  <script src="js/tracking.js/data/mouth.js"></script>

  <style>
    video, canvas {
      margin-left: 230px;
      margin-top: 120px;
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
    $(document).ready(function (){
      var video = document.getElementById('video');
      var canvas = document.getElementById('canvas');
      var context = canvas.getContext('2d');
      var quality = 0.2;  // 0.2-0.5之间，控制压缩率。越小压缩越大，0.2可以在保证质量的情况下达到最大压缩率。

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
              if (!faceflag && rect && rect.x > video.clientWidth * 0.3 && rect.x < video.clientWidth * 0.7) { // 检测到人脸进行拍照，延迟0.5秒
              // $("#tip1").html(faceflag + ":" + rect?rect.x + ":" + video.clientWidth * 0.3 + ":" + video.clientWidth * 0.7:"");
                  $("#tip").html('识别中，请勿乱动~');
                  faceflag = true;
                  tipFlag = true;
                  setTimeout(() => {
                      tackPhoto(); // 拍照
                      //uploadPhoto();
                      $("#tip").html('识别成功.');
                      faceflag = false;
                      tipFlag = false;
                  }, 500);
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
        var imgSrc = "data:image/jepg;" + snapData;
        $("#imgShot").src = imgSrc;

        // sessionStorage.setItem("faceImage", imgSrc);
        // history.go(-1);
        history.back()
        // video.srcObject.getTracks().forEach(track => track.stop());
        // 取消监听
        // tra.stop();
    }

  </script>
</head>
<body>
  <div class="demo-title">
    <p>人脸考勤</p>
  </div>

  <div class="demo-frame">
    <div>
      <img id="imgShot" style="width:300;height:300;" />
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