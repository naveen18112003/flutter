import 'package:flutter/material.dart';
import 'dart:js' as js;

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const HomePage(),
    );
  }
}

/// [Widget] displaying the home page consisting of an image and the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  String _imageUrl = '';
  bool _isFullscreen = false;
  bool _showMenu = false;

  /// Toggles fullscreen mode using JavaScript interop.
  void _toggleFullscreen() {
    if (_isFullscreen) {
      js.context.callMethod('exitFullscreen');
    } else {
      js.context.callMethod('enterFullscreen');
    }
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  /// Displays the image using an HTML <img> element.
  void _showImage() {
    if (_imageUrl.isNotEmpty) {
      js.context.callMethod('displayImage', [_imageUrl]);
    }
  }

  /// Toggles the visibility of the context menu.
  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  /// Closes the context menu.
  void _closeMenu() {
    setState(() {
      _showMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _imageUrl.isEmpty
                          ? null
                          : GestureDetector(
                              onDoubleTap: _toggleFullscreen,
                              child: HtmlElementView(
                                viewType: 'image-view',
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Image URL',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _imageUrl = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _showImage,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
          if (_showMenu)
            GestureDetector(
              onTap: _closeMenu,
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          if (_showMenu)
            Positioned(
              bottom: 80,
              right: 20,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _toggleFullscreen();
                      _closeMenu();
                    },
                    child: Text(
                      _isFullscreen ? 'Exit Fullscreen' : 'Enter Fullscreen',
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMenu,
        child: const Icon(Icons.add),
      ),
    );
  }
}