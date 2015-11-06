"use strict"

app = angular.module "app.services"

app.service 'UserService', [
    "$http"
    "$rootScope"
    "$log"
    "$q"
    ($http, $rootScope, $log, $q) ->
        class User
            checkUniqueness: (key, value) ->
                $log.info "UserService checkUniqueness called"
                $log.debug
                    key: key
                    value: value

                url = $rootScope.apiBase + "/v0/users/check?" + key + '=' + escape(value)
                $http.get(url).then (results) ->
                    $log.error "UserService checkUniqueness success (user already exist)"
                    $log.debug
                        results: results

                    console.log results.data.status

                    # Because at finding the user in the db it is not allowed to take this name by another user
                    $q.reject(results)
                , (error) ->
                    $log.info "UserService checkUniqueness get error (user does not exist)"
                    $log.debug
                        error: error

                    # Not finding the user in the db is good and so on we resolve the promise
                    $q.resolve(error)

        new User
]
