"use strict"

describe "Service Recommender", ->
    beforeEach ->
        @recommender = new Recommender()
        @dataset =
            ["47.349", "13.892", "Salzburg", "41,5%", "2"]
            ["46.841", "12.348", "Wien", "38,5%", "2"]
            ["46.323", "11.234", "Bregenz", "40,5%", "1"]
            ["49.823", "10.348", "Linz", "39,5%", "1"]
            ["49.823", "10.348", "Linz", "39,5%", "2"]

    xit "", ->
