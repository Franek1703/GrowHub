import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/device_dashboard/cubit/device_cubit_cubit.dart';
import 'package:growhub/features/profile/model/profile_model.dart';
import 'package:growhub/views/dashboard/device_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final devicesState = context.watch<DeviceCubit>().state;
    // TODO: Delete this test models
    final ProfileModel profile = ProfileModel(
        name: "Francesko",
        email: "francesko@gmail.com",
        password: "francesko_buahahah");
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
                  style: TextStyle(fontSize: 26),
                  children: <TextSpan>[
                    TextSpan(
                      text: profile.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
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
        
            SizedBox(height: 20),
        
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
                  border: Border.all(color: GHColors().black, width: 4)
                ),
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: GHColors().black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
