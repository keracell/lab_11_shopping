import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lab_11_shopping/data/categories.dart';
import 'package:lab_11_shopping/models/category_model.dart';
import 'package:lab_11_shopping/models/grocery_item_model.dart';
import 'package:lab_11_shopping/api/config.dart';

final database = 'shopping-list';

Category getCategoryByTitle(String title) {
  return categories[Categories.values.firstWhere(
    (c) => c.toString().toLowerCase() == 'categories.${title.toLowerCase()}',
  )]!;
}

class ShoppingApi {
  Future<List<GroceryItem>> getAll() async {
    final url = Uri.https(baseUrl, '$database.json');

    final response = await http.get(url);

    final Map<String, dynamic> mapItems = json.decode(response.body);

    final List<GroceryItem> items = [];
    for (final item in mapItems.entries) {
      items.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: getCategoryByTitle(item.value['category']),
        ),
      );
    }

    return items;
  }

  Future<bool> remove(String id) async {
    final url = Uri.https(baseUrl, '$database/$id.json');
    final response = await http.delete(url);

    return response.statusCode < 300;
  }

  Future<GroceryItem> add(
    String name,
    int quantity,
    String categoryTitle,
  ) async {
    final url = Uri.https(baseUrl, '$database.json');
    final newItem = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: json.encode({
        'name': name,
        'quantity': quantity,
        'category': categoryTitle,
      }),
    );

    final id = json.decode(newItem.body)['name'];

    return GroceryItem(
      id: id,
      name: name,
      quantity: quantity,
      category: getCategoryByTitle(categoryTitle),
    );
  }
}

final shoppingApi = ShoppingApi();
