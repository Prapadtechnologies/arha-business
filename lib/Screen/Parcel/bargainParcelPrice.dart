import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:we_courier_merchant_app/Screen/Widgets/constant.dart';

import '../../utils/image.dart';
import '../../utils/size_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';

class BargainParcelPrice extends StatefulWidget {
  BargainParcelPrice({Key? key}) : super(key: key);

  @override
  State<BargainParcelPrice> createState() => _BargainParcelPriceState();
}

class _BargainParcelPriceState extends State<BargainParcelPrice> {

  var TotalCost;
  TextEditingController _totalCostController = TextEditingController();
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        //  mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
          _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
          _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      //  await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(types.TextMessage message, types.PreviewData previewData,) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfigCustom sizeConfig = SizeConfigCustom();
    sizeConfig.init(context);
    final Size size = MediaQuery.of(context).size;
    TotalCost = ModalRoute.of(context)!.settings.arguments;
    print("Price ==> $TotalCost}");

    return Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          titleSpacing: 0,
          backgroundColor: kBgColor,
          elevation: 0.0,
          title: Container(
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            height: 70,
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Images.appLogo, fit: BoxFit.cover),
              ],
            ),
          ),
        ),
        body: Stack(children: [
          Container(
            child: SingleChildScrollView(
              child: Column(children: [

                Container(height:400, child:   Chat(
                  messages: _messages,
                  onAttachmentPressed: _handleAttachmentPressed,
                  onMessageTap: _handleMessageTap,
                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  showUserAvatars: true,
                  showUserNames: true,
                  user: _user,
                  theme: const DefaultChatTheme(
                    seenIcon: Text(
                      'read',
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),),

                const SizedBox(height: 30.0),
                Container(margin: EdgeInsets.only(left: 10,right: 10),
                  child: AppTextField(
                    controller: TextEditingController(text: TotalCost),
                    showCursor: true,
                    cursorColor: kTitleColor,
                    textFieldType: TextFieldType.NAME,
                     decoration: kInputDecoration.copyWith(
                      labelText: 'Total Cost',
                      labelStyle: kTextStyle.copyWith(color: kTitleColor),
                      hintText: '0.0',
                      hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                      suffixIcon:
                      const Icon(Icons.currency_rupee, color: kGreyTextColor),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                Container(margin: EdgeInsets.only(left: 10,right: 10),
                  child: TextFormField(
                  cursorColor: kTitleColor,
                  textAlign: TextAlign.start,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'note',
                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 45, horizontal: 10.0),
                  ),
                ),
                ),
                const SizedBox(height: 40.0),

                Container(height: 60,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  BargainParcelPrice(),
                          settings: RouteSettings(
                            arguments: '${Get.find<GlobalController>().currency!}${parcel.parcelList[index].totalDeliveryAmount.toString()}',
                          ),
                        ),
                      );*/
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      elevation: 2,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              ]),
            ),
          ),
        ]));
  }
}
