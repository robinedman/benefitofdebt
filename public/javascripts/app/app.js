'use strict';

/* App Module */

angular.module('HashBangURLs', []).config(['$locationProvider', function($location) {
  $location.hashPrefix('!');
}]);

var benefitofdebt = angular.module('benefitofdebt', ['HashBangURLs']);

benefitofdebt.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
      when('/', {templateUrl: 'landing', controller: LandingController}).
      when('/test', {templateUrl: 'test', controller: TestController}).
      when('/members', {templateUrl: 'members', controller: MembersController}).
      otherwise({redirectTo: '/'});
}]);

benefitofdebt.run( function($rootScope, $location) {
  // This might be completely unnecessary
});
