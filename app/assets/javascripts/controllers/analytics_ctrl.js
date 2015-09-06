app.controller('AnalyticsCtrl', ['$scope', 'Page', function ($scope, Page) {
  var analytics = this;

  Page.current = 'analytics';

  var chart = new Highcharts.Chart({
      chart: {
          type: 'bar',
          renderTo: 'container'
      },
      title: {
          text: 'Соотношение спроса и предложения'
      },
      xAxis: {
          categories: _.pluck(gon.data.options, 'title')
      },
      yAxis: {
          min: 0,
          title: {
              text: ''
          }
      },
      legend: {
          reversed: true
      },
      plotOptions: {
          series: {
              stacking: 'percent'
          }
      },
      series: [{
          name: 'Предложение',
          data: [2, 2, 3, 2, 1],
          color: '#D9D9D9'
      },{
          name: 'Спрос',
          data: [5, 3, 4, 7, 2],
          color: '#7FBF3F'
      }]
  });
}])