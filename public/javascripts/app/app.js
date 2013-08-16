'use strict';

/* App Module */

angular.module('HashBangURLs', []).config(['$locationProvider', function($location) {
  $location.hashPrefix('!');
}]);

var benefitofdebt = angular.module('benefitofdebt', ['ngSanitize', 'HashBangURLs']);

benefitofdebt.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
      when('/', {templateUrl: 'landing', controller: LandingController}).
      when('/test', {templateUrl: 'test', controller: TestController}).
      otherwise({redirectTo: '/'});
}]);

benefitofdebt.run( function($rootScope, $location) {
  // This might be completely unnecessary
});
