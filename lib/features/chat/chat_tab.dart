import 'package:flutter/material.dart';

import '../../core/constants.dart';

class ChatMessage {
  final String user;
  final String text;
  final bool isMod;
  final bool isPinned;

  ChatMessage({
    required this.user,
    required this.text,
    this.isMod = false,
    this.isPinned = false,
  });
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  bool _slowMode = false;
  bool _followersOnly = false;

  final List<ChatMessage> _messages = [
    ChatMessage(user: 'AlexGamer', text: 'First! Great stream!'),
    ChatMessage(user: 'SarahVlogs', text: 'Can you show the settings panel?'),
    ChatMessage(user: 'ModBot', text: 'Slow mode is OFF', isMod: true),
    ChatMessage(user: 'PixelArt', text: 'Love the new overlay!'),
  ];

  void _send() {
    final t = _controller.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(user: 'You', text: t, isMod: true));
    });
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  void _modAction(int index, String action) {
    setState(() {
      if (action == 'Pin') {
        _messages[index] = ChatMessage(
          user: _messages[index].user,
          text: _messages[index].text,
          isPinned: true,
        );
      } else if (action == 'Delete') {
        _messages.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat'),
        actions: [
          IconButton(
            tooltip: 'Slow mode',
            icon: Icon(Icons.timer_rounded, color: _slowMode ? AppColors.gold : null),
            onPressed: () => setState(() => _slowMode = !_slowMode),
          ),
          IconButton(
            tooltip: 'Followers only',
            icon: Icon(Icons.group_rounded, color: _followersOnly ? AppColors.gold : null),
            onPressed: () => setState(() => _followersOnly = !_followersOnly),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_slowMode || _followersOnly)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: AppColors.cardLight,
              child: Text(
                '${_slowMode ? 'Slow mode ON  ' : ''}${_followersOnly ? 'Followers-only chat' : ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.gold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final m = _messages[i];
                return Card(
                  color: m.isPinned ? AppColors.primary.withOpacity(0.15) : AppColors.card,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: m.isMod ? AppColors.gold : AppColors.cardLight,
                      child: Text(m.user[0].toUpperCase(),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: m.user,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          if (m.isPinned)
                            const TextSpan(
                              text: '  Pinned',
                              style: TextStyle(color: AppColors.primary, fontSize: 11),
                            ),
                        ],
                      ),
                    ),
                    subtitle: Text(m.text, style: const TextStyle(fontSize: 14)),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) => _modAction(i, v),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'Pin', child: Text('Pin message')),
                        const PopupMenuItem(value: 'Timeout 1m', child: Text('Timeout 1 min')),
                        const PopupMenuItem(value: 'Ban', child: Text('Ban user')),
                        const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.card,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Send a message...'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
