import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
  });

  final String title;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width ?? 150,
        height: widget.height,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Color.fromARGB(255, 209, 209, 209)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text(widget.title)),
        ),
      ),
    );
  }
}
