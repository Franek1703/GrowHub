import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/progress_indicator_small.dart';
import 'package:growhub/common/widgets/refresh_indicator.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';
import 'package:growhub/features/api/cubit/sensor/sensor_cubit.dart';
import 'package:growhub/features/sensors/widgets/sensor_card.dart';

class SensorPage extends HookWidget {
  const SensorPage({
    super.key,
    required this.deviceId,
  });

  final int deviceId;

  List<SensorModel>? getSensors(SensorState from) {
    final state = from;

    if (state is SensorStateLoaded) {
      return state.sensors;
    }

    if (state is SensorStateLoading) {
      return state.sensors;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isFirstLoaded = useState(false);

    useMemoized(
      () async {
        await context.read<SensorCubit>().loadSensorReadings(deviceId);
        isFirstLoaded.value = true;
      },
    );

    return isFirstLoaded.value == false
        ? const GHProgressIndicatorSmall()
        : GHRefreshIndicator(
            onRefresh: () async {
              context.read<SensorCubit>().loadSensorReadings(deviceId);
            },
            child: BlocBuilder<SensorCubit, SensorState>(
              builder: (context, state) {
                final sensors = getSensors(state);
                return ListView(
                  padding: const EdgeInsets.only(bottom: 90),
                  children: [
                    sensors != null
                        ? Column(
                            children: [
                              ...sensors.map(
                                (sensor) => SensorCard(
                                  sensor: sensor,
                                  index: sensor.id,
                                ),
                              )
                            ],
                          )
                        : Text("hehehe")
                  ],
                  // itemBuilder: (context, index) {
                  //   final sensor = state.sensors[index];
                  //   return SensorCard(
                  //     sensor: sensor,
                  //     index: index,
                  //   );
                  // },
                );
              },
            ),
          );
  }
}
