import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/database_helper.dart';
import 'main.dart';
import 'poke_database.dart';
import 'class_root.dart';

List<Poke> pokeInfo = [];
Poke another = pokeInfo[0];
AttackState sendAttack = attackState;

class DfPokeListState extends ChangeNotifier{
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

class DfPokeSelect extends StatefulWidget{
  final AttackState atState;
  const DfPokeSelect({
    super.key, required this.atState
  });

  @override
  State<DfPokeSelect> createState() => _DfPokeSelectState();
}

class _DfPokeSelectState extends State<DfPokeSelect> {
  var text = '';
  var pokeList = List<Poke>;

  @override
  Widget build(BuildContext context) {
    sendAttack = widget.atState;
    return ChangeNotifierProvider(
      create: (context) => DfPokeListState(),
      child: MaterialApp(
        title: 'ポケモンを選択してください',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const DfPokeSelectPage(),
      )
    );
  }
}

class MyDfSelectHome extends StatefulWidget{
  const MyDfSelectHome({super.key});

  @override
  State<MyDfSelectHome> createState() => _MyDfSelectState();
}

class _MyDfSelectState extends State<MyDfSelectHome>{
  @override
  Widget build(BuildContext context){
    Widget page;
    page = const DfPokeSelectPage();
    return LayoutBuilder(builder: (context, constraints){
      return Scaffold(
        body: Center(
          child: page,
        ),
      );
    }
    );
  }
}

class DfPokeSelectPage extends StatefulWidget{
  const DfPokeSelectPage({super.key});

  @override
  State<DfPokeSelectPage> createState() => _DfPokeSelectPageState();
}

class _DfPokeSelectPageState extends State<DfPokeSelectPage> {
  @override
  Widget build(BuildContext context){
    var pokeInputState = context.watch<DfPokeListState>();
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
                                      child: Image.asset(pokeList[position].imagePath)
                                  ),
                                  Text(pokeList[position].pokeName)
                                ]
                            )
                        ),
                        onTap: () async{
                          savedDamageList = [];
                          damageWidgetList = [];
                          reCalcList = [];
                          minMaxSumList = [];
                          skillList = await DatabaseHelper.customSkillList(sendAttack.poke.skill1, sendAttack.poke.skill2, sendAttack.poke.skill3, sendAttack.poke.skill4, sendAttack.poke.skill5) as List<Skill>;
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MyApp(atState: sendAttack, dfState: DefenceState(dfPoke: pokeList[position], hSliderVal: 0, hEffort: 0, bSliderVal: 0, bEffort: 0, bNatPos: 1, dSliderVal: 0, dEffort: 0, dNatPos: 1, bRankPos: 6, dRankPos: 6, dfSpCh: pokeList[position].char1, dfSp: false, dfTeraType: 'null', dfTeraImage: Image.asset('images/not_selected.png'), dfEffect: ''), skills: skillList),
                                settings: RouteSettings(
                                    arguments: sendAttack
                                ),
                              )
                          );
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
    var pokeState = context.watch<DfPokeListState>();
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