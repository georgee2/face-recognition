import 'package:cloud_firestore/cloud_firestore.dart';

class HandleAttendance {
  final firestore = FirebaseFirestore.instance;
  bool? existIn;
  bool? existOut;
  //List? retrievedData;
  final _collectionRefSignIn = FirebaseFirestore.instance.collection('Users').doc('attendance').collection('SignIn');
  final _collectionRefSignOut = FirebaseFirestore.instance.collection('Users').doc('attendance').collection('SignOut');

  submitSignIn(String name, String date, String time) async{
    print('start');
    if(name == '(No Face saved)' || name == '(NOT RECOGNIZED)'){
      print('not a person');
      return;
    }else{
      _collectionRefSignIn.where('name', isEqualTo: name).get().then((value) {
        if(value.docs.isEmpty){
          firestore.collection('Users').doc('attendance').collection('SignIn').add(
              {
                'name' : name,
                'date' : date,
                'time' : time,
              });
          existIn = true;
          print('submitted');
          return;
        }else{
          value.docs.forEach((element) {
            if(element['date'] == date){
              existIn = true;
              //print(exist);
              return;
            }else{
              existIn = false;
            }
          });
        }
      }).then((value) {
        print(existIn);
        existIn!? print('already submitted') : firestore.collection('Users').doc('attendance').collection('SignIn').add(
            {
              'name' : name,
              'date' : date,
              'time' : time,
            });
      });
    }
  }

  submitSignOut(String name, String date, String time) async{
    print('start');
    if(name == '(No Face saved)' || name == '(NOT RECOGNIZED)'){
      print('not a person');
      return;
    }else{
      _collectionRefSignOut.where('name', isEqualTo: name).get().then((value) {
        if(value.docs.isEmpty){
          firestore.collection('Users').doc('attendance').collection('SignOut').add(
              {
                'name' : name,
                'date' : date,
                'time' : time,
              });
          existOut = true;
          print('submitted');
          return;
        }else{
          value.docs.forEach((element) {
            if(element['date'] == date){
              existOut = true;
              //print(exist);
              return;
            }else{
              existOut = false;
            }
          });
        }
      }).then((value) {
        print(existOut);
        existOut!? print('already submitted') : firestore.collection('Users').doc('attendance').collection('SignOut').add(
            {
              'name' : name,
              'date' : date,
              'time' : time,
            });
      });
    }
  }

  // Future<void> getSubmitData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRefSignIn.get();
  //   // Get data from docs and convert map to List
  //   retrievedData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print(retrievedData);
  // }
}