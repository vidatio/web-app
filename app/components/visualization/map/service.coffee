# Map Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'MapService', [ ->
    class Map
        constructor: ->
            @markers = {}

        isCoordinate: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
            lng == Number(lng) and lng >= -180 and lng <= 180

        setMarkers: (data) ->
            # safely removes all attributes to keep databinding alive
            for property of @markers
                delete @markers[property]

            # update markers
            length = 0
            data.forEach (element, index, array) =>
                lat = parseFloat(element[0])
                lng = parseFloat(element[1])
                if @isCoordinate(lat, lng)
                    @markers[length++] =
                        lat: parseFloat(lat)
                        lng: parseFloat(lng)
    new Map
]
