import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Chat/data/data_source/chat_remote_data_source_impl.dart';
import 'package:archilink/features/Chat/data/repo/chat_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeApiService extends ApiService {
  final Map<String, dynamic> responseData;
  FakeApiService(this.responseData) : super(Dio());

  @override
  Future<Response<T>> post<T>(String path, {dynamic body}) async {
    return Response<T>(
      data: responseData as T,
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }
}

void main() {
  test('sendMessage parses API response correctly and returns MessageEntity',
      () async {
    final fakeResponse = {
      "status": "success",
      "message": "Message Sent",
      "data": {
        "id": 6,
        "chat_id": 1,
        "content": "hhhhhhhhhhhhh",
        "sent_at": "2026-09-22 21:27:58",
        "edited_at": null,
        "sender": {
          "id": 1,
          "name": "aon",
          "username": "testUser1",
          "is_verified": null,
          "role": "mentor",
          "avatar":
              "https://res.cloudinary.com/dnsnbfbad/image/upload/c_fill,w_64,h_64/v1790027905/testUser1.jpg",
          "country": "Testland",
          "city": "Testville"
        }
      }
    };

    final dataSource = ChatRemoteDataSourceImpl(FakeApiService(fakeResponse));
    final repo = ChatRepoImpl(dataSource);

    final result = await repo.sendMessage(
      conversationId: 1,
      content: "hhhhhhhhhhhhh",
    );

    expect(result.isRight(), isTrue);
    result.fold(
      (failure) => fail('Expected right, got failure: $failure'),
      (message) {
        expect(message.id, 6);
        expect(message.chatId, 1);
        expect(message.content, "hhhhhhhhhhhhh");
        expect(message.sender.name, "aon");
        expect(message.sender.userAvatar, contains("cloudinary"));
      },
    );
  });
}
