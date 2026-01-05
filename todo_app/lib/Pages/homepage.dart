import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Services/dbhelper.dart';
import 'package:todo_app/Services/todomodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController todoController = TextEditingController();
  Future<List<ToDoModel>>? data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = Dbhelper.instance.getToDos();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do",style: GoogleFonts.aclonica(textStyle: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),),
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Add To Do',style: TextStyle(fontWeight: FontWeight.bold),),
                content: TextField(
                  controller: todoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter To Do'
                  ),
                ),
                actions: [
                  ElevatedButton(onPressed: (){
                    onSave(ToDoModel(todo: todoController.text,isDone: 0));
                    todoController.clear();
                    refreshToDos();
                    Navigator.pop(context);}, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),child: Text('Save',style: TextStyle(color: Colors.white),)),
                  ElevatedButton(onPressed: (){Navigator.pop(context);}, style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),child: Text("Exit",style: TextStyle(color: Colors.white),))
                ],
              );
            }).then(refreshToDos());
        },
        backgroundColor: Colors.lightGreen,
        child: Icon(Icons.add,color: Colors.white,),),
        body: FutureBuilder<List<ToDoModel>>(
          future: data, 
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(child: Text("To Do is not added"),);
            }
            else if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  final data = snapshot.data![index];
                  bool answer = checkValue(data.isDone!);
                  return Card(
                    color: const Color.fromARGB(255, 213, 238, 186),
                    child: ListTile(
                      onLongPress: () => deleteToDo(ToDoModel(id: data.id)),
                      title: Text(data.todo.toString(),style: TextStyle(decoration: data.isDone == 1 ? TextDecoration.lineThrough : TextDecoration.none),),
                      trailing: Checkbox(value: answer, onChanged: (value) {
                        updateToDoStatus(ToDoModel(id: data.id,isDone: data.isDone == 0 ? 1:0,todo: data.todo));
                      },),
                    ),
                  );
                });
            }
          }),

    );
  }
  onSave(ToDoModel model) async{
    await Dbhelper.instance.insertToDos(model);
  }

  refreshToDos() async{
    setState(()  {
      data =  Dbhelper.instance.getToDos();
    });
  }
  deleteToDo(ToDoModel model) async{
  await Dbhelper.instance.deleteToDos(model);
  refreshToDos();
  }
  checklinethrough(int ss){

  }
  bool checkValue(int status){
    return status == 0 ? false : true ;
  }

  updateToDoStatus(ToDoModel model) async{
    await Dbhelper.instance.updateToDos(model);
    refreshToDos();
  }
}