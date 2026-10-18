import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChessClubApp());
}

class ChessClubApp extends StatelessWidget {
  const ChessClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Satranç Kulübü',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E24),
        primaryColor: const Color(0xFF2B2D42),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TournamentDashboardScreen(),
    const StandingsScreen(),
    const ChessClockScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2B2D42),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white60,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: "Turnuva"),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "Sıralama"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Satranç Saati"),
        ],
      ),
    );
  }
}

// 1. EKRAN: TURNUVA VE MASA YÖNETİMİ
class TournamentDashboardScreen extends StatefulWidget {
  const TournamentDashboardScreen({super.key});

  @override
  State<TournamentDashboardScreen> createState() => _TournamentDashboardScreenState();
}

class _TournamentDashboardScreenState extends State<TournamentDashboardScreen> {
  int currentRound = 1;
  final List<Map<String, dynamic>> matches = [
    {"board": 1, "white": "Ahmet Yılmaz", "whiteElo": 1580, "black": "Can Demir", "blackElo": 1540, "result": null},
    {"board": 2, "white": "Burak Kaya", "whiteElo": 1510, "black": "Murat Çelik", "blackElo": 1495, "result": "1-0"},
    {"board": 3, "white": "Emre Şen", "whiteElo": 1460, "black": "Oğuzhan Kurt", "blackElo": 1475, "result": null},
  ];

  void _setResult(int index, String res) {
    setState(() {
      matches[index]["result"] = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tur $currentRound / 5 - A Grubu"),
        backgroundColor: const Color(0xFF2B2D42),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  color: const Color(0xFF2B2D42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Masa ${match['board']}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                            Text(
                              match['result'] ?? "Oynanıyor...",
                              style: TextStyle(
                                color: match['result'] == null ? Colors.grey : Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Beyaz: ${match['white']} (${match['whiteElo']})", style: const TextStyle(color: Colors.white)),
                                  const SizedBox(height: 6),
                                  Text("Siyah: ${match['black']} (${match['blackElo']})", style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                _btn("1-0", match['result'] == "1-0", () => _setResult(index, "1-0")),
                                const SizedBox(width: 4),
                                _btn("½-½", match['result'] == "1/2-1/2", () => _setResult(index, "1/2-1/2")),
                                const SizedBox(width: 4),
                                _btn("0-1", match['result'] == "0-1", () => _setResult(index, "0-1")),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2B2D42),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tüm maçlar kaydedildi. Yeni tur hesaplanıyor...")),
                  );
                },
                child: const Text("Turu Tamamla & Yeni Turu Eşlendir", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _btn(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.amber : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: active ? Colors.amber : Colors.white24),
        ),
        child: Text(text, style: TextStyle(color: active ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}

// 2. EKRAN: SIRALAMA VE AVERAJ TABLOSU
class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final standings = [
      {"rank": 1, "name": "Ahmet Yılmaz", "pts": "3.0", "bh": "6.5", "elo": "+14"},
      {"rank": 2, "name": "Burak Kaya", "pts": "2.5", "bh": "7.0", "elo": "+19"},
      {"rank": 3, "name": "Can Demir", "pts": "2.0", "bh": "5.5", "elo": "-6"},
      {"rank": 4, "name": "Murat Çelik", "pts": "1.5", "bh": "6.0", "elo": "-11"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Canlı Sıralama & Averaj"), backgroundColor: const Color(0xFF2B2D42)),
      body: ListView.separated(
        itemCount: standings.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
        itemBuilder: (context, i) {
          final s = standings[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: i == 0 ? Colors.amber : const Color(0xFF2B2D42),
              child: Text("${s['rank']}", style: TextStyle(color: i == 0 ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
            ),
            title: Text(s['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("BH-1: ${s['bh']}  |  Elo Δ: ${s['elo']}", style: const TextStyle(color: Colors.white60)),
            trailing: Text("${s['pts']} P", style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
}

// 3. EKRAN: DİJİTAL SATRANÇ SAATİ (3+2)
class ChessClockScreen extends StatefulWidget {
  const ChessClockScreen({super.key});

  @override
  State<ChessClockScreen> createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends State<ChessClockScreen> {
  int p1 = 180000;
  int p2 = 180000;
  Timer? timer;
  int turn = 0; // 0: durdu, 1: üstteki, 2: alttaki

  void _tick() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        if (turn == 1 && p1 > 0) p1 -= 100;
        if (turn == 2 && p2 > 0) p2 -= 100;
      });
    });
  }

  void _tap(int player) {
    if (turn == 0) {
      turn = (player == 1) ? 2 : 1;
      _tick();
      return;
    }
    if (turn == player) {
      if (player == 1) {
        p1 += 2000; // +2 saniye artırma
        turn = 2;
      } else {
        p2 += 2000;
        turn = 1;
      }
    }
  }

  String _fmt(int ms) {
    int s = (ms / 1000).floor();
    int m = (s / 60).floor();
    return "${(m % 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RotatedBox(
              quarterTurns: 2,
              child: InkWell(
                onTap: () => _tap(1),
                child: Container(
                  color: turn == 1 ? Colors.amber[800] : const Color(0xFF2B2D42),
                  alignment: Alignment.center,
                  child: Text(_fmt(p1), style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace')),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(turn == 0 ? Icons.play_arrow : Icons.pause, color: Colors.amber),
                  onPressed: () {
                    setState(() {
                      if (turn != 0) {
                        turn = 0;
                        timer?.cancel();
                      } else {
                        turn = 1;
                        _tick();
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      timer?.cancel();
                      turn = 0;
                      p1 = 180000;
                      p2 = 180000;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _tap(2),
              child: Container(
                color: turn == 2 ? Colors.amber[800] : const Color(0xFF2B2D42),
                alignment: Alignment.center,
                child: Text(_fmt(p2), style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
