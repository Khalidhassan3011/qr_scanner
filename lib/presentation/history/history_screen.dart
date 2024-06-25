import 'package:flutter/material.dart';
import 'package:qr_scanner/core/colors.dart';
import 'package:qr_scanner/data/storage_helper.dart';

import '../../core/strings.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageHelper _storageHelper = StorageHelper();
  List<Map<dynamic, dynamic>> data = [];

  @override
  void initState() {
    _storageHelper.getAllRecord().forEach((item) {
      data.add(item);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c_3D3D3D,
      appBar: AppBar(
        backgroundColor: c_3D3D3D,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          scanHistory,
          style: TextStyle(
            color: c_FFFFFF,
          ),
        ),
        elevation: 5,
      ),
      body: data.isEmpty
          ? const Center(
              child: Text(
                noScanHistory,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            )
          : ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  height: .4,
                  thickness: .2,
                );
              },
              itemBuilder: (context, index) {
                int id = data[index][scanId];
                String date = data[index][scanDate];
                String result = data[index][scanResult];

                return Dismissible(
                  key: Key(id.toString()),
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    data.removeAt(index);
                    setState(() {});
                    StorageHelper().deleteRecode(id);
                  },
                  child: ListTile(
                    leading: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: c_FFFFFF,
                      ),
                    ),
                    title: Text(
                      result,
                      style: const TextStyle(
                        color: c_FFFFFF,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      date,
                      style: const TextStyle(
                        color: c_A4A4A4,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
