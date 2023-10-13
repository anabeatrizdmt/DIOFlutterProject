import 'package:dioproject/model/bmi_detail.dart';
import 'package:dioproject/repositories/bmi_repository.dart';
import 'package:dioproject/services/app_storage_service.dart';
import 'package:dioproject/shared/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BmiRecordsPage extends StatefulWidget {
  const BmiRecordsPage({Key? key}) : super(key: key);

  @override
  State<BmiRecordsPage> createState() => _BmiRecordsPageState();
}

class _BmiRecordsPageState extends State<BmiRecordsPage> {
  BmiRepository bmiRepository = BmiRepository();
  AppStorageService storage = AppStorageService();

  String userName = '';
  String userEmail = '';
  var _bmiRecords = <BmiDetail>[];

  TextEditingController _dateController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBmiRecords();
    _loadData();
  }

  void getBmiRecords() async {
    _bmiRecords = bmiRepository.list();
    setState(() {});
  }

  _loadData() async {
    userName = await storage.getUserName();
    userEmail = await storage.getUserEmail();
    setState(() {
      userName = userName;
      userEmail = userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
          userName: userName, userEmail: userEmail),
      appBar: AppBar(
        title: const Text("BMI Records"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _dateController.text = "";
          _weightController.text = "";
          _heightController.text = "";

          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return AlertDialog(
                  title: const Text("Add BMI"),
                  content: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      const Text("Date: "),
                      TextField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () async {
                            var date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900, 5, 20),
                                lastDate: DateTime.now());
                            if (date != null) {
                              _dateController.text = date.toString();
                            }
                          }),
                      const Text("Height: (cm)"),
                      TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter height (in cm)",
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text("Weight: (kg)"),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter weight (in kg)",
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                        onPressed: () {
                          if (_dateController.text.isNotEmpty &&
                              _heightController.text.isNotEmpty &&
                              _weightController.text.isNotEmpty) {
                            DateTime selectedDate =
                                DateTime.parse(_dateController.text);
                            double height =
                                double.tryParse(_heightController.text) ?? 0.0;
                            double weight =
                                double.tryParse(_weightController.text) ?? 0.0;

                            bmiRepository
                                .add(BmiDetail(selectedDate, weight, height));
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("All fields are required"),
                                  content: const Text(
                                      "Please fill all the fields to calculate the BMI"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Save"))
                  ],
                );
              });
        },
      ),
      body: ListView.builder(
        itemCount: _bmiRecords.length,
        itemBuilder: (BuildContext context, int index) {
          _bmiRecords.sort((a, b) => b.date.compareTo(a.date));

          final bmiRecord = _bmiRecords[index];
          final formattedDate =
              DateFormat('MMMM d, yyyy').format(bmiRecord.date);
          final formattedWeight = bmiRecord.weight.toStringAsFixed(2);
          final heightInMeters = bmiRecord.height / 100;
          final formattedHeight = heightInMeters.toStringAsFixed(2);
          final formattedBmi = bmiRecord.bmi?.toStringAsFixed(2);
          final bmiClassification = bmiRecord.bmiClassification?.toString();

          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListTile(
              leading: const Icon(Icons.monitor_weight),
              title: Text(
                formattedDate,
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                'Weight: $formattedWeight | Height: $formattedHeight m | BMI: $formattedBmi\nClassification: $bmiClassification.',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          );
        },
      ),
    );
  }
}
