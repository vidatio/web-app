# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "$translate"
    "$rootScope"
    "DataService"
    "VisualizationService"
    "$timeout"
    "$stateParams"
    ($scope, $translate, $rootScope, Data, Visualization, $timeout, $stateParams) ->
        $scope.share = Data

        # initialize tagsinput on page-init for propper displaying the tagsinput-field
        $(".tagsinput").tagsinput()

        #to remove tags label on focus & remove flag-ui tags-input length
        $('.tagsinput-primary ').on 'focus', '.bootstrap-tagsinput input', ->
            $('span.placeholder').hide()
            $(this).attr('style', 'width:auto')

        #to change color after user selection (impossible with css)
        $('.selection select').change -> $(this).addClass 'selected'

        #plus-button for tags-input
        $('.add-tag').click -> $('.bootstrap-tagsinput input').focus()

        #flat-ui checkbox
        $('#publish').radiocheck()

        # copied from login controller, redundant?
        # To give the prepends tags of flat ui the correct focus style
        $('.input-group').on('focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        ).on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'

        unless $stateParams.id
            $timeout ->
                Visualization.create()

        # TODO refactor the following code which is duplicated from the dataset ctrl
        console.log "### id ###", $stateParams, $stateParams.id
        if $stateParams.id

            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message

                # get dataset according to datasetId and set necessary metadata
                DataFactory.get {id: $stateParams.id}, (data) ->
                    $scope.data = data
                    $scope.data.id = $stateParams.id
                    $scope.data.created = new Date(data.createdAt)
                    $scope.data.creator = data.userId.name || "-"
                    $scope.data.origin = "Vidatio"
                    $scope.data.updated = new Date(data.updatedAt)
                    $scope.data.description = data.description || "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."
                    $scope.data.parent = data.parentId
                    $scope.data.category = data.category || "-"
                    $scope.data.tags = data.tags || "-"

                    Data.createVidatio $scope.data

                    if Data.meta.fileType isnt "shp"
                        Visualization.create()

                    $timeout ->
                        Progress.setMessage()

                    # console.log $scope.data, Visualization.options, Table.dataset, Table.header, Map.geoJSON
                , (error) ->
                    $log.info "DatasetCtrl error on get dataset from id"
                    $log.error error

                    $timeout ->
                        Progress.setMessage()

                    $translate("TOAST_MESSAGES.DATASET_COULD_NOT_BE_LOADED").then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"
]
