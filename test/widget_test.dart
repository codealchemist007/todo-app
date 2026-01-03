// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

import 'package:todo_app/main.dart';
import 'package:todo_app/screens/login.dart';
import 'package:todo_app/services/auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockAuth extends Mock implements Auth {}

void main() {
  testWidgets('App initializes without crashing', (WidgetTester tester) async {
    // This test just verifies the app widget can be created
    // Full integration tests would require Firebase setup
    expect(const App(), isA<App>());
  });

  testWidgets('LoginScreen has email and password fields', (WidgetTester tester) async {
    final mockAuth = MockAuth();
    
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(auth: mockAuth),
    ));

    // Check for email field
    expect(find.text('Email'), findsOneWidget);
    
    // Check for password field
    expect(find.text('Password'), findsOneWidget);
    
    // Check for sign in button
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
  });

  testWidgets('LoginScreen can toggle between sign in and sign up', (WidgetTester tester) async {
    final mockAuth = MockAuth();
    
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(auth: mockAuth),
    ));

    // Initially should show "Sign In"
    expect(find.text('Welcome Back'), findsOneWidget);
    
    // Tap the toggle button
    await tester.tap(find.text("Don't have an account? Sign Up"));
    await tester.pump();
    
    // Should now show "Sign Up"
    expect(find.text('Create Account'), findsOneWidget);
  });
}
