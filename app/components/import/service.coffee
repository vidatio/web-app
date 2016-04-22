## ImportService
# For reading files
# For converting data sets
# For setting the table
## ======================

"use strict"

app = angular.module "app.services"

app.service 'ImportService', [
    "$q"
    "$translate"
    "$log"
    "DataService"
    "ProgressService"
    "ngToast"
    ($q, $translate, $log, Data, Progress, ngToast) ->
        class Reader
            constructor: ->
                @reader = new FileReader()
                @deferred = undefined
                @progress = 0

            readFile: (file, fileType) ->
                $log.info "ImportService readFile called"
                $log.debug
                    file: file
                    fileType: fileType

                @deferred = $q.defer()
                @progress = 0

                @reader.onload = =>
                    @deferred.resolve @reader.result

                @reader.onerror = =>
                    @deferred.reject @reader.result

                switch fileType
                    when "csv"
                        @reader.readAsText file
                    when "zip"
                        @reader.readAsArrayBuffer file

                return @deferred.promise

            # @method getFile
            # @descriptions check the
            # @param {String} file
            getFile: (file) ->
                $translate("OVERLAY_MESSAGES.READING_FILE").then (message) =>
                    Progress.setMessage message

                    # Can't use file.type because of chromes File API
                    fileType = file.name.split "."
                    fileType = fileType[fileType.length - 1]
                    fileName = file.name.toString()
                    fileName = fileName.substring 0, fileName.lastIndexOf(".")
                    Data.name = fileName

                    maxFileSize = 52428800
                    if file.size > maxFileSize
                        $log.warn "ImportCtrl maxFileSize exceeded"
                        $log.debug
                            fileSize: file.size

                        $translate('TOAST_MESSAGES.FILE_SIZE_EXCEEDED', {maxFileSize: maxFileSize / 1048576})
                        .then (translation) ->
                            Progress.resetMessage()
                            ngToast.create(
                                content: translation
                                className: "danger"
                            )
                        return

                    if fileType isnt "csv" and fileType isnt "zip"
                        $log.info "ImportCtrl data format not supported"
                        $log.debug
                            format: fileType

                        $translate('TOAST_MESSAGES.NOT_SUPPORTED', { format: fileType })
                        .then (translation) ->
                            Progress.resetMessage()
                            ngToast.create(
                                content: translation
                                className: "danger"
                            )
                        return

                    @readFile(file, fileType).then (fileContent) ->
                        $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                            Progress.setMessage message

                        Data.initTableAndMap fileType, fileContent

                    , (error) ->
                        $log.error "ImportCtrl Import.readFile promise error called"
                        $log.debug
                            error: error

                        Progress.resetMessage()

                        $translate('TOAST_MESSAGES.READ_ERROR')
                        .then (translation) ->
                            ngToast.create
                                content: translation
                                className: "danger"

        new Reader
]
