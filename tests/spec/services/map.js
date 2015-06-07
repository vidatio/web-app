describe('Service', function () {
  describe('Map', function () {
    var Map;

    beforeEach(module('vidatio'));

    beforeEach(inject(function (MapService) {
      Map = MapService;
    }));

    it('should update markers of the service', function () {
      var rows = [["00", "01"], ["10", "11"]];
      Map.setMarkers(rows);
      expect(Map.markers).toEqual({0: {lat: 00, lng: 01}, 1: {lat: 10, lng: 11}});

      var rows = [["error", 01], [999, "11"], [1, "00179"]];
      Map.setMarkers(rows);
      expect(Map.markers).toEqual({0: {lat: 1, lng: 179}});
    });

    it('should check if value is a potential coordinate', function () {
      expect(Map.isCoordinate(999)).toBeFalsy();
      expect(Map.isCoordinate("Error")).toBeFalsy();
      expect(Map.isCoordinate(-1)).toBeFalsy();
      expect(Map.isCoordinate(200)).toBeFalsy();

      expect(Map.isCoordinate(180)).toBeTruthy();
      expect(Map.isCoordinate(0)).toBeTruthy();
      expect(Map.isCoordinate("128")).toBeTruthy();
      expect(Map.isCoordinate("0")).toBeTruthy();
    });

    it('should have attribute markers defined', function () {
      expect(Map.markers).toBeDefined();
    });
  });
});
