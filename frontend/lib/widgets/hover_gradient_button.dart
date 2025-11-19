import 'package:flutter/material.dart'; 

class HoverGradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const HoverGradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  _HoverGradientButtonState createState() => _HoverGradientButtonState();
}

class _HoverGradientButtonState extends State<HoverGradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHovered
                  ? [Color(0xFF2A5298), Color(0xFF4B7BC6)]
                  : [Color(0xFF1E3C72), Color(0xFF2A5298)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? Colors.blue : Colors.black,
                spreadRadius: 1,
                blurRadius: _isHovered ? 12 : 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 241, 213, 180),
            ),
          ),
        ),
      ),
    );
  }
}