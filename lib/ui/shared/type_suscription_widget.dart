import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubscriptionWidget extends StatelessWidget {
  final String name;
  final String pricePerMonth;
  final String subscriptionLink;
  final int? period;
  final String? pricePerPeriod;
  final String? monthsSaved;

  const SubscriptionWidget({
    Key? key,
    required this.name,
    required this.pricePerMonth,
    required this.subscriptionLink,
    this.period,
    this.pricePerPeriod,
    this.monthsSaved = '0',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (period == 1) {
      return SizedBox();
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
            constraints: BoxConstraints(maxWidth: 300),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0XFF3B8686),
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
                      style: TextStyle(
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
                          style: TextStyle(
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
                        onPressed: () async {
                          if (await canLaunch(subscriptionLink)) {
                            await launch(subscriptionLink);
                          } else {}
                        },
                        child: Text(
                          'Suscríbete a $name',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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

  const DiscountTime({Key? key, required this.discountMonths})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String monthsText = discountMonths == 1 ? 'MES' : 'MESES';

    return Container(
      decoration: BoxDecoration(
        color: Color(0XFF3B8686),
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "AHORRAS $discountMonths $monthsText",
        style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 1.5),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionWidget extends StatelessWidget {
  final String name;
  final String pricePerMonth;
  final String subscriptionLink;
  final int? period;
  final String? pricePerPeriod;
  final String? monthsSaved;

  const SubscriptionWidget({
    Key? key,
    required this.name,
    required this.pricePerMonth,
    required this.subscriptionLink,
    this.period,
    this.pricePerPeriod,
    this.monthsSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0XFF3B8686), // Color del borde
                width: 2.0, // Ancho del borde
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$$pricePerMonth/mes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  if (pricePerPeriod != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Suscripción anual de \$$pricePerPeriod',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (await canLaunch(subscriptionLink)) {
                        await launch(subscriptionLink);
                      } else {
                        // handle the error here
                      }
                    },
                    child: Text(
                      'Suscríbete a $name',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: DiscountTime(
              discountMonths:
                  monthsSaved != null ? int.parse(monthsSaved!) : 0),
        ),
      ],
    );
  }
}

class DiscountTime extends StatelessWidget {
  final int discountMonths;

  const DiscountTime({Key? key, required this.discountMonths})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String monthsText = discountMonths == 1 ? 'MES' : 'MESES';

    return Container(
      decoration: BoxDecoration(
        color: Color(0XFF3B8686),
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "AHORRAS $discountMonths $monthsText",
        style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 1.5),
      ),
    );
  }
}

*/