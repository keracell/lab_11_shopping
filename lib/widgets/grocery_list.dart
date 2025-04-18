import 'package:flutter/material.dart';
import 'package:lab_11_shopping/api/shopping_list.dart';
import 'package:lab_11_shopping/models/grocery_item_model.dart';
import 'package:lab_11_shopping/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  void _getItems() async {
    final items = await shoppingApi.getAll();
    setState(() {
      _groceryItems = items;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) return;

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    if (!await shoppingApi.remove(item.id)) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        "List is Empty",
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
    );

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_groceryItems[index]),
            child: ListTile(
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              title: Text(_groceryItems[index].name),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
            onDismissed: (direction) {
              _removeItem(_groceryItems[index]);
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getItems();
        },
        child: content,
      ),
    );
  }
}
