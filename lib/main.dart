import 'package:dynamictreeview_r/datamodel.dart';
import 'package:flutter/material.dart';

import 'dynamic_treeview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAMBO DYNAMİC TREEVİEW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'DYNAMİC TREEVİEW'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  List<BaseData> getData() {
    return [
      DataModel(
        id: 1,
        name: 'Root',
        parentId: -1,
        extras: {'key': 'extradata1'},
      ),
      DataModel(
        id: 2,
        name: 'Men',
        parentId: 1,
        extras: {'key': 'extradata2'},
      ),
      DataModel(
        id: 3,
        name: 'Shorts',
        parentId: 2,
        extras: {'key': 'extradata3'},
      ),
      DataModel(
        id: 4,
        name: 'Shoes',
        parentId: 2,
        extras: {'key': 'extradata4'},
      ),
      DataModel(
        id: 5,
        name: 'Women',
        parentId: 1,
        extras: {'key': 'extradata5'},
      ),
      DataModel(
        id: 6,
        name: 'Shoes',
        parentId: 5,
        extras: {'key': 'extradata6'},
      ),
      DataModel(
        id: 7,
        name: 'Shorts',
        parentId: 5,
        extras: {'key': 'extradata7'},
      ),
      DataModel(
        id: 8,
        name: 'Tops',
        parentId: 5,
        extras: {'key': 'extradata8'},
      ),
      DataModel(
        id: 9,
        name: 'Electronics',
        parentId: 1,
        extras: {'key': 'extradata9'},
      ),
      DataModel(
        id: 10,
        name: 'Phones',
        parentId: 9,
        extras: {'key': 'extradata10'},
      ),
      DataModel(
        id: 11,
        name: 'Tvs',
        parentId: 9,
        extras: {'key': 'extradata11'},
      ),
      DataModel(
        id: 12,
        name: 'Laptops',
        parentId: 9,
        extras: {'key': 'extradata12'},
      ),
      DataModel(
        id: 13,
        name: 'Nike shooes',
        parentId: 4,
        extras: {'key': 'extradata13'},
      ),
      DataModel(
        id: 14,
        name: 'puma shoes',
        parentId: 4,
        extras: {'key': 'extradata14'},
      ),
      DataModel(
        id: 15,
        name: 'puma shoes 1',
        parentId: 14,
        extras: {'key': 'extradata15'},
      ),
      DataModel(
        id: 16,
        name: 'puma shoes 2',
        parentId: 14,
        extras: {'key': 'extradata16'},
      ),
      DataModel(
        id: 17,
        name: 'puma shoes 3',
        parentId: 14,
        extras: {'key': 'extradata17'},
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            DynamicTreeView(

              data: getData(), // pass here List<BaseModel>
              config: Config(
                  parentTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),

                  rootId: "1",

                  parentPaddingEdgeInsets:
                  EdgeInsets.only(left: 16, top: 0, bottom: 0)),

              onTap: (m) {
                // mesajYaz(m["title"].toString());
              },

              width: 300,
            )
          ],
        ),
      ),
    );
  }

  void mesajYaz(String mesaj){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(mesaj),
    ));

  }
}
