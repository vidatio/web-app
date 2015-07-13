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
            inject ($rootScope, $controller, $compile, $injector) ->
                @injector = $injector
                @scope = $rootScope.$new()
                @element = $compile('<input type="file" ng-file-select>')(@scope)
                $controller 'ImportCtrl', $scope: @scope
                spyOn(@scope, 'getFile').and.callFake ->

        it "should exist in the injector", ->
            expect(@injector.has('ngFileSelectDirective')).toBeTruthy()

        it "should listen to the change event", ->
            event = document.createEvent('CustomEvent')
            event.initCustomEvent('change', false, false, null)
            @element[0].dispatchEvent event
            expect(@scope.getFile).toHaveBeenCalled()

    describe "ngFileDropStart", ->
        beforeEach ->
            module "app"
            inject ($rootScope, $controller, $compile, $injector) ->
                @injector = $injector
                @scope = $rootScope.$new()
                @element = $compile('<div id="drop-zone" ng-file-drop-start></div>')(@scope)
                $controller 'ImportCtrl', $scope: @scope
                spyOn(@scope, 'getFile').and.callFake ->

        it "should exist in the injector", ->
            expect(@injector.has('ngFileDropStartDirective')).toBeTruthy()

        # DispatchEvent always returns true, not according to
        # https://developer.mozilla.org/de/docs/Web/API/EventTarget/dispatchEvent
        xit "should listen to the dragover event", ->
            event = document.createEvent('CustomEvent')
            event.initCustomEvent('dragover', false, false, null)
            expect(@element[0].dispatchEvent event).toBeFalsy()

        it "should listen to the dragover event", ->
            document.body.appendChild(@element[0]);
            event = document.createEvent('CustomEvent')
            event.initCustomEvent('dragenter', false, false, null)
            @element[0].dispatchEvent event
            expect(@element[0].style.display).toEqual "block"

    describe "ngFileDropEnd", ->
        beforeEach ->
            module "app"
            inject ($rootScope, $controller, $compile, $injector) ->
                @injector = $injector
                @scope = $rootScope.$new()
                @element = $compile('<div id="drop-zone" ng-file-drop-end></div>')(@scope)
                $controller 'ImportCtrl', $scope: @scope
                spyOn(@scope, 'getFile').and.callFake ->

        it "should exist in the injector", ->
            expect(@injector.has('ngFileDropEndDirective')).toBeTruthy()
