import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'fave_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  SharedPreferences? sharedPreference;
  bool lookingForImages = true;

  Future<String?> getDog() async{
    try {
      var httpResponse = await http.get(Uri(scheme: "https", host:"dog.ceo", path:"/api/breeds/image/random"));
      if(httpResponse.statusCode != 200) throw Exception();
  
      return jsonDecode(httpResponse.body)["message"];
    } catch(error) {
      return null;
    }
  }

  Widget showTinderWidget(){
    if(lookingForImages) return const CircularProgressIndicator();
    return 
      SwipeCards(
        matchEngine: matchEngine,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width:double.infinity, 
            height:double.infinity,
            decoration:BoxDecoration(border: Border.all(), color: Colors.white),
            child: cardList[index].content
          );   
        },
        onStackFinished: () async {await callAPI();},
        upSwipeAllowed: false,
      );
  }

  MatchEngine matchEngine = MatchEngine(swipeItems:[]);
  var cardList = <SwipeItem>[];

  //(Re)fills the Tinder Widget with cards.
  Future<void> callAPI() async{
    setState(() {
      lookingForImages = true;
    });
    sharedPreference ??= await SharedPreferences.getInstance();
    cardList = <SwipeItem>[];
    for(int i=0;i<10;i++){
      String? dogPic = await getDog();
      print(dogPic);
      //Check if any error happened
      if(dogPic==null) continue;
      try{
        cardList.add(SwipeItem(
          content: Image.network(dogPic),
          //This stores the url of the image. For the "nope" action, there's nothing to do in particular.
          likeAction: () {
            var oldFavList = sharedPreference!.getStringList("favorites");
            var newFavList = oldFavList == null ? [dogPic] : [...oldFavList,dogPic];
            sharedPreference!.setStringList("favorites", newFavList);
          },
        ));
      }
      catch(exception){
        continue;
      }
    }
    setState(() {
      matchEngine = MatchEngine(swipeItems:cardList);   
      lookingForImages = false;   
    });
  }

  @override
  void initState(){
    super.initState();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Do You Like This Dog ?"),
      ),
      body:
      Center(child: 
        Column(children: <Widget>
        [
          SizedBox(
            height: MediaQuery.of(context).size.height*0.75,
            width: double.infinity,
            child: showTinderWidget()
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: ()=>{if(matchEngine.currentItem != null) matchEngine.currentItem!.nope()},
                child: const Text("Discard"),
              ),
              ElevatedButton(
                onPressed: ()=>{if(matchEngine.currentItem != null) matchEngine.currentItem!.like()},
                child: const Text("Keep")
              )
            ]
          ),
          ElevatedButton(
            onPressed: ()=>{
              Navigator.push(context,MaterialPageRoute(builder: (context) => const FaveList()))
            }, 
            child: const Text("Get collection"),)
        ],
        )
      )
    );
  }
}