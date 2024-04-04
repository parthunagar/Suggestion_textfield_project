class Dictionary {
  int? rowId;
  String? word,wordType,definition;

  Dictionary({
    this.rowId,
    this.word,
    this.wordType,
    this.definition
  });

  Map<String, dynamic> toMap() {
    return {
      'rowid': rowId,
      'word': word,
      'wordtype': wordType,
      'definition': definition
    };
  }

  Dictionary.fromMap(Map<dynamic, dynamic> map) {
    rowId = map['rowid'];
    word = map['word'];
    wordType = map['wordtype'];
    definition = map['definition'];
  }

  @override
  String toString() {
    return '{"rowid": "$rowId", "word": "$word", "wordtype": "$wordType", "definition": "$definition"}';
  }
}