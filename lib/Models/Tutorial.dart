import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:canokey/Models/Bloc.dart';
import 'package:canokey/Models/StreamBuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/content_target.dart';
import 'package:tutorial_coach_mark/target_focus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Tutorial {
  static TutorialCoachMark tutorialCoachMark;

  static void initTargets() {
    LanguageBloc.targets.add(
        TargetFocus(
            enableOverlayTab:true ,
            identify: "Target 0",
            keyTarget: LanguageBloc.key1,
            contents: [
              ContentTarget(
                  align: AlignContent.bottom,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Streambuilder("refresh_info", TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0)),
                      ],
                    ),
                  )
              )
            ]
        )
    );
    addBottomBarHelp(LanguageBloc.key2, "bottom_add", CrossAxisAlignment.start);
    addBottomBarHelp(LanguageBloc.key3, "bottom_scan", CrossAxisAlignment.center);
    addBottomBarHelp(LanguageBloc.key4, "bottom_refresh", CrossAxisAlignment.end);
  }

  static void addBottomBarHelp(GlobalKey key, String info, CrossAxisAlignment alignment){
    LanguageBloc.targets.add(
      TargetFocus(
        keyTarget: key,
        enableOverlayTab: true,
        contents: [
          ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: alignment,
                children: [
                  Streambuilder(info, TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0)),
                ],
              ),
            )
          )
        ]
      )
    );
  }

  static void showTutorial(BuildContext context) {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: LanguageBloc.targets,
      colorShadow: Colors.blue,
      alignSkip: Alignment.topLeft,
      textSkip: "SKIP",
      textStyleSkip: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: (){
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType:AnimType.BOTTOMSLIDE,
          body: Column(
            children: <Widget>[
              Streambuilder('success',TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
              Streambuilder('start_client',TextStyle(fontSize: 16)),
            ],
          ),
        )..show();
      }
    )
      ..show();
  }

}