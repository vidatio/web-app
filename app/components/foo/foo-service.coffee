# Foo Service
# ===========


"use strict"

app = angular.module "animals.services"


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
