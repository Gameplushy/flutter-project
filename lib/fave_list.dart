import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galleryimage/galleryimage.dart';

class FaveList extends StatefulWidget{
  const FaveList({super.key});

  @override
  State<FaveList> createState() => _FaveState();
}

class _FaveState extends State<FaveList>{

 SharedPreferences? sp;

  Future<void> getSP() async{
    SharedPreferences tmp;
    tmp = await SharedPreferences.getInstance();
    setState(() {
       sp = tmp;
    });
  }

  @override
  void initState(){
    super.initState();
    getSP();
  }

  Widget getList(){
    if(sp == null) return const Center(child: CircularProgressIndicator());
    var tmp = sp!.getStringList("favorites");
    tmp ??= [];
    return SingleChildScrollView(child:
      GalleryImage(
        imageUrls: tmp,
        numOfShowImages: tmp.length,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Save list"),),
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                  sp!.remove("favorites");  
                  Navigator.pop(context);          
                  });    
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  maximumSize: MaterialStatePropertyAll(Size(300, 128))
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 7), 
                        child:Text("Delete favorites", style: TextStyle(fontSize: 32),)
                      ),
                      Icon(Icons.delete)
                    ]
                  ),
              )
            ),
          Flexible(flex: 10,child: getList())
          ],
        )
      )
    );
  }

}