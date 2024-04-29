import 'package:flutter/material.dart';
import 'dart:async';

class TestimonialCard extends StatefulWidget {
  final String testimonialText;
  final String authorName;
  final String authorDetails;
  final ImageProvider authorImage;
  final int rating;
  final VoidCallback onTap;

  const TestimonialCard({
    super.key,
    required this.testimonialText,
    required this.authorName,
    required this.authorDetails,
    required this.authorImage,
    required this.rating,
    required this.onTap,
  });

  @override
  _TestimonialCardState createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  late bool _isTouchAppOutlined;

  @override
  void initState() {
    super.initState();
    _isTouchAppOutlined = true;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isTouchAppOutlined = !_isTouchAppOutlined;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 300,
        height: 175,
        child: Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '"${widget.testimonialText}"',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 20.0),
                    CircleAvatar(
                      backgroundImage: widget.authorImage,
                    ),
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(widget.authorDetails),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < widget.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: index < widget.rating
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      _isTouchAppOutlined
                          ? Icons.touch_app_outlined
                          : Icons.touch_app,
                      color: Colors.green,
                      size: 35,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
