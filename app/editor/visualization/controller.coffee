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

        # Default settings - Works like scope.center, etc.
        $scope.center =
            lat: 46.723407
            lng: 17.086921
            zoom: 7

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
                # So every markers gets a popup
                html = ""
                for property of feature.properties
                    html += feature.properties[property] + "<br>"
                layer.bindPopup(html)
]
