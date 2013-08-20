'use strict';

/* Controllers */

function IndexController($scope) {
}

function LandingController($scope, $http, $location) {
  $scope.message = "There is no spoon. Revenge!";
  $scope.submitLogin = function() {
    var data = {'email': $scope.email,
                'password': $scope.password};
    $http.post("login", data)
      .success(function(data, status) {
        $location.path('/members')
        console.log("Login success")
      });
      // $scope.messageSent = true;
  };
}

function MembersController($scope) {
  $scope.message = "Membering";
}

function TestController($scope) {
  $scope.message = "Testing";
}
