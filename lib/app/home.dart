
import 'package:flutter/material.dart';

import '../constant/link_api.dart';
import '../global_widget/app_card_notes.dart';
import '../global_widget/crud.dart';
import '../main.dart';
import 'notes/edit_notes.dart';
import 'notes/note_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud _crud = Crud();

  getNotes() async {
    var response = await _crud.postRequest(linkViewNotes, {
      "id": sharedPref.getString("id"),
    });

    return response;
  }

  // deleteNote()async{
  //   var response =await _crud.postRequest(linkDeleteNotes, {
  //     'id': snapshot.data['data'][i]['notes_id'],
  //   });
  //   if(response['status']=='success'){
  //     Navigator.of(context).pushReplacementNamed("home");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addNotes");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              sharedPref.clear();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("/login", (route) => false);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),

        child: ListView(
          children: [
            FutureBuilder(
              future: getNotes(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No Data Found'));
                }
                if (snapshot.data['status'] == 'fail') {
                  return Center(child: Text("No Data"));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data['data'].length,
                    itemBuilder: (context, i) {
                      return AppCardNotes(
                     notemodel: noteModel.fromJson(snapshot.data['data'][i]),

                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EditNote(notes: snapshot.data['data'][i]),
                            ),
                          );
                        },
                        onDelete: () async {
                          var response = await _crud
                              .postRequest(linkDeleteNotes, {
                                'id':
                                    snapshot.data['data'][i]['notes_id']
                                        .toString(),
                            "imagename":snapshot.data['data'][i]['notes_image'].toString(),
                              });
                          if (response['status'] == 'success') {
                            Navigator.of(context).pushReplacementNamed("home");
                          }
                        },
                      );
                    },
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
