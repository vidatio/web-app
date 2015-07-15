"use strict"

xdescribe "Controller Table", ->
    beforeEach ->

        module "app"
        inject ($controller, $rootScope, $compile) ->
            @scope = $rootScope.$new()

            @TableStub =
                setDataset: (result) ->

            @tableTag = $compile('<hot-table></hot-table>')(@scope)

            TableCtrl = $controller "TableCtrl", $scope: @scope, TableService: @TableStub

            $rootScope.$digest();

    it 'should resize the handsontable on resize the window', ->

        # There can't be a test, because the hot-table directive can't get compiled
        # like you can see it here
        # stackoverflow.com/questions/22306022/karma-compiling-angular-directive-in-test
        # or here http://angular-tips.com/blog/2014/06/introduction-to-unit-test-directives/
        # or here http://www.benlesh.com/2013/06/angular-js-unit-testing-directives.html
