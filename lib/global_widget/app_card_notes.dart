
import 'package:flutter/material.dart';

import '../app/notes/note_model.dart';
import '../constant/link_api.dart';

class AppCardNotes extends StatefulWidget {
  final void Function() onTap;
  final noteModel notemodel;
  final void Function()? onDelete;

  AppCardNotes({
    required this.onTap,
    super.key,
    required this.onDelete,
    required this.notemodel,
  });

  @override
  State<AppCardNotes> createState() => _AppCardNotesState();
}

class _AppCardNotesState extends State<AppCardNotes> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "$linkImageRoot/${widget.notemodel.notesImage}",
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text("${widget.notemodel.notesTitle} "),
                subtitle: Text("${widget.notemodel.notesContent}"),
                trailing: IconButton(
                  onPressed: () {
                    widget.onDelete!();
                    setState(() {});
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
