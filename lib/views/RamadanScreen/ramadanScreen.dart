import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/ramdanControler.dart';

class RamadanScheduleScreen extends StatelessWidget {
  final RamadanController controller = Get.put(RamadanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ramadan Schedule'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Select Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.filterByDate(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredSchedule.isEmpty) {
                return Center(child: Text('No data for selected date'));
              }
              return ListView.builder(
                itemCount: controller.filteredSchedule.length,
                itemBuilder: (context, index) {
                  var item = controller.filteredSchedule[index];
                  bool isCurrentDate =
                      item['Date'] == DateTime.now().toString().split(' ')[0];
                  return Card(
                    color: isCurrentDate ? Colors.yellowAccent : Colors.white,
                    child: ListTile(
                      title: Text(
                          "Ramadan Day: ${item['Ramadan']}, Juz: ${item['Juz']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: ${item['Date']}, Day: ${item['Day']}",
                              style: TextStyle(color: Colors.grey)),
                          Text(
                              "Rakat 1: ${item['Rakat 1']}, Rakat 2: ${item['Rakat 2']}")
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
