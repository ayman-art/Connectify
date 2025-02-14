import 'package:Connectify/core/message.dart';
import 'package:sqflite/sqflite.dart';

class Messageprovider {
  static Future<dynamic> insert(Message message, Database db) async {
    await db.insert(tableMessage, message.toMap());
  }

  static Future<Message?> getMessage(String id, Database db) async {
    List<Map<String, dynamic>> maps = await db.query(tableMessage,
        columns: [
          columnId,
          columnSender,
          columnReceiver,
          columnReplied,
          columnTime,
          columnString,
          columnAttachment,
          columnStarred,
          columnIsSeenLevel
        ],
        where: '$columnId = ?',
        whereArgs: [id]) as List<Map<String, dynamic>>;
    if (maps.length > 0) {
      return Message.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<Message>> getMessagesOfChat(
      Database db, String sender, String receiver, int offset) async {
    List<Map<String, dynamic>> maps = await db.query(tableMessage,
        columns: [
          columnId,
          columnSender,
          columnReceiver,
          columnReplied,
          columnTime,
          columnString,
          columnAttachment,
          columnStarred,
          columnIsSeenLevel
        ],
        where:
            '( $columnSender = ? AND $columnReceiver = ? ) OR ( $columnSender = ? AND $columnReceiver = ? )',
        whereArgs: [sender, receiver, receiver, sender],
        orderBy: '$columnTime DESC',
        distinct: true,
        limit: 30,
        offset: offset) as List<Map<String, dynamic>>;
    List<Message> res = [];
    for (Map<String, dynamic> map in maps) {
      res.add(Message.fromMap(map));
      final isSeen = Message.fromMap(map).isSeenLevel;
      print("isSeen: $isSeen, ${Message.fromMap(map).stringContent}");
    }
    return res;
  }

  static Future<void> clearMessages(Database db, String phone) async {
    await db.delete(tableMessage,
        where: '$columnReceiver = ? OR $columnSender = ?',
        whereArgs: [phone, phone]);
  }

  static Future<Message?> getLastMessage(
      Database db, String sender, String receiver) async {
    List<Map<String, dynamic>> maps = await db.query(
      tableMessage,
      columns: [
        columnId,
        columnSender,
        columnReceiver,
        columnReplied,
        columnTime,
        columnString,
        columnAttachment,
        columnStarred,
        columnIsSeenLevel
      ],
      where:
          '( $columnSender = ? AND $columnReceiver = ? ) OR ( $columnSender = ? AND $columnReceiver = ? )',
      whereArgs: [sender, receiver, receiver, sender],
      orderBy: '$columnTime DESC',
    ) as List<Map<String, dynamic>>;
    if (maps.length > 0) {
      return Message.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> update(Message message, Database db) async {
    print("ALL: ${message.toMap()}");
    return await db.update(tableMessage, message.toMap(),
        where: '$columnId = ?', whereArgs: [message.id]);
  }

  static delete(int id, Database db) async {
    return await db
        .delete(tableMessage, where: '$columnId = ?', whereArgs: [id]);
  }

  static Future<List<Message>> getStarredMessages(Database db) async {
    List<Map<String, dynamic>> maps = await db.query(
      tableMessage,
      columns: [
        columnId,
        columnSender,
        columnReceiver,
        columnReplied,
        columnTime,
        columnString,
        columnAttachment,
        columnStarred,
        columnIsSeenLevel
      ],
      where: '$columnStarred = ?',
      whereArgs: [1],
      distinct: true,
    ) as List<Map<String, dynamic>>;

    if (maps.isNotEmpty) {
      return maps.map((message) => Message.fromMap(message)).toList();
    }
    return [];
  }

  static Future<List<Message>> getMessagesContaining(
      String searchString, Database db) async {
    List<Map<String, dynamic>> maps = await db.query(
      tableMessage,
      columns: [
        columnId,
        columnSender,
        columnReceiver,
        columnReplied,
        columnTime,
        columnString,
        columnAttachment,
        columnStarred,
        columnIsSeenLevel
      ],
      where: '$columnString LIKE ?',
      whereArgs: ['%$searchString%'],
    );

    return List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });
  }

  static Future<void> DeleteMessages(
      Database db, String sender, String receiver) async {
    await db.delete(tableMessage,
        where:
            '( $columnSender = ? AND $columnReceiver = ? ) OR ( $columnSender = ? AND $columnReceiver = ? )',
        whereArgs: [sender, receiver, receiver, sender]);
  }
}
