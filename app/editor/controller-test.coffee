"use strict"

describe "Editor Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            EditorCtrl = $controller "EditorCtrl",  {$scope: @scope, $rootScope: @rootScope}

    describe "on clicked tab", ->
        it 'should set the showTableView and showVisualizationView variables accordingly', ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""

            @scope.tabClicked(0)
            expect(@rootScope.showTableView).toBeTruthy()
            expect(@rootScope.showVisualizationView).toBeFalsy()

            @scope.tabClicked(1)
            expect(@rootScope.showTableView).toBeTruthy()
            expect(@rootScope.showVisualizationView).toBeTruthy()

            @scope.tabClicked(2)
            expect(@rootScope.showTableView).toBeFalsy()
            expect(@rootScope.showVisualizationView).toBeTruthy()




