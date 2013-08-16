'use strict';

/* Controllers */

function IndexController($scope) {
}

function LandingController($scope, $http) {
  $scope.message = "There is no spoon. Revenge!";
  $scope.submitLogin = function() {
    var data = {'email': $scope.email,
                'password': $scope.password};
    $http.post("login", data)
      .success(function(data, status) {
        // $scope.email = "";
        // $scope.message = "";
      });
      // $scope.messageSent = true;
  };
}

function TestController($scope) {
  $scope.message = "Testing";
}
