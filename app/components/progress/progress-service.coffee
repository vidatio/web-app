# Animals - Progress Service
# ==========================

"use strict"

app = angular.module "animals.services"

app.service "ProgressService", ->

    @indeterminateLoading = false
    @screenLocked = false
    @subscribers = 0

    @startLoading = ->
        @subscribers++
        @indeterminateLoading = true

    @finishedLoading = ->
        @subscribers--
        if @subscribers is 0
            @indeterminateLoading = false
            @screenLocked = false

    @lockScreen = ->
        @screenLocked = true

    return
