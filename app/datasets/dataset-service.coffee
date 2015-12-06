# # Dataset Service

"use strict"

app = angular.module "app.services"

app.service "DatasetService", [
    "$q"
    "$log"
    ($q, $log) ->
        class Dataset

            goToEditor: (dataset) ->
                $log.info "DatasetService goToEditor called"

            share: (dataset) ->
                $log.info "DatasetService share called"

            downloadDataset: (dataset) ->
                $log.info "DatasetService downloadDataset called"

            downloadCode: (dataset) ->
                $log.info "DatasetService downloadCode called"

            downloadMetadata: (dataset) ->
                $log.info "DatasetService downloadMetadata called"

            getLink: (link) ->
                $log.info "DatasetService getLink called"

        new Dataset
]
