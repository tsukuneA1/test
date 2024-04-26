import 'main.dart';
import 'poke_database.dart';

const List<String> panchSkill = <String>['アイスハンマー', 'アームハンマー', 'かみなりパンチ', 'きあいパンチ', 'グロウパンチ', 'コメットパンチ', 'シャドーパンチ', 'スカイアッパー', 'ドレインパンチ', 'ばくれつパンチ', 'バレットパンチ', 'ピヨピヨパンチ', 'プラズマフィスト', 'ほのおのパンチ', 'マッハパンチ', 'メガトンパンチ', 'れいとうパンチ', 'れんぞくパンチ', 'ダブルパンツァー', 'あんこくきょうだ', 'すいりゅうれんだ', 'ぶちかまし', 'ジェットパンチ', 'ふんどのこぶし'];
const List<String> riskSkill = <String>['アフロブレイク', 'ウッドハンマー', 'じごくぐるま', 'すてみタックル', 'とっしん', 'とびげり', 'とびひざげり', 'もろはのずつき', 'フレアドライブ', 'ブレイブバード', 'ボルテッカー', 'ワイルドボルト', 'ウェーブタックル', 'かかとおとし', 'サンダーダイブ'];
const List<String> noiseSkill = <String>['いびき', 'うたかたのアリア', 'エコーボイス', 'さわぐ', 'スケイルノイズ', 'チャームボイス', 'バークアウト', 'ハイパーボイス', 'ばくおんぱ', 'むしのさざめき', 'りんしょう', 'オーバードライブ', 'ぶきみなじゅもん', 'フレアソング', 'みわくのボイス', 'サイコノイズ'];
const List<String> cutSkill = <String>['アクアカッター', 'いあいぎり', 'エアカッター', 'エアスラッシュ', 'がんせきアックス', 'きょじゅうざん', 'きりさく', 'クロスポイズン', 'サイコカッター', 'サイコブレイド', 'シェルブレード', 'シザークロス', 'しんぴのつるぎ', 'せいなるつるぎ', 'ソーラーブレード', 'つじぎり', 'つばめがえし', 'ドゲザン', 'ネズミざん', 'はっぱカッター', 'ひけん・ちえなみ', 'むねんのつるぎ', 'リーフブレード', 'れんぞくぎり'];
const List<String> chinSkill = <String>['かみつく', 'かみくだく', 'ひっさつまえば', 'ほのおのキバ', 'かみなりのキバ', 'こおりのキバ', 'どくどくのキバ', 'サイコファング', 'エラがみ', 'くらいつく'];
const List<String> waveSkill = <String>['あくのはどう', 'はどうだん', 'りゅうのはどう', 'みずのはどう', 'だいちのはどう', 'こんげんのはどう'];

int strCalc(int damage, int hp){
  var count = 1;
  if(damage != 0){
    while((damage*count) < hp){
      count++;
    }
  }else{
    count = 0;
  }

  return count;
}

String damageStrCalc(int minCount, int maxCount, int hp, int maxDamage, List<int> minMax){
  var retStr = "";
  if(minCount == maxCount){
    retStr = '確定$minCount発';
  }else if(maxCount ==  0){

  }else{
    retStr = '乱数$maxCount発';
    var i = 0;
    while(minMax[i]*maxCount < hp){
      i++;
    }
    var retRand = 100-(i)/16*100;
    retStr += '$retRand%';
  }
  return retStr;
}

int actualCalc(int tribe, int effort, int natPos){
  var actual = ((tribe*2+31+effort/4)*0.5+5).toInt();
  if(natPos == 0){
    actual = (((tribe*2+31+effort/4)*0.5+5)*1.1).toInt();
  }
  if(natPos == 2){
    actual = (((tribe*2+31+effort/4)*0.5+5)*0.9).toInt();
  }
  return actual;
}

List<int> damageCalculate(Poke atPoke, Poke dfPoke, int atActual, int dfActual, double typeMag, double atMag, String atEffect, String dfEffect, Skill skill, int skillPower, int atRankPos, bool critical, String weather){
  double maxDamage = ((22*skillPower*atActual/dfActual).truncate()/50+2).truncate().toDouble();
  maxDamage *= weatherMagnification(skill, weather);
  if(critical){
    maxDamage = (maxDamage*6144/4096).truncate().toDouble();
  }
  List<int> randDamageList = [];
  for(int i = 85; i <= 100; i++){
    var damage = (maxDamage*i/100).floor();
    randDamageList.add((specialRound(damage*atMag)*typeMag).truncate());
  }

  double minDamage = (maxDamage*0.85).truncate().toDouble();
  maxDamage = (specialRound(maxDamage*atMag)*typeMag).truncateToDouble();
  minDamage = (specialRound(minDamage*atMag)*typeMag).truncateToDouble();

  return randDamageList;
}

int finalAtActualCalc(Poke atPoke, Poke dfPoke, int atActual, String atSpCh, String dfSpCh, String atEffect, Skill skill, int rankPos){
  double retActual = atActual.toDouble();
  switch(atSpCh){
    case 'スロースタート':
      if(skill.classification == '物理'){retActual *= 0.5;}
    case 'よわき':
      retActual *= 0.5;
    case 'トランジスタ':
      if(skill.type == 'でんき'){
        retActual *= 5325/4096;
      }
    case 'クォークチャージ':
      retActual = (atActual*5325/4096);
    case 'こだいかっせい':
      retActual = (atActual*5325/4096);
    case 'ハドロンエンジン':
      retActual = (atActual*5461/4096);
    case 'ひひいろのこどう':
      retActual = (atActual*5461/4096);
    case 'フラワーギフト':
      retActual *= 1.5;
    case 'こんじょう':
      retActual *= 1.5;
    case 'しんりょく':
      if(skill.type == 'くさ'){
        retActual *= 1.5;
      }
    case 'もうか':
      if(skill.type == 'ほのお'){
        retActual *= 1.5;
      }
    case 'げきりゅう':
      if(skill.type == 'みず'){
        retActual *= 1.5;
      }
    case 'むしのしらせ':
      if(skill.type == 'むし'){
        retActual *= 1.5;
      }
    case 'もらいび':
      if(skill.type == 'ほのお'){
        retActual *= 1.5;
      }
    case 'サンパワー':
      if(skill.classification == '特殊'){
        retActual *= 1.5;
      }
    case 'プラス' || 'マイナス':
      retActual *= 1.5;
    case 'いわはこび':
      if(skill.type == 'いわ'){retActual *= 1.5;}
    case 'はがねつかい':
      if(skill.type == 'はがね'){retActual *= 1.5;}
    case 'りゅうのあぎと':
      if(skill.type == 'ドラゴン'){retActual *= 1.5;}
    case 'ごりむちゅう':
      if(skill.classification == '物理'){retActual *= 1.5;}
    case 'ちからもち' || 'ヨガパワー':
      if(skill.classification == '物理'){retActual *= 2.0;}
    case 'すいほう':
      if(skill.type == 'みず'){retActual *= 2.0;}
    case 'はりこみ':
      retActual *= 2.0;
  }
  atActual.roundToDouble();

  switch(atEffect){
    case 'こだわりハチマキ':
      if(skill.classification == '物理'){
        retActual *= 1.5;
      }
    case 'こだわりメガネ':
      if(skill.classification == '特殊'){retActual *= 6144/4096;}
    case 'ふといホネ':
      if(atPoke.pokeName == 'ガラガラ' || atPoke.pokeName == 'カラカラ' || atPoke.pokeName == 'ガラガラ(アローラ)'){
        if(skill.classification == '物理'){retActual *= 2.0;}
      }
    case 'でんきだま':
      if(atPoke.pokeName == 'ピカチュウ'){retActual *= 2.0;}
  }
  atActual.roundToDouble();

  switch(dfSpCh){
    case 'わざわいのうつわ':
      if(skill.classification == '特殊'){
        if(atSpCh != 'わざわいのつるぎ' && atSpCh != 'わざわいのたま' && atSpCh != 'わざわいのおふだ'){retActual *= 3/4;}
      }
    case 'わざわいのおふだ':
      if(skill.classification == '物理'){
        if(atSpCh != 'わざわいのつるぎ' && atSpCh != 'わざわいのたま' && atSpCh != 'わざわいのうつわ'){retActual *= 3/4;}
      }
    case 'あついしぼう':
      if(skill.type == 'ほのお' || skill.type == 'こおり'){retActual *= 0.5;}
    case 'たいねつ':
      if(skill.type == 'ほのお'){retActual *= 0.5;}
    case 'きよめのしお':
      if(skill.type== 'ゴースト'){retActual *= 0.5;}
    case 'すいほう':
      if(skill.type == 'ほのお'){retActual *= 0.5;}
  }
  retActual.roundToDouble();

  if(rankPos <= 6){
    retActual *= (8-rankPos)/2;
  }else{
    retActual *= 2/(rankPos-4);
  }


  return retActual.round();
}

int finalDfActualCalc(int dfActual, String atSpCh, String dfSpCh, String dfEffect, int rankPos, Skill skill, String dfType1, String dfType2, String weather){
  double retAct = dfActual.toDouble();

  if(rankPos <= 6){
    retAct *= (8-rankPos)/2;
  }else{
    retAct *= 2/(rankPos-4);
  }
  retAct.truncateToDouble();

  switch(weather){
    case 'すなあらし':
      if(dfType1 == 'いわ' || dfType2 == 'いわ'){
        if(skill.classification == '特殊'){
          retAct *= 6144/4096;
        }
      }
    case 'あられ':
      if(dfType1 == 'こおり' || dfType2 == 'こおり'){
        if(skill.classification == '物理'){
          retAct *= 6144/4096;
        }
      }
  }
  retAct.truncateToDouble();

  switch(atSpCh){
    case 'わざわいのつるぎ':
      if(skill.classification == '物理'){
        if(dfSpCh != 'わざわいのうつわ' && dfSpCh != 'わざわいのたま' && dfSpCh != 'わざわいのおふだ'){
          retAct *= 3/4;
        }
      }
    case 'わざわいのたま':
      if(skill.classification == '特殊'){
        if(dfSpCh != 'わざわいのつるぎ' && dfSpCh != 'わざわいのうつわ' && dfSpCh != 'わざわいのおふだ'){
          retAct *= 3/4;
        }
      }
  }

  switch(dfSpCh){
    case 'クォークチャージ' || 'こだいかっせい':
      retAct *= 1.3;
    case 'ふしぎなうろこ' || 'くさのけがわ':
      if(skill.classification == '物理'){
        retAct *= 1.5;
      }
    case 'ファーコート':
      if(skill.classification == '物理'){
        retAct *= 2.0;
      }
    case 'フラワーギフト':
      if(skill.classification == '特殊'){
        retAct *= 1.5;
      }
  }

  switch(dfEffect){
    case 'とつげきチョッキ':
      if(skill.classification == '特殊'){
        retAct *= 1.5;
      }
  }
  retAct.truncate();

  return retAct.truncate();
}

int finalSkillPowerCalc(Poke atPoke, Skill skill, String atSpCh, String atEffect, String field){
  String name = skill.name;
  double skillPower = skill.power.toDouble();
  switch(atEffect){
    case 'パンチグローブ':
      if(panchSkill.contains(skill.name)){skillPower *= 1.1;}
    case 'タイプ強化系' || 'お面':
      skillPower *= 1.2;
    case 'ちからのハチマキ':
      if(skill.classification == '物理'){skillPower *= 1.1;}
    case 'ものしりメガネ':
      if(skill.classification == '特殊'){skillPower *= 1.1;}
    case 'こんごうだま':
      if(atPoke.pokeName == 'ディアルガ'){
        if(skill.type == 'ドラゴン' || skill.type == 'はがね'){
          skillPower *= 4915/4096;
        }
      }
    case 'しらたま':
      if(atPoke.pokeName == 'パルキア'){
        if(skill.type == 'ドラゴン' || skill.type == 'みず'){
          skillPower *= 4915/4096;
        }
      }
    case 'はっきんだま':
      if(atPoke.pokeName == 'ギラティナ'){
        if(skill.type == 'ドラゴン' || skill.type == 'ゴースト'){
          skillPower *= 4915/4096;
        }
      }
    case 'こころのしずく':
      if(atPoke.pokeName == 'ラティアス' || atPoke.pokeName == 'ラティオス'){
        if(skill.type == 'ドラゴン' || skill.type == 'エスパー'){
          skillPower *= 4915/4096;
        }
      }
    case 'ノーマルジュエル':
      if(skill.type == 'ノーマル'){
        skillPower *= 5325/4096;
      }
  }

  switch(field){
    case 'エレキフィールド':
      if(skill.type == 'でんき'){
        skillPower *= (5325/4096);
        if(skill.name == 'ライジングボルト'){skillPower *= 2;}
      }
    case 'グラスフィールド':
      if(skill.type == 'くさ'){
        skillPower *= (5325/4096);
      }
      if(skill.name == 'じしん'){
        skillPower *= 0.5;
      }
    case 'サイコフィールド':
      if(skill.type == 'エスパー'){
        skillPower *= (5325/4096);
        if(skill.name == 'サイコブレイド'){skillPower *= 6144/4096;}
        if(skill.name == 'ワイドフォース'){skillPower *= 6144/4096;}
      }
    case 'ミストフィールド':
      if(skill.type == 'ドラゴン'){skillPower *= 0.5;}
  }

  switch(atSpCh){
    case 'エレキスキン' || 'スカイスキン' || 'フェアリースキン' || 'フリーズスキン':
      if(skill.type == 'ノーマル'){
        skillPower *= 4915/4096;
      }
    case 'てつのこぶし':
      if(panchSkill.contains(skill.name)){
        skillPower *= 4915/4096;
      }
    case 'すてみ':
      if(riskSkill.contains(skill.name)){
        skillPower *= 4915/4096;
      }
    case 'とうそうしん':
      skillPower *= 5120/4096;
    case 'ちからずく':
      skillPower *= 5325/4096;
    case 'すなのちから':
      if(skill.type == 'いわ' || skill.type == 'じめん' || skill.type == 'はがね'){
        skillPower *= 5325/4096;
      }
    case 'アナライズ':
      skillPower *= 5325/4096;
    case 'かたいつめ':
      if(skill.classification == '物理'){
        skillPower *= 5325/4096;
      }
    case 'パンクロック':
      if(noiseSkill.contains(skill.name)){
        skillPower *= 5325/4096;
      }
    case 'きれあじ':
      if(cutSkill.contains(skill.name)){
        skillPower *= 6144/4096;
      }
    case 'テクニシャン':
      if(skill.power <= 60){skillPower *= 6144/4096;}
    case 'ねつぼうそう':
      if(skill.classification == '特殊'){skillPower *= 6144/4096;}
    case 'どくぼうそう':
      if(skill.classification == '物理'){skillPower *= 6144/4096;}
    case 'がんじょうあご':
      if(chinSkill.contains(skill.name)){skillPower *= 6144/4096;}
    case 'メガランチャー':
      if(waveSkill.contains(skill.name)){skillPower *= 6144/4096;}
    case 'はがねのせいしん':
      if(skill.type == 'はがね'){skillPower *= 6144/4096;}


  }
  return skillPower.truncate();
}

double finalDamageMagnification(Poke atPoke, Poke dfPoke, Skill skill, bool reflect, bool light, String atSpCh, String atEffect, String dfSpCh, String dfEffect, double typeMag){
  double retDamage = 1;
  if(reflect){
    if(skill.classification == '物理'){
      retDamage *= 0.5;
    }
  }
  if(light){
    if(skill.classification == '特殊'){
      retDamage *= 0.5;
    }
  }

  switch(skill.name){
    case 'アクセルブレイク' || 'イナズマドライブ':
      if(typeMag >= 2.0){
        retDamage *= 5461/4096;
      }
  }

  switch(atEffect){
    case '命の珠':
      retDamage *= 5324/4096;
    case 'たつじんのおび':
      retDamage *= 4915/4096;
  }

  switch(dfSpCh){
    case 'マルチスケイル' || 'ファントムガード':
      retDamage *= 0.5;
    case 'もふもふ':
      if(skill.type == 'ほのお'){
        retDamage *= 2.0;
      }
    case 'パンクロック':
      if(noiseSkill.contains(skill.name)){
        retDamage *= 0.5;
      }
    case 'こおりのりんぷん':
      if(skill.classification == '特殊'){
        retDamage *= 0.5;
      }
    case 'プリズムアーマー' || 'ハードロック' || 'フィルター':
      if(typeMag >= 2.0){
        retDamage *= 3072/4096;
      }
  }

  switch(dfEffect){
    case '半減きのみ':
      retDamage *= 0.5;
  }
  return retDamage;
}

double typeMagnification(Skill skill, String type1, atSpCh){
  double magnification = 1.0;
  String skillType = skill.type;
  switch(skillType){
    case 'ノーマル' :
      if(type1 == 'ゴースト'){
        magnification = 0;
        if(atSpCh == 'しんがん'){
          magnification = 1;
        }
      }else if(type1 == 'はがね' || type1 == 'いわ'){
        magnification *= 0.5;
      }
    case 'ほのお':
      if(type1 == 'ほのお' || type1 == 'みず' || type1 == 'いわ' || type1 == 'ドラゴン'){
        magnification *= 0.5;
      }else if(type1 == 'くさ' || type1 == 'こおり' || type1 == 'むし' || type1 == 'はがね'){
        magnification *= 2.0;
      }
    case 'みず':
      if(type1 == 'みず' || type1 == 'くさ' || type1 == 'ドラゴン'){
        magnification *= 0.5;
      }else if(type1 == 'ほのお' || type1 == 'じめん' || type1 == 'いわ'){
        magnification *= 2.0;
      }
    case 'でんき':
      if(type1 == 'みず' || type1 == 'ひこう'){
        magnification *= 2.0;
      }else if(type1 == 'でんき' || type1 == 'くさ' || type1 == 'ドラゴン'){
        magnification *= 0.5;
      }else if(type1 == 'じめん'){
        magnification = 0.0;
      }
    case 'くさ':
      if(type1 == 'ほのお' || type1 == 'くさ' || type1 == 'どく' || type1 == 'ひこう' || type1 == 'むし' || type1 == 'ドラゴン' || type1 == 'はがね'){
        magnification *= 0.5;
      }else if(type1 == 'みず' || type1 == 'じめん' || type1 == 'いわ'){
        magnification *= 2.0;
      }
    case 'こおり':
      if(type1 == 'くさ' || type1 == 'じめん' || type1 == 'ひこう' || type1 == 'ドラゴン'){
        magnification *= 2.0;
      }else if(type1 == 'ほのお' ||type1 == 'みず' || type1 == 'こおり' || type1 == 'はがね'){
        magnification *= 0.5;
        if(skill.name == 'フリーズドライ' && type1 == 'みず'){
          magnification *= 4.0;
        }
      }
    case 'どく':
      if(type1 == 'どく' || type1 == 'いわ' || type1 == 'ゴースト' || type1 == 'じめん'){
        magnification *= 0.5;
      }else if(type1 == 'くさ' || type1 == 'フェアリー'){
        magnification *= 2.0;
      }else if(type1 == 'はがね'){
        magnification = 0.0;
      }
    case 'かくとう':
      if(type1 == 'ノーマル' || type1 == 'こおり' || type1 == 'あく' || type1 == 'いわ' || type1 == 'はがね'){
        magnification *= 2.0;
      }else if(type1 == 'どく' || type1 == 'ひこう' || type1 == 'エスパー' || type1 == 'むし' || type1 == 'フェアリー'){
        magnification *= 0.5;
      }else if(type1 == 'ゴースト'){
        if(atSpCh != 'しんがん'){
          magnification = 0.0;
        }
      }
    case 'じめん':
      if(type1 == 'ほのお'|| type1 == 'でんき'|| type1 == 'どく'|| type1 == 'いわ'|| type1 == 'はがね'){
        magnification *= 2.0;
      }else if(type1 == 'くさ' || type1 == 'むし'){
        magnification *= 0.5;
      }
      else if(type1 == 'ひこう'){
        magnification = 0.0;
      }
    case 'ひこう':
      if(type1 == 'でんき' || type1 == 'いわ' || type1 == 'はがね'){
        magnification *= 0.5;
      }else if(type1 == 'くさ' || type1 == 'かくとう' || type1 == 'むし'){
        magnification *= 2.0;
      }
    case 'エスパー':
      if(type1 == 'かくとう' || type1 == 'どく'){
        magnification *= 2.0;
      }else if(type1 == 'エスパー' || type1 == 'はがね'){
        magnification *= 0.5;
      }else if(type1 == 'あく'){
        magnification = 0.0;
      }
    case 'むし':
      if(type1 == 'ほのお' || type1 == 'かくとう' || type1 == 'どく' || type1 == 'ひこう' || type1 == 'ゴースト' || type1 == 'はがね' || type1 == 'フェアリー'){
        magnification *= 0.5;
      }else if(type1 == 'くさ' || type1 == 'エスパー' || type1 == 'むし'){
        magnification *= 2.0;
      }
    case 'いわ':
      if(type1 == 'ほのお' || type1 == 'こおり' || type1 == 'ひこう' || type1 == 'むし'){
        magnification *= 2.0;
      }else if(type1 == 'かくとう' || type1 == 'じめん' || type1 == 'はがね' || type1 == 'いわ'){
        magnification *= 0.5;
      }
    case 'ゴースト':
      if(type1 == 'エスパー'|| type1 == 'ゴースト'){
        magnification *= 2.0;
      }else if(type1 == 'あく'){
        magnification *= 0.5;
      }else if(type1 == 'ノーマル'){
        magnification *=0;
      }
    case 'ドラゴン':
      if(type1 == 'ドラゴン'){
        magnification *= 2.0;
      }else if(type1 == 'はがね'){
        magnification *= 0.5;
      }else if(type1 == 'フェアリー'){
        magnification *= 0.0;
      }
    case 'あく':
      if(type1 == 'エスパー' || type1 == 'ゴースト'){
        magnification *= 2.0;
      }else if(type1 == 'かくとう' || type1 == 'あく' || type1 == 'フェアリー'){
        magnification *= 0.5;
      }
    case 'はがね':
      if(type1 == 'ほのお'|| type1 == 'みず'|| type1 == 'でんき'|| type1 == 'はがね'){
        magnification *=0.5;
      }else if(type1 == 'こおり' || type1 == 'いわ' || type1 == 'フェアリー'){
        magnification *= 2.0;
      }
    case 'フェアリー':
      if(type1 == 'ほのお' || type1 == 'どく' || type1 == 'はがね'){
        magnification = 0.5;
      }else if(type1 == 'かくとう' || type1 == 'ドラゴン' || type1 == 'あく'){
        magnification = 2.0;
      }
  }

  return magnification;
}

double atMagnification(String skillType, String atType1, String atType2, String atTera){
  double magnification = 1.0;
  if((atTera == skillType && (atTera == atType1 || atTera == atType2)) || (atTera == 'ステラ' && (skillType == atType1 || skillType == atType2))){
    if(skillType != 'ステラ'){
      magnification *= 2.0;
    }
  } else if(skillType == atTera && skillType != 'ステラ'){
    magnification *= 6144/4096;
  }else if(atTera == 'ステラ'){
    magnification *= 1.2;
  } else{
    if(skillType == atType1 || skillType == atType2){
      magnification *= 6144/4096;
    }
  }

  return magnification;
}

double weatherMagnification(Skill skill, String weather){
  var retMag = 1.0;
  if(skill.type == 'ほのお'){
    if(weather == 'はれ'){
      retMag *= 1.5;
    }else if(weather == 'あめ'){
      retMag *= 0.5;
    }
  }else if(skill.type == 'みず'){
    if(weather == 'あめ'){
      retMag *= 1.5;
    }else if(weather == 'はれ'){
      retMag *= 0.5;
    }
  }
  return retMag;
}

double specialRound(double input){
  var retAct = input;
  if((input-input.truncate()) == 0.5){
    retAct = input.truncateToDouble();
  }else{
    retAct = input.roundToDouble();
  }
  return retAct;
}