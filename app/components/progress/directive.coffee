# Progress Directive
# ==================

"use strict"

app = angular.module "app.directives"

app.directive "importProgressBar", ->
    scope:
        progress: "@"
    restrict: "E"
    template: '<div class="bar"></div><div class="text"><span>{{progress}}%</span></div>'
    link: ( $scope, $element, $attributes ) ->

        progressBar = $element.find(".bar")
        progressText = $element.find(".text span")

        progressBar.width $scope.progress

        $attributes.$observe "type", ->
            if $attributes.for is $attributes.type
                progressBar.width $attributes.progress + "%"
                progressText.show()
