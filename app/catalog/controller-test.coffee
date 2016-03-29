"use strict"

describe "Catalog Controller", ->
    beforeEach ->
        module "app"
        inject ($rootScope, $controller) ->
            @scope = $rootScope.$new()
            @CatalogCtrl = $controller "CatalogCtrl", { $scope: @scope }

        @scope.changeURL = ->
            true

    it "should be defined", ->
        expect(@CatalogCtrl).toBeDefined()

    it "should set a category", ->
        @scope.setCategory("Politik")

        expect(@scope.filter.category).toBe("Politik")

    it "should reset filters", ->
        @scope.filter =
            dates:
                from: new Date()
                to: new Date()
            category: "OGD"
            tags: ["myVidatio", "greatVisualization"]
            showMyVidatios: true

        expected =
            dates:
                from: ""
                to: ""
            category: ""
            tags: ""
            showMyVidatios: ""

        @scope.reset()

        expect(@scope.filter).toEqual(expected)
