import 'package:provider/provider.dart';

import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'database_helper.dart';
import 'char_database.dart';
import 'class_root.dart';
import 'poke_database.dart';

class NumericalWidget extends StatelessWidget{
  const NumericalWidget({Key? key, this.state}): super(key: key);
  final NumericalState? state;

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: Builder(builder: (BuildContext context){
        final myAppState = Provider.of<MyAppState>(context);
        var effortVal = state!.effort.toString();
        var actualVal = state!.actual.toString();
        var currentSliderVal = state!.slider;
        int natPos = state!.natPos;
        String classification = myAppState.selectedSkill.classification;
        return Row(
          children: [
            Column(
              children: [
                const Text(
                  '実数値',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
                Text(actualVal),
              ],
            ),
            const SizedBox(width: 10,),
            Column(
              children: [
                const Text(
                  '努力値',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
                Text(effortVal.toString()),
              ],
            ),
            const SizedBox(width: 10,),
            ElevatedButton(
              onPressed: (){
                currentSliderVal = 0.toDouble();
                if(state!.widgetType == 'a'){
                  myAppState.atActualCalc(classification, 0, natPos);
                }else if(state!.widgetType == 'h'){
                  myAppState.hActualCalc(currentSliderVal);
                }else if(state!.widgetType == 'b'){
                  myAppState.bActualCalc(currentSliderVal, natPos);
                }else if(state!.widgetType == 'd'){
                  myAppState.dActualCalc(currentSliderVal, natPos);
                }
              },
              child: const Text('0'),
            ),
            const SizedBox(width: 5,),
            ElevatedButton(
              onPressed: (){
                currentSliderVal = 32.toDouble();
                if(state!.widgetType == 'a'){
                  myAppState.atActualCalc(classification, 32, natPos);
                }else if(state!.widgetType == 'h'){
                  myAppState.hActualCalc(currentSliderVal);
                }else if(state!.widgetType == 'b'){
                  myAppState.bActualCalc(currentSliderVal, natPos);
                }else if(state!.widgetType == 'd'){
                  myAppState.dActualCalc(currentSliderVal, natPos);
                }
              },
              child: const Text('252'),
            ),
          ],
        );
      }),
    );
  }
}

class DamageCalcWidget extends StatelessWidget {
  const DamageCalcWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    double _currentSliderVal = 0;
    int cTribe = context.watch<MyAppState>().atPoke.cTribe;
    int atState = myAppState.atPoke.aTribe;
    int effortVal = 0;
    String natVal = natList[1];
    var changeCircle = const IconData(0xef3f, fontFamily: 'MaterialIcons');

    var skillList = myAppState.skillList;
    var myState = context.watch<MyAppState>();
    var atWidgetState = AtState(myAppState.atPoke, myAppState.teraImage, myAppState.atSliderVal, myAppState.atNatPos, myAppState.atRankPos, myAppState.selectedSkill, myAppState.teraIcon);
    skillList = myState.skillList;
    var classification = myState.physOrSpe;
    if(classification == "特殊"){
      atState = cTribe;
    }
    myState.atActualCalc(classification, myState.atSliderVal, myState.atNatPos);

    if(_currentSliderVal == 0){
      effortVal = 0;
    }else{
      effortVal = (_currentSliderVal*8-4).toInt();
    }

    double doubleActualVal = ((atState*2+31+effortVal/4)*0.5+5);
    if(natVal == natList[0].toString()){
      doubleActualVal = (doubleActualVal*1.1);
    }else if(natVal == natList[2].toString()){
      doubleActualVal = (doubleActualVal*0.9);
    }
    if(myState.firstFlag){
      myState.skillChanged(myState.selectedSkill);
    }
    myState.damageCalc();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 0,
        ),
        body: Column(
          children: [
            Flexible(
              child: Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          color: const Color(0xfff5f5f5),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                AttackerWidget(atState: atWidgetState),
                                const SizedBox(height: 5,),
                                IconButton(
                                  icon: Container(
                                    color: Colors.white,
                                    child: Icon(
                                      changeCircle,
                                      size: 50,
                                    ),
                                  ),
                                  tooltip: '攻守反転',
                                  onPressed: () async{
                                    myState.damageList = [];
                                    myState.widgetList = [];
                                    savedDamageList = [];
                                    damageWidgetList = [];
                                    minMaxSumList = [];
                                    reCalcList = [];
                                    skillList = await DatabaseHelper.customSkillList(dfPokeMap.skill1, dfPokeMap.skill2, dfPokeMap.skill3, dfPokeMap.skill4, dfPokeMap.skill5) as List<Skill>;
                                    spareAttackState = AttackState(poke: myAppState.atPoke, teraImage: myState.teraImage, atSlider: myState.atSliderVal, atEffort: myState.atEffort, atNatPos: myState.atNatPos, atRankPos: myState.atRankPos, atSpCh: myState.atSpChString, atSp: myState.atSpCh, atEffect: myState.atEffect, skill: myState.selectedSkill, teraIcon: myState.teraIcon, teraType: myState.atTeraType, stellaFlag: myState.stellaFlag, stellaEffective: myState.stellaEffectiveFlag);
                                    spareDefenceState = DefenceState(dfPoke: dfPokeMap, hSliderVal: myState.hSliderVal, hEffort: myState.hEffort, bSliderVal: myState.bSliderVal, bEffort: myState.bEffort, bNatPos: myState.bNatPos, dSliderVal: myState.dSliderVal, dEffort: myState.dEffort, dNatPos: myState.dNatPos, bRankPos: myState.bRankPos, dRankPos: myState.dRankPos, dfSpCh: myState.dfSpChString, dfSp: myState.dfSpCh, dfTeraType: myState.dfTeraType, dfTeraImage: myState.dfTeraImage, dfEffect: myState.dfEffect);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => MyApp(atState: AttackState(poke: dfPokeMap, teraImage: Image.asset('images/not_selected.png'), atSlider: 0, atEffort: 0, atNatPos: 1, atRankPos: 6, atSpCh: dfPokeMap.char1, atSp: false, atEffect: '', skill: skillList.first, teraIcon: Image.asset('images/bef_teras.png'), teraType: 'null', stellaFlag: false, stellaEffective: false), dfState: DefenceState(dfPoke: myAppState.atPoke, hSliderVal: 0, hEffort: 0, bSliderVal: 0, bEffort: 0, bNatPos: 1, dSliderVal: 0, dEffort: 0, dNatPos: 1, bRankPos: 6, dRankPos: 6, dfSpCh: myAppState.atPoke.char1, dfSp: false, dfTeraType: 'null', dfTeraImage: Image.asset('images/not_selected.png'), dfEffect: ''), skills: skillList),
                                          settings: RouteSettings(
                                              arguments: DfState(dfPokeMap, myState.hSliderVal, myState.bSliderVal, myState.dSliderVal, myState.bNatPos, myState.dNatPos)
                                          )
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 5,),
                                DefenceWidget(),
                                const SizedBox(height: 20,),
                                EnviContainer(),
                                DamageListWidget(damageList: myState.widgetList)
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const SizedBox(
            height: 90,
            child: DamageContainer()
        ),
      ),
    );
  }
}



