import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/no_data_information.dart';
import 'package:growhub/common/widgets/page_padding.dart';
import 'package:growhub/common/widgets/progress_indicator_small.dart';
import 'package:growhub/common/widgets/refresh_indicator.dart';
import 'package:growhub/common/widgets/progress_indicator.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/user/user_cubit.dart';
import 'package:growhub/features/api/data/models/user_model.dart';
import 'package:growhub/features/device_dashboard/cubit/device_cubit_cubit.dart';
import 'package:growhub/features/device_dashboard/widgets/device_card.dart';

class DashboardPage extends HookWidget {
  const DashboardPage({super.key});

  List<DeviceModel>? getDevices(DeviceState from) {
    final state = from;

    if (state is DeviceStateLoaded) {
      return state.devices.toList();
    }

    if (state is DeviceStateLoading) {
      return state.devices?.toList();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isFirstLoaded = useState(false);

    useMemoized(
      () async {
        await context.read<DeviceCubit>().loadData();
        isFirstLoaded.value = true;
      },
    );

    return Scaffold(
      body: isFirstLoaded.value == false
          ? const GHProgressIndicatorSmall()
          : GHRefreshIndicator(
              onRefresh: () async {
                await context.read<DeviceCubit>().loadData();
              },
              child: GHPagePadding(
                top: 60,
                bottom: 100,
                child: BlocBuilder<DeviceCubit, DeviceState>(
                  builder: (context, state) {
                    final devices = getDevices(state);
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: devices != null
                                          ? ',\nyour plants are doing fine! 🙌'
                                          : ",\nhow is your day going?",
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

                        devices != null
                            ? Column(
                                children: [
                                  ...devices.map(
                                    (device) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: DeviceCard(device: device),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: const NoDataInformation(
                                  title: NoDataInformationText.noDevices,
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
                              border:
                                  Border.all(color: GHColors.black, width: 4),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: GHColors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
