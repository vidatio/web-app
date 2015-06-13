describe('Controller', function () {
  describe('Map', function () {
    describe('read file via link', function () {
      var scope, DataTable, Map;

      //mock Application to allow us to inject our own dependencies
      beforeEach(module('vidatio'));

      //mock the controller for the same reason and include at least $rootScope and $controller
      beforeEach(inject(function ($rootScope, $controller, DataTableService, MapService) {
        scope = $rootScope.$new();
        DataTable = DataTableService;
        Map = MapService;

        //declare the controller and inject our empty scope
        $controller('MapCtrl', {$scope: scope, DataTableService: DataTable, MapService: Map});

        //Create Map Spy
        spyOn(Map, 'setMarkers');
      }));

      it('should define a center on the scope variable', function () {
        expect(scope.center).toBeDefined();
        expect(scope.center.lat).toBeDefined();
        expect(scope.center.lng).toBeDefined();
        expect(scope.center.zoom).toBeDefined();
      });

      it('should pass the rows of the datatable to the map service', function () {
        var rows = [["00", "01"], ["10", "11"]];
        DataTable.dataset = rows;
        scope.$digest();

        expect(Map.setMarkers).toHaveBeenCalled();
        expect(Map.setMarkers).toHaveBeenCalledWith(rows);
      });
    });
  });
});
