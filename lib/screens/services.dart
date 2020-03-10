import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/util/date-time-helper.dart';
import 'package:jackshub/widgets/index.dart';



class ServicesScreen extends StatelessWidget {

  final Future<QuerySnapshot> servicesData =  Firestore.instance.collection('servicesCol').getDocuments();
  // snapshot.documents.forEach(f) => func()

  @override
  Widget build(BuildContext context) {
    //getServices();
    return FutureBuilder<QuerySnapshot>(
      future: servicesData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ReorderableList(snapshotData: snapshot.data);
        } else if (snapshot.hasError) {
          return Container();
        } else {  // Data is currently loading...
          return CircularProgressIndicator();
        }
      }
    );
  }

  // void getServices() {
  //   //List<DocumentSnapshot> services = Firestore.instance.collection('servicesCol').getDocuments().then((QuerySnapshot)
  //   Firestore.instance.collection('servicesCol').getDocuments().then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach((f) => print('${f.data['name']}'));
  //   });
  // }
}



class ReorderableList extends StatefulWidget {
  final QuerySnapshot snapshotData;
  const ReorderableList({
    this.snapshotData
  });
  @override
  _ReorderableList createState() => _ReorderableList();
}



class _ReorderableList extends State<ReorderableList> {
  List<DocumentSnapshot> servicesList = [];
  @override
  Widget build(BuildContext context) {
    for (var serviceDocuments in widget.snapshotData.documents) {
      servicesList.add(
        serviceDocuments
      );
    }
    return ReorderableListView(
      onReorder: _onReorder,
      scrollDirection: Axis.vertical,
      children: List.generate(
        servicesList.length,
        (index) {
          return buildServicesCard(context, servicesList[index], Key('$index'));
        }
      )
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final DocumentSnapshot item = servicesList.removeAt(oldIndex);
      servicesList.insert(newIndex, item);
    });
  }

  Widget buildServicesCard(BuildContext context, DocumentSnapshot doc, Key key) {
    Map<String, dynamic> docData = doc.data;
    return ServicesCard(
      key: key,
      doc: doc,
      name: docData['name'],
      image: docData['image'],
      summary: docData['summary'],
      mainInfo: docData['mainInfo'],
      bigLocation: docData['bigLocation'],
      littleLocation: docData['tinyLocation'],
      email: docData['email'],
      phoneNumber: docData['phoneNumber'],
      serviceHours: getHours(doc),
    );
  }
}
















// class ServicesScreen extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).backgroundColor,
//       child: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 3,
//             child: StreamBuilder<QuerySnapshot>(
//               stream: Firestore.instance.collection('servicesCol').snapshots(),
//               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) return const Text('Loading...');
//                 return ListView.builder(
//                   itemCount: snapshot.data.documents.length,
//                   itemBuilder: (context, index) => buildServicesListItem(context, snapshot.data.documents[index])
//                 );
//               }
//             ),
//           ),
//         ],
//       )
//     );
//   }

//   Widget buildServicesListItem(BuildContext context, DocumentSnapshot doc) {
//     Map<String, dynamic> docdata = doc.data;
//     //ServiceHours serviceHours = getHours(doc);
//     //currentServiceStatusText(context, doc);
//     //print('completed getting service hours: ');
