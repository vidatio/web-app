angular.module('vidatio').service("MapService", function () {
    function Map() {
      this.markers = {};
    }

    Map.prototype.setMarkers = function (data) {
      // safely removes all attributes to keep databinding alive
      for(var property in this.markers) {
        delete this.markers[property];
      }

      data.forEach(function(element,index,array){
        this.markers[index] = {
          lat: parseFloat(element[0]),
          lng: parseFloat(element[1])
        }
      }.bind(this));
    };

    return new Map;
  }
);
