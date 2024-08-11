import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:fitnesseapplication/screens/trainer_view_request.dart';

// Define the function to format the timestamp
String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('yyyy-MM-dd, hh:mm a').format(dateTime);
}

void main() {
  test('Date formatting test', () {
    // Define a sample timestamp
    DateTime dateTime = DateTime(2024, 6, 11, 13, 30); // Change this to a valid timestamp
    Timestamp timestamp = Timestamp.fromDate(dateTime); // Assuming Timestamp is a Firestore timestamp

    // Format the date
    String formattedDate = formatTimestamp(timestamp);

    // Define the expected result
    String expectedDate = DateFormat('yyyy-MM-dd, hh:mm a').format(dateTime);

    // Check if the formatted date matches the expected result
    expect(formattedDate, expectedDate);
  });
}
