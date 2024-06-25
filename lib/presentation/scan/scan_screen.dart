import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/core/colors.dart';
import 'package:qr_scanner/presentation/history/history_screen.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

import '../widgets/scanned_barcode_label.dart';
import '../widgets/scanner_error_widget.dart';
import '../widgets/toggle_camera_button.dart';
import '../widgets/toggle_flash_button.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.all],
  );

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: MobileScanner(
                fit: BoxFit.fitHeight,
                controller: controller,
                scanWindow: scanWindow,
                errorBuilder: (context, error, child) {
                  return ScannerErrorWidget(error: error);
                },
                overlayBuilder: (context, constraints) {
                  return Container();
                },
              ),
            ),
            QRScannerOverlay(
              overlayColor: Colors.black.withOpacity(0.5),
              borderColor: c_FDB623,
              borderStrokeWidth: 5,
              scanAreaSize: const Size(200, 200),
            ),

            Positioned(
              right: 30.h,
              top: 25.w,
              child: SafeArea(
                child: Row(
                  children: [
                    SwitchCameraButton(controller: controller),

                    SizedBox(width: 20.w),

                    ToggleFlashlightButton(controller: controller),

                    SizedBox(width: 40.w),

                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HistoryScreen()),
                        );
                      },
                      child: Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: c_FFFFFF,
                          ),
                        ),
                        child: const Icon(
                          Icons.history,
                          color: c_FFFFFF,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ScannedBarcodeLabel(barcodes: controller.barcodes),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
