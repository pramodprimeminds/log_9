// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'form_view.dart';


// class Thankyou extends StatefulWidget {
//   const Thankyou({Key? key}) : super(key: key);

//   @override
//   State<Thankyou> createState() => _ThankyouState();
// }

// class _ThankyouState extends State<Thankyou> {
//   // final storage = FlutterSecureStorage();

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
//         // iconTheme: Theme.of(context).appBarTheme.iconTheme,
//         // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//         automaticallyImplyLeading: false,
//         title:Image.asset('assets/log_9.png',),
//         backgroundColor: Color.fromARGB(255, 236, 236, 236),
        
//         centerTitle: true,
//         elevation: 3,
//         // leading: IconButton(
//         //   onPressed: () {
//         //     // Navigator.pop(context);
//         //   },
//           // icon: Icon(
//           //   Icons.arrow_back,
//           // ),
//         // ),
//         //  actions: [
//         //   IconButton(
//         //       onPressed: () {
//         //         storage.deleteAll();
//         //         Navigator.pop(context, true);
//         //         Navigator.push(
//         //             context,
//         //             MaterialPageRoute(
//         //               builder: (context) => Form_view(),
//         //             ));
//         //       },
//         //       icon: Icon(Icons.power_settings_new)),
//         // ],
//       ),
//       // body: Container(  
//       //     child:Text("Thank you for Submitting your issue,\nour team will get right on it"),    
    
//       // ),
//           body: SingleChildScrollView(
//         child: Column(children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(30.0, 10.0,30.0, 10),
//             child: Row(
              
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
        
//               children: [
//                 Text("Thank you for Submitting your issue,\nour team will get right on it",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 25),)   
//               ],
//             ),
//           ),
//           Padding(padding: EdgeInsets.fromLTRB(30,50,30,30)),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               onPrimary: Colors.black87,
//               minimumSize: Size(250, 40),
//               padding: EdgeInsets.all(10),
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//             ),
//             onPressed:() {  
//               // storage.deleteAll();
//               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
//                 builder:(context)=>Form_view()),(route)=>false);              
//             },       
//             child: Text(
//               'Create a service request ',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20
//               ),
//               ),
//             ),
//         ],
//         ),
//           ),
//     );
//   }
  
// }