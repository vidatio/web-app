"use strict"

describe "Service Recommender", ->
    beforeEach ->
        @recommender = new window.vidatio.Recommender()
        @helper = new window.vidatio.Helper()

    it "should analyse type of the columns and so the schema of the dataset", ->
        schema = ["coordinate", "coordinate", "nominal", "nominal", "coordinate"]
        dataset = [
            ["47", "13", "Salzburg", "41,5%", "2"]
            ["46", "12", "Wien", "38,5%", "2"]
            ["46", "11", "Bregenz", "40,5%", "1"]
            ["49", "10", "Linz", "39,5%", "1"]
            ["49", "10", "Linz", "39,5%", "2"]
        ]

        dataset = @helper.transposeDataset(dataset)

        expect(@recommender.getSchema(dataset)).toEqual(schema)

    it "should analyse the variances of the columns of the dataset", ->
        variances = [0.5, 0.5, 0.25, 1]
        dataset = [
            ["47.349", "13.892", "Salzburg", "2%"]
            ["47.349", "13.892", "Salzburg", "3%"]
            ["46.323", "13.892", "Salzburg", "4%"]
            ["46.323", "10.348", "Salzburg", "5%"]
        ]
        dataset = @helper.transposeDataset(dataset)
        expect(@recommender.getVariances dataset).toEqual(variances)

        variances = [1, 1]
        dataset = [
            ["200", "Apfel"]
            ["300", "Banane"]
            ["400", "Kiwi"]
            ["500", "Orange"]
        ]
        dataset = @helper.transposeDataset(dataset)
        expect(@recommender.getVariances dataset).toEqual(variances)

    it "should analyse the best diagram type for a given dataset system", ->
        dataset = [
            ["200", "10", "Salzburg", "2%"]
            ["300", "11", "Salzburg", "3%"]
            ["400", "12", "Salzburg", "3%"]
            ["500", "13", "Salzburg", "3%"]
        ]
        expect(@recommender.run dataset).toEqual(
            "recommendedDiagram": "pc"
            "xColumn": 0
            "yColumn": 1
        )

        dataset = [
            ["200", "Salzburg", "2%"]
            ["300", "Salzburg", "3%"]
            ["400", "Salzburg", "3%"]
            ["500", "Salzburg", "3%"]
        ]
        expect(@recommender.run dataset).toEqual(
            "recommendedDiagram": "bar"
            "xColumn": 2
            "yColumn": 0
        )

        dataset = [
            ["200", "Apfel"]
            ["300", "Banane"]
            ["400", "Kiwi"]
            ["500", "Orange"]
        ]
        expect(@recommender.run dataset).toEqual(
            "recommendedDiagram": "bar"
            "xColumn": 1
            "yColumn": 0
        )

        dataset = [
            ["Apfelsaft", "Linz", "Salzburg", "2%"]
            ["Apfelkuchen", "Innsbruck", "Salzburg", "3%"]
            ["Croissants", "Salzburg", "Salzburg", "3%"]
            ["Kaffee", "Wien", "Salzburg", "3%"]
        ]
        expect(@recommender.run dataset).toEqual(
            "recommendedDiagram": "scatter"
            "xColumn": 0
            "yColumn": 1
        )


