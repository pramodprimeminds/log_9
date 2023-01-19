import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log_9/thankyou.dart';

import 'login.dart';

class Form_view extends StatefulWidget {
  const Form_view({Key? key}) : super(key: key);

  @override
  State<Form_view> createState() => _Form_viewState();
}

class _Form_viewState extends State<Form_view> {
  TextEditingController name = TextEditingController();
  TextEditingController odoometer = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController registration_number = TextEditingController();
  TextEditingController value = TextEditingController();
  TextEditingController yesno = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? image;
  List<File> multipleImages = [];
  List categoryItemlist = [];
  var photo;
  

  // void getRequest() async {
  //   var session = await storage.read(key: 'cookie');
  //   var url = Uri.parse("https://mobility-staging.odoo.com/my_services_api/partner/helpdesk_teams");
  //   var response = await http.get(url,headers: {
  //     "Cookie": session.toString(),
  //   });
  //    if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body);
  //     setState(() {
  //       categoryItemlist = jsonData;
  //     });
  //   }
  //   print("categoryItemList");
  //   print(categoryItemlist);
   
  //   print("-----------------------------------------");
  //   print(response.headers.toString());

  // }
  String dropdownValue = 'Yes';
  String dropdownValuenew = "Karnataka";
  var lat = 0.0;
  var lon = 0.0;
  var _cad = '';
  final storage = FlutterSecureStorage();
    void postdata() async {
    var session = await storage.read(key: 'cookie');
    var jsonMap = {
      "team_name":dropdownValuenew.toString(),
      "name" : name.text,
      "registration_number" : registration_number.text,
      "odoometer" : odoometer.text,
      "partner_phone":number.text,
      "landmark":landmark.text,
      "latitude":lat.toString(),
      "longitude":lon.toString(),
      "location":_cad.toString(),
      "picture_of_defect":photo.toString()
     
    };
    print(registration_number.text);

    var url = Uri.parse(
        "https://mobility-staging.odoo.com/my_services_api/partner/breakdown_vehicle_details");

    var response = await http.post(url, body: jsonEncode(jsonMap), headers: {
      "Content-type": "application/json",
      "Cookie": session.toString(),
      'Accept': '*/*'
    });
    print("Hi checkin");
    print("Hi" + response.statusCode.toString());
    print("Body" + response.body.toString());
    var det = jsonDecode(response.body);
    var desc = det['description'];
    print(det['description']);
    print("-----------------------------------");
    var ticket_number =det['ticket_seq'];
    print(det['ticket_seq']);
   
    if (response.statusCode == 200) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Thankyou for Submitting Ticket and \nYour Ticket Number is \n"+det['ticket_seq']),
        behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 100.0),
          duration: const Duration(milliseconds: 30000)      
      ));

      
    }
    else if (response.statusCode == 400) {
      var det = jsonDecode(response.body);
      var desc = det['description'];
     
  
      print("==========================================");
   
      print(desc);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(desc),
        behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 100.0),
          duration: const Duration(milliseconds: 2000)      
      ));
  }
    }
  void initState() {
    super.initState();
    setState(() {
      _determinePosition();
    });
  }

 _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      Placemark place = placemarks[0];
      setState(() {
        _cad = "${place.subLocality}";
        //${place.thoroughfare}
        var aa = _cad.toString();
      });
    } catch (e) {
      print(e);
    }
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    
    Geolocator.getCurrentPosition().then((value) {
      setState(() {
        lat = value.latitude;
        print(lat);
        lon = value.longitude;
        print(lon);
      });
      _getAddressFromLatLng();
    });
  }
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  
  openImage() async {
    try {                  
        var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
        //you can use ImageCourse.camera for Camera capture
        if(pickedFile != null){
              imagepath = pickedFile.path;
              print(imagepath); 
              File imagefile = File(imagepath); 
              // List<int> imagebytes = imagefile.readAsBytesSync();
              

              Uint8List imagebytes = await imagefile.readAsBytes(); 
              String base64string = base64.encode(imagebytes); 
              
              print(base64string); 
              print("--------------------------------------------------");
              log(base64string);
        
              // Uint8List decodedbytes = base64.decode(base64string);
              // List<XFile>? picked = await _picker.pickMultiImage();
              // String base64string = base64.encode(imagebytes); 
              // print(base64string); 
              // print("--------------------------------------------------");
              // log(base64string);
              //  Uint8List decodedbytes = base64.decode(base64string);
              setState(() {
                photo = base64string;
              });
        }else{
           print("No image is selected.");
        }
    }catch (e) {
        print("error while picking file.");
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:Image.asset('assets/log_9.png',),
        backgroundColor: Color.fromARGB(255, 236, 236, 236),  
        centerTitle: true,
        elevation: 3,
        
        // leading: IconButton(
        //   onPressed: () {
        //     // Navigator.pop(context);
        //   },
        //   icon: Icon(
        //     Icons.arrow_back,
        //   ),
        // ),
        //  actions: [
        //   IconButton(
        //       onPressed: () {
        //         // storage.deleteAll();
        //         Navigator.pop(context, true);
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => login(),
        //             ));
        //       },
        //       icon: Icon(Icons.power_settings_new)),
        // ],
      ),
      
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0,30.0, 10.0),
            child: Row(
              children: [
                Text('  Region    :       ',
                style: TextStyle(fontSize: 20),),
                DropdownButton(  
                 value: dropdownValuenew,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValuenew = newValue!;
                      print(dropdownValuenew);
                    });
                  },
                  items: <String>[
                    'Karnataka',//KA51AH1061
                    'Delhi',
                    // 'Tamil Nadu',
                    // 'Uttar Pradesh',
                    // 'Telangana',
                    // 'Kerala',
                    // 'Maharastra',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                        child: Text(value,
                        style: TextStyle(fontSize: 20),),
                      ),
                    );
                    
                  }).toList(),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(30.0, 10.0,30.0, 10),
          //   child: Row(
          //     children: [
          //       Text('  Region    :       ',
          //       style: TextStyle(fontSize: 20),), 
          //       DropdownButton(   
          //           value: dropdownValuenew,
          //           items: categoryItemlist.map((item) {
          //             return new DropdownMenuItem(
          //               child: new Text(
          //                 item,   
          //                 style: TextStyle(
          //                 fontSize: 20.0,
          //                 ),
          //               ),  
          //                 value: item.toString()      
          //              );  
          //           }).toList(),  
                     
          //             onChanged: (String? newValue) {
          //           setState(() {
          //             dropdownValuenew = newValue!;
          //             print(dropdownValuenew);
          //           });
          //         }, 
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0,30.0,10.0),
            child: TextField(
              controller: registration_number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Registration Number',
                  isDense: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0,30.0,10.0),
            child: TextField(
              controller: odoometer,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Odometer reading',
                  isDense: true),
                  keyboardType: TextInputType.number,
                  inputFormatters:  [
                  FilteringTextInputFormatter.digitsOnly,
                  ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0,30.0,10.0),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Issue being faced',
                  isDense: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0,30.0, 10.0),
            child: TextField(
              controller: number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contact Number',
                 
                  isDense: true),
                  keyboardType: TextInputType.number,
                  inputFormatters:  [
                  FilteringTextInputFormatter.digitsOnly,
                  ],     
            ),  
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0,30.0,10.0), 
            child: Column(
               children: [   
              //     imagepath != ""?Image.file(File(imagepath)):
                 Container( 
                      child: Text("Photo of issue being faced",
                      style: TextStyle(fontSize: 20),),
                    ),
              //       ElevatedButton(
              //         onPressed: (){
              //             openImage();
              //         }, 
              //         child: Text("Browse")
                      
              //       ),
              //  ]
          // children: [
            // ElevatedButton(
            //     onPressed: () async {
            //       // XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
            //     XFile? video=  await _picker.pickVideo(source: ImageSource.gallery);
            //       setState(() {
            //         image = File(video!.path);
            //       });
            //       print("Video ${image!.path}");
            //     },
            //     child: Text("Image Picker")),
            
            // ElevatedButton(
            //     onPressed: () 
            //      async{
            //       List<XFile>? picked = await _picker.pickMultiImage();
            //       setState(() {
            //         multipleImages = picked.map((e) => File(e.path)).toList();
            //          openImage();
            //       });
            //     },
            //     child: const Text("Browse")),

            ElevatedButton(
                      onPressed: (){
                          openImage();
                      }, 
                      child: Text("Browse")  
                    ),
          ],
        ),
            ), 
          
           Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0,30.0, 10.0),
            child: Row(
              children: [
                Text('  Is vehicle in \n Breakdown state    :     ',
                style: TextStyle(fontSize: 20),),
                DropdownButton(  
                 value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Yes',
                    'No',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                        child: Text(value,
                        style: TextStyle(fontSize: 20),),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0,30.0, 10),
            child: TextField(
              controller: landmark,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nearest Landmark',
                  isDense: true),
            ),
          ),

          Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),     
                        Text(_cad,
                        textAlign: TextAlign.center,style: TextStyle(fontSize: 20),)
                        // SizedBox(
                        //   width: 300,
                        //   child: Text(
                        //     // _cad,
                        //     style: TextStyle(overflow: TextOverflow.visible,fontSize: 30),
                        //   ),
                        // ),
                      ],
                    ),
                  ]),
            ),
          Padding(padding: EdgeInsets.all(10)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black87,
              minimumSize: Size(250, 40),
              padding: EdgeInsets.all(10),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onPressed:() {               
              postdata();
            },       
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
              ),

            ),
        ],
        ),
      ),
      
    );

    
  }
}
