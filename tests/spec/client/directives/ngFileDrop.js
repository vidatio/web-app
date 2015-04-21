describe('Controller', function() {
  describe('MainCtrl', function() {
    var scope;

    //mock Application to allow us to inject our own dependencies
    beforeEach(module('vidatio'));
    //mock the controller for the same reason and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller){
      //create an empty scope
      scope = $rootScope.$new();
      //declare the controller and inject our empty scope
      $controller('MainCtrl', {$scope: scope});
    }));

    it('should print hello world', function() {
      expect(scope.message).toBe("Hello World!");
    });
  });

});
