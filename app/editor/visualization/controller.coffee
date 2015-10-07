# Visualization Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    "ParserService"
    'leafletData'
    "$timeout"
    ($scope, Table, Map, Parser, leafletData, $timeout) ->



        # icon =
        #     iconUrl: '../images/logo.svg'
        #     iconSize: [25, 30]
        #     iconAnchor: [12.5, 30]
        #     popupAnchor: [0, -30]

        test = L.VectorMarkers.icon
            icon: 'spinner'
            prefix: 'fa'
            markerColor: '#cb4b16'
            spin: true

        leafletData.getMap("map").then (map) ->
            Map.map = map
            # Timeout is needed to wait for the view to finish render
            $timeout ->
                Map.init()

        $scope.geojson =
            data: Map.geoJSON
            style: (feature) ->
                {}
            pointToLayer: (feature, latlng) ->
                new L.marker(latlng, icon: test)

            onEachFeature: (feature, layer) ->
                # So every markers gets a popup
                html = ""
                isFirstAttribute = true

                for property of feature.properties
                    value = feature.properties[property]

                    if isFirstAttribute
                        html += "<b>"

                    if Parser.isEmailAddress(value)
                        html += "<a href='mailto:" + value + "' target='_blank'>" + value + "</a><br>"
                    else if Parser.isPhoneNumber(value)
                        html += "<a href='tel:" + value + "' target='_blank'>" + value + "</a><br>"
                    else if Parser.isURL(value)
                        html += "<a href='" + value + "' target='_blank'>" + value + "</a><br>"
                    else if value
                        html += value + "<br>"

                    if isFirstAttribute
                        html += "</b>"
                        isFirstAttribute = false

                unless html
                    html = "Keine Informationen vorhanden"

                layer.bindPopup(html)
]
