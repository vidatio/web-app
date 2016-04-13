"use strict"

app = angular.module "app.controllers"

app.controller "IndexCtrl", [
    "$scope"
    "DatasetsFactory"
    "$log"
    ($scope, DatasetsFactory, $log) ->
        DatasetsFactory.datasetsLimit { "limit": 3 }, (response) ->
            $scope.newestVidatios = response

            for vidatio in $scope.newestVidatios
                # prevent that one of the newest vidatios has no image
                vidatio.image = if /(png|jpg)/.test(vidatio.visualizationOptions.thumbnail) then vidatio.visualizationOptions.thumbnail else "images/logo-greyscale.svg"

        , (error) ->
            $log.info "IndexCtrl error on query newest datasets"
            $log.error error

        addClassActive = (e) ->
            if e.currentTarget.currentTime > 4
                $("#intro ol li:nth-child(3)").addClass("active")
            if e.currentTarget.currentTime > 2
                $("#intro ol li:nth-child(2)").addClass("active")
            if e.currentTarget.currentTime > 0
                $("#intro ol li:nth-child(1)").addClass("active")

        $("video").bind "timeupdate", addClassActive
        $("video").bind "play", (e) ->
            $("#intro ol li").removeClass("active")
            addClassActive(e)


]
