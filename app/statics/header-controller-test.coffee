"use strict"

describe "Header Controller", ->
    beforeEach ->

        module "app"

        inject ($controller, $rootScope, $httpBackend, DataService, $compile) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()

            HeaderCtrl = $controller "HeaderCtrl", {$scope: @scope, $rootScope: @rootScope, DataService: @Data}



