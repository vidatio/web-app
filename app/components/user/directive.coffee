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

            # @method $asyncValidators.uniqueness
            # @description checks asynchronously if a key (email/username) is already in use
            # @param {String} modelValue
            # @param {String} viewValue
            controller.$asyncValidators.uniqueness = (modelValue, viewValue) ->
                return $q (resolve, reject) ->
                    if viewValue? && viewValue.length
                        UserService.checkUniqueness(property, viewValue).then ->
                            resolve()
                        , (error) ->
                            reject()
]

app.directive "validateName", [
    "$q"
    ($q) ->
        restrict: "A"
        require: "ngModel"
        link: (scope, element, attributes, controller) ->
            controller.$asyncValidators.valid = (modelValue, viewValue) ->
                return $q (resolve, reject) ->
                    if viewValue? && viewValue.length
                        if (/[\/;^<>|\()\[\]#"{}§°\s]+/.test(viewValue))
                            reject()
                        else
                            resolve()
]
