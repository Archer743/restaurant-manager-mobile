import 'package:flutter/cupertino.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/dialogs/confirmation_dialog.dart';

void showTableSelectionWarningDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  required int peopleCount,
  required int totalCapacity,
  required int maxAcceptableCapacity,
}) {
  String title;
  String content;

  if (totalCapacity < peopleCount) {
    title = 'Недостатъчен капацитет';

    if (totalCapacity == 0) {
      content =
          'Резервацията остава без маси, а броят на гостите е $peopleCount.';
    } else {
      content =
          'Избраните маси имат общ капацитет само $totalCapacity места, докато броят на гостите е $peopleCount.';
    }
  } else if (totalCapacity > maxAcceptableCapacity) {
    title = 'Прекомерно използване';
    content =
        'Избраният капацитет ($totalCapacity) е значително по-голям от нужния за $peopleCount гости.';
  } else {
    // Should be unreachable
    return;
  }

  content += ' Желаете ли да запазите въпреки това?';

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        content: content,
        confirmButtonText: 'Запази',
        onConfirm: onConfirm,
      );
    },
  );
}
