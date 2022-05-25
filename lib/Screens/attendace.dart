import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool main = true;
  String? value;
  final Stream<QuerySnapshot> signIn = FirebaseFirestore.instance.collection('Users').doc('attendance').collection('SignIn').orderBy('date', descending: true).snapshots();
  final Stream<QuerySnapshot> signOut = FirebaseFirestore.instance.collection('Users').doc('attendance').collection('SignOut').orderBy('date', descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Attendance'),
        actions: [
          DropdownButton(
            value: value,
            elevation: 30,
            borderRadius:
            const BorderRadius.all(Radius.circular(15)),
            hint: const Text(
              'حضور',
              style: TextStyle(color: Colors.grey),
            ),
            dropdownColor: HexColor('2F409C'),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            onChanged: (String? newValue) {
              setState(() {
                value = newValue;
                value == 'حضور'? main = true : main = false;
              });
            },
            underline: Container(
              height: 0,
              color: Colors.black,
            ),
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            items: ['حضور', 'انصراف']
                .map<DropdownMenuItem<String>>((e) {
              return DropdownMenuItem(
                child: Text(
                  e,
                  style:
                  const TextStyle(color: Colors.white),
                ),
                value: e,
              );
            }).toList(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        color: HexColor('#001b26'),
        child: StreamBuilder<QuerySnapshot>(
          stream: main? signIn : signOut,
          builder: (ctx, snapshot){
            if(snapshot.hasError){
              return const Center(child: Text('something went wrong', style: TextStyle(color: Colors.white),));
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            if(snapshot.requireData.docs.isEmpty){
              return const Center(child: Text('no one submit until now', style: TextStyle(color: Colors.white),));
            }
            final data = snapshot.requireData;
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index){
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${data.docs[index]['date']}'),
                          Text('${data.docs[index]['time']}'),
                          Text('${data.docs[index]['name']}'),
                        ],
                      ),
                      const SizedBox(height: 15,),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
