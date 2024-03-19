// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:trip_planner/features/home/models/retreat_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.model,
    required this.index,
  });

  final RetreatModel model;
  final int index;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  PaletteGenerator? paletteGenerator;

  pallegeGenerate() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
        AssetImage(widget.model.assetName));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    pallegeGenerate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paletteGenerator?.dominantColor?.color ??
          paletteGenerator?.vibrantColor?.color ??
          Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: MyAppBar(
              assetName: widget.model.assetName,
              index: widget.index,
              name: widget.model.name,
              palette: paletteGenerator,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Text(
                    "Himachal"
                        "Manali"
                        "Ladakh",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyAppBar extends SliverPersistentHeaderDelegate {
  final String assetName;
  final int index;
  final String name;
  final PaletteGenerator? palette;
  MyAppBar({
    required this.assetName,
    required this.index,
    required this.name,
    required this.palette,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double opacity = 1;
    double opacity2 = 0;

    if (shrinkOffset > 100) {
      opacity2 = (shrinkOffset - 300) / 50;
    }

    if (shrinkOffset > 200) {
      opacity = (shrinkOffset - 200) / 150;

      opacity = 1 - opacity;
    }

    if (opacity2 > 1) {
      opacity2 = 1;
    }

    if (opacity2 < 0) {
      opacity2 = 0;
    }

    if (opacity < 0) {
      opacity = 0;
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          assetName,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    palette?.dominantColor?.color ??
                        palette?.vibrantColor?.color ??
                        Colors.white,
                  ],
                )),
          ),
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Iconsax.arrow_left,
                  color: Colors.white,
                ),
              ),
              Opacity(
                opacity: opacity2,
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 50,
          left: 16,
          right: 16,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 1.0, end: 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (BuildContext context, double value, Widget? child) {
                  return Transform.scale(
                    scale: 1 + value, // Scale factor for the title
                    child: Opacity(
                      opacity: 1 - value, // Opacity factor for the title
                      child: Opacity(
                        opacity: opacity,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 600;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
