import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/message.dart';

class MessageController extends GetxController {
  TextEditingController textEditingController = TextEditingController();

  RxList<Messages> allMsg = List.generate(
    10,
    (index) => Messages(DateTime.now().subtract(Duration(hours: 3 * index)),
        owner: index.isEven ? "Me" : "Mike Mazowski",
        desc:
            "Hello guys, we have discussed about post-corona vacation plan and our decision is to go to Bali. "),
  ).obs;
  ScrollController listScrollController = ScrollController();
  Map<String, List<Messages>> get msgs => _getGroupedList(allMsg);

  List<String> get msgKeys => msgs.keys.toList();

  @override
  onInit() {
    _sortInboxByTime();
    super.onInit();
  }

  addNewMsg() {
    if (textEditingController.value.text.isEmpty) return;
    allMsg
        .add(Messages(DateTime.now(), desc: textEditingController.value.text));
  }

  _sortInboxByTime() {
    allMsg.sort(((a, b) => a.time.compareTo(b.time)));
  }

  Map<String, List<Messages>> _getGroupedList(List<Messages> soms) {
    final groupedInbox = groupBy(soms, (Messages ele) {
      return DateFormat("MMMM d").format(ele.time);
    });
    return groupedInbox;
  }

  List<Messages> getMsg(int i) {
    return msgs[msgKeys[i]]!;
  }
}
