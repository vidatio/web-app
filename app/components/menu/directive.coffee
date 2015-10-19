"use strict"

app = angular.module "app.directives"

app.directive "menu", [
    ->
        return {
        restrict: "E"
        templateUrl: "menu/menu.html"
        replace: true
        link: ($scope, $element) ->
            console.log "in link"
            console.log $('.toggle-menu')


            console.log $('.toggle-menu').first()#.jPushMenu()


            #$('.toggle-menu').jPushMenu()
        }
]
