class Document {
  //class is your template - howevery document 'looks' like -
  final int?
  id; //final means it can't be changed - ? is nullable //nullable because when doc first created, no id yet, only once saved
  final String title; // must have value, doc name
  final String
  content; //writing inside document, can be empty string '' but must exist
  final DateTime
  createdAt; //records when doc first made, final because doesnt change upon creation
  final DateTime
  updatedAt; //last time doc changed, new document object created when updated

  Document({
    //how you create a document object
    this.id, // doc can be created without id and is optional (required)
    required this.title, //forces you to always include this
    required this.content, // must have something even empty string
    required this.createdAt, //must say when it was created
    required this.updatedAt, //must say when it was last updated
  });

  // Convert Document to Map for database
  Map<String, dynamic> toMap() {
    //dart understands key value pairs - map is dictonary of key value pairs - function name is toMap
    return {
      //keys are text (string), values are dynamic and can be anything - return function returns back a map with all doc data
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt
          .toIso8601String(), //convert to text format because databases store date as texts
      'updatedAt': updatedAt.toIso8601String(),
    };
  } //toMap() is used when saving to the database

  // converts the map into a document object we can use (opposte of toMap()!
  factory Document.fromMap(Map<String, dynamic> map) {
    //factory is a constructor that doesnt always have to create a new object (here itdoes)
    return Document(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(
        map['createdAt'],
      ), //converts text back into date time object, we dont wanna work with strings
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Create a copy with updated fields (like title)
  Document copyWith({
    //everythings optional
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Document(
      id: id ?? this.id, //use new id if provided otherwise keep old id
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
