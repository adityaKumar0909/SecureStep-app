import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// -------------------- BouncyIconButton --------------------
class BouncyIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const BouncyIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<BouncyIconButton> createState() => _BouncyIconButtonState();
}

class _BouncyIconButtonState extends State<BouncyIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isPressed = true);
        widget.onPressed();
      },
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 150),
        tween: Tween<double>(
          begin: 1.0,
          end: _isPressed ? 0.85 : 1.0,
        ),
        onEnd: () => setState(() => _isPressed = false),
        child: widget.icon, // 👈 this makes it not rebuild
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
      ),
    );
  }
}

// -------------------- BouncyIconTextButton --------------------
class BouncyIconTextButton extends StatefulWidget {
  final String text;
  final String svgAssetPath;
  final double fontSize;
  final double iconSize;
  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;

  const BouncyIconTextButton({
    super.key,
    required this.text,
    required this.svgAssetPath,
    required this.onTap,
    this.fontSize = 24,
    this.iconSize = 28,
    this.width = 200,
    this.height = 70,
    this.borderRadius = 25,
    this.backgroundColor = const Color(0xffef233c),
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
  });

  @override
  State<BouncyIconTextButton> createState() => _BouncyIconTextButtonState();
}

class _BouncyIconTextButtonState extends State<BouncyIconTextButton> {
  double _scale = 1.0;

  void _triggerBounce() {
    setState(() => _scale = 0.95);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _scale = 1.0);
        widget.onTap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: widget.backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Text(
              widget.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: GoogleFonts.poppins(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w600,
                color: widget.textColor,
              ),
            ),
          ),
          SvgPicture.asset(
            widget.svgAssetPath,
            height: widget.iconSize,
            colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
          ),
        ],
      ),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: _scale),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutBack,
      child: GestureDetector(
        onTap: _triggerBounce,
        child: child,
      ),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
    );
  }
}
