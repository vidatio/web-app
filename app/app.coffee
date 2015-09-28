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
    "pascalprecht.translate"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$location"
    ($rootScope, $state, $stateParams, $http, $location) ->
        $rootScope.$state = $state
        $rootScope.$stateParams = $stateParams
        $rootScope.apiBase = "http://localhost:3000"
]

app.config [
    "$urlRouterProvider"
    "$stateProvider"
    "$locationProvider"
    "$httpProvider"
    "$translateProvider"
    ($urlRouterProvider, $stateProvider, $locationProvider, $httpProvider, $translateProvider) ->
        $locationProvider.html5Mode true

        # I18N
        $translateProvider.useSanitizeValueStrategy("escape")
        $translateProvider.preferredLanguage("de")
        $translateProvider.fallbackLanguage("de")
        $translateProvider.useStaticFilesLoader
            prefix: "languages/"
            suffix: ".json"

        $stateProvider
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

        # not match was found in the states before (e.g. no language was provided in the URL)
        .state "noMatch",
            url: '*path'
            onEnter: ($state, $stateParams) ->
                locale =
                    locale: $translateProvider.preferredLanguage()

                # iterate over all states and check if the requested url exists as a state
                $state.get().forEach (state) ->
                    if $stateParams.path is state.url
                        $state.go state.name, locale

]
