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

var app = angular.module('routingi', ['ngRoute',
    'routingiControllers',
    'ui.bootstrap','dyrektywy','services','session-service',]);
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

            when('/teams/my/', {
                templateUrl: 'templates/teams.html',
                controller: 'myTeamsController'
            }).

            when('/teams/createTeam/', {
                templateUrl: 'templates/createTeam.html',
                controller: 'createTeamController'
            }).

            when('/meetings/createMeeting', {
                templateUrl: 'templates/createMeeting.html',
                controller: 'createMeetingController'
            }).

            when('/teams/createTeam', {
                templateUrl: 'templates/createTeam.html',
                controller: 'createTeamController'
            }).

            when('/login', {
                templateUrl: 'templates/login.html',
                controller: 'UsersCtrl'
            }).

            otherwise({
                redirectTo: '/'
            });
    }]);

var routingiControllers = angular.module('routingiControllers', ['ui.calendar','ui.bootstrap']);

routingiControllers.controller('meetingsController', ['$scope', '$routeParams', 'Meetings',
    function ($scope, $routeParams, Meetings) {
        $scope.meetings = Meetings.my();
    }]);

routingiControllers.controller('teamsController', ['$scope', '$routeParams',
    function ($scope, $routeParams) {
        $scope.teamId = $routeParams.teamId;
    }]);

routingiControllers.controller('createMeetingController', ['$scope', '$routeParams', 'Meetings',
    function ($scope, $routeParams, Meetings) {

        $scope.eventSources = [];
        $scope.meeting = {};
        $scope.meeting.time_ranges = [];

        $scope.open = function(start, end, allDay)  {
            $scope.meeting.time_ranges.push({start_time: start, end_time: end});

            $scope.calendar.fullCalendar('renderEvent',
                {
                    title: 'placeholder',
                    start: start,
                    end: end
                },
                true
            );
            $scope.calendar.fullCalendar('unselect');
        };
        $scope.uiConfig = {
            calendar: {
                selectable: true,
                select: $scope.open,
                selectHelper: true,
                editable: true,
                header: {
                    left: 'title',
                    center: '',
                    right: 'today prev,next'
                },

                firstDay: 1,
                aspectRatio: 1,
                minTime: '00:00:00',
                maxTime: '23:59:59',
                axisFormat: 'HH:mm',
                defaultView: 'agendaWeek',
                timezone: 'local'
            }
        };

        $scope.create = function(meeting) {

            Meetings.save(meeting, function () {}, function () {
                //error
                alert("Something gone wrong :/");
            });
        };
    }]);


routingiControllers.controller('createTeamController', ['$scope', '$routeParams', 'Teams',
    function ($scope, $routeParams, Teams) {
        $scope.team = {};

        $scope.create = function(team) {
            Teams.save(team, function () {}, function () {
                //error
                alert("Something gone wrong :/");
            });
        };
    }]);

routingiControllers.controller('myTeamsController', ['$scope', '$routeParams', 'Teams',
    function ($scope, $routeParams, Teams) {
        $scope.my_teams = Teams.my();
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

services.factory("Meetings", ['$resource', function ($resource) {
    return $resource('/api/v1/meetings/:id', { id: '@id' }, {
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