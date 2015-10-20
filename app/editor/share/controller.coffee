# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "ShareService"
    ($scope, Share) ->
        $scope.shareVisualization = ->
            $map = $("#map")

            promise = Share.mapToImg $map

            promise.then (obj) ->
                Share.download "obj_png", obj.png
                Share.download "obj_jpg", obj.jpg

]
