import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stockpathshala_beta/feedback/QuestionModel.dart';

class GlobalSocketPopup extends StatelessWidget {
  const GlobalSocketPopup(List<QuestionData>? questions, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,

      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Thank you for attending",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Sector Rotation Strategy for Swing Trading",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Please share your valuable feedback!",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            buildRatingRow("test1"),
            buildRatingRow("test2"),
            buildRatingRow("test3"),
          ],
        ),
      ),
    );
  }

  Widget buildRatingRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              child: Text(
            label,
            style: const TextStyle(fontSize: 12),
          )),
          const SizedBox(width: 12),
          Flexible(
            child: RatingBar(
              itemSize: 20,
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star, color: Colors.amber),
                half: const Icon(Icons.star_half, color: Colors.amber),
                empty: const Icon(Icons.star_border, color: Colors.amber),
              ),
              onRatingUpdate: (rating) {
                print('$label rating: $rating');
              },
            ),
          ),
        ],
      ),
    );
  }
}
