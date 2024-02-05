
import 'package:flutter/material.dart' ;
import 'package:webview_flutter/webview_flutter.dart';


void main() {
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
 
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 31, 147, 241)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sensors'),
    );
  }
}

class MyHomePage extends StatelessWidget{
  const MyHomePage({super.key, required this.title});
  
  final String title;

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture:  Image.asset("images/ziolabs_white.png"),
                accountName: const Text("지오랩스"), 
                accountEmail: const Text("ziolabs.co.kr"),
                onDetailsPressed: (){},)
            ]
          ),
        ),
        appBar: AppBar(
          title: Text(title)
        ),
        body:  Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomRight,
                      colors: [Color.fromARGB(118, 202, 243, 247), Color.fromARGB(255, 152, 232, 247)],
                    ),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                    ),
                  itemBuilder: (context, index){
                    var imageFile = "images/temp.png";
                  
                    if(index == 1){
                      imageFile = "images/rain.png";
                    }else if(index == 2){
                      imageFile = "images/hum2.png";
                    }else if(index == 3){
                      imageFile = "images/wind.png";
                    }
                      
                  
                    return InkWell(
                      child: Container(
                              alignment: Alignment.center,
                              child: Image.asset(imageFile, width: 200, height: 200,fit: BoxFit.fill,)                                                
                            ),
                      onTap: (){
                         var title = "";
                         switch(index){
                          case 0:
                            title = "온도";
                            break;
                          case 1:
                            title = "비";
                            break;
                          case 2:
                            title = "습도";
                            break;
                          case 3:
                            title = "바람";
                            break;
                         }

                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SensorScreen(title: title)),
                          );
                        
                      },
                    );
                  } 
                                ),
                ),
              
            )          
        );
   
    
  }
}

class SensorScreen extends StatelessWidget{
  const SensorScreen({super.key, required this.title});

  final String title;
  


  @override
  Widget build(BuildContext context) {
    
    String uriString="https://hujubnara1.cafe24.com/kjs/iotsensor.php?";

      switch(title){
        case "온도":
          uriString += "0";
          break;
        case "비":
          uriString += "1";
          break;     
        case "습도":
          uriString += "2";
          break;     
        case "바람":
          uriString += "3";
          break;       
      
      }


       WebViewController controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith(uriString)) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
      ..loadRequest(Uri.parse(uriString));
  
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: WebViewWidget (controller: controller,)
      ),
        
      
    );
  }
}