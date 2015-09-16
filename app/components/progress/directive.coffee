# Progress Directive
# ==================

"use strict"

app = angular.module "app.directives"

app.directive "importProgressBar", ->
    restrict: "E"
    link: ( $scope, $element, $attributes ) ->

        $element.width $attributes.progress

        $attributes.$observe "progress", (newVal, oldVal) ->
            $element.width newVal + "%"
