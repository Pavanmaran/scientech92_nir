Widget sensorBox(){
return
Scaffold(
backgroundColor: Colors.white,
drawer: Drawer(
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the drawer if there isn't enough vertical
// space to fit everything.
child: ListView(
// Important: Remove any padding from the ListView.
padding: EdgeInsets.zero,
children: [
const DrawerHeader(
decoration: BoxDecoration(
color: Color(0xFFdbb331),
),
child: Image(image: AssetImage('assets/logo.png'),height: 100,width: 100,),
),
ListTile(
title: const Text("Setting"),
onTap: (){
showDialog (
context: context,
builder: (BuildContext context){
return AlertDialog(
content: ClipRect(
child: Stack(
clipBehavior: Clip.hardEdge,
children: [
Column(
children: [
GestureDetector(
// onLongPress: deletedata(ref_delete),
child: Container(
decoration: BoxDecoration(
color: Colors.black12,
borderRadius: BorderRadius.circular(10),
border: Border.all(
color: Colors.white,
width: 1,
)),
padding: EdgeInsets.all(5),
),
),
SizedBox(height: 20),
Text("Wifi ID"),
TextFormField(
//initialValue: contact['projectName'].toString(),
controller: wifiid,
decoration: InputDecoration(
hintText: "Enter Wifi ID: "),),
SizedBox(height: 20),
Text("Password"),
TextFormField(
//initialValue: contact['projectName'].toString(),
controller: wifipass,
decoration: InputDecoration(
hintText: "Enter Password: "),),
SizedBox(height: 20),
TextButton(
onPressed:(){
if(connected==true){
sendcmd('SSID:'+wifiid.text+';'+'PWD:'+wifipass.text+';;');
Fluttertoast.showToast(
msg: "Wifi ID Password Sent",
toastLength: Toast.LENGTH_SHORT,
gravity: ToastGravity.CENTER,
timeInSecForIosWeb: 1
);
}
},
child: Text("Save")
),
SizedBox(height: 10),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  );
                },
              ),
              ListTile(
                title: const Text('Other Products '),
                onTap: () {
                  _launchURL();
                },
              ),
              ListTile(
                title:aboutUs(),
                onTap: () {
                  setState(() {
                    ontapflag =true;
                  });
                },
              ),
              ListTile(
                title: contactTap(),
                onTap: () {
                  setState(() {
                    ontapcontactflag =true;
                  });
                },
              ),
              const SizedBox(height: 23,),
              ListTile(
                  title: const Text("Version 1.0.0"),
                  onTap: () {
                    setState(() {
                      ontapcontactflag =true;
                    });}),
              const SizedBox(
                height: 23,
              ),
            ],
          ),
        ),
        appBar: AppBar(
            title:Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Image(image: AssetImage('assets/logo.png'),height: 100,width: 100,),
                    const SizedBox(width: 10,),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 9, 0,0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(modelName,style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          //fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                      onTap: (){
                        ledfunc("poweron");
                      },
                      child:  ConnectionStatus
                  )
              ),
            ],
            //backgroundColor:Color(0xFF424242)
            backgroundColor:const Color(0xFFdbb331)
        ),
        body:SingleChildScrollView(
          child: Container
            (
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 10),
              child:Column(
                children:[
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 1.0,
                      childAspectRatio : 1.0,
                    ),
                    itemCount: split.length,
                    itemBuilder: (context, index) {
                      print(split.length);
                      if(split.length==7){
                        return SingleChildScrollView(
                          child: Container(
                            height: 60,
                              width: 120,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(sensors[index],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 23
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Center(
                                      child: Container(
                                        child: SingleChildScrollView(
                                          child: Text(split[index],
                                            style: const TextStyle(
                                                color: Colors.black38,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 14
                                            ),
                                          ),
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                          ),
                        );
                      }
                      return Scaffold(
                        backgroundColor: Color(0xFFdbb331),
                        body: Center(
                          child: Image(image:
                          AssetImage('assets/logo.png'),height: MediaQuery.of(context).size.height,
                          ),
                        ),
                      );
                    },
                  ),
                  // bulbSwitches()
                ],
              )
          ),
        ),
      );

}











import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// import 'package:smartscientech/ssb/ssbHome.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'SE/se.dart';

/*
Scintech technology Private Ltd.
Date : 01.01.2022
Developer : Pawan Meena
*/
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

@override
Widget build(BuildContext context) {
return  MaterialApp(
debugShowCheckedModeBanner: false,
theme: ThemeData(
// backgroundColor: Colors.black54,
),
home: splash(),
);
}
}
class splash extends StatefulWidget {
const splash({Key? key}) : super(key: key);

@override
_splashState createState() => _splashState();
}

class _splashState extends State<splash> {
@override
void initState() {
super.initState();
Timer(Duration(seconds: 3),
()=>Navigator.pushReplacement(context,
MaterialPageRoute(builder:
(context) =>
nir("192.168.0.1:80")
)
)
);
}
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Color(0xFFdbb331),
body: Center(
child: Image(image:
AssetImage('assets/logo.png'),height: MediaQuery.of(context).size.height,
),
),
);
}
}

//apply this class on home: attribute at MaterialApp()
class mainscreen extends StatefulWidget{
@override
State<StatefulWidget> createState() {
return _mainscreen();
}
}
class _mainscreen extends State<mainscreen>{
late bool ledstatus=true; //boolean value to track LED status, if its ON or OFF
late IOWebSocketChannel channel;
late bool connected=false; //boolean value to track if WebSocket is connected
late String sesnor_data ;
late String Temperature="00",Humidity="00",Gas="00",Smoke="00",PIR="0",productModel="NA";
late Icon ConnectionStatus =const Icon(Icons.language_sharp,color: Colors.white,) ;
List svalues=['00'];
late  Map<int, String> nvalues = {};
late Icon typeIcon = const Icon(Icons.downloading) ;
late bool ontapflag = false;
late bool ontapcontactflag = false;
static String _url = 'https://www.scientechworld.com/';
String Modelcode = '';
String modelName = '';
List split =[];
Color bulbColor = Colors.blueGrey;
bool ledbool = false;
TextEditingController ip = TextEditingController();
@override
void initState() {
sendcmd("poweron");
ledstatus = false;
sendcmd("senddata");
// Future.delayed(Duration.zero,() async {
//   channelconnect();
// });
super.initState();

}

Widget aboutUs(){
if(ontapflag ==true){
return Container(
child: Container(
child: const Text('''About Us

'''
+
"For over 35 Years, Scientech has been a "
"leader in the electronics sector providing reliable "
"and quality "
"solutions. We have an extensive line of solutions for"
" Industry, Education, and Environmental sectors.")),
);
}
else{
return const Text("About Us");
}

}
Widget contactTap(){
if(ontapcontactflag ==true){
return Container(
child: Container(
child: const Text('''Contact    
'''
+
'''Scientech Technologies Pvt. Ltd\n'''
'''94, Electronic Complex, Pardesipura,\n'''
'''Indore - 452 010, India\n'''
'''info@scientech.bz\n'''
'''For India:\n'''
'''+91-97555 91500\n'''
'''+91-731 4211100\n'''
'''For International:\n'''
''' +91-73899 10103\n''')),
);
}
else{
return const Text("Contact");
}

}
_launchURL() async{
const url = 'https://www.scientechworld.com/';
if (await canLaunch(url)) {
await launch(url);
} else {
throw 'Could not launch $url';
}
}
Widget notConnected(){
// sendcmd("senddata");
return Scaffold(
drawer: Drawer(
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the drawer if there isn't enough vertical
// space to fit everything.
child: ListView(
// Important: Remove any padding from the ListView.
padding: EdgeInsets.zero,
children: [
const DrawerHeader(
decoration: BoxDecoration(
color: Color(0xFFdbb331),
),
child: Image(image: AssetImage('assets/logo.png'),height: 100,width: 100,),
),
ListTile(
title: const Text('Other Products '),
onTap: () {
_launchURL();
},
),
ListTile(
title:aboutUs(),
onTap: () {
setState(() {
ontapflag =true;
});
},
),
ListTile(
title: contactTap(),
onTap: () {
setState(() {
ontapcontactflag =true;
});
},
),
const SizedBox(height: 23,),
ListTile(
title: const Text("Version 1.0.0"),
onTap: () {
setState(() {
ontapcontactflag =true;
});
},
),

          ],
        ),
      ),
      appBar: AppBar(
          title:
          Row(
            children: [
              const Image(image: AssetImage('assets/logo.png'),height: 100,width: 100,),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 9, 0,0),
                child: Text(modelName,style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  //fontWeight: FontWeight.bold
                ),),
              ),
            ],
          ),
          actions: [
            Container(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                    onTap: (){

                    },
                    child:  ConnectionStatus
                )
            ),
          ],
          //backgroundColor:Color(0xFF424242)
          backgroundColor:const Color(0xFFdbb331)
      ),
      body: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.wifi_off_sharp),
              iconSize: 44,
              onPressed: (){

              },
            ),
            const SizedBox(height: 10),
            Container(
              child: const Center(
                child: Text(
                  "Connect with WiFi",style: TextStyle(
                  color: Colors.black38,
                  fontSize: 23,

                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

}
channelconnect(String ipAdd){ //function to connect
try{
channel = IOWebSocketChannel.connect("ws://"+ipAdd.toString()); //channel IP : Port
print("ip : "+ipAdd);
channel.stream.listen((message) {
print("msg: "+message);
setState(() {
if (message == "SBconnected") {
Modelcode = message.toString().substring(0, 2);
String NewMessage = message.toString().substring(2, 11);
print("Model:" + Modelcode);
print("Model:" + NewMessage);
}
else if (message == "SPconnected") {
Modelcode = message.toString().substring(0, 2);
String NewMessage = message.toString().substring(2, 11);
print("Model:" + Modelcode);
print("Model:" + NewMessage);
}
else if (message == "SIconnected") {
Modelcode = message.toString().substring(0, 2);
String NewMessage = message.toString().substring(2, 11);
print("Model:" + Modelcode);
print("Model:" + NewMessage);
}
else if (message == "SEconnected") {
Modelcode = message.toString().substring(0, 2);
String NewMessage = message.toString().substring(2, 11);
print("Model:" + Modelcode);
print("Model:" + NewMessage);
}
});
},

        onDone: () {
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },);
    }catch (_){
      print("error on connecting to websocket $ipAdd.");
    }
}
Future<void> sendcmd(String cmd) async {
if(connected == true){
channel.sink.add(cmd);
}else{
channelconnect(ip.text);
print("Afsos! Websocket is not connected.");
setState(() {
ConnectionStatus = const Icon(Icons.wifi_off_sharp, color: Colors.black38,);
});
}
}
@override
Widget build(BuildContext context) {

    print(Modelcode);
    print(ip.text);
    if(ip.text.length<5){
      return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFdbb331),
                ),
                child: Image(image: AssetImage('assets/logo.png'),height: 100,width: 100,),
              ),
              ListTile(
                title: const Text('Other Products '),
                onTap: () {
                  _launchURL();
                },
              ),
              ListTile(
                title:aboutUs(),
                onTap: () {
                  setState(() {
                    ontapflag =true;
                  });
                },
              ),
              ListTile(
                title: contactTap(),
                onTap: () {
                  setState(() {
                    ontapcontactflag =true;
                  });
                },
              ),
              const SizedBox(height: 23,),
              ListTile(
                title: const Text("Version 1.0.0"),
                onTap: () {
                  setState(() {
                    ontapcontactflag =true;
                  });
                },
              ),

            ],
          ),
        ),
        appBar: AppBar(
            title:
            Row(
              children: [
                const Image(image: AssetImage('assets/logo.png'),height: 100,width: 100,),

              ],
            ),

            //backgroundColor:Color(0xFF424242)
            backgroundColor:const Color(0xFFdbb331)
        ),
        body: Container(
         child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: ip,
                  ),

                ],
              ),
            ),
          ),

        ),
      );

    }
    else if(Modelcode=='SE'){
      return nir(ip.text);
    }

    else{
      return notConnected();
    }
}


}