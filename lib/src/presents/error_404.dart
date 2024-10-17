import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../constants/router.dart';
import '../constants/size.dart';

class Error404 extends StatelessWidget {
  final messages = const [
    "Chúng tôi đang làm việc hết mình để 'hồi sinh' trang web này thật nhanh! Cảm ơn bạn đã kiên nhẫn.",
    "Đừng lo lắng, chúng tôi đang 'làm thêm giờ' để khắc phục lỗi. Website sẽ sớm hoạt động trở lại!",
    "Nhân viên kỹ thuật của chúng tôi đang 'lao động miệt mài' để mang đến trải nghiệm tốt nhất cho bạn.",
    "Dường như trang web của chúng tôi đang bị 'zombie hóa'! Đội ngũ của chúng tôi đang làm việc để khôi phục lại sự sống cho nó.",
    "Hệ thống đã ghi nhận lỗi bạn đang gặp phải. Chúng tôi đang 'tìm kiếm' giải pháp để khắc phục.",
    "Chúng tôi đang cố gắng 'hồi sinh' trang web này bằng mọi cách, kể cả việc gọi hồn các lập trình viên huyền thoại!",
  ];

  const Error404({super.key});

  static String? message;

  @override
  Widget build(BuildContext context) {
    final sizeMargin = AppSize.sizeScreenMargin(context);
    final sizeScreen = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    Error404.message ??= messages[Random().nextInt(messages.length)];

    return Scaffold(
      body: Builder(builder: (context) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Container(
                color: const Color(0xffb78ece),
                child: SvgPicture.asset(
                  'assets/images/404-error.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: sizeMargin,
              left: sizeMargin,
              right: sizeMargin,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: sizeMargin),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(sizeMargin),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSize.sp16),
                    Text(
                      'Có lỗi trong quá trình xử lý liên kết này.',
                      style: textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSize.sp8),
                    Text(
                      message ?? '--',
                      style: textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSize.sp8),
                    ElevatedButton.icon(
                      onPressed: () => context.go(AppRouter.index),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(AppSize.sp24),
                      ),
                      icon: const Icon(Icons.home),
                      label: const Text('Trở về trang chủ'),
                    ),
                    const SizedBox(height: AppSize.sp16),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
