import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tubes/navbar.dart';
import 'package:tubes/rsc/colors.dart';


class ApplyJob extends StatefulWidget {
  const ApplyJob({super.key});

  @override
  State<ApplyJob> createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Cover Gambar Perusahaan
            buildCoverImage(),
           
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                  color: Colors.white
                ),
              ),
            ),

            //PP Perusahaan
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 140,
                  child: buildProfileImage()
                ),
              ]
            ),

            // Info Perusahaan
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 260,
                  child: Text('Tesla',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'GreycliffCF'
                    ),
                  ),
                ),

                Positioned(
                  top: 290,
                  child: Text('Product Manager',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'GreycliffCF'
                    ),
                  ),
                ),

                // contract & full-time
                Positioned(
                  top: 325,
                  child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: dpurple,
                            ),
                            child: const Text('Contract',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'GreycliffCF'
                              ),
                            ),
                        )
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: yellow,
                        ),
                        child: Text('Full-time',
                          style: TextStyle(
                            color: base,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GreycliffCF'
                          ),
                        ),
                      ),
                    ),                    
                  ],
                  ),
                ),
                
                // Applicants, Salary, Posisiton
                Positioned(
                  top: 370,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Applicants
                      Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.6)
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: ppblue,
                                child: Icon(
                                  Icons.people_alt_rounded,
                                  color: lblue,
                                ),
                              ),
                            ),

                            Column(
                              children: [
                                Text('+100',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'GreycliffCF',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600 
                                  ),
                                ),

                                Text('  Applicants  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'GreycliffCF',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400 
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        ),

                      // Sallary
                      Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.6)
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: pgreen,
                                child: Icon(
                                  Icons.attach_money_rounded,
                                  color: lgreen,
                                ),
                              ),
                            ),

                            Column(
                              children: [
                                Text('\$15K',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'GreycliffCF',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600 
                                  ),
                                ),

                                Text('  per year  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'GreycliffCF',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400 
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        ),

                      // Position
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.6)
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: pred,
                              child: Icon(
                                Icons.work_outline_rounded,
                                color: lred,
                              ),
                            ),
                          ),

                          Column(
                            children: [
                              Text(' Senior ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'GreycliffCF',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600 
                                ),
                              ),

                              Text('  Position  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'GreycliffCF',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400 
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      ),
                    ],
                  ),
                ),                

                
              ],
            ),

            // Button Apply Job
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 750,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      fixedSize: Size(340, 0),
                      backgroundColor: lblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _applyNotifications(context), 
                    child: Text('Apply Job',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'GreycliffCF',
                        fontWeight: FontWeight.w600 
                      ),
                    )
                  )
                )
              ],
            ),

            //pp User & Notif
            Container(
              padding: const EdgeInsets.all(12),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 0, top : 0, left: 0, bottom: 450),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        //pp
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          textDirection: TextDirection.ltr,
                          children: [
                            SizedBox(height: 90),
                            ProfilePicture(
                              name: 'Ashel',
                              radius: 36,
                              fontsize: 20,
                              img: 'https://i.pinimg.com/736x/d8/ef/ce/d8efce4fface78988c6cba03bca0fb6a.jpg',
                            ),
                          ],
                        ),

                        //Notif
                        Container(
                          //color: Colors.red.withOpacity(0.2),
                          margin: const EdgeInsets.only(right:0, left: 323, top: 5, bottom: 0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: SizedBox(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: bblue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                    onPressed: () => _showNotifications(context),
                                    child: Icon(
                                      Icons.notifications_none_outlined,
                                      color: lblue,
                                      size: 24,
                                    )
                                  )
                                )
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

              ],
                ),
            ),
            
            
          ],
        ),

        
      ),
    );
  }

  Widget buildCoverImage() => Container(
    color: greyb,
    child: Image.network (
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAB10FSGA6Wkse91jtn1UG2WfU7nc39KXshbVHM-J4Xg&s',
      width: double.infinity,
      height: 220,
      fit: BoxFit.cover,
      ),
  );

  Widget buildProfileImage() => CircleAvatar(
    radius: 60,
    backgroundColor: Colors.white,
    backgroundImage: NetworkImage(
    'https://i.pinimg.com/564x/53/d8/14/53d81454e5df2ccaab75e4004a6e4190.jpg'
    ),
  );

  Future<void> _applyNotifications(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          icon: Icon(Icons.task_alt_rounded, 
            size: 150,
            color: lblue,
          ),
          title: const Text('Job Applied Successfully',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'GreycliffCF',
              fontWeight: FontWeight.w600 
            ),
          ),
          content: const Text('You can now see your application progress in application page.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(10),
                fixedSize: Size(340, 0),
                backgroundColor: lblue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NavBar() ,));
              }, 
              child: Text('See My Applications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'GreycliffCF',
                  fontWeight: FontWeight.w600 
                ),
              )
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNotifications(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: const Text('You have no new notifications.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
}