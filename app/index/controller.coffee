"use strict"

app = angular.module "app.controllers"

app.controller "IndexCtrl", [
    "$scope"
    "$log"
    "$translate"
    "ngToast"
    "CatalogFactory"
    ($scope, $log, $translate, ngToast, CatalogFactory) ->
        CatalogFactory.getDatasets().query (response) ->
            $log.info "CatalogCtrl successfully queried datasets"

            $scope.vidatios = response

            categoryIDs = []

            for vidatio in $scope.vidatios
                if vidatio.metaData.category?
                    categoryIDs.push(vidatio.metaData.category.name)

            occurencesPerCategory = countOccurences(categoryIDs)

            console.log occurencesPerCategory
            #console.log occurences["Finanzen"]

            chartData = [
                {
                    'Datensätze': 1
                    'name': 'Sport'
                    'color': '#11dcc6'
                }
                {
                    'Datensätze': 2
                    'name': 'Finanzen'
                    'color': '#333'
                }
                {
                    'Datensätze': 3
                    'name': 'Umwelt'
                    'color': '#3e3e3e'
                }
                {
                    'Datensätze': 2
                    'name': 'Politik'
                    'color': '#11dcc6'
                }
            ]

            positions = [
                {
                    'name': 'Sport'
                    'x': 10
                    'y': 30
                }
                {
                    'name': 'Finanzen'
                    'x': 5
                    'y': 10
                }
                {
                    'name': 'Umwelt'
                    'x': 0
                    'y': 0
                }
                {
                    'name': 'Politik'
                    'x': 30
                    'y': 10
                }
            ]

            createCategoryBubbles(chartData, positions)

        , (error) ->
            $log.info "IndexCtrl error on query datasets"
            $log.error error


        CatalogFactory.getCategories().query (response) ->
            $log.info "IndexCtrl successfully queried categories"
            $scope.categories = response

            categoryNames = []

            for category in $scope.categories
                categoryNames.push(category.name)

            #console.log categoryNames

        , (error) ->
            $log.info "IndexCtrl error on query categories"
            $log.error error


        createCategoryBubbles = (categoriesData, positions) ->

            $chart = $("#bubble-categories")
            width = $chart.parent().width()
            height = $chart.parent().height()

            console.log width, height


            d3plus.viz()
            .container("#bubble-categories")
            .type("network")
            .data({
                'value': categoriesData,
                'opacity': 1
            })
            .nodes({
                'value': categoriesData,
                'overlap': 0.5
            })
            .edges([])
            .id("name")
            .color('color')
            .size({
                'value': "Datensätze",
                'scale': {
                    'min': width,
                    'max': width
                }
            })
            .width(width)
            .height(height)
            .legend(false)
            #.background('none')
            .zoom({
                'click': true,
                'scroll': false
            })
            .draw()

        countOccurences = (categoriesArray) ->
            result = []

            if categoriesArray instanceof Array
                categoriesArray.forEach (category) ->

                    if !result[category]
                        result[category] = 1

                    else
                        result[category] += 1

            result
]


