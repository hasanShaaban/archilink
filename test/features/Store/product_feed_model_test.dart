import 'dart:convert';
import 'package:archilink/features/Store/data/models/product_feed_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const jsonString = '''{
	"status": "success",
	"message": "Product feed retrieved successfully",
	"data": {
		"products": [
			{
				"id": 92,
				"store": {
					"id": 1,
					"name": "Test User",
					"handle": "testUser4",
					"description": null,
					"city": null,
					"country": null,
					"store_logo_url": "https://example.com/logo.png",
					"store_banner_url": "https://example.com/banner.png",
					"is_active": true,
					"followers_count": 0
				},
				"name": "facere modi vel",
				"description": "Fuga quas repellendus molestias optio odio excepturi quod. Animi omnis nemo dolor adipisci. Rerum ullam illum eius deserunt odio atque commodi. Odit est nesciunt ut.",
				"price": 310.46,
				"quantity_in_stock": 51,
				"image_url": null,
				"categories": [
					{
						"id": 10,
						"name": "Est",
						"slug": "est"
					},
					{
						"id": 1,
						"name": "Fugiat",
						"slug": "fugiat"
					},
					{
						"id": 38,
						"name": "Natus",
						"slug": "natus"
					}
				],
				"media_items": [],
				"sku": "2239187629300",
				"status": "coming_soon",
				"created_at": "2026-09-13",
				"updated_at": "2026-09-13"
			}
		],
		"pagination": {
			"current_page": 1,
			"per_page": 20,
			"last_page": 5,
			"total": 100,
			"has_more": true,
			"next": "http://127.0.0.1:8000/api/v1/home/product-feed?page=2",
			"prev": null
		}
	}
}''';

  test('ProductFeedModel parses sample JSON response successfully', () {
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final model = ProductFeedModel.fromJson(decoded);

    expect(model.status, 'success');
    expect(model.message, 'Product feed retrieved successfully');
    expect(model.products.length, 1);
    expect(model.products.first.id, 92);
    expect(model.products.first.name, 'facere modi vel');
    expect(model.products.first.price, 310.46);
    expect(model.products.first.store.handle, 'testUser4');
    expect(model.products.first.categories.length, 3);
    expect(model.pagination.currentPage, 1);
    expect(model.pagination.hasMore, true);

    final entity = model.toEntity();
    expect(entity.products.length, 1);
    expect(entity.products.first.formattedStatus, 'Coming Soon');
    expect(entity.products.first.storeName, 'testUser4');
  });
}
