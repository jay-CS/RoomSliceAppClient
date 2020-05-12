import './FileWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'textWrapper.dart';


double scrnWidth = 0;
double scrnHeight = 0;
double blockSize = 0;
double blockSizeVertical = 0;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key:key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<String> userName;
  Map<String, String> household = {};
  List s = [];


  @override
  void initState() {
    super.initState();
    FileWriter fw = new FileWriter();
    userName = fw.readToken();
  }



  Widget build(BuildContext context) {


    scrnWidth = MediaQuery.of(context).size.width;
    scrnHeight = MediaQuery.of(context).size.height;
    blockSize = scrnWidth / 100;
    blockSizeVertical = scrnHeight / 100;

    TextWrapper genText = new TextWrapper(context);
    List <Widget> statusBarText = new List<Widget>();

    //MOVE genText maybe, just need to change the hardcoded "DO NOT DISTRUB"
//------------------------------------STATUS BAR TEXT------------------------------
    // double statusBarHeight = blockSizeVertical*3;
    // genText.setStyle(TextStyle(
    //   fontSize: statusBarHeight,
    //   fontWeight: FontWeight.bold,
    // ));
    // genText.setData("Status: ");
    // statusBarText.add(genText.constructText());
    // statusBarText.add(statusGenerator(2, statusBarHeight));
    // genText.setData("Home (Do Not Disturb)");
    // genText.setStyle(TextStyle(
    //   fontSize: statusBarHeight,
    //   fontStyle: FontStyle.normal,
    // ));

    // statusBarText.add( genText.constructText());


//------------------------------------STATUS BAR TEXT------------------------------

  

    return WillPopScope(
      //Needed to prevent user from sliding back to other pages
      onWillPop: () async => false,
      child: Scaffold(
        primary: true,
        backgroundColor: Colors.purple[100],
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          child: FutureBuilder(
            future: userName,
            builder: (context, snapshot) {
              
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                return Container();
                case ConnectionState.waiting:
                return Container();
                case ConnectionState.none:
                return Container();
                case ConnectionState.done:

                  //------------------------------------Retrieving User JWT Token--------------------------------//
                  int len = snapshot.data.toString().length;
                  print(snapshot.data.toString());
                  String token = snapshot.data.toString().substring(19,len-2).trim();
                  //print("TOKEN" + token);

                  //------------------------------------Initialzing GraphQL Client(User) and Query-------------------------------//
                  String homepageQuery = '''query {
                                              homepage {
                                                ... on HouseholdType {
                                                    name
                                                }
                                                
                                                ... on UserType{
                                                    firstName
                                                    status
                                                }
                                                
                                              }
                                          }''';

                  String householdQuery  = """ 
                                            query {
                                                  me {
                                                      household {
                                                          id
                                                      }
                                                  }
                                              }
                                              """;
                  final HttpLink httpLink =
                       HttpLink(uri: 'http://ubuntu@ec2-3-22-167-219.us-east-2.compute.amazonaws.com/graphql/',
                                headers: {
                                "Authorization":"JWT $token"
                                 }
                               );
                  
                  final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
                    GraphQLClient(
                      link: httpLink,
                      cache: InMemoryCache(),
                    ),
                  );
                  
                  //------------------------------------GraphQL Query--------------------------------//
                  return GraphQLProvider(
                    client: client,
                    child: Query(
                      options: QueryOptions(documentNode: gql(homepageQuery),),
                      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {

                        if (result.hasException) {
                            print(result.exception.toString());
                        }
                        
                      
                        if(result.data != null && result.data.toString() != null) {
                          s = result.data["homepage"];
                          double statusBarHeight = blockSizeVertical*3;
                          genText.setStyle(TextStyle(
                            fontSize: statusBarHeight,
                            fontWeight: FontWeight.bold,
                          ));
                          genText.setData("Status: ");
                          statusBarText.add(genText.constructText());
                          statusBarText.add(statusGenerator(2, statusBarHeight));
                          genText.setData(s[1]["status"]);
                          genText.setStyle(TextStyle(
                            fontSize: statusBarHeight,
                            fontStyle: FontStyle.normal,
                          ));

                          statusBarText.add( genText.constructText());
                          return homepageBody(statusBarText, 0);
                        }

                        else {
                          return Container();
                        }

                      }
                    ),
                  );
                }
              }
            ),
          )
        ),
      ),
    );
  }

  Widget homepageBody(List<Widget> statusBarText, int userID) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
            children: <Widget>[

              Container(
                padding: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purple[400],
                      Colors.purple[300],
                      Colors.purple[200],
                      Colors.purple[100],
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),

                child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height:10),
                    //_addText("", blockSizeVertical*9 , TextAlign.left, FontWeight.normal, FontStyle.normal),
                    _addText(s[0]["name"], blockSizeVertical*3 , TextAlign.center, FontWeight.normal, FontStyle.normal),
                    _buildProfilePicRow(blockSizeVertical*20, context),
                    _addText(s[1]["firstName"],  blockSizeVertical*4.0, TextAlign.center, FontWeight.normal, FontStyle.normal),
                    _addText("", blockSizeVertical*1.0, TextAlign.center, FontWeight.normal, FontStyle.normal),
                    _addColorBarText(statusBarText, Colors.blue ),

//-------------------------ROOMMATE STATUS LIST-------------------------
                    Expanded(


                      child:
                      ListView.builder(

                        shrinkWrap: true,
                        padding: const EdgeInsets.all(2),
                        itemCount: s.length-2, //dynamic
                        itemBuilder: (BuildContext context, int index){
                          return Container(
                            height: 9*blockSizeVertical,
                            color: Colors.purple[500],
                            child: _addStatusRow(context, 1, s[index+2]["firstName"], s[index+2]["status"]),
                          );
                        },
                      ),
                    ),
//-------------------------ROOMMATE STATUS LIST-------------------------

                  ],
                ),
              ),
            ]),
    );
  }

  Widget _buildProfilePicRow( double size, BuildContext context ) { //will likely eventually include userID parameter or the like to load current profile pics
    return Padding(
      padding: EdgeInsets.symmetric(vertical: blockSizeVertical*1.5, horizontal: blockSize*2),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildRoundButton(() => print("Change Profile Pic"), AssetImage("assets/logos/profile.png"), size),


          ]
      ),
    );
  }

  /// Creates a logo for each alternative sign in option a person has
  Widget _buildRoundButton(Function onTap, AssetImage logo, double diameter) {
    return GestureDetector (
      onTap: onTap,
      child: Container(
        height: diameter,
        width: diameter,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0,2),
                blurRadius: 6.0,
              )
            ],
            image: DecorationImage(
              image: logo,
            )
        ),
      ),
    );
  }



  Widget _addText(String label, double fontSize, TextAlign alignment, FontWeight fontWeight, FontStyle fontStyle) {
    return Text(
        label,
        textAlign: alignment,
        style: TextStyle(color: Colors.white.withOpacity(1.0),
          fontSize:  fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decorationColor: Colors.blue,


        ));
  }



  Widget _addTextRow(List<Widget> widgList) {


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: widgList,

    );
  }


  Widget _addColorBarText(List<Widget> widgList, Color color){

    return Card(

      color: color,
      child:


      _addTextRow(widgList),
    );



  }


  //TODO MODIFY CODE so that we pass in the Roomate's name and status
  //We are gunna get a list of roomates with a GET REQUEST FROM THE SERVER
  Widget  _addStatusRow(BuildContext context, int status, String name, String data){
    TextWrapper genText = new TextWrapper(context);
    List <Widget> roommateStatusBarText = new List<Widget>();
//------------------------------------STATUS BAR TEXT------------------------------
    double statusBarHeight = blockSizeVertical*2.5;
    genText.setStyle(TextStyle(
      fontSize: statusBarHeight,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ));
    genText.setData(name + ": ");
    roommateStatusBarText.add(genText.constructText());
    genText.setData(data);
    genText.setStyle(TextStyle(
      fontSize: statusBarHeight,
      fontStyle: FontStyle.normal,
      color: Colors.white,
    ));
    roommateStatusBarText.add(genText.constructText());
//------------------------------------STATUS BAR TEXT------------------------------

    Icon genStatus = statusGenerator(status, statusBarHeight);


    return


      Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            border:Border.all(color: Colors.black, width: .5),
          ),
          child:
          Row(

              mainAxisAlignment: MainAxisAlignment.start,


              children: <Widget>[



                _buildProfilePicRow( blockSizeVertical*5.5, context ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),

                  child: genStatus,
                ),
                roommateStatusBarText[0],
                roommateStatusBarText[1],

              ]
          ));

  }



  Icon statusGenerator(int status, double height){



    switch (status){

      case 1:

        return Icon(
          Icons.lens,
          color: Colors.green,
          size: height,

        );

        break;

      case 2:

        return Icon(
          Icons.lens,
          color: Colors.yellow,
          size: height,
        );

        break;

      case 3:

        return Icon(
          Icons.lens,
          color: Colors.red,
          size: height,
        );

        break;

      default:

        return Icon(
          Icons.error,
          color: Colors.grey,
          size: height,
        );

    }




  }


}



// Future<String> getName() async {

//     FileWriter fw = new FileWriter();
//     //String userToken = await fw.readToken();
//     String userID = await fw.getID1();
//     String url = 'http://ec2-3-21-170-238.us-east-2.compute.amazonaws.com/api/profile/' +  userID + ' /';
//     // make POST request
//     Response response = await get(url);
//     // check the status code for the result
//     int statusCode = response.statusCode;
//     print("Status: " + statusCode.toString());
//     // this API passes back the id of the new item added to the body
//     String body = response.body;
//     return body;

//   }