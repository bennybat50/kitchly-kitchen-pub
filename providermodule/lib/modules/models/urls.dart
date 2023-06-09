class Urls {
  static String offlineIP = 'http://192.168.1.3',
      onlineIP = 'http://206.189.124.254',
      domain = 'https://kitchly.co/api/v1',
      site='https://kitchly.co',
      ip = domain,
      port1 = '$ip:6000/api/v1',
      port3 = '$ip:6003/api/v1',
      port4 = '$ip:6004/api/v1',
      port5 = '$ip:6005/api/v1',
      port6 = '$ip:6006/api/v1';
     static bool isLive=true;
  //URLS
  static String login = "${isLive?ip:port1}/chefs/signin",
      create = "${isLive?ip:port1}/chefs",
      verify = "${isLive?ip:port1}/chefs/verify",
      resendCode = "${isLive?ip:port1}/chefs/resend/code",
      resetPassword = "${isLive?ip:port1}/chefs/reset/account",
      logOut = "${isLive?ip:port1}/chefs/logout",
      createKitchen = "${isLive?ip:port3}/kitchens",
      getKitchens = "${isLive?ip:port3}/kitchens/",
      getKitchensSummary = "${isLive?ip:port3}/kitchens/summary",
      kitchenDetails = "${isLive?ip:port3}/kitchens/details",
      setUpDelivery ="${isLive?ip:port3}/setup/delivery",
      enableDeliveryRoutes ="${isLive?ip:port3}/kitchens/setup/delivery-routes",
      setUpDeliveryRoutes ="${isLive?ip:port3}/kitchens/delivery-routes",
      deactivateDelivery="${isLive?ip:port3}/deactivate/delivery",
      activiteEatIn = "${isLive?ip:port3}/activate/eatin",
      deactivateEatIn = "${isLive?ip:port3}/deactivate/eatin",
      activiteKitchen = "${isLive?ip:port3}/kitchens/activate",
      deactivateKitchen = "${isLive?ip:port3}/kitchens/deactivate",
      activatePickUp = "${isLive?ip:port3}/activate/self-pickup",
      deactivatePickUp = "${isLive?ip:port3}/deactivate/self-pickup",
      changeKitchenOrderStatus = "${isLive?ip:port3}/kitchens/order/status",
      createMenu = "${isLive?ip:port3}/menus",
      getMenu = "${isLive?ip:port3}/menus/info",
      deleteMenu = "${isLive?ip:port3}/menus",
      extrasAction = "${isLive?ip:port3}/extras",
      getExtras = "${isLive?ip:port3}/extras/info",
      optionsAction = "${isLive?ip:port3}/options",
      getOptions = "${isLive?ip:port3}/options/info",
      getAnOptions = "${isLive?ip:port3}/options/id",
      getMeals = "${isLive?ip:port3}/meals",
      getDishDuration = "${isLive?ip:port3}/dishes/durations",
      createDish = "${isLive?ip:port3}/dishes",
      getDishes = "${isLive?ip:port3}/dishes/info",
      getPackages = "${isLive?ip:port3}/specials/info",
      packageActions = "${isLive?ip:port3}/specials",
      dishActions = "${isLive?ip:port3}/dishes/",
      getCountries = "${isLive?ip:port3}/q/countries",
      getStates = "${isLive?ip:port3}/q/states",
      getDistricts = "${isLive?ip:port3}/q/districts",
      getPendingOrders = "${isLive?ip:port5}/orders/pending",
      acceptOrders = "${isLive?ip:port5}/orders/accept",
      rejectOrders = "${isLive?ip:port5}/orders/reject",
      dishStatus = "${isLive?ip:port5}/orders/dish/status",
      getKitchenOrders = "${isLive?ip:port5}/orders/kitchen",
      orderReady = "${isLive?ip:port5}/orders/ready",
      orderConfirmed = "${isLive?ip:port5}/orders/confirmed",
      orderIntransit = "${isLive?ip:port5}/orders/intransit",
      orderDelivery = "${isLive?ip:port5}/orders/delivery",
      getAppInfo = "${isLive?ip:port5}/appinfo",
      payments = "${isLive?ip:port5}/payments/kitchen",
        getDeliveryCompany = "$site/carriage/companies",
      getDeliveryPrice = "$site/carriage/delivery/query";
}
