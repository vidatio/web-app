"use strict"
describe "Filter Catalog", ->
    beforeEach ->
        module "ngCookies", "app.filters"
        inject ($filter, $injector) ->
            @injector = $injector
            @filter = $filter

    describe "TagFilter", ->
        it "should be defined and included", ->
            expect(@filter('categoryFilter')).toBeDefined()

        it "should filter input correctly with tags", ->
            input = [
                {
                    metaData:
                        tags: [
                            { name: "category1" }
                            { name: "category2" }
                        ]
                },
                {
                    metaData:
                        tags: [
                            { name: "category3" }
                        ]

                }
            ]

            result = [
                {
                    metaData:
                        tags: [
                            { name: "category3" }
                        ]
                }
            ]

            expect(@filter('tagsFilter')(input, ["category3"])).toEqual(result)
