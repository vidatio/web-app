# Dataset-view Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "DatasetCtrl", [
    "$scope"
    "$rootScope"
    "$log"
    "DataFactory"
    "UserFactory"
    "DatasetService"
    ($scope, $rootScope, $log, DataFactory, UserFactory, DatasetService) ->

        testId = "565b48985b4c70ae2a34242b"
        $scope.information = []
        dataAll = {}
        link = "-"

        DataFactory.get { id: testId }, (data) ->
            dataAll = data
            updated = "-"
            created = "-"
            datasetId = "-"
            tags = "-"
            format = "-"
            category = "-"
            userName = "-"
            title = "Vidatio"
            parent = "-"
            image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
            description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."

            if dataAll.name
                title = dataAll.name

            if dataAll.createdAt
                created = convertDates(dataAll.createdAt)

            if dataAll.updatedAt
                updated = convertDates(dataAll.updatedAt)

            if dataAll.description
                description = dataAll.description

            if dataAll.image
                image = dataAll.image

            if dataAll.userId
                userName = dataAll.userId

            if dataAll._id
                datasetId = dataAll._id

            if dataAll.parentId
                parent = dataAll.parentId

            if dataAll.category
                category = dataAll.category

            if dataAll.tags
                tags = dataAll.tags

            if dataAll.data
                format = "JSON"

            if dataAll.link
                link = dataAll.link

            $scope.information.push
                title: title
                image: image
                id: datasetId
                created: created
                creator: userName
                updated: updated
                description: description
                parent: parent
                category: category
                tags: tags
                format: format


            #(document).ready ->
            #   $('.dataset-title').text dataAll.name
            #   $('.description').text description
            #   $('.dataset-creator').text dataAll.userId
            #   $('.dataset-created').text created
            #   $('.dataset-update').text updated

        #UserFactory.query null, (response) ->
        #   console.log response


        $scope.editDataset = ->
            $log.info "DatasetCtrl editDataset called"
            $log.debug
                id: testId
                name: dataAll.name
                data: dataAll.data

            DatasetService.goToEditor(dataAll.data)


        $scope.shareDataset = ->
            $log.info "DatasetCtrl shareDataset called"

            DatasetService.share(dataAll.data)

        $scope.downloadDataset = ->
            $log.info "DatasetCtrl downloadDataset called"

            DatasetService.downloadDataset(dataAll.data)


        $scope.getLinkDataset = ->
            $log.info "DatasetCtrl getLinkDataset called"

            DatasetService.getLink(link)


        $scope.getCodeDataset = ->
            $log.info "DatasetCtrl getCodeDataset called"

            DatasetService.downloadCode(dataAll)


        $scope.getMetadataDataset = ->
            $log.info "DatasetCtrl getMetadataDataset called"

            DatasetService.downloadMetadata(dataAll)


        convertDates = (current) ->
            current = new Date dataAll.createdAt
            current = current.toLocaleString()
            current = current.split ','
            return current[0]


]
