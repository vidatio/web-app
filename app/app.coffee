# Animals App
# ===========
"use strict"

app = angular.module "app", [
    "ui.router"
    "leaflet-directive"
    "app.controllers"
    "app.services"
    "app.directives"
    "app.filters"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$location"
    ( $rootScope, $state, $stateParams) ->
        $rootScope.$state = $state
        $rootScope.$stateParams = $stateParams
        $rootScope.apiBase = "http://localhost:3000"
]

app.config [
    "$stateProvider"
    "$locationProvider"
    ( $stateProvider, $locationProvider ) ->
        $locationProvider.html5Mode true

        $stateProvider
        # /
        .state "index",
            url: "/"
            templateUrl: "index/index.html"

        # /import
        .state "import",
            url: "/import"
            templateUrl: "import/import.html"
            controller: "ImportCtrl"
            title: "import"

        # /import
        .state "editor",
            url: "/editor"
            templateUrl: "editor/editor.html"
            controller: "EditorCtrl"
            title: "editor"
]
