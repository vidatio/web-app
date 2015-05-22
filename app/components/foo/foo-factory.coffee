# Foo Factory
# ===========

"use strict"

app = angular.module "app.services"

app.factory "FooFactory", [
    "$rootScope"
    ($rootScope) ->
        return "foo"
]
