import 'package:chat_app/app/data/services/auth/auth_service.dart';
import 'package:chat_app/core/utils/constants/sizes.dart';
import 'package:chat_app/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controller/chat_controller.dart';
import 'widget/message_bubble.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    final user = Get.find<AuthService>().currentUser;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          centerTitle: false,
          title: Builder(
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Group Chat',
                    style: TextStyle(fontFamily: GoogleFonts.cherrySwash().fontFamily, fontWeight: FontWeight.w700, fontSize: 40, color: HColors.textWhite),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('Hi, ${user?.name ?? '<Username>'}', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: HColors.textWhite), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
        body: Column(
          children: [
            // Chat messages area
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.messages.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(HSizes.md16),
                  itemCount: controller.messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    // Get message from the beginning of the list since we're using reverse: true
                    final message = controller.messages[index];

                    // Convert both IDs to integers for comparison
                    final isCurrentUser = int.parse(message.chatDetails?.userId ?? "0") == user?.id;

                    final messageSender = message.userDetails?.name.split(' ').first ?? 'Unknown';

                    // Get image URL if present
                    final imageUrl = message.chatDetails?.image as String?;

                    return MessageBubble(
                      message: message.chatDetails?.message ?? '',
                      sender: messageSender,
                      time: _formatTime(message.chatDetails?.createdAt),
                      isCurrentUser: isCurrentUser,
                      imageUrl: imageUrl,
                    );
                  },
                );
              }),
            ),

            // Image preview if an image is selected
            Obx(() {
              if (controller.selectedImage.value != null) {
                return Container(
                  padding: const EdgeInsets.all(HSizes.sm8),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(HSizes.sm8), image: DecorationImage(image: FileImage(controller.selectedImage.value!), fit: BoxFit.cover)),
                            ),
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(HSizes.xs4),
                                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(HSizes.md16)),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                              onPressed: controller.clearSelectedImage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Message input area
            Container(
              padding: const EdgeInsets.all(HSizes.sm8),
              decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1))),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: HColors.secondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: HColors.borderPrimary)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(child: Icon(Icons.emoji_emotions_outlined, color: HColors.primary, size: 30), onTap: () => controller.showEmoji.toggle()),
                          const SizedBox(width: HSizes.sm8),
                          Expanded(
                            child: TextField(
                              controller: controller.textController,
                              decoration: const InputDecoration(hintText: 'Enter Message', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: HSizes.sm8)),
                            ),
                          ),
                          InkWell(
                            child: Icon(Icons.image_outlined, color: HColors.primary, size: 30),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder:
                                    (context) => Padding(
                                      padding: const EdgeInsets.all(HSizes.md16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.photo_library),
                                            title: const Text('Gallery'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              controller.pickImage(ImageSource.gallery);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.camera_alt),
                                            title: const Text('Camera'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              controller.pickImage(ImageSource.camera);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: HSizes.lg24 / 2),
                  Obx(
                    () => Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(color: const Color(0xFF4A9B9B), borderRadius: BorderRadius.circular(12)),
                      child:
                          controller.isLoading.value
                              ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                              : IconButton(
                                icon: const Icon(Icons.send, color: Colors.white, size: 22),
                                onPressed: () {
                                  if (controller.textController.text.trim().isNotEmpty || controller.selectedImage.value != null) {
                                    controller.sendMessage(controller.textController.text);
                                    controller.textController.clear();
                                  }
                                },
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('h:mm a').format(dateTime.toLocal());
  }
}
