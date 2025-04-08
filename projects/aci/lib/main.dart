import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Academic Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    final url = Uri.parse('https://localhost:7168/login');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      String jwt = responseBody['accessToken'];

      // Store the JWT securely
      await secureStorage.write(key: 'jwt', value: jwt);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      // Navigate to the next screen or show success message
    } else {
      final responseBody = jsonDecode(response.body);
      var errorMessage = responseBody['detail'];
      print('Failed to login: ${response.body}');
      Fluttertoast.showToast(
        msg: "Username or Password is incorrect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        //backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/PSAU_LOGO.jpg', height: 300),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;

                    loginUser(email, password, context);
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<void> logout(BuildContext context) async {
    // Clear the stored JWT
    await secureStorage.delete(key: 'jwt');

    // Navigate back to the Login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context), // Call logout on button press
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildUserInfo("Major", "Software Engineering"),
                  _buildUserInfo("Status", "Active"),
                  _buildUserInfo("Degree", "Bachelor"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "All Services",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Academic",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "13 Services",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Most Used Services",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.2,
                children: [
                  _buildServiceCard(
                    Icons.school,
                    "Attempted Courses",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttemptedCoursesPage(),
                        ),
                      );
                    },
                  ),
                  _buildServiceCard(
                    Icons.check,
                    "Courses Results",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseResultsPage(),
                        ),
                      );
                    },
                  ),
                  _buildServiceCard(
                    Icons.calendar_today,
                    "Academic Calendar",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AcademicCalendarPage(),
                        ),
                      );
                    },
                  ),
                  _buildServiceCard(
                    Icons.smart_toy,
                    "AI Academic Assistant",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AcademicAssistantPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildServiceCard(IconData icon, String title, {Function()? onTap}) {
    final bool isMainService = (title == "AI Academic Assistant");
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isMainService ? Colors.teal : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isMainService ? Colors.white : Colors.teal,
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isMainService ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttemptedCoursesPage extends StatelessWidget {
  final List<Map<String, String>> attemptedCourses = [
    {
      "courseName": "Software Engineering",
      "courseCode": "SE101",
      "semester": "Fall 2024",
      "status": "Completed",
    },
    {
      "courseName": "Data Structures",
      "courseCode": "CS102",
      "semester": "Spring 2025",
      "status": "In Progress",
    },
    {
      "courseName": "Operating Systems",
      "courseCode": "CS201",
      "semester": "Fall 2024",
      "status": "Completed",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Attempted Courses'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: attemptedCourses.length,
        itemBuilder: (context, index) {
          final course = attemptedCourses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(Icons.book, color: Colors.teal),
                title: Text(
                  course["courseName"] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${course["courseCode"]} • ${course["semester"]} • ${course["status"]}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}

class CourseResultsPage extends StatelessWidget {
  final List<Map<String, String>> courseResults = [
    {
      "courseName": "Software Engineering",
      "courseCode": "SE101",
      "semester": "Fall 2024",
      "grade": "A",
    },
    {
      "courseName": "Data Structures",
      "courseCode": "CS102",
      "semester": "Spring 2025",
      "grade": "B+",
    },
    {
      "courseName": "Operating Systems",
      "courseCode": "CS201",
      "semester": "Fall 2024",
      "grade": "A-",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Course Results'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: courseResults.length,
        itemBuilder: (context, index) {
          final result = courseResults[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(Icons.grade, color: Colors.teal),
                title: Text(
                  result["courseName"] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${result["courseCode"]} • ${result["semester"]}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    result["grade"] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}

class AcademicAssistantPage extends StatefulWidget {
  @override
  _AcademicAssistantPageState createState() => _AcademicAssistantPageState();
}

class _AcademicAssistantPageState extends State<AcademicAssistantPage> {
  final List<String> messages = [];
  final TextEditingController textController = TextEditingController();
  bool isTyping = false;
  List<String> suggestedQuestions = [
    'What courses should I take next semester?',
    'How am I doing in my current plan?',
    'Can you help me find elective courses?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('AI Academic Assistant'),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isTyping) {
                  return _buildTypingIndicator();
                } else {
                  return _buildMessage(messages[index]);
                }
              },
            ),
          ),
          _buildInputSection(),
          _buildSuggestedQuestions(),
        ],
      ),
    );
  }

  Widget _buildMessage(String message) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return ListTile(
      title: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 10),
            Text("AI is typing..."),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Type your query...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              _sendMessage(textController.text);
            },
            child: Icon(Icons.send),
            backgroundColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggested Questions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children:
                suggestedQuestions.map((question) {
                  return ActionChip(
                    label: Text(question),
                    onPressed: () {
                      _sendMessage(question);
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        messages.add(message);
        isTyping = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          messages.add("AI response: This is an answer to '$message'.");
          isTyping = false;
        });
      });
      textController.clear();
    }
  }
}

class AcademicCalendarPage extends StatelessWidget {
  final List<Map<String, String>> events = [
    {
      "title": "Software Engineering Exam",
      "date": "Dec 20, 2024",
      "description": "Final exam for Software Engineering.",
    },
    {
      "title": "Data Structures Assignment Due",
      "date": "Nov 15, 2024",
      "description": "Submit assignment 3 for Data Structures.",
    },
    {
      "title": "Operating Systems Midterm",
      "date": "Oct 10, 2024",
      "description": "Midterm exam for Operating Systems.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Academic Calendar'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.teal),
                title: Text(
                  event["title"] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  event["date"] ?? '',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(event["title"] ?? ''),
                          content: Text(event["description"] ?? ''),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
