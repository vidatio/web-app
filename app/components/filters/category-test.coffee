"use strict"
describe "Filter Catalog", ->
    beforeEach ->
        module "ngCookies", "app.filters"
        inject ($filter, $injector) ->
            @injector = $injector
            @filter = $filter

    describe "CategoryFilter", ->
        it "should be defined and included", ->
            expect(@filter('categoryFilter')).toBeDefined()

        it "should filter input correctly with a category", ->
            input = [
                {
                    metaData:
                        category:
                            name: "category1"
                },
                {
                    metaData:
                        category:
                            name: "category2"
                }
            ]

            result = [
                {
                    metaData:
                        category:
                            name: "category2"
                }
            ]

            expect(@filter('categoryFilter')(input, "category2")).toEqual(result)
