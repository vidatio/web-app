"use strict"

app = angular.module "app.directives"

app.directive "menu", [
    "$timeout"
    ($timeout) ->
        restrict: "E"
        templateUrl: "menu/menu.html"
        replace: true
        link: ($scope, $element) ->
            $scope.$on '$stateChangeSuccess', ->
                console.log "heyho"
                $timeout ->
                    console.log "timeout 1"
                    $('.toggle-menu').jPushMenu()

            $timeout ->
                console.log "timeout 2"
                $('.toggle-menu').jPushMenu()
]
