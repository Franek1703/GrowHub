import 'package:flutter/widgets.dart';
import 'package:growhub/config/assets.gen.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;
  const BackgroundImage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Stack(
            children: [
              Positioned(
                top: -55,
                right: -55,
                child: Transform.rotate(
                    angle: -2.4,
                    child: Assets.kwiatki.sproutPlantSvgrepoCom
                        .svg(width: 200, height: 200)),
              ),
            ],
          ),
        ),
        child
      ],
    );
  }
}
