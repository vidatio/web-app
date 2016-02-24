"use strict"

describe "Header Controller", ->
    beforeEach ->

        module "app"

        inject ($controller, $rootScope) ->
            @rootScope = $rootScope
            @scope = $rootScope.$new()

            HeaderCtrl = $controller "HeaderCtrl", $scope: @scope, $rootScope: @rootScope

    #describe "clicked tabs", ->
    #    it 'should change the active views', ->
    #        @scope.tabClicked(1)
    #        expect(@rootScope.activeViews[1]).toBeFalsy()
    #        @scope.tabClicked(1)
    #        expect(@rootScope.activeViews[1]).toBeTruthy()
