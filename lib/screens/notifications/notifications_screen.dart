import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static final NotificationService _notificationService =
  NotificationService();

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();

    final day =
    date.day.toString().padLeft(2, '0');

    final month =
    date.month.toString().padLeft(2, '0');

    final hour =
    date.hour.toString().padLeft(2, '0');

    final minute =
    date.minute.toString().padLeft(2, '0');

    return "$day/$month/${date.year} $hour:$minute";
  }

  IconData _getIcon(String type) {
    switch (type) {
      case "service_payment_received":
        return Icons.payments;

      case "service_payment_approved":
        return Icons.check_circle;

      case "service_payment_rejected":
        return Icons.cancel;

      case "evaluation_payment_received":
        return Icons.assignment;

      case "premium_evaluation_received":
        return Icons.star;

      case "mrv_payment_received":
        return Icons.account_balance;

      case "ds160_uploaded":
        return Icons.description;

      case "cas_appointment":
        return Icons.camera_alt;

      case "consular_appointment":
        return Icons.event;

      case "appointment_reminder_24h":
        return Icons.notifications_active;

      case "appointment_reminder_5h":
        return Icons.alarm;

      default:
        return Icons.notifications;
    }
  }

  Future<void> _openNotification(
      BuildContext context,
      String notificationId,
      ) async {
    await _notificationService.markAsRead(
      notificationId: notificationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notificaciones",
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<int>(
            stream:
            _notificationService.watchUnreadCount(),
            builder: (context, snapshot) {
              final count =
                  snapshot.data ?? 0;

              if (count == 0) {
                return const SizedBox();
              }

              return Padding(
                padding:
                const EdgeInsets.only(right: 15),
                child: Center(
                  child: Text(
                    "$count nuevas",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream:
        _notificationService.watchMyNotifications(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
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
                const EdgeInsets.all(25),
                child: Text(
                  "No se pudieron cargar las notificaciones.\n\n${snapshot.error}",
                  textAlign:
                  TextAlign.center,
                ),
              ),
            );
          }

          final docs =
              snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No tienes notificaciones.",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding:
            const EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder:
                (context, index) {
              final doc = docs[index];

              final data = doc.data();

              final title =
                  data["title"] ?? "";

              final message =
                  data["message"] ?? "";

              final type =
                  data["type"] ?? "";

              final read =
                  data["read"] ?? false;

              final createdAt =
              data["createdAt"];

              return Card(
                margin:
                const EdgeInsets.only(
                  bottom: 12,
                ),
                elevation:
                read ? 1 : 4,
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),

                  leading: CircleAvatar(
                    child: Icon(
                      _getIcon(type),
                    ),
                  ),

                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: read
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),

                  subtitle: Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 6,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(message),

                        if (createdAt
                        is Timestamp)
                          Padding(
                            padding:
                            const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Text(
                              _formatDate(
                                createdAt,
                              ),
                              style:
                              const TextStyle(
                                fontSize: 12,
                                color:
                                Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  trailing: read
                      ? null
                      : const Icon(
                    Icons.circle,
                    size: 10,
                  ),

                  onTap: () {
                    _openNotification(
                      context,
                      doc.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton:
      StreamBuilder<int>(
        stream:
        _notificationService
            .watchUnreadCount(),
        builder:
            (context, snapshot) {
          final count =
              snapshot.data ?? 0;

          if (count == 0) {
            return const SizedBox();
          }

          return FloatingActionButton.extended(
            onPressed: () async {
              await _notificationService
                  .markAllAsRead();
            },
            icon: const Icon(
              Icons.done_all,
            ),
            label: const Text(
              "Marcar todas",
            ),
          );
        },
      ),
    );
  }
}