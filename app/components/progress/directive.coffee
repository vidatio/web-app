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

        progressBar = $element.find ".bar"
        progressText = $element.find ".text span"

        progressBar.width $scope.progress

        $attributes.$observe "type", (newVal, oldVal) ->
            if oldVal isnt newVal and !!newVal
                if $attributes.for is $attributes.type
                    progressBar.width $attributes.progress + "%"
                    progressText.show()
                else
                    progressBarArea = $element.parent ".area"
                    progressBarArea.addClass "progress-disabled"
                    for element, index in progressBarArea.find "input, button"
                        $(element).prop "disabled", true
