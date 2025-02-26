import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/utils/theme/colors.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String sender;
  final String time;
  final bool isCurrentUser;
  final String? imageUrl;

  const MessageBubble({super.key, required this.message, required this.sender, required this.time, required this.isCurrentUser, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HSizes.xs4),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: isCurrentUser ? 0 : HSizes.xs4, right: isCurrentUser ? HSizes.xs4 : 0, bottom: HSizes.xs4),
            child: Text(sender, style: TextStyle(color: isCurrentUser ? Colors.blue : HColors.primary, fontWeight: FontWeight.w600, fontSize: 15)),
          ),
          Row(
            mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isCurrentUser) ...[Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)), const SizedBox(width: HSizes.xs4)],
              if (!isCurrentUser) const SizedBox(width: HSizes.xs4),
              Flexible(
                child: Container(
                  padding: imageUrl != null ? const EdgeInsets.all(HSizes.xs4) : const EdgeInsets.symmetric(horizontal: HSizes.md16, vertical: HSizes.md16),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.lightBlue.shade100 : Colors.lightBlue.shade50,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(HSizes.md16),
                      topRight: const Radius.circular(HSizes.md16),
                      bottomLeft: Radius.circular(isCurrentUser ? HSizes.md16 : 0),
                      bottomRight: Radius.circular(isCurrentUser ? 0 : HSizes.md16),
                    ),
                  ),
                  child:
                      imageUrl != null
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(HSizes.lg24 / 2),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl!,
                                  placeholder: (context, url) => Container(height: 200, width: 200, color: Colors.grey[300], child: const Center(child: CircularProgressIndicator())),
                                  errorWidget: (context, url, error) => Container(height: 200, width: 200, color: Colors.grey[300], child: const Icon(Icons.error)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (message.isNotEmpty) ...[
                                const SizedBox(height: HSizes.sm8),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: HSizes.sm8), child: Text(message, style: const TextStyle(fontSize: 15, color: Colors.black87))),
                              ],
                            ],
                          )
                          : Text(message, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                ),
              ),
              if (!isCurrentUser) ...[const SizedBox(width: HSizes.xs4), Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600))],
            ],
          ),
        ],
      ),
    );
  }
}
