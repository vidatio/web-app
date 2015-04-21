describe('Service', function () {
  describe('FileReader', function () {
    var scope, rootScope, file;

    beforeEach(module('vidatio'));

    beforeEach(inject(function ($rootScope, $q, $controller, FileReader) {

      scope = $rootScope.$new();

      $controller('MainCtrl', {$scope: scope});

      rootScope = $rootScope;

      file = ["File test content"];
      var blob = new Blob(file, {type: 'text/html'});
      scope.file = blob;

      scope.progress = 0;

      var deferred = $q.defer();
      deferred.resolve(file[0]);

      spyOn(FileReader, 'readAsDataUrl').and.returnValue(deferred.promise);

      scope.$on("fileProgress", function (e, progress) {
        scope.progress = progress.loaded / progress.total;
      });

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

      expect(scope.progress).toBe(1);

      scope.$broadcast("fileProgress",
        {
            total: 10,
            loaded: 5
        });

      expect(scope.progress).toBe(0.5);
    });
  });

});
