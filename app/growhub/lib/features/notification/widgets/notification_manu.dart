import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/notification/cubit/notification_cubit.dart';
import 'package:growhub/features/notification/model/notification_model.dart';

class NotificationMenu extends StatelessWidget {
  final NotificationModel model;
  final void Function() hideMenu;
  const NotificationMenu(
      {super.key, required this.model, required this.hideMenu});

  @override
  Widget build(BuildContext context) {
    //TODO: Implemnet right icons and colors
    final List<(String, dynamic, IconData, Color)> menuTile = [
      (
        "Mark as resolved",
        model.isResolved
            ? () {}
            : () {
                context.read<NotificationCubit>().markAsResolved(model);
                hideMenu();
              },
        Icons.done,
        model.isResolved ? GHColors.grey.withOpacity(0.6) : GHColors.black,
      ),
      (
        "Delete",
        () {
          context.read<NotificationCubit>().deleteNotification(model);
          hideMenu();
        },
        Icons.delete,
        Colors.red,
      ),
    ];
    return Container(
      height: 180,
      padding: EdgeInsets.symmetric(horizontal: 19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: GHColors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            height: 3,
            width: 72,
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ...menuTile.map(
          (tile) => Column(
            children: [
              GestureDetector(
                onTap: () {
                  tile.$2();
                },
                child: Row(
                  children: [
                    SizedBox(
                        width: 17,
                        height: 17,
                        child: Icon(
                          tile.$3,
                          color: tile.$4,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      tile.$1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: tile.$4, fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              menuTile.indexOf(tile) == menuTile.length - 1
                  ? const SizedBox.shrink()
                  : Divider(
                      color: GHColors.grey,
                    ),
              SizedBox(
                height: 7,
              ),
            ],
          ),
        ),
        // SizedBox(height: 100.h,)
      ]),
    );
  }
}
