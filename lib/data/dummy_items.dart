import 'package:lab_11_shopping/data/categories.dart';
import 'package:lab_11_shopping/models/category_model.dart';
import 'package:lab_11_shopping/models/grocery_item_model.dart';

List<GroceryItem> groceryItems = [
  GroceryItem(
    id: 'a',
    name: 'Milk',
    quantity: 1,
    category: categories[Categories.dairy]!,
  ),
  GroceryItem(
    id: 'b',
    name: 'Bananas',
    quantity: 5,
    category: categories[Categories.fruit]!,
  ),
  GroceryItem(
    id: 'c',
    name: 'Beef Steak',
    quantity: 1,
    category: categories[Categories.meat]!,
  ),
];
