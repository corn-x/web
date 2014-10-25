// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require angular
//= require angular-route
//= require angular-cookies
//= require angular-translate
//= require angular-animate
//= require angular-resource
//= require moment
//= require moment/locale/pl
//= require angular-moment
//= require angular-ui-bootstrap
//= require angular-ui-bootstrap-tpls
//= require angular-translate-loader-static-files
//= require angular-translate-storage-cookie
//= require datetimepicker
//= require fullcalendar
//= require fullcalendar/lang/pl
//= require angular-ui-calendar
//= require qtip2/jquery.qtip
//= require angular-loading-bar
//= require_tree .
//= require_self


var rootScope;

var app = angular.module('routingi', ['ngRoute', 'routingiControllers','ui.bootstrap','dyrektywy','services','session-service']);
app.config(['$routeProvider',
    function ($routeProvider) {
        $routeProvider.
            when('/teams/', {
                templateUrl: 'templates/teams.html',
                controller: 'teamsController'
            }).

            when('/meetings/', {
                templateUrl: 'templates/meetings.html',
                controller: 'meetingsController'
            }).

            when('/meetings/:meetingId/', {
                templateUrl: 'templates/meeting.html',
                controller: 'meetingsController'
            }).

            when('/teams/:teamId/', {
                templateUrl: 'templates/team.html',
                controller: 'teamsController'
            }).

            when('/teams/:createTeam/', {
                templateUrl: 'templates/createTeam.html',
                controller: 'createTeamController'
            }).

            when('/meetings/:createMeeting', {
                templateUrl: 'templates/createMeeting.html',
                controller: 'createMeetingController'
            }).

            when('/home/', {
                controller: 'homeController'
            }).
            when('/login', {
                templateUrl: 'templates/login.html',
                controller: 'UsersCtrl'
            }).

            otherwise({
                redirectTo: '/'
            });
    }]);

var routingiControllers = angular.module('routingiControllers', []);

routingiControllers.controller('meetingsController', ['$scope', '$routeParams','$http','Teams',
    function ($scope, $routeParams, $http, Teams) {
        $scope.meetingId = $routeParams.meetingId;
        $http.get('https://api.github.com/users/mralexgray/repos')
            .success(function (data) {
                $scope.events = data;
            }).error(function(data, status, headers, config) {


            });
        $scope.my_teams = Teams.my();

    }]);

routingiControllers.controller('teamsController', ['$scope', '$routeParams', '$http',
    function ($scope, $routeParams, $http) {
        $scope.teamId = $routeParams.teamId;
        $http.get('https://api.github.com/users/mralexgray/repos')
            .success(function (data) {
                $scope.teams = data;
            }).error(function(data, status, headers, config) {


            });
    }]);

routingiControllers.controller('createTeamController', ['$scope', '$routeParams',
    function ($scope, $routeParams) {
        $scope.meetingId = $routeParams.meetingId;
    }]);

routingiControllers.controller('createMeetingController', ['$scope', '$routeParams',
    function ($scope, $routeParams) {
        $scope.meetingId = $routeParams.meetingId;
    }]);


routingiControllers.controller('homeController', ['$scope', function ($scope) {
        $scope.message = "Home sweet home!";
        $scope.teamId = 6;
    }]);

var dyrektywyApp = angular.module('dyrektywy', [])

    .controller('mainController', ['$scope', function ($scope) {


    }]);
var services = angular.module('services',['ngResource']);

services.factory("Teams", ['$resource', function ($resource) {
    return $resource('/api/v1/teams/:id', { id: '@id' }, {
        //'get': {method:'GET'},
        // 'save': {method:'POST'},
        // 'query': {method:'GET', isArray:true},
        // 'remove': {method:'DELETE'},
        // 'delete': {method:'DELETE'}
        update: { method: 'PATCH' },
        my: { method: 'GET', isArray:true}

        // they're included by default
    })
}]);