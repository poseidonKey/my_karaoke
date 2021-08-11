import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import 'package:my_karaoke/my_song_data.dart';
import 'utils.dart' as utils;

class DBWorker {
  /// Static instance and private constructor, since this is a singleton.
  DBWorker._();
  static final DBWorker db = DBWorker._();

  /// The one and only database instance.
  Database? _db;

  /// Get singleton instance, create if not available yet.
  ///
  /// @return The one and only Database instance.
  Future get database async {
    if (_db == null) {
      // print("null");
      _db = await init();
    }

    print("## Notes NotesDBWorker.get-database(): _db = $_db");

    return _db;
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    print("Notes NotesDBWorker.init()");

    String path = join(utils.docsDir!.path, "songs.db");
    print("## notes NotesDBWorker.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS songs ("
          "songID INTEGER PRIMARY KEY,"
          "songName TEXT,"
          "songGYNumber TEXT,"
          "songTJNumber TEXT,"
          "songJanre TEXT,"
          "songUtubeAddress TEXT,"
          "songETC TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a Note from a Map.
  MySongData noteFromMap(Map inMap) {
    print("## Notes NotesDBWorker.noteFromMap(): inMap = $inMap");

    MySongData song = MySongData();
    song.songID = inMap["songID"];
    song.songName = inMap["songName"];
    song.songGYNumber = inMap["songGYNumber"];
    song.songTJNumber = inMap["songTJNumber"];
    song.songJanre = inMap["songJanre"];
    song.songUtubeAddress = inMap["songUtubeAddress"];
    song.songETC = inMap["songETC"];

    print("## songs NotesDBWorker.noteFromMap(): note = $song");

    return song;
  } /* End noteFromMap(); */

  /// Create a Map from a Note.
  Map<String, dynamic> noteToMap(MySongData inSong) {
    print("## Notes NotesDBWorker.noteToMap(): inNote = $inSong");

    Map<String, dynamic> map = Map<String, dynamic>();
    map["songID"] = inSong.songID;
    map["songName"] = inSong.songName;
    map["songGYNumber"] = inSong.songGYNumber;
    map["songTJNumber"] = inSong.songTJNumber;
    map["songJanre"] = inSong.songJanre;
    map["songUtubeAddress"] = inSong.songUtubeAddress;
    map["songETC"] = inSong.songETC;

    print("## notes NotesDBWorker.noteToMap(): map = $map");

    return map;
  } /* End noteToMap(). */

  /// Create a note.
  ///
  /// @param  inNote The Note object to create.
  /// @return        Future.
  Future create(MySongData inNote) async {
    print("## Notes NotesDBWorker.create(): inNote = $inNote");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(songID) + 1 as songID FROM songs");
    // print("result : ${val.first['songID']}");
    int songID;
    if (val.first['songID'] == null) {
      songID = 1;
    } else {
      String t = val.first['songID'].toString();
      songID = int.parse(t);
    }
    // if (songID == 0) songID = 1;
    // print(songID);
    // return;
    // print(songID);
    // int songID = int.parse(val.first["songID"].toString());
    // int songID = String.parse(val.first['songID']);
    // print("ID $songID}");
    // return;

    // if (songID == null) {
    //   songID = 1;
    // }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO songs (songID, songName, songGYNumber, songTJNumber,songJanre,songUtubeAddress,songETC) VALUES (?,?,?, ?, ?, ?,?)",
        [
          songID,
          inNote.songName,
          inNote.songGYNumber,
          inNote.songTJNumber,
          inNote.songJanre,
          inNote.songUtubeAddress,
          inNote.songETC
        ]);
  } /* End create(). */

  /// Get a specific note.
  ///
  /// @param  inID The ID of the note to get.
  /// @return      The corresponding Note object.
  Future<MySongData> get(int inID) async {
    print("## Notes NotesDBWorker.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("songs", where: "songID = ?", whereArgs: [inID]);

    print("## Notes NotesDBWorker.get(): rec.first = $rec.first");

    return noteFromMap(rec.first);
  } /* End get(). */

  /// Get all notes.
  ///
  /// @return A List of Note objects.
  Future<List> getAll() async {
    print("## Notes NotesDBWorker.getAll()");

    Database db = await database;
    var recs = await db.query("songs");
    var list = recs.isNotEmpty ? recs.map((m) => noteFromMap(m)).toList() : [];

    print("## Notes NotesDBWorker.getAll(): list = $list");

    return list;
  } /* End getAll(). */

  /// Update a note.
  ///
  /// @param inNote The note to update.
  /// @return       Future.
  Future update(MySongData inSong) async {
    print("## Notes NotesDBWorker.update(): inNote = $inSong");

    Database db = await database;
    return await db.update("songs", noteToMap(inSong),
        where: "songID = ?", whereArgs: [inSong.songID]);
  } /* End update(). */

  /// Delete a note.
  ///
  /// @param inID The ID of the note to delete.
  /// @return     Future.
  Future delete(int inID) async {
    print("## Notes NotesDBWorker.delete(): inID = $inID");

    Database db = await database;
    return await db.delete("songs", where: "songID = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
