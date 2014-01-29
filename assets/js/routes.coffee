@app.config(['$routeProvider', ($routeProvider) =>
  $routeProvider.
    #when('/',                         {templateUrl: '/templates/marketing/index', controller: 'MarketingCtrl'}).
    when('/logout',                   {templateUrl: '/templates/logout', controller: 'LogoutCtrl'}).
    when('/login',                    {templateUrl: '/templates/users/login', controller: 'LoginCtrl'}).
    when('/join',                     {templateUrl: '/templates/users/join', controller: 'JoinCtrl'}).
    when('/dashboard',                {templateUrl: '/templates/dashboard/index', controller: 'DashboardCtrl'}).
    when('/dashboard/:when',          {templateUrl: '/templates/dashboard/index', controller: 'DashboardCtrl'}).
    otherwise(       {templateUrl: '/templates/users/login', controller: "LoginCtrl"})
])
