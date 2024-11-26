import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/notification/cubit/notification_cubit.dart';
import 'package:growhub/features/notification/widgets/notification_manu.dart';
import 'package:growhub/features/notification/widgets/notification_tile.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationState = context.watch<NotificationCubit>().state;
    final notificationTiles = notificationState.notifications;
    final now = DateTime.now();

    final newTiles = notificationTiles.where((element) {
      return element.time.month == now.month &&
          element.time.year == now.year &&
          element.time.day == now.day &&
          element.isResolved == false;
    }).toList();

    final todaysTiles = notificationTiles.where((element) {
      return element.time.month == now.month &&
          element.time.year == now.year &&
          element.time.day == now.day &&
          element.isResolved == true;
    }).toList();

    final oldTiles = notificationTiles.where(
      (element) =>
          todaysTiles.contains(element) == false &&
          newTiles.contains(element) == false,
    );
    return Scaffold(
      backgroundColor: GHColors.background,
      body: Padding(
        padding: EdgeInsets.only(bottom: 70),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          scrollDirection: Axis.vertical,
          children: [
            Builder(builder: (context) {
              if (newTiles.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New",
                      ),
                      Divider(
                        color: GHColors.grey,
                      ),
                      ...newTiles.map((tile) => NotificationTile(
                            tile: tile,
                            onTileMenuOpen: () {
                              showModalBottomSheet<void>(
                                  clipBehavior: Clip.hardEdge,
                                  barrierColor:
                                      GHColors.primary.withOpacity(0.8),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return NotificationMenu(
                                        model: tile,
                                        hideMenu: () => Navigator.pop(context));
                                  });
                            },
                          ))
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            Builder(
              builder: (context) {
                if (todaysTiles.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today",
                        ),
                        Divider(
                          color: GHColors.grey,
                        ),
                        ...todaysTiles.map((tile) => NotificationTile(
                              tile: tile,
                              onTileMenuOpen: () {
                                showModalBottomSheet<void>(
                                    barrierColor:
                                        GHColors.primary.withOpacity(0.8),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return NotificationMenu(
                                          model: tile,
                                          hideMenu: () =>
                                              Navigator.pop(context));
                                    });
                              },
                            ))
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            Builder(
              builder: (context) {
                if (oldTiles.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Previous",
                        ),
                        Divider(
                          color: GHColors.grey,
                        ),
                        ...oldTiles.map((tile) => NotificationTile(
                              tile: tile,
                              onTileMenuOpen: () {
                                showModalBottomSheet<void>(
                                    barrierColor:
                                        GHColors.primary.withOpacity(0.8),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return NotificationMenu(
                                          model: tile,
                                          hideMenu: () =>
                                              Navigator.pop(context));
                                    });
                              },
                            ))
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
