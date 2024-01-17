import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgame/style/menu/menu_text.dart';
import 'package:mgame/style/palette.dart';

enum ButtonType { standard, quit }

class MenuButton extends ConsumerStatefulWidget {
  const MenuButton({super.key, required this.text, required this.onPressed, required this.buttonType});

  final String text;
  final VoidCallback onPressed;
  final ButtonType buttonType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuButtonState();
}

class _MenuButtonState extends ConsumerState<MenuButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    Palette palette = ref.watch(paletteProvider);

    Map<String, Color> mapColor = switch (widget.buttonType) {
      ButtonType.standard => {'isPressed': palette.secondaryDark, '!isPressed': palette.secondary},
      ButtonType.quit => {'isPressed': palette.tertiaryDark, '!isPressed': palette.tertiary},
    };

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isPressed ? mapColor['isPressed'] : mapColor['!isPressed'],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: Offset(0, isPressed ? 2 : 4),
                blurRadius: isPressed ? 2 : 8,
              ),
            ],
          ),
          child: MenuText(
            text: widget.text,
            style: MenuTextStyle.button,
            color: MenuTextColor.white,
          ),
        ),
      ),
    );
  }
}
