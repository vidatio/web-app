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

            $scope.chartData = $scope.prepareChartData(categoryOccurrences)
            $scope.positions = $scope.setBubblePositions($scope.chartData)

            setTimeout ->
                $scope.createCategoryBubbles()
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
                $scope.createCategoryBubbles()
            , 250

        # resize event only should be fired if user is currently on landing-page
        window.angular.element($window).on "resize", $scope.$apply, onWindowResizeCallback

        # resize watcher has to be removed when landing-page is leaved
        $scope.$on "$destroy", ->
            window.angular.element($window).off "resize", onWindowResizeCallback

        lastWidth = 0

        # @method createCategoryBubbles
        # @description set necessary parameters and draw categories bubble-visualization
        $scope.createCategoryBubbles = ->
            $chart = $("#bubble-categories")
            width = $chart.parent().width() + 60    # +60px to enlarge the diagram as much as possible
            height = $chart.parent().height()
            $chart.css("margin-left", "-30px")      # set the left margin accordingly to the enlargement

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
            .height(height)
            .legend(false)
            .font("family": "Colaborate-Medium")
            .labels("font": {"family": "Colaborate-Regular"})
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
        # @param {Array} occurrences
        # @return {Array} chartData
        $scope.prepareChartData = (occurrences) ->
            chartData = []
            colors = ["#11DDC6", "#FF5444", "#000000"] # vidatio-green and -red, black
            currentColor = 0

            for category in $scope.categories

                if occurrences[category.name]?
                    categoryOccurrence = occurrences[category.name]

                    # key 'datensätze' is set in german consciously as this key is displayed within the tooltip on front-end
                    chartData.push({"name": category.name, "datensätze": categoryOccurrence, "color": colors[currentColor]})
                    currentColor++

                if currentColor is colors.length
                    currentColor = 0

            chartData

        # @method setBubblePositions
        # @description set the bubbles' positions according to the amount of datasets the respective category has;
        #               the category with the most datasets is located in the middle, the categories with the fewest datasets are at the left and right hand side
        # @param {Array} chartData
        # @return {Array} finalPositions
        $scope.setBubblePositions = (chartData) ->
            finalPositions = []
            numberOfCategories = chartData.length - 1

            # sort bubbleData according to their amount of datasets in descending order
            numericalSort = (a, b) ->
                return b.datensätze - a.datensätze

            bubbleData = chartData.sort(numericalSort)
            predefinedPositions = []

            xvalueMultiplicator = 1
            yvalueMultiplicator = 1
            bubblesFirstLine = 0
            bubblesSecondLine = 0

            for data, index in chartData
                if index is numberOfCategories
                    break

                if bubblesFirstLine < 2
                    if bubblesFirstLine is 0
                        predefinedPositions.push({"x": 14 * xvalueMultiplicator, "y": 24})
                    else
                        predefinedPositions.push({"x": (-1) * (14 * xvalueMultiplicator), "y": 24})

                    bubblesFirstLine++
                else
                    if bubblesSecondLine is 0
                        predefinedPositions.push({"x": 28 * yvalueMultiplicator, "y": 0})
                    else
                        predefinedPositions.push({"x": (-1) * (28 * yvalueMultiplicator), "y": 0})

                    bubblesSecondLine++

                    if bubblesSecondLine is 2
                        bubblesFirstLine = 0
                        bubblesSecondLine = 0
                        xvalueMultiplicator += 2
                        yvalueMultiplicator += 1

            predefinedPositions.sort ->
                0.5 - Math.random()

            for category, index in bubbleData
                if index is 0
                    finalPositions.push({"name": category.name, "x": 0, "y": 0})
                else
                    finalPositions.push({"name": category.name, "x": predefinedPositions[index - 1].x, "y": predefinedPositions[index - 1].y})

            finalPositions
]
