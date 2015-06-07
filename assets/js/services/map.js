angular.module('vidatio').service("MapService", function () {
    function Map() {
      this.markers = {};
    }

    Map.prototype.isCoordinate = function (value){
      var value = parseFloat(value);
      return value === Number(value) && value >= 0 && value <= 180;
    };

    Map.prototype.setMarkers = function (data) {
      // safely removes all attributes to keep databinding alive
      for (var property in this.markers) {
        delete this.markers[property];
      }

      // update markers
      var length = 0;
      data.forEach(function (element, index, array) {
          var lat =  parseFloat(element[0]);
          var lng =  parseFloat(element[1]);

          if (this.isCoordinate(lat) && this.isCoordinate(lng)) {
            this.markers[length++] = {
              lat: lat,
              lng: lng
            }
          }
        }.bind(this)
      );
    };

    return new Map;
  }
)
;
