import 'package:flutter/material.dart';
// import 'package:group_chat/Constants/colors.dart';
import 'package:group_chat/Pages/group_chat.dart';
// import 'package:group_chat/Widgets/cards_user.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  TextEditingController userEmailController = TextEditingController();
  _add_Group_Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: AlertDialog(
              scrollable: true,
              title: const Text('Add Group'),
              content: Column(
                children: [
                  TextFormField(
                    controller: userEmailController,
                    // validator: validateUsername,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Group Name',
                      hintStyle: const TextStyle(
                        color: Colors.black12,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  // _contentServices(context),

                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: userEmailController,
                    // validator: validateUsername,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Group Description',
                      hintStyle: const TextStyle(
                        color: Colors.black12,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  // _contentServices(context),

                  const SizedBox(
                    height: 30,
                  ),

                  // RadioButtonGroup(
                  //   labels: [
                  //     "Personal",
                  //     "Business",
                  //   ],
                  //   labelStyle:
                  //       TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  //   // disabled: ["Option 1"],
                  //   onChange: (String label, int index) => setState(() {
                  //     value = index;
                  //     print("label: $label index: $index");
                  //   }),

                  //   onSelected: (String label) => print(label),
                  // ),

                  // const SizedBox(
                  //   height: 16,
                  // ),

                  MaterialButton(
                    elevation: 0,
                    color: const Color(0xFF44B6AF),
                    height: 50,
                    minWidth: 500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      // _add_client_API();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Create',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/teamwork.png'),
              ),
              title: Text('Contact Name'),
              subtitle: Text('Status'),
              trailing: IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  // Handle message button press
                  // ...
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupChatScreen()),
                );
                },
              ),
              onTap: () {
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Action to perform when the FAB is pressed
          // print('FAB Pressed');
          _add_Group_Dialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
