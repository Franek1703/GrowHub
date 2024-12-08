import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/notification/cubit/notification_cubit.dart';
import 'package:growhub/features/notification/widgets/notification_menu.dart';
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
    return RefreshIndicator(
      onRefresh: () => context.read<NotificationCubit>().refreshNotifications(),
      child: ListView(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 90, top: 10),
        scrollDirection: Axis.vertical,
        children: [
          Builder(builder: (context) {
            if (newTiles.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: GHColors.black),
                    ),
                    Divider(
                      color: GHColors.grey,
                    ),
                    ...newTiles.map((tile) => NotificationTile(
                          tile: tile,
                          onTileMenuOpen: () {
                            showModalBottomSheet<void>(
                                useRootNavigator: true,
                                clipBehavior: Clip.hardEdge,
                                barrierColor: GHColors.black.withOpacity(0.8),
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
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: GHColors.black),
                      ),
                      Divider(
                        color: GHColors.grey,
                      ),
                      ...todaysTiles.map((tile) => NotificationTile(
                            tile: tile,
                            onTileMenuOpen: () {
                              showModalBottomSheet<void>(
                                  useRootNavigator: true,
                                  barrierColor: GHColors.black.withOpacity(0.8),
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
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: GHColors.black),
                      ),
                      Divider(
                        color: GHColors.grey,
                      ),
                      ...oldTiles.map((tile) => NotificationTile(
                            tile: tile,
                            onTileMenuOpen: () {
                              showModalBottomSheet<void>(
                                  useRootNavigator: true,
                                  barrierColor: GHColors.black.withOpacity(0.8),
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
            },
          )
        ],
      ),
    );
  }
}
