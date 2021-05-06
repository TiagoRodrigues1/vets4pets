import 'package:flutter/material.dart';
import 'package:hello_world/screens/forumdetail.dart';
import 'colors.dart';

class ForumPage extends StatefulWidget {
  ForumPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ForumPageState createState() => new _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
 

  static final listItemsData = [
    new ListEntry("Forum 1", "test", "description 1", 54, 2, true),
    new ListEntry("Forum 2", "test", "description 2",  154, 3,false),
    new ListEntry("Forum 3", "test", "description 3", 971, 0, false),
    new ListEntry("Forum 4", "test", "description 4",  124, 2,true),
    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),
    new ListEntry("Forum 8", "test", "descrKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKiption 6",  12, 2,true),
    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),
        new ListEntry("Forum 5", "test", "description 5",  412, 5,true),

    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),

    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),

    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),


    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),

    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),

    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),

    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),

    new ListEntry("Forum 5", "test", "description 5",  412, 5,true),


 
  ];
  var listView = new ListView.builder(
     physics: const NeverScrollableScrollPhysics(), 
    itemBuilder: (BuildContext context, int index) =>
        EntryItem(entry:listItemsData[index]),
    itemCount: listItemsData.length,
    shrinkWrap: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: new Text(
          "Forum",
          textScaleFactor: 1.3,
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: _onSearchPressed,
          ),
        ],
      ),
       body: SingleChildScrollView(
        child:  Column(
          children: [listView],
        ),
      ),
    );
  }
  void _onSearchPressed() {
    Navigator.pop(context);
  }
}

class ListEntry {
  final String title;
  final String icon;
  final String description;
  final int views;
  final int responses;
  final bool answered;

  ListEntry(this.title, this.icon, this.description, this.views, this.responses, this.answered);
}

class CategoryIcon extends StatelessWidget {
  const CategoryIcon(this.icon, this.iconText, this.selected);

  final String iconText;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new IconButton(
            icon: new Icon(icon),
            onPressed: _onSearchPressed,
            color: selected == true
                ? AppColorsTheme.myTheme.primarySwatch
                : Colors.black,
          ),
          new Text(iconText)
        ],
      ),
    );
  }

  static void _onSearchPressed() {
  }
}

class EntryItem extends StatelessWidget {
  

  final ListEntry entry;
  EntryItem({Key key, this.entry}) : super(key: key);
  @override
 Widget build(BuildContext context) {
   var description;
   if(entry.description.length>25)
   {
 description=entry.description.substring(0,25);
 description=description +" ...";
   }
   else{
    description=entry.description;

   }
    return Container(
      padding: const EdgeInsets.all(3.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      decoration: new BoxDecoration(
        color: AppColorsTheme.myTheme.secondaryGradientColor,
        borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
      ),
      child: new ListTile(
        title: new Text(entry.title),
        subtitle: new Text(description),
        leading:  IconButton(
                      icon: entry.answered==true?const Icon(Icons.check_circle,color:Colors.green) : const Icon(Icons.cancel ,color:Colors.red), onPressed: () {  },
          ),     
        trailing:    new Container(
           padding: const EdgeInsets.only(top:10),
          child:Column(
            children: <Widget>[
              new Icon(Icons.comment,color: Colors.black,),
              new Text(entry.responses.toString()),
            ]
          )
          ,
        ),
                    
        onTap: () {
           Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForumDetailPage()),
                  );
        },
      )
    );
  }
}