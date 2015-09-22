"use strict"

app = angular.module "app.services"

# TODO: after extracting coordinates they have to be converted to decimal format

app.service 'ConverterService', [
    "ParserService"
    "HelperService"
    (Parser, Helper) ->
        class Converter
            convertArrays2GeoJSON: (dataset) ->
                dataset = Helper.trimDataset(dataset)

                geoJSON =
                    "type": "FeatureCollection"
                    "features": []

                indicesCoordinates = Parser.findCoordinatesColumns(dataset)

                dataset.forEach (row) ->
                    coordinates = []

                    if indicesCoordinates.hasOwnProperty("xy")
                        coordinates = Parser.extractCoordinatesOfOneCell row[indicesCoordinates["xy"]]
                    else if indicesCoordinates.hasOwnProperty("x") && indicesCoordinates.hasOwnProperty("y")
                        coordinates.push(parseFloat(row[indicesCoordinates["y"]]))
                        coordinates.push(parseFloat(row[indicesCoordinates["x"]]))
                    else
                        # TODO print failure to the user
                        return

                    if coordinates.length == 0
                        return

                    feature = JSON.parse(JSON.stringify(
                        "type": "Feature"
                        "geometry":
                            "type": undefined
                            "coordinates": []
                        "properties": {}
                    ))

                    if coordinates.length == 2
                        longitude = parseFloat(coordinates[1])
                        latitude = parseFloat(coordinates[0])
                        feature.geometry.coordinates = [longitude, latitude]
                        feature.geometry.type = "Point"
                    else
                        #coordinates.forEach (coordinate, index) ->
                        # TODO: 2 Arrays: Line, mehr: Polygon, lat - long für GeoJSON vertauschen
                        return

                    # All none coordinate cell should be filled into the properties of the feature
                    row.forEach (cell, indexColumn) ->
                        if indicesCoordinates.hasOwnProperty("xy")
                            if(indexColumn != indicesCoordinates["xy"])
                                feature.properties[indexColumn] = (cell)
                        else if indicesCoordinates.hasOwnProperty("x") && indicesCoordinates.hasOwnProperty("y")
                            if(indexColumn != indicesCoordinates["x"] && indexColumn != indicesCoordinates["y"])
                                feature.properties[indexColumn] = (cell)

                    geoJSON.features.push(feature)
                return geoJSON

            convertCSV2Arrays: (csv) ->
                return Papa.parse(csv).data

            convertSHP2Arrays: (shp) ->
                return @convertSHP2GeoJSON(shp).then (geoJSON) ->
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

            convertSHP2GeoJSON: (buffer) ->
                shp(buffer).then (geoJSON) ->
                    return geoJSON

        new Converter
]
