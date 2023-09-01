import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference usersRef = firestore.collection('user_masters');
CollectionReference adminLoginRef = firestore.collection('admin');
CollectionReference vidhanRef = firestore.collection('vidhansabha');
CollectionReference districtRef = firestore.collection('district');
CollectionReference whatsappRef = firestore.collection('whatsapp');
