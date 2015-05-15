describe('Controller', function () {
  describe('FileReadCtrl', function () {
    describe('read file via browsing and drag & drop', function () {
      var scope, FileReader;

      //mock Application to allow us to inject our own dependencies
      beforeEach(module('vidatio'));

      //mock the controller for the same reason and include $rootScope and $controller
      beforeEach(inject(function ($rootScope, $controller, $q, FileReaderService) {
        //create an empty scope
        scope = $rootScope.$new();

        //declare the controller and inject our empty scope
        $controller('FileReadCtrl', {$scope: scope});

        FileReader = FileReaderService;
      }));

      it('should update the progress value', function () {        scope.$apply();
        FileReader.progress = 0.1;
        scope.$apply();
        expect(scope.progress).toBe(0.1);
        scope.$apply();
        FileReader.progress = 0.5;
        scope.$apply();
        expect(scope.progress).toBe(0.5);
      });
    });

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

        expect(DataTable.dataset).toEqual([["test","1"],["test","2"],["test","3"]]);
      });
    });
  });
});
