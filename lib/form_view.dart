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
import 'login.dart';
import 'pallete.dart';
import 'profile.dart';
import 'tickets.dart';

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
  void clearText() {
    name.clear();
    odoometer.clear();
    number.clear();
    landmark.clear();
    registration_number.clear();
    value.clear();
    yesno.clear();
  }

//   void getRequest() async {
//     var session = await storage.read(key: 'cookie');
//     var url = Uri.parse("https://mobility-staging.odoo.com/my_services_api/partner/helpdesk_teams");
//     var response = await http.get(url,headers: {
//       "Cookie": session.toString(),
//     });
//      if (response.statusCode == 200) {
//       var jsonData = json.decode(response.body);
//       setState(() {
//         categoryItemlist = jsonData;
//       });
//     }
//     print("categoryItemList");
//     print(categoryItemlist);

//     print("-----------------------------------------");
//     print(response.headers.toString());

//   }
// //  api_help
//   void initState(){
//     super.initState();
//     getRequest();
//   }
  String dropdownValue = 'Yes';
  String dropdownValuenew = "Karnataka";
  var lat = 0.0;
  var lon = 0.0;
  var _cad = '';
  final storage = FlutterSecureStorage();
  void postdata() async {
    var session = await storage.read(key: 'cookie');
    var jsonMap = {
      "team_name": dropdownValuenew.toString(),
      "name": name.text,
      "registration_number": registration_number.text,
      "breakdown": dropdownValue.toString(),
      "odoometer": odoometer.text,
      "partner_phone": number.text,
      "landmark": landmark.text,
      "latitude": lat.toString(),
      "longitude": lon.toString(),
      "location": _currentAddress.toString(),
      "picture_of_defect": photo.toList(),
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
    var ticket_number = det['ticket_seq'];
    print(det['ticket_seq']);

    if (response.statusCode == 200) {
      Widget okButton = TextButton(
        child: Text(
          "OK",
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text(
          "Ticket Number",
          style: TextStyle(color: Palette.kToDark),
        ),
        content: Text(
            "Thankyou for Submitting Ticket and \nYour Ticket Number is " +
                det['ticket_seq'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        actions: [
          okButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      clearText();
    } else if (response.statusCode == 400) {
      var det = jsonDecode(response.body);
      var desc = det['description'];
      // print(desc.text);
      RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
      String parsedstring = desc.replaceAll(exp, '');
      print(parsedstring);

      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text(
          "Error",
          style: TextStyle(color: Palette.kToDark),
        ),
        content: Text(parsedstring),
        actions: [
          okButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
        lat = _currentPosition!.latitude;
        print(lat);
        lon = _currentPosition!.longitude;
        print(lon); // ${place.subAdministrativeArea}, ${place.postalCode}
      });
    }).catchError((e) {
      debugPrint(e);
    });
    print(_currentPosition!.latitude);
    print(_currentPosition!.longitude);
    print(_currentAddress);
  }

  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";

//   openImage() async {
//     try {
//       List<String> base64Images = [];

//       var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
//       //you can use ImageCourse.camera for Camera capture
//       if (pickedFile != null) {
//         imagepath = pickedFile.path;
//         print(imagepath);
//         File imagefile = File(imagepath);

//         // List<int> imagebytes = imagefile.readAsBytesSync();

//         Uint8List imagebytes = await imagefile.readAsBytes();
//         String base64string = base64.encode(imagebytes);
//         List<String> convertMultipleImagesToBase64(List<File> images) {
//   List<String> base64Images = [];
//   for (var i = 0; i < images.length; i++) {
//     List<int> imageBytes = images[i].readAsBytesSync();
//     String base64Image = base64Encode(imageBytes);
//     base64Images.add(base64Image);
//   }
//   print(base64Images);
//   return base64Images;

// }

//         print(base64string);
//         // print("--------------------------------------------------");
//         // log(base64string);

//         setState(() {
//           photo = base64string;
//         });
//       } else {
//         print("No image is selected.");
//       }
//     } catch (e) {
//       print("error while picking file.");
//     }
//   }
  Future<List<String>> pickAndConvertImages() async {
    final ImagePicker _picker = ImagePicker();

    // Pick multiple images from the gallery
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles == null && pickedFiles!.length <3 )  {
      return [];
    }
    // Convert the images to base64 strings
    List<String> base64Images = [];
    for (var pickedFile in pickedFiles) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      base64Images.add(base64Image);
      setState(() {
        photo = base64Images;
      });
      print(photo);
    }

    return base64Images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/log_9.png',
        ),
        backgroundColor: Color.fromARGB(255, 236, 236, 236),
        centerTitle: true,
        elevation: 3,
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu', style: TextStyle(fontSize: 20)),
              decoration: BoxDecoration(
                color: Palette.kToDark,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'My Profile',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'My Tickets',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Tickets(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: Row(
                  children: [
                    Text(
                      '  Region    :       ',
                      style: TextStyle(fontSize: 20),
                    ),
                    DropdownButton(
                      value: dropdownValuenew,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValuenew = newValue!;
                          print(dropdownValuenew);
                        });
                      },
                      items: <String>[
                        'Karnataka', //KA51AH1061
                        'Delhi',
                        // 'Tamil Nadu',
                        // 'Uttar Pradesh',
                        'Telangana',
                        // 'Kerala',
                        // 'Maharastra',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 20),
                            ),
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
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
                child: TextField(
                  controller: registration_number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Registration Number',
                      isDense: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
                child: TextField(
                  controller: odoometer,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Odometer reading',
                      isDense: true),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Issue being faced',
                      isDense: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
                child: TextField(
                  controller: number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contact Number',
                      isDense: true),
                  keyboardType: TextInputType.phone,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Photo of issue being faced",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          // openImage();
                          pickAndConvertImages();
                        },
                        child: Text("Photo")),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
                child: Row(
                  children: [
                    Text(
                      '  Is vehicle in \n Breakdown state    :     ',
                      style: TextStyle(fontSize: 20),
                    ),
                    DropdownButton(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          print(dropdownValue);
                        });
                      },
                      items: <String>[
                        'Yes',
                        'No',
                      ].map<DropdownMenuItem<String>>((String yesno) {
                        return DropdownMenuItem<String>(
                          value: yesno,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                            child: Text(
                              yesno,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10),
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_currentAddress ?? ""}'),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _getCurrentPosition,
                        child: const Text("Get Current Location"),
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
                onPressed: () {
                  postdata();
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
