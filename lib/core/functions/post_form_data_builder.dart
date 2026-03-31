import 'package:archilink/features/Create_Post/domain/entity/create_post_parms.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

Future<FormData> buildFormData(CreatePostParms params) async {
  final mediaFiles = <MultipartFile>[];

  for (final asset in params.assetIds) {
    final file = await asset.originFile;
    if (file == null) continue;
    final mime = lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];
    mediaFiles.add(
      await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType(mime[0], mime[1]),
      ),
    );
  }

  return FormData.fromMap({
    'body': params.text,
    'privacy': params.privacy,
    'tags[]': params.tags,
    'media[]': mediaFiles,
  });
}
