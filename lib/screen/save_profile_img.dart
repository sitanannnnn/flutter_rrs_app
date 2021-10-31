import 'dart:typed_data';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';

class CloudApiProfileImg {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient? _client;

  CloudApiProfileImg(String json)
      : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<ObjectInfo?> save(String name, Uint8List imgBytes) async {
    // TODO create a client
    if (_client == null) {
      _client =
          (await auth.clientViaServiceAccount(_credentials, Storage.SCOPES));
    }

    // TODO Instantiate objects to cloud torage
    var storag = Storage(_client!, 'Image Upload Google Storage');
    var bucket = storag.bucket('cusprofile_img');

    // TODO save to bucket
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(name);
    return await bucket.writeBytes(name, imgBytes,
        metadata: ObjectMetadata(contentType: type, custom: {
          'timestamp': '$timestamp',
        }));
  }
}
