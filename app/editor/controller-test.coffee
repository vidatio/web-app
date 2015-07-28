"use strict"

describe "Editor Controller", ->
    beforeEach ->

        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()

            EditorCtrl = $controller "EditorCtrl", $scope: @scope, $rootScope: @rootScope

    describe "on changed active views", ->
        it 'should set the showTableView, showVisualizationView and showShareView variables accordingly', ->
            @httpBackend.expectGET(/index/).respond ""
            @httpBackend.expectGET(/editor/).respond ""
            @rootScope.activeViews = [true, false, false]
            # change the value in the callback function to start the $digest cycle
            @rootScope.$apply((rootScope) ->
                rootScope.activeViews = [false, true, true]
            )
            expect(@rootScope.showTableView).toBeFalsy()
            expect(@rootScope.showVisualizationView).toBeTruthy()
            expect(@rootScope.showShareView).toBeTruthy()




