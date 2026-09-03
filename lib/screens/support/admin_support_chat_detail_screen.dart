import 'package:flutter/material.dart';

import '../../services/support_chat_service.dart';

class AdminSupportChatDetailScreen
    extends StatefulWidget {

  final String clientId;
  final String clientEmail;

  const AdminSupportChatDetailScreen({
    super.key,
    required this.clientId,
    required this.clientEmail,
  });

  @override
  State<AdminSupportChatDetailScreen>
  createState() =>
      _AdminSupportChatDetailScreenState();
}

class _AdminSupportChatDetailScreenState
    extends State<
        AdminSupportChatDetailScreen> {

  final SupportChatService
  _chatService =
  SupportChatService();

  final TextEditingController
  _messageController =
  TextEditingController();

  final ScrollController
  _scrollController =
  ScrollController();

  bool _sending = false;

  @override
  void initState() {
    super.initState();

    _chatService
        .markAdminMessagesAsRead(
      widget.clientId,
    );
  }

  @override
  void dispose() {

    _messageController.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  Future<void> _sendMessage() async {

    final text =
    _messageController.text.trim();

    if (text.isEmpty ||
        _sending) {
      return;
    }

    setState(() {
      _sending = true;
    });

    try {

      await _chatService.sendMessageAsAdmin(
        clientId:
        widget.clientId,
        text:
        text,
      );

      _messageController.clear();

    } catch (e) {

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo enviar: $e',
          ),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {
          _sending = false;
        });

      }
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF7F7FB),

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF082D6B),

        foregroundColor:
        Colors.white,

        title: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              'Soporte',
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),

            Text(
              widget.clientEmail,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 12,
                color:
                Colors.white70,
              ),
            ),
          ],
        ),
      ),

      body: Column(

        children: [

          Expanded(

            child: StreamBuilder(

              stream:
              _chatService
                  .adminMessages(
                widget.clientId,
              ),

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
                    child: Text(
                      'Error cargando chat:\n'
                          '${snapshot.error}',
                      textAlign:
                      TextAlign.center,
                    ),
                  );
                }

                final messages =
                    snapshot.data?.docs ??
                        [];

                if (messages.isEmpty) {

                  return const Center(
                    child: Text(
                      'El cliente todavía '
                          'no ha enviado mensajes.',
                      style: TextStyle(
                        color:
                        Colors.grey,
                      ),
                    ),
                  );
                }

                WidgetsBinding.instance
                    .addPostFrameCallback(
                      (_) {

                    if (_scrollController
                        .hasClients) {

                      _scrollController
                          .jumpTo(
                        _scrollController
                            .position
                            .maxScrollExtent,
                      );
                    }
                  },
                );

                return ListView.builder(

                  controller:
                  _scrollController,

                  padding:
                  const EdgeInsets.all(
                    15,
                  ),

                  itemCount:
                  messages.length,

                  itemBuilder:
                      (
                      context,
                      index,
                      ) {

                    final data =
                    messages[index]
                        .data();

                    final isAdmin =
                        data['senderRole'] ==
                            'admin';

                    return Align(

                      alignment:
                      isAdmin
                          ? Alignment
                          .centerRight
                          : Alignment
                          .centerLeft,

                      child: Container(

                        constraints:
                        const BoxConstraints(
                          maxWidth: 300,
                        ),

                        margin:
                        const EdgeInsets
                            .only(
                          bottom: 10,
                        ),

                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 15,
                          vertical: 11,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          isAdmin
                              ? const Color(
                            0xFF0A3B91,
                          )
                              : Colors.white,

                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),

                          boxShadow: const [

                            BoxShadow(
                              color:
                              Colors.black12,
                              blurRadius: 4,
                              offset:
                              Offset(0, 2),
                            ),
                          ],
                        ),

                        child: Text(

                          data['text']
                              ?.toString() ??
                              '',

                          style:
                          TextStyle(
                            color:
                            isAdmin
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SafeArea(

            top: false,

            child: Container(

              padding:
              const EdgeInsets.all(10),

              color:
              Colors.white,

              child: Row(

                children: [

                  Expanded(

                    child: TextField(

                      controller:
                      _messageController,

                      maxLines: 4,
                      minLines: 1,

                      decoration:
                      InputDecoration(

                        hintText:
                        'Responder al cliente...',

                        filled:
                        true,

                        fillColor:
                        const Color(
                          0xFFF1F3F7,
                        ),

                        border:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(
                            22,
                          ),
                          borderSide:
                          BorderSide.none,
                        ),
                      ),

                      onSubmitted:
                          (_) =>
                          _sendMessage(),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(

                    width: 48,
                    height: 48,

                    decoration:
                    const BoxDecoration(
                      color:
                      Color(0xFF0A3B91),
                      shape:
                      BoxShape.circle,
                    ),

                    child: IconButton(

                      onPressed:
                      _sending
                          ? null
                          : _sendMessage,

                      icon:
                      _sending
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                        CircularProgressIndicator(
                          strokeWidth:
                          2,
                          color:
                          Colors.white,
                        ),
                      )
                          : const Icon(
                        Icons.send,
                        color:
                        Colors.white,
                      ),
                    ),
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