import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import './loginPage.dart';
import './homePage.dart';
import './FileWriter.dart';


class SignupPage extends StatefulWidget {
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final fNameController = new TextEditingController();
  final lNameController =  new TextEditingController();
  final eNameController = new TextEditingController();
  final passController = new TextEditingController();
  final confPassController = new TextEditingController();

  
  //The Widget notifies the user if they already have an account to hit cancel and go to Login Page
  //Once tapped the widget will navigate the user to the Login Page
  Widget _buildLoginButton() {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()),);
    },
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w600
            )
          ),
          TextSpan(
            text: ' Log in',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              fontFamily: "Comic Sans"
            )
          )
        ] 
      ),
    )
  );
}
  
  /// Creates the Register Button 
  /// Makes a POST request with user information
  /// If information is valid a 201 code will be received and user is navigated to Home Page
  Widget _buildRegisterButton(RunMutation runMutation) {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 20, left: 22, right: 22),
      width: 300,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
            setState(() {
              runMutation({"email":eNameController.text, "password": passController.text, "firstName":fNameController.text,"lastName":lNameController.text});
            });
        },
        padding:EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
          ),
        color: Colors.white,
        child: Text(
          "Register",
          style:TextStyle(
            color: Colors.purple,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Open Sans"
            )
          )
        )
      );
  }

  //This widget creates all the text fields for the user's password and confirming the password 
  //@textField, a String the notifies the user what to enter
  //@hintText, a String thats placed in inside the textbox, notifying the user what to enter
  //@Controller, is the corresponding controller to the information being collected (i.e. password field would use passController)
  Widget _buildPasswordField(String textField, String hintText, TextEditingController controller) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          height: 30,
          width: 90,
          child: Text(
            textField,
            style:TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: "Comic Sans"
            )
          ),
        ),
        Container(
          height: 40,
          width: 245,
          padding: EdgeInsets.only(left: 9),
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              )
          ]),
          child: TextField(
            obscureText: true,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.0
              ),
              icon: Icon(
                Icons.person,
                size: 20,
                color: Colors.white
              )
            ),
          ),
        )
      ],
    );
  }
  

  //This widget creates all the text fields for the user's genreal information
  //@textField, a String the notifies the user what to enter
  //@hintText, a String thats placed in inside the textbox, notifying the user what to enter
  //@Controller, is the corresponding controller to the information being collected (i.e. first name field would use fNameController)
  Widget _buildInformationField(String textField, String hintText, TextEditingController controller, bool obscure) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          height: 30,
          width: 90,
          child: Text(
            textField,
            style:TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: "Comic Sans"
            )
          ),
        ),
        Container(
          height: 40,
          width: 245,
          padding: EdgeInsets.only(left: 9),
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              )
          ]),
          child: TextField(
            obscureText: obscure,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.0
              ),
              icon: Icon(
                Icons.person,
                size: 20,
                color: Colors.white
              )
            ),
          ),
        )
      ],
    );
  }


  //Creates the entire forgot password page
  @override
  Widget build(BuildContext context) {

    String homepageQuery = r"""mutation CreateUser($email: String!, $password: String!, $firstName: String!, $lastName: String!) {
          createUser(
            email:$email,
            password: $password,
            firstName: $firstName,
            lastName: $lastName,
          ) {
            user {
                id
            }
          }
        }""";

    final HttpLink httpLink =
          HttpLink(uri: 'http://ubuntu@ec2-3-22-167-219.us-east-2.compute.amazonaws.com/graphql/',
                  );
    
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: InMemoryCache(),
      ),
    );


    return GraphQLProvider(
      client: client,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql(homepageQuery),

            update: (Cache cache, QueryResult result) {
                return cache;
              },

              onCompleted: (dynamic resultData) {
                if(resultData != null) {
                  //FileWriter fw;
                  //fw.writeToken();
                  Navigator.pop(context);
                }
              },
              
              onError: (onError) {
                print("error $onError");
              }
            ), 

        builder: (RunMutation runMutation, QueryResult result){

          return Scaffold(
            
            body: AnnotatedRegion<SystemUiOverlayStyle>(
  
              value: SystemUiOverlayStyle.light,
              child:GestureDetector(
                child: Stack(
                  children: <Widget>[
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.purple[400],
                              Colors.purple[300],
                              Colors.purple[200],
                              Colors.purple[200],
                            ],
                            stops: [0.1, 0.3, 0.5, 0.7],
                          ),
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 75.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "SIGN UP",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.0,
                                fontFamily: "Comic Sans",
                              )
                            ),
                            SizedBox(height: 20.0),
                            _buildInformationField("First Name:", "Enter your first name",fNameController,false),
                            SizedBox(height: 25.0),
                            _buildInformationField("Last Name:", "Enter your last name",lNameController,false),
                            SizedBox(height: 25.0),
                            _buildInformationField("Email:", "Enter your email",eNameController,false),
                            // SizedBox(height: 35.0),
                            // _buildInformationField("Number:", "Enter your number",tNumController,false),
                            SizedBox(height: 25.0),
                            _buildPasswordField("Password:", "Enter your password",passController),
                            //SizedBox(height: 10.0),
                           // _buildPasswordField("Password:", "Re-enter your password",confPassController),
                            _buildRegisterButton(runMutation),
                            _buildLoginButton()
                          ]
                        )
                    ),
                  ],
                ),
              )
            ),
          );
        }
        )
    );
  }
}





  // Future<int> _makePostRequest(String name, String email, String pass) async {
  // // set up POST request arguments
  //   String url = 'http://ec2-3-21-170-238.us-east-2.compute.amazonaws.com/api/profile/';
  //   Map<String, String> headers = {"Content-type": "application/json"};
  //   String json = '{"email": ' + '"' + email + '",'+ ' "name": ' + '"' + name + '"'+  ', "status": ' +  '"Sleep"'+ ',' + '"household": ' + '"' + null + '",' + '"password": ' + '"' + pass + '"' + "}";
  //   print(json);
  //   // make POST request
  //   Response response = await post(url, headers: headers, body: json);
  //   // check the status code for the result
  //   int statusCode = response.statusCode;
  //   print(statusCode);
  //   // this API passes back the id of the new item added to the body
  //   String body = response.body;
  //   if(statusCode == 200) {
  //     FileWriter fw = new FileWriter();
  //     fw.writeToken(body);
  //   }
  // }

