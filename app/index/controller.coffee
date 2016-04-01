"use strict"

app = angular.module "app.controllers"

app.controller "IndexCtrl", [
    "$scope"
    "$log"
    "CategoriesFactory"
    "DatasetsFactory"
    "$window"
    "$state"
    ($scope, $log, CategoriesFactory, DatasetsFactory, $window, $state) ->
        CategoriesFactory.query (response) ->
            $scope.categories = response

        , (error) ->
            $log.info "IndexCtrl error on query categories"
            $log.error error

        DatasetsFactory.query (response) ->
            $scope.vidatios = response

            categoryIDs = []

            for vidatio in $scope.vidatios
                if vidatio.metaData?.category?
                    categoryIDs.push(vidatio.metaData.category.name)

            $scope.chartData = prepareChartData(countOccurrences(categoryIDs))
            $scope.positions = setBubblePositions($scope.chartData)

            setTimeout ->
                createCategoryBubbles()
            , 250

        , (error) ->
            $log.info "IndexCtrl error on query datasets"
            $log.error error

        # Resizing the visualizations
        # using setTimeout to use only to the last resize action of the user
        id = null

        onWindowResizeCallback = ->
            # a new visualization should only be created when the visualization is visible in editor
            clearTimeout id
            id = setTimeout ->
                createCategoryBubbles()
            , 250

        # resize event only should be fired if user is currently in editor
        window.angular.element($window).on "resize", $scope.$apply, onWindowResizeCallback

        # resize watcher has to be removed when editor is leaved
        $scope.$on "$destroy", ->
            window.angular.element($window).off "resize", onWindowResizeCallback

        lastWidth = 0

        # @method createCategoryBubbles
        # @description set necessary parameters and draw categories bubble-visualization
        createCategoryBubbles = ->
            $chart = $("#bubble-categories")
            width = $chart.parent().width()

            # draw new visualization only when $chart.parents' width has changed, return otherwise
            if lastWidth is width
                return

            lastWidth = width

            $chart.empty()

            d3plus.viz()
            .container("#bubble-categories")
            .type("network")
            .data({
                "value": $scope.chartData,
                "opacity": 1
            })
            .nodes({
                "value": $scope.positions,
                "overlap": 0.5
            })
            .edges([])
            .id("name")
            .color("color")
            .size("datensätze")
            .width(width)
            .height(650)
            .legend(false)
            .font("family": "Colaborate")
            .messages("Die Kategorien werden geladen...")
            .focus("tooltip": false)
            .background("none")
            .mouse({
                "click": (category) ->
                    $state.go "app.catalog", {category: category.name}
            })
            .zoom(true)
            .draw()

        # @method countOccurrences
        # @description count the occurrences per category over all datasets
        countOccurrences = (categoriesArray) ->
            result = {}

            categoriesArray.forEach (category) ->
                result[category] = (result[category] or 0) + 1

            result

        # @method prepareChartData
        # @description prepare the necesssary data for d3plus according to our categories and their occurrences
        #               set name, size (= "Anzahl der Datensätze") and color for each bubble
        # @param {array}
        prepareChartData = (occurrences) ->
            chartData = []
            colors = ["#11dcc6", "#F2B1B1", "#FF5444", "#ABF4E9", "#FAFAFA"]
            currentColor = 0

            for category in $scope.categories

                if occurrences[category.name]?
                    chartData.push({"name": category.name, "datensätze": occurrences[category.name], "color": colors[currentColor]})

                currentColor++

                if currentColor is colors.length
                    currentColor = 0

            chartData

        # @method setBubblePositions
        # @description set the bubbles' positions according to the amount of datasets the respective category has
        #               the category with the most datasets is in the middle, the categories with the fewest datsets are at the left and right hand side
        # @param {array}
        setBubblePositions = (chartData) ->

            finalPositions = []

            # sort bubbleData according to their amount of datasets in descending order
            numericalSort = (a, b) ->
                return b.datensätze - a.datensätze

            bubbleData = chartData.sort(numericalSort)

            predefinedPositions = [
                {
                    "x": -17
                    "y": 21
                }
                {
                    "x": 17
                    "y": 21
                }
                {
                    "x": 34
                    "y": 0
                }
                {
                    "x": -34
                    "y": 0
                }
            ]

            predefinedPositions.sort ->
                0.5 - Math.random()

            for category, index in bubbleData
                if index is 0
                    finalPositions.push({"name": category.name, "x": 0, "y": 0})
                else
                    finalPositions.push({"name": category.name, "x": predefinedPositions[index - 1].x, "y": predefinedPositions[index - 1].y})

            finalPositions
]

