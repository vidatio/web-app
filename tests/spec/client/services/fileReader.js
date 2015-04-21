describe('Service', function() {
  describe('FileReader', function() {
    var scope;

    //mock Application to allow us to inject our own dependencies
    beforeEach(module('vidatio'));
    //mock the controller for the same reason and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller){
      //create an empty scope
      scope = $rootScope.$new();
      //declare the controller and inject our empty scope
      $controller('MainCtrl', {$scope: scope});

      scope.file = new Blob(["File test content"])

      FileReader.readAsDataUrl(scope.file, scope)
        .then(function (result) {
          scope.content = result;
        });
    }));

    it('check result', function() {

      expect(scope.content).toBe("Hello World!");
    });

    it('check result', function() {
      scope.$on("fileProgress", function (e, progress) {
        scope.progress = progress.loaded / progress.total;
      });

      expect(scope.progress).toBe(1);
    });
  });

});
