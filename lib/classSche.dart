// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ewu_portal/Advising_rule.dart';
import 'package:ewu_portal/Profile.dart';
import 'package:ewu_portal/advising.dart';
import 'package:ewu_portal/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'DbHelper/Course_Data.dart';
import 'DbHelper/dbh.dart';
import 'DegreeReview.dart';
import 'FacEvaluation.dart';
import 'GradeReport.dart';
import 'InstallmentPayment.dart';
import 'MyAccLeadger.dart';
import 'OfferedCourse.dart';
import 'SemesterDrop.dart';
import 'UploadDoc.dart';
import 'convo.dart';
import 'curriculumn/Curriculumn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logins/loginPage.dart';
import 'logins/mainL.dart';
import 'logins/updatePass.dart';

GlobalKey<ScaffoldState> key = GlobalKey();

int s=1;
bool showCourse=false;
class classSche extends StatefulWidget {
  const classSche({super.key});

  @override
  State<classSche> createState() => _classScheState();
}

class _classScheState extends State<classSche> {

  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _filter = [];
  String? valueChosen;
  List SemList=["Fall24","Summer24","Spring24","Fall23","Summer23","Spring23","Fall22"];
  @override


  fetchCourses() async {
    await dbh.instance.deleteall();
    await insertData();
    var courses = await dbh.instance.queryDatabase();
    setState(() {
      _courses = courses;
      print(_filter);
    });
  }
  filterCourses(String sem) async{
    setState(() {
      _filter = _courses.where((course) => course[dbh.semester].toString() == sem).toList();
      print(_filter);
    });
  }
@override
  initState()  {
  //insertData();
  fetchCourses();
   showCourse=false;
  }
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar:AppBar(
      toolbarHeight: 60,
      title: TextButton(
        child: Image.asset(
          "assets/logonn.png",
          width: 200,
          height: 50,
          alignment: Alignment.topLeft,

        ),
        onPressed: (){
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>Home(),
          ));

        },
        style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            )
        ),
        ),
      ),

      leading: Builder(
        builder: (context) {

          return Container(
            height: 50,
            width: 40,
            alignment: Alignment.topLeft,
            color: Color.fromARGB(255, 75, 164, 200),
            //color: Color.fromARGB(255, 255, 0, 0),
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          );
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 40, 65, 111),
                Color.fromARGB(255, 40, 65, 111),
              ],
            )),
      ),
      iconTheme: IconThemeData(color: Colors.black, size: 40),

      actions: [
        Container(
          child: IconButton(onPressed: (){}, icon: Badge.count(
              count: 0,
              padding: EdgeInsets.all(2),
              child: FaIcon(FontAwesomeIcons.bell,size: 25,color: Colors.white,)),color: Colors.white,),
        )
        ,
        PopupMenuButton(
            offset: Offset(0, 50),
            itemBuilder: (context)=>[

              PopupMenuItem(
                child: Row(
                  children: [
                    Container(margin: EdgeInsets.only(left: 10,right: 10),child: FaIcon(FontAwesomeIcons.user,size: 16,color: Colors.black,)),
                    Container(child: Text("Profile",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),),
                  ],
                ), onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=> profile(),
                ));
              },

              ),

              PopupMenuItem(child: Row(
                children: [
                  Container(margin: EdgeInsets.only(left: 10,right: 10),child: FaIcon(FontAwesomeIcons.exchange,size: 16,color: Colors.black,)),
                  Container(child: Text("Change Password",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),),
                ],
              ), onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=> updatePass(),
                ));
              },

              ),

              PopupMenuItem(child: Row(
                children: [
                  Container(margin: EdgeInsets.only(left: 10,right: 10),child: FaIcon(FontAwesomeIcons.signInAlt,size: 16,color: Colors.black,)),
                  Container(child: Text("LogOut",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),),
                ],
              ), onTap: () async{

                var sharedPref= await SharedPreferences.getInstance();
                sharedPref.setBool(mainLState.KEYLOGIN, false);
                //Navigator.of(context).pop(true);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context)=>loginPage(),
                ));
              },
              ),


            ],icon: CircleAvatar(
            backgroundImage: AssetImage("assets/bateman.jpg",)
        )
          //FaIcon(FontAwesomeIcons.userCog,size: 25,color: Colors.white,),color: Colors.white,
        )
      ],
    ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 40, 65, 111),
          child: ListView(
            children: [
              ListTile(
                leading: Icon(
                  Icons.dehaze,
                  color: Colors.white,
                  size: 40,
                ),
                onTap: () {
                  key.currentState!.closeDrawer();
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidRegistered,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'ADVISING',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> advising(),
                  ));
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.school,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'MY CLASS SCHEDULE',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                ),
                /*
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),*/
               // onTap: () {},
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.book,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'ADVISING RULE',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {

                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> AdvisingRule(),
                  ));

                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.sortNumericAsc,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'GRADE REPORT',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> GradeReport(),
                  ));
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.trash,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'SEMESTER DROP',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Semesterdrop(),
                  ));
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.bookOpenReader,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'CURRICULUMN',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {


                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Curriculumn(),
                  ));

                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.coins,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'INSTALLEMNT PAYMENT',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.1),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Installmentpayment(),
                  ));
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.moneyCheck,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'MY ACCOUNT LEADGER',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.5),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Myaccleadger(),
                  ));
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.bookOpen,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'OFFERED COURSES',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Offeredcourse(),
                  ));
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.book,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'DEGREE REVIEW',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Degreereview(),
                  ));
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.fill,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'FACULTY EVALUATION',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Facevaluation(),
                  ));
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.userGraduate,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'CONVOCATION APPLY',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {



                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> convo(),
                  ));



                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.fileUpload,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'UPLOAD DOCUMENT',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Uploaddoc(),
                  ));
                },
              ),
            ],
          ),
        ),

      body:


      Column(
        children: <Widget>[

          Container(
            height: 25,

          ),Divider(
            height: 20,
            thickness: 0.3,
            color: Colors.black,
          ),Container(
            height: 20,

          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(
                width: 240,
                child: DropdownButton2(
                  hint: Text("Select Semester"),
                  value: valueChosen,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      valueChosen = newValue as String;
                    });
                  },
                  items: SemList.map((valueItem){
                    return DropdownMenuItem(value: valueItem,child: Text(valueItem));
                  }).toList(),

                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 76, 165, 196),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  onPressed: () async{
                  // await dbh.instance.deleteall();
                 //await insertData();
                  await fetchCourses();
                  filterCourses(valueChosen!);
                  showCourse=true;
                  s=1;
                  }, child: Text("SHOW COURSES",
                    style: TextStyle(color: Colors.white,fontSize: 12,),textAlign: TextAlign.left,),),



            ],
          ),
        Container(
          width: 500,
          height: 30,
        ),
             Visibility(
               visible: showCourse,
               child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(color: Colors.black),
                  columns: [
                  DataColumn(label: Text("Serial",style: TextStyle(fontWeight: FontWeight.bold),),),
                  DataColumn(label: Text("Course",style: TextStyle(fontWeight: FontWeight.bold),)),
                   DataColumn(label: Text("Section",style: TextStyle(fontWeight: FontWeight.bold),)),
                   DataColumn(label: Text("Credit",style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text("Timing",style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text("Faculty Initial",style: TextStyle(fontWeight: FontWeight.bold),)),
                   DataColumn(label: Text("Faculty",style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text("Faculty Mail",style: TextStyle(fontWeight: FontWeight.bold),)),
                 //  DataColumn(label: Text("Semester",style: TextStyle(fontWeight: FontWeight.bold),)),

                ],
                  rows: _filter.map((course) => DataRow(
                    cells: [
                      DataCell(Text((s++).toString())),
                      DataCell(Text(course[dbh.course].toString()),),
                      DataCell(Text(course[dbh.section].toString())),
                     DataCell(Text(course[dbh.credit].toString())),
                      DataCell(Text(course[dbh.timing].toString())),
                      DataCell(Text(course[dbh.facultyIni].toString())),
                       DataCell(Text(course[dbh.faculty].toString())),
                      DataCell(Text(course[dbh.facultyMail].toString())),
                     //  DataCell(Text(course[dbh.semester].toString())),
                    ],
                  ),
                )
                    .toList(),


                ),
                           ),
             ),

        ],
      ),

    );
  }
}


