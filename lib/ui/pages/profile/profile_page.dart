import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:secure_step/core/services/updateUserProfile_service.dart';
import 'package:secure_step/ui/pages/main/main_page.dart';
import 'package:secure_step/ui/widgets/custom_buttons.dart';
import 'package:secure_step/ui/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/pageMedia.dart';
import '../../../core/constants/pageTexts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> emergencyContacts = [];
  String username = "empty";
  TextEditingController _usernameController = TextEditingController();
  String userEmail = "empty";
  TextEditingController _emailController = TextEditingController();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController(text: username);
    _emailController = TextEditingController(text: userEmail);
    loadFromPreferences();
  }

  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedName = prefs.getString('name');
    String? savedEmail = prefs.getString('email');

    List<String>? savedContacts = prefs.getStringList('emergencyContacts');

    setState(() {
      username = savedName ?? "";
      userEmail = savedEmail ?? "";
      emergencyContacts = savedContacts ?? [];
      _usernameController.text = username;
      _emailController.text = userEmail;
    });

    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(SnackBar(content: Text('Profile loaded successfully!')));
  }

  Future<void> saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text.trim());
    await prefs.setString('name', _usernameController.text.trim());
    await prefs.setStringList(
      'emergencyContacts',
      emergencyContacts.map((e) => e.trim()).toList(),
    );
    await updateUserProfileInServer();

    // Fluttertoast.showToast(
    //   msg: "Profile saved successfully!",
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   fontSize: 20,
    //   backgroundColor: Colors.white,
    //   textColor: Colors.black,
    // );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void updateName(String newName) {
      if (newName.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: MText('Please enter a name before updating.')),
        );
        return;
      }
      setState(() {
        username = newName;
        _usernameController.text = newName;
      });
    }

    void updateEmail(String newEmail) {
      final emailRegex = RegExp(r'^[\w-\.]+@(gmail|outlook|hotmail)\.com$');
      if (!emailRegex.hasMatch(newEmail)) {
        Fluttertoast.showToast(
          msg: "Only Gmail, Outlook, or Hotmail emails are allowed.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
        return;
      }
      if (newEmail.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter an email before updating.')),
        );
        return;
      }
      setState(() {
        userEmail = newEmail;
        _emailController.text = newEmail;
      });
    }

    void deleteName() {
      setState(() {
        username = "";
        _usernameController.clear();
      });
    }

    void updateTile(int index, String newText) {
      setState(() {
        emergencyContacts[index] = newText;
      });
    }

    void deleteTile(int index) {
      setState(() {
        emergencyContacts.removeAt(index);
      });
    }

    void addTile() {
      final emailRegex = RegExp(r'^[\w\.-]+@(?:gmail|outlook|hotmail)\.com$');

      if (emergencyContacts.length >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: MText('Only 3 emergency contacts allowed!')),
        );
        return;
      }

      if (emergencyContacts.isNotEmpty) {
        final lastContact = emergencyContacts.last.trim();

        if (lastContact.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: MText('Please enter a contact before adding a new one.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        if (!emailRegex.hasMatch(lastContact)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: MText(
                'Only Gmail, Outlook, or Hotmail emails are allowed.',
              ),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
      }

      setState(() {
        emergencyContacts.add("");
      });
    }


    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),

             //Profile Page Text
              profile_page_text,

              //Username page text
              username_page_text,

              SizedBox(height: screenHeight * 0.015),

              NameTile(
                controller: _usernameController,
                onNameChanged: (newName) => updateName(newName),
              ),

              SizedBox(height: screenHeight * 0.015),

              //email page text
              email_page_text,



              SizedBox(height: screenHeight * 0.015),

              NameTile(
                controller: _emailController,
                onNameChanged: (newEmail) => updateEmail(newEmail),
              ),

              SizedBox(height: screenHeight * 0.025),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //EmergencyContacts page text
                  emergency_contacts_page_text,

                  BouncyIconButton(
                    icon: const RoundedIconSVG(
                      iconPath: "assets/profile_page/add.svg", iconColor:Colors.black, containerColor:Colors.white, size: 25,
                    ),
                    onPressed: addTile,
                  ),
                ],
              ),

              Container(
                height: screenHeight * 0.30,
                child:
                    emergencyContacts.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              //animation
                              noContactsAnimation,
                              //Page Text
                              no_emergency_contacts_added_yet_page_text,
                            ],
                          ),
                        )
                        : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: emergencyContacts.length,
                          itemBuilder: (_, index) {
                            return EditableTile(
                              initialText: emergencyContacts[index],
                              onTextChanged:
                                  (newText) => updateTile(index, newText),
                              onDelete: () => deleteTile(index),
                            );
                          },
                        ),
              ),

              SizedBox(height: screenHeight * 0.025),

              Center(
                child: ThumpingButton(
                  backgroundColor: Colors.white,
                  text: "Save",
                  onPressed: () => saveToPreferences(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget MText(String text){
  return Center(
    child: Text(text,style: GoogleFonts.outfit(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),),
  );
}
