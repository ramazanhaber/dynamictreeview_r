import 'package:flutter/material.dart';

///Callback when child/parent is tapped . Map data will contain {String 'id',String 'parent_id',String 'title',Map 'extra'}

typedef OnTap = Function(Map data);

///A tree view that supports indefinite category/subcategory lists with horizontal and vertical scrolling
class DynamicTreeView extends StatefulWidget {
  ///DynamicTreeView will be build based on this.Create a model class and implement [BaseData]
  final List<BaseData> data;

  ///Called when DynamicTreeView parent or children gets tapped.
  ///Map will contain the following keys :
  ///id , parent_id , title , extra
  final OnTap onTap;

  ///The width of DynamicTreeView
  final double width;

  ///Configuration object for [DynamicTreeView]
  final Config config;
  DynamicTreeView({
    required this.data,
    this.config = const Config(),
    required this.onTap,
    this.width = 220.0,
  }) : assert(data != null);

  @override
  _DynamicTreeViewOriState createState() => _DynamicTreeViewOriState();
}

class _DynamicTreeViewOriState extends State<DynamicTreeView> {
  late List<ParentWidget> treeView;
  ChildTapListener _childTapListener = ChildTapListener(Map());

  @override
  void initState() {
    _buildTreeView();
    _childTapListener.addListener(childTapListener);
    super.initState();
  }

  void childTapListener() {
    if (widget.onTap != null) {
      var k = _childTapListener.getMapValue();
      widget.onTap(k);
    }
  }

  @override
  void dispose() {
    _childTapListener.removeListener(childTapListener);
    _childTapListener.dispose();
    super.dispose();
  }

  _buildTreeView() {
    var k = widget.data
        .where((data) {
      return data.getParentId() == widget.config.rootId;
    })
        .map((data) {
      return data.getId();
    })
        .toSet()
        .toList()
      ..sort((i, j) => i.compareTo(j));

    var widgets = <ParentWidget>[];
    k.forEach((f) {
      ParentWidget p = buildWidget(f, "");
      if (p != null) widgets.add(p);
    });
    setState(() {
      treeView = widgets;
    });
  }

  ParentWidget buildWidget(String parentId, String name) {
    var data = _getChildrenFromParent(parentId);
    BaseData d =
    widget.data.firstWhere((d) => d.getId() == parentId.toString());
    if (name == null) {
      name = d.getTitle();
    }

    var p = ParentWidget(
      baseData: d,
      onTap: widget.onTap,
      config: widget.config,
      children: _buildChildren(data),
      key: ObjectKey({
        'id': '${d.getId()}',
        'parent_id': '${d.getParentId()}',
        'title': '${d.getTitle()}',
        'extra': '${d.getExtraData()}'
      }),
    );
    return p;
  }

  _buildChildren(List<BaseData> data) {
    var cW = <Widget>[];
    for (var k in data) {
      var c = _getChildrenFromParent(k.getId());
      if ((c?.length ?? 0) > 0) {
        //has children
        var name = widget.data
            .firstWhere((d) => d.getId() == k.getId().toString())
            .getTitle();
        cW.add(buildWidget(k.getId(), name));
      } else {
        cW.add(ListTile(
          onTap: () {
            widget?.onTap({
              'id': '${k.getId()}',
              'parent_id': '${k.getParentId()}',
              'title': '${k.getTitle()}',
              'extra': '${k.getExtraData()}'
            });
          },
          contentPadding: widget.config.childrenPaddingEdgeInsets,
          title: Text(
            "${k.getTitle()}",
            style: widget.config.childrenTextStyle,
          ),
        ));
      }
    }
    return cW;
  }

  List<BaseData> _getChildrenFromParent(String parentId) {
    return widget.data
        .where((data) => data.getParentId() == parentId.toString())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return treeView != null
        ? SingleChildScrollView(
      child: Container(
        width: widget.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: treeView,
          ),
          physics: BouncingScrollPhysics(),
        ),
      ),
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
    )
        : Container();
  }
}

class ChildWidget extends StatefulWidget {
  final List<Widget> children;
  final bool shouldExpand;
  final Config config;
  ChildWidget({required this.children, required this.config, this.shouldExpand = false});

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> sizeAnimation;
  late AnimationController expandController;

  @override
  void didUpdateWidget(ChildWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldExpand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void initState() {
    prepareAnimation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    expandController.dispose();
  }

  void prepareAnimation() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    Animation<double> curve =
    CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);

    sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: sizeAnimation,
      axisAlignment: -1.0,
      child: Column(
        children: _buildChildren(),
      ),
    );
  }

  _buildChildren() {
    return widget.children.map((c) {
      // return c;
      return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: widget.config.childrenPaddingEdgeInsets,
            child: c,
          ));
    }).toList();
  }
}

class ParentWidget extends StatefulWidget {
  final List<Widget> children;
  final BaseData baseData;
  final Config config;
  final OnTap onTap;
  ParentWidget({
    required this.baseData,
    required this.onTap,
    required this.children,
    required this.config,
    required Key key,
  }) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget>
    with SingleTickerProviderStateMixin {
  bool shouldExpand = false;
  late Animation<double> sizeAnimation;
  late AnimationController expandController;

  @override
  void dispose() {
    super.dispose();
    expandController.dispose();
  }

  @override
  void initState() {
    prepareAnimation();
    super.initState();
  }

  void prepareAnimation() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    Animation<double> curve =
    CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);

    sizeAnimation = Tween(begin: 0.0, end: 0.5).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          onTap: () {
            var map = Map<String, dynamic>();
            map['id'] = widget.baseData.getId();
            map['parent_id'] = widget.baseData.getParentId();
            map['title'] = widget.baseData.getTitle();
            map['extra'] = widget.baseData.getExtraData();
            if (widget.onTap != null) widget.onTap(map);
          },
          title: Text(widget.baseData.getTitle(),
              style: widget.config.parentTextStyle),
          contentPadding: widget.config.parentPaddingEdgeInsets,
          trailing: IconButton(
            onPressed: () {
              setState(() {
                shouldExpand = !shouldExpand;
              });
              if (shouldExpand) {
                expandController.forward();
              } else {
                expandController.reverse();
              }
            },
            icon: RotationTransition(
              turns: sizeAnimation,
              child: widget.config.arrowIcon,
            ),
          ),
        ),
        ChildWidget(
          children: widget.children,
          config: widget.config,
          shouldExpand: shouldExpand,
        )
      ],
    );
  }
}

///A singleton Child tap listener
class ChildTapListener extends ValueNotifier<Map<dynamic, dynamic>> {
  /* static final ChildTapListener _instance = ChildTapListener.internal();

  factory ChildTapListener() => _instance;

  ChildTapListener.internal() : super(null); */
  late Map<dynamic, dynamic> mapValue;

  ChildTapListener(Map<dynamic, dynamic> value) : super(value);

  // ChildTapListener() : super(null);

  void addMapValue(Map map) {
    this.mapValue = map;
    notifyListeners();
  }

  Map getMapValue() {
    return this.mapValue;
  }
}

///Dynamic TreeView will construct treeview based on parent-child relationship.So, its important to
///override getParentId() and getId() with proper values.
abstract class BaseData {
  ///id of this data
  String getId();

  /// parentId of a child
  String getParentId();

  /// Text displayed on the parent/child tile
  String getTitle();

  ///Any extra data you want to get when tapped on children
  Map<String, dynamic> getExtraData();
}

class Config {
  final TextStyle parentTextStyle;
  final TextStyle childrenTextStyle;
  final EdgeInsets childrenPaddingEdgeInsets;
  final EdgeInsets parentPaddingEdgeInsets;

  ///Animated icon when tile collapse/expand
  final Widget arrowIcon;

  ///the rootid of a treeview.This is needed to fetch all the immediate child of root
  ///Default is 1
  final String rootId;

  const Config(
      {this.parentTextStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        this.parentPaddingEdgeInsets = const EdgeInsets.all(6.0),
        this.childrenTextStyle = const TextStyle(color: Colors.black),
        this.childrenPaddingEdgeInsets =
        const EdgeInsets.only(left: 15.0, top: 0, bottom: 0),
        this.rootId = "1",
        this.arrowIcon = const Icon(Icons.keyboard_arrow_down)});
}
