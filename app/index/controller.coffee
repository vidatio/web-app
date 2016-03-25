"use strict"

app = angular.module "app.controllers"

app.controller "IndexCtrl", [
    "$scope"
    "$log"
    "$translate"
    "ngToast"
    "CategoriesFactory"
    "DatasetsFactory"
    "$window"
    ($scope, $log, $translate, ngToast, CategoriesFactory, DatasetsFactory, $window) ->
        CategoriesFactory.query (response) ->
            $log.info "IndexCtrl successfully queried categories"

            $scope.categories = response

            #console.log $scope.categories

        , (error) ->
            $log.info "IndexCtrl error on query categories"
            $log.error error

        DatasetsFactory.query (response) ->
            $log.info "IndexCtrl successfully queried datasets"

            $scope.vidatios = response

            categoryIDs = []

            for vidatio in $scope.vidatios
                if vidatio.metaData.category?
                    categoryIDs.push(vidatio.metaData.category.name)

            $scope.chartData = prepareChartData(countOccurrences(categoryIDs))

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
                console.log "test"
            , 250

        # resize event only should be fired if user is currently in editor
        window.angular.element($window).on "resize", $scope.$apply, onWindowResizeCallback

        # resize watcher has to be removed when editor is leaved
        $scope.$on "$destroy", ->
            window.angular.element($window).off "resize", onWindowResizeCallback

        createCategoryBubbles = ->

            $chart = $("#bubble-categories")
            $chart.empty()

            width = $chart.parent().width()
            height = $chart.parent().height()

            console.log "parent ", width, height
            console.log "viz ", $chart.width(), $chart.height()

            d3plus.viz()
            .container("#bubble-categories")
            .type("network")
            .data({
                "value": $scope.chartData,
                "opacity": 1
            })
            .nodes({
                "value": $scope.chartData,
                "overlap": 0.5
            })
            .edges([])
            .id("name")
            .color("color")
            .size("Datensätze")
            .width(width)
            .height(height)
            .legend(false)
            .background('none')
            .zoom({
                'click': true,
                'scroll': false
            })
            .draw()

        countOccurrences = (categoriesArray) ->
            result = {}

            categoriesArray.forEach (category) ->
                result[category] = (result[category] or 0) + 1

            result


        prepareChartData = (occurrences) ->
            chartData = []
            colors = ["#11dcc6", "#F2B1B1", "#FF5444", "#ABF4E9", "#FAFAFA"]
            currentColor = 0

            for category in $scope.categories

                if occurrences[category.name]?
                    chartData.push({"name": category.name, "Datensätze": occurrences[category.name], "color": colors[currentColor]})

                currentColor++

                if currentColor is colors.length
                    currentColor = 0

            return chartData
]
