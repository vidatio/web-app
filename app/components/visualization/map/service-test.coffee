xdescribe "Service Map", ->
    mapService = undefined

    beforeEach ->
        module "app"
        inject (MapService) ->
            mapService = MapService

    it 'sets markers', ->
        dataset = [[90, 90], [80, 80], [70, 70]]
        mapService.setMarkers dataset
        markers =
            0:
                lat: 90
                lng: 90
            1:
                lat: 80
                lng: 80
            2:
                lat: 70
                lng: 70

        expect(mapService.markers).toEqual markers

