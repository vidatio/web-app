# File Reader Directive Test
# =================

"use strict"

# what to test:
#   - directive created?
#   - events at elements?

describe "Directive Import", ->

    describe "ngFileSelect", ->

        beforeEach ->
            module "app"
            inject ($rootScope, $controller, $compile) ->
                @scope = $rootScope.$new()
                @element = $compile('<input type="file" ng-file-select>')(@scope)
                $controller 'ImportCtrl', $scope: @scope
                spyOn(@scope, 'getFile').and.callFake ->

        it "should have a directive created", ->
            expect(@element).toExist()

        it "should listen to the change event", ->
            event = document.createEvent('CustomEvent')
            event.initCustomEvent('change', false, false, null)
            @element[0].dispatchEvent event
            expect(@scope.getFile).toHaveBeenCalled()

    describe "ngFileDropStart", ->

        beforeEach ->
        module "app"
        inject ($rootScope, $controller, $compile) ->
            @scope = $rootScope.$new()
            @element = $compile('<div id="drop-zone" ng-file-drop></div>')(@scope)
            $controller 'ImportCtrl', $scope: @scope
            spyOn(@scope, 'getFile').and.callFake ->


    describe "ngFileDropEnd", ->

        beforeEach ->
        module "app"
        inject ($rootScope, $controller, $compile) ->
            @scope = $rootScope.$new()
            @element = $compile('<div id="drop-zone" ng-file-drop></div>')(@scope)
            $controller 'ImportCtrl', $scope: @scope
            spyOn(@scope, 'getFile').and.callFake ->
