import 'package:flutter/material.dart';

class YinYangLine extends StatelessWidget {
  final String code;
  final Color? lineColor;
  final double lineSpace;
  final double lineHeight;
  final EdgeInsetsGeometry? padding;

  const YinYangLine({
    super.key,
    required this.code,
    this.lineColor,
    this.lineSpace = 8,
    this.lineHeight = 8,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (code.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final lineColorPick = lineColor ?? colorScheme.onSurface;

    final heightYinYang =
        (((code.length * 2 - 1) / 2).floor() * lineSpace) + (((code.length * 2 - 1) / 2).ceil() * lineHeight);
    final widthYinYang = 5 * lineSpace + 6 * lineHeight;

    return Padding(
      padding: padding ?? EdgeInsets.all(lineSpace),
      child: SizedBox(
        width: widthYinYang,
        height: heightYinYang,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: code.length,
          separatorBuilder: (context, index) => SizedBox(height: lineSpace),
          itemBuilder: (context, index) {
            final char = code[code.length - 1 - index];
            if (char == '0') {
              return Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: Container(
                      height: lineHeight,
                      color: lineColorPick,
                    ),
                  ),
                  const Spacer(flex: 10),
                  Expanded(
                    flex: 15,
                    child: Container(
                      height: lineHeight,
                      color: lineColorPick,
                    ),
                  ),
                ],
              );
            }
            return Container(
              height: lineHeight,
              color: lineColorPick,
            );
          },
        ),
      ),
    );
  }
}
