# Map Service
# ===========

"use strict"

app = angular.module "app.services"

app.service 'MapService', [
    "$log"
    "$timeout"
    "leafletData"
    ($log, $timeout, leafletData) ->
        class Map
            constructor: ($scope) ->
                $log.info "MapService constructor called"

                @map = undefined
                @geoJSON =
                    "type": "FeatureCollection"
                    "features": []
                @bounds = undefined

                icon =
                    iconUrl: '../images/marker-small.png'
                    iconSize: [25, 30]
                    iconAnchor: [12.5, 30]
                    popupAnchor: [0, -30]

                leafletData.getMap("map").then (mapInstance) =>
                    $log.info "MapService leafletData.getMap called"
                    $log.debug
                        message: "MapService leafletData.getMap called"

                    @map = mapInstance
                    # Timeout is needed to wait for the view to finish render
                    $timeout =>
                        @init()

                , (error) ->
                    $log.error "MapService error on map create"
                    $log.debug
                        message: "MapService error on map create"
                        error: error

                    ngToast.create
                        content: error
                        className: "danger"

                $scope.geojson =
                    data: @geoJSON
                    style: ->
                        {}
                    pointToLayer: (feature, latlng) ->
                        new L.marker(latlng, icon: L.icon(icon))

                    onEachFeature: (feature, layer) ->
                        # So every markers gets a popup
                        html = ""
                        isFirstAttribute = true

                        for property, value of feature.properties

                            if value
                                if isFirstAttribute
                                    html += "<b>"

                                if vidatio.helper.isEmailAddress(value)
                                    html += "<a href='mailto:" + value + "' target='_blank'>" + value + "</a><br>"
                                else if vidatio.helper.isPhoneNumber(value)
                                    html += "<a href='tel:" + value + "' target='_blank'>" + value + "</a><br>"
                                else if vidatio.helper.isURL(value)
                                    html += "<a href='" + value + "' target='_blank'>" + value + "</a><br>"
                                else if value
                                    html += value + "<br>"

                                if isFirstAttribute
                                    html += "</b>"
                                    isFirstAttribute = false

                        unless html
                            html = "Keine Informationen vorhanden"

                        layer.bindPopup(html)

            # Because the map gets set later than the geoJSON
            # we need init function to do initial actions
            # like fitting to the bounds of the geoJSON
            init: ->
                $log.info "MapService init called"

                @setBoundsToGeoJSON()
                @resizeMap()

            resetGeoJSON: ->
                $log.info "MapService resetGeoJSON called"

                @geoJSON =
                    "type": "FeatureCollection"
                    "features": []

            # @method setGeoJSON
            # @description sets new geoJSON data, which automatically updates the map.
            # @param {geoJSON} data
            setGeoJSON: (data) ->
                $log.info "MapService setGeoJSON called"
                $log.debug
                    message: "MapService setGeoJSON called"
                    data: data

                # safely remove all items, keeps data binding alive
                @geoJSON.features.splice 0, @geoJSON.features.length
                @geoJSON.features = data.features

                @setBoundsToGeoJSON()

            # Notifies the leaflet map to resize itself
            # @method resizeMap
            # @public
            resizeMap: ->
                $log.info "MapService resizeMap called"

                if(@map)
                    @map.invalidateSize()

            setBoundsToGeoJSON: ->
                $log.info "MapService setBoundsToGeoJSON called"

                if(!@geoJSON.features.length || !@map)
                    return

                coordinates = []
                @geoJSON.features.forEach (feature) ->

                    if feature.geometry.type is "Point"
                        if vidatio.helper.isCoordinate(feature.geometry.coordinates[0]) and vidatio.helper.isCoordinate(feature.geometry.coordinates[1])
                            latLng = L.GeoJSON.coordsToLatLng(feature.geometry.coordinates)
                            coordinates.push(latLng)
                    else if feature.geometry.type is "LineString"
                        feature.geometry.coordinates.forEach (latLng) ->
                            if vidatio.helper.isCoordinate(latLng[0]) and vidatio.helper.isCoordinate(latLng[1])
                                latLng = L.GeoJSON.coordsToLatLng(latLng)
                                coordinates.push(latLng)
                    else if feature.geometry.type is "Polygon"
                        feature.geometry.coordinates[0].forEach (latLng) ->
                            if vidatio.helper.isCoordinate(latLng[0]) and vidatio.helper.isCoordinate(latLng[1])
                                latLng = L.GeoJSON.coordsToLatLng(latLng)
                                coordinates.push(latLng)
                    else if feature.geometry.type is "MultiPolygon"
                        feature.geometry.coordinates.forEach (array) ->
                            array[0].forEach (latLng) ->
                                if vidatio.helper.isCoordinate(latLng[0]) and vidatio.helper.isCoordinate(latLng[1])
                                    latLng = L.GeoJSON.coordsToLatLng(latLng)
                                    coordinates.push(latLng)
                    else
                        $log.warn "Geometry type not supported."

                if coordinates.length
                    @bounds = L.latLngBounds(coordinates)
                    @map.fitBounds(@bounds, {maxZoom: 15})

            # @method updateGeoJSONwithSHP
            # @description updates the geoJSON object(generated from shp file) used for the map after data table changes.
            # @param {integer} row
            # @param {integer} column
            # @param {number or string} oldData
            # @param {number or string} newData
            # @param {string} key
            # @return {boolean}
            updateGeoJSONwithSHP: (row, column, oldData, newData, key) ->
                $log.info "MapService updateGeoJSONwithSHP called"
                $log.debug
                    message: "MapService updateGeoJSONwithSHP called"
                    row: row
                    column: column
                    oldData: oldData
                    newData: newData
                    key: key

                keys = key.split(" ")

                if keys[0] is "coordinates"
                    if vidatio.helper.isNumeric(newData)
                        if @geoJSON.features[row].geometry.type is "Point"
                            if @geoJSON.features[row].geometry.coordinates[keys[1]] == oldData
                                @geoJSON.features[row].geometry.coordinates[keys[1]] = newData
                            else
                                $log.warn "MapService updateGeoJSONwithSHP Point does not exist"
                                return false
                        else if @geoJSON.features[row].geometry.type is "Polygon"
                            arrayIndex = Math.floor(keys[1] / 2)
                            index = keys[1] % 2
                            if Array.isArray(@geoJSON.features[row].geometry.coordinates[0][arrayIndex])
                                @geoJSON.features[row].geometry.coordinates[0][arrayIndex][index] = newData
                            else
                                $log.warn "MapService updateGeoJSONwithSHP Array does not exist and can't be updated"
                                # The table has to be reseted if the array can't be updated
                                return false
                    else
                        $log.warn "MapService updateGeoJSONwithSHP Value is not a Number"
                        return false

                else if keys[0] is "bbox"
                    if vidatio.helper.isNumeric(newData)
                        @geoJSON.features[row].geometry.bbox[keys[1]] = newData
                    else
                        $log.warn "MapService updateGeoJSONwithSHP Value is not a Number"
                        return false

                    # check if colHeader is part of properties
                else
                    for property, value of @geoJSON.features[row].properties
                        if key == property
                            @geoJSON.features[row].properties[key] = newData

                @setBoundsToGeoJSON()
                return true

            # @method validateGeoJSONUpdateSHP
            # @description validates the geoJSON object(generated from shp file) used for the map before data table changes.
            # @param {integer} row
            # @param {integer} column
            # @param {number or string} oldData
            # @param {number or string} newData
            # @param {string} key
            # @return {boolean}
            validateGeoJSONUpdateSHP: (row, column, oldData, newData, key) ->
                $log.info "MapService validateGeoJSONUpdateSHP called"
                $log.debug
                    message: "MapService validateGeoJSONUpdateSHP called"
                    row: row
                    column: column
                    oldData: oldData
                    newData: newData
                    key: key

                keys = key.split(" ")

                if keys[0] is "coordinates"
                    if vidatio.helper.isNumeric(newData)
                        if @geoJSON.features[row].geometry.type is "Point"
                            unless @geoJSON.features[row].geometry.coordinates[keys[1]] == oldData
                                $log.warn "MapService validateGeoJSONUpdateSHP Point does not exist"
                                return false
                        else if @geoJSON.features[row].geometry.type is "Polygon"
                            arrayIndex = Math.floor(keys[1] / 2)
                            index = keys[1] % 2
                            unless Array.isArray(@geoJSON.features[row].geometry.coordinates[0][arrayIndex])
                                $log.warn "MapService validateGeoJSONUpdateSHP Array does not exist and can't be updated"
                                # The table has to be reseted if the array can't be updated
                                return false
                    else
                        $log.warn "MapService validateGeoJSONUpdateSHP Value is not a Number"
                        return false

                else if keys[0] is "bbox"
                    unless vidatio.helper.isNumeric(newData)
                        $log.warn "MapService validateGeoJSONUpdateSHP Value is not a Number"
                        return false

                return true

            getGeoJSON: ->
                $log.info "MapService getGeoJSON called"

                return @geoJSON
]
