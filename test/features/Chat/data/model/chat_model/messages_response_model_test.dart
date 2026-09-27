import 'package:archilink/features/Chat/data/model/chat_model/messages_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses user response json accurately', () {
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
          },
          {
            "id": 5,
            "chat_id": 1,
            "content": "good, ff",
            "sent_at": "2026-09-21 23:23:50",
            "edited_at": null,
            "sender": {
              "id": 3,
              "name": "Test User",
              "username": "testUser3",
              "is_verified": null,
              "role": "admin",
              "avatar": null,
              "country": "Testland",
              "city": "Testville"
            },
            "reactions": []
          },
          {
            "id": 4,
            "chat_id": 1,
            "content": "how you doin",
            "sent_at": "2026-09-21 23:15:20",
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
          },
          {
            "id": 3,
            "chat_id": 1,
            "content": "of course it will",
            "sent_at": "2026-09-21 23:13:50",
            "edited_at": null,
            "sender": {
              "id": 3,
              "name": "Test User",
              "username": "testUser3",
              "is_verified": null,
              "role": "admin",
              "avatar": null,
              "country": "Testland",
              "city": "Testville"
            },
            "reactions": []
          },
          {
            "id": 2,
            "chat_id": 1,
            "content": "this application will be so much down",
            "sent_at": "2026-09-21 23:11:54",
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
          },
          {
            "id": 1,
            "chat_id": 1,
            "content": "Nice hat darling",
            "sent_at": "2026-09-21 23:11:21",
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
          "total": 6,
          "has_more": false,
          "next": null,
          "prev": null
        }
      }
    };

    final result = MessagesResponseModel.fromJson(responseJson);

    expect(result.messages.length, 6);
    expect(result.pagination.total, 6);
    expect(result.messages[0].id, 6);
    expect(result.messages[0].content, "hhhhhhhhhhhhh");
    expect(result.messages[0].sender.name, "aon");
    expect(result.messages[0].sender.userAvatar, contains("cloudinary"));
    expect(result.messages[0].receiptUserIds, isEmpty);
    expect(result.messages[0].reactions, isEmpty);
  });
}
