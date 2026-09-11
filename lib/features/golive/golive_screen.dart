import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants.dart';

enum StreamMode { screen, camera, prerecorded, alwaysOn }

class StreamModeConfig {
  final String title;
  final IconData icon;
  final Color color;
  final String subtitle;
  final List<String> bullets;

  const StreamModeConfig({
    required this.title,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.bullets,
  });
}

const Map<StreamMode, StreamModeConfig> kModeConfigs = {
  StreamMode.screen: StreamModeConfig(
    title: 'Screen Live Stream',
    icon: Icons.screen_share_rounded,
    color: AppColors.accent,
    subtitle: 'Stream your screen to YouTube with face-cam overlay',
    bullets: [
      'Full HD screen capture with internal audio + mic mixing',
      'Draggable / resizable floating face-cam (round or square)',
      'Draw on screen while streaming',
      'Floating "Go Live" bubble over other apps',
    ],
  ),
  StreamMode.camera: StreamModeConfig(
    title: 'Camera Live Stream',
    icon: Icons.videocam_rounded,
    color: AppColors.primary,
    subtitle: 'Go live on camera with pro effects',
    bullets: [
      'Beauty filters, AR masks, stickers and GIF reactions',
      'AI virtual background without a green screen',
      'Multi-guest rooms (up to 8 guests, PK battles)',
      'Flip camera, flash, focus and exposure control',
    ],
  ),
  StreamMode.prerecorded: StreamModeConfig(
    title: 'Pre-Recorded Live Stream',
    icon: Icons.play_circle_fill_rounded,
    color: AppColors.gold,
    subtitle: 'Schedule a video to play as a "live" stream',
    bullets: [
      'Upload MP4/MOV or pick from gallery',
      'Schedule exact start date and time',
      'Live chat active during playback (simulated live)',
      'Intro / outro bumpers and loop options',
    ],
  ),
  StreamMode.alwaysOn: StreamModeConfig(
    title: '24x7 Always-On Channel',
    icon: Icons.all_inclusive_rounded,
    color: AppColors.success,
    subtitle: 'Run a 24/7 looping channel on YouTube',
    bullets: [
      'Drag-and-drop playlist builder with smart shuffle',
      'Auto-restart watchdog + fallback video',
      'Insert live ads/messages at intervals',
      'Sleep / wake schedule (e.g. off 3AM - 6AM)',
    ],
  ),
};

class GoLiveScreen extends StatefulWidget {
  final StreamMode mode;
  const GoLiveScreen({super.key, required this.mode});

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  bool _live = false;
  int _elapsed = 0;
  Timer? _timer;

  StreamModeConfig get cfg => kModeConfigs[widget.mode]!;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    // TODO(streaming): plug the real pipeline here:
    //   - ffmpeg-kit (https://pub.dev/packages/ffmpeg_kit_flutter) for
    //     encoding / pre-recorded / 24x7 playlist playback, and
    //   - camera + MediaProjection capture feeding the encoder,
    //   - push RTMPS to the Smartyt ingest relay, which forwards to
    //     YouTube Live via the YouTube Live Streaming API.
    // Until then this simulates the stream session so the UI is testable.
    setState(() => _live = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed++);
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() {
      _live = false;
      _elapsed = 0;
    });
  }

  String get _elapsedText {
    final h = (_elapsed ~/ 3600).toString().padLeft(2, '0');
    final m = ((_elapsed % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsed % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cfg.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _live
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('LIVE',
                              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ),
                        const SizedBox(height: 12),
                        Text(_elapsedText, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'Viewers: ${12 + (_elapsed % 40)}   |   Bitrate: 6.2 Mbps   |   Dropped: 0',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cfg.icon, size: 64, color: cfg.color),
                        const SizedBox(height: 12),
                        Text(cfg.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            const Text('What this mode gives you',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final b in cfg.bullets)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_rounded, color: cfg.color, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(b, style: const TextStyle(fontSize: 14))),
                  ],
                ),
              ),
            const SizedBox(height: 28),
            if (_live)
              OutlinedButton.icon(
                onPressed: _stop,
                icon: const Icon(Icons.stop_rounded, color: AppColors.danger),
                label: const Text('End Stream', style: TextStyle(color: AppColors.danger)),
              )
            else
              ElevatedButton.icon(
                onPressed: _start,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start Stream'),
              ),
          ],
        ),
      ),
    );
  }
}
