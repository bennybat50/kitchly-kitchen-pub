import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:menumodule/menumodule.dart';

class SpecialPackages extends StatefulWidget {
  SpecialPackages({Key key}) : super(key: key);

  @override
  _SpecialPackagesState createState() => _SpecialPackagesState();
}

class _SpecialPackagesState extends State<SpecialPackages> {
  AppBloc appBloc = AppBloc();
  String menuField;
   

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

 checkPackageData() {
    if (!appBloc.hasPackages) {
      return FutureBuilder(
        initialData: appBloc.packages,
        builder: (ctx, snap) {
          if (snap.data == "false") {
            return noNetwork();
          }
          if (snap.data == "empty") {
            return firstPackagesWidget()();
          }
          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.active) {
            return ShowPageLoading();
          }
          return packageBuilder();
        },
        future: getPackages(),
      );
    } else {
      return packageBuilder();
    }
  }

  packageBuilder() {
    if (appBloc.packages.length == 0) {
      return noData();
    } else {
      return ListView(
        children: <Widget>[
          
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
                separatorBuilder: (ctx, i) {
                  return Divider();
                },
                itemCount: appBloc.packages.length,
                reverse: true,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
                    onTap: () {
                   
                      NextPage().nextRoute(
                          context,
                          PackageDetails(
                            packageIndex: i,
                          ));
                    },
                    onLongPress: () => askDeletePackage(dix: i),
                    leading: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      color: Colors.black.withOpacity(0.6),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        splashColor: Colors.grey.withOpacity(0.6),
                        onTap: () {},
                        child: Container(
                            height: 120,
                            width: 80,
                            decoration:BoxDecoration(
                              border:Border.all(width:2, color:Color(PublicVar.primaryColor).withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(10),
                              color:Colors.white,
                            ),
                            child: Padding(
                              padding:  EdgeInsets.all(2.0),
                              child:ClipRRect( 
                                 borderRadius: BorderRadius.circular(8),
                               child: GetImageProvider(
                                placeHolder: PublicVar.defaultKitchenImage,
                                url: appBloc.packages[i]['image'],
                              ),
                              ),
                            ),
                          ),
                      ),
                    ),
                    title: Text(
                      appBloc.packages[i]['caption'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.packages[i]['price']) }',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                    ),
                    trailing: TextButton(
                      child: Text( appBloc.packages[i]['status']?"Online" :"Offline",
                       style: TextStyle(color:appBloc.packages[i]['status']?Color(PublicVar.primaryColor):Colors.grey[400]),),
                      onPressed: (){
                        if(appBloc.packages[i]['status']){
                          AppActions().showAppDialog(
                              context,
                              title: 'Set Package Offline?',
                              descp:'Your customers will not be able to see this packages, are you sure you want to take if offline?',
                              okText: "Confirm",
                              cancleText: "Cancel",
                              danger:true,
                              cancleAction: () => Navigator.pop(context),
                              okAction: () async {
                                changeActiveStatus( pix: i,online: false, packageId:appBloc.packages[i]['id']);
                                Navigator.pop(context);
                              });
                        }else{
                              changeActiveStatus( pix: i,online: true, packageId: appBloc.packages[i]['id']);
                        }
                      },
                    )
                  );
                }),
          )
        ,SizedBox(height: 100,)
        ],
      );
    }
  }

 askDeletePackage({
    dix,
  }) async {
    AppActions().showAppDialog(
        context,
        title: 'Delete Package?',
        descp:
            'Are you sure you want to delete ${appBloc.packages[dix]['caption']} from your special packages?',
        okText: "Delete",
        cancleText: "Cancel",
        danger:true,
        cancleAction: () => Navigator.pop(context),
        okAction: () async {
          Navigator.pop(context);
          if (await Server().deleteAction(
              bloc: appBloc,
              url: Urls.packageActions,
              data: {"dish_id": appBloc.packages[dix]['id']})) {
            appBloc.packages.removeAt(dix);
            appBloc.packages = appBloc.packages;
            AppActions().showSuccessToast(text: 'Package deleted',context: context,);
          } else {
            AppActions().showErrorToast(text: '${appBloc.errorMsg}',context: context,);
          }
        });
  }

  changeActiveStatus({pix,packageId,bool online})async {
    if(await Server().putAction(bloc: appBloc,url: '${Urls.packageActions}/$packageId',
     data: {
          "caption":appBloc.packages[pix]['caption'],
          "kitchen_id":PublicVar.kitchenID,
          "start_date":appBloc.packages[pix]['start_date'],
          "end_date":appBloc.packages[pix]['end_date'],
          "continual":appBloc.packages[pix]['continual'],
          "active":online,
          "descp":appBloc.packages[pix]['descp'],
          "price":appBloc.packages[pix]['price']
          })){
      appBloc.packages[pix]['status']=online;
      appBloc.packages = appBloc.packages;
      AppActions().showSuccessToast(text: online?'Package is online':'Packages is now offline',context: context,);
    }else{
      AppActions().showErrorToast(text: '${appBloc.errorMsg}',context: context,);
    }
  }

    firstPackagesWidget() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:8.0),
      child: DisplayMessage(
        onPress: () => openCreatePackage(),
        asset: 'assets/images/icons/dish_icon.png',
        title: 'Create Packages',
        message:'Create a Package under any of the category you created and you can include the extras too.',
        btnText: 'Create Packages',
      ),
    );
  }

  noNetwork() {
    return DisplayMessage(
      onPress: () => reload(),
      asset: 'assets/images/icons/connection_icon.png',
      message: PublicVar.checkInternet,
      btnText: 'Reload',
    );
  }

  btnCreatePackages({String text}) {
    return FloatingTextButton(
      text: "Add Packages",
      icon: Icons.add,
      width: 145.0,
      onTap: () => openCreatePackage(),
    );
  }

   openCreatePackage() {
    NextPage().nextRoute(context,PackagesAction(update:false));
  }

  noData() {
    return DisplayMessage(
      onPress: () => reload(),
      asset: 'assets/images/icons/dataError_icon.png',
      message: PublicVar.requestErrorString,
      btnText: 'Reload',
      btnWidth: 100,
    );
  }

   getPackages() async {
    return await Server().getPackages(appBloc: appBloc, data: PublicVar.queryKitchen);
  }

   reload() {
    appBloc.hasPackages = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
    body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          child: PublicVar.hasPackages ? checkPackageData() : firstPackagesWidget(),
        ),
      ),
      floatingActionButton:
          PublicVar.hasPackages ? btnCreatePackages(text: "Create Package") : null,
    );
  }
}
