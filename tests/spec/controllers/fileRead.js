describe('Controller', function () {
  describe('FileReadCtrl', function () {
    describe('read file via browsing and drag & drop', function () {
      var scope, rootScope;

      //mock Application to allow us to inject our own dependencies
      beforeEach(module('vidatio'));

      //mock the controller for the same reason and include $rootScope and $controller
      beforeEach(inject(function ($rootScope, $controller, $q, FileReader) {
        //create an empty scope
        scope = $rootScope.$new();
        rootScope = $rootScope;

        //declare the controller and inject our empty scope
        $controller('FileReadCtrl', {$scope: scope});

        //create promise and set it's return value
        var deferred = $q.defer();
        deferred.resolve("aaa: 123; bbb: 456");

        spyOn(FileReader, 'readAsDataUrl').and.returnValue(deferred.promise);
      }));

      // ***
      // scope.content was only for testing purposes
      // got replaced by the data table
      // ***
      
      // it('should get the content of a file', function () {
      //   var scopeContent = ["aaa: 123; bbb: 456"];
      //   var blob = new Blob(scopeContent, {type: 'text/html'});
      //   scope.file = blob;

      //   scope.getFile();
      //   rootScope.$apply();
      //   expect(scope.content).toBe(scopeContent[0]);
      // });

      it('should update the progress value', function () {
        scope.$broadcast("fileProgress", {
          total: 10,
          loaded: 10
        });
        expect(scope.progress).toBe(1);

        scope.$broadcast("fileProgress", {
          total: 10,
          loaded: 5
        });
        expect(scope.progress).toBe(0.5);
      });
    });

    describe('read file via link', function () {
      var scope, httpBackend;

      //mock Application to allow us to inject our own dependencies
      beforeEach(module('vidatio'));

      //mock the controller for the same reason and include $rootScope and $controller
      beforeEach(inject(function ($rootScope, $controller, $httpBackend) {
        httpBackend = $httpBackend;

        //create an empty scope
        scope = $rootScope.$new();

        //declare the controller and inject our empty scope
        $controller('FileReadCtrl', {$scope: scope});
      }));

      it('should get the content of a file', function () {
        httpBackend.whenGET("/api?url=test.txt").respond("aaa: 123; bbb: 456");

        scope.link = "test.txt";

        scope.load();
        httpBackend.flush();
        expect(scope.content).toBe("aaa: 123; bbb: 456");
      });
    });
  });
});
