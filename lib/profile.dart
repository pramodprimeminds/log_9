import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'pallete.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var storage = FlutterSecureStorage();
  var aaa;
  List<String> head = <String>['id', 'name', 'pan_no'];
  List<String> detail = <String>[];
  Future<Map<String, dynamic>> fetchAlbum() async {
    var session = await storage.read(key: 'cookie');
    var url = Uri.parse(
        "https://mobility-staging.odoo.com/my_services_api/partner/get_user_details");
    var response = await http.get(url, headers: {
      "Cookie": session.toString(),
    });
    print(response.body);
    print(session);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print("------------------------------------------------");
      var det = jsonDecode(response.body)['user_list'][0];
      print(det);
      // print(jsonData);
      // setState(() {
      //   aaa = det;
      // });
      return det;
    } //pradeepb@micelio.com
    return Map();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getRequest();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          'User Details',
        ),
        centerTitle: true,
        elevation: 50,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<Map>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(left: 30, top: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,

                        child: Text.rich(TextSpan(
                            text: "Name : ",
                            style: TextStyle(fontSize: 20),
                            children: <InlineSpan>[
                              TextSpan(
                                text: snapshot.data!['name'].toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ])),

                        //     "Name :  ${snapshot.data!['name'].toString()}",
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold
                        //     ),
                        //   ),
                        // ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "User Id : ${snapshot.data!['id'].toString()}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Phone : ${snapshot.data!['phone'].toString()}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Email : ${snapshot.data!['email'].toString()}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Mobile : ${snapshot.data!['mobile'].toString()}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Gst Number : ${snapshot.data!['vat'].toString()} ",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Pan Number : ${snapshot.data!['pan_no'].toString()}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
          future: fetchAlbum(),
        ),
      ),
    );
  }
}
