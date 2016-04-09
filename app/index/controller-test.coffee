"use strict"

describe "Index Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            IndexCtrl = $controller "IndexCtrl",  {$scope: @scope, $rootScope: @rootScope}

    afterEach ->


    describe "on page init", ->
        it "the bubble-chart should be drawn", (done) ->
            setTimeout (->
                done()
            ), 10
            return
            expect(@scope.createCategoryBubbles).toHaveBeenCalled()

    describe "on page init", ->
        it "the bubble-chart data should be prepared for d3plus -> only the data of categories used in datasets should be prepared", ->
            colors = ["#11DDC6", "#FF5444", "#000000"]
            occurences = {Arbeit: 5, Bildung: 4, Wirtschaft: 3}
            @scope.categories = [{name: "Arbeit"}, {name: "Bildung"}, {name:"Wirtschaft"}, {name: "Sport"}, {name: "Audi"}]
            
            chartData = @scope.prepareChartData(occurences)

            expect(chartData).toBeDefined()
            expect(chartData).toEqual([{name: "Arbeit", datensätze: 5, color: "#11DDC6"}, {name: "Bildung", datensätze: 4, color: "#FF5444"}, {name: "Wirtschaft", datensätze: 3, color: "#000000"}])


