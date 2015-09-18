# Progress Directive
# ==================

"use strict"

app = angular.module "app.directives"

app.directive "importProgressBar", ->
    scope:
        progress: "@"
    restrict: "E"
    link: ( $scope, $element, $attributes ) ->

        $element.width $scope.progress

        $attributes.$observe "type", ->
            if $attributes.for is $attributes.type
                $element.width $attributes.progress + "%"
