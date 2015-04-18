//Source: http://www.tuesdaydeveloper.com/2013/06/angularjs-testing-with-karma-and-jasmine/

describe('Directive', function() {
  describe('ngFileSelect', function() {
    var scope;

    //mock Application to allow us to inject our own dependencies
    beforeEach(module('vidatio'));
    //mock the controller for the same reason and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller){
      //create an empty scope
      scope = $rootScope.$new();
      //declare the controller and inject our empty scope
      $controller('FileReadCtrl', {$scope: scope});
    }));

  });

});
