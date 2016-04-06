"use strict"

app = angular.module "app.controllers"

app.controller "IndexCtrl", [
    "$scope"
    "$log"
    "CategoriesFactory"
    "DatasetsFactory"
    "$window"
    "$state"
    "$translate"
    ($scope, $log, CategoriesFactory, DatasetsFactory, $window, $state, $translate) ->
        $translate("CATEGORIES_DIAGRAM_LOADING").then (translation) ->
            $scope.message = translation

        CategoriesFactory.query (response) ->
            $scope.categories = response

        , (error) ->
            $log.info "IndexCtrl error on query categories"
            $log.error error

        DatasetsFactory.datasetsLimit { "limit": 3 }, (response) ->
            $scope.newestVidatios = response

            for vidatio in $scope.newestVidatios
            # prevent that one of the newest vidatios has no image
                vidatio.image = if /(png|jpg)/.test(vidatio.visualizationOptions.thumbnail) then vidatio.visualizationOptions.thumbnail else "images/logo-greyscale.svg"

        , (error) ->
            $log.info "IndexCtrl error on query newest datasets"
            $log.error error

        DatasetsFactory.query (response) ->
            $scope.vidatios = response
            categoryOccurrences = {}

            for vidatio in $scope.vidatios
                if vidatio.metaData?.categoryId?
                    #count the occurrences per category over all datasets with category-attribute
                    categoryOccurrences[vidatio.metaData.categoryId.name] = (categoryOccurrences[vidatio.metaData.categoryId.name] or 0) + 1

            $scope.chartData = prepareChartData(categoryOccurrences)
            $scope.positions = setBubblePositions($scope.chartData)

            setTimeout ->
                createCategoryBubbles()
            , 250

        , (error) ->
            $log.info "IndexCtrl error on query all datasets"
            $log.error error

        # Resizing the category-bubbles
        # using setTimeout to use only to the last resize action of the user
        id = null

        onWindowResizeCallback = ->
            clearTimeout id
            id = setTimeout ->
                createCategoryBubbles()
            , 250

        # resize event only should be fired if user is currently on landing-page
        window.angular.element($window).on "resize", $scope.$apply, onWindowResizeCallback

        # resize watcher has to be removed when landing-page is leaved
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
            .font("family": "Colaborate-Regular")
            .messages($scope.message)
            .focus("tooltip": false)
            .background("none")
            .mouse({
                "click": (category) ->
                    $state.go "app.catalog", {category: category.name}
            })
            .zoom("scroll": false)
            .draw()

        # @method prepareChartData
        # @description prepare the necessary data for d3plus according to our categories and their occurrences;
        #               set name, size (="datensätze") and color for each bubble
        # @param {array} occurrences
        prepareChartData = (occurrences) ->
            chartData = []
            colors = ["#11DDC6", "#FF5444", "#000000"]

            currentColor = 0

            for category in $scope.categories

                if occurrences[category.name]?
                    # key 'datensätze' is set in german consciously as this key is displayed within the tooltip on front-end
                    chartData.push({"name": category.name, "datensätze": occurrences[category.name], "color": colors[currentColor]})

                currentColor++

                if currentColor is colors.length
                    currentColor = 0

            chartData

        # @method setBubblePositions
        # @description set the bubbles' positions according to the amount of datasets the respective category has;
        #               the category with the most datasets is located in the middle, the categories with the fewest datasets are at the left and right hand side
        # @param {array} chartData
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
