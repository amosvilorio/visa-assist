const {setGlobalOptions} = require("firebase-functions");
const {
  onDocumentCreated,
  onDocumentUpdated,
} = require("firebase-functions/v2/firestore");
const {
  initializeApp,
} = require("firebase-admin/app");

const {
  getFirestore,
} = require("firebase-admin/firestore");

const {
  getMessaging,
} = require("firebase-admin/messaging");

const logger = require("firebase-functions/logger");

initializeApp();

setGlobalOptions({
  maxInstances: 10,
  region: "us-central1",
});

// Enviar push cuando se crea una notificación.
exports.sendNotificationPush = onDocumentCreated(
    "users/{userId}/notifications/{notificationId}",
    async (event) => {
      try {
        const notificationSnapshot = event.data;

        if (!notificationSnapshot) {
          logger.warn(
              "No se encontró el documento de notificación.",
          );
          return;
        }

        const notification = notificationSnapshot.data();
        const userId = event.params.userId;
        const notificationId = event.params.notificationId;

        const userSnapshot = await getFirestore()
            .collection("users")
            .doc(userId)
            .get();

        if (!userSnapshot.exists) {
          logger.warn(
              `No existe el usuario ${userId}.`,
          );
          return;
        }

        const userData = userSnapshot.data() || {};
        const fcmToken = userData.fcmToken;

        if (!fcmToken) {
          logger.info(
              `El usuario ${userId} no tiene FCM token.`,
          );
          return;
        }

        const title =
            notification.title || "Visa Assist";

        const body =
            notification.message ||
            "Tienes una nueva notificación.";

        const type =
            notification.type || "general";

        const expedienteId =
            notification.expedienteId || "";

        const message = {
          token: fcmToken,

          notification: {
            title: title,
            body: body,
          },

          data: {
            notificationId: String(notificationId),
            type: String(type),
            expedienteId: String(expedienteId),
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },

          android: {
            priority: "high",

            notification: {
           channelId: "visa_assist_notifications_v2",
              sound: "default",
              defaultSound: true,
              defaultVibrateTimings: true,
              defaultLightSettings: true,
            },
          },

          apns: {
            payload: {
              aps: {
                sound: "default",
                badge: 1,
              },
            },
          },
        };

        const response =
            await getMessaging().send(message);

        logger.info(
            "NOTIFICACIÓN PUSH ENVIADA",
            {
              userId: userId,
              notificationId: notificationId,
              messageId: response,
              type: type,
            },
        );
      } catch (error) {
        logger.error(
            "ERROR ENVIANDO NOTIFICACIÓN PUSH",
            error,
        );

        if (
          error.code ===
          "messaging/registration-token-not-registered"
        ) {
          try {
            const userId = event.params.userId;

            await getFirestore()
                .collection("users")
                .doc(userId)
                .update({
                  fcmToken: null,
                });

            logger.info(
                `Token FCM eliminado para ${userId}.`,
            );
          } catch (cleanupError) {
            logger.error(
                "ERROR ELIMINANDO TOKEN FCM",
                cleanupError,
            );
          }
        }
      }
    },
);

// Crear notificación para administradores cuando llega un pago.
exports.notifyAdminsOnPaymentCreated = onDocumentCreated(
    "payments/{paymentId}",
    async (event) => {
      try {
        const paymentSnapshot = event.data;

        if (!paymentSnapshot) {
          logger.warn(
              "No se encontró el documento del pago.",
          );
          return;
        }

        const payment = paymentSnapshot.data();
        const paymentId = event.params.paymentId;

        const paymentType =
            payment.paymentType || "";

        const expedienteId =
            payment.expedienteId || "";

        const amount =
            payment.amount || 0;

        const currency =
            payment.currency || "";

        const status =
            payment.status || "";

        // Solo procesamos pagos pendientes.
        if (status !== "pending") {
          logger.info(
              `Pago ${paymentId} ignorado porque ` +
              `su estado es ${status}.`,
          );
          return;
        }

        let title = "";
        let message = "";
        let type = "";

               if (paymentType === "evaluation") {
                 title = "Nuevo pago Premium";

                 message =
                     "Un cliente ha enviado un comprobante " +
                     "para desbloquear la evaluación Premium.";

                 type = "evaluation_payment_received";
               } else if (paymentType === "service") {
                 title = "Nuevo pago del servicio";

                 message =
                     "Un cliente ha enviado un comprobante " +
                     "de pago para el servicio Visa Assist.";

                 type = "service_payment_received";
               } else if (paymentType === "mrv") {
                 title = "Nuevo pago MRV";

                 message =
                     `Un cliente ha enviado un comprobante ` +
                     `de pago MRV por ${currency} ${Number(amount).toFixed(2)}.`;

                 type = "mrv_payment_received";
               } else {
                 logger.info(
                     `Pago ${paymentId} de tipo ` +
                     `${paymentType} ignorado.`,
                 );
                 return;
               }

        // Buscar administradores.
        const adminsSnapshot =
            await getFirestore()
                .collection("users")
                .where("role", "==", "admin")
                .get();

        logger.info(
            `Administradores encontrados: ` +
            `${adminsSnapshot.size}`,
        );

        if (adminsSnapshot.empty) {
          logger.warn(
              "No se encontraron administradores.",
          );
          return;
        }

        // Crear notificación para cada administrador.
        const batch = getFirestore().batch();

        for (const adminDoc of adminsSnapshot.docs) {
          const notificationRef =
              getFirestore()
                  .collection("users")
                  .doc(adminDoc.id)
                  .collection("notifications")
                  .doc();

          batch.set(
              notificationRef,
              {
                title: title,
                message: message,
                type: type,
                expedienteId: expedienteId,

                data: {
                  paymentId: paymentId,
                  paymentType: paymentType,
                  amount: amount,
                  currency: currency,
                },

                read: false,
                createdAt: new Date(),
              },
          );
        }

                await batch.commit();

                logger.info(
                    "NOTIFICACIONES DE PAGO CREADAS " +
                    "PARA ADMINISTRADORES",
                    {
                      paymentId: paymentId,
                      paymentType: paymentType,
                      admins: adminsSnapshot.size,
                    },
                );
              } catch (error) {
                logger.error(
                    "ERROR CREANDO NOTIFICACIONES " +
                    "PARA ADMINISTRADORES",
                    error,
                );
              }
            },
        );

        // ============================================================
        // NOTIFICACIONES DE SOLICITUD DE MONTO MRV
        // ============================================================

        exports.notifyMrvAmountStatusChanged = onDocumentUpdated(
            "expedientes/{expedienteId}",
            async (event) => {
              try {
                const beforeSnapshot = event.data.before;
                const afterSnapshot = event.data.after;

                if (!beforeSnapshot.exists || !afterSnapshot.exists) {
                  return;
                }

                const before = beforeSnapshot.data() || {};
                const after = afterSnapshot.data() || {};

                const expedienteId = event.params.expedienteId;

                const previousStatus =
                    before.mrvAmountRequestStatus || "none";

                const currentStatus =
                    after.mrvAmountRequestStatus || "none";

                const userId =
                    after.userId || "";

                if (!userId) {
                  logger.warn(
                      `El expediente ${expedienteId} no tiene userId.`,
                  );
                  return;
                }

                // ========================================================
                // CLIENTE SOLICITÓ EL MONTO EN PESOS
                // ========================================================

                if (
                  previousStatus !== "pending" &&
                  currentStatus === "pending"
                ) {
                  logger.info(
                      "NUEVA SOLICITUD DE MONTO MRV",
                      {
                        expedienteId: expedienteId,
                        userId: userId,
                      },
                  );

                  const adminsSnapshot =
                      await getFirestore()
                          .collection("users")
                          .where("role", "==", "admin")
                          .get();

                  if (adminsSnapshot.empty) {
                    logger.warn(
                        "No se encontraron administradores " +
                        "para notificar solicitud MRV.",
                    );
                    return;
                  }

                  const batch = getFirestore().batch();

                  for (const adminDoc of adminsSnapshot.docs) {
                    const notificationRef =
                        getFirestore()
                            .collection("users")
                            .doc(adminDoc.id)
                            .collection("notifications")
                            .doc();

                    batch.set(
                        notificationRef,
                        {
                          title: "Nueva solicitud MRV",

                          message:
                              "Un cliente ha solicitado el " +
                              "monto de US$185 en pesos dominicanos.",

                          type: "mrv_amount_requested",

                          expedienteId: expedienteId,

                          data: {
                            expedienteId: expedienteId,
                            amountUsd:
                                after.mrvAmountRequestedUsd || 185,
                          },

                          read: false,

                          createdAt: new Date(),
                        },
                    );
                  }

                  await batch.commit();

                  logger.info(
                      "NOTIFICACIÓN MRV ENVIADA A ADMINISTRADORES",
                      {
                        expedienteId: expedienteId,
                        admins: adminsSnapshot.size,
                      },
                  );

                  return;
                }

                // ========================================================
                // ADMIN RESPONDIÓ EL MONTO EN PESOS
                // ========================================================

                if (
                  previousStatus !== "responded" &&
                  currentStatus === "responded"
                ) {
                  const dopAmount =
                      after.mrvDopAmount || 0;

                  logger.info(
                      "ADMIN RESPONDIÓ MONTO MRV",
                      {
                        expedienteId: expedienteId,
                        userId: userId,
                        dopAmount: dopAmount,
                      },
                  );

                  const notificationRef =
                      getFirestore()
                          .collection("users")
                          .doc(userId)
                          .collection("notifications")
                          .doc();

                  await notificationRef.set({
                    title: "Monto MRV disponible",

                    message:
                        `Ya puedes consultar el monto en pesos ` +
                        `dominicanos correspondiente a tu tarifa MRV: ` +
                        `RD$ ${Number(dopAmount).toFixed(2)}.`,

                    type: "mrv_amount_response",

                    expedienteId: expedienteId,

                    data: {
                      expedienteId: expedienteId,
                      amountUsd:
                          after.mrvAmountRequestedUsd || 185,
                      amountDop: dopAmount,
                    },

                    read: false,

                    createdAt: new Date(),
                  });

                  logger.info(
                      "NOTIFICACIÓN MRV ENVIADA AL CLIENTE",
                      {
                        expedienteId: expedienteId,
                        userId: userId,
                        dopAmount: dopAmount,
                      },
                  );
                }
              } catch (error) {
                logger.error(
                    "ERROR EN NOTIFICACIÓN DE MONTO MRV",
                    error,
                );
              }
            },
        );

        // ============================================================
        // NOTIFICACIONES DE ACTUALIZACIÓN DEL PROCESO DE VISA
        // DS-160 / CITA CAS / ENTREVISTA CONSULAR
        // ============================================================

        exports.notifyVisaProcessUpdated = onDocumentUpdated(
            "expedientes/{expedienteId}",
            async (event) => {
              try {
                const beforeSnapshot = event.data.before;
                const afterSnapshot = event.data.after;

                if (!beforeSnapshot.exists || !afterSnapshot.exists) {
                  return;
                }

                const before = beforeSnapshot.data() || {};
                const after = afterSnapshot.data() || {};

                const expedienteId = event.params.expedienteId;

                const userId = after.userId || "";

                if (!userId) {
                  logger.warn(
                      `El expediente ${expedienteId} no tiene userId.`,
                  );
                  return;
                }

                const beforeVisa =
                    before.visaProcessInformation || {};

                const afterVisa =
                    after.visaProcessInformation || {};

                                    // ========================================================
                                    // 1. PERFIL CAS - USUARIO Y CONTRASEÑA ACTUALIZADOS
                                    // ========================================================

                                    const beforeCasUsername =
                                        beforeVisa.casUsername || "";

                                    const afterCasUsername =
                                        afterVisa.casUsername || "";

                                    const beforeCasPassword =
                                        beforeVisa.casPassword || "";

                                    const afterCasPassword =
                                        afterVisa.casPassword || "";

                                    const casCredentialsChanged =
                                        beforeCasUsername !== afterCasUsername ||
                                        beforeCasPassword !== afterCasPassword;

                                    if (
                                      casCredentialsChanged &&
                                      (
                                        afterCasUsername !== "" ||
                                        afterCasPassword !== ""
                                      )
                                    ) {
                                      const notificationRef =
                                          getFirestore()
                                              .collection("users")
                                              .doc(userId)
                                              .collection("notifications")
                                              .doc();

                                      await notificationRef.set({
                                        title: "Perfil CAS actualizado",

                                        message:
                                            "Tu usuario y contraseña del perfil CAS " +
                                            "han sido registrados por nuestro equipo. " +
                                            "Ya puedes consultarlos desde tu expediente.",

                                        type: "cas_credentials_updated",

                                        expedienteId: expedienteId,

                                        data: {
                                          expedienteId: expedienteId,
                                        },

                                        read: false,

                                        createdAt: new Date(),
                                      });

                                      logger.info(
                                          "NOTIFICACIÓN PERFIL CAS ENVIADA AL CLIENTE",
                                          {
                                            expedienteId: expedienteId,
                                            userId: userId,
                                          },
                                      );
                                    }

                                    // ========================================================
                                    // 2. DS-160 SUBIDO
                                    // ========================================================

                // ========================================================
                // 1. DS-160 SUBIDO
                // ========================================================

                const beforeDs160Url =
                    beforeVisa.ds160PdfUrl || "";

                const afterDs160Url =
                    afterVisa.ds160PdfUrl || "";

                if (
                  beforeDs160Url !== afterDs160Url &&
                  afterDs160Url !== ""
                ) {
                  const notificationRef =
                      getFirestore()
                          .collection("users")
                          .doc(userId)
                          .collection("notifications")
                          .doc();

                  await notificationRef.set({
                    title: "DS-160 disponible",

                    message:
                        "Tu formulario DS-160 ha sido cargado por " +
                        "nuestro equipo. Ya puedes consultarlo " +
                        "desde tu expediente.",

                    type: "ds160_uploaded",

                    expedienteId: expedienteId,

                    data: {
                      expedienteId: expedienteId,
                      ds160FileName:
                          afterVisa.ds160FileName || "",
                      ds160PdfUrl: afterDs160Url,
                    },

                    read: false,

                    createdAt: new Date(),
                  });

                  logger.info(
                      "NOTIFICACIÓN DS-160 ENVIADA AL CLIENTE",
                      {
                        expedienteId: expedienteId,
                        userId: userId,
                      },
                  );
                }

                // ========================================================
                // 2. CITA CAS - HUELLA Y FOTO
                // ========================================================

                const beforeCasDate =
                    before.casAppointmentDate || "";

                const afterCasDate =
                    after.casAppointmentDate || "";

                const beforeCasTime =
                    before.casAppointmentTime || "";

                const afterCasTime =
                    after.casAppointmentTime || "";

                const beforeCasLocation =
                    before.casLocation || "";

                const afterCasLocation =
                    after.casLocation || "";

                const casChanged =
                    beforeCasDate !== afterCasDate ||
                    beforeCasTime !== afterCasTime ||
                    beforeCasLocation !== afterCasLocation;

                if (
                  casChanged &&
                  (
                    afterCasDate !== "" ||
                    afterCasTime !== ""
                  )
                ) {
                  const notificationRef =
                      getFirestore()
                          .collection("users")
                          .doc(userId)
                          .collection("notifications")
                          .doc();

                  await notificationRef.set({
                    title: "Cita de huellas y foto disponible",

                    message:
                        "Tu cita para huellas y fotografía ha sido " +
                        "registrada. Consulta la fecha, hora y " +
                        "ubicación en tu expediente.",

                    type: "cas_appointment_updated",

                    expedienteId: expedienteId,

                    data: {
                      expedienteId: expedienteId,
                      date: afterCasDate,
                      time: afterCasTime,
                      location: afterCasLocation,
                    },

                    read: false,

                    createdAt: new Date(),
                  });

                  logger.info(
                      "NOTIFICACIÓN CITA CAS ENVIADA AL CLIENTE",
                      {
                        expedienteId: expedienteId,
                        userId: userId,
                      },
                  );
                }

                // ========================================================
                // 3. ENTREVISTA CONSULAR
                // ========================================================

                const beforeInterviewDate =
                    before.interviewDate || "";

                const afterInterviewDate =
                    after.interviewDate || "";

                const beforeInterviewTime =
                    before.interviewTime || "";

                const afterInterviewTime =
                    after.interviewTime || "";

                const beforeInterviewLocation =
                    before.interviewLocation || "";

                const afterInterviewLocation =
                    after.interviewLocation || "";

                const interviewChanged =
                    beforeInterviewDate !== afterInterviewDate ||
                    beforeInterviewTime !== afterInterviewTime ||
                    beforeInterviewLocation !== afterInterviewLocation;

                if (
                  interviewChanged &&
                  (
                    afterInterviewDate !== "" ||
                    afterInterviewTime !== ""
                  )
                ) {
                  const notificationRef =
                      getFirestore()
                          .collection("users")
                          .doc(userId)
                          .collection("notifications")
                          .doc();

                  await notificationRef.set({
                    title: "Cita consular disponible",

                    message:
                        "Tu entrevista consular ha sido registrada. " +
                        "Consulta la fecha, hora y ubicación " +
                        "en tu expediente.",

                    type: "interview_appointment_updated",

                    expedienteId: expedienteId,

                    data: {
                      expedienteId: expedienteId,
                      date: afterInterviewDate,
                      time: afterInterviewTime,
                      location: afterInterviewLocation,
                    },

                    read: false,

                    createdAt: new Date(),
                  });

                  logger.info(
                      "NOTIFICACIÓN ENTREVISTA CONSULAR ENVIADA",
                      {
                        expedienteId: expedienteId,
                        userId: userId,
                      },
                  );
                }
              } catch (error) {
                logger.error(
                    "ERROR EN NOTIFICACIONES DEL PROCESO DE VISA",
                    error,
                );
              }
            },
        );
