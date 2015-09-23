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

        progressBar.width 0

        $attributes.$observe "type", (newVal, oldVal) ->
            #This ignores the initial load, where newVal is still undefined
            if oldVal isnt newVal and !!newVal
                #All three progress-bars have the same type and therefore it is needed to check if the type is the the same as the for-attribute (the actual use of the progress-bar); thus if it is true, the correct progress-bar is selected
                if $attributes.for is $attributes.type
                    progressBar.width $attributes.progress + "%"
                    progressText.show()
                else
                    progressBarArea = $element.parent ".area"
                    progressBarArea.addClass "progress-disabled"
                    for element, index in progressBarArea.find "input, button"
                        $(element).prop "disabled", true
