import 'package:binge_app/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantName, restaurantImage;
  DetailScreen({@required this.restaurantName, @required this.restaurantImage});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('restaurant_detail').document(widget.restaurantName).collection('menu').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if(snapshot.hasData)
              return GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, position) {
                    return buildMenu(snapshot.data.documents[position]);
                  }
              );
            }
          ),

          VideoPlayback(),
        ],
      ),
    );
  }

  Widget buildMenu(DocumentSnapshot document) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              document.data['food_image'],
              height: 100,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.filter_center_focus, color: document.data['type'] == 'veg'? Colors.green: Colors.red,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(document.data['name'],
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('₹ ${document.data['price']}'),
          )
        ],
      ),
    );
  }
}
