"use strict"

describe "Dataset Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Table =
                setDataset: (result) ->
            @Data =
                useSavedData: (data) ->

            DatasetCtrl = $controller "DatasetCtrl",  {$scope: @scope, $rootScope: @rootScope, TableService: @Table, DataService: @Data}

