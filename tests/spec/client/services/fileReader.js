describe('Service', function () {
  describe('FileReader', function () {
    var scope, rootScope, file;

    beforeEach(module('vidatio'));

    beforeEach(inject(function ($rootScope, $q, $controller, FileReader) {
      //create an empty scope
      scope = $rootScope.$new();
      //declare the controller and inject our empty scope
      $controller('MainCtrl', {$scope: scope});

      rootScope = $rootScope;
      //initialize test file 
      file = ["File test content"];
      var blob = new Blob(file, {type: 'text/html'});
      scope.file = blob;

      scope.progress = 0;
      //create promise and set it's return value
      var deferred = $q.defer();
      deferred.resolve(file[0]);

      spyOn(FileReader, 'readAsDataUrl').and.returnValue(deferred.promise);
      //mock fileProgress funtion to return progress status
      scope.$on("fileProgress", function (e, progress) {
        scope.progress = {loaded: progress.loaded, total: progress.total};
      });
      //use of FileReader mock
      FileReader.readAsDataUrl(scope.file, scope)
        .then(function (result) {
          scope.content = result;
        });
    }));

    it('should read data of the file', function () {
      rootScope.$apply();
      expect(scope.content).toBe(file[0]);
    });

    it('should have progress finished at the end', function () {
      rootScope.$apply();
      // because of promises the broadcast of the service is never called, 
      // so we have to run a broadcast
      scope.$broadcast("fileProgress",
        {
            total: 10,
            loaded: 10
        });

      expect(scope.progress.loaded).toBe(10);
      expect(scope.progress.total).toBe(10);

      scope.$broadcast("fileProgress",
        {
            total: 10,
            loaded: 5
        });

      expect(scope.progress.loaded).toBe(5);
      expect(scope.progress.total).toBe(10);
    });
  });

});
