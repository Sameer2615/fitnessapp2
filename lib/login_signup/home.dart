// import 'package:fitnessapp/screens/profile.dart';
import 'package:fitnessapp/login_signup/calender.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pedometer/pedometer.dart';

// import 'package:fitnessapp/main.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///for pedometer concept
  /////stream handles asynchronous data its not a data type ok
  late Stream<StepCount> _stepCountStream;
  String steps = "0";

  @override
  void initState() {
    super.initState();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onError);
  }

  void _onStepCount(StepCount event) {
    setState(() => steps = event.steps.toString());
  }

  void _onError(error) {
    print("Step Count Error: $error");
  }

  ///to here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Macros',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 35),
              //////////MACROS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMacroIndicator(
                    label: "Carbohydrates",
                    value: 244,
                    maxValue: 276,
                    color: Colors.teal,
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  _buildMacroIndicator(
                    label: "Fat",
                    value: 25,
                    maxValue: 73,
                    color: Colors.purple,
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  _buildMacroIndicator(
                    label: "Protein",
                    value: 61,
                    maxValue: 111,
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              ///////////STEPS AND EXERCISES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _cards(
                      name: 'Steps',
                      data: '18',
                      goal: '$steps steps',
                      icon2: Icons.numbers,
                      icon3: Icons.cloud_circle),
                  _cards(
                      name: 'Exercises',
                      data: '204 cal',
                      goal: '00.25hr',
                      icon1: Icons.add,
                      icon2: Icons.fireplace_rounded,
                      icon3: Icons.timelapse_outlined),
                  // _cards(name: 'Rajina'),
                ],
              ),
              const SizedBox(
                height: 40,
              ),

              const SizedBox(height: 28),
              /////////////////STATISTICS PART////////////////

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColorDark,
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('Statistics',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 18)),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(6, (index) {
                          bool isCurrentDay = index == 2;
                          return Column(
                            children: [
                              Text(
                                '190 kcal', // Sample values
                                style: TextStyle(
                                  color: isCurrentDay
                                      ? Colors.black
                                      : Colors.transparent,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 100, // Total height of the indicator
                                width: 20, // Width of the indicator
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FractionallySizedBox(
                                    heightFactor: 0.7,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isCurrentDay
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                'Mon',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Calender()),
                  );
                },
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////MACROSSSSSSSSSSS

  Widget _buildMacroIndicator(
      {required String label,
      required double value,
      required double maxValue,
      required Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 10.0,
          percent: value / maxValue,
          center: Text(
            '$value/$maxValue',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
        ),
        const SizedBox(height: 24),
        Text(
          label,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          '${maxValue - value} left',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
  //////CARDDDDDDDDDDSSSSSS

  Widget _cards(
      {required String name,
      required String data,
      required String goal,
      IconData? icon1,
      required IconData icon2,
      required IconData icon3}) {
    return Card(
        color: Theme.of(context).primaryColorDark,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    icon1,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    icon2,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    icon3,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    goal,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              //
            ],
          ),
        ));
  }

///////////SHOW MODAL BOTTOM SHEET////////
  Future scrollbottom(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This is a Modal Bottom Sheet'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
