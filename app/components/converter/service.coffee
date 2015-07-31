"use strict"

app = angular.module "app.services"

app.factory 'ConverterService', [ ->
    class Converter
        convertSHP2GeoJSON: (buffer) ->
            shp(buffer).then (geoJSON) ->
                return geoJSON

        convertCSV2Arrays: (csv) ->
            return Papa.parse(csv).data

        convertGeoJSON2Arrays: (geoJSON) ->
                dataset = []

                geoJSON.features.forEach (feature) ->
                    if feature.geometry.type == "MultiPolygon"
                        feature.geometry.coordinates.forEach (polygon, index) ->
                            newRow = []

                            for property, value of feature.properties
                                newRow.push value

                            for property, value of feature.geometry
                                if property == "bbox"
                                    value.forEach (coordinate) ->
                                        newRow.push coordinate
                                else if property == "coordinates"
                                    newRow.push "Polygon " + (index + 1)
                                    feature.geometry.coordinates.forEach (polygon) ->
                                        polygon.forEach (pair) ->
                                            pair.forEach (coordinates) ->
                                                coordinates.forEach (coordinate) ->
                                                    newRow.push coordinate
                                else
                                    newRow.push value

                            dataset.push newRow

                    else
                        newRow = []

                        for property, value of feature.properties
                            newRow.push value

                        for property, value of feature.geometry
                            if property == "bbox"
                                value.forEach (coordinate) ->
                                    newRow.push coordinate

                            else if property == "coordinates"
                                if feature.geometry.type == "Point"
                                    feature.geometry.coordinates.forEach (coordinate) ->
                                        newRow.push coordinate

                                else
                                    feature.geometry.coordinates.forEach (pair) ->
                                        pair.forEach (coordinates) ->
                                            coordinates.forEach (coordinate) ->
                                                    newRow.push coordinate

                            else
                                newRow.push value

                        dataset.push newRow

                return dataset

        convertArrays2GeoJSON: (arrays) ->
            geoJSON =
                "type": "FeatureCollection"
                "features": []

            arrays.forEach (element) =>
                lat = parseFloat(element[0])
                lng = parseFloat(element[1])
                if @isCoordinate(lat, lng)
                    feature = JSON.parse(JSON.stringify(
                        "type": "Feature"
                        "geometry":
                            "type": undefined
                            "coordinates": []
                    ))
                    feature.geometry.coordinates = [parseFloat(lng), parseFloat(lat)]
                    feature.geometry.type = "Point"
                    geoJSON.features.push(feature)
            return geoJSON

        isCoordinate: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
                lng == Number(lng) and lng >= -180 and lng <= 180

    new Converter
]
