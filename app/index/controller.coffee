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

            console.log occurencesPerCategory[0]
            #console.log occurences["Finanzen"]

            chartData = [
                {
                    'size': 10
                    'name': 'Sport'
                }
                {
                    'size': 20
                    'name': 'Finanzen'
                }
                {
                    'size': 20
                    'name': 'Umwelt'
                }
                {
                    'size': 20
                    'name': 'Politik'
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

            createCategoryBubbles(chartData)

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


            visualization = d3plus.viz()
            .container("#bubble-categories")
            .type("network")
            .data(categoriesData)
            .nodes(categoriesData)
            .edges([])
            .id("name")
            .size("size")
            .color("name")
            .width(width)
            .height(height)
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


