import 'package:archilink/core/utils/message_mapper.dart';
import 'package:archilink/features/Chat/data/model/chat_model/messages_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses and maps to ChatView messages', () {
    final responseJson = {
      "status": "success",
      "message": "Success",
      "data": {
        "messages": [
          {
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
            },
            "reactions": []
          }
        ],
        "pagination": {
          "current_page": 1,
          "per_page": 50,
          "last_page": 1,
          "total": 1,
          "has_more": false,
          "next": null,
          "prev": null
        }
      }
    };

    final result = MessagesResponseModel.fromJson(responseJson);
    final chatViewMessage = result.messages.first.toChatViewMessage('1');

    expect(chatViewMessage.id, '6');
    expect(chatViewMessage.message, 'hhhhhhhhhhhhh');
    expect(chatViewMessage.sentBy, '1');
  });
}
