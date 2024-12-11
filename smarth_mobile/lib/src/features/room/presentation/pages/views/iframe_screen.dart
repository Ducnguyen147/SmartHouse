import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class IframeScreen extends StatefulWidget {
  final PageController pageController;
  final int crossAxisCount;
  const IframeScreen(
      {this.crossAxisCount = 6, required this.pageController, super.key});
  @override
  State<IframeScreen> createState() => _IframeScreenState();
}

class _IframeScreenState extends State<IframeScreen> {
  final IFrameElement _iFrameElement = IFrameElement();

  @override
  void initState() {
    _iFrameElement.style.minHeight = '92vh';
    _iFrameElement.style.minWidth = '25vw';
    _iFrameElement.src = 'http://localhost:3000';
    _iFrameElement.style.border = 'none';

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
    );

    super.initState();
  }

  final Widget _iframeWidget = HtmlElementView(
    viewType: 'iframeElement',
    key: UniqueKey(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            //Column(
            // children: [
            SizedBox(
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      child: _iframeWidget,
    )
        //   ],
        // ),
        );
  }
}
