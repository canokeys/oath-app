import 'package:canaokey/main.dart';
import 'MultiLanguage.dart';
import 'package:flutter/widgets.dart';
class Streambuilder extends StatefulWidget {
  String str,extrainfo;
  TextStyle _textStyle;
  Streambuilder(this.str,this._textStyle,[this.extrainfo]);
  @override
  _StreambuilderState createState() => _StreambuilderState();
}

class _StreambuilderState extends State<Streambuilder> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LanguagePackage>(
      stream: LanBloc.of(context).bloc.languageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData&&widget.extrainfo!=null)
          return Text('${snapshot.data.id[widget.str]}${widget.extrainfo}',style:widget._textStyle);
        else if (snapshot.hasData&&widget.extrainfo==null)
          return Text(snapshot.data.id[widget.str],style:widget._textStyle);
        else return Container();
      },
    );
  }
}
