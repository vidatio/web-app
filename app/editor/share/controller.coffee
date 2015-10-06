# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "MapService"
    ($scope, Map) ->
        console.log "ctrl"
        $scope.shareVisualization = ->
            console.log "shareVisualization"
            map = Map.map
            console.log "map", map

            # html2canvas(document.getElementById("map")) (canvas) ->
                # document.body.appendChild canvas

            html2canvas document.getElementById("map"),
                useCORS: true
                onrendered: (canvas) ->
                    console.log canvas
                    document.getElementById("editor").appendChild canvas

]
