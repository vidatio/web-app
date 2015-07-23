# Parser Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'ParserService', [ ->
    class Parser
        zip: (buffer) ->
            shp buffer
            .then (geojson) ->
                console.log geojson
                console.log JSON.stringify geojson
                return geojson

    new Parser
]