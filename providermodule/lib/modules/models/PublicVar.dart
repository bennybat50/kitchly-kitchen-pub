import 'dart:io';

class PublicVar {
  static int userId, userPin,basePage=0;
  static String userName,
      firstName,
      lastName,
      userEmail,
      userPhone,
      userPass,
      userGender,
      userProfilePic,
      userProfileLink,
      userDOB,
      userCountry,
      userZipCode,
      userKitchlyID,
      userPinCode,
      userImageStatus,
      userStatus,
      userAddress,
      distance,
      getToken,
      forGotStage="1",
      totalReceived,
      totalDelivered,
      totalEarning,
      kitchenID,
      kitchenUserName,
      kitchenCaption,
      kitchenLocation,
      kitchenTime,
      kitchenVideoUrl,
      kitchenVideoPath,
      kitchenImageUrl,
      kitchenImagePath;

  static bool accountApproved,
      kitchenCreated,
      kitchenHasDisplay,
      kitchenHasAddress,
      kitchenHasHours,
      kitchenHasDelivery,
      hasMenu,
      hasCategory,
      hasExtra,
      hasDish,
      hasPackages=true,
      isRegistration,
      isVerified,
      useServer,onProduction=false,showSpecialPackages=false;
      static List kitchenViews;
      static Map queryKitchen = {
        "query": {"kitchen_id": PublicVar.kitchenID},
        "token": PublicVar.getToken,
      };

      static Map queryKitchenNoKey = {
        "nokey": {"kitchen_id":PublicVar.kitchenID},
          "token":PublicVar.getToken
      };
    static Map getOrderData={
        "query":{
          "kitchen_id":PublicVar.kitchenID,
          "status":""
        },
        "page": 1,
        "limit": 100,
      "token": PublicVar.getToken
      };
    static Map  pageTime={"h":0,"m":0,"s":0};
      static Map appWatch = {
      "kitchen_data": [],
    };

  //Defaults
  static int primaryColor = 0XFF34D186;

  static int white = 0XFFFFFFFF;

  static int nameColor = 0xff333636;

  static int black = 0XFF000000;

  static Map deviceMap,
      appMap,
      kitchenOpenings,
      kitchenCountry = {"symbol": ""};

  static File uploadFile, userFileImg, kitchenTourFile;

  static String defaultKitchenImage = "assets/images/kitchenDefault.jpg",
      videoPlace = "assets/images/video_place.png",
      defaultOnlineImage =
          "https://images.unsplash.com/photo-1508717272800-9fff97da7e8f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=751&q=80",
      noImage = "No Moment's yet,\nShare a moment or Reload",
      selectVideo = "You have not selected a video ",
      noNotification = "No Notifications ",
      noComment = "No Comments yet,\nSend a Comments or Reload",
      noMessage = "No Messages yet,\nSend a message or Reload",
      checkInternet = "Please check your internet connection",
      serverError = 'something went wrong,\n please try again',
      wait = 'One moment please....',
      requestErrorString = "Something went wrong!!\n please try again";
}
