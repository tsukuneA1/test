import 'package:sqflite/sqflite.dart';
import 'main.dart';

List<Ability> charList = [];

class Ability{
    Ability({
        required this.ability,
        required this.another
    });
    String ability;
    String another;
}

late String path;
late Database charDb;

class CharDbHelper{
  static Future<List> charDatabase() async{
    var databasesPath = await getDatabasesPath();
    path = '$databasesPath/demo3.db';

    charDb = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async{
        await db.execute('CREATE TABLE AbilityInfo(ability TEXT, another TEXT)');

        await db.insert('AbilityInfo', {'ability': 'あくしゅう', 'another': 'アクシュウ'});
        await db.insert('AbilityInfo', {'ability': 'あめふらし', 'another': 'アメフラシ'});
        await db.insert('AbilityInfo', {'ability': 'かそく', 'another': 'カソク'});
        await db.insert('AbilityInfo', {'ability': 'カブトアーマー', 'another': 'かぶとあーまー'});
        await db.insert('AbilityInfo', {'ability': 'がんじょう', 'another': 'ガンジョウ'});
        await db.insert('AbilityInfo', {'ability': 'しめりけ', 'another': 'シメリケ'});
        await db.insert('AbilityInfo', {'ability': 'じゅうなん', 'another': 'ジュウナン'});
        await db.insert('AbilityInfo', {'ability': 'すながくれ', 'another': 'スナガクレ'});
        await db.insert('AbilityInfo', {'ability': 'せいでんき', 'another': 'セイデンキ'});
        await db.insert('AbilityInfo', {'ability': 'ちくでん', 'another': 'チクデン'});
        await db.insert('AbilityInfo', {'ability': 'ちょすい', 'another': 'チョスイ'});
        await db.insert('AbilityInfo', {'ability': 'どんかん', 'another': 'ドンカン'});
        await db.insert('AbilityInfo', {'ability': 'ノーてんき', 'another': 'のーてんき'});
        await db.insert('AbilityInfo', {'ability': 'ふくがん', 'another': 'フクガン'});
        await db.insert('AbilityInfo', {'ability': 'ふみん', 'another': 'フミン'});
        await db.insert('AbilityInfo', {'ability': 'へんしょく', 'another': 'ヘンショク'});
        await db.insert('AbilityInfo', {'ability': 'めんえき', 'another': 'メンエキ'});
        await db.insert('AbilityInfo', {'ability': 'もらいび', 'another': 'モライビ'});
        await db.insert('AbilityInfo', {'ability': 'りんぷん', 'another': 'リンプン'});
        await db.insert('AbilityInfo', {'ability': 'マイペース', 'another': 'まいぺーす'});
        await db.insert('AbilityInfo', {'ability': 'きゅうばん', 'another': 'キュウバン'});
        await db.insert('AbilityInfo', {'ability': 'いかく', 'another': 'イカク'});
        await db.insert('AbilityInfo', {'ability': 'かげふみ', 'another': 'カゲフミ'});
        await db.insert('AbilityInfo', {'ability': 'さめはだ', 'another': 'サメハダ'});
        await db.insert('AbilityInfo', {'ability': 'ふしぎなまもり', 'another': 'フシギナマモリ'});
        await db.insert('AbilityInfo', {'ability': 'ふゆう', 'another': 'フユウ'});
        await db.insert('AbilityInfo', {'ability': 'ほうし', 'another': 'ホウシ'});
        await db.insert('AbilityInfo', {'ability': 'シンクロ', 'another': 'しんくろ'});
        await db.insert('AbilityInfo', {'ability': 'クリアボディ', 'another': 'くりあぼでぃ'});
        await db.insert('AbilityInfo', {'ability': 'しぜんかいふく', 'another': 'シゼンカイフク'});
        await db.insert('AbilityInfo', {'ability': 'ひらいしん', 'another': 'ヒライシン'});
        await db.insert('AbilityInfo', {'ability': 'てんのめぐみ', 'another': 'テンノメグミ'});
        await db.insert('AbilityInfo', {'ability': 'すいすい', 'another': 'スイスイ'});
        await db.insert('AbilityInfo', {'ability': 'ようりょくそ', 'another': 'ヨウリョクソ'});
        await db.insert('AbilityInfo', {'ability': 'はっこう', 'another': 'ハッコウ'});
        await db.insert('AbilityInfo', {'ability': 'トレース', 'another': 'とれーす'});
        await db.insert('AbilityInfo', {'ability': 'ちからもち', 'another': 'チカラモチ'});
        await db.insert('AbilityInfo', {'ability': 'どくのトゲ', 'another': 'どくのとげ'});
        await db.insert('AbilityInfo', {'ability': 'せいしんりょく', 'another': 'セイシンリョク'});
        await db.insert('AbilityInfo', {'ability': 'マグマのよろい', 'another': 'まぐまのよろい'});
        await db.insert('AbilityInfo', {'ability': 'みずのベール', 'another': 'みずのべーる'});
        await db.insert('AbilityInfo', {'ability': 'じりょく', 'another': 'ジリョク'});
        await db.insert('AbilityInfo', {'ability': 'ぼうおん', 'another': 'ボウオン'});
        await db.insert('AbilityInfo', {'ability': 'あめうけざら', 'another': 'アメウケザラ'});
        await db.insert('AbilityInfo', {'ability': 'すなおこし', 'another': 'スナオコシ'});
        await db.insert('AbilityInfo', {'ability': 'プレッシャー', 'another': 'ぷれっしゃー'});
        await db.insert('AbilityInfo', {'ability': 'あついしぼう', 'another': 'アツイシボウ'});
        await db.insert('AbilityInfo', {'ability': 'はやおき', 'another': 'ハヤオキ'});
        await db.insert('AbilityInfo', {'ability': 'ほのおのからだ', 'another': 'ホノオノカラダ'});
        await db.insert('AbilityInfo', {'ability': 'にげあし', 'another': 'ニゲアシ'});
        await db.insert('AbilityInfo', {'ability': 'するどいめ', 'another': 'スルドイメ'});
        await db.insert('AbilityInfo', {'ability': 'かいりきバサミ', 'another': 'かいりきばさみ'});
        await db.insert('AbilityInfo', {'ability': 'ものひろい', 'another': 'モノヒロイ'});
        await db.insert('AbilityInfo', {'ability': 'なまけ', 'another': 'ナマケ'});
        await db.insert('AbilityInfo', {'ability': 'はりきり', 'another': 'ハリキリ'});
        await db.insert('AbilityInfo', {'ability': 'メロメロボディ', 'another': 'めろめろぼでぃ'});
        await db.insert('AbilityInfo', {'ability': 'プラス', 'another': 'ぷらす'});
        await db.insert('AbilityInfo', {'ability': 'マイナス', 'another': 'まいなす'});
        await db.insert('AbilityInfo', {'ability': 'てんきや', 'another': 'テンキヤ'});
        await db.insert('AbilityInfo', {'ability': 'ねんちゃく', 'another': 'ネンチャク'});
        await db.insert('AbilityInfo', {'ability': 'だっぴ', 'another': 'ダッピ'});
        await db.insert('AbilityInfo', {'ability': 'こんじょう', 'another': 'コンジョウ'});
        await db.insert('AbilityInfo', {'ability': 'ふしぎなうろこ', 'another': 'フシギナウロコ'});
        await db.insert('AbilityInfo', {'ability': 'ヘドロえき', 'another': 'へどろえき'});
        await db.insert('AbilityInfo', {'ability': 'しんりょく', 'another': 'シンリョク'});
        await db.insert('AbilityInfo', {'ability': 'もうか', 'another': 'モウカ'});
        await db.insert('AbilityInfo', {'ability': 'げきりゅう', 'another': 'ゲキリュウ'});
        await db.insert('AbilityInfo', {'ability': 'むしのしらせ', 'another': 'ムシノシラセ'});
        await db.insert('AbilityInfo', {'ability': 'いしあたま', 'another': 'イシアタマ'});
        await db.insert('AbilityInfo', {'ability': 'ひでり', 'another': 'ヒデリ'});
        await db.insert('AbilityInfo', {'ability': 'ありじごく', 'another': 'アリジゴク'});
        await db.insert('AbilityInfo', {'ability': 'やるき', 'another': 'ヤルキ'});
        await db.insert('AbilityInfo', {'ability': 'しろいけむり', 'another': 'シロイケムリ'});
        await db.insert('AbilityInfo', {'ability': 'ヨガパワー', 'another': 'よがぱわー'});
        await db.insert('AbilityInfo', {'ability': 'シェルアーマー', 'another': 'しぇるあーまー'});
        await db.insert('AbilityInfo', {'ability': 'エアロック', 'another': 'えあろっく'});
        await db.insert('AbilityInfo', {'ability': 'ちどりあし', 'another': 'チドリアシ'});
        await db.insert('AbilityInfo', {'ability': 'でんきエンジン', 'another': 'でんきえんじん'});
        await db.insert('AbilityInfo', {'ability': 'とうそうしん', 'another': 'トウソウシン'});
        await db.insert('AbilityInfo', {'ability': 'ふくつのこころ', 'another': 'フクツノココロ'});
        await db.insert('AbilityInfo', {'ability': 'ゆきがくれ', 'another': 'ユキガクレ'});
        await db.insert('AbilityInfo', {'ability': 'くいしんぼう', 'another': 'クイシンボウ'});
        await db.insert('AbilityInfo', {'ability': 'いかりのつぼ', 'another': 'イカリノツボ'});
        await db.insert('AbilityInfo', {'ability': 'かるわざ', 'another': 'カルワザ'});
        await db.insert('AbilityInfo', {'ability': 'たいねつ', 'another': 'タイネツ'});
        await db.insert('AbilityInfo', {'ability': 'たんじゅん', 'another': 'タンジュン'});
        await db.insert('AbilityInfo', {'ability': 'かんそうはだ', 'another': 'カンソウハダ'});
        await db.insert('AbilityInfo', {'ability': 'ダウンロード', 'another': 'だうんろーど'});
        await db.insert('AbilityInfo', {'ability': 'てつのこぶし', 'another': 'テツノコブシ'});
        await db.insert('AbilityInfo', {'ability': 'ポイズンヒール', 'another': 'ぽいずんひーる'});
        await db.insert('AbilityInfo', {'ability': 'てきおうりょく', 'another': 'テキオウリョク'});
        await db.insert('AbilityInfo', {'ability': 'スキルリンク', 'another': 'すきるりんく'});
        await db.insert('AbilityInfo', {'ability': 'うるおいボディ', 'another': 'うるおいぼでぃ'});
        await db.insert('AbilityInfo', {'ability': 'サンパワー', 'another': 'さんぱわー'});
        await db.insert('AbilityInfo', {'ability': 'はやあし', 'another': 'ハヤアシ'});
        await db.insert('AbilityInfo', {'ability': 'ノーマルスキン', 'another': 'のーまるすきん'});
        await db.insert('AbilityInfo', {'ability': 'スナイパー', 'another': 'すないぱー'});
        await db.insert('AbilityInfo', {'ability': 'マジックガード', 'another': 'まじっくがーど'});
        await db.insert('AbilityInfo', {'ability': 'ノーガード', 'another': 'のーがーど'});
        await db.insert('AbilityInfo', {'ability': 'あとだし', 'another': 'アトダシ'});
        await db.insert('AbilityInfo', {'ability': 'テクニシャン', 'another': 'てくにしゃん'});
        await db.insert('AbilityInfo', {'ability': 'リーフガード', 'another': 'りーふがーど'});
        await db.insert('AbilityInfo', {'ability': 'ぶきよう', 'another': 'ブキヨウ'});
        await db.insert('AbilityInfo', {'ability': 'かたやぶり', 'another': 'カタヤブリ'});
        await db.insert('AbilityInfo', {'ability': 'きょううん', 'another': 'キョウウン'});
        await db.insert('AbilityInfo', {'ability': 'ゆうばく', 'another': 'ユウバク'});
        await db.insert('AbilityInfo', {'ability': 'きけんよち', 'another': 'キケンヨチ'});
        await db.insert('AbilityInfo', {'ability': 'よちむ', 'another': 'ヨチム'});
        await db.insert('AbilityInfo', {'ability': 'てんねん', 'another': 'テンネン'});
        await db.insert('AbilityInfo', {'ability': 'いろめがね', 'another': 'イロメガネ'});
        await db.insert('AbilityInfo', {'ability': 'フィルター', 'another': 'ふぃるたー'});
        await db.insert('AbilityInfo', {'ability': 'スロースタート', 'another': 'すろーすたーと'});
        await db.insert('AbilityInfo', {'ability': 'きもったま', 'another': 'キモッタマ'});
        await db.insert('AbilityInfo', {'ability': 'よびみず', 'another': 'ヨビミズ'});
        await db.insert('AbilityInfo', {'ability': 'アイスボディ', 'another': 'あいすぼでぃ'});
        await db.insert('AbilityInfo', {'ability': 'ハードロック', 'another': 'はーどろっく'});
        await db.insert('AbilityInfo', {'ability': 'ゆきふらし', 'another': 'ユキフラシ'});
        await db.insert('AbilityInfo', {'ability': 'みつあつめ', 'another': 'ミツアツメ'});
        await db.insert('AbilityInfo', {'ability': 'おみとおし', 'another': 'オミトオシ'});
        await db.insert('AbilityInfo', {'ability': 'すてみ', 'another': 'ステミ'});
        await db.insert('AbilityInfo', {'ability': 'マルチタイプ', 'another': 'まるちたいぷ'});
        await db.insert('AbilityInfo', {'ability': 'フラワーギフト', 'another': 'ふらわーぎふと'});
        await db.insert('AbilityInfo', {'ability': 'ナイトメア', 'another': 'ないとめあ'});
        await db.insert('AbilityInfo', {'ability': 'わるいてぐせ', 'another': 'ワルイテグセ'});
        await db.insert('AbilityInfo', {'ability': 'ちからずく', 'another': 'チカラズク'});
        await db.insert('AbilityInfo', {'ability': 'あまのじゃく', 'another': 'アマノジャク'});
        await db.insert('AbilityInfo', {'ability': 'きんちょうかん', 'another': 'キンチョウカン'});
        await db.insert('AbilityInfo', {'ability': 'まけんき', 'another': 'マケンキ'});
        await db.insert('AbilityInfo', {'ability': 'よわき', 'another': 'ヨワキ'});
        await db.insert('AbilityInfo', {'ability': 'のろわれボディ', 'another': 'のろわれぼでぃ'});
        await db.insert('AbilityInfo', {'ability': 'いやしのこころ', 'another': 'イヤシノココロ'});
        await db.insert('AbilityInfo', {'ability': 'フレンドガード', 'another': 'ふれんどがーど'});
        await db.insert('AbilityInfo', {'ability': 'くだけるよろい', 'another': 'クダケルヨロイ'});
        await db.insert('AbilityInfo', {'ability': 'ヘヴィメタル', 'another': 'へゔぃめたる'});
        await db.insert('AbilityInfo', {'ability': 'ライトメタル', 'another': 'らいとめたる'});
        await db.insert('AbilityInfo', {'ability': 'マルチスケイル', 'another': 'まるちすけいる'});
        await db.insert('AbilityInfo', {'ability': 'どくぼうそう', 'another': 'ドクボウソウ'});
        await db.insert('AbilityInfo', {'ability': 'ねつぼうそう', 'another': 'ネツボウソウ'});
        await db.insert('AbilityInfo', {'ability': 'しゅうかく', 'another': 'シュウカク'});
        await db.insert('AbilityInfo', {'ability': 'テレパシー', 'another': 'てれぱしー'});
        await db.insert('AbilityInfo', {'ability': 'ムラっけ', 'another': 'むらっけ'});
        await db.insert('AbilityInfo', {'ability': 'ぼうじん', 'another': 'ボウジン'});
        await db.insert('AbilityInfo', {'ability': 'どくしゅ', 'another': 'ドクシュ'});
        await db.insert('AbilityInfo', {'ability': 'さいせいりょく', 'another': 'サイセイリョク'});
        await db.insert('AbilityInfo', {'ability': 'はとむね', 'another': 'ハトムネ'});
        await db.insert('AbilityInfo', {'ability': 'すなかき', 'another': 'スナカキ'});
        await db.insert('AbilityInfo', {'ability': 'ミラクルスキン', 'another': 'みらくるすきん'});
        await db.insert('AbilityInfo', {'ability': 'アナライズ', 'another': 'あならいず'});
        await db.insert('AbilityInfo', {'ability': 'イリュージョン', 'another': 'いりゅーじょん'});
        await db.insert('AbilityInfo', {'ability': 'かわりもの', 'another': 'カワリモノ'});
        await db.insert('AbilityInfo', {'ability': 'すりぬけ', 'another': 'スリヌケ'});
        await db.insert('AbilityInfo', {'ability': 'ミイラ', 'another': 'みいら'});
        await db.insert('AbilityInfo', {'ability': 'じしんかじょう', 'another': 'ジシンカジョウ'});
        await db.insert('AbilityInfo', {'ability': 'せいぎのこころ', 'another': 'セイギノココロ'});
        await db.insert('AbilityInfo', {'ability': 'びびり', 'another': 'ビビリ'});
        await db.insert('AbilityInfo', {'ability': 'マジックミラー', 'another': 'まじっくみらー'});
        await db.insert('AbilityInfo', {'ability': 'そうしょく', 'another': 'ソウショク'});
        await db.insert('AbilityInfo', {'ability': 'いたずらごころ', 'another': 'イタズラゴコロ'});
        await db.insert('AbilityInfo', {'ability': 'すなのちから', 'another': 'スナノチカラ'});
        await db.insert('AbilityInfo', {'ability': 'てつのトゲ', 'another': 'てつのとげ'});
        await db.insert('AbilityInfo', {'ability': 'ダルマモード', 'another': 'だるまもーど'});
        await db.insert('AbilityInfo', {'ability': 'しょうりのほし', 'another': 'ショウリノホシ'});
        await db.insert('AbilityInfo', {'ability': 'ターボブレイズ', 'another': 'たーぼぶれいず'});
        await db.insert('AbilityInfo', {'ability': 'テラボルテージ', 'another': 'てらぼるてーじ'});
        await db.insert('AbilityInfo', {'ability': 'アロマベール', 'another': 'あろまべーる'});
        await db.insert('AbilityInfo', {'ability': 'フラワーベール', 'another': 'ふらわーべーる'});
        await db.insert('AbilityInfo', {'ability': 'ほおぶくろ', 'another': 'ホオブクロ'});
        await db.insert('AbilityInfo', {'ability': 'へんげんじざい', 'another': 'ヘンゲンジザイ'});
        await db.insert('AbilityInfo', {'ability': 'ファーコート', 'another': 'ふぁーこーと'});
        await db.insert('AbilityInfo', {'ability': 'マジシャン', 'another': 'まじしゃん'});
        await db.insert('AbilityInfo', {'ability': 'ぼうだん', 'another': 'ボウダン'});
        await db.insert('AbilityInfo', {'ability': 'かちき', 'another': 'カチキ'});
        await db.insert('AbilityInfo', {'ability': 'がんじょうあご', 'another': 'ガンジョウアゴ'});
        await db.insert('AbilityInfo', {'ability': 'フリーズスキン', 'another': 'ふりーずすきん'});
        await db.insert('AbilityInfo', {'ability': 'スイートベール', 'another': 'すいーとべーる'});
        await db.insert('AbilityInfo', {'ability': 'バトルスイッチ', 'another': 'ばとるすいっち'});
        await db.insert('AbilityInfo', {'ability': 'はやてのつばさ', 'another': 'ハヤテノツバサ'});
        await db.insert('AbilityInfo', {'ability': 'メガランチャー', 'another': 'めがらんちゃー'});
        await db.insert('AbilityInfo', {'ability': 'くさのけがわ', 'another': 'クサノケガワ'});
        await db.insert('AbilityInfo', {'ability': 'きょうせい', 'another': 'キョウセイ'});
        await db.insert('AbilityInfo', {'ability': 'かたいツメ', 'another': 'かたいつめ'});
        await db.insert('AbilityInfo', {'ability': 'フェアリースキン', 'another': 'ふぇありーすきん'});
        await db.insert('AbilityInfo', {'ability': 'ぬめぬめ', 'another': 'ヌメヌメ'});
        await db.insert('AbilityInfo', {'ability': 'スカイスキン', 'another': 'すかいすきん'});
        await db.insert('AbilityInfo', {'ability': 'おやこあい', 'another': 'オヤコアイ'});
        await db.insert('AbilityInfo', {'ability': 'ダークオーラ', 'another': 'だーくおーら'});
        await db.insert('AbilityInfo', {'ability': 'フェアリーオーラ', 'another': 'ふぇありーおーら'});
        await db.insert('AbilityInfo', {'ability': 'オーラブレイク', 'another': 'おーらぶれいく'});
        await db.insert('AbilityInfo', {'ability': 'はじまりのうみ', 'another': 'ハジマリノウミ'});
        await db.insert('AbilityInfo', {'ability': 'おわりのだいち', 'another': 'オワリノダイチ'});
        await db.insert('AbilityInfo', {'ability': 'デルタストリーム', 'another': 'でるたすとりーむ'});
        await db.insert('AbilityInfo', {'ability': 'じきゅうりょく', 'another': 'ジキュウリョク'});
        await db.insert('AbilityInfo', {'ability': 'にげごし', 'another': 'ニゲゴシ'});
        await db.insert('AbilityInfo', {'ability': 'ききかいひ', 'another': 'キキカイヒ'});
        await db.insert('AbilityInfo', {'ability': 'みずがため', 'another': 'ミズガタメ'});
        await db.insert('AbilityInfo', {'ability': 'ひとでなし', 'another': 'ヒトデナシ'});
        await db.insert('AbilityInfo', {'ability': 'リミットシールド', 'another': 'りみっとしーるど'});
        await db.insert('AbilityInfo', {'ability': 'はりこみ', 'another': 'ハリコミ'});
        await db.insert('AbilityInfo', {'ability': 'すいほう', 'another': 'スイホウ'});
        await db.insert('AbilityInfo', {'ability': 'はがねつかい', 'another': 'ハガネツカイ'});
        await db.insert('AbilityInfo', {'ability': 'ぎゃくじょう', 'another': 'ギャクジョウ'});
        await db.insert('AbilityInfo', {'ability': 'ゆきかき', 'another': 'ユキカキ'});
        await db.insert('AbilityInfo', {'ability': 'えんかく', 'another': 'エンカク'});
        await db.insert('AbilityInfo', {'ability': 'うるおいボイス', 'another': 'うるおいぼいす'});
        await db.insert('AbilityInfo', {'ability': 'ヒーリングシフト', 'another': 'ひーりんぐしふと'});
        await db.insert('AbilityInfo', {'ability': 'エレキスキン', 'another': 'えれきすきん'});
        await db.insert('AbilityInfo', {'ability': 'サーフテール', 'another': 'さーふてーる'});
        await db.insert('AbilityInfo', {'ability': 'ぎょぐん', 'another': 'ギョグン'});
        await db.insert('AbilityInfo', {'ability': 'ばけのかわ', 'another': 'バケノカワ'});
        await db.insert('AbilityInfo', {'ability': 'きずなへんげ', 'another': 'キズナヘンゲ'});
        await db.insert('AbilityInfo', {'ability': 'スワームチェンジ', 'another': 'すわーむちぇんじ'});
        await db.insert('AbilityInfo', {'ability': 'ふしょく', 'another': 'フショク'});
        await db.insert('AbilityInfo', {'ability': 'ぜったいねむり', 'another': 'ゼッタイネムリ'});
        await db.insert('AbilityInfo', {'ability': 'じょおうのいげん', 'another': 'ジョオウノイゲン'});
        await db.insert('AbilityInfo', {'ability': 'とびだすなかみ', 'another': 'トビダスナカミ'});
        await db.insert('AbilityInfo', {'ability': 'おどりこ', 'another': 'オドリコ'});
        await db.insert('AbilityInfo', {'ability': 'バッテリー', 'another': 'ばってりー'});
        await db.insert('AbilityInfo', {'ability': 'もふもふ', 'another': 'モフモフ'});
        await db.insert('AbilityInfo', {'ability': 'ビビッドボディ', 'another': 'びびっどぼでぃ'});
        await db.insert('AbilityInfo', {'ability': 'ソウルハート', 'another': 'そうるはーと'});
        await db.insert('AbilityInfo', {'ability': 'カーリーヘアー', 'another': 'かーりーへあー'});
        await db.insert('AbilityInfo', {'ability': 'レシーバー', 'another': 'れしーばー'});
        await db.insert('AbilityInfo', {'ability': 'かがくのちから', 'another': 'カガクノチカラ'});
        await db.insert('AbilityInfo', {'ability': 'ビーストブースト', 'another': 'びーすとぶーすと'});
        await db.insert('AbilityInfo', {'ability': 'ＡＲシステム', 'another': 'ＡＲしすてむ'});
        await db.insert('AbilityInfo', {'ability': 'エレキメイカー', 'another': 'えれきめいかー'});
        await db.insert('AbilityInfo', {'ability': 'サイコメイカー', 'another': 'さいこめいかー'});
        await db.insert('AbilityInfo', {'ability': 'ミストメイカー', 'another': 'みすとめいかー'});
        await db.insert('AbilityInfo', {'ability': 'グラスメイカー', 'another': 'ぐらすめいかー'});
        await db.insert('AbilityInfo', {'ability': 'メタルプロテクト', 'another': 'めたるぷろてくと'});
        await db.insert('AbilityInfo', {'ability': 'ファントムガード', 'another': 'ふぁんとむがーど'});
        await db.insert('AbilityInfo', {'ability': 'プリズムアーマー', 'another': 'ぷりずむあーまー'});
        await db.insert('AbilityInfo', {'ability': 'ブレインフォース', 'another': 'ぶれいんふぉーす'});
        await db.insert('AbilityInfo', {'ability': 'ふとうのけん', 'another': 'フトウノケン'});
        await db.insert('AbilityInfo', {'ability': 'ふくつのたて', 'another': 'フクツノタテ'});
        await db.insert('AbilityInfo', {'ability': 'リベロ', 'another': 'りべろ'});
        await db.insert('AbilityInfo', {'ability': 'たまひろい', 'another': 'タマヒロイ'});
        await db.insert('AbilityInfo', {'ability': 'わたげ', 'another': 'ワタゲ'});
        await db.insert('AbilityInfo', {'ability': 'スクリューおびれ', 'another': 'すくりゅーおびれ'});
        await db.insert('AbilityInfo', {'ability': 'ミラーアーマー', 'another': 'みらーあーまー'});
        await db.insert('AbilityInfo', {'ability': 'うのミサイル', 'another': 'うのみさいる'});
        await db.insert('AbilityInfo', {'ability': 'すじがねいり', 'another': 'スジガネイリ'});
        await db.insert('AbilityInfo', {'ability': 'じょうききかん', 'another': 'ジョウキキカン'});
        await db.insert('AbilityInfo', {'ability': 'パンクロック', 'another': 'ぱんくろっく'});
        await db.insert('AbilityInfo', {'ability': 'すなはき', 'another': 'スナハキ'});
        await db.insert('AbilityInfo', {'ability': 'こおりのりんぷん', 'another': 'コオリノリンプン'});
        await db.insert('AbilityInfo', {'ability': 'じゅくせい', 'another': 'ジュクセイ'});
        await db.insert('AbilityInfo', {'ability': 'アイスフェイス', 'another': 'あいすふぇいす'});
        await db.insert('AbilityInfo', {'ability': 'パワースポット', 'another': 'ぱわーすぽっと'});
        await db.insert('AbilityInfo', {'ability': 'ぎたい', 'another': 'ギタイ'});
        await db.insert('AbilityInfo', {'ability': 'バリアフリー', 'another': 'ばりあふりー'});
        await db.insert('AbilityInfo', {'ability': 'はがねのせいしん', 'another': 'ハガネノセイシン'});
        await db.insert('AbilityInfo', {'ability': 'ほろびのボディ', 'another': 'ほろびのぼでぃ'});
        await db.insert('AbilityInfo', {'ability': 'さまようたましい', 'another': 'サマヨウタマシイ'});
        await db.insert('AbilityInfo', {'ability': 'ごりむちゅう', 'another': 'ゴリムチュウ'});
        await db.insert('AbilityInfo', {'ability': 'かがくへんかガス', 'another': 'かがくへんかがす'});
        await db.insert('AbilityInfo', {'ability': 'パステルベール', 'another': 'ぱすてるべーる'});
        await db.insert('AbilityInfo', {'ability': 'はらぺこスイッチ', 'another': 'はらぺこすいっち'});
        await db.insert('AbilityInfo', {'ability': 'クイックドロウ', 'another': 'くいっくどろう'});
        await db.insert('AbilityInfo', {'ability': 'ふかしのこぶし', 'another': 'フカシノコブシ'});
        await db.insert('AbilityInfo', {'ability': 'きみょうなくすり', 'another': 'キミョウナクスリ'});
        await db.insert('AbilityInfo', {'ability': 'トランジスタ', 'another': 'とらんじすた'});
        await db.insert('AbilityInfo', {'ability': 'りゅうのあぎと', 'another': 'リュウノアギト'});
        await db.insert('AbilityInfo', {'ability': 'しろのいななき', 'another': 'シロノイナナキ'});
        await db.insert('AbilityInfo', {'ability': 'くろのいななき', 'another': 'クロノイナナキ'});
        await db.insert('AbilityInfo', {'ability': 'じんばいったい', 'another': 'ジンバイッタイ'});
        await db.insert('AbilityInfo', {'ability': 'じんばいったい', 'another': 'ジンバイッタイ'});
        await db.insert('AbilityInfo', {'ability': 'とれないにおい', 'another': 'トレナイニオイ'});
        await db.insert('AbilityInfo', {'ability': 'こぼれダネ', 'another': 'こぼれだね'});
        await db.insert('AbilityInfo', {'ability': 'ねつこうかん', 'another': 'ネツコウカン'});
        await db.insert('AbilityInfo', {'ability': 'いかりのこうら', 'another': 'イカリノコウラ'});
        await db.insert('AbilityInfo', {'ability': 'きよめのしお', 'another': 'キヨメノシオ'});
        await db.insert('AbilityInfo', {'ability': 'こんがりボディ', 'another': 'こんがりぼでぃ'});
        await db.insert('AbilityInfo', {'ability': 'かぜのり', 'another': 'カゼノリ'});
        await db.insert('AbilityInfo', {'ability': 'ばんけん', 'another': 'バンケン'});
        await db.insert('AbilityInfo', {'ability': 'いわはこび', 'another': 'イワハコビ'});
        await db.insert('AbilityInfo', {'ability': 'ふうりょくでんき', 'another': 'フウリョクデンキ'});
        await db.insert('AbilityInfo', {'ability': 'マイティチェンジ', 'another': 'まいてぃちぇんじ'});
        await db.insert('AbilityInfo', {'ability': 'しれいとう', 'another': 'シレイトウ'});
        await db.insert('AbilityInfo', {'ability': 'でんきにかえる', 'another': 'デンキニカエル'});
        await db.insert('AbilityInfo', {'ability': 'こだいかっせい', 'another': 'コダイカッセイ'});
        await db.insert('AbilityInfo', {'ability': 'クォークチャージ', 'another': 'くぉーくちゃーじ'});
        await db.insert('AbilityInfo', {'ability': 'おうごんのからだ', 'another': 'オウゴンノカラダ'});
        await db.insert('AbilityInfo', {'ability': 'わざわいのうつわ', 'another': 'ワザワイノウツワ'});
        await db.insert('AbilityInfo', {'ability': 'わざわいのつるぎ', 'another': 'ワザワイノツルギ'});
        await db.insert('AbilityInfo', {'ability': 'わざわいのおふだ', 'another': 'ワザワイノオフダ'});
        await db.insert('AbilityInfo', {'ability': 'わざわいのたま', 'another': 'ワザワイノタマ'});
        await db.insert('AbilityInfo', {'ability': 'ひひいろのこどう', 'another': 'ヒヒイロノコドウ'});
        await db.insert('AbilityInfo', {'ability': 'ハドロンエンジン', 'another': 'はどろんえんじん'});
        await db.insert('AbilityInfo', {'ability': 'びんじょう', 'another': 'ビンジョウ'});
        await db.insert('AbilityInfo', {'ability': 'はんすう', 'another': 'ハンスウ'});
        await db.insert('AbilityInfo', {'ability': 'きれあじ', 'another': 'キレアジ'});
        await db.insert('AbilityInfo', {'ability': 'そうだいしょう', 'another': 'ソウダイショウ'});
        await db.insert('AbilityInfo', {'ability': 'きょうえん', 'another': 'キョウエン'});
        await db.insert('AbilityInfo', {'ability': 'どくげしょう', 'another': 'ドクゲショウ'});
        await db.insert('AbilityInfo', {'ability': 'テイルアーマー', 'another': 'ているあーまー'});
        await db.insert('AbilityInfo', {'ability': 'どしょく', 'another': 'ドショク'});
        await db.insert('AbilityInfo', {'ability': 'きんしのちから', 'another': 'キンシノチカラ'});
        await db.insert('AbilityInfo', {'ability': 'しんがん', 'another': 'シンガン'});
        await db.insert('AbilityInfo', {'ability': 'かんろなミツ', 'another': 'かんろなみつ'});
        await db.insert('AbilityInfo', {'ability': 'おもてなし', 'another': 'オモテナシ'});
        await db.insert('AbilityInfo', {'ability': 'どくのくさり', 'another': 'ドクノクサリ'});
        await db.insert('AbilityInfo', {'ability': 'おもかげやどし', 'another': 'オモカゲヤドシ'});
        await db.insert('AbilityInfo', {'ability': 'テラスチェンジ', 'another': 'てらすちぇんじ'});
        await db.insert('AbilityInfo', {'ability': 'テラスシェル', 'another': 'てらすしぇる'});
        await db.insert('AbilityInfo', {'ability': 'ゼロフォーミング', 'another': 'ぜろふぉーみんぐ'});
        await db.insert('AbilityInfo', {'ability': 'どくくぐつ', 'another': 'ドククグツ'});
      }
    );

    List<Map> chars = await charDb.rawQuery('SELECT * FROM AbilityInfo');
    List<String> initialStr = [];
    for(int i = 0; i < charList.length; i++){
        initialStr.add(charList[i].ability);
    }
    for(var char in chars){
        if(!initialStr.contains(char["ability"])){
            charList.add(Ability(ability: char["ability"], another: char["another"]));
        }
    }

    return charList;
  }

}