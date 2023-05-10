import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'main_page.dart';

class Menu extends StatelessWidget{
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("What The Dog Doing")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            SizedBox(
              height: 32,
              child: Marquee(
                text: "DoGallery",
                style: const TextStyle(fontSize: 25),
                blankSpace: 100,
                fadingEdgeStartFraction: .3,
                fadingEdgeEndFraction: .3,
                showFadingOnlyWhenScrolling: false,
              )
            ),
            ElevatedButton(
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));},
              style: const ButtonStyle(maximumSize: MaterialStatePropertyAll(Size(100, 50)),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: Text("Start"),
                  ),
                  Icon(Icons.arrow_right_outlined)
                ]
              )
            )
          ],
        )
      )
    );
  }
}