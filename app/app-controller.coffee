"use strict"

app = angular.module "app.controllers"

app.controller "AppCtrl", [
    "$scope"
    ($scope) ->
        # Closing the menu on click of body should remove the active class
        $scope.disableMenuActive = ->
            $('#menu').removeClass "menu-active"
            return true
]
