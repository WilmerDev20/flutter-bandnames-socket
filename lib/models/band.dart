

import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Band {

  String id;
  String  name;
  int votes; 

  Band({
    required this.id,
    required this.name,
    required this.votes
  });

  factory Band.fromJson(Map<String , dynamic> obj) => Band(
    id: obj['id'], 
    name: obj['name'], 
    votes: obj['votes']
  );
  




}