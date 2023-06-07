import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:providermodule/modules/utils/app_actions.dart';
import 'package:providermodule/providermodule.dart';
import 'package:provider/provider.dart';

class FeedBackPage extends StatefulWidget {
  const FeedBackPage({Key key}) : super(key: key);

  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  AppBloc appBloc;
  List ratingWords = [
    "",
    "I am very Dissatisfied",
    "I am Dissatisfied",
    "I am ok",
    "I am Satisfied",
    "I am very Satisfied"
  ];
  var ratingIndex, index;
  String commentField;
  TextEditingController commentController = TextEditingController();
  List<String> attachments = [];
  bool isHTML = false;



  Future<void> send() async {
    final Email email = Email(
      body: "KITCHEN:${appBloc.kitchenDetails['kitchen_name']}  \n\nCHEF: ${appBloc.kitchenDetails['username']} \n\n REACTION: ${ratingWords[ratingIndex]}  \n\nCOMMENT: ${commentController.text}",
      subject: "Kitchen App Feedback",
      recipients: ["kitchly.kitchens@gmail.com","benny.bat51@gmail.com","geo.stephone@gmail.com"],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    AppActions().showSuccessToast(context:context,text:platformResponse);
  }


  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            iconSize: 30,
            icon: Icon(Icons.close_rounded)),
      ),
      bottomNavigationBar:ratingIndex == null ? null: ButtonWidget(
          onPress: () async {
            await send();
            Navigator.pop(context);
          },
          height: 50.0,
          fontSize: 20.0,
          radius: 0.0,
          txColor: Colors.white,
          bgColor: Color(PublicVar.primaryColor),
          text: 'Send Feedback',
        ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Text(
              "How was your experience with Kitchly Kitchen App?",textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
           SizedBox(
            height: 10,
          ),
          RatingBar.builder(
            initialRating: 0,
            itemCount: 5,
            updateOnDrag: true,
            allowHalfRating: false,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  );
                case 1:
                  return Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.orangeAccent,
                  );
                case 2:
                  return Icon(
                    Icons.sentiment_neutral,
                    color: Colors.yellow,
                  );
                case 3:
                  return Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.lightGreen,
                  );
                case 4:
                  return Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                  );
                default:return SizedBox();
              }
            },
            onRatingUpdate: (rating) {
              print(rating);
              setState(() {
                ratingIndex = rating.round();
              });
            },
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${ratingIndex == null ? "" : ratingWords[ratingIndex]}",
            style: TextStyle(color: Colors.grey[600]),
          ),
          
          SizedBox(
            height: 50,
            width: double.infinity,
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:18.0),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              controller: commentController,
              textCapitalization: TextCapitalization.sentences,
              onSaved: (String val) {
                commentField = val;
              },
              decoration: FormDecorator(
                  fillColor: Colors.white,
                  hint: 'Leave a comment...',
                  helper: 'e.g I love the app.'),
            ),
          ),
        ]),
      ),
    );
  }


  
}