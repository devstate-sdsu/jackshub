import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'widgets/menu-card.dart';

class HomeScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: Text("Application"),
                floating: true,
                pinned: true,
                snap: false,
                bottom: new TabBar(
                  tabs: <Widget>[
                    Tab(icon: new Icon(Icons.event)),
                    Tab(icon: new Icon(Icons.room_service)),
                    Tab(icon: new Icon(Icons.fastfood)),
                  ]
                )
              )
            ];
          },
          body: new TabBarView(
            children: <Widget>[
              new ListView(
                children: <Widget>[
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                ],
              ),
              new ListView(
                children: <Widget>[
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                ],
              ),
              new ListView(
                children: <Widget>[
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                ],
              )
            ],
          )
        )
      )
    );
  }
}




/*
    return new DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                title: const Text('Jacks Hub'),
                centerTitle: true,
                pinned: false,
                floating: true,
                snap: true,
                expandedHeight: 200.0,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(icon: new Icon(Icons.event)),
                    Tab(icon: new Icon(Icons.room_service)),
                    Tab(icon: new Icon(Icons.fastfood)),
                  ]
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
              new Material(
              //color: Colors.white,
              child: ListView(
                children: <Widget>[
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
                  ),
                ],
              )
            ),
            new Container(
              color: Colors.grey,
            ),
            new Container(
              color: Colors.white,
            )
          ]
        )

      )
    );
  }
  */

  // Widget build(BuildContext context) {
  //   return new DefaultTabController(
  //     length: 3,
  //     child: new Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.white,
  //         title: Text('Jacks Hub'),
  //       ),
  //       body: TabBarView(
  //         children: <Widget>[
  //           new Container(
  //             color: Colors.white30,
  //           ),
  //           new Container(
  //             color: Colors.white70,
  //           ),
  //           new Container(
  //             color: Colors.grey,
  //             child: Image.network(
  //               'https://picsum.photos/250?image=9',
  //             )
  //           ),
  //         ]
  //       ),
  //       bottomNavigationBar: new BottomAppBar(
  //         color: Colors.white,
  //         child: new TabBar(
            
  //           tabs: <Widget>[
  //             Tab(icon: new Icon(Icons.event)),
  //             Tab(icon: new Icon(Icons.room_service)),
  //             Tab(icon: new Icon(Icons.fastfood)),
  //           ],
  //           labelColor: Colors.black,
  //           unselectedLabelColor: Colors.grey,
  //           indicatorSize: TabBarIndicatorSize.label,
  //           indicatorPadding: EdgeInsets.all(0.0),
  //           indicatorColor: Colors.red,
  //         )
  //       ),
  //     )
  //   );
  // }


  

