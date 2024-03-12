import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/user_controller.dart';
import 'package:mgame/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../flame_game/game.dart';

Widget viewMyEvents(BuildContext context, MGame game) {
  return ViewMyEvents(game);
}

class ViewMyEvents extends ConsumerStatefulWidget {
  ViewMyEvents(this.mgame, {super.key});

  final MGame mgame;

  final db = FirebaseFirestore.instance;

  @override
  ConsumerState<ViewMyEvents> createState() => _ViewMyEventsState();
}

class _ViewMyEventsState extends ConsumerState<ViewMyEvents> {
  String selected = "";
  bool isAddToWalletVisible = true;

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> listMapEvents = fetchListMapEvents(ref.read(userControllerProvider));

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Center(
            child: Container(
              width: (constraints.maxWidth / 2 > 600) ? 600 : constraints.maxWidth / 2,
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
                  width: (constraints.maxWidth / 2.5 > 500) ? 500 : constraints.maxWidth / 2.5,
                  height: (constraints.maxHeight / 1.5 > 450) ? 450 : constraints.maxHeight / 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Text(
                          'MY CLEANING EVENT',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Get the organizer's Google Wallet Pass to reward participants and get rewarded yourself!",
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder(
                            future: listMapEvents,
                            builder: ((BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                List<Widget> listCard = [];
                                for (final map in snapshot.data!) {
                                  listCard.add(
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selected == map['title']) {
                                            selected = '';
                                          } else {
                                            selected = map['title'] as String? ?? "";
                                          }
                                        });
                                      },
                                      child: eventCard(map, (constraints.maxWidth / 3 > 500) ? 500 : constraints.maxWidth / 3, selected),
                                    ),
                                  );
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                widget.mgame.overlays.remove('viewMyEvents');
                                widget.mgame.mouseCursor = SystemMouseCursors.none;
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            (selected != "" && isAddToWalletVisible)
                                ? GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isAddToWalletVisible = false;
                                      });
                                      await addToGoogleWallet(selected);
                                      widget.mgame.overlays.remove('viewMyEvents');
                                      widget.mgame.mouseCursor = SystemMouseCursors.none;
                                    },
                                    child: Image.asset(
                                      Assets.images.ui.addToGoogleWalletButton.path,
                                      width: 200,
                                    ),
                                  )
                                : Container(),
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

  Widget eventCard(Map<String, dynamic> map, double width, String selected) {
    return SizedBox(
      width: width,
      child: Card(
        surfaceTintColor: (selected == map['title']) ? Colors.black : Colors.white,
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

  Future<List<Map<String, dynamic>>> fetchListMapEvents(User? user) async {
    List<Map<String, dynamic>> listMapEvents = [];
    final result = await widget.db.collection('events').get();
    final userMail = user?.email ?? "";

    for (final doc in result.docs) {
      final map = doc.data();
      final eventUser = map['user'];

      if (eventUser == userMail) {
        listMapEvents.add(doc.data());
      }
    }
    listMapEvents.sort((a, b) => (a['date'] as Timestamp).compareTo((b['date'] as Timestamp)));

    return listMapEvents;
  }

  Future<void> addToGoogleWallet(String selected) async {
    String response = "";

    String userName = ref.read(userControllerProvider)?.email ?? "";

    final url = Uri.https('us-west1-mgame-8c88b.cloudfunctions.net', 'createJoinMyTeamPass');
    final res = await http.post(url, body: {'eventTitle': selected, 'userName': userName});
    response = res.body;

    if (response.isNotEmpty) launch(response);
  }

  void launch(String url) {
    final Uri uri = Uri.parse(url);
    launchUrl(uri);
  }
}
