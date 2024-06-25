import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/colors.dart';

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return _icon(TorchState.auto, Icons.flash_auto);
          case TorchState.off:
            return _icon(TorchState.off, Icons.flash_off);
          case TorchState.on:
            return _icon(TorchState.on, Icons.flash_on);
          case TorchState.unavailable:
            return _icon(TorchState.unavailable, Icons.no_flash);
        }
      },
    );
  }

  Widget _icon(TorchState torchState, IconData icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () async {
        if(torchState != TorchState.unavailable) {
          await controller.toggleTorch();
        }
      },
      child: Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: torchState == TorchState.on ? c_FDB623 : Colors.transparent,
          border: Border.all(
            color: torchState == TorchState.unavailable ? Colors.grey : c_FFFFFF,
          ),
        ),
        child: Icon(
          icon,
          color: torchState == TorchState.unavailable ? Colors.grey : c_FFFFFF,
        ),
      ),
    );
  }
}