import 'package:flutter/material.dart';


class Verifierscreen  extends StatelessWidget{
  const Verifierscreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 233, 244, 253),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [const Color.fromARGB(255, 56, 165, 255), Color.fromARGB(255, 3, 134, 194)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(20),
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Icon(Icons.person, size: 50, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 120),
                Text(
                  "Scan to Continue",
                  style: TextStyle(
                    fontSize: 25,
                    color: const Color.fromARGB(255, 6, 144, 213),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                   
               GestureDetector(
  /*onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => (),
      ),
    );
  },*/
  child: Container(
    width: 220,
    height: 220,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        colors: [Colors.blue, Color.fromARGB(255, 3, 175, 255)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.4),
          blurRadius: 25,
          spreadRadius: 6,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.center_focus_strong,
          color: Colors.white,
          size: 90,
        ),
        SizedBox(height: 20),
        Text(
          "Face Scan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  ),
),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                    child:Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.topCenter,
                      width: 150,
                      height: 100,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, color: Colors.blue),
                          SizedBox(width: 6),
                          Text(
                            "Last Scan",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    )
                    ),
                    Expanded(
                      child: 
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.topCenter,
                      width: 150,
                      height: 100,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 6),
                          Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      
    );
  }
}
