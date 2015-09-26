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
            iconUrl: 'images/marker-icon.png'
            iconSize: [ 25, 41 ]
            iconAnchor: [ 12.5, 41 ]

        leafletData.getMap().then (map) ->
            Map.map = map
            $timeout ->
                Map.init()
            , 100

        $scope.geojson =
            data: Map.geoJSON
            style: (feature) ->
                {}
            pointToLayer: (feature, latlng) ->
                new (L.marker)(latlng, icon: L.icon(icon))

            onEachFeature: (feature, layer) ->
                # So every markers gets a popup
                html = ""
                for property of feature.properties
                    html += feature.properties[property] + "<br>"
                layer.bindPopup(html)
]
