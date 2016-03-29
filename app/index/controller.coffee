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
            $log.info "IndexCtrl successfully queried categories"

            $scope.categories = response

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

            d3plus.viz()
            .container("#bubble-categories")
            .error("Die Kategorien können momentan leider nicht geladen werden")
            .background("none")
            .draw()

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

            positions = [
                {
                    'name': 'Bildung'
                    'x': -40
                    'y': 5
                }
                {
                    "name": "Finanzen"
                    "x": -20
                    "y": 25
                }
                {
                    "name": "Politik"
                    "x": 0
                    "y": -5
                }
                {
                    "name": "Sport"
                    "x": 20
                    "y": 20
                }
                {
                    "name": "Umwelt"
                    "x": 40
                    "y": 0
                }
            ]

            d3plus.viz()
            .container("#bubble-categories")
            .type("network")
            .data({
                "value": $scope.chartData,
                "opacity": 1
            })
            .nodes({
                "value": positions,
                "overlap": 0.47
            })
            .edges([])
            .id("name")
            .color("color")
            .size("Anzahl der Datensätze")
            .width(width)
            .height(380)
            .legend(false)
            .font("family": "Colaborate")
            .messages( "Die Kategorien werden geladen..." )
            .focus("tooltip": false)
            .background("none")
            .mouse({
                "click": (category) ->
                    $state.go "app.catalog", {category: category.name}
            })
            .zoom({
                #"click": true,
                "scroll": false
            })
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
                    chartData.push({"name": category.name, "Anzahl der Datensätze": occurrences[category.name], "color": colors[currentColor]})

                currentColor++

                if currentColor is colors.length
                    currentColor = 0

            return chartData
]
