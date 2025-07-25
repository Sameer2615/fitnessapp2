import 'package:fitnessapp/firebase_services/firebase_auth.dart';
import 'package:fitnessapp/login_signup/front_page.dart';
import 'package:fitnessapp/main.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _unit = TextEditingController();
  String? selectedvalue = 'kg';
  String? weightselect;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Please Fill up your details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 28,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Firstname',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _firstname,
                  decoration: defaultInputDecoration.copyWith(
                    hintText: 'Enter your first name',
                  )),
              const SizedBox(
                height: 15,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lastname',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _lastname,
                  decoration: defaultInputDecoration.copyWith(
                    hintText: 'Enter your last name',
                  )),
              const SizedBox(
                height: 15,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gender',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownMenu(
                controller: _gender,
                width: double.infinity,
                dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                  DropdownMenuEntry(value: 'Male', label: 'Male'),
                  DropdownMenuEntry(value: 'Female', label: 'Female')
                ],
                onSelected: (String? value) {
                  setState(() {
                    selectedvalue = value;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Age',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _age,
                decoration: defaultInputDecoration.copyWith(
                  hintText: 'Enter your Age',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Height',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _height,
                decoration: defaultInputDecoration.copyWith(
                  hintText: '_ ft . _ inches',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Weight',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weight,
                      decoration: defaultInputDecoration.copyWith(
                        hintText: 'Enter weight',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: DropdownMenu<String>(
                      controller: _unit,
                      width: 100,
                      initialSelection: weightselect,
                      hintText: 'unit',
                      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                        DropdownMenuEntry(value: 'kg', label: 'kg'),
                        DropdownMenuEntry(value: 'lbs', label: 'lbs')
                      ],
                      onSelected: (String? value) {
                        setState(() {
                          weightselect = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await AuthService().userInform(
                      firstName: _firstname.text,
                      lastName: _lastname.text,
                      gender: _gender.text,
                      age: _age.text.trim(),
                      height: '${_height.text} ft',
                      weight: '${_weight.text} ${_unit.text}',
                    );

                    navigatorKey.currentState?.push(MaterialPageRoute(
                        builder: (context) => const FrontPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.black,
                  ),
                  child: Text('Submit',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const defaultInputDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: Color(0xFF9E9E9E), // Equivalent to Colors.grey[600]
    fontSize: 15,
  ),
  contentPadding: EdgeInsets.symmetric(
    vertical: 16.0,
    horizontal: 16.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(
      width: 2.0,
    ),
  ),
);
