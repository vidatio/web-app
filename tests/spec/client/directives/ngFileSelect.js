//Source: http://www.tuesdaydeveloper.com/2013/06/angularjs-testing-with-karma-and-jasmine/

describe('Directive', function() {
  describe('ngFileSelect', function() {
    var scope;
    var mockFileReader;

    //mock Application to allow us to inject our own dependencies
    beforeEach(module('vidatio'));

    beforeEach(module(function($provide){
      $provide.service('FileReader', function() {
        this.readAsDataUrl = jasmine.createSpy('readAsDataUrl').and.callFake(function(file,scope) {
          //a fake implementation
        });
      });
    }));
    //mock the controller for the same reason and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller, $compile, $window, FileReader){
      //create an empty scope
      scope = $rootScope.$new();
      //declare the controller and inject our empty scope
      $controller('FileReadCtrl', {$scope: scope});

      windowMock = $window;
      compile = $compile;

      mockFileReader = FileReader;
    }));

    it("should create file reader", function() {
      var elm = compile('<input type="file" ng-file-select="onFileSelect($files)">')(scope);
      var div = elm[0];
      div.files = ['test-data.txt'];
      div.dispatchEvent(new CustomEvent('change'));
      expect(mockFileReader.readAsDataUrl).toHaveBeenCalled();
      });

  });

});
