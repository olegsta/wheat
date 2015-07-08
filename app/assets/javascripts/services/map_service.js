app.service('YandexMaps', ['pluralize', '$http', function(pluralize, $http) {
  var YandexMaps = this, cluster;

  YandexMaps.registerFilters = function () {
    ymaps.template.filtersStorage.add('position_pluralize', function (data, count, filterValue) {
      return pluralize(count, ["позиция", "позиции", "позиций"]);
    });
    
    ymaps.template.filtersStorage.add('marker_color', function (data, count, filterValue) {
      var name = "";
      if (count < 5) {
        name = 'small';
      } else if (count < 15) {
        name = 'medium';
      } else if (count < 25) {
        name = 'large';
      } else {
        name = 'extra';
      }
      return name;
    });
  }

  YandexMaps.registerTemplates = function () {
    YandexMaps.markerLayout = ymaps.templateLayoutFactory.createClass(
      "<div class='marker-label'>"
          + "<div class='marker-label__head'>Купить 300 т, 8000 руб/т</div>"
          + "<div class='marker-label__body'>{{ properties.title }}</div>"
      + "</div>",
      {
        build: function () {
          YandexMaps.markerLayout.superclass.build.call(this);

          this._events = ymaps.domEvent.manager.group(this.getElement());
          this._events.add('click', function () {
              alert("Модальное окно позиции");
          }, this);
        },
        
        clear: function () {
          this._events.removeAll();
          YandexMaps.markerLayout.superclass.clear.call(this);
        }
      }
    );

    YandexMaps.clustererLayout = ymaps.templateLayoutFactory.createClass(
      "<div class='marker-label cluster cluster__{{properties.geoObjects.length | marker_color}}'>"
          + "<div class='marker-label__body'>{{properties.geoObjects.length}} {{properties.geoObjects.length | position_pluralize}}</div>"
      + "</div>", {
      getShape: function () {
        if (!this.getParentElement()) return null;
        
        var width = this.getParentElement().querySelector('.marker-label__body').offsetWidth;

        return new ymaps.shape.Rectangle(new ymaps.geometry.pixel.Rectangle([[0, -14], [width, 11]]));
      }
    });
  }

  YandexMaps.create = function () {
    YandexMaps.registerFilters();
    YandexMaps.registerTemplates();

    YandexMaps.map = new ymaps.Map('map', {
        center: [55.7, 37.6],
        zoom: 10,
        controls: []
      }, {
        suppressMapOpenBlock: true
    });

    YandexMaps.clusterer = new ymaps.Clusterer({
      clusterIconLayout: YandexMaps.clustererLayout,
      gridSize: 128
    });
  }

  YandexMaps.drawMarkers = function (points) {
    var geoObjects = [];
    for(var i = 0, len = points.length; i < len; i++) {
      geoObjects.push(new ymaps.Placemark(
        points[i][0], {title: points[i][1]}, {
            iconLayout: YandexMaps.markerLayout,
            iconPane: 'overlaps'
        })
      );
    }

    YandexMaps.clusterer.add(geoObjects);
    YandexMaps.map.geoObjects.add(YandexMaps.clusterer);
  }

}])