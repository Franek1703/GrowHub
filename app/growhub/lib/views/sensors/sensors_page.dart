import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/no_data_information.dart';
import 'package:growhub/common/widgets/page_padding.dart';
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

    useEffect(() {
      final sensorCubit = context.read<SensorCubit>();
      Future.microtask(() async {
        await sensorCubit.loadSensorReadings(deviceId);
        if (context.mounted) {
          isFirstLoaded.value = true;
        }
      });
      return null;
    }, [deviceId]);

    return isFirstLoaded.value == false
        ? const GHProgressIndicatorSmall()
        : GHRefreshIndicator(
            onRefresh: () async {
              if (context.mounted) {
                await context.read<SensorCubit>().loadSensorReadings(deviceId);
              }
            },
            child: GHPagePadding(
              bottom: 100,
              child: BlocBuilder<SensorCubit, SensorState>(
                builder: (context, state) {
                  final sensors = getSensors(state);
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 90),
                    children: [
                      sensors != null && sensors.isNotEmpty
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
                          : const NoDataInformation(
                              title: NoDataInformationText.noSensors,
                            )
                    ],
                  );
                },
              ),
            ),
          );
  }
}