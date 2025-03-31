import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateTeamScreen extends StatefulWidget {
  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _gameModeController = TextEditingController();
  final _adminNameController = TextEditingController();
  final _adminNumberController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _teamNameController = TextEditingController();
  int _teamMemberCount = 1;
  final List<Map<String, dynamic>> _teamMembers = [];
  bool _conditionsAccepted = false;

  void _addTeamMember() {
    if (_teamMembers.length < _teamMemberCount) {
      setState(() {
        _teamMembers.add({
          'name': '',
          'id': 0,
          'role': '',
        });
      });
    } else {
      Fluttertoast.showToast(msg: 'Maximum team members reached');
    }
  }

  void _removeTeamMember(int index) {
    setState(() {
      _teamMembers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _gameModeController,
                decoration: InputDecoration(labelText: 'Game Mode'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the game mode';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _adminNameController,
                decoration: InputDecoration(labelText: 'Admin Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the admin name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _adminNumberController,
                decoration: InputDecoration(labelText: 'Admin Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the admin number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _adminEmailController,
                decoration: InputDecoration(labelText: 'Admin Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the admin email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _teamNameController,
                decoration: InputDecoration(labelText: 'Team Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the team name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _teamMemberCount,
                onChanged: (int? newValue) {
                  setState(() {
                    _teamMemberCount = newValue!;
                  });
                },
                items: List<int>.generate(10, (index) => index + 1)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Team Members Count'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the team members count';
                  }
                  return null;
                },
              ),
              ..._teamMembers.map((member) {
                final index = _teamMembers.indexOf(member);
                return Column(
                  children: [
                    TextFormField(
                      initialValue: member['name'],
                      decoration: InputDecoration(labelText: 'Member ${index + 1} Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the member name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _teamMembers[index]['name'] = value;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: member['id'].toString(),
                      decoration: InputDecoration(labelText: 'Member ${index + 1} ID'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the member ID';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _teamMembers[index]['id'] = int.parse(value);
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: member['role'],
                      decoration: InputDecoration(labelText: 'Member ${index + 1} Role'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the member role';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _teamMembers[index]['role'] = value;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTeamMember(index),
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: _addTeamMember,
                child: Text('Add Team Member'),
              ),
              CheckboxListTile(
                title: Text('I accept the conditions'),
                value: _conditionsAccepted,
                onChanged: (bool? value) {
                  setState(() {
                    _conditionsAccepted = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _conditionsAccepted) {
                    try {
                      await authProvider.createTeam(
                        authProvider.userId ?? 0, // Use the user ID from authProvider
                        _gameModeController.text,
                        _adminNameController.text,
                        _adminNumberController.text,
                        _adminEmailController.text,
                        _teamNameController.text,
                        _teamMemberCount,
                      );
                      for (var member in _teamMembers) {
                        await authProvider.addTeamMember(
                          member['name'],
                          member['id'],
                          member['role'],
                        );
                      }
                      await authProvider.sendTeamIdEmail(_adminEmailController.text);
                      Fluttertoast.showToast(msg: 'Team created successfully');
                      Navigator.pop(context);
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'Failed to create team: $e');
                    }
                  } else {
                    Fluttertoast.showToast(msg: 'Please accept the conditions');
                  }
                },
                child: Text('Create Team'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Implement join team functionality
                  Fluttertoast.showToast(msg: 'Join team functionality not implemented yet');
                },
                child: Text('Join Team'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}