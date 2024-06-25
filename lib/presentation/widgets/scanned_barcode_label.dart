import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/data/storage_helper.dart';
import 'package:vibration/vibration.dart';

import '../../core/strings.dart';

class ScannedBarcodeLabel extends StatefulWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  State<ScannedBarcodeLabel> createState() => _ScannedBarcodeLabelState();
}

class _ScannedBarcodeLabelState extends State<ScannedBarcodeLabel> {
  String _previousValue = "";
  final StorageHelper _storageHelper = StorageHelper();

  final ValueNotifier<String> _buttonText = ValueNotifier(copyToClipboard);

  Future<void> _vibrate(String value) async {
    if ((await Vibration.hasVibrator() ?? false) && value != _previousValue) {
      Vibration.vibrate(duration: 100);

      _storageHelper.saveRecord({
        scanId: DateTime.now().millisecond,
        scanDate: DateTime.now().toString().split(".").first,
        scanResult: value,
      });

      _previousValue = value;
      _buttonText.value = copyToClipboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return const Text(
            scanSomething,
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        _vibrate(scannedBarcodes.first.displayValue ?? "");

        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  scannedBarcodes.first.displayValue ?? noDisplayValue,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Visibility(
                visible: scannedBarcodes.first.displayValue != null,
                child: ValueListenableBuilder<String>(
                    valueListenable: _buttonText,
                    builder: (context, String value, child) {
                      return InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                            text: scannedBarcodes.first.displayValue ?? "",
                          ));
                          _buttonText.value = copied;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
