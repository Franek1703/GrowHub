import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/progress_indicator_small.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/device/device_cubit.dart';
import 'package:growhub/features/api/data/models/device_model.dart';
import 'package:growhub/features/settings/widgets/plant_pop_icon.dart';
import 'package:growhub/features/login/widgets/input_filed.dart';
import 'package:growhub/features/settings/widgets/toggle.dart';

/// The `SettingsPage` is responsible for rendering the settings interface
/// for a specific device. It displays the device name, location, a dosage toggle, and an icon representing the device.
class SettingsPage extends HookWidget {
  const SettingsPage({
    super.key,
    required this.deviceId,
  });

  /// The unique identifier for the device whose settings are being configured.
  final int deviceId;

  /// A helper function to retrieve the set of devices from the provided state.
  ///
  /// This function checks the state type and extracts the devices list accordingly.
  /// Returns `null` if devices are not available yet.
  Set<DeviceModel>? getDevices(DeviceState from) {
    final state = from;

    if (state is DeviceStateLoaded) {
      return state.devices;
    }

    if (state is DeviceStateLoading) {
      return state.devices;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // State hooks to track changes in the device name and location.
    final deviceName = useState<String>("");
    final deviceLocation = useState<String>("");

    useEffect(() {
      // Initialize deviceName and deviceLocation only once when the widget is first built.
      final device = context.read<DeviceCubit>().findDeviceById(
            getDevices(context.read<DeviceCubit>().state)!,
            deviceId,
          );
      if (device != null) {
        if (deviceName.value.isEmpty) deviceName.value = device.name;
        if (deviceLocation.value.isEmpty) deviceLocation.value = device.location ?? "";
      }
      return null; // Cleanup function not needed.
    }, [deviceId]); // Run only when the widget is created or deviceId changes.

    return Scaffold(
      backgroundColor: GHColors.background,
      body: BlocBuilder<DeviceCubit, DeviceState>(
        builder: (context, state) {
          // Show a progress indicator if devices are not yet loaded.
          if (getDevices(state) == null) {
            return const GHProgressIndicatorSmall();
          }

          // Retrieve the device details by ID.
          final device = context
              .watch<DeviceCubit>()
              .findDeviceById(getDevices(state)!, deviceId);

          // If the device is not found, display a progress indicator as a fallback.
          if (device == null) {
            return const GHProgressIndicatorSmall();
          }

          // Main content of the settings page.
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spacer to add vertical padding at the top.
                  const SizedBox(height: 32),

                  // Input field for the device name.
                  GHInputField(
                    text: deviceName.value,
                    hintText: "Device Name",
                    title: "Device Name",
                    onTitleChange: (value) {
                      deviceName.value = value;

                      // Save the updated device name using the DeviceCubit.
                      context.read<DeviceCubit>().updateDevice(
                            deviceId: deviceId,
                            name: value,
                          );
                    },
                  ),

                  // Spacer between the input fields.
                  const SizedBox(height: 16),

                  // Input field for the device location.
                  GHInputField(
                    text: deviceLocation.value,
                    hintText: "Device Location",
                    title: "Device Location",
                    onTitleChange: (value) {
                      deviceLocation.value = value;

                      // Save the updated device location using the DeviceCubit.
                      context.read<DeviceCubit>().updateDevice(
                            deviceId: deviceId,
                            location: value,
                          );
                    },
                  ),

                  // // Spacer between the input field and the dosage toggle.
                  // const SizedBox(height: 32),

                  // // Toggle widget to switch between automatic and manual dosage settings.
                  // Center(
                  //   child: GHToggle(
                  //     title: 'Dosage',
                  //     leftText: 'Auto',
                  //     rightText: 'every 12h',
                  //     onToggle: (isLeftSelected) {
                  //       // Handle toggle changes and print the selected state.
                  //       print(isLeftSelected ? 'Auto selected' : 'Every 12h selected');
                  //     },
                  //   ),
                  // ),

                  // Spacer between the toggle and the device icon.
                  const SizedBox(height: 42),

                  // Icon representing the current device, centered horizontally.
                  Center(
                    child: PlantPopIcon(
                      deviceId: deviceId,
                      icon: device.icon,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}