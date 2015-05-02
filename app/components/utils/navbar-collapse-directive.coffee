# navbar collapse directive
# =========================

"use strict"

app = angular.module "animals.directives"

app.directive "navbarCollapse", ->
    restrict: "A"
    link: ($scope, $element, $attrs) ->
        $element.on "click", ->
            $(".navbar-collapse.in").collapse "hide"
