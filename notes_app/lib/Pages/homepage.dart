import 'package:flutter/material.dart';
import 'package:notes_app/Pages/addoreditpage.dart';
import 'package:notes_app/Services/dbhelper.dart';
import 'package:notes_app/Services/notesmodal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
      late Future<List<NotesModel>> data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = Dbhelper.instance.GetNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<NotesModel>>(
        future: data, 
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: Colors.amber,),);
          }
          else if(!snapshot.hasData){
            return Center(child: Text("No Notes Added",style: TextStyle(fontSize: 19),),);
          }
          
          else{
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context,index){
                final data = snapshot.data![index];
                return Card(
                  color: Colors.cyan,
                  child: ListTile(
                    title: Text(data.title.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(data.description.toString(),maxLines: 1,),
                    onLongPress: () async{
                      onDelete(data.id!);
                      refreshhhhh();
                    },
                    onTap: () async{
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => AddorEditPage(isSave: false,modell: NotesModel(title: data.title,description: data.description,id: data.id),)));
                        refreshhhhh();
                    },
                  ));
              });
          }
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddorEditPage(isSave: true,)));
            refreshhhhh();
          },
          backgroundColor: Colors.cyan,
          child: Icon(Icons.add,color: Colors.white,),),
    );
  }

  refreshhhhh()async{
    
    setState(() {
      data = Dbhelper.instance.GetNotes();  
    });
  }

  onDelete(int id) async{
    await Dbhelper.instance.deleteNote(NotesModel(id: id));
    
  }
}