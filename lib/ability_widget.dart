import 'package:provider/provider.dart';

import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'database_helper.dart';
import 'char_database.dart';
import 'class_root.dart';
import 'poke_database.dart';

class AbilityCard extends StatelessWidget {
  const AbilityCard({
    super.key,
    required this.abilities,
  });

  final Ability abilities;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(abilities.ability),
      ),
    );
  }
}

List<Ability> abilityCheck(List<Ability> charList, List<Ability> initialList){
  List<String> initialAbility = [];
  for(int i= 0; i < initialList.length; i++){
    initialAbility.add(initialList[i].ability);
  }
  for(int i = 0; i< charList.length; i++){
    if(!initialAbility.contains(charList[i].ability)){
      initialList.add(charList[i]);
    }
  }
  return initialList;
}