import 'dart:async';
import 'package:flutter/material.dart';
import 'package:landing_v3/models/landing_user_event_model.dart';
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

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int inactivityTracker = 0;
  int limitInactivityTime = 25; // 12 = 1 minuto 25
  Timer? activityTimer;
  bool showPromotionalWidget = false;
  int jumpedToSuscriptions = 0;
  bool checkActivityBanner = false;
  final ScrollController scrollController = ScrollController();
  bool _isLoading = true;

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

  double getViewHeight(String viewName, BuildContext context) {
    if (viewName == 'promotionalWidget') {
      return Provider.of<PromotionalWidgetHeightProvider>(context,
              listen: false)
          .height;
    } else {
      return Provider.of<ViewHeightProvider>(context, listen: false)
          .getViewHeight(viewName);
    }
  }

  void getViewHeights() {
    presentationViewHeightSeen = getViewHeight('presentationView', context) -
        getViewHeight('promotionalWidget', context);

    menuHighlightsViewHeightSeen = presentationViewHeightSeen +
        getViewHeight('menuHighlightsView', context) +
        -getViewHeight('promotionalWidget', context);

    menuScreensViewHeightSeen = menuHighlightsViewHeightSeen +
        getViewHeight('menuScreensView', context) -
        getViewHeight('promotionalWidget', context);

    forWhoViewHeightSeen = menuScreensViewHeightSeen +
        getViewHeight('forWhoView', context) -
        getViewHeight('promotionalWidget', context);

    whyUsViewHeightSeen =
        forWhoViewHeightSeen + getViewHeight('whyUsView', context);

    suscriptionsViewHeightSeen =
        whyUsViewHeightSeen + getViewHeight('suscriptionsView', context);

    testimonialsViewHeightSeen =
        suscriptionsViewHeightSeen + getViewHeight('testimonialsView', context);

    faqViewHeightSeen =
        testimonialsViewHeightSeen + getViewHeight('faqView', context);

    trustElementsViewHeightSeen =
        faqViewHeightSeen + getViewHeight('trustElementsView', context);
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void updatePromotionalWidgetVisibility(String activeView) {
    if (!showPromotionalWidget) {
      setState(() {
        showPromotionalWidget = true;
        getViewHeights();
      });
      Timer(const Duration(milliseconds: 100), () {
        if (mounted) {
          scrollController.animateTo(whyUsViewHeightSeen,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final ScrollController scrollController = ScrollController();
    String activeView = "presentationView";

    void showInactivityBanner() {
      if (!checkActivityBanner) {
        checkActivityBanner = true;
        activityTimer?.cancel();

        EventDetails detailsActivityStatusInactive =
            EventDetails(status: "Inactive");

        EventBuilder builder = EventBuilder(
          eventType: "ActivityStatus",
          details: detailsActivityStatusInactive,
        );

        Provider.of<UserEventProvider>(context, listen: false)
            .addEvent(builder.build());

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("¿Sigues aquí?"),
              content: const Text("Haz clic en 'Sí' para seguir navegando."),
              actions: <Widget>[
                TextButton(
                  child: const Text('Sí'),
                  onPressed: () async {
                    checkActivityBanner = false;
                    inactivityTracker = 0;

                    EventDetails detailsActivityStatusReactivated =
                        EventDetails(status: "Reactivated");

                    EventBuilder builder = EventBuilder(
                      eventType: "ActivityStatus",
                      details: detailsActivityStatusReactivated,
                    );

                    Provider.of<UserEventProvider>(context, listen: false)
                        .addEvent(builder.build());

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

                          EventDetails detailsVisitDurationTotalSecondsElapsed =
                              EventDetails(duration: totalSecondsElapsed);

                          EventBuilder builderVisitDuration = EventBuilder(
                            eventType: "VisitDuration",
                            details: detailsVisitDurationTotalSecondsElapsed,
                          );

                          Provider.of<UserEventProvider>(context, listen: false)
                              .addEvent(builderVisitDuration.build());

                          EventDetails detailsViewsSecondsElapsed =
                              EventDetails(
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

                          EventBuilder builderSectionLoad = EventBuilder(
                            eventType: "SectionLoad",
                            details: detailsViewsSecondsElapsed,
                          );

                          Provider.of<UserEventProvider>(context, listen: false)
                              .addEvent(builderSectionLoad.build());
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
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

            EventDetails detailsVisitDurationTotalSecondsElapsed =
                EventDetails(duration: totalSecondsElapsed);

            EventBuilder builderVisitDuration = EventBuilder(
              eventType: "VisitDuration",
              details: detailsVisitDurationTotalSecondsElapsed,
            );

            Provider.of<UserEventProvider>(context, listen: false)
                .addEvent(builderVisitDuration.build());

            EventDetails detailsViewsSecondsElapsed = EventDetails(
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

            EventBuilder builderSectionLoad = EventBuilder(
              eventType: "SectionLoad",
              details: detailsViewsSecondsElapsed,
            );

            Provider.of<UserEventProvider>(context, listen: false)
                .addEvent(builderSectionLoad.build());
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
        }
      });

      getViewHeights();
    });

    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            if (showPromotionalWidget)
              PromotionalWidget(widgetKey: keys['promotionalWidget']!),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: _HomeBody(keys: keys),
              ),
            ),
          ],
        ),
        if (_isLoading)
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff24ace4)),
                        ),
                      ),
                      Image.asset('assets/tools/4uRest-DM-3.png',
                          width: 200, height: 200),
                    ],
                  ),
                ),
              ),
            ),
      ]),
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
