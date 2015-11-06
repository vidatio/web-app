"use strict"

app = angular.module "app.directives"

app.directive "validateUniqueness", [
    "$q"
    "UserService"
    ($q, UserService) ->
        restrict: "A"
        require: 'ngModel'
        link: (scope, element, attributes, controller) ->
            property = attributes.validateUniqueness

            controller.$asyncValidators.uniqueness = (modelValue, viewValue) ->
                return $q (resolve, reject) ->
                    if viewValue? && viewValue.length
                        UserService.checkUniqueness(property, viewValue).then ->
                            resolve()
                        , (error) ->
                            reject()
]
