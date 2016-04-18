"use strict"

app = angular.module "app.directives"

app.directive "validateDataName", [
    "$q"
    ($q) ->
        restrict: "A"
        require: "ngModel"
        link: (scope, element, attributes, controller) ->
            controller.$validators.valid = (modelValue, viewValue) ->
                if (/[\/;^<>|\\[\]#"{}§°]+/.test(viewValue))
                  return false
                else
                    return true
]
