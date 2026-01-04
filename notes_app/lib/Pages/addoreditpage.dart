import 'package:flutter/material.dart';
import 'package:notes_app/Services/dbhelper.dart';
import 'package:notes_app/Services/notesmodal.dart';

class AddorEditPage extends StatefulWidget {
  bool? isSave;
  NotesModel? modell;
   AddorEditPage({required this.isSave,this.modell,super.key});

  @override
  State<AddorEditPage> createState() => _AddorEditPageState();
}

class _AddorEditPageState extends State<AddorEditPage> {
  String? title;
  String? description;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onEdit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_circle_left,color: Colors.cyan,size: 40.0,))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Title'
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
                maxLines: 7,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Description'
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  onPressed: () async{
                    if(widget.isSave == true){
                      await onSave(NotesModel(title: titleController.text.toString(),description: descriptionController.text.toString()));
                    }
                    else{
                      await onUpdate(NotesModel(title: titleController.text,description: descriptionController.text,id: widget.modell?.id));
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan
                  ), 
                  child: Text(widget.isSave == true ? 'Save Note':'Edit Note',style: TextStyle(color: Colors.white,fontSize: 20),)),
              )
            ],
          ),
        ),
      ),
    );
  }

  onEdit() async{
    titleController.text = widget.modell?.title.toString() ?? "";
    descriptionController.text = widget.modell?.description.toString() ?? "";
  }
  onSave(NotesModel model) async{
    await Dbhelper.instance.insertNote(model);
  }

  onUpdate(NotesModel model) async{
    await Dbhelper.instance.updateNote(model);
  }
}