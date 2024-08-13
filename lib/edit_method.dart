import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Model/model.dart';
import "package:logger/logger.dart";

class EditPage extends StatefulWidget {
  final User? user;

  EditPage({this.user});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  final log = Logger();

  bool _isLoading = true;
  String _responseMessage = '';
  final String _baseUrl = 'https://66b4556a9f9169621ea27eef.mockapi.io/m';

  @override
  void initState() {
    super.initState();
    log.d("edit page");
    // Initialize the controllers
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    // Fetch the item data
    _fetchItem();
  }

  Future<void> _fetchItem() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/${widget.user?.id}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final item = User.fromJson(data);

        setState(() {
          _nameController.text = item.name;
          _emailController.text = item.email;
          _phoneController.text = item.phoneNumber.toString();
          _addressController.text = item.location;
          _isLoading = false;
        });
      } else {
        setState(() {
          _responseMessage = 'Failed to load item';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final updatedItem = User(
        id: widget.user!.id,
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: int.parse(_phoneController.text),
        location: _addressController.text,
      );

      try {
        final response = await http.put(
          Uri.parse('$_baseUrl/${widget.user?.id}'),
          headers: {'Content-Type': 'application/json'},
          body:
              json.encode(updatedItem.toJson()), // Make sure to encode the JSON
        );

        if (response.statusCode == 200) {
          setState(() {
            _responseMessage = 'Item updated successfully';
          });
        } else {
          setState(() {
            _responseMessage = 'Failed to update item: ${response.statusCode}';
          });
        }
      } catch (e) {
        setState(() {
          _responseMessage = 'Error: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _updateItem,
                            child: Text('Update Item'),
                          ),
                    SizedBox(height: 20),
                    Text(_responseMessage),
                  ],
                ),
              ),
      ),
    );
  }
}
