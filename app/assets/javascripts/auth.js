/**
 * Manage sign in/out and etc. actions
 */
var session_service = angular.module('session-service', []);
session_service.factory("SessionService", [ '$http', '$q', '$rootScope','$location', function ( $http, $q, $rootScope,$location) {
    var service;
    service = {
        /**
         * Login function for <b>UserAccount</b> for devise in rails.
         *
         * @param {string} email user email
         * @param {string} password user password
         * @param remember_me true or false (null==false)
         */
        login: function (email, password, remember_me) {
            return $http.post("/api/v1/users/sign_in.json", {
                user: {
                    email: email,
                    password: password,
                    remember_me: remember_me
                }
            }).then((function (response) {
                if (response.status !== 201) {
                    //AlertService.add("danger", response.data.error);
                } else {
                    service.currentUser = response.data;
                    console.log(response.data);
                    service.broadcastToNav(service.currentUser);
                    //AlertService.clear();
                    //AlertService.add("success", "Logged in", 2000);
                    $location.path('#/teams');
                }
            }), function (response) {
                //return AlertService.add("danger", response.data.error);
            });
        },
        /**
         * Logout from session for devise in rails
         */
        logout: function () {
            return $http["get"]("/api/v1/users/sign_out").then(function () {
                service.currentUser = null;
                service.broadcastToNav(null);
                //AlertService.clear();
                //AlertService.add("warning", "Successfully logged out", 2000);
                $location.go('/');
            });
        },
        /**
         * First page of password resetting. Only field for email.
         *
         * @param {string} email email of user which forgotten password
         * @returns {object} response object from $http.put
         */
        reset: function (email) {
            return $http.post("/api/v1/users/password", {
                user_account: {
                    email: email
                }
            }).then(function (response) {
                if (response.status === 201) {
                    $state.go('login');
                }
                return response;
            });
        },
        /**
         * Second page of password resetting (after click on email link)
         *
         * @param {string} password new password
         * @param {string} confirm_password new password confirmation
         * @param {string} reset_password_token token from page path to authorize
         * password change in devise
         * @returns {object} response object from $http.put
         */
        edit_confirm_mail: function (password, confirm_password, reset_password_token) {
            console.log(reset_password_token);
            return $http.put("/api/v1/users/password", {
                user_account: {
                    password: password,
                    password_confirmation: confirm_password,
                    reset_password_token: reset_password_token
                }
            }).then(function (response) {
                if (response.status === 204) {
                    $state.go('login');
                }
                return response;
            });
        },
        /**
         * Request current user from API.
         * If user is already set in service it return value from it, else create connection to server and download current_user.
         * @returns {object} current user object
         */
        requestCurrentUser: function () {
            if (service.currentUser !== null) {
                return $q.when(service.currentUser);
            } else {
                return $http.get("/api/v1/users/current").then(function (response) {
                    service.currentUser = response.data;
                    return service.currentUser;
                });
            }
        },
        /**
         * Just return current user or null (if no one logged)
         * @returns {null|object}
         */
        getCurrentUser: function () {
            return service.currentUser;
        },
        /**
         * Variable to save current user object
         */
        currentUser: null,
        /**
         * Check if anybody is signed in
         * @returns {boolean} true if authenticated
         */
        isAuthenticated: function () {
            return !!service.currentUser;
        },
        /**
         * Broadcast for user change for navbar
         *
         * @param {object} current_user logged user object
         */
        broadcastToNav: function (current_user) {
            return $rootScope.$broadcast('refreshUser', {
                my_user: current_user
            });
        },

        /**
         * Variable to save return page
         */
        returnPage: null,
        /**
         * Get page to return after successful login
         * @returns {string} last watched page
         */
        getReturnPage: function () {
            var myPage = service.returnPage || "/";
            service.returnPage = null;
            return myPage;
        }
    };
    return service;
}]);


// app/assets/javascripts/angular/controllers/users/UsersCtrl.js

session_service.controller('UsersCtrl', [
    '$scope', 'SessionService','$location', function ($scope, SessionService,$location) {
        /**
         * Make login after click
         * Invokes SessionService.login()
         * @param user {object} with parameters from form (login.html)
         */
        $scope.login = function (user) {
            // AlertService.clear();
            return SessionService.login(user.email, user.password, user.remember_me);
        };
        /**
         * Logout after click
         */
        $scope.logout = function () {
            return SessionService.logout();
        };
        /**
         * Register user (not used for now)
         * Invokes SessionService.register()
         * @param user {object} with parameters from form (no template)
         */
        $scope.register = function (user) {
            // AlertService.clear();
            SessionService.register(user.email, user.password, user.confirm_password, user.type).then((function (response) {
                // return AlertService.add("success", "Registered");
            }), function (response) {
                // return AlertService.processErrors(response, $scope);
            });
        };
        /**
         * Reset password after email enter
         * Invokes SessionService.reset()
         * @param user {object} with email from form (reset_password.html)
         * @returns {*}
         */
        $scope.reset = function (user) {
            // AlertService.clear();
            return SessionService.reset(user.email).then((function (response) {
                // return AlertService.add("success", "Reset password email has been sent");
            }), function (response) {
                // return AlertService.processErrors(response, $scope);
            });
        };
        /**
         *
         * @param user {object} with parameters from form (reset_password_instructions.html)
         * @returns {*}
         */
        $scope.edit_pass_confirm = function (user) {
            // AlertService.clear();
            return SessionService.edit_confirm_mail(user.password, user.confirm_password, $stateParams.token).then((function (response) {
                // return AlertService.add("success", "Password has been changed");
            }), function (response) {
                // return AlertService.processErrors(response, $scope);
            });
        };
    }
]);