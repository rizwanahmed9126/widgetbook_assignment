import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgetbook_challenge/api/widgetbook_api.dart';



/// The app.
class App extends StatefulWidget {
  /// Creates a new instance of [App].
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  ///variable to take user input
  final nameController=TextEditingController();
  ///to validate the user input[if textfield if empty]
   bool _validate = false;
   ///variable to take user simulated backend response
   String? outPut;
   ///object of widgetBookAPi class
  final object=WidgetbookApi();
  ///variable to stop UI interaction when response being
  ///prepared from simulated backend
  bool absorb=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Challenge'),
      ),
      body:  AbsorbPointer(
        absorbing: absorb,
        child: Column(
          children:  [
            const Text('Hello Flutter enthusiast!'),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextFormField(
                controller: nameController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                ],
                decoration:  InputDecoration(
                  border:  const OutlineInputBorder(),
                  labelText: 'Enter Full Name',
                  errorText: _validate ? "Value Can't Be Empty" : null,

                ),

              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height*0.06,
              width: MediaQuery.of(context).size.width*0.4,
              decoration:  BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(22),

              ),
              child: TextButton(
                onPressed: ()async{
                  ///check if textField is empty
                  if(nameController.text.isEmpty){
                    setState(() {
                      nameController.text.isEmpty ? _validate = true
                          : _validate = false;
                      return;
                    });
                  }else{
                    setState(() {
                      ///stop UI Interaction
                      absorb=true;
                    });
                    try{

                      ///call method of simulated backend
                      final response= await object
                          .welcomeToWidgetbook(message: nameController.text);
                      setState(() {
                        outPut=response;
                        absorb=false;
                      });
                    }catch(e){
                      setState(() {
                        ///catch exception
                        outPut='Error Occurred';
                        absorb=false;
                      });
                    }
                  }
                },
                child: const Text('Submit',
                  style: TextStyle(color: Colors.white),),
              ),
            ),
           const SizedBox(height: 20,),

           if (outPut!=null) Text('Result: $outPut') else Container()

          ],
        ),
      ),
    );
  }
}
