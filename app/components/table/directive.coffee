"use strict"
app = angular.module "app.directives"

app.directive 'data-table', ->
    controller: ->

    template: '<div class="data-table"></div>'
    link: ($scope, $element) ->

