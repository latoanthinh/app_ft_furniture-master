import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../business_logic/i_ching/i_ching_list/list_bloc.dart';
import '../../../business_logic/i_ching/i_ching_list/list_event.dart';
import '../../../business_logic/i_ching/i_ching_list/list_state.dart';
import '../../../constants/router.dart';
import '../../../constants/size.dart';
import '../../../data/repositories/i_ching/models/hexagram.dart';
import '../widgets/yin_yang_line.dart';

class IChingResearchTab extends StatelessWidget {
  const IChingResearchTab({super.key});

  void _onPressedHexagram(BuildContext context, String? hexagramCode) {
    context.goNamed(AppRouter.iChingDetail, pathParameters: {'code': hexagramCode ?? '000000'});
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }

  Widget _buildView(BuildContext context) {
    final sizeMargin = AppSize.sizeScreenMargin(context);
    final textTheme = Theme.of(context).textTheme;
    final iChingListBloc = context.read<IChingListBloc>();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: context.pop),
        title: Text('i_ching_tab.appbar_title'.tr()),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          iChingListBloc.add(IChingListEvent.init());
          await iChingListBloc.stream.first;
        },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeMargin).copyWith(top: sizeMargin),
              child: Text(
                'i_ching.research.i_ching_list_intro',
                style: textTheme.headlineMedium,
              ),
            ),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: sizeMargin),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: AppSize.compact,
                mainAxisExtent: AppSize.sp64,
              ),
              children: [
                ListTile(
                  onTap: () => {},
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.symmetric(horizontal: sizeMargin),
                  leading: Icon(Icons.text_snippet),
                  title: Text(
                    'Template 1',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: AppSize.sp8),
                    child: Text(
                      'Template 2',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => {},
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.symmetric(horizontal: sizeMargin),
                  leading: Icon(Icons.text_snippet),
                  title: Text(
                    'Template 1',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: AppSize.sp8),
                    child: Text(
                      'Template 2',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => {},
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.symmetric(horizontal: sizeMargin),
                  leading: Icon(Icons.text_snippet),
                  title: Text(
                    'Template 1',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: AppSize.sp8),
                    child: Text(
                      'Template 2',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeMargin).copyWith(top: sizeMargin),
              child: Text(
                'i_ching.research.i_ching_list_title',
                style: textTheme.headlineMedium,
              ),
            ),
            BlocSelector<IChingListBloc, IChingListState, Iterable<Hexagram>?>(
              selector: (state) => state.hexagrams?.values,
              builder: (context, hexagrams) {
                return Visibility(
                  visible: hexagrams != null,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: sizeMargin),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: AppSize.compact,
                      mainAxisExtent: AppSize.sp64,
                    ),
                    children: hexagrams?.map((hexagram) {
                          return Hero(
                            tag: 'hero_hexagram_detail_${hexagram.code}',
                            child: Material(
                              child: ListTile(
                                onTap: () => _onPressedHexagram(context, hexagram.code),
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.symmetric(horizontal: sizeMargin),
                                leading: FittedBox(
                                  fit: BoxFit.fill,
                                  alignment: Alignment.bottomCenter,
                                  child: YinYangLine(
                                    code: hexagram.code ?? '000000',
                                  ),
                                ),
                                title: Text(
                                  '${'i_ching.hexagrams.${hexagram.code}.hexagram_title_no'.tr()}: '
                                  '${'i_ching.hexagrams.${hexagram.code}.name'.tr()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(left: AppSize.sp8),
                                  child: Text(
                                    '${'i_ching.trigrams.${hexagram.upperTrigramCode}.name'.tr()} '
                                    '${'i_ching.trigrams.${hexagram.lowerTrigramCode}.name'.tr()} '
                                    '| "${'i_ching.hexagrams.${hexagram.code}.subtitle'.tr()}"',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
