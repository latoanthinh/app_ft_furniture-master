import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/router.dart';
import '../../../constants/size.dart';

class IChingHomeTab extends StatelessWidget {
  const IChingHomeTab({super.key});

  Future<void> _onPressSentMessage(BuildContext context) async {
    context.goNamed(AppRouter.iChingCoinToss);
  }

  @override
  Widget build(BuildContext context) {
    final sizeMargin = AppSize.sizeScreenMargin(context);
    final textStyle = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: context.pop),
        title: Text('i_ching.home.appbar_title'.tr()),
      ),
      bottomNavigationBar: TextField(
        textAlignVertical: TextAlignVertical.center,
        autofocus: true,
        decoration: InputDecoration(
          fillColor: colorScheme.primaryContainer,
          filled: true,
          iconColor: colorScheme.onPrimaryContainer,
          prefixIcon: const Icon(Icons.chat_outlined),
          suffixIcon: IconButton(
            onPressed: () => _onPressSentMessage(context),
            icon: const Icon(Icons.send),
          ),
          hintText: 'i_ching.home.question_input_hint'.tr(),
        ),
        minLines: 1,
        maxLines: 5,
      ),
      body: ListView(
        padding: EdgeInsets.all(sizeMargin),
        children: [
          Text(
            'i_ching.home.support_title'.tr(),
            style: textStyle.headlineMedium,
          ),
          SizedBox(height: sizeMargin),
          Markdown(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            data: 'i_ching.home.support_content'.tr(),
          ),
        ],
      ),
    );
  }
}
