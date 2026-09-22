import 'dart:convert';
import 'package:archilink/features/Chat/data/model/chat_list_view_model/chat_list_model.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const jsonString = '''
{
	"status": "success",
	"message": "Success",
	"data": {
		"chats": [
			{
				"id": 2,
				"type": "private",
				"chat_name": "Test User",
				"chat_cover_url": null,
				"contact": {
					"id": 4,
					"name": "Test User",
					"username": "testUser4",
					"is_verified": null,
					"role": "store",
					"avatar": "https://res.cloudinary.com/dnsnbfbad/image/upload/c_fill,w_64,h_64/v1790026353/ghwunfq3y1wkiswtqlfn.jpg",
					"country": null,
					"city": null
				},
				"latest_message_at": null,
				"latest_message": null,
				"unread_count": 0,
				"read_inbox_max_id": null,
				"read_outbox_max_id": null
			},
			{
				"id": 1,
				"type": "private",
				"chat_name": "Test User",
				"chat_cover_url": null,
				"contact": {
					"id": 3,
					"name": "Test User",
					"username": "testUser3",
					"is_verified": null,
					"role": "admin",
					"avatar": null,
					"country": "Testland",
					"city": "Testville"
				},
				"latest_message_at": "2026-09-21 23:15:20",
				"latest_message": {
					"id": 4,
					"chat_id": 1,
					"content": "how you doin",
					"sent_at": "2026-09-21 23:15:20",
					"edited_at": null
				},
				"unread_count": 0,
				"read_inbox_max_id": 2,
				"read_outbox_max_id": null
			}
		],
		"pagination": {
			"current_page": 1,
			"per_page": 20,
			"total": 2,
			"last_page": 1,
			"from": 1,
			"to": 2
		}
	}
}
''';

  test('ChatListModel correctly parses the API response', () {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final model = ChatListModel.fromJson(jsonMap);

    expect(model.status, 'success');
    expect(model.message, 'Success');
    expect(model.chats.length, 2);

    // Chat 1 (id: 2)
    final chat1 = model.chats[0];
    expect(chat1.id, 2);
    expect(chat1.type, ChatType.private);
    expect(chat1.chatName, 'Test User');
    expect(chat1.chatCoverUrl, isNull);
    expect(chat1.latestMessageAt, isNull);
    expect(chat1.lastMessage, isNull);
    expect(chat1.unreadCount, 0);
    expect(chat1.readInboxMaxId, isNull);
    expect(chat1.readOutboxMaxId, isNull);

    // Contact in Chat 1
    expect(chat1.contact.id, 4);
    expect(chat1.contact.name, 'Test User');
    expect(chat1.contact.username, 'testUser4');
    expect(chat1.contact.isVerified, isNull);
    expect(chat1.contact.role, 'store');
    expect(chat1.contact.avatar,
        'https://res.cloudinary.com/dnsnbfbad/image/upload/c_fill,w_64,h_64/v1790026353/ghwunfq3y1wkiswtqlfn.jpg');
    expect(chat1.contact.userAvatar, chat1.contact.avatar);
    expect(chat1.contact.country, isNull);
    expect(chat1.contact.city, isNull);

    // Chat 2 (id: 1)
    final chat2 = model.chats[1];
    expect(chat2.id, 1);
    expect(chat2.type, ChatType.private);
    expect(chat2.chatName, 'Test User');
    expect(chat2.latestMessageAt, DateTime.parse('2026-09-21 23:15:20'));
    expect(chat2.lastMessage, isNotNull);
    expect(chat2.lastMessage!.id, 4);
    expect(chat2.lastMessage!.chatId, 1);
    expect(chat2.lastMessage!.content, 'how you doin');
    expect(chat2.lastMessage!.sentAt, DateTime.parse('2026-09-21 23:15:20'));
    expect(chat2.lastMessage!.editedAt, isNull);
    expect(chat2.readInboxMaxId, 2);
    expect(chat2.readOutboxMaxId, isNull);

    // Contact in Chat 2
    expect(chat2.contact.id, 3);
    expect(chat2.contact.role, 'admin');
    expect(chat2.contact.avatar, isNull);
    expect(chat2.contact.country, 'Testland');
    expect(chat2.contact.city, 'Testville');

    // Pagination
    expect(model.pagination.currentPage, 1);
    expect(model.pagination.perPage, 20);
    expect(model.pagination.total, 2);
    expect(model.pagination.lastPage, 1);
    expect(model.pagination.from, 1);
    expect(model.pagination.to, 2);
    expect(model.pagination.hasNextPage, isFalse);
  });
}
