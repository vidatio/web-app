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
    "ShareService"
    "DataService"
    "HelperService"
    "ProgressOverlayService"
    "ngToast"
    "$log"
    ($scope, Table, Map, Parser, leafletData, $timeout, Share, Data, Helper, ProgressOverlay, ngToast, $log) ->
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

        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $log.info "ShareCtrl shareVisualization called"
            $log.debug
                message: "ShareCtrl shareVisualization called"
                type: type

            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                $log.info "ShareCtrl shareVisualization promise success called"
                $log.debug
                    message: "Share mapToImg success callback"
                    obj: obj

                ProgressOverlay.setMessage ""

                if Data.meta.fileName == ""
                    fileName = Helper.dateToString(new Date())
                else
                    fileName = Data.meta.fileName

                Share.download fileName, obj[type]
            , (error) ->
                ngToast.create
                    content: error
                    className: "danger"
            , (notify) ->
                ProgressOverlay.setMessage notify
]
