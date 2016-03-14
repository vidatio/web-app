"use strict"
describe "Filter Catalog", ->
    beforeEach ->
        module "ngCookies", "app.filters"
        inject ($filter, $injector, $cookieStore) ->
            @injector = $injector
            @filter = $filter
            @cookieStore = $cookieStore

    describe "DateFilter", ->
        it "should be defined and included", ->
            expect(@filter('dateFilter')).toBeDefined()

        it "should filter input correctly between minimum and maximum date", ->
            input = [
                {
                    createdAt: new Date("2016-02-06")
                },
                {
                    createdAt: new Date("2016-02-08")
                }
            ]

            result = [
                {
                    createdAt: new Date("2016-02-06")
                }
            ]

            expect(@filter('dateFilter')(input, "2016-02-05", "2016-02-07")).toEqual(result)

        it "should filter input correctly from minimum date", ->
            input = [
                {
                    createdAt: new Date("2016-02-06")
                },
                {
                    createdAt: new Date("2016-02-08")
                }
            ]

            result = [
                {
                    createdAt: new Date("2016-02-08")
                }
            ]

            expect(@filter('dateFilter')(input, "2016-02-07")).toEqual(result)

        it "should filter input correctly to maximum date", ->
            input = [
                {
                    createdAt: new Date("2016-02-06")
                },
                {
                    createdAt: new Date("2016-02-08")
                }
            ]

            result = [
                {
                    createdAt: new Date("2016-02-06")
                }
            ]

            expect(@filter('dateFilter')(input, undefined, "2016-02-07")).toEqual(result)

    describe "CategoryFilter", ->
        it "should be defined and included", ->
            expect(@filter('categoryFilter')).toBeDefined()

        it "should filter input correctly with a cateory", ->
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

    describe "MyVidatioFilter", ->
        beforeEach ->
            globals =
                currentUser:
                    id: "123456789"

            @cookieStore.put "globals", globals

            @input = [
                {
                    userId:
                        _id: "123456789"
                },
                {
                    userId:
                        _id: "abcdefghi"
                }
            ]

            @result = [
                {
                    userId:
                        _id: "123456789"
                }
            ]

        it "should be defined and included", ->
            expect(@filter('myVidatioFilter')).toBeDefined()

        it "should filter input by user name", ->
            expect(@filter('myVidatioFilter')(@input, true)).toEqual(@result)

        it "should not filter input by user name", ->
            expect(@filter('myVidatioFilter')(@input, false)).toEqual(@input)
