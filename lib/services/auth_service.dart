import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/models/address_model.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/models/parent_model.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/repositories/consultant_repository.dart';
import 'package:consultant/repositories/parent_repository.dart';
import 'package:consultant/repositories/student_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/user_types.dart';

class AuthService {
  final FirebaseAuth _auth;
  final ConsultantRepository _consultantRepository;
  final ParentRepository _parentRepository;
  final StudentRepository _studentRepository;
  AuthService(
    this._auth,
    this._consultantRepository,
    this._parentRepository,
    this._studentRepository,
  );

  Future<UserCredential?> createUser(
    UserType userType,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userType == UserType.consultant) {
        await _consultantRepository.create(
          Consultant(uid: userCredential.user!.uid),
        );
        await userCredential.user?.updateDisplayName('consultant');
      } else if (userType == UserType.parent) {
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
          ),
        );
        await userCredential.user?.updateDisplayName('student');
      }
      return userCredential;
    } catch (e) {
      log('error', error: e);
      return null;
    }
  }

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

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
