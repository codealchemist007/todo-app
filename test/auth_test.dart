import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/services/auth.dart';

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

final MockUser _mockUser= MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User?> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
  
  @override
  Future<UserCredential> createUserWithEmailAndPassword({required String? email, required String? password}) =>
      super.noSuchMethod(
        Invocation.method(
          #createUserWithEmailAndPassword,
          [],
          {#email: email, #password: password},
        ),
        returnValue: Future.value(MockUserCredential()),
        returnValueForMissingStub: Future.value(MockUserCredential()),
      );

  @override
  Future<UserCredential> signInWithEmailAndPassword({required String? email, required String? password}) =>
      super.noSuchMethod(
        Invocation.method(
          #signInWithEmailAndPassword,
          [],
          {#email: email, #password: password},
        ),
        returnValue: Future.value(MockUserCredential()),
        returnValueForMissingStub: Future.value(MockUserCredential()),
      );

  @override
  Future<UserCredential> signOut() =>
      super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: Future.value(MockUserCredential()),
        returnValueForMissingStub: Future.value(MockUserCredential()),
      );
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth= Auth(auth: mockFirebaseAuth);
  setUp(() {});
  tearDown(() {});

  test("emit occurs", () async {
    await expectLater(auth.user, emitsInOrder([_mockUser]));
 });

  test("create account", () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
        email: ("swastikroy157@gmail.com"),
        password: ("#exelliarmus123"),
      ),
    ).thenAnswer((_) async => MockUserCredential());

    expect(
      await auth.createAccount("swastikroy157@gmail.com", "#exelliarmus123"),
      "Success");
  });
 
   test("create account exception", () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
        email: ("swastikroy157@gmail.com"), password: ("#exelliarmus123")),
    ).thenThrow(
      FirebaseAuthException(message: "Oops! Something went wrong", code: "500"),
    );

    expect(
      await auth.createAccount("swastikroy157@gmail.com", "#exelliarmus123"),
      "Oops! Something went wrong");
   });

   test("sign in", () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
        email: ("swastikroy157@gmail.com"),
        password: ("#exelliarmus123"),
      ),
    ).thenAnswer((_) async => MockUserCredential());

    expect(
      await auth.signIn("swastikroy157@gmail.com", "#exelliarmus123"),
      "Success");
  });
 
   test("sign in exception", () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
        email: ("swastikroy157@gmail.com"), password: ("#exelliarmus123")),
    ).thenThrow(
      FirebaseAuthException(message: "Oops! Something went wrong", code: "500"),
    );

    expect(
      await auth.signIn("swastikroy157@gmail.com", "#exelliarmus123"),
      "Oops! Something went wrong");
    });

    test("sign out", () async {
    when(
      mockFirebaseAuth.signOut(
      ),
    ).thenAnswer((_) async => MockUserCredential());
    expect(
      await auth.signOut(),
      "Success");
  });
}
