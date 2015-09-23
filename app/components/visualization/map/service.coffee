# Map Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'MapService', [ ->
    class Map
        constructor: ->
            @geoJSON =
                "type": "FeatureCollection"
                "features": []

        # @method setGeoJSON
        # @description sets new geoJSON data, which automatically updates the map.
        # @param {geoJSON} data
        setGeoJSON: (data) ->
            # safely remove all items, keeps data binding alive
            @geoJSON.features.splice 0, @geoJSON.features.length
            @geoJSON.features = data.features

        # @method isNumeric
        # @description checks if a value is numeric.
        # @param {Mixed} n
        # @return {Boolean}
        isNumeric: (n) ->
            return (!isNaN(parseFloat(n)) && isFinite(n))

        # @method updateGeoJSONwithSHP
        # @description updates the geoJSON object(generated from shp file) used for the map after data table changes.
        # @param {integer} row
        # @param {integer} column
        # @param {number or string} oldData
        # @param {number or string} newData
        # @param {string} key
        # @return {boolean}
        updateGeoJSONwithSHP: (row, column, oldData, newData, key) ->
            keys = key.split(" ")

            if keys[0] == "coordinates"
                if @isNumeric(newData)
                    if @geoJSON.features[row].geometry.type == "Point"
                        if @geoJSON.features[row].geometry.coordinates[keys[1]] == oldData
                            @geoJSON.features[row].geometry.coordinates[keys[1]] = newData
                        else
                            console.log "Point does not exist"
                            return false
                    else if @geoJSON.features[row].geometry.type == "Polygon"
                        arrayIndex = Math.floor(keys[1] / 2)
                        index = keys[1] % 2
                        if Array.isArray(@geoJSON.features[row].geometry.coordinates[0][arrayIndex])
                            @geoJSON.features[row].geometry.coordinates[0][arrayIndex][index] = newData
                        else
                            # Array does not exist and can't be updated
                            console.log "Array does not exist and can't be updated"
                            # The table has to be reseted if the array can't be updated
                            return false
                else
                    console.log "Value is not a Number"
                    return false

            else if keys[0] == "bbox"
                if @isNumeric(newData)
                    @geoJSON.features[row].geometry.bbox[keys[1]] = newData
                else
                    console.log "Value is not a Number"
                    return false

            # check if colHeader is part of properties
            else
                for property, value of @geoJSON.features[row].properties
                    if key == property
                        @geoJSON.features[row].properties[key] = newData

            return true

        getGeoJSON: ->
            return @geoJSON

    new Map
]
