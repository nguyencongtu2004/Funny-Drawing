import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({
    super.key,
    required this.scrollController,
    required this.chatMessages,
  });

  final ScrollController scrollController;
  final List<Map<String, dynamic>> chatMessages;

  @override
  ConsumerState<ChatList> createState() => _ChatList();
}

class _ChatList extends ConsumerState<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.chatMessages.length,
      itemBuilder: (context, index) {
        final item = widget.chatMessages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: item['userName'] == 'Hệ thống'
              ? Center(
                  child: Text(
                    '--${item['message']}--',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00705A),
                        ),
                  ),
                )
              : item['userName'] != 'Đáp án'
                  ? Text(
                      '${item['userName']}: ${item['message']}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  : Center(
                      child: Text(
                        '--${item['message']}--',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFf8fc00),
                            ),
                      ),
                    ),
        );
      },
    );
  }
}
