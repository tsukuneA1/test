import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'poke_database.dart';
import 'poke_select.dart';
import 'function.dart';
import 'df_poke_select.dart';
import 'char_database.dart';
import 'class_root.dart';
import 'ability_widget.dart';

const List<String> natList = <String>['×1.1', '×1.0', '×0.9'];
const List<String> rankList = <String>['+6', '+5', '+4', '+3', '+2', '+1', '+-0', '-1', '-2', '-3', '-4', '-5', '-6'];
const List<String> atEffectList = <String>['持ち物なし', '命の珠', 'こだわりハチマキ', 'こだわりメガネ', 'パンチグローブ', 'タイプ強化系', 'たつじんのおび', 'ちからのハチマキ', 'ものしりメガネ', 'でんきだま', 'ばんのうがさ'];
const List<String> dfEffectList = <String>['持ち物なし', 'しんかのきせき', 'とつげきチョッキ', '半減きのみ'];
const SerialSkill serialOneToFive = SerialSkill(<int>[1,2,3,4,5], 4, <String>['スイープビンタ', 'スケイルショット', 'タネマシンガン', 'つっぱり', 'ボーンラッシュ', 'ミサイルばり', 'みずしゅりけん', 'みだれづき', 'みだれひっかき', 'ロックブラスト', 'つららばり']);
const SerialSkill serialOneToTwo = SerialSkill(<int>[1,2], 1, <String>['タキオンカッター', 'ダブルアッタク', 'ダブルウイング', 'ツインビーム', 'ドラゴンアロー', 'にどげり']);
const SerialSkill nezumi = SerialSkill(<int>[1,2,3,4,5,6,7,8,9,10], 9, <String>['ネズミざん']);
const SerialSkill serialOneToThree = SerialSkill(<int>[1,2,3], 2, <String>['すいりゅうれんだ', 'トリプルダイブ', 'トリプルアクセル', 'トリプルキック']);
const List<String> serialSkills = <String>['スイープビンタ', 'スケイルショット', 'タネマシンガン', 'つっぱり', 'ボーンラッシュ', 'ミサイルばり', 'みずしゅりけん', 'みだれづき', 'みだれひっかき', 'ロックブラスト', 'つららばり', 'タキオンカッター', 'ダブルアッタク', 'ダブルウイング', 'ツインビーム', 'ドラゴンアロー', 'にどげり', 'すいりゅうれんだ', 'トリプルダイブ', 'トリプルアクセル', 'トリプルキック', 'ネズミざん'];
var damageListPos = 0;

late String path;
late Database database;
List<Skill> listMap = skillList;
List<Poke> pokeInfo = [];
Poke pokeMap = pokeInfo[0];
Poke dfPokeMap = pokeInfo[1];
List<SavedDamage> savedDamageList = [];
List<SavedDamageWidget> damageWidgetList = [];
List<ReCalc> reCalcList = [];
List<MinMaxSum> minMaxSumList = [];
AttackState attackState = AttackState(poke: pokeInfo[0], teraImage: Image.asset('images/not_selected.png'), atSlider: 0, atEffort: 0, atNatPos: 1, atRankPos: 6, atSpCh: pokeInfo[0].char1, atSp: false, atEffect: '', skill: skillList[0], teraIcon: Image.asset('images/bef_teras.png'), teraType: 'null', stellaFlag: false, stellaEffective: false);
DefenceState defenceState = DefenceState(dfPoke: pokeInfo[1], hSliderVal: 0, hEffort: 0, bSliderVal: 0, bEffort: 0, bNatPos: 1, dSliderVal: 0, dEffort: 0, dNatPos: 1, bRankPos: 6, dRankPos: 6, dfSpCh: pokeInfo[1].char1, dfSp: false, dfTeraType: 'null', dfTeraImage: Image.asset('images/not_selected.png'), dfEffect: '');
AttackState spareAttackState = attackState;
DefenceState spareDefenceState = defenceState;
List<AttackState> spareAtList = [];
List<DefenceState> spareDfList = [];

final List<Type> typeList = [
  Type(type: 'ノーマル', typeImage: Image.asset('images/nomaru_tag.png'), typeIcon: Image.asset('images/noma_tera.png')),
  Type(type: 'ほのお', typeImage: Image.asset('images/hono_tag.png'), typeIcon: Image.asset('images/hono_tera.png')),
  Type(type: 'みず', typeImage: Image.asset('images/mizu_tag.png'), typeIcon: Image.asset('images/mizu_tera.png')),
  Type(type: 'でんき', typeImage: Image.asset('images/denki_tag.png'), typeIcon: Image.asset('images/denki_tera.png')),
  Type(type: 'くさ', typeImage: Image.asset('images/kusa_tag.png'), typeIcon: Image.asset('images/kusa_tera.png')),
  Type(type: 'こおり', typeImage: Image.asset('images/kori_tag.png'), typeIcon: Image.asset('images/kori_tera.png')),
  Type(type: 'かくとう', typeImage: Image.asset('images/kakuto_tag.png'), typeIcon: Image.asset('images/kakuto_tera.png')),
  Type(type: 'どく', typeImage: Image.asset('images/doku_tag.png'), typeIcon: Image.asset('images/doku_tera.png')),
  Type(type: 'じめん', typeImage: Image.asset('images/jimen_tag.png'), typeIcon: Image.asset('images/jimen_tera.png')),
  Type(type: 'いわ', typeImage: Image.asset('images/iwa_tag.png'), typeIcon: Image.asset('images/iwa_tera.png')),
  Type(type: 'ゴースト', typeImage: Image.asset('images/gosuto_tag.png'), typeIcon: Image.asset('images/gosuto_tera.png')),
  Type(type: 'あく', typeImage: Image.asset('images/aku_tag.png'), typeIcon: Image.asset('images/aku_tera.png')),
  Type(type: 'ひこう', typeImage: Image.asset('images/hiko_tag.png'), typeIcon: Image.asset('images/hiko_tera.png')),
  Type(type: 'むし', typeImage: Image.asset('images/mushi_tag.png'), typeIcon: Image.asset('images/mushi_tera.png')),
  Type(type: 'エスパー', typeImage: Image.asset('images/esupa_tag.png'), typeIcon: Image.asset('images/esupa_tera.png')),
  Type(type: 'ドラゴン', typeImage: Image.asset('images/doragon_tag.png'), typeIcon: Image.asset('images/doragon_tera.png')),
  Type(type: 'はがね', typeImage: Image.asset('images/hagane_tag.png'), typeIcon: Image.asset('images/hagane_tera.png')),
  Type(type: 'フェアリー', typeImage: Image.asset('images/feari_tag.png'), typeIcon: Image.asset('images/feari_tera.png')),
  Type(type: 'ステラ', typeImage: Image.asset('images/stella_tag.png'), typeIcon: Image.asset('images/stcheck.png')),
  Type(type: '非テラスタル', typeImage: Image.asset('images/not_selected.png'), typeIcon: Image.asset('images/bef_teras.png'))
];

void main() async{
  pokeInfo = await PokeDbHelper.pokeInfo() as List<Poke>;
  var pokeMap = pokeInfo[0];
  listMap = await DatabaseHelper.customSkillList(pokeMap.skill1, pokeMap.skill2, pokeMap.skill3, pokeMap.skill4, pokeMap.skill5) as List<Skill>;
  charList = await CharDbHelper.charDatabase() as List<Ability>;
  runApp(
    MyApp(atState: attackState, dfState: defenceState, skills: skillList,),
  );
}

class MyApp extends StatefulWidget {
  MyApp(
      {super.key, required this.atState, required this.dfState, required this.skills}
      );
  AttackState atState;
  DefenceState dfState;
  List<Skill> skills;

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    attackState = widget.atState;
    pokeMap = attackState.poke;
    defenceState = widget.dfState;
    dfPokeMap = widget.dfState.dfPoke;
    listMap = widget.skills;

    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),//Androidの遷移もIOS風に指定している
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }
          )
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            toolbarHeight: 0,

          ),
          body: const MyHomePage(),
          bottomNavigationBar: const SizedBox(
              height: 90,
              child: DamageContainer()
          ),
        )
      ),
    );
  }
}

class MyAppState extends ChangeNotifier{
  var atEffort = attackState.atEffort;
  var atNatPos = attackState.atNatPos;
  var atSliderVal = attackState.atSlider;
  var atRankPos = attackState.atRankPos;
  var atSpCh = attackState.atSp;
  var atSpChString = attackState.atSpCh;
  var atEffect = attackState.atEffect;
  var hEffort = defenceState.hEffort;
  var hSliderVal = defenceState.hSliderVal;
  var bEffort = defenceState.bEffort;
  var bSliderVal = defenceState.bSliderVal;
  var bNatPos = defenceState.bNatPos;
  var bRankPos = defenceState.bRankPos;
  var dEffort = defenceState.dEffort;
  var dSliderVal = defenceState.dSliderVal;
  var dNatPos = defenceState.dNatPos;
  var dRankPos = defenceState.dRankPos;
  var dfSpCh = defenceState.dfSp;
  var dfEffect = defenceState.dfEffect;
  var dfSpChString = defenceState.dfSpCh;
  var hTribe = dfPokeMap.hTribe;
  var aTribe = attackState.poke.aTribe;
  var bTribe = dfPokeMap.bTribe;
  var cTribe = attackState.poke.cTribe;
  var dTribe = dfPokeMap.dTribe;
  var skillList = listMap;
  var selectedSkill = attackState.skill;
  var physOrSpe = listMap.first.classification;
  var aActual = ((attackState.poke.aTribe*2+31)*0.5+5).toInt();
  var hActual = ((dfPokeMap.hTribe*2+31+defenceState.hEffort/4)*0.5+60).toInt();
  var bActual = actualCalc(dfPokeMap.bTribe, defenceState.bEffort, defenceState.bNatPos);
  var dActual = actualCalc(dfPokeMap.dTribe, defenceState.dEffort, defenceState.dNatPos);
  var teraIcon = attackState.teraIcon;
  var teraImage = attackState.teraImage;
  var atTeraType = attackState.teraType;
  var dfTeraType = defenceState.dfTeraType;
  var dfTeraImage = defenceState.dfTeraImage;
  var weatherItem = 'なし';
  var fieldItem = 'なし';
  var maxDamage = 0;
  var minDamage =0;
  var damageText = '0';
  var reflect = false;
  var light = false;
  var sixteen = 0;
  var ten = 0;
  var eight = 0;
  var six = 0;
  var four = 0;
  var two = 0;
  var constSum = 0;
  var critical = false;
  var attackTime = 1;
  var twoThirds = false;
  var second = false;
  var damageList = savedDamageList;
  var widgetList = damageWidgetList;
  var atContainerOffStage = false;
  var dfContainerOffStage = false;
  var envContainerOffStage = false;
  var damageListContainerOffStage = true;
  var minSum = 0;
  var maxSum = 0;
  var firstFlag = true;
  var stellaFlag = attackState.stellaFlag;
  var stellaImagePath = 'images/stella.png';
  var teraBlastFlag = true;
  var stellaBlastFlag = true;
  var teraPhysOrSpe = '特殊';
  var stellaEffectiveFlag = false;
  var atPoke = pokeMap;
  var dfPoke = dfPokeMap;

  void atActualCalc(String classification,double changeSliderVal, int changeNut){
    atSliderVal = changeSliderVal;
    if(changeSliderVal == 0.0){
      atEffort = 0;
    }else{
      atEffort = (changeSliderVal*8-4).toInt();
    }
    atNatPos = changeNut;
    int tribe = aTribe;
    if(classification == '特殊'){
      tribe = cTribe;
    }
    if(selectedSkill.name == 'ボディプレス'){
      tribe = atPoke.bTribe;
    }

    aActual = actualCalc(tribe, atEffort, atNatPos);
    AtState(atPoke, teraImage, atSliderVal, atNatPos, atRankPos, selectedSkill, teraIcon);
    damageCalc();
    notifyListeners();
  }

  void hActualCalc(double hSlider){
    hSliderVal = hSlider;
    if(hSliderVal == 0){
      hEffort = 0;
    }else{
      hEffort = (hSliderVal*8-4).toInt();
    }
    hActual = ((hTribe*2+31+hEffort/4)*0.5+60).toInt();
    DfState(dfPoke, hSlider, bSliderVal, dSliderVal, bNatPos, dNatPos);
    damageCalc();
    notifyListeners();
  }

  void bActualCalc(double bSlider, int bNat){
    bSliderVal = bSlider;
    if(bSliderVal == 0){
      bEffort = 0;
    }else{
      bEffort = (bSliderVal*8-4).toInt();
    }
    bNatPos = bNat;
    bActual = actualCalc(bTribe, bEffort, bNatPos);
    DfState(dfPoke, hSliderVal, bSliderVal, dSliderVal, bNatPos, dNatPos);
    notifyListeners();
    minMaxDecide(reCalcList, hActual, bActual, dActual);
    damageCalc();
  }

  void dActualCalc(double dSlider, int dNat){
    dSliderVal = dSlider;
    if(dSliderVal == 0){
      dEffort = 0;
    }else{
      dEffort = (dSliderVal*8-4).toInt();
    }
    dNatPos = dNat;
    dActual = actualCalc(dTribe, dEffort, dNatPos);
    DfState(dfPoke, hSliderVal, bSliderVal, dSliderVal, bNatPos, dNatPos);
    notifyListeners();
    minMaxDecide(reCalcList, hActual, bActual, dActual);
    damageCalc();
  }

  void dfActualCalc(double hSlider, double bSlider, int bNat, double dSlider, int dNat){
    hSliderVal = hSlider;
    if(hSliderVal == 0){
      hEffort = 0;
    }else{
      hEffort = (hSliderVal*8-4).toInt();
    }
    bSliderVal = bSlider;
    if(bSliderVal == 0){
      bEffort = 0;
    }else{
      bEffort = (bSliderVal*8-4).toInt();
    }
    dSliderVal = dSlider;
    if(dSliderVal == 0){
      dEffort = 0;
    }else{
      dEffort = (dSliderVal*8-4).toInt();
    }
    bNatPos = bNat;
    dNatPos = dNat;

    hActual = ((hTribe*2+31+hEffort/4)*0.5+60).toInt();
    bActual = actualCalc(bTribe, bEffort, bNatPos);
    dActual = actualCalc(dTribe, dEffort, dNatPos);
    DfState(dfPokeMap, hSlider, bSlider, dSlider, bNat, dNat);
    notifyListeners();
    minMaxDecide(reCalcList, hActual, bActual, dActual);
    damageCalc();
  }

  void atRankChanged(int aPos){
    atRankPos = aPos;
    damageCalc();
    notifyListeners();
  }

  void dfRankChanged(int bPos, int dPos){
    bRankPos = bPos;
    dRankPos = dPos;
    damageCalc();
    notifyListeners();
  }

  void attackTimeChanged(int i){
    attackTime = i;
    damageCalc();
    notifyListeners();
  }

  void skillChanged(Skill skill){
    selectedSkill = skill;
    if(skill.name == 'ツタこんぼう'){
      if(atPoke.pokeName == 'オーガポン(竈)'){
        selectedSkill = Skill(name: 'ツタこんぼう', power: 100, type: 'ほのお', anotherName: 'ツタこんぼう', classification: '物理');
        atEffect = 'お面';
      }
      if(atPoke.pokeName == 'オーガポン(井戸)'){
        selectedSkill = Skill(name: 'ツタこんぼう', power: 100, type: 'みず', anotherName: 'ツタこんぼう', classification: '物理');
        atEffect = 'お面';
      }
      if(atPoke.pokeName == 'オーガポン(礎)'){
        selectedSkill = Skill(name: 'ツタこんぼう', power: 100, type: 'いわ', anotherName: 'ツタこんぼう', classification: '物理');
        atEffect = 'お面';
      }
    }
    if(skill.name == 'テラバースト'){
      if(atTeraType != 'null' && atTeraType != 'ステラ'){
        var classification = teraPhysOrSpe;
        teraBlastFlag = false;
        stellaBlastFlag = true;
        atActualCalc(classification, atSliderVal, atNatPos);
        selectedSkill = Skill(name: 'テラバースト', power: 80, type: atTeraType, anotherName: 'てらばーすと', classification: classification);
      }else if(atTeraType == 'ステラ'){
        var classification = teraPhysOrSpe;
        stellaBlastFlag = false;
        teraBlastFlag = true;
        atActualCalc(classification, atSliderVal, atNatPos);
        selectedSkill = Skill(name: 'テラバースト', power: 100, type: 'ステラ', anotherName: 'てらばーすと', classification: classification);
      }
    }else if(skill.name == "テラクラスター"){
      if(atPoke.pokeName == "テラパゴス(ステラ)"){
        atTeraType == 'ステラ';
        stellaBlastFlag = false;
        teraBlastFlag = true;
        atActualCalc(teraPhysOrSpe, atSliderVal, atNatPos);
        selectedSkill = Skill(name: 'テラクラスター', power: 120, type: 'ステラ', anotherName: 'てらくらすたー', classification: '特殊');
      }
    }else{
      teraBlastFlag = true;
      stellaBlastFlag = true;
    }
    if(selectedSkill.classification == '物理'){
      physOrSpe = '物理';
    }else{
      physOrSpe = '特殊';
    }
    if(serialOneToTwo.serialSkillList.contains(skill.name)){attackTime = serialOneToTwo.defaultTime+1;}
    else if(serialOneToThree.serialSkillList.contains(skill.name)){attackTime = serialOneToThree.defaultTime+1;}
    else if(serialOneToFive.serialSkillList.contains(skill.name)){attackTime = serialOneToFive.defaultTime+1;}
    else{attackTime = 1;}

    if(skill.name == 'あんこくきょうだ' || skill.name == 'すいりゅうれんだ'){
      critical = true;
    }else{
      critical = false;
    }
    if(skill.name == 'はたきおとす'){
      twoThirds = true;
    }else{
      twoThirds = false;
    }
    if(skill.name == 'アクロバット' || skill.name == 'からげんき' || skill.name == 'しおみず' || skill.name == 'ベノムショック' || skill.name == 'クロスフレイム' || skill.name == 'クロスサンダー' || skill.name == 'かたきうち' || skill.name == 'たたりめ'){
      second = true;
    }else{
      second = false;
    }
    firstFlag = false;
    damageCalc();
    notifyListeners();
  }

  void extraChanged(bool twoThirdVal, bool secondVal){
    twoThirds = twoThirdVal;
    second = secondVal;
    notifyListeners();
  }

  void teraStateChanged(String type){
    if(type == 'null'){
      teraIcon = Image.asset('images/bef_teras.png');
      teraImage = typeList.where((Type option){
        return option.type == pokeMap.type1;
      }).first.typeImage;
      teraImage = typeList[19].typeImage;
      atTeraType = 'null';
      stellaFlag = false;
      stellaImagePath = 'images/stella.png';
      if(selectedSkill.name == 'テラバースト'){
        skillChanged(Skill(name: 'テラバースト', power: 80, type: 'ノーマル', anotherName: 'てらばーすと', classification: '特殊'));
        teraBlastFlag = true;
        stellaBlastFlag = true;
        stellaEffectiveFlag = false;
      }
    }else if(type == 'ステラ'){
      teraIcon = Image.asset('images/bef_teras.png');
      teraImage = Image.asset('images/stella_tag.png');
      atTeraType = 'ステラ';
      stellaFlag = true;
      var classification = '物理';
      if(cTribe > aTribe){
        classification = '特殊';
      }else{
        atActualCalc(classification, atSliderVal, atNatPos);
      }
      if(selectedSkill.name == 'テラバースト'){
        teraPhysOrSpe = classification;
        selectedSkill = Skill(name: 'テラバースト', power: 100, type: 'ステラ', anotherName: 'てらばーすと', classification: classification);
        skillChanged(selectedSkill);
        stellaBlastFlag = false;
      }else if(selectedSkill.name == 'テラクラスター'){
        selectedSkill = Skill(name: 'テラクラスター', power: 120, type: 'ステラ', anotherName: 'てらくらすたー', classification: '特殊');
        skillChanged(selectedSkill);
        stellaBlastFlag = false;
      }
      stellaImagePath = 'images/stcheck.png';
    }else{
      teraIcon = typeList.where((Type option){
        return option.type == type;
      }).first.typeIcon;
      teraImage = typeList.where((Type option){
        return option.type == type;
      }).first.typeImage;
      atTeraType = type;
      stellaFlag = false;
      stellaBlastFlag = true;
      stellaEffectiveFlag = false;
      stellaImagePath = 'images/stella.png';
      var classification = '物理';
      if(cTribe > aTribe){
        classification = '特殊';
      }else{
        atActualCalc(classification, atSliderVal, atNatPos);
      }
      if(selectedSkill.name == 'テラバースト'){
        teraPhysOrSpe = classification;
        selectedSkill = Skill(name: 'テラバースト', power: 80, type: atTeraType, anotherName: 'てらばーすと', classification: classification);
        skillChanged(selectedSkill);
        teraBlastFlag = false;
      }
    }
    damageCalc();
    notifyListeners();
  }

  void classificationChanged(Skill skill, String classification){
    teraPhysOrSpe = classification;
    skillChanged(Skill(name: skill.name, power: skill.power, type: skill.type, anotherName: skill.anotherName, classification: classification));
    atActualCalc(classification, atSliderVal, atNatPos);
    physOrSpe = classification;
    notifyListeners();
    damageCalc();
  }

  void dfTeraStateChanged(String type){
    if(type == 'null'){
      dfTeraImage = typeList.where((Type option){
        return option.type == dfPokeMap.type1;
      }).first.typeImage;
      dfTeraImage = typeList[19].typeImage;
      dfTeraType = 'null';
    }else{
      dfTeraImage = typeList.where((Type option){
        return option.type == type;
      }).first.typeImage;
      dfTeraType = type;
    }
    damageCalc();
    notifyListeners();
  }

  void atSpChChanged(String spChString, bool spCh){
    atSpCh = spCh;
    atSpChString = spChString;
    if(atSpChString == "ひひいろのこどう" && atSpCh){
      weatherItemChanged('はれ');
      notifyListeners();
    }
    if(atSpChString == "ハドロンエンジン" && spCh){
      fieldItemChanged('エレキフィールド');
      notifyListeners();
    }
    damageCalc();
    notifyListeners();
  }

  void dfSpChChanged(String spChString, bool spCh){
    dfSpCh = spCh;
    dfSpChString = spChString;
    damageCalc();
    notifyListeners();
  }

  void atEffectChanged(String effect){
    atEffect = effect;
    damageCalc();
    notifyListeners();
  }

  void dfEffectChanged(String effect){
    dfEffect = effect;
    damageCalc();
    notifyListeners();
  }

  void weatherItemChanged(String weather){
    weatherItem = weather;
    damageCalc();
    notifyListeners();
  }

  void fieldItemChanged(String field){
    fieldItem = field;
    damageCalc();
    notifyListeners();
  }

  void barrierChanged(bool reflectVal, bool lightVal){
    reflect = reflectVal;
    light = lightVal;
    damageCalc();
    notifyListeners();
  }

  void constDamageChanged(int sixteenth, int tenth, int eighth, int sixth, int fourth, int second){
    sixteen = sixteenth;
    ten = tenth;
    eight = eighth;
    six = sixth;
    four = fourth;
    two = second;
    constSum = (hActual/16).truncate()*sixteen+(hActual/10).truncate()*ten+(hActual/8).truncate()*eight+(hActual/6).truncate()*six+(hActual/4).truncate()*four+(hActual/2).truncate()*two;
    damageCalc();
    notifyListeners();
  }

  void damageCalc(){
    minMaxDecide(reCalcList, hActual, bActual, dActual);
    int atActual = aActual;
    int dfActual = bActual;
    int dfRankPos = bRankPos;
    if(selectedSkill.classification == '特殊'){
      atActual = actualCalc(cTribe, atEffort, atNatPos);
      dfActual = dActual;
      dfRankPos = dRankPos;
      if(selectedSkill.name == 'サイコショック' || selectedSkill.name == 'サイコブレイク'){
        dfActual = bActual;
        dfRankPos = bRankPos;
      }
    }
    if(selectedSkill.name == 'ボディプレス'){
      atActual = actualCalc(atPoke.bTribe, atEffort, atNatPos);
    }
    String atSp = atSpChString;
    String dfSp = dfSpChString;
    if(!atSpCh){atSp = 'null';}
    if(!dfSpCh){dfSp = 'null';}
    var type1 = dfPoke.type1;
    var type2 = dfPoke.type2;
    if(dfTeraType != 'null' && dfTeraType != 'ステラ'){
      type1 = dfTeraType;
      type2 = 'null';
    }

    int atAct = finalAtActualCalc(atPoke, dfPoke, atActual, atSp, dfSp, atEffect, selectedSkill, atRankPos);
    int dfAct = finalDfActualCalc(dfActual, atSp, dfSp, dfEffect, dfRankPos, selectedSkill, type1, type2, weatherItem);
    int finalSkillPower = finalSkillPowerCalc(atPoke, selectedSkill, atSp, atEffect, fieldItem);
    if(twoThirds){finalSkillPower = (finalSkillPower*1.5).truncate();}
    if(second){finalSkillPower = (finalSkillPower*2).truncate();}
    double typeMag1 = typeMagnification(selectedSkill, dfPoke.type1, atSp);
    double typeMag2 = typeMagnification(selectedSkill, 'null', atSp);
    if(dfPokeMap.type2 != 'null'){
      typeMag2 = typeMagnification(selectedSkill, dfPoke.type2, atSp);
    }
    double typeMag = typeMag1*typeMag2;
    if(dfTeraType != 'null' && dfTeraType != 'ステラ'){
      typeMag = typeMagnification(selectedSkill, dfTeraType, atSp);
    }else if(atTeraType == 'ステラ' && stellaEffectiveFlag){
      typeMag = 2.0;
    }
    double finalDamageMag = finalDamageMagnification(atPoke, dfPoke, selectedSkill, reflect, light, atSp, atEffect, dfSp, dfEffect, typeMag);

    var minSum = 0;
    var maxSum = 0;
    for(int i = 0; i < minMaxSumList.length; i++){
      minSum += minMaxSumList[i].min;
      maxSum += minMaxSumList[i].max;
    }

    List<int> minMax = damageCalculate(atPoke, dfPoke, atAct, dfAct, typeMag, atMagnification(selectedSkill.type, atPoke.type1, atPoke.type2, atTeraType), '', '', selectedSkill, finalSkillPower, atRankPos, critical, weatherItem);
    maxDamage = (minMax.last*finalDamageMag).round()*attackTime+constSum+maxSum;
    minDamage = (minMax.first*finalDamageMag).round()*attackTime+constSum+minSum;
    for(int i = 0; i < minMax.length; i++){
      minMax[i] = (minMax[i]*finalDamageMag).round()*attackTime+constSum+minSum;
    }
    var minStr = strCalc(minDamage, hActual);
    var maxStr = strCalc(maxDamage, hActual);
    var randText = damageStrCalc(minStr, maxStr, hActual, maxDamage, minMax);
    damageText = '${minDamage.toString()}~${maxDamage.toString()} $randText';

    notifyListeners();
  }

  void damageSave(double progress, double progressWidth, double secondaryProgressWidth){
    var atActual = aActual;
    if(selectedSkill.classification == '特殊'){
      atActual = actualCalc(cTribe, atEffort, atNatPos);
    }
    Image atTeraImage;
    if(atTeraType == 'null'){
      atTeraImage = typeList[19].typeImage;
    }else {
      atTeraImage = typeList.where((Type option) {
        return option.type == atTeraType;
      }).first.typeImage;
    }
    var minSum = 0;
    var maxSum = 0;
    for(int i = 0; i<minMaxSumList.length; i++){
      minSum += minMaxSumList[i].min;
      maxSum += minMaxSumList[i].max;
    }
    var atStatePath = AttackStatePath(poke: atPoke, teraImage: teraImage, atTera: atTeraType, atActual: atActual, atRankPos: atRankPos, skill: selectedSkill, atEffect: atEffect, atSpCh: atSpChString, atSp: atSpCh, twoThirds: twoThirds, second: second, critical: critical, attackTime: attackTime, stellaEffective: stellaEffectiveFlag);
    var dfStatePath = DefenceStatePath(dfPoke, bRankPos, dRankPos, dfSpChString, dfEffect, dfTeraType, dfSpCh);
    var envStatePath = CircumstanceStatePath(constSum, weatherItem, fieldItem, reflect, light);
    reCalcList.add(ReCalc(id: damageListPos, atPath: atStatePath, dfPath: dfStatePath, envPath: envStatePath));
    var damageBottomWidget = PokeDamageBottom(path: DamageWidgetPath(atStatePath, dfStatePath, envStatePath),pos: damageListPos, hActual: hActual, bActual: bActual, dActual: dActual,);
    minMaxSumList.add(MinMaxSum(id: damageListPos, min: minDamage-minSum, max: maxDamage-maxSum));
    damageList.add(SavedDamage(damageContainer: damageBottomWidget, atPokeDetail: PokeDetailTop(poke: atPoke, id: damageListPos, teraImage: atTeraImage,), skill: selectedSkill, dfPoke: dfPoke, id: damageListPos));
    widgetList.add(SavedDamageWidget(path: SavedDamage(damageContainer: damageBottomWidget, atPokeDetail: PokeDetailTop(poke: atPoke, id: damageListPos, teraImage: atTeraImage,), skill: selectedSkill, dfPoke: dfPoke, id: damageListPos), widgetPath: DamageWidgetPath(atStatePath, dfStatePath, envStatePath)));

    damageListPos += 1;
    notifyListeners();
  }

  void damageDelete(int pos){
    var i = 0;
    while(damageList[i].id != pos){
      i++;
    }
    damageList.removeAt(i);
    widgetList.removeAt(i);
    minMaxSumList.removeAt(i);
    reCalcList.removeAt(i);
    damageListPos--;
    notifyListeners();
  }

  void damageChanged(List<MinMaxSum> list){
    minMaxSumList = list;
    notifyListeners();
    damageCalc();
  }

  void backKeyPressed(){
    attackState = spareAtList.last;
    defenceState = spareDfList.last;
    pokeMap = attackState.poke;
    dfPokeMap = defenceState.dfPoke;
    atPoke = attackState.poke;
    dfPoke = defenceState.dfPoke;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Widget page;
    page = const DamageCalcPage();
    return LayoutBuilder(
        builder: (context, constraints) {
          var myAppState = context.watch<MyAppState>();
          return PopScope(
            canPop: true,
            onPopInvoked: (bool didPop) {
              if (didPop){
                attackState = spareAtList.last;
                defenceState = spareDfList.last;
                pokeMap = attackState.poke;
                dfPokeMap = defenceState.dfPoke;
                spareAtList.removeLast();
                spareDfList.removeLast();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => MyApp(atState: spareAtList.last, dfState: spareDfList.last, skills: listUpdate(spareAtList.last.poke)),
                  ),
                );
              }
            },
            child: page
          );
        }
    );
  }
}

class DamageCalcPage extends StatefulWidget{
  const DamageCalcPage({super.key});

  @override
  State<DamageCalcPage> createState() => _DamageCalcPageState();
}

class _DamageCalcPageState extends State<DamageCalcPage> {
  final pokeList = pokeInfo;
  final double _currentSliderVal = 0;
  int aTribe = pokeMap.aTribe;
  int cTribe = pokeMap.cTribe;
  int atState = pokeMap.aTribe;
  int effortVal = 0;
  String natVal = natList[1];
  String rankVal = rankList[6];
  List<String> spChList = <String>[pokeMap.char1, pokeMap.char2, pokeMap.char3];
  String effectVal = atEffectList[0];
  bool spChChecked = false;
  static const IconData change_circle_outlined = IconData(0xef3f, fontFamily: 'MaterialIcons');

  var skillList = listMap;

  @override
  Widget build(BuildContext context){
    var myState = context.watch<MyAppState>();
    skillList = myState.skillList;
    var classification = myState.physOrSpe;
    if(classification == "特殊"){
      atState = cTribe;
    }

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
    if(myState.atPoke.pokeName == "テラパゴス(ステラ)"){
      myState.stellaFlag = true;
      myState.teraBlastFlag = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        myState.teraStateChanged('ステラ');
      });
    }
    if(myState.firstFlag){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        myState.skillChanged(myState.selectedSkill);
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      myState.atActualCalc(classification, myState.atSliderVal, myState.atNatPos);
      myState.damageCalc();
    });

    return Column(
      children: [
        Flexible(
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
                          const AttackerWidget(),
                          const SizedBox(height: 5,),
                          buildIconButton(myState, context),
                          const SizedBox(height: 5,),
                          const DefenceWidget(),
                          const SizedBox(height: 20,),
                          const EnviContainer(),
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
      ],
    );
  }

  IconButton buildIconButton(MyAppState myState, BuildContext context) {
    return IconButton(
      icon: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(
          change_circle_outlined,
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
        spareAttackState = AttackState(poke: pokeMap, teraImage: myState.teraImage, atSlider: myState.atSliderVal, atEffort: myState.atEffort, atNatPos: myState.atNatPos, atRankPos: myState.atRankPos, atSpCh: myState.atSpChString, atSp: myState.atSpCh, atEffect: myState.atEffect, skill: myState.selectedSkill, teraIcon: myState.teraIcon, teraType: myState.atTeraType, stellaFlag: myState.stellaFlag, stellaEffective: myState.stellaEffectiveFlag);
        spareDefenceState = DefenceState(dfPoke: dfPokeMap, hSliderVal: myState.hSliderVal, hEffort: myState.hEffort, bSliderVal: myState.bSliderVal, bEffort: myState.bEffort, bNatPos: myState.bNatPos, dSliderVal: myState.dSliderVal, dEffort: myState.dEffort, dNatPos: myState.dNatPos, bRankPos: myState.bRankPos, dRankPos: myState.dRankPos, dfSpCh: myState.dfSpChString, dfSp: myState.dfSpCh, dfTeraType: myState.dfTeraType, dfTeraImage: myState.dfTeraImage, dfEffect: myState.dfEffect);
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => MyApp(atState: AttackState(poke: dfPokeMap, teraImage: Image.asset('images/not_selected.png'), atSlider: 0, atEffort: 0, atNatPos: 1, atRankPos: 6, atSpCh: dfPokeMap.char1, atSp: false, atEffect: '', skill: skillList.first, teraIcon: Image.asset('images/bef_teras.png'), teraType: 'null', stellaFlag: false, stellaEffective: false), dfState: DefenceState(dfPoke: pokeMap, hSliderVal: 0, hEffort: 0, bSliderVal: 0, bEffort: 0, bNatPos: 1, dSliderVal: 0, dEffort: 0, dNatPos: 1, bRankPos: 6, dRankPos: 6, dfSpCh: pokeMap.char1, dfSp: false, dfTeraType: 'null', dfTeraImage: Image.asset('images/not_selected.png'), dfEffect: ''), skills: skillList),
                settings: RouteSettings(
                    arguments: DfState(dfPokeMap, myState.hSliderVal, myState.bSliderVal, myState.dSliderVal, myState.bNatPos, myState.dNatPos)
                )
            ),
          );
        });
        },
    );
  }
}

class AttackerWidget extends StatefulWidget{
  const AttackerWidget({super.key});

  @override
  State<AttackerWidget> createState() => _AttackerWidgetState();
}

class _AttackerWidgetState extends State<AttackerWidget>  {
  final pokeList = pokeInfo;
  final double _currentSliderVal = 0;
  int bTribe = pokeMap.bTribe;
  int atState = pokeMap.aTribe;
  int effortVal = 0;
  String natVal = natList[1];
  String rankVal = rankList[6];
  String effectVal = atEffectList[0];
  bool spChChecked = false;
  Image befImage = Image.asset('images/bef_teras.png');
  List<String> serial = serialOneToFive.serialSkillList+serialOneToThree.serialSkillList+serialOneToTwo.serialSkillList+nezumi.serialSkillList;
  bool offStage = true;

  var skillList = listMap;
  static String _displaySkillStringForOption(Skill option) => option.name;
  final TextEditingController _textSkillEditingController = TextEditingController();
  @override
  Widget build(BuildContext context){
    var myState = context.watch<MyAppState>();
    var atWidgetState = AtState(myState.atPoke, myState.teraImage, myState.atSliderVal, myState.atNatPos, myState.atRankPos, myState.selectedSkill, myState.teraIcon);
    skillList = myState.skillList;
    var classification = myState.physOrSpe;
    if(classification == "特殊"){
      atState = myState.atPoke.cTribe;
    }else{
      atState = myState.atPoke.aTribe;
    }

    var skill = myState.selectedSkill;

    SerialSkill serialApply = nezumi;

    if(serial.contains(skill.name)){
      offStage = false;
      if(serialOneToTwo.serialSkillList.contains(skill.name)){
        serialApply = serialOneToTwo;
      }else if(serialOneToThree.serialSkillList.contains(skill.name)){
        serialApply = serialOneToThree;
      }else if(serialOneToFive.serialSkillList.contains(skill.name)){
        serialApply = serialOneToFive;
      }
    }else{
      offStage = true;
      myState.attackTime = 1;
    }

    Image teraIcon = myState.teraIcon;
    var teraType = myState.atTeraType;
    String physOrSpe = '特攻';
    if(myState.physOrSpe == '物理'){
      physOrSpe = '攻撃';
    }else{
      physOrSpe = '特攻';
    }

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

    var offsetIcon = const Icon(Icons.unfold_less);
    if(myState.atContainerOffStage){
      offsetIcon = const Icon(Icons.unfold_more);
    }
    var stellaFlag = myState.stellaFlag;
    var color = const Color(0xFF424242);
    if(stellaFlag){
      color = const Color(0xFFEC407A);
    }
    var stellaImagePath = myState.stellaImagePath;
    var stellaIcon = ImageIcon(
      AssetImage(stellaImagePath),
      size: 50,
      color: color,
    );

    var initialChar = <Ability>[];
    var another1 = charList.where((Ability option){return myState.atPoke.char1 == option.ability;}).first.another;
    initialChar.add(Ability(ability: myState.atPoke.char1, another: another1));
    if(myState.atPoke.char2 != ''){
      var another2 = charList.where((Ability option){return myState.atPoke.char2 == option.ability;}).first.another;
      initialChar.add(Ability(ability: myState.atPoke.char2, another: another2));
    }
    if(myState.atPoke.char3 != ''){
      var another3 = charList.where((Ability option){return myState.atPoke.char3 == option.ability;}).first.another;
      initialChar.add(Ability(ability: myState.atPoke.char3, another: another3));
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      myState.damageCalc();
    });

    return Column(
      children: [
        TopTabContainer(tabIcon: const Icon(Icons.edit_off), offsetIcon: offsetIcon, tabType: "Attacker"),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Colors.white,
            border: Border.all(
                color: const Color(0xffc7c7ff)
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Offstage(
                      offstage: myState.atContainerOffStage,
                      child: Column(
                        children: [
                          PokeDetailWidget(atState: DetailClassPath('at', myState.atPoke, atWidgetState.teraImage)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 10,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Text(
                                  physOrSpe,
                                  style: const TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                              ),
                              NumericalValWidget(state: NumericalState('a', myState.aActual, myState.atSliderVal, myState.atEffort, myState.atNatPos)),
                              EffortSeekBarWidget(state: NumericalState('a', myState.aActual, myState.atSliderVal, myState.atEffort, myState.atNatPos)),
                              NatRankWidget(natState: NatClassPath('a', myState.atNatPos, myState.atRankPos),),
                              SpEffectWidget(spEfState: SpEffectClassPath('at', myState.atPoke)),
                              const SizedBox(height: 5,),
                              const Text(
                                "攻撃技",
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                children: <Widget>[
                                  const SkillDialogWidget(),
                                  const SizedBox(width: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        if(teraType == 'null' || teraType == 'ステラ'){
                                          myState.teraStateChanged(skill.type);
                                        }else{
                                          myState.teraStateChanged('null');
                                        }
                                      });
                                    },
                                    child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: teraIcon
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      width: 50,
                                      height: 50,
                                      child: CircleAvatar(
                                          backgroundColor: const Color(0xFFE5E5E5),
                                          child: IconButton(
                                              onPressed: (){
                                                setState(() {
                                                  if(myState.stellaFlag){
                                                    myState.teraStateChanged('null');
                                                  }else{
                                                    myState.teraStateChanged('ステラ');
                                                  }
                                                });
                                              },
                                              icon: stellaIcon
                                          )
                                      )
                                  )
                                ],
                              ),
                              Offstage(
                                offstage: offStage,
                                child: AttackTime(path: serialApply),
                              ),
                              ExtraInfo(path: ExtraInfoPath(myState.selectedSkill)),
                              const SizedBox(height: 5,),
                              const TeraBlastWidget(),
                              const StellaBlastWidget()
                            ],
                          ),

                        ],
                      ),
                    ),
                    const Row(
                      children: [
                        Expanded(child: SizedBox())
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DefenceWidget extends StatefulWidget{
  const DefenceWidget({super.key});

  @override
  State<DefenceWidget> createState() => _DefenceWidgetState();
}

class _DefenceWidgetState extends State<DefenceWidget> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var teraTypeImage = myAppState.dfTeraImage;
    var offsetIcon = const Icon(Icons.unfold_less);
    if(myAppState.dfContainerOffStage){
      offsetIcon = const Icon(Icons.unfold_more);
    }
    return Column(
      children: [
        TopTabContainer(tabIcon: const Icon(Icons.verified_user), offsetIcon: offsetIcon, tabType: "Defender"),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)
            ),
            color: Colors.white,
            border: Border.all(
                color: const Color(0xffc7c7ff)
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Offstage(
                  offstage: myAppState.dfContainerOffStage,
                  child: Column(
                    children: [
                      PokeDetailWidget(atState: DetailClassPath('df', myAppState.dfPoke, teraTypeImage)),
                      const SizedBox(height: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              child: Text(
                                'HP',
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          NumericalValWidget(state: NumericalState('h', myAppState.hActual, myAppState.hSliderVal, myAppState.hEffort, 1)),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
                              ),
                              child: Column(
                                children: [
                                  EffortSeekBarWidget(state: NumericalState('h', myAppState.hActual, myAppState.hSliderVal, myAppState.hEffort, 1)),
                                  const SizedBox(height: 10,)
                                ],
                              ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              child: Text(
                                '防御',
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                            ),
                          ),
                          NumericalValWidget(state: NumericalState('b', myAppState.bActual, myAppState.bSliderVal, myAppState.bEffort, myAppState.bNatPos)),
                          EffortSeekBarWidget(state: NumericalState('b', myAppState.bActual, myAppState.bSliderVal, myAppState.bEffort, myAppState.bNatPos)),
                          NatRankWidget(natState: NatClassPath('b', myAppState.bNatPos, myAppState.bRankPos),),
                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              child: Text(
                                '特防',
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                            ),
                          ),
                          NumericalValWidget(state: NumericalState('d', myAppState.dActual, myAppState.dSliderVal, myAppState.dEffort, myAppState.dNatPos)),
                          EffortSeekBarWidget(state: NumericalState('d', myAppState.dActual, myAppState.dSliderVal, myAppState.dEffort, myAppState.dNatPos)),
                          NatRankWidget(natState: NatClassPath('d', myAppState.dNatPos, myAppState.dRankPos),),
                          const SizedBox(height: 5,),
                          SpEffectWidget(spEfState: SpEffectClassPath('df', myAppState.dfPoke)),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Row(
                children: [
                  Expanded(child: SizedBox())
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class PokeDetailWidget extends StatefulWidget{
  final DetailClassPath atState;
  const PokeDetailWidget({super.key, required this.atState});

  @override
  State<PokeDetailWidget> createState() => _PokeDetailWidgetState();
}

class _PokeDetailWidgetState extends State<PokeDetailWidget> {
  String teraRadio = 'teraRadio';
  @override
  Widget build(BuildContext context){
    var myState = context.watch<MyAppState>();
    var atState = widget.atState;
    if(atState.aOrD == 'at'){
      if(myState.atTeraType != 'null'){
        teraRadio = myState.atTeraType;
      }else{
        teraRadio = '非テラスタル';
      }
    }else{
      if(myState.dfTeraType != 'null'){
        teraRadio = myState.dfTeraType;
      }else{
        teraRadio = '非テラスタル';
      }
    }
    void teraChange(String? value){
      if(atState.aOrD == 'at'){
        teraRadio = value!;
        if(value == '非テラスタル'){
          myState.teraStateChanged('null');
        }else{
          myState.teraStateChanged(teraRadio);
        }
      }else{
        teraRadio = value!;
        if(value == '非テラスタル'){
          myState.dfTeraStateChanged('null');
        }else{
          myState.dfTeraStateChanged(teraRadio);
        }
      }
    }
    Image type1 = typeList.where((Type option){
      return option.type == atState.poke.type1;
    }).first.typeImage;
    var imageList = <Image>[type1];
    Image type2;
    if(atState.poke.type2 != ''){
      type2 = typeList.where((Type option){
        return option.type == atState.poke.type2;
      }).first.typeImage;
      imageList.add(type2);
    }

    String pokeTribe = '${atState.poke.hTribe}-${atState.poke.aTribe}-${atState.poke.bTribe}-${atState.poke.cTribe}-${atState.poke.dTribe}-${atState.poke.sTribe}';
    var teraImage = atState.teraImage;

    return Column(
      children: [
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12
                ),
                child: SizedBox(
                  width: 110,
                    height: 110,
                    child: Image.asset(atState.poke.imagePath)
                )
            ),
            buildContainer(context, atState, myState, pokeTribe, imageList, teraImage, teraChange)
          ],
        ),
      ],
    );
  }

  Container buildContainer(BuildContext context, DetailClassPath atState, MyAppState myState, String pokeTribe, List<Image> imageList, Image teraImage, void teraChange(String? value)) {
    return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
                  ),
                  child: InkWell(
                    onTap: (){
                      if(atState.aOrD == 'at'){
                        spareAttackState = AttackState(poke: pokeMap, teraImage: myState.teraImage, atSlider: myState.atSliderVal, atEffort: myState.atEffort, atNatPos: myState.atNatPos, atRankPos: myState.atRankPos, atSpCh: myState.atSpChString, atSp: myState.atSpCh, atEffect: myState.atEffect, skill: myState.selectedSkill, teraIcon: myState.teraIcon, teraType: myState.atTeraType, stellaFlag: myState.stellaFlag, stellaEffective: myState.stellaEffectiveFlag);
                        spareAtList.add(spareAttackState);
                        defenceState = DefenceState(dfPoke: dfPokeMap, hSliderVal: myState.hSliderVal, hEffort: myState.hEffort, bSliderVal: myState.bSliderVal, bEffort: myState.bEffort, bNatPos: myState.bNatPos, dSliderVal: myState.dSliderVal, dEffort: myState.dEffort, dNatPos: myState.dNatPos, bRankPos: myState.bRankPos, dRankPos: myState.dRankPos, dfSpCh: myState.dfSpChString, dfSp: myState.dfSpCh, dfTeraType: myState.dfTeraType, dfTeraImage: myState.dfTeraImage, dfEffect: myState.dfEffect);
                        spareDfList.add(defenceState);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const PokeSelect(),
                            settings: RouteSettings(
                                arguments: DefenceState(dfPoke: dfPokeMap, hSliderVal: myState.hSliderVal, hEffort: myState.hEffort, bSliderVal: myState.bSliderVal, bEffort: myState.bEffort, bNatPos: myState.bNatPos, dSliderVal: myState.dSliderVal, dEffort: myState.dEffort, dNatPos: myState.dNatPos, bRankPos: myState.bRankPos, dRankPos: myState.dRankPos, dfSpCh: myState.dfSpChString, dfSp: myState.dfSpCh, dfTeraType: myState.dfTeraType, dfTeraImage: myState.dfTeraImage, dfEffect: myState.dfEffect)
                            )
                        ));
                      }else if(atState.aOrD == 'df'){
                        spareDefenceState = DefenceState(dfPoke: dfPokeMap, hSliderVal: myState.hSliderVal, hEffort: myState.hEffort, bSliderVal: myState.bSliderVal, bEffort: myState.bEffort, bNatPos: myState.bNatPos, dSliderVal: myState.dSliderVal, dEffort: myState.dEffort, dNatPos: myState.dNatPos, bRankPos: myState.bRankPos, dRankPos: myState.dRankPos, dfSpCh: myState.dfSpChString, dfSp: myState.dfSpCh, dfTeraType: myState.dfTeraType, dfTeraImage: myState.dfTeraImage, dfEffect: myState.dfEffect);
                        spareDfList.add(spareDefenceState);
                        attackState =  AttackState(poke: pokeMap, teraImage: myState.teraImage, atSlider: myState.atSliderVal, atEffort: myState.atEffort, atNatPos: myState.atNatPos, atRankPos: myState.atRankPos, atSpCh: myState.atSpChString, atSp: myState.atSpCh, atEffect: myState.atEffect, skill: myState.selectedSkill, teraIcon: myState.teraIcon, teraType: myState.atTeraType, stellaFlag: myState.stellaFlag, stellaEffective: myState.stellaEffectiveFlag);
                        spareAtList.add(attackState);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const DfPokeSelect(),
                              settings: RouteSettings(
                                  arguments: AttackState(poke: pokeMap, teraImage: myState.teraImage, atSlider: myState.atSliderVal, atEffort: myState.atEffort, atNatPos: myState.atNatPos, atRankPos: myState.atRankPos, atSpCh: myState.atSpChString, atSp: myState.atSpCh, atEffect: myState.atEffect, skill: myState.selectedSkill, teraIcon: myState.teraIcon, teraType: myState.atTeraType, stellaFlag: myState.stellaFlag, stellaEffective: myState.stellaEffectiveFlag)
                              )
                          ),
                        );
                      }

                    },
                    child:Container(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 220,
                        child: Text(
                          atState.poke.pokeName,
                          style: const TextStyle(
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text('種族値:'),
                    Text(pokeTribe),
                  ],
                ),
                Row(
                  children: [
                    const Text('タイプ:'),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      height: 14,
                      child: Row(
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: imageList.length,
                            itemBuilder: (context, index){
                              return SizedBox(
                                child: Row(
                                  children: [
                                    imageList[index],
                                    const SizedBox(width: 5,),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('テラスタル:'),
                    const SizedBox(width: 5,),
                    SizedBox(
                      height: 14,
                      child: GestureDetector(
                        child: teraImage,
                          onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('テラスタイプ選択'),
                            content: Container(
                              width: 300,
                              height: 600,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  RadioListTile(value: typeList[0].type, groupValue: teraRadio, title: Text(typeList[0].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[1].type, groupValue: teraRadio, title: Text(typeList[1].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[2].type, groupValue: teraRadio, title: Text(typeList[2].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[3].type, groupValue: teraRadio, title: Text(typeList[3].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[4].type, groupValue: teraRadio, title: Text(typeList[4].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[5].type, groupValue: teraRadio, title: Text(typeList[5].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[6].type, groupValue: teraRadio, title: Text(typeList[6].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[7].type, groupValue: teraRadio, title: Text(typeList[7].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[8].type, groupValue: teraRadio, title: Text(typeList[8].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[9].type, groupValue: teraRadio, title: Text(typeList[9].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[10].type, groupValue: teraRadio, title: Text(typeList[10].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[11].type, groupValue: teraRadio, title: Text(typeList[11].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[12].type, groupValue: teraRadio, title: Text(typeList[12].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[13].type, groupValue: teraRadio, title: Text(typeList[13].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[14].type, groupValue: teraRadio, title: Text(typeList[14].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[15].type, groupValue: teraRadio, title: Text(typeList[15].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[16].type, groupValue: teraRadio, title: Text(typeList[16].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[17].type, groupValue: teraRadio, title: Text(typeList[17].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[18].type, groupValue: teraRadio, title: Text(typeList[18].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                  RadioListTile(value: typeList[19].type, groupValue: teraRadio, title: Text(typeList[19].type), onChanged: (value){setState(() {teraChange(value); Navigator.pop(context);});}),
                                ],
                              ),
                            ),
                          )
                          ),
                      )
                    )
                  ],
                )
              ],
            ),
    );
  }
}

class SkillWidget extends StatelessWidget {
  const SkillWidget({
    super.key,
    required this.skills,
  });

  final Skill skills;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(skills.name),
        subtitle: Text('${skills.type} ${skills.power} ${skills.classification}'),
      ),
    );
  }
}

class NumericalValWidget extends StatefulWidget{
  final NumericalState state;
  const NumericalValWidget({super.key, required this.state});

  @override
  State<NumericalValWidget> createState() => _NumericalValWidgetState();
}

class _NumericalValWidgetState extends State<NumericalValWidget> {
  double currentSliderVal = 0;
  String actualVal = '';
  String effortVal = '';
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    effortVal = widget.state.effort.toString();
    actualVal = widget.state.actual.toString();
    currentSliderVal = widget.state.slider;
    int natPos = widget.state.natPos;

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
            setState(() {
              currentSliderVal = 0.toDouble();
              if(widget.state.widgetType == 'a'){
                myAppState.atActualCalc(classification, 0, natPos);
              }else if(widget.state.widgetType == 'h'){
                myAppState.hActualCalc(currentSliderVal);
              }else if(widget.state.widgetType == 'b'){
                myAppState.bActualCalc(currentSliderVal, natPos);
              }else if(widget.state.widgetType == 'd'){
                myAppState.dActualCalc(currentSliderVal, natPos);
              }
            });
          },
          child: const Text('0'),
        ),
        const SizedBox(width: 5,),
        ElevatedButton(
          onPressed: (){
            setState(() {
              currentSliderVal = 32.toDouble();
              if(widget.state.widgetType == 'a'){
                myAppState.atActualCalc(classification, 32, natPos);
              }else if(widget.state.widgetType == 'h'){
                myAppState.hActualCalc(currentSliderVal);
              }else if(widget.state.widgetType == 'b'){
                myAppState.bActualCalc(currentSliderVal, natPos);
              }else if(widget.state.widgetType == 'd'){
                myAppState.dActualCalc(currentSliderVal, natPos);
              }
            });
          },
          child: const Text('252'),
        ),
      ],
    );
  }
}

class EffortSeekBarWidget extends StatefulWidget{
  final NumericalState state;
  const EffortSeekBarWidget({super.key, required this.state});

  @override
  State<EffortSeekBarWidget> createState() => _EffortSeekBarWidgetState();
}

class _EffortSeekBarWidgetState extends State<EffortSeekBarWidget> {
  double _currentSliderVal = 0.0;
  int effortVal = 0;
  int natPos = 1;

  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var state = widget.state;
    var natPos = state.natPos;
    _currentSliderVal = state.slider;
    var effortVal = state.effort;
    var classification= myAppState.selectedSkill.classification;
    return Container(
        child: Row(
          children: [
            Expanded(
              child: Slider(
                value: _currentSliderVal,
                max: 32,
                divisions: 32,
                label: effortVal.toString(),
                onChanged: (double value){
                  setState((){
                    _currentSliderVal = value;
                    if(state.widgetType == 'a'){
                      myAppState.atActualCalc(classification, _currentSliderVal, natPos);
                    }else if(state.widgetType == 'h'){
                      myAppState.hActualCalc(_currentSliderVal);
                    }else if(state.widgetType == 'b'){
                      myAppState.bActualCalc(_currentSliderVal, natPos);
                    }else if(state.widgetType == 'd'){
                      myAppState.dActualCalc(_currentSliderVal, natPos);
                    }
                  });
                },
              ),
            ),

            ElevatedButton(
                onPressed: (){
                  setState(() {
                    if(_currentSliderVal < 32){
                      _currentSliderVal++;
                      if(state.widgetType == 'a'){
                        myAppState.atActualCalc(classification, _currentSliderVal, natPos);
                      }else if(state.widgetType == 'h'){
                        myAppState.hActualCalc(_currentSliderVal);
                      }else if(state.widgetType == 'b'){
                        myAppState.bActualCalc(_currentSliderVal, natPos);
                      }else if(state.widgetType == 'd'){
                        myAppState.dActualCalc(_currentSliderVal, natPos);
                      }
                    }
                  });
                },
                child: const Text('+')
            ),
            const SizedBox(width: 5,),
            ElevatedButton(
                onPressed: (){
                  if(_currentSliderVal > 0){
                    setState(() {
                      _currentSliderVal--;
                      if(state.widgetType == 'a'){
                        myAppState.atActualCalc(classification, _currentSliderVal, natPos);
                      }else if(state.widgetType == 'h'){
                        myAppState.hActualCalc(_currentSliderVal);
                      }else if(state.widgetType == 'b'){
                        myAppState.bActualCalc(_currentSliderVal, natPos);
                      }else if(state.widgetType == 'd'){
                        myAppState.dActualCalc(_currentSliderVal, natPos);
                      }
                    });
                  }
                },
                child: const Text('-')
            ),
          ],
        )
    );
  }
}

class NatRankWidget extends StatefulWidget{
  final NatClassPath natState;
  const NatRankWidget({super.key, required this.natState});

  @override
  State<NatRankWidget> createState() => _NatRankWidgetState();
}

class _NatRankWidgetState extends State<NatRankWidget> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var natRankState = widget.natState;
    var atSliderVal = myAppState.atSliderVal;
    var classification= myAppState.selectedSkill.classification;
    var natVal = natList[natRankState.natPos];
    var rankPos = natRankState.rankPos;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '性格補正',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
              DropdownButton(
                value: natVal,
                items: natList.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width: 50,
                        child: Text(value)
                    ),
                  );
                }).toList(),
                onChanged: (String? value){
                  setState(() {
                    natVal = value!;
                    for(int i =0; i < 3; i++){
                      if(natList[i] == value){
                        if(natRankState.widgetType == 'a'){
                          myAppState.atActualCalc(classification, atSliderVal, i);
                        }else if(natRankState.widgetType == 'b'){
                          myAppState.bActualCalc(myAppState.bSliderVal, i);
                        }else{
                          myAppState.dActualCalc(myAppState.dSliderVal, i);
                        }
                      }
                    }
                  }
                  );
                },
              ),
              const SizedBox(height: 15,)
            ],
          ),
          const SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ランク補正',
                style: TextStyle(
                  fontSize: 16
                ),
                textAlign: TextAlign.start,),
              Row(
                children: [
                  DropdownButton(
                    value: rankList[rankPos],
                    items: rankList.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                          width: 65,
                            child: Text(value)
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        for(int i =0; i < 13; i++){
                          if(rankList[i] == value){
                            if(natRankState.widgetType=='a'){
                              myAppState.atRankChanged(i);
                            }else if(natRankState.widgetType == 'b'){
                              myAppState.dfRankChanged(i, myAppState.dRankPos);
                            }else{
                              myAppState.dfRankChanged(myAppState.bRankPos, i);
                            }

                          }
                        }
                      }
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            if(rankPos > 0){
                              setState(() {
                                if(natRankState.widgetType == 'a'){
                                  myAppState.atRankChanged(rankPos-1);
                                }else if(natRankState.widgetType == 'b'){
                                  myAppState.dfRankChanged(rankPos-1, myAppState.dRankPos);
                                }else {
                                  myAppState.dfRankChanged(myAppState.bRankPos, rankPos-1);
                                }
                              });
                            }
                          },
                          child: const Text('+')
                      ),
                      const SizedBox(width: 5,),
                      ElevatedButton(
                        onPressed: (){
                          if(rankPos < 12){
                            setState(() {
                              if(natRankState.widgetType == 'a'){
                                myAppState.atRankChanged(rankPos+1);
                              }else if(natRankState.widgetType == 'b'){
                                myAppState.dfRankChanged(rankPos+1, myAppState.dRankPos);
                              }else {
                                myAppState.dfRankChanged(myAppState.bRankPos, rankPos+1);
                              }
                            });
                          }
                        },
                        child: const Text('-'),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15,)
            ],
          ),
        ],
      ),
    );
  }
}

class SpEffectWidget extends StatefulWidget{
  final SpEffectClassPath spEfState;
  const SpEffectWidget({super.key, required this.spEfState});

  @override
  State<SpEffectWidget> createState() => _SpEffectWidgetState();
}

class _SpEffectWidgetState extends State<SpEffectWidget> {
  String effectVal = atEffectList[0];

  bool spChChecked = false;

  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var spEfState = widget.spEfState;
    spChChecked = myAppState.atSpCh;
    effectVal = myAppState.atEffect;
    if(spEfState.aOrD == 'df'){
      effectVal = myAppState.dfEffect;
      spChChecked = myAppState.dfSpCh;
    }
    if(effectVal == ''){
      effectVal = '持ち物なし';
    }
    List<String> spChList = <String>[spEfState.poke.char1];
    spChList.add(spEfState.poke.char2);
    spChList.add(spEfState.poke.char3);
    var poke = spEfState.poke;
    var initialChar = <Ability>[];
    var another1 = charList.where((Ability option){return poke.char1 == option.ability;}).first.another;
    initialChar.add(Ability(ability: poke.char1, another: another1));
    if(poke.char2 != ''){
      var another2 = charList.where((Ability option){return poke.char2 == option.ability;}).first.another;
      initialChar.add(Ability(ability: poke.char2, another: another2));
    }
    if(poke.char3 != ''){
      var another3 = charList.where((Ability option){return poke.char3 == option.ability;}).first.another;
      initialChar.add(Ability(ability: poke.char3, another: another3));
    }

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white30;
      }
      return Colors.white;
    }
    var effectList = atEffectList;
    if(spEfState.aOrD == 'df'){
      effectList = dfEffectList;
    }
    if(spEfState.poke.pokeName == 'オーガポン(井戸)' || spEfState.poke.pokeName == 'オーガポン(竈)' || spEfState.poke.pokeName == 'オーガポン(礎)'){
      effectList = ['お面'];
      effectVal = effectList.first;
    }
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '特性',
              style: TextStyle(
                  fontSize: 16
              ),
            ),
            Row(
              children: [
                SpChDialogWidget(initialCharList: initialChar, aOrD: spEfState.aOrD),
                Checkbox(
                    checkColor: Colors.purple,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: spChChecked,
                    onChanged:  (bool? value) {
                      setState(() {
                        spChChecked = value!;
                        if(spEfState.aOrD == 'at'){
                          myAppState.atSpChChanged(myAppState.atSpChString, spChChecked);
                        }else{
                          myAppState.dfSpChChanged(myAppState.dfSpChString, spChChecked);
                        }
                      });
                    }
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '持ち物',
              style: TextStyle(
                  fontSize: 16
              ),
            ),
            SizedBox(
              height: 60,
              child: DropdownButton(
                value: effectVal,
                items: effectList.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value){
                  setState(() {
                    effectVal = value!;
                    if(spEfState.aOrD == 'at'){
                      myAppState.atEffectChanged(effectVal);
                    }else{
                      myAppState.dfEffectChanged(effectVal);
                    }
                  }
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

class EnviContainer extends StatefulWidget{
  const EnviContainer({super.key});

  @override
  State<EnviContainer> createState() => _EnviContainerState();
}

class _EnviContainerState extends State<EnviContainer> {
  List<String> weatherList = <String>['なし', 'はれ', 'あめ', 'あられ', 'すなあらし'];

  List<String> fieldList = <String>['なし', 'エレキフィールド', 'グラスフィールド', 'ミストフィールド', 'サイコフィールド'];

  List<int> sixteenList = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  List<int> tenList = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> eightList = <int>[0, 1, 2, 3, 4, 5, 6, 7];
  List<int> sixList = <int>[0, 1, 2, 3, 4, 5];
  List<int> fourList = <int>[0, 1, 2, 3];
  List<int> twoList = <int>[0, 1];

  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var offsetIcon = const Icon(Icons.unfold_less);
    if(myAppState.envContainerOffStage){
      offsetIcon = const Icon(Icons.unfold_more);
    }
    return Column(
      children: [
        TopTabContainer(tabIcon: const Icon(Icons.sunny_snowing), offsetIcon: offsetIcon, tabType: "環境"),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)
            ),
            color: Colors.white,
            border: Border.all(
                color: const Color(0xffc7c7ff)
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Offstage(
                  offstage: myAppState.envContainerOffStage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('天候',
                                      style: TextStyle(
                                        fontSize: 18
                                      ),
                                    ),
                                  )
                              ),
                              DropdownButton<String>(
                                value: myAppState.weatherItem,
                                  items: weatherList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: SizedBox(
                                        width: 100,
                                          child: Text(value)),
                                    );
                                  }).toList(),
                                  onChanged: (String? value){
                                    setState(() {
                                      myAppState.weatherItemChanged(value!);
                                    });
                                  }),
                            ],
                          ),
                          const SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('フィールド',
                                      style: TextStyle(
                                          fontSize: 18
                                      ),
                                    ),
                                  )
                              ),
                              DropdownButton<String>(
                                  value: myAppState.fieldItem,
                                  items: fieldList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value){
                                    setState(() {
                                      myAppState.fieldItemChanged(value!);
                                    });
                                  }
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('壁',
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                          )
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: myAppState.reflect,
                              onChanged: (bool? value){
                                myAppState.barrierChanged(value!, myAppState.light);
                              }
                          ),
                          const Text('リフレクター',
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                          Checkbox(
                              value: myAppState.light,
                              onChanged: (bool? value){
                                myAppState.barrierChanged(myAppState.reflect, value!);
                              }
                          ),
                          const Text('光の壁',
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('定数ダメージ',
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                          )
                      ),
                      ConstDamageWidget(path: ConstDamageClassPath(myAppState.sixteen, '1/16', sixteenList, myAppState.ten, '1/10', tenList)),
                      ConstDamageWidget(path: ConstDamageClassPath(myAppState.eight, '1/8', eightList, myAppState.six, '1/6', sixList)),
                      ConstDamageWidget(path: ConstDamageClassPath(myAppState.four, '1/4', fourList, myAppState.two, '1/2', twoList)),

                    ],
                  ),
                ),
              ),
              const Row(
                children: [Expanded(child: SizedBox())],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ConstDamageWidget extends StatefulWidget{
  final ConstDamageClassPath path;
  const ConstDamageWidget({super.key, required this.path});

  @override
  State<ConstDamageWidget> createState() => _ConstDamageWidgetState();
}

class _ConstDamageWidgetState extends State<ConstDamageWidget> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var path = widget.path;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${path.constStr}ダメージ',
              style: const TextStyle(
                fontSize: 16
              ),
            ),
            Row(
              children: [
                DropdownButton<String>(
                    value: path.constVal.toString(),
                    items: path.constTimeList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: SizedBox(
                          width: 22,
                            child: Text(value.toString())),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        switch(path.constStr){
                          case '1/16':
                            myAppState.constDamageChanged(path.constVal, myAppState.ten, myAppState.eight, myAppState.six, myAppState.four, myAppState.two);
                          case '1/8':
                            myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, path.constVal, myAppState.six, myAppState.four, myAppState.two);
                          case '1/4':
                            myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, myAppState.eight, myAppState.six, path.constVal, myAppState.two);
                        }
                      });
                    }
                ),
                const SizedBox(width: 5,),
                ElevatedButton(
                    onPressed: (){
                      if(path.constVal < path.constTimeList.length-1){
                        setState(() {
                          switch(path.constStr){
                            case '1/16':
                              myAppState.constDamageChanged(path.constVal +1, myAppState.ten, myAppState.eight, myAppState.six, myAppState.four, myAppState.two);
                            case '1/8':
                              myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, path.constVal + 1, myAppState.six, myAppState.four, myAppState.two);
                            case '1/4':
                              myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, myAppState.eight, myAppState.six, path.constVal+1, myAppState.two);
                          }
                        }
                        );
                      }
                    },
                    child: const Text('+')
                ),
                const SizedBox(width: 5,),
                ElevatedButton(
                    onPressed: (){
                      if(path.constVal > 0){
                        setState(() {
                          switch(path.constStr){
                            case '1/16':
                              myAppState.constDamageChanged(path.constVal -1, myAppState.ten, myAppState.eight, myAppState.six, myAppState.four, myAppState.two);
                            case '1/8':
                              myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, path.constVal - 1, myAppState.six, myAppState.four, myAppState.two);
                            case '1/4':
                              myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, myAppState.eight, myAppState.six, path.constVal-1, myAppState.two);
                          }
                        });
                      }
                    },
                    child: const Text('-')
                )
              ],
            )
          ],
        ),
        const SizedBox(width: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${path.secondlyConstStr}ダメージ',
              style: const TextStyle(
                fontSize: 16
              ),
            ),
            Row(
              children: [
                DropdownButton<String>(
                    value: path.secondlyConstVal.toString(),
                    items: path.secondlyTimeList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: SizedBox(
                          width: 22,
                            child: Text(value.toString())
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        switch(path.secondlyConstStr){
                          case '1/10':
                            myAppState.constDamageChanged(myAppState.sixteen, path.secondlyConstVal, myAppState.eight, myAppState.six, myAppState.four, myAppState.two);
                          case '1/6':
                            myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, myAppState.eight, path.secondlyConstVal, myAppState.four, myAppState.two);
                          case '1/2':
                            myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, myAppState.eight, myAppState.six, myAppState.four, path.secondlyConstVal);
                        }
                      });
                    }
                ),
                const SizedBox(width: 5,),
                ElevatedButton(
                    onPressed: (){
                      if(path.secondlyConstVal < path.secondlyTimeList.length-1){
                        setState(() {
                          switch(path.secondlyConstStr){
                            case '1/10':
                              myAppState.constDamageChanged(myAppState.sixteen, path.secondlyConstVal+1, myAppState.eight, myAppState.six, myAppState.four, myAppState.two);
                            case '1/6':
                              myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, myAppState.eight, path.secondlyConstVal+1, myAppState.four, myAppState.two);
                            case '1/2':
                              myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, myAppState.eight, myAppState.six, myAppState.four, path.secondlyConstVal+1);
                          }
                        }
                        );
                      }
                    },
                    child: const Text('+')
                ),
                const SizedBox(width: 5,),
                ElevatedButton(
                    onPressed: (){
                      if(path.secondlyConstVal > 0){
                        setState(() {
                          switch(path.secondlyConstStr){
                            case '1/10':
                              myAppState.constDamageChanged(myAppState.sixteen, path.secondlyConstVal-1, myAppState.eight, myAppState.six, myAppState.four, myAppState.two);
                            case '1/6':
                              myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, myAppState.eight, path.secondlyConstVal-1, myAppState.four, myAppState.two);
                            case '1/2':
                              myAppState.constDamageChanged(myAppState.sixteen, myAppState.ten, myAppState.eight, myAppState.six, myAppState.four, path.secondlyConstVal-1);
                          }
                        });
                      }
                    },
                    child: const Text('-')
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

class DamageContainer extends StatefulWidget{
  const DamageContainer({super.key});

  @override
  State<DamageContainer> createState() => _DamageContainerState();
}

class _DamageContainerState extends State<DamageContainer> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    double progressWidth = 300*(1-(myAppState.maxDamage)/myAppState.hActual);
    if(progressWidth < 0){
      progressWidth = 0;
    }
    double progress = (1-(myAppState.minDamage)/myAppState.hActual)*(300-progressWidth)/300.toDouble();
    double secondaryProgressWidth = 300-progressWidth;
    Widget secondClip = IndicatorOnly(path: IndicatePath(Colors.purple, progress, secondaryProgressWidth));
    if(progressWidth == 0){
      secondClip = IndicatorFull(path: IndicatePath(Colors.purple, progress, secondaryProgressWidth));
    }
    return BottomAppBar(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                  ),
                  child: SizedBox(
                    width: progressWidth,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                      minHeight: 8,
                      value: 1,
                    ),
                  ),
                ),
                secondClip,
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Checkbox(
                      value: myAppState.critical,
                      onChanged: (bool? value){
                        setState(() {
                          myAppState.critical = value!;
                          myAppState.damageCalc();
                        });
                      }
                  ),
                ),
                const Text('急所')
              ],
            ),
            Row(
              children: [
                Text(myAppState.damageText.toString()),
                const SizedBox(width: 10,),
                Text('(${(myAppState.minDamage/myAppState.hActual*1000).ceil()/10}%~${(myAppState.maxDamage/myAppState.hActual*1000).ceil()/10}%)', style: TextStyle(fontSize: 13),),
                const Expanded(child: SizedBox()),
                Container(
                  alignment: Alignment.topRight,
                  height: 35,
                  child: TextButton(
                      onPressed: (){
                        setState(() {
                          myAppState.damageSave(progress, progressWidth, secondaryProgressWidth);
                        });
                      },
                      child: const Text('ダメージ加算')
                  ),
                )
              ],
            ),
          ],
        )
    );
  }
}

class IndicatorFull extends StatelessWidget{
  final IndicatePath path;
  const IndicatorFull({super.key, required this.path});

  @override
  Widget build(BuildContext context){
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),

      ),
      child: SizedBox(
        width: path.progressWidth,
        child: LinearProgressIndicator(
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(path.indicatorColor),
          minHeight: 8,
          value: path.progress,
        ),
      ),
    );
  }
}

class IndicatorOnly extends StatelessWidget{
  final IndicatePath path;
  const IndicatorOnly({super.key, required this.path});

  @override
  Widget build(BuildContext context){
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10)
      ),
      child: SizedBox(
        width: path.progressWidth,
        child: LinearProgressIndicator(
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(path.indicatorColor),
          minHeight: 8,
          value: path.progress,
        ),
      ),
    );
  }
}

class AttackTime extends StatefulWidget{
  final SerialSkill path;
  const AttackTime({super.key, required this.path});

  @override
  State<AttackTime> createState() => _AttackTimeState();
}

class _AttackTimeState extends State<AttackTime> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '攻撃回数',
          style: TextStyle(
            fontSize: 16
          ),
        ),
        Row(
          children: [
            DropdownButton<String>(
                value: myAppState.attackTime.toString(),
                items: widget.path.minMax.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: SizedBox(
                        width: 22,
                        child: Text(value.toString())),
                  );
                }).toList(),
                onChanged: (String? value){
                  setState(() {
                    for(int i = 1; i<= widget.path.minMax.length; i++){
                      if(i.toString() == value!){
                        myAppState.attackTimeChanged(i);
                      }
                    }
                    myAppState.damageCalc();
                  });
                }
            ),
          ],
        ),
      ],
    );
  }
}

class ExtraInfo extends StatefulWidget{
  final ExtraInfoPath path;
  const ExtraInfo({super.key, required this.path});

  @override
  State<ExtraInfo> createState() => _ExtraInfoState();
}

class _ExtraInfoState extends State<ExtraInfo> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var path = widget.path;
    var skill = path.skill;
    var twoThirdsOffstage = true;
    var secondOffstage = true;
    if(path.skill.name == 'はたきおとす'){
      twoThirdsOffstage = false;
    }
    if(path.skill.name == 'アクロバット' || path.skill.name == 'からげんき'|| skill.name == 'しおみず' || skill.name == 'ベノムショック' || skill.name == 'クロスフレイム' || skill.name == 'クロスサンダー' || skill.name == 'かたきうち' || skill.name == 'たたりめ'){
      secondOffstage = false;
    }
    var twoThirds = myAppState.twoThirds;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      myAppState.damageCalc();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Offstage(
          offstage: twoThirdsOffstage,
          child: Row(
            children: [
              Checkbox(
                  value: myAppState.twoThirds,
                  onChanged: (bool? value){
                    setState(() {
                      myAppState.extraChanged(value!, myAppState.second);
                      myAppState.damageCalc();
                    });
                  }
              ),
              const Text('ダメージ1.5倍'),
            ],
          ),
        ),
        Offstage(
          offstage: secondOffstage,
          child: Row(
            children: [
              Checkbox(
                  value: myAppState.second,
                  onChanged: (bool? value){
                    myAppState.second = value!;
                    myAppState.damageCalc();
                  }
              ),
              const Text('ダメージ2倍')
            ],
          ),
        )
      ],
    );
  }
}

class PokeDetailTop extends StatefulWidget{
  final Poke poke;
  final int id;
  final Image teraImage;
  const PokeDetailTop({super.key, required this.poke, required this.id, required this.teraImage});

  @override
  State<PokeDetailTop> createState() => _PokeDetailTopState();
}

class _PokeDetailTopState extends State<PokeDetailTop> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var pokeTribe = '${widget.poke.hTribe}-${widget.poke.aTribe}-${widget.poke.bTribe}-${widget.poke.cTribe}-${widget.poke.dTribe}-${widget.poke.sTribe}';
    var imageList = <Image>[typeList.where((Type option) {return option.type == widget.poke.type1;}).first.typeImage];
    if(widget.poke.type2 != ''){
      imageList.add(typeList.where((Type option) {return option.type == widget.poke.type2;}).first.typeImage);
    }
    return Column(
      children: [
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12
                ),
                child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.asset(widget.poke.imagePath)
                )
            ),
            buildContainer(context, pokeTribe, imageList)
          ],
        ),
      ],
    );
  }

  Container buildContainer(BuildContext context, String pokeTribe, List<Image> imageList) {
    var myAppState = context.watch<MyAppState>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 190,
                    child: Text(
                      widget.poke.pokeName,
                      style: const TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: (){
                        setState(() {
                          myAppState.damageDelete(widget.id);
                        });
                      },
                      icon: Icon(Icons.cancel)),
                ],
              )
            ],
          ),
          Row(
            children: [
              const Text('種族値:'),
              Text(pokeTribe),
            ],
          ),
          Row(
            children: [
              const Text('タイプ:'),
              const SizedBox(width: 5,),
              SizedBox(
                width: 150,
                  height: 14,
                  child: Row(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: imageList.length,
                        itemBuilder: (context, index){
                          return Row(
                            children: [
                              imageList[index],
                              const SizedBox(width: 5,),
                            ],
                          );
                        },
                      )
                    ],
                  )
              ),
            ],
          ),
          Row(
            children: [
              const Text('テラスタル:'),
              const SizedBox(width: 5,),
              SizedBox(
                  height: 14,
                  child: widget.teraImage
              )
            ],
          )
        ],
      ),
    );
  }
}

class PokeDamageBottom extends StatefulWidget{
  final DamageWidgetPath path;
  final int pos;
  final int hActual;
  final int bActual;
  final int dActual;
  const PokeDamageBottom({super.key, required this.path, required this.pos, required this.hActual, required this.bActual, required this.dActual});

  @override
  State<PokeDamageBottom> createState() => _PokeDamageBottomState();
}

class _PokeDamageBottomState extends State<PokeDamageBottom>{
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    final atState = widget.path.atPath;
    final dfState = widget.path.dfPath;
    final envState = widget.path.envPath;
    List<int> minMax = damageCalc(atState, dfState, envState, widget.hActual, widget.bActual, widget.dActual);
    int min = minMax.first;
    int max = minMax[1];
    if(minMaxSumList.isNotEmpty){
      var i = 0;
      while(minMaxSumList[i].id != widget.pos){
        i++;
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        minMaxSumList[i] = MinMaxSum(id: widget.pos, min: min, max: max);
        myAppState.damageChanged(minMaxSumList);
        myAppState.damageCalc();
      });
    }
    double progressWidth = 300*(1-(max)/widget.hActual);
    if(progressWidth < 0){
      progressWidth = 0;
    }
    double progress = (1-(min)/widget.hActual)*(300-progressWidth)/300.toDouble();
    double secondaryProgressWidth = 300-progressWidth;
    Widget secondClip = IndicatorOnly(path: IndicatePath(Colors.purple, progress, secondaryProgressWidth));
    if(progressWidth == 0){
      secondClip = IndicatorFull(path: IndicatePath(Colors.purple, progress, secondaryProgressWidth));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)
              ),
              child: SizedBox(
                width: progressWidth,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                  minHeight: 8,
                  value: 1,
                ),
              ),
            ),
            secondClip,
            
          ],
        ),
        Row(
          children: [
            Text('$min~$max'),
            const SizedBox(width: 10,),
            Text('(${(min/widget.hActual*1000).ceil()/10}%~${(max/widget.hActual*1000).ceil()/10}%)'),
            const SizedBox(width: 10,),
            Text('HP ${widget.hActual}')
          ],
        ),
      ],
    );
  }
}

class SavedDamageWidget extends StatelessWidget{
  final SavedDamage path;
  final DamageWidgetPath widgetPath;
  const SavedDamageWidget({super.key, required this.path, required this.widgetPath});

  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var atState = widgetPath.atPath;
    var dfState = widgetPath.dfPath;
    var dfActual = myAppState.bActual;
    var dfRankPos = dfState.dfBRank;
    if(atState.skill.classification == '特殊'){
      dfActual = myAppState.dActual;
      dfRankPos = dfState.dfDRank;
    }
    var atSp = atState.atSpCh;
    if(!atState.atSp){atSp = 'なし';}
    var dfSp = dfState.dfSpCh;
    if(!dfState.dfSp){dfSp = 'なし';}

    var atEffect = atState.atEffect;
    var dfEffect = dfState.dfEffect;
    if(atState.atEffect == ''){atEffect = 'なし';}
    if(dfState.dfEffect == ''){dfEffect = 'なし';}
    var atTera = atState.atTera;
    var dfTera = dfState.dfTeraType;
    if(atTera== 'null'){atTera = '非テラスタル';}
    if(dfTera == 'null'){dfTera = '非テラスタル';}
    var envState = widgetPath.envPath;
    var damageContainer = PokeDamageBottom(path: DamageWidgetPath(atState, dfState, envState), pos: path.id, hActual: myAppState.hActual, bActual: myAppState.bActual, dActual: myAppState.dActual,);
    var reflect = 'なし';
    if(envState.reflect){reflect = 'あり';}
    var light = 'なし';
    if(envState.lightWall){light = 'あり';}

    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: GestureDetector(
        onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: SizedBox(
            width: 350,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('詳細'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //const SizedBox(width: 15,),
                        DamageDialogWidget(path: DamageDialogPath(poke: atState.poke, actual: atState.atActual, rankPos: atState.atRankPos, spCh: atSp, effect: atEffect, teraType: atTera)),
                        const Column(
                          children: [
                            SizedBox(
                              height: 92,
                              child: Icon(Icons.double_arrow),
                            ),
                            Text('ポケモン名'),
                            Text('実数値'),
                            Text('ランク補正'),
                            Text('特性(適用中)'),
                            Text('持ち物'),
                            Text('テラスタイプ')
                          ],
                        ),
                        DamageDialogWidget(path: DamageDialogPath(poke: dfState.poke, actual: dfActual, rankPos: dfRankPos, spCh: dfSp, effect: dfEffect, teraType: dfTera)),
                        ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text('環境',style: TextStyle(fontSize: 16),),
                        Row(
                          children: [
                            const Text('天候: '),
                            Text(envState.weather),
                            const SizedBox(width: 10,),
                            const Text('フィールド: '),
                            Text(envState.field)
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text('リフレクター: '),
                            Text(reflect),
                            const SizedBox(width: 10,),
                            const Text('光の壁: '),
                            Text(light)
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                            children: [
                              const Text('定数ダメージ: '),
                              Text(envState.constDamage.toString()
                              )
                            ]
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        SizedBox(
                            height: 30,
                            child: typeList.where((Type option) {return option.type == path.skill.type;}).first.typeIcon
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          children: [
                            const SizedBox(height: 5,),
                            Text(path.skill.name),
                          ],
                        ),
                        const SizedBox(width: 5,),
                        Column(
                          children: [
                            const SizedBox(height: 5,),
                            Text(path.skill.classification),
                          ],
                        ),
                        const SizedBox(width: 5,),
                        Column(
                          children: [
                            const SizedBox(height: 5,),
                            Text(path.skill.power.toString()),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    damageContainer,
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              path.atPokeDetail,
              const SizedBox(height: 5,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                      child: typeList.where((Type option) {return option.type == path.skill.type;}).first.typeIcon
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    children: [
                      const SizedBox(height: 5,),
                      Text(path.skill.name),
                    ],
                  ),
                  const SizedBox(width: 5,),
                  Column(
                    children: [
                      const SizedBox(height: 5,),
                      Text(path.skill.classification),
                    ],
                  ),
                  const SizedBox(width: 5,),
                  Column(
                    children: [
                      const SizedBox(height: 5,),
                      Text(path.skill.power.toString()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              damageContainer
            ],
          ),
        ),
      ),
    );
  }
}

class DamageListWidget extends StatefulWidget{
  final List<SavedDamageWidget> damageList;
  const DamageListWidget({super.key, required this.damageList});

  @override
  State<DamageListWidget> createState() => _DamageListWidgetState();
}

class _DamageListWidgetState extends State<DamageListWidget> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var offsetIcon = const Icon(Icons.unfold_less);
    if(myAppState.damageListContainerOffStage){
      offsetIcon = const Icon(Icons.unfold_more);
    }
    return Column(
      children: [
        const SizedBox(height: 20,),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(
                color: const Color(0xffc7c7ff)
            ),
            color: const Color(0xFFe6e6fa),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_motion),
                    const SizedBox(width: 10,),
                    const Text(
                      '追加ダメージ',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: (){
                          setState(() {
                            if(myAppState.damageListContainerOffStage){
                              myAppState.damageListContainerOffStage = false;
                            }else{
                              myAppState.damageListContainerOffStage = true;
                            }
                          });
                        },
                        icon: offsetIcon
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Colors.white,
            border: Border.all(
                color: const Color(0xffc7c7ff)
            ),
          ),
          child: Column(
            children: [
              Offstage(
                offstage: myAppState.damageListContainerOffStage,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: SizedBox(
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.damageList.length,
                        itemBuilder: (BuildContext context, int index){
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  widget.damageList[index],
                                  const SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          ],
                        );
                        }
                    ),
                  ),
                ),
              ),
              const Row(
                children: [
                  Expanded(child: SizedBox(height: 15,))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DamageDialogWidget extends StatelessWidget{
  final DamageDialogPath path;
  const DamageDialogWidget({super.key, required this.path});

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12
            ),
            child: SizedBox(
                width: 90,
                height: 90,
                child: Image.asset(path.poke.imagePath)
            )
        ),
        Text(path.poke.pokeName),
        Text(path.actual.toString()),
        Text(rankList[path.rankPos]),
        Text(path.spCh),
        Text(path.effect),
        Text(path.teraType)
      ],
    );
  }
}

class TeraBlastWidget extends StatefulWidget{
  const TeraBlastWidget({super.key});

  @override
  State<TeraBlastWidget> createState() => _TeraBlastWidgetState();
}

class _TeraBlastWidgetState extends State<TeraBlastWidget> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var teraBlastClassification = myAppState.teraPhysOrSpe;
    var physicFlag = false;
    var specialFlag = false;
    if(teraBlastClassification == '物理'){
      physicFlag = true;
      specialFlag = false;
    }else{
      physicFlag = false;
      specialFlag = true;
    }
    return Column(
      children: [
        Offstage(
          offstage: myAppState.teraBlastFlag,
          child: Row(
            children: [
              Checkbox(
                  value: physicFlag,
                  onChanged: (bool? value){
                    setState(() {
                      if(value!){
                        myAppState.classificationChanged(myAppState.selectedSkill, '物理');
                      }else{
                        myAppState.classificationChanged(myAppState.selectedSkill, '特殊');
                      }
                    });
                  },
              ),
              const Text('物理'),
              Checkbox(
                  value: specialFlag,
                  onChanged: (bool? value){
                    setState(() {
                      if(value!){
                        myAppState.classificationChanged(myAppState.selectedSkill, '特殊');
                      }else{
                        myAppState.classificationChanged(myAppState.selectedSkill, '物理');
                      }
                    });
                  }
              ),
              const Text('特殊')
            ],
          ),
        )
      ],
    );
  }
}

class StellaBlastWidget extends StatefulWidget{
  const StellaBlastWidget({super.key});

  @override
  State<StellaBlastWidget> createState() => _StellaBlastWidgetState();
}

class _StellaBlastWidgetState extends State<StellaBlastWidget> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var teraBlastClassification = myAppState.teraPhysOrSpe;
    var physicFlag = false;
    var specialFlag = false;
    if(teraBlastClassification == '物理'){
      physicFlag = true;
      specialFlag = false;
    }else{
      physicFlag = false;
      specialFlag = true;
    }
    return Column(
      children: [
        Offstage(
          offstage: myAppState.stellaBlastFlag,
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: physicFlag,
                    onChanged: (bool? value){
                      setState(() {
                        if(value!){
                          myAppState.classificationChanged(myAppState.selectedSkill, '物理');
                        }else{
                          myAppState.classificationChanged(myAppState.selectedSkill, '特殊');
                        }
                      });
                    },
                  ),
                  const Text('物理'),
                  Checkbox(
                      value: specialFlag,
                      onChanged: (bool? value){
                        setState(() {
                          if(value!){
                            myAppState.classificationChanged(myAppState.selectedSkill, '特殊');
                          }else{
                            myAppState.classificationChanged(myAppState.selectedSkill, '物理');
                          }
                        });
                      }
                  ),
                  const Text('特殊')
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: myAppState.stellaEffectiveFlag,
                      onChanged: (bool? value){
                        setState(() {
                          myAppState.stellaEffectiveFlag = value!;
                          myAppState.damageCalc();
                        });
                      }
                  ),
                  const Text('相手がテラスタル中')
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class SpCharacteristic extends StatefulWidget{
  final List<Ability> initialCharList;
  final String aOrD;
  const SpCharacteristic({super.key, required this.initialCharList, required this.aOrD});

  @override
  State<SpCharacteristic> createState() => _SpCharacteristicState();
}

class _SpCharacteristicState extends State<SpCharacteristic> {
  final TextEditingController _textEditingController = TextEditingController();
  static String _displayStringForOption(Ability option) => option.ability;
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var retList = widget.initialCharList;
    retList = abilityCheck(charList, retList);
    return SizedBox(
      width: 150,
      child: Autocomplete<Ability>(
        initialValue: TextEditingValue(text:retList.first.ability),
        displayStringForOption: _displayStringForOption,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return retList;
          }
          return retList.where((Ability option) {
            return option.ability.toString().contains(textEditingValue.text.toLowerCase()) | option.another.toString().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (Ability selection) {
          _textEditingController.text = selection.ability;
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            if(widget.aOrD == 'at'){
              myAppState.atSpChChanged(selection.ability.toString(), myAppState.atSpCh);
            }else{
              myAppState.dfSpChChanged(selection.ability.toString(), myAppState.dfSpCh);
            }
          });
        },
        optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Ability> onSelected, retList){
          return Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 420,
              color: Colors.transparent,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Container(
                    width: 240,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      border: Border.all(
                          color: const Color(0xffc7c7ff)
                      ),
                      color: const Color(0xFFe6e6fa),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      itemCount: retList.length,
                      itemBuilder: (BuildContext context, int index){
                        final Ability abilities = retList.elementAt(index);
                        return GestureDetector(
                          onTap: (){
                            _textEditingController.text = abilities.ability;
                            onSelected(abilities);
                          },
                          child: AbilityCard(abilities: abilities),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SkillDialogWidget extends StatefulWidget{
  const SkillDialogWidget({super.key});

  @override
  State<SkillDialogWidget> createState() => _SkillDialogWidgetState();
}

class _SkillDialogWidgetState extends State<SkillDialogWidget> {
  static String _displaySkillStringForOption(Skill option) => option.name;
  final TextEditingController _textSkillEditingController = TextEditingController();
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      myAppState.selectedSkill.name,
                      style: const TextStyle(
                          fontSize: 16
                      ),
                    ),
                  ],
                ),
              ]
            ),
          ),
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Autocomplete<Skill>(
                      initialValue: TextEditingValue(text: myAppState.selectedSkill.name),
                      displayStringForOption: _displaySkillStringForOption,
                      optionsBuilder: (TextEditingValue textEditingValue) { // 3.
                        if (textEditingValue.text == '') {
                          return skillList;
                        }
                        return skillList.where((Skill option) {// 4.
                          return option.name.toString().contains(textEditingValue.text) | option.anotherName.toString().contains(textEditingValue.text);
                        });
                      },
                      onSelected: (Skill skill) { // 5.
                        setState(() {
                          myAppState.skillChanged(skill);
                          FocusManager.instance.primaryFocus?.unfocus();
                        });
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) {
                            onFieldSubmitted();
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(22),
                                topRight: Radius.circular(22)
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            labelText: '攻撃技',
                            floatingLabelStyle: TextStyle(fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(22),
                                  topRight: Radius.circular(22)
                              ),
                              borderSide: BorderSide(
                                color: Colors.purple,
                                width: 1.0,
                              ),
                            ),
                          ),
                        );
                      },
                      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Skill> onSelected, skillList){
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: 330,
                                height: 400,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(10),
                                  itemCount: skillList.length,
                                  itemBuilder: (BuildContext context, int index){
                                    final Skill skills = skillList.elementAt(index);
                                    return GestureDetector(
                                      onTap: (){
                                        _textSkillEditingController.text = skills.name;
                                        onSelected(skills);
                                        Navigator.pop(context);
                                      },
                                      child: SkillWidget(skills: skills),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ),
        ),
      ],
    );
  }
}

class SpChDialogWidget extends StatefulWidget{
  final List<Ability> initialCharList;
  final String aOrD;
  const SpChDialogWidget({super.key, required this.initialCharList, required this.aOrD});

  @override
  State<SpChDialogWidget> createState() => _SpChDialogWidgetState();
}

class _SpChDialogWidgetState extends State<SpChDialogWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  static String _displayStringForOption(Ability option) => option.ability;
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    var retList = widget.initialCharList;
    retList = abilityCheck(charList, retList);
    var spCh = myAppState.atSpChString;
    if(widget.aOrD == "df"){
      spCh = myAppState.dfSpChString;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
            width: 150,
            height: 50,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.grey
                ),
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        spCh,
                        style: const TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
          onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Autocomplete<Ability>(
                        initialValue: TextEditingValue(text: spCh),
                        displayStringForOption: _displayStringForOption,
                        optionsBuilder: (TextEditingValue textEditingValue) { // 3.
                          if (textEditingValue.text == '') {
                            return retList;
                          }
                          return retList.where((Ability option) {
                            return option.ability.toString().contains(textEditingValue.text.toLowerCase()) | option.another.toString().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (Ability selection) {
                          _textEditingController.text = selection.ability;
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            if(widget.aOrD == 'at'){
                              myAppState.atSpChChanged(selection.ability.toString(), myAppState.atSpCh);
                            }else{
                              myAppState.dfSpChChanged(selection.ability.toString(), myAppState.dfSpCh);
                            }
                          });
                        },
                        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            onFieldSubmitted: (String value) {
                              onFieldSubmitted();
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(22),
                                    topRight: Radius.circular(22)
                                ),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              labelText: '特性',
                              floatingLabelStyle: TextStyle(fontSize: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(22),
                                    topRight: Radius.circular(22)
                                ),
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          );
                        },
                        optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Ability> onSelected, retList){
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: 330,
                                  height: 400,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(10),
                                    itemCount: retList.length,
                                    itemBuilder: (BuildContext context, int index){
                                      final Ability abilities = retList.elementAt(index);
                                      return GestureDetector(
                                        onTap: (){
                                          _textEditingController.text = abilities.ability;
                                          onSelected(abilities);
                                          Navigator.pop(context);
                                        },
                                        child: AbilityCard(abilities: abilities),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
          ),
        ),
      ],
    );
  }
}

class SavedDamage{
  SavedDamage({
    required this.id,
    required this.damageContainer,
    required this.atPokeDetail,
    required this.skill,
    required this.dfPoke,
  });
  int id;
  PokeDamageBottom damageContainer;
  PokeDetailTop atPokeDetail;
  Skill skill;
  Poke dfPoke;
}

class DamageDialogPath{
  DamageDialogPath({
    required this.poke,
    required this.actual,
    required this.rankPos,
    required this.spCh,
    required this.effect,
    required this.teraType
  });
  Poke poke;
  int actual;
  int rankPos;
  String spCh;
  String effect;
  String teraType;
}

class TopTabContainer extends StatefulWidget{
  final Icon tabIcon;
  final Icon offsetIcon;
  final String tabType;
  const TopTabContainer({super.key, required this.tabIcon, required this.offsetIcon, required this.tabType});

  @override
  State<TopTabContainer> createState() => _TopTabContainerState();
}

class _TopTabContainerState extends State<TopTabContainer> {
  @override
  Widget build(BuildContext context){
    var myAppState = context.watch<MyAppState>();
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(
            color: const Color(0xffc7c7ff)
        ),
        color: const Color(0xFFe6e6fa),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Row(
              children: [
                widget.tabIcon,
                const SizedBox(width: 10,),
                Text(
                  widget.tabType,
                  style: const TextStyle(
                      fontSize: 20
                  ),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                    onPressed: (){
                      setState(() {
                        if(widget.tabType == "Attacker"){
                          if(myAppState.atContainerOffStage){
                            myAppState.atContainerOffStage = false;
                          }else{
                            myAppState.atContainerOffStage = true;
                          }
                        }else if(widget.tabType == "Defender"){
                          if(myAppState.dfContainerOffStage){
                            myAppState.dfContainerOffStage = false;
                          }else{
                            myAppState.dfContainerOffStage = true;
                          }
                        }else if(widget.tabType == "環境"){
                          if(myAppState.envContainerOffStage){
                            myAppState.envContainerOffStage = false;
                          }else{
                            myAppState.envContainerOffStage = true;
                          }
                        }

                      });
                    },
                    icon: widget.offsetIcon
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Skill {
  Skill({
    required this.name,
    required this.power,
    required this.type,
    required this.anotherName,
    required this.classification
  });
  String name;
  String anotherName;
  int power;
  String type;
  String classification;
}

class MinMaxSum{
  MinMaxSum({
    required this.id,
    required this.min,
    required this.max
  });
  int id;
  int min;
  int max;
}

List<Skill> listUpdate(Poke poke){
  List<String> initialList = [poke.skill1, poke.skill2, poke.skill3, poke.skill4, poke.skill5];
  List<Skill> retSkill = [];
  for(int i = 0; i<skillList.length; i++){
    if(initialList.contains(skillList[i].name)){
      retSkill.add(skillList[i]);
    }
  }
  for(int i = 0; i < skillList.length; i++){
    if(!initialList.contains(skillList[i].name)){
      retSkill.add(skillList[i]);
    }
  }
  return retSkill;
  
}

Future<List<Skill>> retUpdate(String skill1, String skill2,String skill3,String skill4,String skill5) async{
  listMap = await DatabaseHelper.customSkillList(skill1, skill2, skill3, skill4, skill5) as List<Skill>;
  return listMap;
}

void minMaxDecide(List<ReCalc> list, int hActual, int bActual, int dActual){
  for(int i=0; i< list.length; i++){
    var minMax = damageCalc(list[i].atPath, list[i].dfPath, list[i].envPath, hActual, bActual, dActual);
    minMaxSumList[i] = MinMaxSum(id: list[i].id, min: minMax.first, max: minMax[1]);
  }
}

List<int> damageCalc(AttackStatePath atPath, DefenceStatePath dfPath, CircumstanceStatePath envPath, int hActual, int bActual, int dActual){
  int atActual = atPath.atActual;
  int dfActual = bActual;
  int dfRankPos = dfPath.dfBRank;
  if(atPath.skill.classification == '特殊'){
    dfActual = dActual;
    dfRankPos = dfPath.dfDRank;
    if(atPath.skill.name == 'サイコショック' || atPath.skill.name == 'サイコブレイク'){
      dfActual = bActual;
      dfRankPos = dfPath.dfBRank;
    }
  }
  String atSp = atPath.atSpCh;
  String dfSp = dfPath.dfSpCh;
  if(!atPath.atSp){atSp = 'null';}
  if(!dfPath.dfSp){dfSp = 'null';}
  Skill selectedSkill = atPath.skill;
  var type1 = dfPath.poke.type1;
  var type2 = dfPath.poke.type2;
  if(dfPath.dfTeraType != 'null' && dfPath.dfTeraType != 'ステラ'){
    type1 = dfPath.dfTeraType;
    type2 = 'null';
  }

  int atAct = finalAtActualCalc(pokeMap, dfPokeMap, atActual, atSp, dfSp, atPath.atEffect, selectedSkill, atPath.atRankPos);
  int dfAct = finalDfActualCalc(dfActual, atSp, dfSp, dfPath.dfEffect, dfRankPos, selectedSkill, type1, type2, envPath.weather);
  int finalSkillPower = finalSkillPowerCalc(pokeMap, selectedSkill, atSp, atPath.atEffect, envPath.field);
  if(atPath.twoThirds){finalSkillPower = (finalSkillPower*1.5).truncate();}
  if(atPath.second){finalSkillPower = (finalSkillPower*2).truncate();}
  double typeMag1 = typeMagnification(selectedSkill, dfPokeMap.type1, atSp);
  double typeMag2 = typeMagnification(selectedSkill, 'null', atSp);
  if(dfPokeMap.type2 != 'null'){
    typeMag2 = typeMagnification(selectedSkill, dfPokeMap.type2, atSp);
  }
  double typeMag = typeMag1*typeMag2;
  if(dfPath.dfTeraType != 'null' && dfPath.dfTeraType != 'ステラ'){
    typeMag = typeMagnification(selectedSkill, dfPath.dfTeraType, atSp);
  }else if(atPath.atTera == 'ステラ' && atPath.stellaEffective){
    typeMag = 2.0;
  }
  double finalDamageMag = finalDamageMagnification(pokeMap, dfPokeMap, selectedSkill, envPath.reflect, envPath.lightWall, atSp, atPath.atEffect, dfSp, dfPath.dfEffect, typeMag);

  List<int> minMax = damageCalculate(pokeMap, dfPokeMap, atAct, dfAct, typeMag, atMagnification(selectedSkill.type, atPath.poke.type1, atPath.poke.type2, atPath.atTera), '', '', selectedSkill, finalSkillPower, atPath.atRankPos, atPath.critical, envPath.weather);
  int maxDamage = (minMax.last*finalDamageMag).round()*atPath.attackTime+envPath.constDamage;
  int minDamage = (minMax.first*finalDamageMag).round()*atPath.attackTime+envPath.constDamage;
  List<int> retList = [minDamage, maxDamage];
  return retList;
}