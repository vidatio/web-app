"use strict"
app = angular.module "app.directives"

app.directive 'progressScreen', ->
    link: ($scope, el) ->
        return {
            restrict: "E"
            template: "<p>This is my message: {{message}}</p>"
            controller: ($scope, $element) ->
                $scope.setMessage = (msg) ->
                    $scope.message = msg
            link: (scope, el, attr) ->
                scope.message = ""
        }
