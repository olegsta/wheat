app.service('YandexMaps', ['pluralize', '$location', '$http', function(pluralize, $location, $http) {
  var YandexMaps = this, cluster;

  window.YandexMaps = this;

  YandexMaps.geoObjects = [];

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
      "<a class='marker-label'>"
          + "<div class='marker-label__head'>{{ properties.trade_type }} {{ properties.weight }} {{ properties.weight_dimension }}, {{ properties.price }} {{ properties.currency }}/{{ properties.price_weight_dimension }}</div>"
          + "<div class='marker-label__body'>{{ properties.title }}</div>"
      + "</a>",
      {
        build: function () {
          YandexMaps.markerLayout.superclass.build.call(this);
          this._events = ymaps.domEvent.manager.group(this.getElement());
          this._events.add('click', function (event) {
            if (this.getData().properties.get('id'))
              $location.search({id: this.getData().properties.get('id')})
            console.log(this.getData().properties.get('coords'))
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

  YandexMaps.create = function (id) {
    YandexMaps.registerFilters();
    YandexMaps.registerTemplates();

    YandexMaps.map = new ymaps.Map(id, {
        center: [55.7, 37.6],
        zoom: 10,
        controls: [],
      }, {
        maxZoom: 15,
        // minZoom: 7,
        suppressMapOpenBlock: true,
    });

    // YandexMaps.map.controls.add(new ymaps.control.RulerControl())

    YandexMaps.clusterer = new ymaps.Clusterer({
      clusterIconLayout: YandexMaps.clustererLayout,
      gridSize: 256
    });
  }

  YandexMaps.drawMarkers = function (points, options) {
    YandexMaps.map.geoObjects.removeAll();
    YandexMaps.clusterer.removeAll();

    if (points.length) {
      var result;
      YandexMaps.geoObjects = [];
      for(var i = 0, len = points.length; i < len; i++) {
        var coords = options.short ? [points[i][1], points[i][2]] : [points[i].lat, points[i].lng],
            properties = options.short ? YandexMaps.shortMarkerProperties(points[i]) : YandexMaps.markerProperties(points[i])

        YandexMaps.geoObjects.push(new ymaps.Placemark(
          coords, properties, {
              iconLayout: YandexMaps.markerLayout,
              iconPane: 'overlaps',
              draggable: options.draggable
          })
        );
      }

      if (points.length > 1) {
        YandexMaps.clusterer.add(YandexMaps.geoObjects);
        YandexMaps.map.geoObjects.add(YandexMaps.clusterer);
        result = YandexMaps.geoObjects;
      } else {
        YandexMaps.map.geoObjects.add(YandexMaps.geoObjects[0]);
        result = YandexMaps.geoObjects[0]
      }
      return result;
    }

    return points
  }

  YandexMaps.markerProperties = function (point) {
    var title = gon.group.options[point.option_id],
        weight_dimension = gon.group.weight_dimensions[point.weight_dimension_id || 1].title,
        price_weight_dimension = gon.group.weight_dimensions[point.price_weight_dimension_id || 1].title;

    var result = {
      id: point.id,
      trade_type: gon.group.trade_types[point.trade_type_id] || "Тип",
      title: title ? title.title : "Категория",
      weight: point.weight || 0,
      weight_dimension: weight_dimension,
      price: point.price || 0,
      currency: gon.user.currency.title,
      price_weight_dimension: price_weight_dimension
    }

    return result;
  }

  YandexMaps.shortMarkerProperties = function (point) {
    var title = gon.group.options[point[4]],
        weight_dimension = gon.group.weight_dimensions[point[6] || 1].title,
        price_weight_dimension = gon.group.weight_dimensions[point[9] || 1].title;

    var result = {
      id: point[0],
      trade_type: gon.group.trade_types[point[3]] || "Тип",
      title: title ? title.title : "Категория",
      weight: point[5] || 0,
      weight_dimension: weight_dimension,
      price: (point[7] * gon.data.rates[point[8]].rate).toFixed(2) || 0,
      currency: gon.user.currency.title,
      price_weight_dimension: price_weight_dimension,
      coords: [point[1], point[2]]
    }

    return result;
  }

  YandexMaps.createCircle = function (coords, radius) {
    var circle = new ymaps.Circle([
      // Координаты центра круга
      coords,
      // Радиус круга в метрах
      radius
    ], {}, {
      fillColor: 'rgba(255, 219, 76, 0.5)',
      strokeColor: 'rgba(215, 185, 64, 0.6)'
    });

    return circle;
  }

  YandexMaps.addCircleToMap = function (circles) {
    _.each(circles, function (circle) {
      if (circle.geometry.getRadius())
        YandexMaps.map.geoObjects.add(circle);
    });

    if (YandexMaps.map.geoObjects.getLength())
      YandexMaps.map.setBounds(YandexMaps.map.geoObjects.getBounds());
      // YandexMaps.map.setZoom(YandexMaps.map.getZoom()-1);
  }

  YandexMaps.deleteCircleFromMap = function (circle) {
    YandexMaps.map.geoObjects.remove(circle);
  }

}])