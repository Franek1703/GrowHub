import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/common/widgets/progress_indicator.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/user/user_cubit.dart';
import 'package:growhub/features/api/data/models/user_model.dart';
import 'package:growhub/features/device_dashboard/cubit/device_cubit_cubit.dart';
import 'package:growhub/features/device_dashboard/widgets/device_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final devicesState = context.watch<DeviceCubit>().state;

    // TODO: Delete this test models

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if(state is UserStateLoaded || state is UserStateSignedUp) {
          late UserModel profile;
          switch(state) {
            case UserStateLoaded _:
              profile = state.user;
              break;
            case UserStateSignedUp _:
              profile = state.user;
              break;
          }
          return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Text.rich(
                    TextSpan(
                      text: 'Hi ',
                      style: const TextStyle(fontSize: 26),
                      children: <TextSpan>[
                        TextSpan(
                          text: profile.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: ',\nyour plants are doing fine!',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
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
                        border: Border.all(color: GHColors.black, width: 4)),
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
        );
        }
        else{
          return Center(child: GHProgressIndicator());
        }
      },
    );
  }
}
