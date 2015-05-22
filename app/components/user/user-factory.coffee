# User Factory
# ============

"use strict"

app = angular.module "app.services"

app.factory "UserFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $rootScope.apiBase = "http://localhost:3333/v0"
        $resource $rootScope.apiBase + "/auth/"

]
