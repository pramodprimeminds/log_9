import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'pallete.dart';


class Tickets extends StatefulWidget {
  const Tickets({Key? key}) : super(key: key);

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  var storage = FlutterSecureStorage();
  var aaa;
  var bbb;
  

  

  Future<Map<String, dynamic>> fetchAlbum() async {
  //     @override
  // void initState() {
  //   super.initState();
  //   getRequest();
  // }

    // void getRequest() async{
    var session = await storage.read(key: 'cookie');
    var url = Uri.parse(
        "https://mobility-staging.odoo.com/my_services_api/partner/get_ticket_details");
    var response = await http.get(url, headers: {
      "Cookie": session.toString(),
    });
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var det = jsonDecode(response.body)['open_tickets'];
      print("+++++++++++++++++++++++");
      print(det);
      aaa = det;

      String pet_val = "";
      for (var pet in det) {
        pet_val = pet_val +"\n \n" + pet;
              bbb = pet_val;
      }
      
    }
    return Map();
  }


  @override
  Widget build(BuildContext context) { 

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
     
        title: Text(
          'My Tickets',
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
                padding: const EdgeInsets.only(left: 30, top: 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,

                        child: Text.rich(TextSpan(
                            // text: " My Tickets : \n",
                            // style: TextStyle(fontSize: 25),
                            children: <InlineSpan>[
                              TextSpan(
                                text:
                              bbb.toString(),
                                style: TextStyle(
                                    fontSize: 25, ),
                              )
                            ],),),
                        //                       child:ListView.builder(
                        //                          scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        //       itemCount:bbb.toString().length,
                        //       // itemExtent: 60.0,
                        //       itemBuilder: (context, index) {
                        //         return ListTile(
                        //           title: Text('${bbb}'),
                        //         ); // ListTile
                        //       },
                        //     ),
                       
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

