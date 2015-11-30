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
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""
            @rootScope.activeViews = [true, false]
            #change the value in the callback function to start the $digest cycle
            @rootScope.$apply((rootScope) ->
                rootScope.activeViews = [false, true]
            )
            expect(@rootScope.showTableView).toBeFalsy()
            expect(@rootScope.showVisualizationView).toBeTruthy()




