"use strict"

describe "Header Controller", ->
    beforeEach ->

        module "app"

        inject ($controller, $rootScope) ->
            @rootScope = $rootScope
            @scope = $rootScope.$new()

            HeaderCtrl = $controller "HeaderCtrl", $scope: @scope, $rootScope: @rootScope
