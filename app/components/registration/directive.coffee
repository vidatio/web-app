"use strict"

app = angular.module "app.directives"

app.directive "registration", [ ->
    restrict: "E"
    templateUrl: "registration/registration.html"
    controller: "RegistrationCtrl"
    replace: true
    require: 'ngModel',
]

# http://www.ng-newsletter.com/posts/validations.html
app.directive 'ensureUnique', [
    '$http'
    ($http) ->
        require: 'ngModel'
        link: (scope, ele, attribute, c) ->
            if !checking and c.$dirty
                checking = $timeout ->
                    $http
                        method: 'POST'
                        url: '/api/check/' + attribute.ensureUnique
                        data: 'field': attribute.ngModel
                    .success (data, status, headers, cfg) ->
                        c.$setValidity 'unique', data.isUnique
                        checking = null
                    .error (data, status, headers, cfg) ->
                        checking = null
                , 500
]

# http://www.ng-newsletter.com/posts/validations.html
app.directive 'ngFocus', [ ->
    FOCUS_CLASS = 'ng-focused'

    return {
        restrict: 'A'
        require: 'ngModel'
        link: (scope, element, attribute, ctrl) ->
            ctrl.$focused = false
            element.bind('focus', (evt) ->
                element.addClass FOCUS_CLASS
                scope.$apply ->
                    ctrl.$focused = true
            ).bind 'blur', (evt) ->
                element.removeClass FOCUS_CLASS
                scope.$apply ->
                    ctrl.$focused = false
    }
]
