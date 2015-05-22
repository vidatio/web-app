# Foo Service
# ===========


"use strict"

app = angular.module "app.services"


app.service "FooService", [
    "FooFactory"
    ( FooFactory ) ->
        new class Foos
            constructor: ->
                @penguins = []
                @penguin  = {}

            doFoo: ->
                return FooFactory.foo()

]
