import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController biographyController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "CONTACT US",
            style: TextStyle(
                color: const Color.fromARGB(255, 105, 190, 108),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Name",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'your name here',
                    filled: true,
                    fillColor: Color.fromARGB(109, 112, 208, 166),
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Email",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'your email here',
                    filled: true,
                    fillColor: Color.fromARGB(109, 112, 208, 166),
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "About you",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  maxLines: 3,
                  controller: biographyController,
                  decoration: InputDecoration(
                    hintText: 'about you here',
                    filled: true,
                    fillColor: Color.fromARGB(109, 112, 208, 166),
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green)),
                      onPressed: () {
                        //  send for contacting  .
                      },
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Center(child: Text('Submit')))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
