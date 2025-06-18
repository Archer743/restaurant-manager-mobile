import 'package:flutter/material.dart';

class BackLeadingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const BackLeadingAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          if (context.mounted) Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
