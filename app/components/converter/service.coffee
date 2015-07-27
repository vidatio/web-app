# Converter Service
# ======================

"use strict"

app = angular.module "app.services"

app.factory 'ConverterService', [ ->
    class Converter
        convertSHP2GeoJSON: (buffer) ->
            shp buffer
            .then (geojson) ->
                return geojson

    new Converter
]
