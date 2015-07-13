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
                document.body.appendChild(@element[0])
                $controller 'ImportCtrl', $scope: @scope
                spyOn(@scope, 'getFile').and.callFake ->

        it "should exist in the injector", ->
            expect(@injector.has('ngFileSelectDirective')).toBeTruthy()

        # Drag over event not tested, because DispatchEvent always returns true, not according to
        # https://developer.mozilla.org/de/docs/Web/API/EventTarget/dispatchEvent

        it "should listen to the dragover event", ->
            event = document.createEvent('CustomEvent')
            event.initCustomEvent('dragenter', false, false, null)
            @element[0].dispatchEvent event
            expect(@element[0].style.display).toEqual "block"

        afterEach ->
            element = document.getElementById "drop-zone"
            element.parentNode.removeChild element

    describe "ngFileDropEnd", ->
        beforeEach ->
            module "app"
            inject ($rootScope, $controller, $compile, $injector) ->
                @injector = $injector
                @scope = $rootScope.$new()
                @element = $compile('<div id="drop-zone" ng-file-drop-end></div>')(@scope)
                document.body.appendChild(@element[0])

                $controller 'ImportCtrl', $scope: @scope
                spyOn(@scope, 'getFile').and.callFake ->

        it "should exist in the injector", ->
            expect(@injector.has('ngFileDropEndDirective')).toBeTruthy()

        it "should listen to the dragleave event", ->
            event = document.createEvent('CustomEvent')
            event.initCustomEvent('dragleave', false, false, null)
            @element[0].dispatchEvent event
            expect(@element[0].style.display).toEqual "none"

        ## DragOver event not tested, because DispatchEvent always returns true, not according to
        # https://developer.mozilla.org/de/docs/Web/API/EventTarget/dispatchEvent

        ## Drop event not tested, because init event doesn't allow setting dataTransfer attribute

        afterEach ->
            element = document.getElementById "drop-zone"
            element.parentNode.removeChild element
