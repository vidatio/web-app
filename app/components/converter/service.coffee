# Converter Service
# ======================

"use strict"

app = angular.module "app.services"

app.factory 'ConverterService', [ ->
    class Converter
        convertSHP2GeoJSON: (buffer) ->
            shp(buffer).then (geoJSON) ->
                return geoJSON

        convertCSV2Arrays: (csv) ->
            # TODO: add here further splitting options
            # e.g. split with another separator

            dataset = []
            rows = csv.split('\n')
            rows.forEach (row, index) ->
                dataset.push rows[index].split(',')
            return dataset

        convertSHP2Arrays: (shp) ->
            return @convertSHP2GeoJSON(shp).then (geoJSON) ->
                dataset = []

                geoJSON.features.forEach (feature) ->
                    newRow = []
                    newRow.push feature.geometry.type

                    feature.geometry.coordinates.forEach (coordinate) ->
                        newRow.push coordinate

                    for property, value of feature.properties
                        newRow.push value

                    dataset.push newRow

                return dataset

    new Converter
]
