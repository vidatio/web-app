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
        it 'should set the showTableView and showVisualizationView variables accordingly', ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""
            @rootScope.activeTabs = [true, true]
            #change the value in the callback function to start the $digest cycle
            @rootScope.$apply((rootScope) ->
                rootScope.activeViews = [true, false]
            )
            expect(@rootScope.showTableView).toBeTruthy()
            expect(@rootScope.showVisualizationView).toBeTruthy()

    #describe "clicked tabs", ->
    #    it 'should change the active views', ->
    #        @scope.tabClicked(1)
    #        expect(@rootScope.activeTabs[1]).toBeFalsy()
    #        @scope.tabClicked(1)
    #        expect(@rootScope.activeTabs[1]).toBeTruthy()




