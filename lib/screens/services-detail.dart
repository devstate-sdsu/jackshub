import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:jackshub/widgets/index.dart';
import 'package:jackshub/config/theme.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';



class DetailedServicesScreen extends StatefulWidget {
  final DocumentSnapshot doc;
  final String name;
  final String image;
  final String mainInfo;
  final String bigLocation;
  final String littleLocation;
  final String email;
  final String phoneNumber;

  const DetailedServicesScreen({
    Key key,
    this.doc,
    this.name,
    this.image,
    this.mainInfo,
    this.bigLocation,
    this.littleLocation,
    this.email,
    this.phoneNumber
  });

  @override
  _DetailedServicesScreen createState() => _DetailedServicesScreen();
}



class _DetailedServicesScreen extends State<DetailedServicesScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  var offset = -AppTheme.detailedScreenAnimateOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: AppTheme.detailedScreenAnimateDuration
      )
    );
    _animation = Tween(
      begin: -AppTheme.detailedScreenAnimateOffset,
      end: 0.0
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.detailedScreenCurve
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    _controller.forward();

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return Stack(
          children: <Widget>[
            Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              )
            ),
            Hero(
              tag: 'servicesCardImg'+widget.doc.documentID,
              child: CachedNetworkImage(
                imageUrl: widget.image,
                imageBuilder: (context, imageProvider) => Container(
                  height: screenWidth,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    )
                  )
                ),
                placeholder: (context, url) => Image(
                  image: AssetImage('lib/assets/images/loadingPlaceHolder.png')
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 40.0
                  )
                )
              )
            ),
            Transform.translate(
              offset: Offset(0.0, -_animation.value),
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width*0.75,
                      color: Colors.transparent
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: AppTheme.cardSideMargin,
                      right: AppTheme.cardSideMargin,
                      bottom: AppTheme.cardVerticalMargin
                    ),
                    padding: EdgeInsets.all(AppTheme.detailCardInnerPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(AppTheme.cardRadius)),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowColor,
                          blurRadius: AppTheme.shadowBlurRadius,
                          offset: AppTheme.shadowOffset
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AutoSizeText(
                          widget.name,
                          textAlign: TextAlign.left,
                          maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                          minFontSize: Theme.of(context).textTheme.headline.fontSize,
                          style: Theme.of(context).textTheme.headline
                        ),
                        SizedBox(
                          height: 15
                        ),
                        Container(
                          height: 1.5,
                          color: Theme.of(context).accentColor
                        ),
                        SizedBox(
                          height: 15
                        ),
                        Container(  // OpenHours / Schedule Widget
                          height: 150,
                          color: Colors.grey
                        ),
                        SizedBox(
                          height: 15
                        ),
                        Container(
                          height: 1.5,
                          color: Theme.of(context).accentColor
                        ),
                        SizedBox(
                          height: 15
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.mail_outline,
                              size: 14,
                              color: Theme.of(context).accentColor
                            ),
                            SizedBox(
                              width: 6.0
                            ),
                            AutoSizeText(
                              widget.email,
                              maxLines: 1,
                              maxFontSize: AppTheme.bigLocationTextSize.max,
                              minFontSize: AppTheme.bigLocationTextSize.min,
                              style: Theme.of(context).textTheme.display2
                            )
                          ]
                        ),
                        SizedBox(
                          height: 10
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              size: 16,
                              color: Theme.of(context).accentColor
                            ),
                            SizedBox(
                              width: 4.0
                            ),
                            AutoSizeText(
                              widget.phoneNumber,
                              maxLines: 1,
                              maxFontSize: AppTheme.bigLocationTextSize.max,
                              minFontSize: AppTheme.bigLocationTextSize.min,
                              style: Theme.of(context).textTheme.display2
                            )
                          ],
                        ),
                        /*
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.mail_outline,
                                    size: 13.5,
                                    color: Theme.of(context).accentColor
                                  ),
                                  SizedBox(
                                    width: 4.0
                                  ),
                                  AutoSizeText(
                                    widget.email,
                                    maxLines: 1,
                                    maxFontSize: AppTheme.bigLocationTextSize.max,
                                    minFontSize: AppTheme.bigLocationTextSize.min,
                                    style: Theme.of(context).textTheme.display2
                                  )
                                ]
                              ),
                            ),
                            Spacer(
                              flex: 1
                            ),
                            Flexible(
                              flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.phone,
                                    size: 13.5,
                                    color: Theme.of(context).accentColor
                                  ),
                                  SizedBox(
                                    width: 4.0
                                  ),
                                  AutoSizeText(
                                    widget.ph  oneNumber,
                                    maxLines: 1,
                                    maxFontSize: AppTheme.bigLocationTextSize.max,
                                    minFontSize: AppTheme.bigLocationTextSize.min
                                  )
                                ],
                              )
                            )
                          ],
                        ),
                        */
                        SizedBox(
                          height: 8
                        ),
                        SizedBox(
                          height: 34,
                          child: locationComponent(context, widget.bigLocation, widget.littleLocation)
                        ),
                        SizedBox(
                          height: 15
                        ),
                        Container(
                          height: 1.5,
                          color: Theme.of(context).accentColor
                        ),
                        SizedBox(
                          height: 15
                        ),
                        Text(
                          widget.mainInfo,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.caption
                        ),
                        SizedBox(
                          height: 15
                        ),
                      ],
                    )
                  )
                ],
              )
            )
          ],
        );
      }
    );
  }

    Widget buildServicesInfoCards(BuildContext context, DocumentSnapshot doc) {
    return ServicesDetailInfoCard(
      doc: doc
    );
  }
}



// class DetailedServicesScreen extends StatelessWidget {
//   DetailedServicesScreen({
//     this.docId,
//     this.name,
//     this.image,
//   });

//   final String docId;
//   final String name;
//   final String image;

//   final double cardBorderRadius = 15.0;
//   final double cardSidePadding = 20.0;

//   final Color shadowColor = Color.fromRGBO(0,0,0,0.25);
//   final double shadowBlurRadius = 20.0;
//   final Offset shadowOffset = Offset(0,5);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             color: Theme.of(context).primaryColor
//           )
//         ),
//         Hero(
//           tag: 'servicesCardImg'+this.docId,
//           child: Container(
//             height: MediaQuery.of(context).size.width,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: NetworkImage(
//                   this.image
//                 )
//               )
//             )
//           )
//         ),
//         ListView(
//           children: <Widget>[
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(
//                   context
//                 );
//               },
//               child: Container(
//                 height: MediaQuery.of(context).size.width*0.85,
//                 color: Colors.transparent,
//               )
//             ),
//             Row(
//               children: <Widget>[
//                 Spacer(
//                   flex: 100
//                 ),
//                 Expanded(
//                   flex: 1000,
//                   child: Hero(
//                     tag: 'servicesCardTitle'+this.docId,
//                     child: Text(
//                       this.name,
//                       textAlign: TextAlign.left,
//                       style: Theme.of(context).textTheme.headline,
//                     )
//                   )
//                 )
//               ],
//             ),
//             SizedBox( 
//               height: 20
//             ),
//             StreamBuilder<QuerySnapshot>(
//               stream: Firestore.instance.collection('servicesCol').document(this.docId).collection('cards').snapshots(),
//               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: snapshot.data.documents.length,
//                     itemBuilder: (context, index) => buildServicesInfoCards(context, snapshot.data.documents[index])
//                   );
//                 } else if (snapshot.hasError) {
//                   return Container(
//                     margin: EdgeInsets.only(
//                       left: cardSidePadding,
//                       right: cardSidePadding
//                     ),
//                     padding: EdgeInsets.all(15.0),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).cardColor,
//                       borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: shadowColor,
//                           blurRadius: shadowBlurRadius,
//                           offset: shadowOffset
//                         )
//                       ]
//                     ),
//                     child: Text(
//                       "Sorry, there has been an error! :(",
//                       style: Theme.of(context).textTheme.title,
//                       textAlign: TextAlign.center
//                     )
//                   );
//                 } else {
//                   return Container(
//                     margin: EdgeInsets.only(
//                       left: cardSidePadding,
//                       right: cardSidePadding
//                     ),
//                     padding: EdgeInsets.all(15.0),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).cardColor,
//                       borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: shadowColor,
//                           blurRadius: shadowBlurRadius,
//                           offset: shadowOffset
//                         )
//                       ]
//                     ),
//                     child: SizedBox(
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).indicatorColor)
//                       )
//                     )
//                   );
//                 }
//               }
//             )
//           ],
//         )
//       ],
//     );
//   }
