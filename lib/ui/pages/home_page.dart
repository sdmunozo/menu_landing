import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/data/landing_user_event_model.dart';
import 'package:landing_v3/provider/promotional_widget_height_provider.dart.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:landing_v3/provider/view_widget_height_provider.dart';
import 'package:landing_v3/ui/shared/build_footer_widget.dart';
import 'package:landing_v3/ui/views/faq_view.dart';
import 'package:landing_v3/ui/views/for_who_view.dart';
import 'package:landing_v3/ui/views/menu_highlights_view.dart';
import 'package:landing_v3/ui/views/menu_screens_view.dart';
import 'package:landing_v3/ui/views/presentation_view.dart';
import 'package:landing_v3/ui/views/suscriptions_view.dart';
import 'package:landing_v3/ui/views/testimonials_view.dart';
import 'package:landing_v3/ui/views/trust_elements_view.dart';
import 'package:landing_v3/ui/views/why_us_view.dart';
import 'package:provider/provider.dart';
import 'package:landing_v3/ui/shared/promotional_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

int inactivityTracker = 0;
int limitInactivityTime = 25; // 12 = 1 minuto 25
Timer? activityTimer;
bool showPromotionalWidget = false;
bool checkActivityBanner = false;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double presentationViewHeightSeen = 0.0;
  double menuHighlightsViewHeightSeen = 0.0;
  double menuScreensViewHeightSeen = 0.0;
  double forWhoViewHeightSeen = 0.0;
  double whyUsViewHeightSeen = 0.0;
  double suscriptionsViewHeightSeen = 0.0;
  double testimonialsViewHeightSeen = 0.0;
  double faqViewHeightSeen = 0.0;
  double trustElementsViewHeightSeen = 0.0;
  int totalSecondsElapsed = 0;
  int presentationViewSecondsElapsed = 0;
  int menuHighlightsViewSecondsElapsed = 0;
  int menuScreensViewSecondsElapsed = 0;
  int forWhoViewSecondsElapsed = 0;
  int whyUsViewSecondsElapsed = 0;
  int suscriptionsViewSecondsElapsed = 0;
  int testimonialsViewSecondsElapsed = 0;
  int faqViewSecondsElapsed = 0;
  int trustElementsViewSecondsElapsed = 0;

  void updatePromotionalWidgetVisibility(String activeView) {
    void getHeights() {}

    if (!showPromotionalWidget) {
      setState(() {
        showPromotionalWidget = true;

        double promotionalWidgetHeight =
            Provider.of<PromotionalWidgetHeightProvider>(context, listen: false)
                .height;

        double presentationViewHeight =
            Provider.of<ViewHeightProvider>(context, listen: false)
                .getViewHeight('presentationView');

        double menuHighlightsViewHeight =
            Provider.of<ViewHeightProvider>(context, listen: false)
                .getViewHeight('menuHighlightsView');

        double menuScreensViewHeight =
            Provider.of<ViewHeightProvider>(context, listen: false)
                .getViewHeight('menuScreensView');

        double forWhoViewHeight =
            Provider.of<ViewHeightProvider>(context, listen: false)
                .getViewHeight('forWhoView');

        double whyUsViewHeight =
            Provider.of<ViewHeightProvider>(context, listen: false)
                .getViewHeight('whyUsView');

        double suscriptionsViewHeight =
            Provider.of<ViewHeightProvider>(context, listen: false)
                .getViewHeight('suscriptionsView');

        double testimonialsViewHeight =
            Provider.of<ViewHeightProvider>(context, listen: false)
                .getViewHeight('testimonialsView');

        double faqViewHeight =
            Provider.of<ViewHeightProvider>(context, listen: false)
                .getViewHeight('faqView');

        double trustElementsViewHeight =
            Provider.of<ViewHeightProvider>(context, listen: false)
                .getViewHeight('trustElementsView');

        presentationViewHeightSeen =
            presentationViewHeight - promotionalWidgetHeight;

        menuHighlightsViewHeightSeen = presentationViewHeightSeen +
            menuHighlightsViewHeight +
            -promotionalWidgetHeight;

        menuScreensViewHeightSeen = menuHighlightsViewHeightSeen +
            menuScreensViewHeight -
            promotionalWidgetHeight;

        forWhoViewHeightSeen = menuScreensViewHeightSeen +
            forWhoViewHeight -
            promotionalWidgetHeight;

        whyUsViewHeightSeen = forWhoViewHeightSeen + whyUsViewHeight;

        suscriptionsViewHeightSeen =
            whyUsViewHeightSeen + suscriptionsViewHeight;

        testimonialsViewHeightSeen =
            suscriptionsViewHeightSeen + testimonialsViewHeight;

        faqViewHeightSeen = testimonialsViewHeightSeen + faqViewHeight;

        trustElementsViewHeightSeen =
            faqViewHeightSeen + trustElementsViewHeight;
      });
    }
  }

  final Map<String, GlobalKey> keys = {
    'promotionalWidget': GlobalKey(),
    'presentationView': GlobalKey(),
    'menuHighlightsView': GlobalKey(),
    'menuScreensView': GlobalKey(),
    'forWhoView': GlobalKey(),
    'whyUsView': GlobalKey(),
    'suscriptionsView': GlobalKey(),
    'testimonialsView': GlobalKey(),
    'faqView': GlobalKey(),
    'trustElementsView': GlobalKey(),
  };

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    String activeView = "presentationView";

    void showInactivityBanner() async {
      if (!checkActivityBanner) {
        checkActivityBanner = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userId');
        String? sessionId = prefs.getString('sessionId');
        activityTimer?.cancel();
        // Establecer 'isInactive' en true al cargar la página y sobreescribir si ya existe
        await prefs.setBool('isInactive', true);

        // Creando el objeto de detalles del evento
        EventDetails details = EventDetails(
            status:
                "Inactive" // Asegúrate de que 'status' es un campo definido en EventDetails
            );
        // Creando el objeto del evento principal
        LandingUserEventModel event = LandingUserEventModel(
            userId: userId ?? 'defaultUserId',
            sessionId: sessionId ?? 'defaultSessionId',
            eventType: "ActivityStatus",
            eventTimestamp: DateTime.now().toUtc(),
            details: details);

        //print(jsonEncode(inactivityEvent.toJson())); // Utiliza toJson para imprimir el evento

        // Imprimir mensaje después de lanzar la URL
        //print('Enviando eventos pendientes... ActivityStatus ${details.status}');
        Provider.of<UserEventProvider>(context, listen: false).addEvent(event);
        event.reset();
        details = EventDetails();

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text("¿Sigues aquí?"),
              content: Text("Haz clic en 'Sí' para seguir navegando."),
              actions: <Widget>[
                TextButton(
                  child: Text('Sí'),
                  onPressed: () async {
                    //print('Timer Encendido');
                    checkActivityBanner = false;
                    inactivityTracker = 0;

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? userId = prefs.getString('userId');
                    String? sessionId = prefs.getString('sessionId');
                    await prefs.setBool('isInactive', false);

                    // Creando el objeto de detalles del evento
                    details = EventDetails(
                        status:
                            "Reactivated" // Asegúrate de que 'status' es un campo definido en EventDetails
                        );

                    // Creando el objeto del evento principal
                    event = LandingUserEventModel(
                        userId: userId ?? 'defaultUserId',
                        sessionId: sessionId ?? 'defaultSessionId',
                        eventType: "ActivityStatus",
                        eventTimestamp: DateTime.now().toUtc(),
                        details: details);

                    //print(jsonEncode(activityEvent.toJson())); // Utiliza toJson para imprimir el evento

                    //print('Enviando eventos pendientes... ActivityStatus ${details.status}');

                    Provider.of<UserEventProvider>(context, listen: false)
                        .addEvent(event);
                    event.reset();
                    details = EventDetails();

                    Navigator.of(dialogContext).pop();
                    activityTimer =
                        Timer.periodic(const Duration(seconds: 1), (timer) {
                      totalSecondsElapsed++;

                      switch (activeView) {
                        case 'presentationView':
                          presentationViewSecondsElapsed++;
                          break;
                        case 'menuHighlightsView':
                          menuHighlightsViewSecondsElapsed++;
                          break;
                        case 'menuScreensView':
                          menuScreensViewSecondsElapsed++;
                          break;
                        case 'forWhoView':
                          forWhoViewSecondsElapsed++;
                          break;
                        case 'whyUsView':
                          whyUsViewSecondsElapsed++;
                          break;
                        case 'suscriptionsView':
                          suscriptionsViewSecondsElapsed++;
                          break;
                        case 'testimonialsView':
                          testimonialsViewSecondsElapsed++;
                          break;
                        case 'faqView':
                          faqViewSecondsElapsed++;
                          break;
                        case 'trustElementsView':
                          trustElementsViewSecondsElapsed++;
                          break;
                        default:
                          break;
                      }

                      if (totalSecondsElapsed % 5 == 0) {
                        if (inactivityTracker < limitInactivityTime) {
                          inactivityTracker++;

                          details = EventDetails(duration: totalSecondsElapsed);

                          event = LandingUserEventModel(
                            userId: userId!,
                            sessionId: sessionId!,
                            eventType: "VisitDuration",
                            eventTimestamp: DateTime.now().toUtc(),
                            details: details,
                          );

                          //print('Enviando eventos pendientes... VisitDuration 1 ${details.duration}');

                          Provider.of<UserEventProvider>(context, listen: false)
                              .addEvent(event);

                          event.reset();
                          details = EventDetails();

                          details = EventDetails(
                            presentationViewSecondsElapsed:
                                presentationViewSecondsElapsed,
                            menuHighlightsViewSecondsElapsed:
                                menuHighlightsViewSecondsElapsed,
                            menuScreensViewSecondsElapsed:
                                menuScreensViewSecondsElapsed,
                            forWhoViewSecondsElapsed: forWhoViewSecondsElapsed,
                            whyUsViewSecondsElapsed: whyUsViewSecondsElapsed,
                            suscriptionsViewSecondsElapsed:
                                suscriptionsViewSecondsElapsed,
                            testimonialsViewSecondsElapsed:
                                testimonialsViewSecondsElapsed,
                            faqViewSecondsElapsed: faqViewSecondsElapsed,
                            trustElementsViewSecondsElapsed:
                                trustElementsViewSecondsElapsed,
                          );

                          event = LandingUserEventModel(
                            userId: userId!,
                            sessionId: sessionId!,
                            eventType: "SectionLoad",
                            eventTimestamp: DateTime.now().toUtc(),
                            details: details,
                          );

                          if (kDebugMode) {
                            //print(jsonEncode(visitEvent.toJson()));
                            //print(jsonEncode(sectionLoadEvent.toJson()));
                          }

                          //print('Enviando eventos pendientes... SectionLoad ${details.presentationViewSecondsElapsed}');

                          Provider.of<UserEventProvider>(context, listen: false)
                              .addEvent(event);
                          event.reset();
                          details = EventDetails();
                        } else {
                          showInactivityBanner();
                        }
                      }
                    });
                  },
                )
              ],
            );
          },
        );
      }
    }

    scrollController.addListener(() {
      inactivityTracker = 0;
      if (scrollController.position.pixels <= presentationViewHeightSeen) {
        activeView = "presentationView";
      } else if (scrollController.position.pixels <=
          menuHighlightsViewHeightSeen) {
        activeView = "menuHighlightsView";
      } else if (scrollController.position.pixels <=
          menuScreensViewHeightSeen) {
        activeView = "menuScreensView";
      } else if (scrollController.position.pixels <= forWhoViewHeightSeen) {
        activeView = "forWhoView";
      } else if (scrollController.position.pixels <= whyUsViewHeightSeen) {
        activeView = "whyUsView";
      } else if (scrollController.position.pixels <=
          suscriptionsViewHeightSeen) {
        activeView = "suscriptionsView";
        //showPromotionalWidget = true;
        updatePromotionalWidgetVisibility(activeView);
      } else if (scrollController.position.pixels <=
          testimonialsViewHeightSeen) {
        activeView = "testimonialsView";
      } else if (scrollController.position.pixels <= faqViewHeightSeen) {
        activeView = "faqView";
      } else if (scrollController.position.pixels <=
          trustElementsViewHeightSeen) {
        activeView = "trustElementsView";
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? sessionId = prefs.getString('sessionId');

      activityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        totalSecondsElapsed++;

        switch (activeView) {
          case 'presentationView':
            presentationViewSecondsElapsed++;
            break;
          case 'menuHighlightsView':
            menuHighlightsViewSecondsElapsed++;
            break;
          case 'menuScreensView':
            menuScreensViewSecondsElapsed++;
            break;
          case 'forWhoView':
            forWhoViewSecondsElapsed++;
            break;
          case 'whyUsView':
            whyUsViewSecondsElapsed++;
            break;
          case 'suscriptionsView':
            suscriptionsViewSecondsElapsed++;
            break;
          case 'testimonialsView':
            testimonialsViewSecondsElapsed++;
            break;
          case 'faqView':
            faqViewSecondsElapsed++;
            break;
          case 'trustElementsView':
            trustElementsViewSecondsElapsed++;
            break;
          default:
            break;
        }

        if (totalSecondsElapsed % 5 == 0) {
          if (inactivityTracker < limitInactivityTime) {
            inactivityTracker++;

            EventDetails details = EventDetails(
              duration: totalSecondsElapsed,
            );

            LandingUserEventModel event = LandingUserEventModel(
              userId: userId!,
              sessionId: sessionId!,
              eventType: "VisitDuration",
              eventTimestamp: DateTime.now().toUtc(),
              details: details,
            );

            //print('Enviando eventos pendientes... VisitDuration 2 ${details.duration}');

            Provider.of<UserEventProvider>(context, listen: false)
                .addEvent(event);

            event.reset();
            details = EventDetails();

            details = EventDetails(
              presentationViewSecondsElapsed: presentationViewSecondsElapsed,
              menuHighlightsViewSecondsElapsed:
                  menuHighlightsViewSecondsElapsed,
              menuScreensViewSecondsElapsed: menuScreensViewSecondsElapsed,
              forWhoViewSecondsElapsed: forWhoViewSecondsElapsed,
              whyUsViewSecondsElapsed: whyUsViewSecondsElapsed,
              suscriptionsViewSecondsElapsed: suscriptionsViewSecondsElapsed,
              testimonialsViewSecondsElapsed: testimonialsViewSecondsElapsed,
              faqViewSecondsElapsed: faqViewSecondsElapsed,
              trustElementsViewSecondsElapsed: trustElementsViewSecondsElapsed,
            );

            event = LandingUserEventModel(
              userId: userId!,
              sessionId: sessionId!,
              eventType: "SectionLoad",
              eventTimestamp: DateTime.now().toUtc(),
              details: details,
            );

            if (kDebugMode) {
              //print(jsonEncode(visitEvent.toJson()));
              //print(jsonEncode(sectionLoadEvent.toJson()));
            }
            //print('Enviando eventos pendientes... SectionLoad ${details.presentationViewSecondsElapsed}');

            Provider.of<UserEventProvider>(context, listen: false)
                .addEvent(event);
            event.reset();
            details = EventDetails();
          } else {
            showInactivityBanner();
          }
        }
      });

      keys.forEach((key, globalKey) {
        if (globalKey.currentContext != null) {
          final RenderBox renderBox =
              globalKey.currentContext!.findRenderObject() as RenderBox;

          double viewHeight = renderBox.size.height;

          if (key == 'promotionalWidget') {
            Provider.of<PromotionalWidgetHeightProvider>(context, listen: false)
                .setPromotionalWidgetHeight(viewHeight);
          } else {
            Provider.of<ViewHeightProvider>(context, listen: false)
                .setViewHeight(key, viewHeight);
          }
        } else {
          //print("$key is not ready");
        }
      });

      double promotionalWidgetHeight =
          Provider.of<PromotionalWidgetHeightProvider>(context, listen: false)
              .height;

      double presentationViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('presentationView');

      double menuHighlightsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('menuHighlightsView');

      double menuScreensViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('menuScreensView');

      double forWhoViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('forWhoView');

      double whyUsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('whyUsView');

      double suscriptionsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('suscriptionsView');

      double testimonialsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('testimonialsView');

      double faqViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('faqView');

      double trustElementsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('trustElementsView');

      presentationViewHeightSeen =
          presentationViewHeight - promotionalWidgetHeight;

      menuHighlightsViewHeightSeen = presentationViewHeightSeen +
          menuHighlightsViewHeight +
          -promotionalWidgetHeight;

      menuScreensViewHeightSeen = menuHighlightsViewHeightSeen +
          menuScreensViewHeight -
          promotionalWidgetHeight;

      forWhoViewHeightSeen = menuScreensViewHeightSeen +
          forWhoViewHeight -
          promotionalWidgetHeight;

      whyUsViewHeightSeen = forWhoViewHeightSeen + whyUsViewHeight;

      suscriptionsViewHeightSeen = whyUsViewHeightSeen + suscriptionsViewHeight;

      testimonialsViewHeightSeen =
          suscriptionsViewHeightSeen + testimonialsViewHeight;

      faqViewHeightSeen = testimonialsViewHeightSeen + faqViewHeight;

      trustElementsViewHeightSeen = faqViewHeightSeen + trustElementsViewHeight;
    });

    return Scaffold(
      body: Column(
        children: [
          if (showPromotionalWidget)
            PromotionalWidget(widgetKey: keys['promotionalWidget']!),
          //PromotionalWidget(widgetKey: keys['promotionalWidget']!),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: _HomeBody(keys: keys),
            ),
          )
        ],
      ),
    );
  }
}

class _HomeBody extends StatefulWidget {
  final Map<String, GlobalKey> keys;

  const _HomeBody({required this.keys});

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(246, 246, 246, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            PresentationView(
              viewKey: widget.keys['presentationView']!,
            ),
            MenuHighlightsView(viewKey: widget.keys['menuHighlightsView']!),
            MenuScreensView(viewKey: widget.keys['menuScreensView']!),
            ForWhoView(viewKey: widget.keys['forWhoView']!),
            WhyUsView(viewKey: widget.keys['whyUsView']!),
            SuscriptionsView(viewKey: widget.keys['suscriptionsView']!),
            TestimonialsView(viewKey: widget.keys['testimonialsView']!),
            FAQView(viewKey: widget.keys['faqView']!),
            TrustElementsView(viewKey: widget.keys['trustElementsView']!),
            const BuildFooterWidget(),
          ],
        ),
      ),
    );
  }
}


/*

  WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? sessionId = prefs.getString('sessionId');

      activityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        totalSecondsElapsed++;

        switch (activeView) {
          case 'presentationView':
            presentationViewSecondsElapsed++;
            break;
          case 'menuHighlightsView':
            menuHighlightsViewSecondsElapsed++;
            break;
          case 'menuScreensView':
            menuScreensViewSecondsElapsed++;
            break;
          case 'forWhoView':
            forWhoViewSecondsElapsed++;
            break;
          case 'whyUsView':
            whyUsViewSecondsElapsed++;
            break;
          case 'suscriptionsView':
            suscriptionsViewSecondsElapsed++;
            break;
          case 'testimonialsView':
            testimonialsViewSecondsElapsed++;
            break;
          case 'faqView':
            faqViewSecondsElapsed++;
            break;
          case 'trustElementsView':
            trustElementsViewSecondsElapsed++;
            break;
          default:
            break;
        }

        if (totalSecondsElapsed % 5 == 0) {
          if (inactivityTracker < limitInactivityTime) {
            inactivityTracker++;

            Map<String, dynamic> visitEvent = {
              "UserId": userId,
              "SessionId": sessionId,
              "EventType": "VisitDuration",
              "EventTimestamp": DateTime.now().toUtc().toIso8601String(),
              "EventDetails": {"Duration": totalSecondsElapsed}
            };

            Map<String, dynamic> sectionLoadEvent = {
              "UserId": userId,
              "SessionId": sessionId,
              "EventType": "SectionLoad",
              "EventTimestamp": DateTime.now().toUtc().toIso8601String(),
              "EventDetails": {
                "presentationViewSecondsElapsed":
                    presentationViewSecondsElapsed,
                "menuHighlightsViewSecondsElapsed":
                    menuHighlightsViewSecondsElapsed,
                "menuScreensViewSecondsElapsed": menuScreensViewSecondsElapsed,
                "forWhoViewSecondsElapsed": forWhoViewSecondsElapsed,
                "whyUsViewSecondsElapsed": whyUsViewSecondsElapsed,
                "suscriptionsViewSecondsElapsed":
                    suscriptionsViewSecondsElapsed,
                "testimonialsViewSecondsElapsed":
                    testimonialsViewSecondsElapsed,
                "faqViewSecondsElapsed": faqViewSecondsElapsed,
                "trustElementsViewSecondsElapsed":
                    trustElementsViewSecondsElapsed
              }
            };

            if (kDebugMode) {
              print(jsonEncode(visitEvent));
            }
            if (kDebugMode) {
              print(jsonEncode(sectionLoadEvent));
            }
          } else {
            showInactivityBanner();
          }
        }
      });

      keys.forEach((key, globalKey) {
        if (globalKey.currentContext != null) {
          final RenderBox renderBox =
              globalKey.currentContext!.findRenderObject() as RenderBox;

          double viewHeight = renderBox.size.height;

          if (key == 'promotionalWidget') {
            Provider.of<PromotionalWidgetHeightProvider>(context, listen: false)
                .setPromotionalWidgetHeight(viewHeight);
          } else {
            Provider.of<ViewHeightProvider>(context, listen: false)
                .setViewHeight(key, viewHeight);
          }
        } else {
          //print("$key is not ready");
        }
      });

      double promotionalWidgetHeight =
          Provider.of<PromotionalWidgetHeightProvider>(context, listen: false)
              .height;

      double presentationViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('presentationView');

      double menuHighlightsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('menuHighlightsView');

      double menuScreensViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('menuScreensView');

      double forWhoViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('forWhoView');

      double whyUsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('whyUsView');

      double suscriptionsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('suscriptionsView');

      double testimonialsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('testimonialsView');

      double faqViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('faqView');

      double trustElementsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('trustElementsView');

      presentationViewHeightSeen =
          presentationViewHeight - promotionalWidgetHeight;

      menuHighlightsViewHeightSeen = presentationViewHeightSeen +
          menuHighlightsViewHeight +
          -promotionalWidgetHeight;

      menuScreensViewHeightSeen = menuHighlightsViewHeightSeen +
          menuScreensViewHeight -
          promotionalWidgetHeight;

      forWhoViewHeightSeen = menuScreensViewHeightSeen +
          forWhoViewHeight -
          promotionalWidgetHeight;

      whyUsViewHeightSeen = forWhoViewHeightSeen + whyUsViewHeight;

      suscriptionsViewHeightSeen = whyUsViewHeightSeen + suscriptionsViewHeight;

      testimonialsViewHeightSeen =
          suscriptionsViewHeightSeen + testimonialsViewHeight;

      faqViewHeightSeen = testimonialsViewHeightSeen + faqViewHeight;

      trustElementsViewHeightSeen = faqViewHeightSeen + trustElementsViewHeight;
    });

 */



/*
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/provider/promotional_widget_height_provider.dart.dart';
import 'package:landing_v3/provider/view_widget_height_provider.dart';
import 'package:landing_v3/ui/shared/build_footer_widget.dart';
import 'package:landing_v3/ui/views/faq_view.dart';
import 'package:landing_v3/ui/views/for_who_view.dart';
import 'package:landing_v3/ui/views/menu_highlights_view.dart';
import 'package:landing_v3/ui/views/menu_screens_view.dart';
import 'package:landing_v3/ui/views/presentation_view.dart';
import 'package:landing_v3/ui/views/suscriptions_view.dart';
import 'package:landing_v3/ui/views/testimonials_view.dart';
import 'package:landing_v3/ui/views/trust_elements_view.dart';
import 'package:landing_v3/ui/views/why_us_view.dart';
import 'package:provider/provider.dart';
import 'package:landing_v3/ui/shared/promotional_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

int inactivityTracker = 0;
int limitInactivityTime = 3; // 12 = 1 minuto
Timer? activityTimer;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, GlobalKey> keys = {
    'promotionalWidget': GlobalKey(),
    'presentationView': GlobalKey(),
    'menuHighlightsView': GlobalKey(),
    'menuScreensView': GlobalKey(),
    'forWhoView': GlobalKey(),
    'whyUsView': GlobalKey(),
    'suscriptionsView': GlobalKey(),
    'testimonialsView': GlobalKey(),
    'faqView': GlobalKey(),
    'trustElementsView': GlobalKey(),
  };

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    String activeView = "presentationView";

    int totalSecondsElapsed = 0;
    int presentationViewSecondsElapsed = 0;
    int menuHighlightsViewSecondsElapsed = 0;
    int menuScreensViewSecondsElapsed = 0;
    int forWhoViewSecondsElapsed = 0;
    int whyUsViewSecondsElapsed = 0;
    int suscriptionsViewSecondsElapsed = 0;
    int testimonialsViewSecondsElapsed = 0;
    int faqViewSecondsElapsed = 0;
    int trustElementsViewSecondsElapsed = 0;

    double presentationViewHeightSeen = 0.0;
    double menuHighlightsViewHeightSeen = 0.0;
    double menuScreensViewHeightSeen = 0.0;
    double forWhoViewHeightSeen = 0.0;
    double whyUsViewHeightSeen = 0.0;
    double suscriptionsViewHeightSeen = 0.0;
    double testimonialsViewHeightSeen = 0.0;
    double faqViewHeightSeen = 0.0;
    double trustElementsViewHeightSeen = 0.0;

    void showInactivityBanner() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? sessionId = prefs.getString('sessionId');
      activityTimer?.cancel();
      print('Timer Apagado');

      Map<String, dynamic> inactivityEvent = {
        "UserId": userId,
        "SessionId": sessionId,
        "EventType": "ActivityStatus",
        "EventTimestamp": DateTime.now().toUtc().toIso8601String(),
        "EventDetails": {"Status": "Inactive"}
      };

      print(jsonEncode(inactivityEvent));

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("¿Sigues aquí?"),
            content: Text("Haz clic en 'Sí' para seguir navegando."),
            actions: <Widget>[
              TextButton(
                child: Text('Sí'),
                onPressed: () {
                  print('Timer Encendido');
                  inactivityTracker = 0;

                  Map<String, dynamic> activityEvent = {
                    "UserId": userId,
                    "SessionId": sessionId,
                    "EventType": "ActivityStatus",
                    "EventTimestamp": DateTime.now().toUtc().toIso8601String(),
                    "EventDetails": {"Status": "Reactivated"}
                  };

                  print(jsonEncode(activityEvent));

                  Navigator.of(dialogContext).pop();
                  activityTimer =
                      Timer.periodic(const Duration(seconds: 1), (timer) {
                    totalSecondsElapsed++;

                    switch (activeView) {
                      case 'presentationView':
                        presentationViewSecondsElapsed++;
                        break;
                      case 'menuHighlightsView':
                        menuHighlightsViewSecondsElapsed++;
                        break;
                      case 'menuScreensView':
                        menuScreensViewSecondsElapsed++;
                        break;
                      case 'forWhoView':
                        forWhoViewSecondsElapsed++;
                        break;
                      case 'whyUsView':
                        whyUsViewSecondsElapsed++;
                        break;
                      case 'suscriptionsView':
                        suscriptionsViewSecondsElapsed++;
                        break;
                      case 'testimonialsView':
                        testimonialsViewSecondsElapsed++;
                        break;
                      case 'faqView':
                        faqViewSecondsElapsed++;
                        break;
                      case 'trustElementsView':
                        trustElementsViewSecondsElapsed++;
                        break;
                      default:
                        break;
                    }

                    if (totalSecondsElapsed % 5 == 0) {
                      if (inactivityTracker < limitInactivityTime) {
                        inactivityTracker++;

                        Map<String, dynamic> visitEvent = {
                          "UserId": userId,
                          "SessionId": sessionId,
                          "EventType": "VisitDuration",
                          "EventTimestamp":
                              DateTime.now().toUtc().toIso8601String(),
                          "EventDetails": {"Duration": totalSecondsElapsed}
                        };

                        Map<String, dynamic> sectionLoadEvent = {
                          "UserId": userId,
                          "SessionId": sessionId,
                          "EventType": "SectionLoad",
                          "EventTimestamp":
                              DateTime.now().toUtc().toIso8601String(),
                          "EventDetails": {
                            "presentationViewSecondsElapsed":
                                presentationViewSecondsElapsed,
                            "menuHighlightsViewSecondsElapsed":
                                menuHighlightsViewSecondsElapsed,
                            "menuScreensViewSecondsElapsed":
                                menuScreensViewSecondsElapsed,
                            "forWhoViewSecondsElapsed":
                                forWhoViewSecondsElapsed,
                            "whyUsViewSecondsElapsed": whyUsViewSecondsElapsed,
                            "suscriptionsViewSecondsElapsed":
                                suscriptionsViewSecondsElapsed,
                            "testimonialsViewSecondsElapsed":
                                testimonialsViewSecondsElapsed,
                            "faqViewSecondsElapsed": faqViewSecondsElapsed,
                            "trustElementsViewSecondsElapsed":
                                trustElementsViewSecondsElapsed
                          }
                        };

                        if (kDebugMode) {
                          print(jsonEncode(visitEvent));
                        }
                        if (kDebugMode) {
                          print(jsonEncode(sectionLoadEvent));
                        }
                      } else {
                        showInactivityBanner();
                      }
                    }
                  });
                },
              )
            ],
          );
        },
      );
    }

    scrollController.addListener(() {
      inactivityTracker = 0;
      if (scrollController.position.pixels <= presentationViewHeightSeen) {
        activeView = "presentationView";
      } else if (scrollController.position.pixels <=
          menuHighlightsViewHeightSeen) {
        activeView = "menuHighlightsView";
      } else if (scrollController.position.pixels <=
          menuScreensViewHeightSeen) {
        activeView = "menuScreensView";
      } else if (scrollController.position.pixels <= forWhoViewHeightSeen) {
        activeView = "forWhoView";
      } else if (scrollController.position.pixels <= whyUsViewHeightSeen) {
        activeView = "whyUsView";
      } else if (scrollController.position.pixels <=
          suscriptionsViewHeightSeen) {
        activeView = "suscriptionsView";
      } else if (scrollController.position.pixels <=
          testimonialsViewHeightSeen) {
        activeView = "testimonialsView";
      } else if (scrollController.position.pixels <= faqViewHeightSeen) {
        activeView = "faqView";
      } else if (scrollController.position.pixels <=
          trustElementsViewHeightSeen) {
        activeView = "trustElementsView";
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? sessionId = prefs.getString('sessionId');

      activityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        totalSecondsElapsed++;

        switch (activeView) {
          case 'presentationView':
            presentationViewSecondsElapsed++;
            break;
          case 'menuHighlightsView':
            menuHighlightsViewSecondsElapsed++;
            break;
          case 'menuScreensView':
            menuScreensViewSecondsElapsed++;
            break;
          case 'forWhoView':
            forWhoViewSecondsElapsed++;
            break;
          case 'whyUsView':
            whyUsViewSecondsElapsed++;
            break;
          case 'suscriptionsView':
            suscriptionsViewSecondsElapsed++;
            break;
          case 'testimonialsView':
            testimonialsViewSecondsElapsed++;
            break;
          case 'faqView':
            faqViewSecondsElapsed++;
            break;
          case 'trustElementsView':
            trustElementsViewSecondsElapsed++;
            break;
          default:
            break;
        }

        if (totalSecondsElapsed % 5 == 0) {
          if (inactivityTracker < limitInactivityTime) {
            inactivityTracker++;

            Map<String, dynamic> visitEvent = {
              "UserId": userId,
              "SessionId": sessionId,
              "EventType": "VisitDuration",
              "EventTimestamp": DateTime.now().toUtc().toIso8601String(),
              "EventDetails": {"Duration": totalSecondsElapsed}
            };

            Map<String, dynamic> sectionLoadEvent = {
              "UserId": userId,
              "SessionId": sessionId,
              "EventType": "SectionLoad",
              "EventTimestamp": DateTime.now().toUtc().toIso8601String(),
              "EventDetails": {
                "presentationViewSecondsElapsed":
                    presentationViewSecondsElapsed,
                "menuHighlightsViewSecondsElapsed":
                    menuHighlightsViewSecondsElapsed,
                "menuScreensViewSecondsElapsed": menuScreensViewSecondsElapsed,
                "forWhoViewSecondsElapsed": forWhoViewSecondsElapsed,
                "whyUsViewSecondsElapsed": whyUsViewSecondsElapsed,
                "suscriptionsViewSecondsElapsed":
                    suscriptionsViewSecondsElapsed,
                "testimonialsViewSecondsElapsed":
                    testimonialsViewSecondsElapsed,
                "faqViewSecondsElapsed": faqViewSecondsElapsed,
                "trustElementsViewSecondsElapsed":
                    trustElementsViewSecondsElapsed
              }
            };

            if (kDebugMode) {
              print(jsonEncode(visitEvent));
            }
            if (kDebugMode) {
              print(jsonEncode(sectionLoadEvent));
            }
          } else {
            showInactivityBanner();
          }
        }
      });

      keys.forEach((key, globalKey) {
        if (globalKey.currentContext != null) {
          final RenderBox renderBox =
              globalKey.currentContext!.findRenderObject() as RenderBox;

          double viewHeight = renderBox.size.height;

          if (key == 'promotionalWidget') {
            Provider.of<PromotionalWidgetHeightProvider>(context, listen: false)
                .setPromotionalWidgetHeight(viewHeight);
          } else {
            Provider.of<ViewHeightProvider>(context, listen: false)
                .setViewHeight(key, viewHeight);
          }
        } else {
          //print("$key is not ready");
        }
      });

      double promotionalWidgetHeight =
          Provider.of<PromotionalWidgetHeightProvider>(context, listen: false)
              .height;

      double presentationViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('presentationView');

      double menuHighlightsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('menuHighlightsView');

      double menuScreensViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('menuScreensView');

      double forWhoViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('forWhoView');

      double whyUsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('whyUsView');

      double suscriptionsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('suscriptionsView');

      double testimonialsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('testimonialsView');

      double faqViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('faqView');

      double trustElementsViewHeight =
          Provider.of<ViewHeightProvider>(context, listen: false)
              .getViewHeight('trustElementsView');

      presentationViewHeightSeen =
          presentationViewHeight - promotionalWidgetHeight;

      menuHighlightsViewHeightSeen = presentationViewHeightSeen +
          menuHighlightsViewHeight +
          -promotionalWidgetHeight;

      menuScreensViewHeightSeen = menuHighlightsViewHeightSeen +
          menuScreensViewHeight -
          promotionalWidgetHeight;

      forWhoViewHeightSeen = menuScreensViewHeightSeen +
          forWhoViewHeight -
          promotionalWidgetHeight;

      whyUsViewHeightSeen = forWhoViewHeightSeen + whyUsViewHeight;

      suscriptionsViewHeightSeen = whyUsViewHeightSeen + suscriptionsViewHeight;

      testimonialsViewHeightSeen =
          suscriptionsViewHeightSeen + testimonialsViewHeight;

      faqViewHeightSeen = testimonialsViewHeightSeen + faqViewHeight;

      trustElementsViewHeightSeen = faqViewHeightSeen + trustElementsViewHeight;
    });

    return Scaffold(
      body: Column(
        children: [
          PromotionalWidget(widgetKey: keys['promotionalWidget']!),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: _HomeBody(keys: keys),
            ),
          )
        ],
      ),
    );
  }
}

class _HomeBody extends StatefulWidget {
  final Map<String, GlobalKey> keys;

  const _HomeBody({required this.keys});

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(246, 246, 246, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            PresentationView(
              viewKey: widget.keys['presentationView']!,
            ),
            MenuHighlightsView(viewKey: widget.keys['menuHighlightsView']!),
            MenuScreensView(viewKey: widget.keys['menuScreensView']!),
            ForWhoView(viewKey: widget.keys['forWhoView']!),
            WhyUsView(viewKey: widget.keys['whyUsView']!),
            SuscriptionsView(viewKey: widget.keys['suscriptionsView']!),
            TestimonialsView(viewKey: widget.keys['testimonialsView']!),
            FAQView(viewKey: widget.keys['faqView']!),
            TrustElementsView(viewKey: widget.keys['trustElementsView']!),
            const BuildFooterWidget(),
          ],
        ),
      ),
    );
  }
}

 */