import 'package:flutter/material.dart';

//----------------PROFILE PAGE-------------------------//
final profile_page_text =  Text(
  "Profile ",
  overflow: TextOverflow.visible,
  maxLines: null,
  style: TextStyle(
      color: Colors.white,
      fontSize: 70,
      fontWeight: FontWeight.bold,
      fontFamily: 'Outfit'
  ),
);

final username_page_text = Text(
  "User name:",
  softWrap: true,
  overflow: TextOverflow.visible,
  maxLines: null,
  style: TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontFamily: 'Outfit'
  ),
);

final email_page_text = Text(
  "User email",
  softWrap: true,
  overflow: TextOverflow.visible,
  maxLines: null,
  style: TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontFamily: 'Outfit'
  ),
);

final emergency_contacts_page_text = Text(
  "Emergency Contacts :",
  softWrap: true,
  overflow: TextOverflow.visible,
  maxLines: null,
  style: TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontFamily: 'Outfit'
  ),
);

final no_emergency_contacts_added_yet_page_text = Text(
  "No emergency contacts yet!",
  style: TextStyle(
      color: Colors.white60,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      fontFamily: 'Outfit'
  ),
);