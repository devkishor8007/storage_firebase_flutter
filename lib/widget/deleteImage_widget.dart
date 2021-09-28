import 'package:flutter/material.dart';
import 'package:flux_firex_storage/model/image_model.dart';
import 'package:flux_firex_storage/service/image_service.dart';
import 'package:flux_firex_storage/widget/textButton_widget.dart';

Future<dynamic> deleteImageDialog(BuildContext context, ImageModel imageModel) {
  return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Are you sure to delete?"),
          actions: [
            TextButtonWidget(
                name: "Yes",
                onPressed: () {
                  ImageFireStoreService.deleteImage(imageModel.id.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Delete Successfully"),
                    ),
                  );
                  Navigator.pop(context, true);
                }),
            TextButtonWidget(
                name: "No",
                onPressed: () {
                  Navigator.pop(context, false);
                }),
          ],
        );
      });
}
