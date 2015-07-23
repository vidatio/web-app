# Parser Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'ParserService', [ ->
    class Parser
        zip: (buffer) ->

            # not neccessary
            if buffer instanceof ArrayBuffer
                shp buffer
                .then (geojson) ->
                    console.log geojson
                    console.log JSON.stringify geojson

    new Parser
]