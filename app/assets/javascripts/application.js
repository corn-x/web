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

var test;
var rootScope;

var app = angular.module('routingi', ['ngRoute',
    'routingiControllers',
    'ui.bootstrap','dyrektywy','services','session-service']);
app.run(['$rootScope', function ($rootScope)    {
    rootScope = $rootScope;
}]);
app.config(['$routeProvider',
    function ($routeProvider) {
        $routeProvider.
            when('/teams', {
                templateUrl: 'templates/teams.html',
                controller: 'teamsController'
            }).

            when('/meetings', {
                templateUrl: 'templates/meetings.html',
                controller: 'meetingsController'
            }).

            when('/teams/my', {
                templateUrl: 'templates/teams.html',
                controller: 'myTeamsController'
            }).

            when('/teams/createTeam', {
                templateUrl: 'templates/createTeam.html',
                controller: 'createTeamController'
            }).

            when('/meetings/createMeeting', {
                templateUrl: 'templates/createMeeting.html',
                controller: 'createMeetingController'
            }).

            when('/login', {
                templateUrl: 'templates/login.html',
                controller: 'loginCtrl'
            }).

            when('/meetings/:id/chooseTime', {
                templateUrl: 'templates/chooseTime.html',
                controller: 'chooseTimeController'
            }).
            when('/', {
                templateUrl: 'templates/root.html'
            }).

            when('/register', {
                templateUrl: 'templates/register.html',
                controller: 'registerCtrl'
            }).

            otherwise({
                redirectTo: '/'
            });
    }]);

var routingiControllers = angular.module('routingiControllers', ['ui.calendar','ui.bootstrap']);

routingiControllers.controller('loginCtrl', ['$scope', '$routeParams','SessionService',
    function ($scope, $routeParams, SessionService) {
        $scope.login = function (user) {
            return SessionService.login(user.email, user.password, user.remember_me);
        };

    }]);

routingiControllers.controller('registerCtrl', ['$scope', '$routeParams','SessionService',
    function ($scope, $routeParams, SessionService) {
        $scope.create = function (user) {
            return SessionService.register(user);
        };

    }]);

routingiControllers.controller('NavCtrl', ['$scope', '$routeParams','SessionService','$rootScope',
    function ($scope, $routeParams,SessionService,$rootScope) {
        $scope.getCurrentUser = function () {
            SessionService.requestCurrentUser().then(function (current_user) {
                if (current_user === null) {
                    return;
                }
                return $scope.current_user = current_user;
            });
        };
        $rootScope.$on("refreshUser", function (event, my_user) {
            var current_user;
            current_user = my_user.my_user;
            if (current_user === null) {
                return $scope.current_user = "";
            }
            
            $scope.current_user = current_user;

        });
        $scope.getCurrentUser();
        $scope.logout = function () {
            if ($scope.source != null)
                $scope.source.close();
            return SessionService.logout();
        };
    }]);

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
        $scope.time_ranges = [];

        $scope.open = function(start, end, allDay)  {
            var event = {
                    title: 'placeholder',
                    start: start,
                    end: end,
                    id: Math.random().toString(36).substring(7)
                };
            $scope.calendar.fullCalendar('renderEvent', event, true);
            $scope.time_ranges.push({start_time: start, end_time: end, event:event});

            
            $scope.calendar.fullCalendar('unselect');
        };
        $scope.eventClick = function(event) {
            console.log(event);
            $scope.calendar.fullCalendar('removeEvents', event.id);
            var remain = [];
              for(var i in $scope.time_ranges){
                if($scope.time_ranges[i].event.id == event.id){
                  continue;
                }
                remain.push($scope.time_ranges[i]);
              }
              $scope.time_ranges = remain;
              console.log(remain);  
        };
        $scope.uiConfig = {
            calendar: {
                selectable: true,
                select: $scope.open,
                selectHelper: true,
                eventClick: $scope.eventClick,
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
        test = $scope;
        $scope.create = function() {
            //$scope.meeting.time_ranges = $scope.time_ranges;
            Meetings.save(angular.extend($scope.meeting,{time_ranges:$scope.time_ranges}), function() {}, function() {
                //error
                alert("Something went wrong.");
            });
        };
    }]);


routingiControllers.controller('chooseTimeController', ['$scope', '$routeParams',
    function ($scope, $routeParams) {

        var id = $routeParams.id;

        $scope.eventSources = [{
            url: "/api/v1/meetings/"+id+"/stats",
            editable: false,
            ignoreTimezone: false
        }];

        $scope.meeting = {};
        $scope.meeting.time_ranges = [];

        $scope.eventClick = function(event) {
            console.log(event);
            $scope.calendar.fullCalendar('removeEvents', event.id);
            var remain = [];
              for(var i in $scope.meeting.time_ranges){
                if($scope.meeting.time_ranges[i].event.id == event.id){
                  continue;
                }
                remain.push($scope.meeting.time_ranges[i]);
              }
              $scope.meeting.time_ranges = remain;
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

    }]);



routingiControllers.controller('myTeamsController', ['$scope', '$routeParams', 'Teams', 'Invitations',
    function ($scope, $routeParams, Teams, Invitations) {
        $scope.my_teams = Teams.my();
        $scope.pending_invitations = Invitations;
    }]);

routingiControllers.controller('createTeamController', ['$scope', '$routeParams', 'Teams',
    function ($scope, $routeParams, Teams) {
        $scope.team = {};
        $scope.create = function(team) {
            Teams.save(team, function() {}, function() {
                //error
                alert("Something went wrong.");
            });
        };
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


services.factory("Invitations", ['$resource', function ($resource) {
    return $resource('/api/v1/invitations/my', {
        'get': {method:'GET'}//,
        // 'save': {method:'POST'},
        // 'query': {method:'GET', isArray:true},
        // 'remove': {method:'DELETE'},
        // 'delete': {method:'DELETE'}
       // update: { method: 'PATCH' }//,
       // my: { method: 'GET', isArray:true}

        // they're included by default
    })
}]);