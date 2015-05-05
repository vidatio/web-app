describe('Controller', function() {
  describe('DataTableCtrl', function() {
    var scope, DataTable, DataTableCtrl;

    //mock Application to allow us to inject our own dependencies
    beforeEach(module('vidatio'));

    //mock the controller for the same reason and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller, _DataTable_){
      //create an empty scope
      scope = $rootScope.$new();
      //declare the controller and inject our empty scope
      DataTableCtrl = $controller('DataTableCtrl', {$scope: scope});

      // scope.afterInit = function() {
      //   table = {
      //     loadData: function(){}
      //   };
      // };

      // spyOn(scope, 'afterInit').and.callFake(function(){
      //   table = {
      //     loadData: function(){}
      //   };
      // });
      
      DataTable = _DataTable_;
      dataset = "Montag,5\nDienstag,2\nMittwoch,4";
      DataTable.setDataset(dataset);
    }));

    it('should set data table content', function() {
      // scope.$broadcast("datasetChanged", {});
      // expect(scope.rows).toBe();
      // console.log(scope.rows);
    });
  });

});
