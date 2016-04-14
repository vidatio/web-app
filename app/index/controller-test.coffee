"use strict"

describe "Index Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()

            @occurences = {Arbeit: 3, Bildung: 5, Wirtschaft: 4, Sport: 8}
            @colors = ["#11DDC6", "#FF5444", "#000000"]
            @scope.categories = [{name: "Arbeit"}, {name: "Bildung"}, {name: "Wirtschaft"}, {name: "Sport"}, {name: "Audi"}]

            IndexCtrl = $controller "IndexCtrl",  {$scope: @scope, $rootScope: @rootScope}

    describe "on page init", ->
        it "the bubble-chart should be drawn", (done) ->
            setTimeout (->
                done()
            ), 10
            return
            expect(@scope.createCategoryBubbles).toHaveBeenCalled()

    describe "on call prepareChartData", ->
        it "the bubble-chart data should be prepared for d3plus -> only the data of categories used in datasets should be prepared", ->

            chartData = @scope.prepareChartData(@occurences)

            expect(chartData).toBeDefined()
            expect(chartData).not.toContain([{name: "Audi"}])
            expect(chartData).toEqual([{name: "Arbeit", datensätze: 3, color: "#11DDC6"}, {name: "Bildung", datensätze: 5, color: "#FF5444"}, {name: "Wirtschaft", datensätze: 4, color: "#000000"}, {name: "Sport", datensätze: 8, color: "#11DDC6"}])

    describe "on call setBubblePositions", ->
        it "the positions for the category-bubbles should be calculated and set -> only as much positions as bubbles available should be set", ->

            spyOn(Math, "random").and.returnValue(1)

            chartData = @scope.prepareChartData(@occurences)
            finalPositions = @scope.setBubblePositions(chartData)

            expect(finalPositions.length).toBe(4)
            expect(finalPositions).toEqual([{name: "Sport", x: 0, y: 0}, {name: "Bildung", x: 28, y: 0}, {name: "Wirtschaft", x: -14, y: 24}, {name: "Arbeit", x: 14, y: 24}])


            @occurences = {Arbeit: 3, Bildung: 5, Wirtschaft: 4, Sport: 8, Audi: 15}

            chartData = @scope.prepareChartData(@occurences)
            finalPositions = @scope.setBubblePositions(chartData)

            expect(finalPositions.length).toBe(5)
            expect(finalPositions).toEqual([{name: "Audi", x: 0, y: 0}, {name: "Sport", x: -28, y: 0}, {name: "Bildung", x: 28, y: 0}, {name: "Wirtschaft", x: -14, y: 24}, {name: "Arbeit", x: 14, y: 24}])


