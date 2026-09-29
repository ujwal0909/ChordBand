import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/song_providers.dart';

class LiveBandScreen extends ConsumerStatefulWidget {
  const LiveBandScreen({super.key});

  @override
  ConsumerState<LiveBandScreen> createState() => _LiveBandScreenState();
}

class _LiveBandScreenState extends ConsumerState<LiveBandScreen> with SingleTickerProviderStateMixin {
  bool _isLeader = false;
  bool _isFollowing = true;
  int _bpm = 100;
  bool _isMetronomeRunning = false;
  int _currentBeat = 0;
  int _beatsPerMeasure = 4;
  Timer? _metronomeTimer;
  final List<DateTime> _tapTimes = [];

  late AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _metronomeTimer?.cancel();
    _flashController.dispose();
    super.dispose();
  }

  void _toggleMetronome() {
    setState(() {
      _isMetronomeRunning = !_isMetronomeRunning;
    });

    if (_isMetronomeRunning) {
      final intervalMs = (60000 / _bpm).round();
      _metronomeTimer?.cancel();
      _metronomeTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
        setState(() {
          _currentBeat = (_currentBeat + 1) % _beatsPerMeasure;
        });
        _flashController.forward(from: 0.0);
      });
    } else {
      _metronomeTimer?.cancel();
      setState(() => _currentBeat = 0);
    }
  }

  void _onTapTempo() {
    final now = DateTime.now();
    _tapTimes.add(now);
    if (_tapTimes.length > 5) _tapTimes.removeAt(0);

    if (_tapTimes.length >= 2) {
      double totalDiff = 0;
      for (int i = 1; i < _tapTimes.length; i++) {
        totalDiff += _tapTimes[i].difference(_tapTimes[i - 1]).inMilliseconds;
      }
      final avgDiff = totalDiff / (_tapTimes.length - 1);
      final calculatedBpm = (60000 / avgDiff).round().clamp(40, 240);

      setState(() {
        _bpm = calculatedBpm;
      });

      if (_isMetronomeRunning) {
        _toggleMetronome();
        _toggleMetronome();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isStage = themeMode == AppThemeMode.stage;
    final primaryAccent = isStage ? AppColors.stageChord : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Band Session'),
        actions: [
          IconButton(
            icon: Icon(
              isStage ? Icons.nightlife : Icons.nightlife_outlined,
              color: isStage ? AppColors.stageChordAccent : null,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  isStage ? AppThemeMode.dark : AppThemeMode.stage;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions & Explanation Banner
            Card(
              color: Colors.indigo.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.indigo.withOpacity(0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.podcasts, color: Colors.indigo, size: 20),
                        SizedBox(width: 8),
                        Text('Live Stage Performance Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '• Band Leader: Select "Lead Session". As you change songs or transpose keys, all connected member screens update automatically.\n• Band Member: Select "Follow Leader" to automatically follow the leader\'s sheet music on your device.\n• Metronome: Visual beat flasher helps the team lock into tempo silently on stage.',
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => context.push('/groups'),
                          icon: const Icon(Icons.groups, size: 16),
                          label: const Text('Manage Band Members & Songbooks', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Follow the Leader Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.wifi_tethering, color: primaryAccent, size: 28),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Follow The Leader', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Sync active song, section, and key in real time across devices', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment(value: false, label: Text('Band Member (Follower)')),
                              ButtonSegment(value: true, label: Text('Band Leader')),
                            ],
                            selected: {_isLeader},
                            onSelectionChanged: (set) => setState(() => _isLeader = set.first),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (!_isLeader)
                      SwitchListTile(
                        title: const Text('Auto-Sync With Leader'),
                        subtitle: const Text('Automatically jump to song and section pushed by leader'),
                        value: _isFollowing,
                        activeColor: primaryAccent,
                        onChanged: (val) => setState(() => _isFollowing = val),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Metronome & Tap Tempo Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.av_timer, color: primaryAccent),
                            const SizedBox(width: 8),
                            const Text('Stage Metronome', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Beats per measure selector
                        DropdownButton<int>(
                          value: _beatsPerMeasure,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 4, child: Text('4/4 Time')),
                            DropdownMenuItem(value: 3, child: Text('3/4 Time')),
                            DropdownMenuItem(value: 6, child: Text('6/8 Time')),
                            DropdownMenuItem(value: 2, child: Text('2/4 Time')),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _beatsPerMeasure = v);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // BPM Display
                    Text(
                      '$_bpm',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: primaryAccent,
                      ),
                    ),
                    const Text('BEATS PER MINUTE', style: TextStyle(fontSize: 12, letterSpacing: 1.5)),

                    const SizedBox(height: 20),

                    // Visual Beat Flasher
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_beatsPerMeasure, (i) {
                        final isActive = _isMetronomeRunning && _currentBeat == i;
                        final isDownbeat = i == 0;

                        return Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? (isDownbeat ? Colors.redAccent : primaryAccent)
                                : Colors.grey.withOpacity(0.3),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: isDownbeat ? Colors.redAccent : primaryAccent,
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    // BPM Slider & Buttons
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => setState(() => _bpm = (_bpm - 1).clamp(40, 240)),
                          icon: const Icon(Icons.remove),
                        ),
                        Expanded(
                          child: Slider(
                            value: _bpm.toDouble(),
                            min: 40,
                            max: 240,
                            activeColor: primaryAccent,
                            onChanged: (v) => setState(() => _bpm = v.round()),
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () => setState(() => _bpm = (_bpm + 1).clamp(40, 240)),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Controls: Start/Stop & Tap Tempo
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _toggleMetronome,
                            icon: Icon(_isMetronomeRunning ? Icons.stop : Icons.play_arrow),
                            label: Text(_isMetronomeRunning ? 'Stop' : 'Start Metronome'),
                            style: FilledButton.styleFrom(
                              backgroundColor: primaryAccent,
                              foregroundColor: isStage ? Colors.black : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _onTapTempo,
                            icon: const Icon(Icons.touch_app),
                            label: const Text('Tap Tempo'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
