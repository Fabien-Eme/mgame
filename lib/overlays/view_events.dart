import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../flame_game/game.dart';

Widget viewEvents(BuildContext context, MGame game) {
  return ViewEvents(game);
}

class ViewEvents extends StatelessWidget {
  ViewEvents(this.mgame, {super.key});

  final MGame mgame;

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> listMapEvents = fetchListMapEvents();

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Center(
            child: Container(
              width: (constraints.maxWidth / 2.5 > 600) ? 600 : constraints.maxWidth / 2.5,
              height: (constraints.maxHeight / 1.2 > 500) ? 500 : constraints.maxHeight / 1.2,
              decoration: BoxDecoration(
                color: Colors.blueGrey[50]!,
                border: Border.all(
                  width: 5,
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                child: SizedBox(
                  width: (constraints.maxWidth / 3 > 500) ? 500 : constraints.maxWidth / 3,
                  height: (constraints.maxHeight / 1.5 > 450) ? 450 : constraints.maxHeight / 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Text(
                          'ALL CLEANING EVENT',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Attend the events of your choice. Scan the Google Wallet Pass of the organizer to get a reward !',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder(
                            future: listMapEvents,
                            builder: ((BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                List<Widget> listCard = [];
                                for (final map in snapshot.data!) {
                                  listCard.add(eventCard(map, (constraints.maxWidth / 3 > 500) ? 500 : constraints.maxWidth / 3));
                                }
                                return Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: listCard,
                                    ),
                                  ),
                                );
                              } else {
                                return const Text('Loading...');
                              }
                            })),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                mgame.overlays.remove('viewEvents');
                                mgame.mouseCursor = SystemMouseCursors.none;
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget eventCard(Map<String, dynamic> map, double width) {
    return SizedBox(
      width: width,
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(map['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(map['description'] as String),
              const SizedBox(height: 5),
              Text(map['dateAndAdress'] as String, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchListMapEvents() async {
    List<Map<String, dynamic>> listMapEvents = [];
    final result = await db.collection('events').get();

    for (final doc in result.docs) {
      listMapEvents.add(doc.data());
    }
    listMapEvents.sort((a, b) => (a['date'] as Timestamp).compareTo((b['date'] as Timestamp)));

    return listMapEvents;
  }
}
