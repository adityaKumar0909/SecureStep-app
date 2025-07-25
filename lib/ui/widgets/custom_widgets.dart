import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedIconSVG extends StatelessWidget {
  final String iconPath;
  final double size;
  final Color iconColor;
  final Color containerColor;

  const RoundedIconSVG({
    super.key,
    required this.iconPath,
    required this.size,
    required this.iconColor,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          iconPath,
          height: size,
          width: size,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class RoundedBrandingSVG extends StatelessWidget {
  final String iconPath;
  final double iconSize;
  final Color iconColor;
  final double fontSize;

  const RoundedBrandingSVG({
    super.key,
    required this.iconPath,
    required this.iconSize,
    required this.iconColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "SecureStep",
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8), // little space between text and icon
            SvgPicture.asset(
              iconPath,
              height: iconSize,
              width: iconSize,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}


class EditableTile extends StatefulWidget {
  final String initialText;
  final void Function(String updatedText) onTextChanged;
  final VoidCallback onDelete;

  const EditableTile({
    super.key,
    required this.initialText,
    required this.onTextChanged,
    required this.onDelete,
  });

  @override
  State<EditableTile> createState() => _EditableTileState();
}

class _EditableTileState extends State<EditableTile> {
  late bool isEditing;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    isEditing = false;
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) {
      widget.onDelete(); // Delete if blank
      return;
    }

    widget.onTextChanged(trimmed); // Only call on final submit
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xff353535),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            Expanded(
              child: isEditing
                  ? TextField(
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                controller: _controller,
                autofocus: true,
                onSubmitted: (_) => _save(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              )
                  : GestureDetector(
                onTap: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                child: Text(
                  _controller.text,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: isEditing
                  ? const Icon(Icons.check, color: Colors.white)
                  : SvgPicture.asset(
                "assets/profile_page/trash.svg",
                color: Colors.white,
                height: 30,
                width: 30,
              ),
              onPressed: () {
                if (isEditing) {
                  _save();
                } else {
                  widget.onDelete();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



class NameTile extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String updatedName) onNameChanged;

  const NameTile({
    super.key,
    required this.controller,
    required this.onNameChanged,
  });

  @override
  State<NameTile> createState() => _NameTileState();
}

class _NameTileState extends State<NameTile> {
  late bool isEditing;
  late String cachedInitial;

  @override
  void initState() {
    super.initState();
    isEditing = false;
    cachedInitial = widget.controller.text;
  }

  void _save() {
    final trimmed = widget.controller.text.trim();
    if (trimmed.isEmpty) return;

    if (trimmed != cachedInitial) {
      // only trigger if changed
      widget.onNameChanged(trimmed);
      cachedInitial = trimmed;
    }

    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xff353535),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Expanded(
            child: isEditing
                ? TextField(
              controller: widget.controller,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              autofocus: true,
              onSubmitted: (_) => _save(),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            )
                : GestureDetector(
              onTap: () {
                setState(() {
                  isEditing = true;
                });
              },
              child: Text(
                widget.controller.text,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              if (isEditing) {
                _save();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}


class ThumpingButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const ThumpingButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  State<ThumpingButton> createState() => _ThumpingButtonState();
}

class _ThumpingButtonState extends State<ThumpingButton> {
  double _scale = 1.0;

  void _handleTap() async {
    setState(() => _scale = 0.95); // shrink
    await Future.delayed(Duration(milliseconds: 100));
    setState(() => _scale = 1.0); // bounce back
    widget.onPressed(); // do the actual action
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: _scale),
      duration: Duration(milliseconds: 25),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              width: screenWidth * 0.6,
              height: screenHeight * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: widget.backgroundColor,
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

