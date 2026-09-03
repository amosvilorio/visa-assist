import 'package:flutter/material.dart';
import '../../services/support_chat_service.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({
    super.key,
  });

  @override
  State<SupportChatScreen> createState() =>
      _SupportChatScreenState();
}

class _SupportChatScreenState
    extends State<SupportChatScreen> {

  final SupportChatService _chatService =
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
        .createOrUpdateConversation();

    _chatService
        .markClientMessagesAsRead();
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

    if (text.isEmpty || _sending) {
      return;
    }

    setState(() {
      _sending = true;
    });

    try {

      await _chatService.sendMessage(
        text: text,
        senderRole: 'client',
      );

      _messageController.clear();

      await Future.delayed(
        const Duration(
          milliseconds: 150,
        ),
      );

      if (_scrollController
          .hasClients) {

        _scrollController.animateTo(
          _scrollController
              .position
              .maxScrollExtent,
          duration:
          const Duration(
            milliseconds: 250,
          ),
          curve:
          Curves.easeOut,
        );
      }

    } catch (e) {

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo enviar el mensaje: $e',
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

        title: const Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              'Soporte Visa Assist',
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),

            Text(
              'Estamos para ayudarte',
              style: TextStyle(
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

          // ==================================================
          // AVISO
          // ==================================================

          Container(

            width:
            double.infinity,

            padding:
            const EdgeInsets.all(12),

            color:
            const Color(0xFFEAF3FF),

            child: const Row(

              children: [

                Icon(
                  Icons.support_agent,
                  color:
                  Color(0xFF0A3B91),
                ),

                SizedBox(width: 10),

                Expanded(

                  child: Text(
                    'Escribe tu consulta y nuestro equipo '
                        'te responderá por este mismo chat.',
                    style: TextStyle(
                      fontSize: 13,
                      color:
                      Color(0xFF082D6B),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // MENSAJES
          // ==================================================

          Expanded(

            child: StreamBuilder(

              stream:
              _chatService
                  .clientMessages(),

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
                            'los mensajes.\n\n'
                            '${snapshot.error}',
                        textAlign:
                        TextAlign.center,
                      ),
                    ),
                  );
                }

                final messages =
                    snapshot.data?.docs ??
                        [];

                if (messages.isEmpty) {

                  return const Center(

                    child: Padding(

                      padding:
                      EdgeInsets.all(30),

                      child: Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          Icon(
                            Icons.chat_bubble_outline,
                            size: 60,
                            color:
                            Color(0xFF0A3B91),
                          ),

                          SizedBox(height: 15),

                          Text(
                            'Inicia la conversación',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Escribe tu pregunta o consulta '
                                'y nuestro equipo de soporte '
                                'te responderá.',
                            textAlign:
                            TextAlign.center,
                            style: TextStyle(
                              color:
                              Colors.grey,
                            ),
                          ),
                        ],
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
                  const EdgeInsets.fromLTRB(
                    14,
                    18,
                    14,
                    18,
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

                    final isClient =
                        data['senderRole'] ==
                            'client';

                    return _messageBubble(
                      text:
                      data['text']
                          ?.toString() ??
                          '',

                      isClient:
                      isClient,
                    );
                  },
                );
              },
            ),
          ),

          // ==================================================
          // CAMPO DE MENSAJE
          // ==================================================

          SafeArea(

            top: false,

            child: Container(

              padding:
              const EdgeInsets.fromLTRB(
                10,
                8,
                10,
                8,
              ),

              decoration:
              const BoxDecoration(

                color:
                Colors.white,

                boxShadow: [

                  BoxShadow(
                    color:
                    Colors.black12,
                    blurRadius: 8,
                    offset:
                    Offset(0, -2),
                  ),
                ],
              ),

              child: Row(

                children: [

                  Expanded(

                    child: TextField(

                      controller:
                      _messageController,

                      minLines: 1,

                      maxLines: 4,

                      textCapitalization:
                      TextCapitalization.sentences,

                      decoration:
                      InputDecoration(

                        hintText:
                        'Escribe tu mensaje...',

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

                        contentPadding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 16,
                          vertical: 10,
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

  Widget _messageBubble({
    required String text,
    required bool isClient,
  }) {

    return Align(

      alignment:
      isClient
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(

        constraints:
        const BoxConstraints(
          maxWidth: 300,
        ),

        margin:
        const EdgeInsets.only(
          bottom: 10,
        ),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),

        decoration:
        BoxDecoration(

          color:
          isClient
              ? const Color(
            0xFF0A3B91,
          )
              : Colors.white,

          borderRadius:
          BorderRadius.only(

            topLeft:
            const Radius.circular(18),

            topRight:
            const Radius.circular(18),

            bottomLeft:
            Radius.circular(
              isClient ? 18 : 4,
            ),

            bottomRight:
            Radius.circular(
              isClient ? 4 : 18,
            ),
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

          text,

          style: TextStyle(

            color:
            isClient
                ? Colors.white
                : Colors.black87,

            fontSize: 15,

            height: 1.35,
          ),
        ),
      ),
    );
  }
}