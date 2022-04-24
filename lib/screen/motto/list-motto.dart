import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/model/motto-item.dart';
import 'package:flutter_application_1/screen/motto/motto-item.dart';

Widget ListMotto(BuildContext context, List<MottoItem>? mottos) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: mottos?.length,
    itemBuilder: (context, index) {
      return MottoSingle(context, mottos![index].content);
    },
  );
}
