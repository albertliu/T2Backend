	var chartsclassListLong = 0;		//0: 标准栏目  1：短栏目
    //var echarts = require('echarts');
    //var myChart = echarts.init($("#chartsclassCover"));

	$(document).ready(function (){
      getComList("searchChartsClassCert","certificateInfo","certID","shortName","status=0 and type=0 order by certID",1);
      getComList("searchChartsClassAdviserID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser') order by realName",1);
      getDicList("statusYes","searchChartsClassArchive",1);
      $("#searchChartsClassStartDate").click(function(){WdatePicker();});
      $("#searchChartsClassEndDate").click(function(){WdatePicker();});
      $("#searchChartsClassStartDate").val(addDays(currDate,-183));
      $("#searchChartsClassEndDate").val(currDate);

      if(checkRole("adviser")){
        $("#searchChartsClassAdviserID").val(currUser);
      }

      $("#btnSearchChartsClass").click(function(){
				if($("#searchChartsClassStartDate").val()>"" && $("#searchChartsClassEndDate").val()>""){
					getChartsClass();
				}else{
					jAlert("请选择日期范围。");
				}
      });
      //if(checkRole("leader")){
      //  getChartsClass();
      //}
      $('input[type=radio][name=rptChartsClassDate]').change(function() {
        if(this.value==1){
          //this week
          $("#searchChartsClassStartDate").val(addDays(currDate,-7));
          $("#searchChartsClassEndDate").val(currDate);
        }
        if(this.value==2){
          //this quater
          $("#searchChartsClassStartDate").val(addDays(currDate,-90));
          $("#searchChartsClassEndDate").val(currDate);
        }
        if(this.value==3){
          //half a year
          $("#searchChartsClassStartDate").val(addDays(currDate,-183));
          $("#searchChartsClassEndDate").val(currDate);
        }
        if(this.value==4){
          //one year
          $("#searchChartsClassStartDate").val(addDays(currDate,-365));
          $("#searchChartsClassEndDate").val(currDate);
        }
      });
	});

	function getChartsClass(){
      var mark = 1;
      var adviserID = "";
      if($("#searchChartsClassAdviserID").val()>""){
        adviserID = $("#searchChartsClassAdviserID").val();
      }
      var total = 0;
      //alert((sWhere) + "&refID=" + $("#searchChartsClassCert").val() + "&status=" + $("#searchChartsClassStatus").val() + "&project=" + $("#searchChartsClassProject").val());
      $.post(uploadURL + "/public/getClassRpt",{adviserID:adviserID,certID:$("#searchChartsClassCert").val(), startDate:$("#searchChartsClassStartDate").val(), endDate:$("#searchChartsClassEndDate").val(), archived:$("#searchChartsClassArchive").val(), mark:mark},function(data){
            //var data = {total:32, title:['2021-10-01', '2021-10-02', '2021-10-03', '2021-10-04', '2021-10-05', '2021-10-06', '2021-10-07', '2021-10-08', '2021-10-09', '2021-10-10'],list:[{key:"社会",val:[320, 302, 301, 334, , 330, 320, 302, , 334]},{key:"中石化",val:[120, , 101, 134, 90, 230, 210, 132, , 134]},{key:"地铁",val:[220, 182, 191, 234, 290, 330, 310, 191, , 290]}]};
            var series = new Array();
            var obj;
            $("#chartsclassTotal").html("班级数量：" + data["total"]);
            total = data["total"];
            var list = data["list"];
            var lists = data["lists"];
            var i = 0;
            var zoom = 100-3000/total;
            if(zoom<0){
              zomm = 0;
            }
            list.forEach((item) =>{
                obj = {
                    name: item["key"],
                    type: 'bar',
                    stack: 'total',
                    label: {
                      show: true
                    },
                    emphasis: {
                      focus: 'series'
                    },
                    data: item["val"],
                    itemStyle: {
                      normal: {
                          color: function (params) {
                              var index_color = params.value;
                              if(item["key"]=="上课" && index_color>""){
                                if(index_color <= lists[0][i]) {
                                  return 'RGB(0,0,0,1)';   //课程正常结束：浅红
                                }else{
                                  return 'RGB(0,0,0,0.2)';   //红
                                }
                              }else if(item["key"]=="安排考试" && index_color>""){
                                if(index_color <= lists[1][i]) {
                                  return 'RGB(255,255,0,1)';   //正常：浅黄
                                }else{
                                  return 'RGB(255,255,0,0.2)';   //超期：黄
                                }
                              }else if(item["key"]=="制作证书" && index_color>""){
                                if(index_color <= lists[2][i]) {
                                  return 'RGB(0,255,0,1)';   //正常：浅绿
                                }else{
                                  return 'RGB(0,255,0,0.2)';   //超期：绿
                                }
                              }else if(item["key"]=="归档" && index_color>""){
                                if(index_color <= lists[3][i]) {
                                  return 'RGB(0,0,255,1)';   //正常：浅蓝
                                }else{
                                  return 'RGB(0,0,255,0.2)';   //超期：深蓝
                                }
                              }else if(item["key"]=="结束" && index_color>""){
                                return 'RGB(255,0,0)';   //正常：浅蓝
                              }
                          }
                      }
                  }
                };
                series.push(obj);
                i += 1;
            });

            var chartsclassOption = {
              title: {
                text: '班级运行情况',
                top: 5
              },
                  tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                      // Use axis to trigger tooltip
                      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
                    },
                    formatter: function (params,ticket,callback) {
                      var res = params[0].name;
                      var adviser = "未指定";
                      var examScore = 0;
                      var examTimes = 0;
                      //var i = data["title"].indexof(res);
                      var i = $.inArray(res,data["title"]);
                      if(i>=0){
                        adviser = data["adviser"][i];
                        examScore = data["examScore"][i];
                        examTimes = data["examTimes"][i];
                      }
                      res += "<br/>" + "班主任：" + adviser + "<br/>" + "模拟考试：" + examTimes + "次 " + examScore + "分";
                      for (var i = 0, l = params.length; i < l; i++) {
                          //val = params[i].value;
                          res += '<br/>' + params[i].seriesName + ' ：' + (params[i].seriesName=="结束" && params[i].value>"" ? "已结束":params[i].value > "" ? params[i].value+"天":"");//要填充的内容
                      }
                      return res;
                    }
                  },
                  color: ['#000','#ff0', '#0f0','#00f', '#f00'],
                  legend: {
                    top: "3%" // bottom:"20%" // 组件离容器的距离
                  },
                  grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                  },
                  xAxis: {
                    type: 'value'
                  },
                  yAxis: {
                    type: 'category',
                    //data: ['2021-10-01', '2021-10-02', '2021-10-03', '2021-10-04', '2021-10-05', '2021-10-06', '2021-10-07', '2021-10-08', '2021-10-09', '2021-10-10']
                    data: data["title"]
                  },
                  dataZoom:[
                    {
                        type:"slider",//slider表示有滑动块的，
                        show:true,
                        yAxisIndex:[0],//表示y轴折叠
                        start:100,//数据窗口范围的起始百分比,表示100%
                        end:zoom//数据窗口范围的结束百分比,表示60%坐标
                    }
                  ],
                  series: series               
            };

            var myChart = echarts.init(document.getElementById("chartsclassCover"));
            chartsclassOption && myChart.setOption(chartsclassOption, true);
		  });
}

	
	