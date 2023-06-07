import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchlykitchendb/kitchlykitchendb.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   AppBloc appBloc;  
   UsersDb userDB = UsersDb(databaseProvider: DatabaseProvider());
  var fNameCtrl=TextEditingController(),lNameCtrl=TextEditingController(),phoneCtrl=TextEditingController(),emailCtrl=TextEditingController();
  String fnameField,lnameField,phoneField,emailField;
  bool loading = false, autoValidate = false,firstTime=false;
  double deviceHeight,deviceWidth,deviceFont;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if(!firstTime){
      // I did this because of the User update account Api is not working
      fNameCtrl.text = appBloc.kitchenDetails['kitchen_name'] ?? '';
      lNameCtrl.text = appBloc.kitchenDetails['caption'] ?? '';
      phoneCtrl.text = appBloc.kitchenDetails['phone'] ?? '';
      firstTime=true;
    }
    deviceHeight=MediaQuery.of(context).size.height;
    deviceWidth=MediaQuery.of(context).size.width;
    deviceFont=deviceHeight *0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Feather.arrow_left,size: 30,),
            onPressed: () {
              Navigator.pop(context);
            }),

      ),
      body: SingleChildScrollView(child: Padding(
        padding:  EdgeInsets.symmetric(horizontal:10.0,vertical: 3.0),
        child: Form(
          key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal:20,vertical: 5),
              alignment: Alignment.centerLeft,
              child: Text(
              'Quick Settings',
              style: TextStyle(fontSize: 4.4*deviceFont, fontWeight: FontWeight.w700),
          ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:8.0,vertical: 12.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: fNameCtrl,
                textCapitalization: TextCapitalization.words,
                validator: Validation().text,
                onSaved: (String val) {
                  fnameField = val;
                },
                decoration: FormDecorator(
                    hint: 'Kitchen Name',
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:8.0,vertical: 12.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: lNameCtrl,
                textCapitalization: TextCapitalization.words,
                validator: Validation().text,
                onSaved: (String val) {
                  lnameField = val;
                },
                decoration: FormDecorator(
                    hint: 'Caption',),

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:8.0,vertical: 12.0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneCtrl,
                textCapitalization: TextCapitalization.words,
                validator: Validation().phone,
                onSaved: (String val) {
                  phoneField = val;
                },
                decoration: FormDecorator(
                    hint: 'Phone',),
                    
              ),
            ),
Padding(
  padding: EdgeInsets.symmetric(horizontal:8.0,vertical: 50),
  child:   ButtonWidget(
  
              onPress: () => validateFields(),
  
              height: deviceHeight*0.07,
  
              fontSize:20.0,
  
              loading: loading,
  
              txColor: Colors.white,
  
              bgColor: Color(PublicVar.primaryColor),
  
              text: 'Update Account',
  
            ),
), SizedBox(height:500)

          ],),
        ),
      ),),
      
    );
  }

   validateFields() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showLoading();
    if (await AppActions().checkInternetConnection()) {
      updateAccount();
       FocusScope.of(context).unfocus();
    } else {
      showLoading();
      AppActions().showErrorToast(text: PublicVar.checkInternet,context: context,);
    }
    } else {
      setState(() => autoValidate = true);
    }
  }



  updateAccount() async {
    Map data = {
    "kitchen_name": fnameField,
    "caption": lnameField,
    "user_name":appBloc.kitchenDetails['username'] ,
    "email": PublicVar.userEmail,
    "phone": phoneField
  };
   if(!PublicVar.onProduction) print(data);
    if (await Server().putAction(bloc: appBloc, url: "${Urls.createKitchen}/${PublicVar.kitchenID}", data: data)) {
     if(!PublicVar.onProduction) print(appBloc.mapSuccess);
      // PublicVar.firstName=fnameField;
      // PublicVar.lastName=lnameField;
      // PublicVar.userPhone=phoneField;
      // await userDB.update(UserDoa().fromMap({
      //   'id':1,
      //   'firstName': PublicVar.firstName,
      //   'lastName': PublicVar.lastName,
      //   'phone': PublicVar.userPhone,
      // }));
      AppActions().showSuccessToast(text:"Account update successful",context: context,);
      showLoading();
      await Server().queryKitchen(appBloc: appBloc);
    } else {
      showLoading();
      AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
    }
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    if (mounted) {
      setState(() {});
    }
  }

}




