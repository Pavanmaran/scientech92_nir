import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;


displaySnackBar(BuildContext context, String msg) {
  final snackBar =SnackBar(
      content: Text(msg));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class nir extends StatefulWidget{
  String ip ;
  nir(String this.ip);

  @override
  State<StatefulWidget> createState() {
    return _nir(this.ip);
  }
}

class _nir extends State<nir>{
  String ip;
  _nir(this.ip);
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
  String Modelcode = '';
  String modelName = '';
  List split =[];
  Color bulbColor = Colors.blueGrey;
  bool ledbool = false;
  TextEditingController wifiid = TextEditingController();
  TextEditingController wifipass = TextEditingController();
  String ipadd = "192.168.0.1:80" ;
  TextEditingController enteredIP = TextEditingController();
  List sensors = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G'
  ];

  List typeicons = [
    const Icon(Icons.local_fire_department_outlined,color: Colors.amber),

    const Icon(Icons.cloud,color: Colors.lightBlueAccent),
    const Icon(Icons.cloud_outlined,color: Colors.amber),
    const Icon(Icons.cloud_outlined,color: Colors.amber),
    const Icon(Icons.compress,color: Colors.amber,),
    const Icon(Icons.blur_on,color: Colors.amber),
    const Icon(Icons.wb_sunny_outlined,color: Colors.amber,),

  ];

  // List datetest = [
  //   '10:22  |  31/12/2021',
  //   '10:21  |  31/12/2021',
  //   '10:23  |  31/12/2021',
  //   '10:22  |  31/12/2021',
  //   '10:21  |  31/12/2021',
  //   '10:21  |  31/12/2021',
  //   '10:21  |  31/12/2021',
  //   '10:21  |  31/12/2021'
  // ];

  List units = [
    "\u2103",
    "%",
    "PPM",
    "PPM",
    "mm",
    "%",
    "%",
  ];

  String _status = '';
  //String url = "http://192.168.43.5";
  var response ;
  bool StartFlag=false;
  Color StartButtonColor = Colors.white24;

  @override
  void initState() {

    sendcmd("poweron");
    ledstatus = false; //initially leadstatus is off so its FALSE
    //connected = false; //initially connection status is "NO" so its FALSE
    Future.delayed(Duration.zero,() async {
      channelconnect(ipadd); //connect to WebSocket wth NodeMCU
    });

    super.initState();

  }

  channelconnect(String connectIP){ //function to connect
    try{
      channel = IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      channel.stream.listen((message) {
        //print(message);
        setState(() {
          if (message == "92connected") {
            Modelcode = message.toString().substring(0, 2);
            String NewMessage = message.toString().substring(2, 11);
            print("Model:" + Modelcode);
            print("Model:" + NewMessage);
            if (NewMessage == "connected") {
              setState(() {
                ConnectionStatus = const Icon(Icons.wifi_off_sharp, color: Colors.white);
                connected = true; //message is "connected" from NodeMCU
              });
            }
            if(Modelcode=='SB'){
              setState(() {
                modelName = "Smart Building";
              });
            }
            else if(Modelcode=='SE'){
              setState(() {
                modelName = "Spectroscopy Meter";
              });
            }
          }
          else {
            setState(() {
              ConnectionStatus = const Icon(Icons.wifi_outlined, color: Colors.white);
              sesnor_data = message;
              splitData(sesnor_data);

            });
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
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if(connected == true){
      channel.sink.add(cmd);
    }else{
      channelconnect("192.168.0.1:81");
      print("Websocket is not connected.");
      setState(() {
        ConnectionStatus = const Icon(Icons.wifi_off_sharp, color: Colors.black38,);
      });
    }
  }
  late BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    return HomeWidget();
  }
  Widget HomeWidget(){
    return Scaffold(
      drawer: Drawer(
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
                if(connected==true){
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
                }
                else{
                  displaySnackBar(context, 'WiFi Not Connected, Please Connect.');
                }

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
                });
              },
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
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            height: 200,
            child: Builder(builder: (BuildContext context) {
              scaffoldContext = context;
              return ListView(
                children: <Widget>[
                  TextFormField(
                    controller: enteredIP,
                    decoration: InputDecoration(
                      hintText: "Enter IP: "
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(25.0),
                    child: RaisedButton(
                      onPressed: (){
                        StartFlag = StartFlag==true?false:true;
                        StartFlag==true?StartButtonColor=Colors.indigo:StartButtonColor=Colors.white24;
                        getInitLedState(enteredIP.text);
                        getdata(enteredIP.text);
                        setState(() {});
                      },
                      child: Text('Connect'),
                      color: StartButtonColor,
                    ),
                  ),
                  Text(
                    'Data: $_status',
                    textAlign: TextAlign.center,
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
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



  getInitLedState(String host) async {
    print("Initializing");
    try {
      response = await http.get(Uri.parse(host), headers: {"Accept": "plain/text"});
      setState(() {
        _status = 'Connected';
      });
      print(response);
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      if (this.mounted) {
        setState(() {
          _status = 'Not Connected';
        });
      }
    }
    print("Initialed");
  }
  getdata(String host_) async {
    while(StartFlag==true){
      try {
        response = await http.get(Uri.parse("http://"+host_+ '/GPIO4OFF'), headers: {"Accept": "plain/text"});
        setState(() {
          _status = response.body;
          //print(response.body);
        });
        Timer(Duration(seconds: 1), () {});
      } catch (e) {
        // If NodeMCU is not connected, it will throw error
        print(e);
        displaySnackBar(context, 'Module Not Connected');
      }
    }
  }

  splitData(String data){
    var removeline = data.replaceAll("\n", "");
    //removeline = data.replaceAll("\t", "");
    split = removeline.split(',');
    nvalues = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
    print(nvalues);
  }

  Widget bulbSwitches(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: bulbColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueGrey)
              ),
              child: IconButton(
                onPressed: (){
                  if(ledbool ==true){
                    ledfunc('poweroff');
                  }
                  else{
                    ledfunc('poweron');
                  }
                },
                icon: const Icon(Icons.lightbulb),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10,),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueGrey)
              ),
              child: IconButton(
                onPressed: (){
                  bulbColor = const Color(0xFFdbb331);
                },
                icon: const Icon(Icons.lightbulb),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10,),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black38)
              ),
              child: IconButton(
                onPressed: (){
                  if(ledbool ==false){
                    ledfunc('poweron');
                  }
                },
                icon:  Icon(Icons.lightbulb,color: Colors.black38,
                ),
              ),
            )],
        ),
        const SizedBox(width: 10,),
      ],
    );
  }

  void ledfunc(String msg) {
    if(msg == 'poweron'){ //if ledstatus is true, then turn off the led
      //if led is on, turn off
      sendcmd(msg);
      setState(() {
        ledbool = true;
        bulbColor = Colors.blueGrey;
      });
    }
    else if(msg == 'poweroff'){ //if ledstatus is false, then turn on the led
      setState(() {
        ledbool = false;
        bulbColor = const Color(0xFFdbb331);
      });
      sendcmd(msg);
    }
  }
}