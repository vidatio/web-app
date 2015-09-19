# Visualization Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    ($scope, Table, Map) ->

        # Default settings - Works like scope.center, etc.
        $scope.center =
            lat: 47.723407
            lng: 13.086921
            zoom: 1

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

        $scope.geojson =
            data: Map.geoJSON
            style: (feature) ->
                {}
            pointToLayer: (feature, latlng) ->
                new (L.marker)(latlng, icon: L.icon(icon))
            onEachFeature: (feature, layer) ->
                html = ""
                for property of feature.properties
                    html += feature.properties[property] + "<br>"
                layer.bindPopup(html);
]
