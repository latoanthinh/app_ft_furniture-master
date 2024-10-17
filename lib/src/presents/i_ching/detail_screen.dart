import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:furniture/src/presents/i_ching/widgets/yin_yang_line.dart';
import '../../business_logic/i_ching/i_ching_detail/detail_bloc.dart';
import '../../business_logic/i_ching/i_ching_detail/detail_event.dart';
import '../../business_logic/i_ching/i_ching_detail/detail_state.dart';
import '../../constants/size.dart';
import '../../data/repositories/i_ching/models/hexagram.dart';

class IChingDetailScreen extends StatelessWidget {
  final String hexagramCode;

  const IChingDetailScreen({super.key, required this.hexagramCode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IChingDetailBloc(
        localDataRepo: context.read(),
      )..add(IChingDetailEvent.getWithCode(code: hexagramCode)),
      child: Builder(builder: (context) => _buildView(context)),
    );
  }

  Widget _buildView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sizeMargin = AppSize.sizeScreenMargin(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('i_ching_detail_screen.research.appbar_title'.tr()),
      ),
      body: ListView(
        children: [
          Hero(
            tag: 'hero_hexagram_detail_$hexagramCode',
            child: _HexagramSession(hexagramCode: hexagramCode),
          ),
          const _MdDetailSession(),
        ],
      ),
    );
  }
}

class _HexagramSession extends StatelessWidget {
  final String hexagramCode;

  const _HexagramSession({required this.hexagramCode});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final sizeMargin = AppSize.sizeScreenMargin(context);
    final isCompactMode = AppSize.compact > MediaQuery.sizeOf(context).width;
    final hexagram = Hexagram(code: hexagramCode);
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSize.sp8),
      ),
      padding: EdgeInsets.all(sizeMargin),
      margin: EdgeInsets.all(sizeMargin).copyWith(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YinYangLine(
            code: hexagramCode,
          ),
          SizedBox(width: sizeMargin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSize.sp4),
                Text(
                  '${'i_ching.hexagrams.$hexagramCode.hexagram_title_no'.tr()}: ',
                  style: (isCompactMode ? textTheme.labelLarge : textTheme.titleMedium)
                      ?.copyWith(color: colorScheme.secondary),
                ),
                Text(
                  'i_ching.hexagrams.$hexagramCode.name'.tr(),
                  style: isCompactMode ? textTheme.titleLarge : textTheme.displaySmall,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeMargin),
                  child: Text(
                    '${'i_ching.trigrams.${hexagram.upperTrigramCode}.name'.tr()} '
                    '${'i_ching.trigrams.${hexagram.lowerTrigramCode}.name'.tr()}',
                    style: (isCompactMode ? textTheme.titleMedium : textTheme.titleLarge)
                        ?.copyWith(color: colorScheme.secondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeMargin),
                  child: Text(
                    'i_ching.hexagrams.$hexagramCode.subtitle'.tr(),
                    style: (isCompactMode ? textTheme.titleMedium : textTheme.titleLarge)
                        ?.copyWith(color: colorScheme.secondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MdDetailSession extends StatelessWidget {
  const _MdDetailSession();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sizeMargin = AppSize.sizeScreenMargin(context);
    return BlocSelector<IChingDetailBloc, IChingDetailState, String?>(
      selector: (state) => state.mdData,
      builder: (context, mdData) {
        return Visibility(
          visible: mdData != null,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSize.sp8),
            ),
            padding: EdgeInsets.all(sizeMargin),
            margin: EdgeInsets.all(sizeMargin),
            child: Markdown(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              data: mdData ?? '--',
            ),
          ),
        );
      },
    );
  }
}
