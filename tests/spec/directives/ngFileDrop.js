describe('Directive', function() {
  describe('ngFileDrop', function() {
    var scope, element;

    //mock Application to allow us to inject our own dependencies
    beforeEach(module('vidatio'));

    //mock the controller for the same reason and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller, $compile){
      //create an empty scope
      scope = $rootScope.$new();

      //declare the controller and inject our empty scope
      $controller('FileReadCtrl', {$scope: scope});

      //mock the function scope.getFile
      spyOn(scope, 'getFile').and.callFake(function(){});

      //combine template and scope
      element = $compile('<div id="drop-zone" ng-file-drop="onFileDrop($file)">Drop Files Here</div>')(scope);
      spyOnEvent($(element), 'drop');

      //mock drop event listener, because event.dataTransfer can not be set manually
      $(element).on('drop', function() {
        scope.getFile();
        return false;
      });
    }));

    it("should create file reader", function() {
      $(element).trigger('drop');
      expect('drop').toHaveBeenTriggeredOn($(element));
      expect(scope.getFile).toHaveBeenCalled();
    });
  });
});
