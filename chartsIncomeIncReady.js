	var chartsincomeListLong = 0;		//0: 标准栏目  1：短栏目
    //var echarts = require('echarts');
    //var myChart = echarts.init($("#chartsIncomeCover"));

	$(document).ready(function (){
      getComList("searchChartsIncomeCert","certificateInfo","certID","shortName","status=0 and type=0 order by certID",1);
      if(checkRole("saler")){
          getComList("searchChartsIncomeFromID","userInfo","username","realName","status=0 and username='" + currUser + "' order by realName",0);
      }else{
          getComList("searchChartsIncomeFromID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='saler') order by realName",1);
      }
      $("#searchChartsIncomeStartDate").click(function(){WdatePicker();});
      $("#searchChartsIncomeEndDate").click(function(){WdatePicker();});
      $("#searchChartsIncomeStartDate").val(addDays(currDate,-183));
      $("#searchChartsIncomeEndDate").val(currDate);
      $("#btnSearchChartsIncome").click(function(){
				if($("#searchChartsIncomeStartDate").val()>"" && $("#searchChartsIncomeEndDate").val()>""){
					getChartsIncome();
				}else{
					jAlert("请选择日期范围。");
				}
      });
      //if(checkRole("leader")){
      //  getChartsIncome();
      //}
      $('input[type=radio][name=rptChartsIncomeDate]').change(function() {
        if(this.value==1){
          //this week
          $("#searchChartsIncomeStartDate").val(addDays(currDate,-7));
          $("#searchChartsIncomeEndDate").val(currDate);
          $('input[name=rptChartsIncomeGroupDate][value=d]').prop("checked",true)
        }
        if(this.value==2){
          //this quater
          $("#searchChartsIncomeStartDate").val(addDays(currDate,-90));
          $("#searchChartsIncomeEndDate").val(currDate);
          $('input[name=rptChartsIncomeGroupDate][value=w]').prop("checked",true)
        }
        if(this.value==3){
          //half a year
          $("#searchChartsIncomeStartDate").val(addDays(currDate,-183));
          $("#searchChartsIncomeEndDate").val(currDate);
          $('input[name=rptChartsIncomeGroupDate][value=m]').prop("checked",true)
        }
        if(this.value==4){
          //one year
          $("#searchChartsIncomeStartDate").val(addDays(currDate,-365));
          $("#searchChartsIncomeEndDate").val(currDate);
          $('input[name=rptChartsIncomeGroupDate][value=m]').prop("checked",true)
        }
      });
	});

	function getChartsIncome(){
      var mark = 1;
      var fromID = "";
      if(checkRole("saler")){
          mark = 3;
          fromID = currUser;
      }
      if($("#searchChartsIncomeFromID").val()>""){
          fromID = $("#searchChartsIncomeFromID").val();
      }
      var g4 = $("input[name='rptChartsIncomeGroupDate']:checked").val();
      var total = 0;
      //alert((sWhere) + "&refID=" + $("#searchChartsIncomeCert").val() + "&status=" + $("#searchChartsIncomeStatus").val() + "&project=" + $("#searchChartsIncomeProject").val());
      $.post(uploadURL + "/public/getIncomeRpt",{refID:g4, certID:$("#searchChartsIncomeCert").val(), startDate:$("#searchChartsIncomeStartDate").val(), endDate:$("#searchChartsIncomeEndDate").val(), mark:mark, fromID:fromID},function(data){
            //var data = {title:['2021-10-01', '2021-10-02', '2021-10-03', '2021-10-04', '2021-10-05', '2021-10-06', '2021-10-07', '2021-10-08', '2021-10-09', '2021-10-10'],list:[{key:"社会",val:[320, 302, 301, 334, , 330, 320, 302, , 334]},{key:"中石化",val:[120, , 101, 134, 90, 230, 210, 132, , 134]},{key:"地铁",val:[220, 182, 191, 234, 290, 330, 310, 191, , 290]}]};
            var series = new Array();
            var obj;
            $("#chartsIncomeTotal").html("收费合计：" + data["total"].toLocaleString());
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
            var chartsincomeOption = {
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

            var myChart = echarts.init(document.getElementById("chartsIncomeCover"));
            chartsincomeOption && myChart.setOption(chartsincomeOption, true);

            chartsincomeOption = {
              title: {
                text: '来源分布',
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

            var myChartPie = echarts.init(document.getElementById("chartsIncomePie"));
            chartsincomeOption && myChartPie.setOption(chartsincomeOption, true);
          });

		  $.post(uploadURL + "/public/getIncomeRptPie1",{refID:g4, startDate:$("#searchChartsIncomeStartDate").val(), endDate:$("#searchChartsIncomeEndDate").val(), mark:mark, fromID:fromID},function(data){
            var chartsincomeOption = {
              title: {
                text: '培训项目分布',
                //subtext: '证书类别',
                left: 'center'
              },
              tooltip: {
                trigger: 'item',
                formatter: '{b}<br/>数量：{c} <br/>比例：{d}%'
              },
              series: [
                {
                  name: '项目名称',
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
            

            var myChartPie1 = echarts.init(document.getElementById("chartsIncomePie1"));
            chartsincomeOption && myChartPie1.setOption(chartsincomeOption, true);
		  });
}

	
	