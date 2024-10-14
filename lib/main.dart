import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}


class CustomIconButton extends StatefulWidget {
  final String text;
  final IconData leftIcon;
  final IconData rightIcon;
  final Color iconColor;
  final double fontSize;
  final Color textColor;
  final int maxLines;

  const CustomIconButton({
    Key? key,
    required this.text,
    required this.leftIcon,
    required this.rightIcon,
    required this.iconColor,
    this.fontSize = 16,
    this.textColor = Colors.black,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
          _scale = 0.93;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
          _scale = 1.0;
        });
        print("Button pressed with text: ${widget.text}");
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.7 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              shadowColor: Colors.blueAccent.withOpacity(0.5),
              elevation: 15,
              backgroundColor: Colors.transparent,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                constraints: const BoxConstraints(minWidth: 150, minHeight: 50),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.leftIcon, color: widget.iconColor, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      widget.text,
                      maxLines: widget.maxLines,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        color: widget.textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(widget.rightIcon, color: widget.iconColor, size: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class UserListCell extends StatelessWidget {
  final String imageUrl;
  final String userName;

  const UserListCell({
    Key? key,
    required this.imageUrl,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 600),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(imageUrl),
        ),
        title: Text(
          userName,
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}


class UserListView extends StatelessWidget {
  final List<String> imageUrls;
  final List<String> userNames;

  const UserListView({
    Key? key,
    required this.imageUrls,
    required this.userNames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userNames.length,
      itemBuilder: (context, index) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0), // Start from right
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: AnimationController(
                vsync: Scaffold.of(context),
                duration: const Duration(milliseconds: 500),
              )..forward(),
              curve: Curves.easeInOut,
            ),
          ),
          child: UserListCell(
            imageUrl: imageUrls[index],
            userName: userNames[index],
          ),
        );
      },
    );
  }
}


class UserGridView extends StatelessWidget {
  final List<String> imageUrls;

  const UserGridView({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 400),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(imageUrls[index]),
            radius: 40,
          ),
        );
      },
    );
  }
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  bool _showGridView = false;
  Color _bgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = List.generate(
      100,
          (index) => 'https://i.pravatar.cc/150?img=${index + 1}',
    );
    List<String> userNames = List.generate(100, (index) => 'User $index');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(' User List and Grid'),
          backgroundColor: Colors.blueAccent,
        ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          color: _bgColor,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomIconButton(
                  text: 'Toggle View',
                  leftIcon: Icons.view_list,
                  rightIcon: Icons.grid_view,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap to toggle between ListView and GridView',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: _showGridView
                      ? UserGridView(imageUrls: imageUrls)
                      : UserListView(
                    imageUrls: imageUrls,
                    userNames: userNames,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _showGridView = !_showGridView;
              _bgColor = _showGridView ? Colors.grey[100]! : Colors.white;
            });
          },
          child: AnimatedRotation(
            turns: _showGridView ? 0.5 : 0,
            duration: const Duration(milliseconds: 500),
            child: Icon(_showGridView ? Icons.list : Icons.grid_view),
          ),
        ),
      ),
    );
  }
}
