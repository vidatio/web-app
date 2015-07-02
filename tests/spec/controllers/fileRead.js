describe('Controller', function () {
  describe('FileReadCtrl', function () {
    describe('read file via link', function () {
      var scope, httpBackend, DataTable;

      //mock Application to allow us to inject our own dependencies
      beforeEach(module('vidatio'));

      //mock the controller for the same reason and include $rootScope and $controller
      beforeEach(inject(function ($rootScope, $controller, $httpBackend, DataTableService) {
        httpBackend = $httpBackend;

        //create an empty scope
        scope = $rootScope.$new();

        //declare the controller and inject our empty scope
        $controller('FileReadCtrl', {$scope: scope});

        DataTable = DataTableService;
      }));

      it('should get the content of a file', function () {
        httpBackend.whenGET("/api?url=test.txt").respond("test,1\ntest,2\ntest,3");

        scope.link = "test.txt";

        scope.load();
        httpBackend.flush();

        expect(DataTable.dataset).toEqual([["test", "1"], ["test", "2"], ["test", "3"]]);
      });
    });
  });
});
