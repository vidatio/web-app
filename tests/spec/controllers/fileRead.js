describe('Controller', function () {
  describe('FileReadCtrl', function () {
    describe('read file via browsing and drag & drop', function () {
      var scope, FileReader, rootScope;

      //mock Application to allow us to inject our own dependencies
      beforeEach(module('vidatio'));

      //mock the controller for the same reason and include $rootScope and $controller
      beforeEach(inject(function ($rootScope, $controller, $q, $http, FileReaderService, DataTableService) {
        //create an empty scope
        scope = $rootScope.$new();
        rootScope = $rootScope;
        FileReader = FileReaderService;

        //declare the controller and inject our empty scope
        $controller('FileReadCtrl', {
          $scope: scope,
          $http: $http,
          FileReaderService: FileReaderService,
          DataTableService: DataTableService
        });
      }));

      /**
       * INTEGRATION AND NO UNIT TEST
       * Maybe separate integrations tests later to own files
       */
      it('should update the progress value', function () {

        FileReader.progress = 0.1;
        rootScope.$apply();
        expect(scope.progress).toBe(0.1);
        rootScope.$apply();
        FileReader.progress = 0.5;
        rootScope.$apply();
        expect(scope.progress).toBe(0.5);
      });
    });
  });
});
