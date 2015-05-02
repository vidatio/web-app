# Animals - User Service
# ======================

"use strict"

app = angular.module "animals.services"

app.factory "UserFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $rootScope.apiBase = "http://localhost:3333/v0"
        $resource $rootScope.apiBase + "/auth/"

]
