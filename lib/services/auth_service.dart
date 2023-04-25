import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/models/address_model.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/models/parent_model.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/repositories/repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/user_types.dart';

abstract class AuthService {
  Future<UserCredential?> createUser({
    required UserType userType,
    required String email,
    required String password,
    String? parentIdForStudentUser,
  });
  Future<UserCredential?> signIn(String email, String password);
  Future<void> signOut();
}

class AuthServiceIml extends AuthService {
  final FirebaseAuth _auth;
  final Repository<Consultant> _consultantRepository;
  final Repository<Parent> _parentRepository;
  final Repository<Student> _studentRepository;
  AuthServiceIml(
    this._auth,
    this._consultantRepository,
    this._parentRepository,
    this._studentRepository,
  );

  @override
  Future<UserCredential?> createUser({
    required UserType userType,
    required String email,
    required String password,
    String? parentIdForStudentUser,
  }) async {
    try {
      UserCredential userCredential;
      if (userType == UserType.consultant) {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await _consultantRepository.create(
          Consultant(uid: userCredential.user!.uid),
        );
        await userCredential.user?.updateDisplayName('consultant');
      } else if (userType == UserType.parent) {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await _parentRepository.create(
          Parent(
            uid: userCredential.user!.uid,
            name: '',
            phone: '',
            email: email,
            address: const Address(
              city: '',
              district: '',
              geoPoint: GeoPoint(0, 0),
            ),
          ),
        );
        await userCredential.user?.updateDisplayName('parent');
      } else {
        if (parentIdForStudentUser != null) {
          final parentSnapshot = await _parentRepository.collection
              .doc(parentIdForStudentUser)
              .get();
          if (parentSnapshot.exists) {
            userCredential = await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            await _studentRepository.create(
              Student(
                uid: userCredential.user!.uid,
                name: '',
                birthDay: DateTime(1970),
                address: const Address(
                  city: '',
                  district: '',
                  geoPoint: GeoPoint(0, 0),
                ),
                grade: 0,
                gender: '',
                parentId: parentIdForStudentUser,
              ),
            );
            await userCredential.user?.updateDisplayName('student');
          } else {
            return null;
          }
        } else {
          return null;
        }
      }
      await userCredential.additionalUserInfo?.profile
          ?.update('infoUpdated', (value) => false);
      return userCredential;
    } catch (e) {
      log('error', error: e);
      return null;
    }
  }

  @override
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log('error', error: e);
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
