import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/data/landing_user_event_model.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionWidget extends StatelessWidget {
  final String name;
  final String pricePerMonth;
  final String subscriptionLink;
  final Color color;
  final String linkLabel;
  final int? period;
  final String? pricePerPeriod;
  final String? monthsSaved;

  const SubscriptionWidget({
    super.key,
    required this.name,
    required this.pricePerMonth,
    required this.subscriptionLink,
    required this.color,
    required this.linkLabel,
    this.period,
    this.pricePerPeriod,
    this.monthsSaved = '0',
  });

  @override
  Widget build(BuildContext context) {
    Future<void> launchUrlLink(Uri url, BuildContext context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? sessionId = prefs.getString('sessionId');
      String eventTimestamp = DateTime.now().toUtc().toIso8601String();

      // Crea un objeto EventDetails
      EventDetails details =
          EventDetails(linkDestination: url.toString(), linkLabel: linkLabel);
      // 'Subscripción Anual - Banner'); // Asegúrate de definir correctamente el linkLabel

      // Crea un objeto LandingUserEventModel
      LandingUserEventModel event = LandingUserEventModel(
          userId: userId ?? 'defaultUserId',
          sessionId: sessionId ?? 'defaultSessionId',
          eventType: 'ExternalLink',
          eventTimestamp: DateTime.parse(eventTimestamp),
          details: details);

      // Imprimir mensaje antes de enviar el evento
      //print('Enviando evento: ${event.toJson()}');

      // Registra el evento sin escuchar cambios en Provider
      //Provider.of<UserEventProvider>(context, listen: false).addEvent(event);

      try {
        bool launched =
            await launchUrl(url, mode: LaunchMode.externalApplication);
        if (!launched) {
          //print('No se pudo lanzar $url');
        } else {
          //print('Enlace lanzado con éxito: $url');
        }
      } catch (e) {
        //print('Error al lanzar $url: $e');
      }

      // Imprimir mensaje después de lanzar la URL
      //print('Enviando eventos pendientes... ExternalLink ${details.linkLabel}');
      Provider.of<UserEventProvider>(context, listen: false).addEvent(event);
    }

    /*
    void launchUrlLink(Uri url, BuildContext context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? sessionId = prefs.getString('sessionId');
      String eventTimestamp = DateTime.now().toUtc().toIso8601String();

      // Crea un objeto EventDetails
      EventDetails details =
          EventDetails(linkDestination: url.toString(), linkLabel: linkLabel);
      // 'Subscripción Anual - Banner'); // Asegúrate de definir correctamente el linkLabel

      // Crea un objeto LandingUserEventModel
      LandingUserEventModel event = LandingUserEventModel(
          userId: userId ?? 'defaultUserId',
          sessionId: sessionId ?? 'defaultSessionId',
          eventType: 'ExternalLink',
          eventTimestamp: DateTime.parse(eventTimestamp),
          details: details);

      // Registra el evento sin escuchar cambios en Provider
      Provider.of<UserEventProvider>(context, listen: false).addEvent(event);

      try {
        bool launched =
            await launchUrl(url, mode: LaunchMode.externalApplication);
        if (!launched) {
          if (kDebugMode) {
            print('No se pudo lanzar $url');
          }
        } else {
          if (kDebugMode) {
            print('Enlace lanzado con éxito: $url');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error al lanzar $url: $e');
        }
      }

      // Envía todos los eventos pendientes después de lanzar la URL
      Provider.of<UserEventProvider>(context, listen: false).sendEvents();
    }
*/
/*
    void launchUrlLink(Uri url) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? sessionId = prefs.getString('sessionId');
      String eventTimestamp = DateTime.now().toUtc().toIso8601String();

      // Crea un objeto EventDetails
      EventDetails details =
          EventDetails(linkDestination: url.toString(), linkLabel: linkLabel);

      // Crea un objeto LandingUserEventModel
      LandingUserEventModel event = LandingUserEventModel(
          userId: userId ?? 'defaultUserId',
          sessionId: sessionId ?? 'defaultSessionId',
          eventType: 'ExternalLink',
          eventTimestamp: DateTime.parse(eventTimestamp),
          details: details);

      // Imprime el evento si estás en modo de depuración
      if (kDebugMode) {
        print(event.toJson()); // Utiliza toJson para imprimir el evento
      }

      // Intenta lanzar el URL
      if (!await launchUrl(url)) {
        if (kDebugMode) {
          //print('No se pudo lanzar $url');
        }
        // Considera enviar el evento al servidor incluso si el enlace no se pudo abrir
        // Aquí podrías llamar a una función para enviar el evento al servidor
      }
    }
*/
    /*
    void launchUrlLink(Uri url) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? sessionId = prefs.getString('sessionId');
      String eventTimestamp = DateTime.now().toUtc().toIso8601String();

      var event = {
        "UserId": userId ?? 'defaultUserId',
        "SessionId": sessionId ?? 'defaultSessionId',
        "EventType": "ExternalLink",
        "EventTimestamp": eventTimestamp,
        "EventDetails": {
          "LinkDestination": url.toString(),
          "LinkLabel": linkLabel
        }
      };

      if (kDebugMode) {
        print(event);
      }

      if (!await launchUrl(url)) {
        if (kDebugMode) {
          print('No se pudo lanzar $url');
        }
      }
    }
    */

    if (period == 1) {
      return const SizedBox();
    }

    String subscriptionText;
    if (period == 6) {
      subscriptionText = 'Suscripción semestral de \$$pricePerPeriod';
    } else if (period == 12) {
      subscriptionText = 'Suscripción anual de \$$pricePerPeriod';
    } else {
      subscriptionText = '';
    }

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Card(
          margin: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: color,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 32.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            'assets/tools/flag.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Text(
                          '\$$pricePerMonth/mes',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    if (subscriptionText.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        subscriptionText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          launchUrlLink(Uri.parse(subscriptionLink), context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.green),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Suscríbete a $name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (monthsSaved != '0') ...[
          Positioned(
            top: 0,
            child: DiscountTime(
                color: color,
                discountMonths:
                    monthsSaved != null ? int.parse(monthsSaved!) : 0),
          ),
        ]
      ],
    );
  }
}

class DiscountTime extends StatelessWidget {
  final int discountMonths;
  final Color color;

  const DiscountTime(
      {super.key, required this.discountMonths, required this.color});

  @override
  Widget build(BuildContext context) {
    String monthsText = discountMonths == 1 ? 'MES' : 'MESES';

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "AHORRAS $discountMonths $monthsText",
        style: const TextStyle(
            color: Colors.white, fontSize: 10, letterSpacing: 1.5),
      ),
    );
  }
}
