import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group_chat/services/firestore_service.dart';
import 'package:get/get.dart';
import 'package:flutter_group_chat/controller/login_controller.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  LoginController _loginController = Get.find();
  TextEditingController _sendController = TextEditingController();
  FocusNode _fn = FocusNode();

  @override
  void dispose() {
    _sendController.dispose();
    _fn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_loginController.name}'),
      ),
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: _streamMessageList(context)),
          _sendMessageWidget(context),
        ],
      ),
    );
  }

  Widget _streamMessageList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireStoreService().getChatsMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Something went wrong');

        if (snapshot.connectionState == ConnectionState.waiting)
          return Text('Loading');

        if (!snapshot.hasData) return Center(child: Text('No data'));

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            if (_loginController.name.toString() ==
                snapshot.data.docs[index].get('name'))
              return _receiveMessage(
                context,
                name: snapshot.data.docs[index].get('name'),
                message: snapshot.data.docs[index].get('message'),
                isSender: true,
              );
            else
              return _receiveMessage(
                context,
                name: snapshot.data.docs[index].get('name'),
                message: snapshot.data.docs[index].get('message'),
                // isSender: true,
              );
          },
        );
      },
    );
  }

  Widget _receiveMessage(
    BuildContext context, {
    @required String name,
    @required String message,
    bool isSender = false,
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomRight:
                isSender ? Radius.circular(0.0) : Radius.circular(12.0),
            bottomLeft: isSender ? Radius.circular(12.0) : Radius.circular(0.0),
          ),
          color: isSender ? Colors.blue[100] : Colors.grey[300],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(message),
          ],
        ),
      ),
    );
  }

  Widget _sendMessageWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _sendController,
        focusNode: _fn,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              await FireStoreService().sendMessages(
                _sendController.text,
                _loginController.name.toString(),
              );

              _sendController.text = '';
              _fn.unfocus();
            },
          ),
        ),
      ),
    );
  }
}
