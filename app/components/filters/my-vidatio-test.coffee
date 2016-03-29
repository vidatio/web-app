"use strict"
describe "Filter Catalog", ->
    beforeEach ->
        module "ngCookies", "app.filters"
        inject ($filter, $injector, $cookieStore) ->
            @injector = $injector
            @filter = $filter
            @cookieStore = $cookieStore

    describe "MyVidatioFilter", ->
        beforeEach ->
            globals =
                currentUser:
                    id: "123456789"

            @cookieStore.put "globals", globals

            @input = [
                { metaData: userId: _id: "123456789" }
                { metaData: userId: _id: "abcdefghi" }
            ]

            @result = [
                { metaData: userId: _id: "123456789" }
            ]

        it "should be defined and included", ->
            expect(@filter('myVidatioFilter')).toBeDefined()

        it "should filter input by user name", ->
            expect(@filter('myVidatioFilter')(@input, true)).toEqual(@result)

        it "should not filter input by user name", ->
            expect(@filter('myVidatioFilter')(@input, false)).toEqual(@input)
