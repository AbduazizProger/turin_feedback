import 'package:feedback/const/text_styles.dart';
import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    this.title,
    this.actions,
    required this.content,
    this.actionButtons = const [],
  });

  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final List<Widget> actionButtons;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: title != null
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title!, style: TextStyles.blackW700S24),
              Row(children: [
                for (var button in actionButtons)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: button,
                  ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ]),
            ])
          : null,
      content: SingleChildScrollView(child: content),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions ?? [],
        )
      ],
    );
  }
}
