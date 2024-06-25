import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/core/colors.dart';

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final IconData icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = Icons.camera_front;
          case CameraFacing.back:
            icon = Icons.camera_rear;
        }

        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () async {
            await controller.switchCamera();
          },
          child: Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: icon == Icons.camera_front ? c_FDB623 : Colors.transparent,
              border: Border.all(
                color: c_FFFFFF,
              ),
            ),
            child: Icon(
              icon,
              color: c_FFFFFF,
            ),
          ),
        );
      },
    );
  }
}