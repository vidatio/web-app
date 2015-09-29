# Visualization Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    'leafletData'
    "$timeout"
    ($scope, Table, Map, leafletData, $timeout) ->
        icon =
            iconUrl: '../images/marker-small.png'
            iconSize: [25, 30]
            iconAnchor: [12.5, 30]
            popupAnchor: [0, -30]

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
                new L.marker(latlng, icon: L.icon(icon))

            onEachFeature: (feature, layer) ->
                # So every markers gets a popup
                html = ""
                for property of feature.properties
                    if mailAddressCheck(property)
                        html += "<a href='mailto:" + feature.properties[property] +
                                "'>" + feature.properties[property] + "</a><br>"
                    else if phoneNumberCheck(property)
                        html += "<a href='tel:" + feature.properties[property] +
                                "'>" + feature.properties[property] + "</a><br>"
                    else
                        html += feature.properties[property] + "<br>"

                if html?
                    html = "Keine Informationen vorhanden"

                layer.bindPopup(html)

        phoneNumberCheck = (cell) ->
            regex = /^\+(\d{2})[-. ]?(\d{3})[-. ]?(\d*)$/
            return regex.test(cell)

        mailAddressCheck = (cell) ->
            regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
            return regex.test(cell)
]
