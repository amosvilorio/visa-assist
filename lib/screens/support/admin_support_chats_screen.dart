import 'package:flutter/material.dart';

import '../../services/support_chat_service.dart';
import 'admin_support_chat_detail_screen.dart';

class AdminSupportChatsScreen
    extends StatelessWidget {

  const AdminSupportChatsScreen({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      ) {

    final chatService =
    SupportChatService();

    return Scaffold(

      backgroundColor:
      const Color(0xFFF7F7FB),

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF082D6B),

        foregroundColor:
        Colors.white,

        title: const Text(
          'Chats de Soporte',
          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder(

        stream:
        chatService
            .adminConversations(),

        builder:
            (
            context,
            snapshot,
            ) {

          if (snapshot
              .connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(
                  20,
                ),
                child: Text(
                  'No se pudieron cargar '
                      'las conversaciones.\n\n'
                      '${snapshot.error}',
                  textAlign:
                  TextAlign.center,
                ),
              ),
            );
          }

          final conversations =
              snapshot.data?.docs ??
                  [];

          if (conversations.isEmpty) {

            return const Center(

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.chat_bubble_outline,
                    size: 65,
                    color:
                    Color(0xFF0A3B91),
                  ),

                  SizedBox(height: 15),

                  Text(
                    'No hay conversaciones',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Cuando un cliente contacte '
                        'con soporte aparecerá aquí.',
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      color:
                      Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(

            padding:
            const EdgeInsets.all(16),

            itemCount:
            conversations.length,

            itemBuilder:
                (
                context,
                index,
                ) {

              final doc =
              conversations[index];

              final data =
              doc.data();

              final clientEmail =
                  data['clientEmail']
                      ?.toString() ??
                      'Cliente';

              final lastMessage =
                  data['lastMessage']
                      ?.toString() ??
                      'Sin mensajes';

              final unread =
                  data['unreadForAdmin'] ==
                      true;

              return Card(

                margin:
                const EdgeInsets.only(
                  bottom: 12,
                ),

                elevation: 3,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),

                child: ListTile(

                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  leading: CircleAvatar(

                    radius: 26,

                    backgroundColor:
                    const Color(
                      0xFFEAF3FF,
                    ),

                    child: const Icon(
                      Icons.person,
                      color:
                      Color(0xFF0A3B91),
                    ),
                  ),

                  title: Row(

                    children: [

                      Expanded(

                        child: Text(
                          clientEmail,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,

                          style: TextStyle(
                            fontWeight:
                            unread
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                      ),

                      if (unread)
                        Container(

                          width: 10,
                          height: 10,

                          decoration:
                          const BoxDecoration(
                            color:
                            Colors.red,
                            shape:
                            BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  subtitle: Padding(

                    padding:
                    const EdgeInsets.only(
                      top: 5,
                    ),

                    child: Text(
                      lastMessage,

                      maxLines: 2,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      TextStyle(
                        color:
                        unread
                            ? Colors.black87
                            : Colors.grey,
                        fontWeight:
                        unread
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),

                  trailing:
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),

                  onTap: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            AdminSupportChatDetailScreen(
                              clientId:
                              doc.id,

                              clientEmail:
                              clientEmail,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}