"use strict"

app = angular.module "app.factories"

app.factory "CatalogFactory", [
    "$resource"
    ($resource) ->
        $resource.apiBase + "/v0/datasets/"

]
