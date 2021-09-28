import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flux_firex_storage/main.dart';
import 'package:flux_firex_storage/model/image_model.dart';
import 'package:flux_firex_storage/pages/fullImages.dart';
import 'package:flux_firex_storage/service/auth_service.dart';
import 'package:flux_firex_storage/service/image_service.dart';
import 'package:flux_firex_storage/widget/deleteImage_widget.dart';
import 'package:flux_firex_storage/widget/textButton_widget.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  final User uid;
  HomePage({required this.uid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  late File file;
  String? filename;
  bool _isLoading = false;

  Future<void> uploadImage(String imageSource) async {
    final picker = ImagePicker();

    final XFile? imagePick = await picker.pickImage(
      source:
          imageSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
    );

    if (imagePick == null) {
      return;
    }
    file = File(imagePick.path);
    filename = imagePick.path;
    File compresImg = await compressImage(file);

    try {
      setState(() {
        _isLoading = true;
      });
      String imageUrl =
          await _firebaseStorage.ref(filename).putFile(compresImg).then((res) {
        return res.ref.getDownloadURL();
      });

      await ImageFireStoreService.addImage(widget.uid.uid, imageUrl);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Added Successfully!"),
        ),
      );
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<File> compressImage(File file) async {
    File compressImageFile =
        await FlutterNativeImage.compressImage(file.path, quality: 50);
    print(file.path); // show the size of our image without compress
    print(compressImageFile.path); // show the size of our image with compress
    return compressImageFile;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Anonymous Image Savier"),
          actions: [
            _isLoading
                ? CircularProgressIndicator()
                : IconButton(
                    onPressed: () {
                      onCameraGalleryDiaglog(context);
                    },
                    icon: Icon(Icons.more_vert),
                  ),
          ],
        ),
        drawer: OpenDrawer(),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('images')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          ImageModel imageModel =
                              ImageModel.fromJson(snapshot.data!.docs[index]);
                          return InkWell(
                            onTap: () {
                              deleteImageDialog(context, imageModel);
                            },
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FullImageShow(image: imageModel),
                                ),
                              );
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shadowColor: Colors.black.withOpacity(0.5),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                height: size.height * 0.45,
                                width: size.width,
                                child: Image.network(
                                  imageModel.image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        });
              }
              return Container();
            }));
  }

  Future<dynamic> onCameraGalleryDiaglog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextButtonWidget(
                      name: "Camera",
                      onPressed: () {
                        uploadImage("camera");
                        Navigator.pop(context);
                      }),
                  const SizedBox(
                    height: 25,
                  ),
                  TextButtonWidget(
                    name: "Gallery",
                    onPressed: () {
                      uploadImage("gallery");
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class OpenDrawer extends StatelessWidget {
  const OpenDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('imageViwer'),
            accountEmail: Text("image@viewr.2021"),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              AuthService.logout();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => AuthChecker()));
            },
          ),
        ],
      ),
    );
  }
}
