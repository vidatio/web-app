# Foo Factory
# ===========

"use strict"

app = angular.module "animals.services"

app.factory "FooFactory", [
    "$rootScope"
    ($rootScope) ->
        return "foo"
]
