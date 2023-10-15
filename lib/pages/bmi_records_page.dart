import 'package:dioproject/model/bmi_detail.dart';
import 'package:dioproject/repositories/bmi_repository.dart';
import 'package:dioproject/services/app_storage_service.dart';
import 'package:dioproject/shared/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class BmiRecordsPage extends StatefulWidget {
  const BmiRecordsPage({Key? key}) : super(key: key);

  @override
  State<BmiRecordsPage> createState() => _BmiRecordsPageState();
}

class _BmiRecordsPageState extends State<BmiRecordsPage> {
  BmiRepository bmiRepository = BmiRepository();
  AppStorageService storage = AppStorageService();
  late Box heightHiveBox;

  String userName = '';
  String userEmail = '';
  double userHeight = 0.0;
  var _bmiRecords = <BmiDetail>[];

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBmiRecords();
    _loadUserProfileData();
    _loadUserHeight();
  }

  void getBmiRecords() async {
    _bmiRecords = await bmiRepository.getData();
    setState(() {});
  }

  _loadUserProfileData() async {
    userName = await storage.getUserName();
    userEmail = await storage.getUserEmail();
    setState(() {});
  }

  _loadUserHeight() async {
    if (!Hive.isBoxOpen('user_height_box')) {
      heightHiveBox = await Hive.openBox('user_height_box');
    } else {
      heightHiveBox = Hive.box('user_height_box');
    }
    userHeight = await heightHiveBox.get('user_height') ?? 0.0;
    _heightController.text = userHeight.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(userName: userName, userEmail: userEmail),
      appBar: AppBar(
        title: const Text("BMI Records"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _dateController.text = "";
          _weightController.text = "";
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return AlertDialog(
                  title: const Text("Add BMI"),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(date);
                            }
                          }),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text("Height: (cm)"),
                      TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter height (in cm)",
                        ),
                      ),
                      const SizedBox(
                        height: 16,
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
                            debugPrint("bmiRepository save");
                            final newBmiRecord =
                                BmiDetail(0, selectedDate, weight, height);

                            bmiRepository.save(newBmiRecord);
                            Navigator.pop(context);
                            setState(() {
                              _bmiRecords.add(newBmiRecord);
                            });
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
      body: Column(
        children: [
          Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Current Height (cm):",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Enter height (in cm)",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        double currentHeight =
                            double.tryParse(_heightController.text) ?? 0.0;
                        if (currentHeight > 30 && currentHeight < 300) {
                          debugPrint("Current height: $currentHeight");
                          heightHiveBox.put('user_height', currentHeight);
                          _heightController.text = currentHeight.toString();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Height saved successfully"),
                            ),
                          );
                          FocusManager.instance.primaryFocus?.unfocus();
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Invalid height"),
                                content: const Text(
                                    "Please enter a valid height in cm"),
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
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                final bmiClassification =
                    bmiRecord.bmiClassification?.toString();

                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    final deletedRecord = _bmiRecords[index];
                    bmiRepository.delete(deletedRecord);
                    setState(() {
                      _bmiRecords.removeAt(index);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.monitor_weight),
                      title: Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        'Weight: $formattedWeight | Height: $formattedHeight m | BMI: $formattedBmi\nClassification: $bmiClassification.',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
