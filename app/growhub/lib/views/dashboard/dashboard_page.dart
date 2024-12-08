import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/common/widgets/refresh_indicator.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/user/user_cubit.dart';
import 'package:growhub/features/device_dashboard/cubit/device_cubit_cubit.dart';
import 'package:growhub/features/device_dashboard/widgets/device_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final devicesState = context.watch<DeviceCubit>().state;

    return Scaffold(
      body: GHRefreshIndicator(
        onRefresh: () async {
          print("Refreshing data...");
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 100),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    return Text.rich(
                      TextSpan(
                        text: 'Hi ',
                        style: const TextStyle(fontSize: 26),
                        children: <TextSpan>[
                          TextSpan(
                            text: state is UserStateLoaded
                                ? state.user.username
                                : "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: ',\nyour plants are doing fine!',
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // This maps the devices from your state into a list of DeviceCard widgets
              ...devicesState.devices.map(
                (device) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DeviceCard(device: device),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  // TODO: Add add new device logic here
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: GHColors.black, width: 4),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: GHColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
