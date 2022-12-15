import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remainder/repository/project_friends.dart';

class ProjectPersonViewScreen extends StatefulWidget {
  final List<Friend> includedPeople;
  const ProjectPersonViewScreen(this.includedPeople, {Key? key}) : super(key: key);

  @override
  State<ProjectPersonViewScreen> createState() => _ProjectPersonViewScreenState();
}

class _ProjectPersonViewScreenState extends State<ProjectPersonViewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black54,
          title: Padding(
            padding: EdgeInsets.only(right: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timelapse, color: Colors.black),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Remainder",
                  style: GoogleFonts.barlow(color: Colors.black),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.timelapse,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: ListView.builder(
                          itemCount: widget.includedPeople.length,
                          itemBuilder: ((context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Text(
                                  style: GoogleFonts.nunito(fontSize: 20),
                                  "${widget.includedPeople[index].firstName} ${widget.includedPeople[index].lastName}  ",
                                )
                              ]
                              )
                          )
                          )
                      )
                  )
              )
          )
        ]
        )

    );
  }
}