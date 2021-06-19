
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: Container(
        width: 40,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'Connect');
          },
          child: Icon(Icons.arrow_back,size: 30,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(50,0,50,0),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              spacing: 0,
              runSpacing: 10,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,30,0,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/img/logo_placeholder.png'),
                        width: 120,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Alpha Version 1.0',
                        style: TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'RaspPlayer',
                        style: TextStyle(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Text(
                  'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan> [
                        TextSpan(
                          text: 'Privacy Policy\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'This SERVICE is provided by and is intended for use as is. This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service. If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at RaspPlayer unless otherwise defined in this Privacy Policy.\n\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextSpan(
                          text: 'Personal Data\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'We do not store personal data. There is no registration required nor will the application ever give the option to submit personal data. The only data that we receive, are game relevant information that is used to improve the player experience. This data, like how long a category was played, or how many tools have been used, cannot be assigned to a person, since all the data is being sent without user information (like User IP, etc.) and will be held anonymously at any time.\n\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextSpan(
                          text: 'Security\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.\n\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextSpan(
                          text: 'Children\'s Privacy\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.\n\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextSpan(
                          text: 'Changes to This Privacy Policy\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.\n\n',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}