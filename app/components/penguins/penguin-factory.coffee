# Animals - Penguin Factory
# =========================
# factory to abstract the api resource /accounts
# to adapt and add functionality (e.g. update = PUT)

"use strict"

app = angular.module "animals.services"

app.factory "PenguinFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + "/penguin/:id",
            { id: "@id" },
            { update: { method: "PUT" } }
]
