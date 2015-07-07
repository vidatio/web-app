# Map Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'MapService', [ ->

    class Map
        constructor: ->
            @markers = {}

        isCoordinate: (value) ->
            value == Number(value) and value >= 0 and value <= 180

        setMarkers: (data) ->
            # safely removes all attributes to keep databinding alive
            for property of @markers
                delete @markers[property]

            # update markers
            length = 0
            data.forEach ((element, index, array) ->
                lat = parseFloat(element[0])
                lng = parseFloat(element[1])
                if isCoordinate(lat) and isCoordinate(lng)
                    @markers[length++] =
                        lat: parseFloat(lat)
                        lng: parseFloat(lng)
            ).bind(this)

    new Map
]
