# Visualization Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    'leafletData'
    ($scope, Table, Map, leafletData) ->
        icon =
            iconUrl: 'images/marker-icon.png'
            iconSize: [
                25
                41
            ]
            iconAnchor: [
                12
                0
            ]

        $scope.center = {}

        leafletData.getMap().then (map) ->
            Map.map = map
            Map.init()

        $scope.geojson =
            data: Map.geoJSON
            style: (feature) ->
                {}
            pointToLayer: (feature, latlng) ->
                new (L.marker)(latlng, icon: L.icon(icon))

            onEachFeature: (feature, layer) ->
                # So every markers gets an popup
                html = ""
                for property of feature.properties
                    html += feature.properties[property] + "<br>"
                layer.bindPopup(html)
]
