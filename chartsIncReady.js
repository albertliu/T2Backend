	var chartsListLong = 0;		//0: 标准栏目  1：短栏目
    //var echarts = require('echarts');
    //var myChart = echarts.init($("#chartsCover"));

	$(document).ready(function (){
      getComList("searchChartsCert","certificateInfo","certID","shortName","status=0 and type=0 order by certID",1);
      if(checkRole("saler")){
          getComList("searchChartsFromID","userInfo","username","realName","status=0 and username='" + currUser + "' order by realName",0);
      }else{
          getComList("searchChartsFromID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='saler') order by realName",1);
      }
      $("#searchChartsStartDate").click(function(){WdatePicker();});
      $("#searchChartsEndDate").click(function(){WdatePicker();});
      $("#searchChartsStartDate").val(addDays(currDate,-183));
      $("#searchChartsEndDate").val(currDate);
      $("#btnSearchCharts").click(function(){
				if($("#searchChartsStartDate").val()>"" && $("#searchChartsEndDate").val()>""){
					getCharts();
				}else{
					jAlert("请选择日期范围。");
				}
      });
      //if(checkRole("leader")){
      //  getCharts();
      //}
      $('input[type=radio][name=rptChartsDate]').change(function() {
        if(this.value==1){
          //this week
          $("#searchChartsStartDate").val(addDays(currDate,-7));
          $("#searchChartsEndDate").val(currDate);
          $('input[name=rptChartsGroupDate][value=d]').prop("checked",true)
        }
        if(this.value==2){
          //this quater
          $("#searchChartsStartDate").val(addDays(currDate,-90));
          $("#searchChartsEndDate").val(currDate);
          $('input[name=rptChartsGroupDate][value=w]').prop("checked",true)
        }
        if(this.value==3){
          //half a year
          $("#searchChartsStartDate").val(addDays(currDate,-183));
          $("#searchChartsEndDate").val(currDate);
          $('input[name=rptChartsGroupDate][value=m]').prop("checked",true)
        }
        if(this.value==4){
          //one year
          $("#searchChartsStartDate").val(addDays(currDate,-365));
          $("#searchChartsEndDate").val(currDate);
          $('input[name=rptChartsGroupDate][value=m]').prop("checked",true)
        }
      });
	});

	function getCharts(){
      var mark = 1;
      var fromID = "";
      if(checkRole("saler")){
          mark = 3;
          fromID = currUser;
      }
      if($("#searchChartsFromID").val()>""){
          fromID = $("#searchChartsFromID").val();
      }
      var g4 = $("input[name='rptChartsGroupDate']:checked").val();
      var total = 0;
      //alert((sWhere) + "&refID=" + $("#searchChartsCert").val() + "&status=" + $("#searchChartsStatus").val() + "&project=" + $("#searchChartsProject").val());
      $.post(uploadURL + "/public/getEnterRpt",{refID:g4, certID:$("#searchChartsCert").val(), startDate:$("#searchChartsStartDate").val(), endDate:$("#searchChartsEndDate").val(), mark:mark, fromID:fromID},function(data){
            //var data = {title:['2021-10-01', '2021-10-02', '2021-10-03', '2021-10-04', '2021-10-05', '2021-10-06', '2021-10-07', '2021-10-08', '2021-10-09', '2021-10-10'],list:[{key:"社会",val:[320, 302, 301, 334, , 330, 320, 302, , 334]},{key:"中石化",val:[120, , 101, 134, 90, 230, 210, 132, , 134]},{key:"地铁",val:[220, 182, 191, 234, 290, 330, 310, 191, , 290]}]};
            var series = new Array();
            var obj;
            $("#chartsTotal").html("报名人数合计：" + data["total"].toLocaleString());
            total = data["total"];
            var list = data["list"];
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
                    data: item["val"]
                };
                series.push(obj);
            });
            var chartsOption = {
              title: {},
                  tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                      // Use axis to trigger tooltip
                      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
                    }
                  },
                  legend: {
                    top: "3%", // bottom:"20%" // 组件离容器的距离
                  },
                  grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                  },
                  xAxis: {
                    type: 'category',
                    //data: ['2021-10-01', '2021-10-02', '2021-10-03', '2021-10-04', '2021-10-05', '2021-10-06', '2021-10-07', '2021-10-08', '2021-10-09', '2021-10-10']
                    data: data["title"]
                  },
                  yAxis: {
                    type: 'value'
                  },
                  series: series               
            };

            var myChart = echarts.init(document.getElementById("chartsCover"));
            chartsOption && myChart.setOption(chartsOption, true);

            chartsOption = {
              title: {
                text: '报名来源分布',
                //subtext: '证书类别',
                left: 'center'
              },
              tooltip: {
                trigger: 'item',
                formatter: '{b}<br/>数量：{c} <br/>比例：{d}%'
              },
              legend: {
                orient: 'vertical',
                left: 'left',
                top: "10%", // bottom:"20%" // 组件离容器的距离
                left: "5%" //left:"10%"  // // 组件离容器的距离
              },
              series: [
                {
                  name: '生源',
                  type: 'pie',
                  radius: '70%',
                  center: ['50%', '55%'],
                  data: data["pie"],
                  emphasis: {
                    itemStyle: {
                      shadowBlur: 10,
                      shadowOffsetX: 0,
                      shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                  }
                }
              ]
            };

            var myChartPie = echarts.init(document.getElementById("chartsPie"));
            chartsOption && myChartPie.setOption(chartsOption, true);
          });

		  $.post(uploadURL + "/public/getEnterRptPie1",{refID:g4, startDate:$("#searchChartsStartDate").val(), endDate:$("#searchChartsEndDate").val(), mark:mark, fromID:fromID},function(data){
            var chartsOption = {
              title: {
                text: '报名课程分布',
                //subtext: '证书类别',
                left: 'center'
              },
              tooltip: {
                trigger: 'item',
                formatter: '{b}<br/>数量：{c} <br/>比例：{d}%'
              },
              series: [
                {
                  name: '证书名称',
                  type: 'pie',
                  radius: '70%',
                  center: ['50%', '55%'],
                  data: data,
                  emphasis: {
                    itemStyle: {
                      shadowBlur: 10,
                      shadowOffsetX: 0,
                      shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                  }
                }
              ]
            };
            

            var myChartPie1 = echarts.init(document.getElementById("chartsPie1"));
            chartsOption && myChartPie1.setOption(chartsOption, true);
		  });

      $.post(uploadURL + "/public/getExamRpt",{refID:g4, certID:$("#searchChartsCert").val(), startDate:$("#searchChartsStartDate").val(), endDate:$("#searchChartsEndDate").val(), mark:mark},function(data){
        //var data = {title:['2021-10-01', '2021-10-02', '2021-10-03', '2021-10-04', '2021-10-05', '2021-10-06', '2021-10-07', '2021-10-08', '2021-10-09', '2021-10-10'],list:[{key:"社会",val:[320, 302, 301, 334, , 330, 320, 302, , 334]},{key:"中石化",val:[120, , 101, 134, 90, 230, 210, 132, , 134]},{key:"地铁",val:[220, 182, 191, 234, 290, 330, 310, 191, , 290]}]};
        var series = new Array();
        var obj;
        for(var i=0; i < data.length; i++){
            if(i>0){
              obj = {
                type: 'line',
                smooth: true,
                seriesLayoutBy: 'row',
                emphasis: { focus: 'series' }
              };
              series.push(obj);
            }
        };
        
        var chartsOption = {
          title: {
            text: '鉴定合格率',
            left: 'center',
            top: 5
          },
          legend: {
            type: "plain", // 图例的类型 'plain':普通图例  'scroll':可滚动翻页的图例
            bottom: 0
          },
          tooltip: {},
          grid: {
            left: '3%',
            right: '4%',
            bottom: '35%',
            containLabel: true
          },
          dataset: {
              // 这里指定了维度名的顺序，从而可以利用默认的维度到坐标轴的映射。
              // 如果不指定 dimensions，也可以通过指定 series.encode 完成映射，参见后文。
              source: data
          },
          xAxis: { type: 'category' },
          yAxis: { gridIndex: 0 },
          series: series
        };

        var myChartPie2 = echarts.init(document.getElementById("chartsPie2"));
        chartsOption && myChartPie2.setOption(chartsOption, true);
  });

      $.post(uploadURL + "/public/getMockRpt",{refID:g4, startDate:$("#searchChartsStartDate").val(), endDate:$("#searchChartsEndDate").val(), mark:mark, fromID:fromID},function(data){
        //var data = {title:['2021-10-01', '2021-10-02', '2021-10-03', '2021-10-04', '2021-10-05', '2021-10-06', '2021-10-07', '2021-10-08', '2021-10-09', '2021-10-10'],list:[{key:"社会",val:[320, 302, 301, 334, , 330, 320, 302, , 334]},{key:"中石化",val:[120, , 101, 134, 90, 230, 210, 132, , 134]},{key:"地铁",val:[220, 182, 191, 234, 290, 330, 310, 191, , 290]}]};
        var series = new Array();
        var obj;
        for(var i=0; i < data.length; i++){
            if(i>0){
              obj = {
                type: 'line',
                smooth: true,
                seriesLayoutBy: 'row',
                emphasis: { focus: 'series' }
              };
              series.push(obj);
            }
        };
        
        var chartsOption = {
          title: {
            text: '模拟考试成绩',
            left: 'center',
            top: 5
          },
          legend: {
            type: "plain", // 图例的类型 'plain':普通图例  'scroll':可滚动翻页的图例
            bottom: 0
          },
          tooltip: {},
          grid: {
            left: '3%',
            right: '4%',
            bottom: '35%',
            containLabel: true
          },
          dataset: {
              // 这里指定了维度名的顺序，从而可以利用默认的维度到坐标轴的映射。
              // 如果不指定 dimensions，也可以通过指定 series.encode 完成映射，参见后文。
              source: data
          },
          xAxis: { type: 'category' },
          yAxis: { gridIndex: 0 },
          series: series
        };

        var myChartPie3 = echarts.init(document.getElementById("chartsPie3"));
        chartsOption && myChartPie3.setOption(chartsOption, true);
  });
}

	
	