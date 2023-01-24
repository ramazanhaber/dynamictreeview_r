import 'package:dynamictreeview_r/dynamic_treeview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RightClickModel {

  late BuildContext context;
  RightClickModel(BuildContext context){
    this.context=context;

  }
  void mesajYaz(String mesaj){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(mesaj),
    ));

  }

  Future<void> onPointerDown(PointerDownEvent event, BaseData baseData) async {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
      Overlay.of(context)!.context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          context: context,

          items: [
            PopupMenuItem(child: Text("         ["+baseData.getTitle()+"]       ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),), value: 0),
            PopupMenuItem(child: Text('Copy'), value: 1),
            PopupMenuItem(child: Text('Cut'), value: 2),
          ],
          position: RelativeRect.fromSize(
              event.position & Size(48.0, 48.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
          mesajYaz("kopyalandi "+baseData.getTitle());
          break;
        case 2:
          mesajYaz("kesildi "+baseData.getTitle());
          break;
        default:
      }
    }
  }

}