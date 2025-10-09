// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 249, 248, 245),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 140,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 249, 248, 245),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 30, // search bar height
                        width: 230,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            238,
                            238,
                            234,
                          ), //search bg
                          borderRadius: BorderRadius.circular(
                            15,
                          ), // search corners
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5), //light border
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.grey,
                            ), // search icon
                            SizedBox(width: 10),
                            GestureDetector(
                              child: Text(
                                'Search file...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                              onTap: () {
                                print(
                                  "Search Bar clicked",
                                ); //change so that whole search bar clicked shows and not just on text
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('ooga booga'),
                onTap: () {
                  print('Thingy clicked');
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 250, 249, 247),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        appBar: AppBar(
          elevation: 1.0,
          backgroundColor: const Color.fromARGB(255, 250, 249, 247),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 80),
              Center(child: Text('File Name')),
              SizedBox(width: 100),
              GestureDetector(
                child: Icon(Icons.add),
                onTap: () {
                  print('New file button clicked');
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      238,
                      238,
                      234,
                    ), // inside color of icon box
                    borderRadius: BorderRadius.circular(
                      20,
                    ), //round edges for icon box
                    border: Border.all(
                      color: const Color.fromARGB(
                        255,
                        248,
                        246,
                        243,
                      ), // border color for icon box
                      width: 2, // border thickness for icon box
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.edit_document,
                      size: 50,
                      color: Color.fromARGB(255, 139, 157, 140),
                    ),
                  ),
                ),
              ),
              Text(
                'Welcome to ReCollect',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Select or double-click a document to start writing',
                style: TextStyle(fontFamily: 'Times New Roman', fontSize: 15),
              ),
              Text(
                "Your thoughts, beautifully organized",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
