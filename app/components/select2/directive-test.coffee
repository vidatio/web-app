"use strict"

describe "Directive Select2", ->
    beforeEach ->
        module "app"
        inject ($injector, $q, $compile, $controller, $rootScope, $httpBackend) ->
            @injector = $injector
            @scope = $rootScope.$new()
            @deferred = $q.defer()

            # create a promise to either resolve or reject it in the tests and pass it to the directive's isolate scope
            @scope.promise = @deferred.promise
            @element = $compile("<select2 id='tags' multiple ng-model='test' ajax-content='promise' ng-list=','></select2>")(@scope)

            # get the directive's isolate scope to spy on the directives functions
            @elementScope = angular.element(@element[0]).isolateScope()
            spyOn(@elementScope, "initializeSelect2")

            $httpBackend.when('GET', 'languages/de.json').respond({})

    it "should exist in the injector", ->
        expect(@injector.has('select2Directive')).toBeTruthy()

    it "should initialize Select2 with data", ->
        data = [
            {
                id: "tag1"
                text: "tag1"
            }
        ]

        @deferred.resolve(data)
        @scope.$digest()

        expect(@elementScope.initializeSelect2).toHaveBeenCalledWith(data)

    it "should initialize Select2 without data", ->
        @deferred.reject()
        @scope.$digest()

        expect(@elementScope.initializeSelect2).toHaveBeenCalledWith([])
