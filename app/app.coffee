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
    "app.config"
    "pascalprecht.translate"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$location"
    "ASDF"
    ( $rootScope, $state, $stateParams, $http, $location, ASDF) ->
        $rootScope.$state = $state
        $rootScope.$stateParams = $stateParams
        $rootScope.apiBase = "http://localhost:3000"
        console.log ASDF
]

app.config [
    "$urlRouterProvider"
    "$stateProvider"
    "$locationProvider"
    "$httpProvider"
    "$translateProvider"
    ( $urlRouterProvider, $stateProvider, $locationProvider, $httpProvider, $translateProvider ) ->
        $locationProvider.html5Mode true

        $stateProvider
        # forward user to /de/ if no language is chosen
        .state "noLanguage",
            url: "/"
            onEnter: ($state) ->
                $state.go "app.landingPage", { locale: "de" }

        # abstract state for language as parameter in URL
        .state "app",
            abstract: true
            url: "/{locale}"
            controller: "AppCtrl"
            template: "<ui-view/>"
        # /
        .state "app.landingPage",
            url: "/"
            templateUrl: "index/index.html"

        # /import
        .state "app.import",
            url: "/import"
            templateUrl: "import/import.html"
            controller: "ImportCtrl"
            title: "import"

        # /editor
        .state "app.editor",
            url: "/editor"
            templateUrl: "editor/editor.html"
            controller: "EditorCtrl"
            title: "editor"

        # I18N
        $translateProvider
        .useStaticFilesLoader
            prefix: "languages/"
            suffix: ".json"
        $translateProvider.preferredLanguage("de")
]
