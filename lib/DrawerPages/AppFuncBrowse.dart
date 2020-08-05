import 'package:flutter/material.dart';

class AppFuncBrowse extends StatefulWidget {
  @override
  _AppFuncBrowseState createState() {
    return _AppFuncBrowseState();
  }
}

class _AppFuncBrowseState extends State<AppFuncBrowse> {
  PageController _pageController=PageController();
  Color _pageColor=Colors.grey;
  int _pageIndex=0;
  GlobalKey<_AppFuncBrowseState> _pageIndicatorKey = GlobalKey();
  @override
  _scrollToPreviousPage() {
    if (_pageIndex > 0) {
      _pageController.animateToPage(_pageIndex - 1,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    }
  }
  _scrollToNextPage() {
    if (_pageIndex > 0) {
      _pageController.animateToPage(_pageIndex +1,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    }
  }
  Widget _createPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (pageIndex) {
        setState(() {
          _pageIndex = pageIndex;
          print(_pageController.page);
          print(pageIndex);
        });
      },
      children: <Widget>[
        Container(
          color: _pageColor,
          child: Center(
            child:ListView(
              padding: EdgeInsets.fromLTRB(30, 50, 30, 100),
              children: <Widget>[Image.asset('lib/Images/page1.png',)],
            )
          ),
        ),
        Container(
          color: _pageColor,
          child: ListView(
            padding: EdgeInsets.fromLTRB(30, 50, 30, 100),
            children: <Widget>[Image.asset('lib/Images/page2.png')],
          )
        ),
        Container(
          color: _pageColor,
          child: ListView(
            padding: EdgeInsets.fromLTRB(30, 50, 30, 100),
            children: <Widget>[Image.asset('lib/Images/page3.png')],
          )
        ),
        Container(
          color: _pageColor,
          child: ListView(
            padding: EdgeInsets.fromLTRB(30, 50, 30, 100),
            children: <Widget>[Image.asset('lib/Images/page4.png')],
          )
        ),
        Container(
          color: _pageColor,
          child: Center(
            child: RaisedButton(
              child: Text('Finished'),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ),
        )
      ],
    );
  }
  _createPageIndicator() {
    return Opacity(
      opacity: 0.7,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 60),
          height: 40,
          width: 100,
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: Colors.blue, //.withAlpha(128),
              borderRadius: BorderRadius.all(const Radius.circular(6.0))),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapUp: (detail) => _handlePageIndicatorTap(detail),
            child: Row(
                key: _pageIndicatorKey,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _dotWidget(0),
                  _dotWidget(1),
                  _dotWidget(2),
                  _dotWidget(3),
                  _dotWidget(4)
                ]),
          ),
        ),
      ),
    );
  }
  _dotWidget(int index) {
    return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (_pageIndex == index) ? Colors.white70 : Colors.black12));
  }
  _handlePageIndicatorTap(TapUpDetails detail) {
    RenderBox renderBox =
    _pageIndicatorKey.currentContext.findRenderObject();
    Size widgeSize = renderBox.paintBounds.size;
    Offset tapOffset =
    renderBox.globalToLocal(detail.globalPosition);

    if (tapOffset.dx > widgeSize.width / 2) {
      _scrollToNextPage();
    } else {
      _scrollToPreviousPage();
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
          color: Colors.white,
//        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: <Widget>[
              _createPageView(),
              _createPageIndicator()
            ],
          ),
        ));
  }
}
