import 'package:flutter/material.dart';

class ErrorHandler {
  static void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.transparent),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 28),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(150),
              ),
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );

    // Close the dialog after 2 seconds
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pop();
    });
  }

  static void showLoginError(BuildContext context, dynamic error) {
    String errorMessage = 'Login failed.';

    if (error is String) {
      errorMessage = 'Login failed: $error';
    }

    showErrorDialog(context, errorMessage);
  }

  static void showSignUpError(BuildContext context, dynamic error) {
    String errorMessage = 'Sign-up failed.';

    if (error is String) {
      if (error.contains('email-already-in-use')) {
        errorMessage = 'Email address is already in use.';
      } else {
        errorMessage = 'Sign-up failed: $error';
      }
    }

    showErrorDialog(context, errorMessage);
  }

  static void showDatabaseError(BuildContext context, dynamic error) {
    String errorMessage = 'Database operation failed.';

    if (error is String) {
      errorMessage = 'Database error: $error';
    }

    showErrorDialog(context, errorMessage);
  }

  static void showEmailError(BuildContext context, dynamic error) {
    String errorMessage = 'Email sending failed.';

    if (error is String) {
      errorMessage = 'Email error: $error';
    }

    showErrorDialog(context, errorMessage);
  }

  static void showIncorrectEmailOrPassword(BuildContext context) {
    showErrorDialog(context, 'Incorrect email or password.');
  }

// Add more methods for different types of errors as needed
}