// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
//
// class DynamicLinksService {
//   Future<String> createDynamicLink({String data,packageName,surfix,link}) async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: surfix,
//       link: Uri.parse(link),
//       androidParameters: AndroidParameters(
//         packageName: packageName,
//         minimumVersion: 0,
//       ),
//       dynamicLinkParametersOptions: DynamicLinkParametersOptions(
//         shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
//       ),
//       iosParameters: IosParameters(
//         bundleId: packageName,
//         minimumVersion: '0',
//       ),
//     );
//
//     Uri dynamicUrls ;
//     await parameters.buildShortLink().then((value) {
//      dynamicUrls = value.shortUrl;
//     } );
//     return dynamicUrls.toString();
//   }
//
//   Future handleDynamicLink() async {
//     //STARTUP FROM DYNAMIC LINK LOGIC
//     //Get initial dynamic link if app is started using link
//     var response;
//     PendingDynamicLinkData data =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//   response = _handleDeepLink(data);
//
//     //INTO FOREGROUND FROM DYNAMIC LINK LOGIC
//     FirebaseDynamicLinks.instance.onLink(
//       onSuccess: (PendingDynamicLinkData dynamicLink) async{
//       response =  _handleDeepLink(dynamicLink);
//       },
//       onError: (OnLinkErrorException e)async{
//         print("Dynamic Link Failed : ${e.message}");
//       }
//     );
//
//     return response;
//   }
//
//    _handleDeepLink(PendingDynamicLinkData data) {
//     var kitchenId;
//     Uri deepLink = data?.link;
//
//     if (deepLink != null) {
//       print("_handleDeepLink | deepLink: $deepLink");
//       var isID=deepLink.pathSegments.contains("kitchen");
//       if(isID){
//          kitchenId=deepLink.queryParameters['_id'];
//       }
//     }
//     return kitchenId;
//   }
// }
