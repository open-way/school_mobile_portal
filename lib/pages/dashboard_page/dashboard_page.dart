import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.authService, this.userId, this.logoutCallback})
      : super(key: key);

  static const String routeName = '/dashboard';
  final AuthService authService;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    //_checkEmailVerification();

    // _todoList = new List();
    // _todoQuery = _database
    //     .reference()
    //     .child("todo")
    //     .orderByChild("userId")
    //     .equalTo(widget.userId);
    // _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
    // _onTodoChangedSubscription =
    //     _todoQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      // body: ContactList());
      body: Card(
        child: Text('Dashboard page'),
      ),
    );
  }
}

// class DashboardPage extends StatelessWidget {
//   static const String routeName = '/dashboard';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: AppDrawer(),
//       appBar: AppBar(
//         title: Text('Dashboard'),
//       ),
//       // body: ContactList());
//       body: Card(
//         child: Text('Dashboard page'),
//       ),
//     );
//   }
// }

// class ContactList extends StatefulWidget {
//   ContactList({Key key}) : super(key: key);

//   @override
//   _ContactListState createState() => _ContactListState();
// }

// class _ContactListState extends State<ContactList>
//     implements ContactListViewContract {
//   ContactListPresenter _presenter;

//   List<Contact> _contacts;

//   bool _isSearching;

//   _ContactListState() {
//     _presenter = ContactListPresenter(this);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _isSearching = true;
//     _presenter.loadContacts();
//   }

//   @override
//   void onLoadContactsComplete(List<Contact> items) {
//     setState(() {
//       _contacts = items;
//       _isSearching = false;
//     });
//   }

//   @override
//   void onLoadContactsError() {
//     // TODO: implement onLoadContactsError
//   }

//   @override
//   Widget build(BuildContext context) {
//     var widget;

//     if (_isSearching) {
//       widget = Center(
//           child: Padding(
//               padding: EdgeInsets.only(left: 16.0, right: 16.0),
//               child: CircularProgressIndicator()));
//     } else {
//       widget = ListView(
//           padding: EdgeInsets.symmetric(vertical: 8.0),
//           children: _buildContactList());
//     }

//     return widget;
//   }

//   List<_ContactListItem> _buildContactList() {
//     return _contacts
//         .map((contact) => new _ContactListItem(
//             contact: contact,
//             onTap: () {
//               _showContactPage(context, contact);
//             }))
//         .toList();
//   }

//   void _showContactPage(BuildContext context, Contact contact) {
//     Navigator.push(
//         context,
//         new MaterialPageRoute<Null>(
//             settings: const RouteSettings(name: ContactPage.routeName),
//             builder: (BuildContext context) => new ContactPage(contact)));
//   }
// }

// ///
// ///   Contact List Item
// ///

// class _ContactListItem extends ListTile {
//   _ContactListItem(
//       {@required Contact contact, @required GestureTapCallback onTap})
//       : super(
//             title: Text(contact.fullName),
//             subtitle: Text(contact.email),
//             leading: CircleAvatar(child: Text(contact.fullName[0])),
//             onTap: onTap);
// }
