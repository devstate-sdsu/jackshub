import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/util/date-time-helper.dart';
import 'package:jackshub/widgets/index.dart';



class FoodScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('foodCol').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => buildServicesListItem(context, snapshot.data.documents[index])
                );
              }
            ),
          ),
        ],
      )
    );
  }

  Widget buildServicesListItem(BuildContext context, DocumentSnapshot doc) {
    Map<String, dynamic> docdata = doc.data;
    //ServiceHours serviceHours = getHours(doc);
    //currentServiceStatusText(context, doc);
    //print('completed getting service hours: ');
    //print(serviceHours);
    return ServicesCard(
        doc: doc,
        name: docdata['name'],
        image: docdata['image'],
        summary: docdata['summary'],
        mainInfo: docdata['mainInfo'],
        bigLocation: docdata['bigLocation'],
        littleLocation: docdata['tinyLocation'],
        email: docdata['email'],
        phoneNumber: docdata['phoneNumber'],
        serviceHours: getHours(doc),
    );
  }

}

