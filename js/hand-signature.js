/** 
 * @param {*} params {}
 * /**
 *  whiteBord 白板盒子canvas id名
 *  popverBox 确认签字以后想要隐藏掉的盒子
 *  againWrite 重写按钮id名
 *  sureWrite 确定按钮id名
 *  whiteBordPtions 白板配置项
 *  sureWriteCallback 确定签名之后的回调函数
 * @returns 签名的图片：格式base64
 */
 function signature(params) {
     alert(1);
  let {whiteBord,againWrite,sureWrite,whiteBordPtions,sureWriteCallback} = params
  let whiteBoardDom = document.getElementById(whiteBord);
  let againWriteBtn = document.getElementById(againWrite)
  let sureWriteBtn = document.getElementById(sureWrite)
  
  let writeCanvas;
  let imageBase64=''
  againWriteBtn.addEventListener("click", function () {
      drawClear()
  })
  sureWriteBtn.addEventListener('click', function () {
      savePict()
  })

  function WriteFont(options) {
      let obj = {
          canvas: whiteBoardDom,
          context: whiteBoardDom.getContext("2d"),
          isWrite: false, //是否开始
          canvasWidth: 300, //canvas宽高
          canvasHeight: 400,
          lastPoint: {}, //
          writeWidth: 2, //基础轨迹宽度
          writeColor: '#000', // 轨迹颜色
      }

      for (let name in options) {
          obj[name] = options[name];
      }

      /**
       * 轨迹宽度
       */
      this.setLineWidth = function () {
          let nowTime = new Date().getTime();
          obj.lastWriteTime = nowTime;
          obj.context.lineWidth = obj.writeWidth;

      }

      /**
       * 绘制轨迹
       */
      this.writing = function (point) {
          obj.context.beginPath();
          obj.context.moveTo(obj.lastPoint.x, obj.lastPoint.y);
          obj.context.lineTo(point.x, point.y);
          this.setLineWidth();
          obj.context.stroke();
          obj.lastPoint = point;
          obj.context.closePath();
      }

      /**
       * 轨迹样式
       */
      this.writeContextStyle = function () {
          obj.context.beginPath();
          obj.context.strokeStyle = obj.writeColor;
          obj.context.lineCap = 'round';
          obj.context.lineJoin = "round";
      }

      /**
       * 写开始
       */
      this.writeBegin = function (point) {
          obj.isWrite = true;
          obj.lastWriteTime = new Date().getTime();
          obj.lastPoint = point;
          this.writeContextStyle();
      }

      /**
       * 写结束
       */
      this.writeEnd = function () {
          obj.isWrite = false;
      }

      /**
       * 清空画板
       */
      this.canvasClear = function () {
          obj.context.save();
          obj.context.strokeStyle = '#fff';
          obj.context.clearRect(0, 0, obj.canvasWidth, obj.canvasHeight);
          obj.context.restore();
      }

      /**
       * 初始化画板
       */
      this.canvasInit = function () {
          whiteBoardDom.width = obj.canvasWidth;
          whiteBoardDom.height = obj.canvasHeight;
          emptyCanvas = whiteBoardDom.toDataURL("image/png");
      }
      let that = this
      /**======================事件绑定===========================**/
      whiteBoardDom.addEventListener('touchstart', function (e) {

          let point = {
              x: e.touches[0].pageX - 35,
              y: e.touches[0].pageY - 60
          };
          that.writeBegin(point);
          point = {
              x: point.x / obj.canvasWidth * 330,
              y: point.y / obj.canvasHeight * 170
          };
      });

      whiteBoardDom.addEventListener('touchend', function (e) {
          that.writeEnd();
      });

      whiteBoardDom.addEventListener('touchmove', function (e) {
          if (obj.isWrite) {
              let point = {
                  x: e.touches[0].pageX - 35,
                  y: e.touches[0].pageY - 60
              };
              that.writing(point);
              point = {
                  x: point.x / obj.canvasWidth * 330,
                  y: point.y / obj.canvasHeight * 170
              };
          }
      });


      this.canvasInit();
      this.canvasClear();
      obj.control = {
          clearCanvas: that.canvasClear
      };

      this.option = obj;

  }
  /**
       * 初始化调用
       * 设置参数
  */
  writeCanvas = new WriteFont('whiteBord', whiteBordPtions);

  function savePict() {
      imageBase64 = whiteBoardDom.toDataURL("image/png"); //base64
      writeCanvas.option.control.clearCanvas();
      sureWriteCallback(imageBase64)
  }
  function drawClear() {
      writeCanvas.option.control.clearCanvas();

  }
}
