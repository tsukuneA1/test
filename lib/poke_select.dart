import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/database_helper.dart';
import 'main.dart';
import 'poke_database.dart';
import 'class_root.dart';


List<Poke> pokeInfo = [];
Poke another = pokeInfo[0];
DefenceState sendDefence = defenceState;

class PokeListState extends ChangeNotifier{
  var pokeInfo = pokeInitList;
  var retInfo = pokeInitList;
  var currentInput = '';

  void inputChanged(String text){
    currentInput = text;
    if(text == ''){
      retInfo = pokeInitList;
    }
    retInfo = pokeInfo.where((Poke option){
      return option.pokeName.contains(text) | option.anotherName.contains(text);
    }).toList();
    notifyListeners();
  }
}

class PokeSelect extends StatefulWidget{
  final DefenceState dfState;
  const PokeSelect({
    super.key, required this.dfState
  });

  @override
  State<PokeSelect> createState() => _PokeSelectState();
}

class _PokeSelectState extends State<PokeSelect> {
  var text = '';
  var pokeList = List<Poke>;

  @override
  Widget build(BuildContext context) {
    sendDefence = widget.dfState;
    return ChangeNotifierProvider(
      create: (context) => PokeListState(),
      child: MaterialApp(
        title: 'ポケモンを選択してください',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const MySelectHome(),
      ),
    );
  }
}

class MySelectHome extends StatefulWidget{
  const MySelectHome({super.key});

  @override
  State<MySelectHome> createState() => _MySelectState();
}

class _MySelectState extends State<MySelectHome>{
  @override
  Widget build(BuildContext context){
    Widget page;
    page = const PokeSelectPage();
    return LayoutBuilder(
        builder: (context, constraints){
          return Scaffold(
            body: Center(
              child: page,
            ),
          );
        }
    );
  }
}

class PokeSelectPage extends StatefulWidget{
  const PokeSelectPage({super.key});

  @override
  State<PokeSelectPage> createState() => _PokeSelectPageState();
}

class _PokeSelectPageState extends State<PokeSelectPage> {
  @override
  Widget build(BuildContext context){
    var pokeInputState = context.watch<PokeListState>();
    var pokeList = pokeInputState.retInfo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeCalculation'),
        backgroundColor: Colors.black,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          //const SizedBox(height: 40,),
          const Material(
              child: PokeInput()
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position){
                return Card(
                  child: Row(
                    children: [
                      InkWell(
                        child: SizedBox(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                  height: 50,
                                  child: Image.asset(pokeList[position].imagePath)),
                              Text(pokeList[position].pokeName)
                            ]
                          )
                        ),
                        onTap: () async{
                          skillList = await DatabaseHelper.customSkillList(pokeList[position].skill1, pokeList[position].skill2, pokeList[position].skill3, pokeList[position].skill4, pokeList[position].skill5) as List<Skill>;

                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => MyApp(atState: AttackState(poke: pokeList[position], teraImage: Image.asset('images/not_selected.png'), atSlider: 0, atEffort: 0, atNatPos: 1, atRankPos: 6, atSpCh: pokeList[position].char1, atSp: false, atEffect: '', skill: skillList[0], teraIcon: Image.asset('images/bef_teras.png'), teraType: 'null', stellaFlag: false, stellaEffective: false), dfState: sendDefence, skills: skillList),
                          ));
                        },
                      )
                    ],
                  ),
                );
              },
              itemCount: pokeList.length,
            ),
          ),
        ],
      ),
    );
  }
}

class PokeInput extends StatefulWidget{
  const PokeInput({super.key});

  @override
  State<PokeInput> createState() => _PokeInputState();
}

class _PokeInputState extends State<PokeInput> {
  var text = '';
  var pokeList = List<Poke>;
  @override
  Widget build(BuildContext context) {
    var pokeState = context.watch<PokeListState>();
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ポケモン名'
            ),
            onChanged: (value) {
              setState(() {
                text = value;
                pokeState.inputChanged(text);
              });
            },
          ),
        ),
      ],
    );
  }
}

Future<List<Skill>> customSkillRet(Poke poke) async{
  var skillList = await DatabaseHelper.customSkillList(poke.skill1, poke.skill2, poke.skill3, poke.skill4, poke.skill5) as List<Skill>;
  return skillList;
}