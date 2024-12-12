import 'dart:html';
import 'dart:ui' as ui;
import 'dart:html' as html; // For postMessage communication
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
    // _iFrameElement.style.minHeight = '25vh';
    // _iFrameElement.style.minWidth = '25vw';
    _iFrameElement.src = 'http://localhost:3000';
    _iFrameElement.style.border = 'none';

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
    );

    super.initState();
    // Add a listener for postMessage
    html.window.onMessage.listen((event) {
      if (event.data['action'] == 'toggle_chat') {
        setState(() {
          _isChatVisible = !_isChatVisible;
        });
      }
    });
  }

  bool _isButtonVisible = true; // Controls button visibility

  final Widget _iframeWidget = HtmlElementView(
    viewType: 'iframeElement',
    key: UniqueKey(),
  );

  bool _isChatVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Floating Action Button (Fixed Position)
        if (_isButtonVisible)
          FloatingActionButton(
            backgroundColor: Colors.blue, // Customize color
            onPressed: () {
              setState(() {
                _isChatVisible = true; // Show chatbox content
                _isButtonVisible = false; // Remove button permanently
              });
            },
            child: Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
        // Chatbox Content (Conditionally Visible)
        if (_isChatVisible)
          Material(
            elevation: 0, // Optional: Adds shadow
            color: Colors.grey[200],
            child: SizedBox(
              width: 500,
              height: 500,
              child: _iframeWidget,
            ),
          ),
      ],
    );
  }
}
