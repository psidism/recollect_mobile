// ignore_for_file: avoid_print, deprecated_member_use
// this line tells Flutter to ignore certain warnings that aren't important for us

import 'package:flutter/material.dart'; // imports Flutter's UI building blocks
import 'models/document.dart'; // imports our Document model (the blueprint for a document)
import 'services/database_helper.dart'; // imports our database manager

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key}); // constructor - how you create a MainApp

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // createState() creates the STATE object that holds all the changing data
  // Flutter separates the widget (HomePage) from its state (_HomePageState)
  @override
  State<HomePage> createState() => _HomePageState();
}

// _HomePageState holds all the DATA and LOGIC for HomePage
// the underscore _ makes this private (only usable in THIS file)
class _HomePageState extends State<HomePage> {
  // ========== STATE VARIABLES (the data that can change) ==========

  // _dbHelper is our connection to the database
  // DatabaseHelper.instance gives us ONE shared database helper (singleton pattern)
  // final = this variable can't be reassigned after creation
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // _documents is the list of ALL documents in the app
  // starts as an empty list []
  // List<Document> means "a list that only contains Document objects"
  List<Document> _documents = [];

  // _isLoading tracks whether we're currently loading data from the database
  // bool = boolean (true or false)
  // starts as true because we load documents immediately
  bool _isLoading = true;

  // ========== LIFECYCLE METHODS ==========

  // initState() runs ONCE when this widget is first created
  // think of it as the "setup" function
  @override
  void initState() {
    super
        .initState(); // ALWAYS call super.initState() first (Flutter requirement)
    _loadDocuments(); // load all documents from database
  }

  // ========== DATABASE METHODS ==========

  // _loadDocuments gets all documents from the database
  // Future<void> means "this takes time and returns nothing"
  // async means "this function will use 'await' to wait for things"
  Future<void> _loadDocuments() async {
    // setState() tells Flutter "I'm changing the state, please redraw the screen"
    // everything inside setState() updates state variables
    setState(() => _isLoading = true); // show loading spinner

    // await means "wait for this to finish before continuing"
    // getAllDocuments() goes to the database and gets all documents
    // this might take a few milliseconds, so we wait
    final documents = await _dbHelper.getAllDocuments();

    // now we have the documents, update state again
    setState(() {
      _documents = documents; // save the documents we got
      _isLoading = false; // hide loading spinner
    });
    // after setState() finishes, Flutter automatically redraws the screen
  }

  // _createNewDocument makes a brand new empty document
  Future<void> _createNewDocument() async {
    final now = DateTime.now(); // gets current date and time

    // create a new Document object
    // note: no 'id' field - the database will assign an ID automatically
    final newDoc = Document(
      title: 'Untitled Document', // default name
      content: '', // empty content (user will type in it later)
      createdAt: now, // when it was created
      updatedAt: now, // when it was last updated
    );

    // save this document to the database
    // createDocument() returns the same document but WITH an ID now
    final createdDoc = await _dbHelper.createDocument(newDoc);

    // reload all documents so the drawer updates and shows the new document
    await _loadDocuments();

    // print to console (for debugging - you can see this in terminal/logs)
    print('Created document with ID: ${createdDoc.id}');
  }

  // _deleteDocument removes a document from the database
  // int id = the unique ID number of the document to delete
  Future<void> _deleteDocument(int id) async {
    await _dbHelper.deleteDocument(id); // delete from database
    await _loadDocuments(); // reload list so deleted doc disappears from drawer
  }

  // ========== BUILD METHOD (DRAWS THE UI) ==========

  // build() is called every time setState() is called
  // it returns a tree of widgets that Flutter draws on screen
  @override
  Widget build(BuildContext context) {
    // Scaffold is a pre-made layout structure that gives you:
    // - an app bar at the top
    // - a drawer on the left
    // - a body in the middle
    // - a bottom navigation bar at the bottom
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        249,
        248,
        245,
      ), // cream background
      // ========== DRAWER (SIDE MENU) ==========
      // Drawer slides in from the left when you tap the hamburger menu
      drawer: Drawer(
        // Column stacks widgets vertically (top to bottom)
        child: Column(
          children: [
            // ===== DRAWER HEADER WITH SEARCH BAR =====
            SizedBox(
              height: 140, // fixed height for header
              child: DrawerHeader(
                // DrawerHeader is a pre-styled widget for drawer tops
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 249, 248, 245), // cream color
                ),
                // Row puts widgets horizontally (left to right)
                child: Row(
                  children: [
                    // Container is a box that can hold other widgets
                    // think of it like a <div> in HTML
                    Container(
                      height: 30, // search bar height
                      width: 230, // search bar width
                      // margin = space OUTSIDE the container
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20, // 20 pixels left and right
                        vertical: 10, // 10 pixels top and bottom
                      ),

                      // padding = space INSIDE the container
                      padding: const EdgeInsets.symmetric(horizontal: 15),

                      // decoration = styling (color, borders, shadows, etc.)
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          238,
                          238,
                          234,
                        ), // light gray
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // rounded corners
                        border: Border.all(
                          color: Colors.grey.withOpacity(
                            0.5,
                          ), // semi-transparent gray
                          width: 1, // 1 pixel thick border
                        ),
                      ),

                      // the contents of the search bar
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.grey,
                          ), // magnifying glass icon
                          SizedBox(width: 10), // 10 pixel space
                          // GestureDetector detects touches/clicks
                          GestureDetector(
                            child: Text(
                              'Search file...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                            // onTap = what happens when user taps this
                            onTap: () {
                              print("Search Bar clicked");
                              // TODO: add search functionality later
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== "ALL DOCUMENTS" HEADER =====
            // Padding adds space around its child widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // spreads items apart
                children: [
                  Text(
                    'All Documents (${_documents.length})', // shows count of documents
                    // ${} is string interpolation - it puts a variable inside a string
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Divider draws a horizontal line
            Divider(height: 1),

            // ===== DOCUMENT LIST (SCROLLABLE) =====
            // Expanded takes up all remaining space in the Column
            // without Expanded, the ListView would have infinite height (error!)
            Expanded(
              // CONDITIONAL RENDERING: show different widgets based on state
              child:
                  _isLoading // if currently loading...
                  ? Center(child: CircularProgressIndicator()) // show spinner
                  : _documents
                        .isEmpty // else if no documents exist...
                  ? Center(
                      // show "no documents" message
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'No documents yet.\nTap + to create one!',
                          textAlign: TextAlign.center, // center the text
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Times New Roman',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      // else, show scrollable list of documents
                      padding: const EdgeInsets.all(8),

                      // itemCount = how many items in the list
                      itemCount: _documents.length,

                      // itemBuilder = function that builds EACH item in the list
                      // it runs once for EACH document
                      // index = position in list (0, 1, 2, 3, ...)
                      itemBuilder: (context, index) {
                        // get the document at this position in the list
                        final doc = _documents[index];

                        // return a Card widget for this document
                        // Card gives us a nice box with shadow and rounded corners
                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 8,
                          ), // space below each card
                          color: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ), // white
                          elevation: 1, // shadow depth (1 = subtle shadow)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // rounded corners
                          ),

                          // ListTile is a pre-made widget for list items
                          // it automatically arranges leading icon, title, subtitle, and trailing icon
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, // space on sides
                              vertical: 4, // space on top/bottom
                            ),

                            // ===== LEADING (LEFT SIDE ICON) =====
                            leading: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 238, 238, 234),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.description, // document icon
                                size: 20,
                                color: Color.fromARGB(
                                  255,
                                  139,
                                  157,
                                  140,
                                ), // sage green
                              ),
                            ),

                            // ===== TITLE (DOCUMENT NAME) =====
                            title: Text(
                              doc.title, // the document's title from database
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1, // only show 1 line
                              overflow: TextOverflow
                                  .ellipsis, // if too long, show "..."
                            ),

                            // ===== SUBTITLE (CONTENT PREVIEW) =====
                            subtitle: Text(
                              // TERNARY OPERATOR: condition ? valueIfTrue : valueIfFalse
                              doc
                                      .content
                                      .isEmpty // if content is empty
                                  ? 'Empty document' // show this
                                  : doc.content.length >
                                        30 // else if content is long
                                  ? '${doc.content.substring(0, 30)}...' // show first 30 chars + "..."
                                  : doc.content, // else show full content
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 12,
                                color: Colors.grey[600], // darker gray
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // ===== TRAILING (RIGHT SIDE DELETE BUTTON) =====
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // when delete button is pressed
                                if (doc.id != null) {
                                  // make sure document has an ID
                                  _deleteDocument(doc.id!); // delete it
                                  // the ! means "I promise this isn't null"
                                }
                              },
                            ),

                            // ===== ONTAP (WHAT HAPPENS WHEN YOU TAP THE CARD) =====
                            onTap: () {
                              print('Tapped on document: ${doc.title}');
                              Navigator.pop(context); // close the drawer
                              // TODO: later we'll navigate to an editor screen here
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // ========== BOTTOM NAVIGATION BAR ==========
      // BottomNavigationBar is a pre-made widget for bottom tabs
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 250, 249, 247),

        // items = list of tabs in the bottom bar
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // the icon for this tab
            label: 'Search', // the text label below the icon
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        // TODO: make these tabs actually do something later
      ),

      // ========== APP BAR (TOP BAR) ==========
      // AppBar is a pre-made widget for the top bar
      appBar: AppBar(
        elevation: 1.0, // subtle shadow under the bar
        backgroundColor: const Color.fromARGB(255, 250, 249, 247),

        // title can be any widget, not just text!
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // spread items apart
          children: [
            SizedBox(
              width: 80,
            ), // empty spacer on left (pushes title to center)
            Center(child: Text('ReCollect')), // app name in center
            SizedBox(width: 100), // empty spacer (for visual balance)
            // the "+" button to create new documents
            GestureDetector(
              child: Icon(Icons.add), // plus icon
              onTap: _createNewDocument, // when tapped, create a new document
            ),
          ],
        ),
      ),

      // ========== BODY (MAIN CONTENT AREA) ==========
      // the body ALWAYS shows the welcome screen
      // documents are in the drawer, not here
      body: Center(
        // Center positions its child in the middle of the screen
        child: Column(
          // Column stacks widgets vertically
          mainAxisAlignment:
              MainAxisAlignment.center, // center items vertically
          children: [
            // ===== ICON BOX =====
            Center(
              child: Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.all(10), // space around the box
                padding: const EdgeInsets.all(10), // space inside the box
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 238, 238, 234), // light gray
                  borderRadius: BorderRadius.circular(20), // rounded corners
                  border: Border.all(
                    color: const Color.fromARGB(
                      255,
                      248,
                      246,
                      243,
                    ), // cream border
                    width: 2, // 2 pixels thick
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.edit_document, // document with pen icon
                    size: 50, // icon size
                    color: Color.fromARGB(255, 139, 157, 140), // sage green
                  ),
                ),
              ),
            ),

            // ===== WELCOME TEXT =====
            Text(
              'Welcome to ReCollect',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Open the drawer to view your documents',
              style: TextStyle(fontFamily: 'Times New Roman', fontSize: 15),
            ),
            Text(
              "Your thoughts, beautifully organized",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontStyle: FontStyle.italic, // makes text slanted
              ),
            ),
          ],
        ),
      ),
    );
  }
}
