import 'poke_database.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class AtState {
  final Poke poke;
  final Image teraImage;
  final double atSlider;
  final int atNatPos;
  final int atRankPos;
  final Skill skill;
  final Image teraIcon;

  const AtState(this.poke, this.teraImage, this.atSlider, this.atNatPos, this.atRankPos, this.skill, this.teraIcon);
}

class AttackState{
  AttackState({
    required this.poke,
    required this.teraImage,
    required this.atSlider,
    required this.atEffort,
    required this.atNatPos,
    required this.atRankPos,
    required this.atSpCh,
    required this.atSp,
    required this.atEffect,
    required this.skill,
    required this.teraIcon,
    required this.teraType,
    required this.stellaFlag,
    required this.stellaEffective
  });
  Poke poke;
  Image teraImage;
  double atSlider;
  int atEffort;
  int atNatPos;
  int atRankPos;
  String atSpCh;
  bool atSp;
  String atEffect;
  Skill skill;
  Image teraIcon;
  String teraType;
  bool stellaFlag;
  bool stellaEffective;
}

class AttackStatePath{
  AttackStatePath({
    required this.poke,
    required this.teraImage,
    required this.atTera,
    required this.atActual,
    required this.atRankPos,
    required this.skill,
    required this.atEffect,
    required this.atSpCh,
    required this.atSp,
    required this.twoThirds,
    required this.second,
    required this.critical,
    required this.attackTime,
    required this.stellaEffective
  });
  Poke poke;
  Image teraImage;
  String atTera;
  int atActual;
  int atRankPos;
  Skill skill;
  String atEffect;
  String atSpCh;
  bool atSp;
  bool twoThirds;
  bool second;
  bool critical;
  int attackTime;
  bool stellaEffective;
}

class DfState{
  final Poke poke;
  final double hSlider;
  final double bSlider;
  final double dSlider;
  final int bNat;
  final int dNat;

  const DfState(this.poke, this.hSlider, this.bSlider, this.dSlider, this.bNat, this.dNat);
}

class DefenceState{
  DefenceState({
    required this.dfPoke,
    required this.hSliderVal,
    required this.hEffort,
    required this.bSliderVal,
    required this.bEffort,
    required this.bNatPos,
    required this.dSliderVal,
    required this.dEffort,
    required this.dNatPos,
    required this.bRankPos,
    required this.dRankPos,
    required this.dfSpCh,
    required this.dfSp,
    required this.dfTeraType,
    required this.dfTeraImage,
    required this.dfEffect,
  });
  Poke dfPoke;
  double hSliderVal;
  int hEffort;
  double bSliderVal;
  int bEffort;
  int bNatPos;
  double dSliderVal;
  int dEffort;
  int dNatPos;
  int bRankPos;
  int dRankPos;
  String dfSpCh;
  bool dfSp;
  String dfTeraType;
  Image dfTeraImage;
  String dfEffect;
}

class DefenceStatePath{
  final Poke poke;
  final int dfBRank;
  final int dfDRank;
  final String dfSpCh;
  final String dfEffect;
  final String dfTeraType;
  final bool dfSp;

  const DefenceStatePath(this.poke, this.dfBRank, this.dfDRank, this.dfSpCh, this.dfEffect, this.dfTeraType, this.dfSp);
}

class CircumstanceStatePath{
  final int constDamage;
  final String weather;
  final String field;
  final bool reflect;
  final bool lightWall;

  const CircumstanceStatePath(this.constDamage, this.weather, this.field, this.reflect, this.lightWall);
}

class DamageWidgetPath{
  final AttackStatePath atPath;
  final DefenceStatePath dfPath;
  final CircumstanceStatePath envPath;

  const DamageWidgetPath(this.atPath, this.dfPath, this.envPath);
}

class ReCalc{
  ReCalc({
    required this.id,
    required this.atPath,
    required this.dfPath,
    required this.envPath,
  });
  int id;
  AttackStatePath atPath;
  DefenceStatePath dfPath;
  CircumstanceStatePath envPath;
}

class DamageState{
  final Poke poke;
  final Poke dfPoke;
  final int aActual;
  final int hActual;
  final int bActual;
  final int dActual;
  final Skill skill;

  const DamageState(this.poke, this.dfPoke, this.aActual, this.hActual, this.bActual, this.dActual, this.skill);
}

class Item{
  Item({
    required this.itemName,
    required this.itemClassification,
  });

  String itemName;
  int itemClassification;
}

class Type{
  Type({
    required this.type,
    required this.typeImage,
    required this.typeIcon,
  });

  String type;
  Image typeImage;
  Image typeIcon;
}

class NumericalState{
  final String widgetType;
  final int actual;
  final double slider;
  final int effort;
  final int natPos;

  const NumericalState(this.widgetType, this.actual, this.slider, this.effort, this.natPos);
}

class DetailClassPath{
  final String aOrD;
  final Poke poke;
  final Image teraImage;

  const DetailClassPath(this.aOrD, this.poke, this.teraImage);
}

class NatClassPath{
  final String widgetType;
  final int natPos;
  final int rankPos;

  const NatClassPath(this.widgetType, this.natPos, this.rankPos);
}

class SpEffectClassPath{
  final String aOrD;
  final Poke poke;

  const SpEffectClassPath(this.aOrD, this.poke);
}

class ConstDamageClassPath{
  final int constVal;
  final String constStr;
  final int secondlyConstVal;
  final String secondlyConstStr;
  final List<int> constTimeList;
  final List<int> secondlyTimeList;

  const ConstDamageClassPath(this.constVal, this.constStr, this.constTimeList, this.secondlyConstVal, this.secondlyConstStr, this.secondlyTimeList);
}

class SerialSkill{
  final List<int> minMax;
  final int defaultTime;
  final List<String> serialSkillList;

  const SerialSkill(this.minMax, this.defaultTime, this.serialSkillList);
}

class IndicatePath{
  final Color indicatorColor;
  final double progress;
  final double progressWidth;

  const IndicatePath(this.indicatorColor, this.progress, this.progressWidth);
}

class ExtraInfoPath{
  final Skill skill;

  const ExtraInfoPath(this.skill);
}