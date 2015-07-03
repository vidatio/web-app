describe('Controller', function() {
  describe('DataTableCtrl', function() {
    var scope, DataTable, DataTableCtrl;

    //mock Application to allow us to inject our own dependencies
    beforeEach(module('vidatio'));

    //mock the controller for the same reason and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller, DataTableService){
      //create an empty scope
      scope = $rootScope.$new();
      //declare the controller and inject our empty scope
      DataTableCtrl = $controller('DataTableCtrl', {$scope: scope});
      
      DataTable = DataTableService;

      dataset = "Montag,5\nDienstag,2\nMittwoch,4";
      DataTable.setDataset(dataset);
    }));

    it('should set data table content', function() {
      expect(DataTable.dataset).toEqual([["Montag", "5"], ["Dienstag", "2"], ["Mittwoch", "4"]])
    });
  });

});
