import 'package:flutter/material.dart';
import 'package:shopsage_auth_app/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductListItem(
      {Key? key, required this.product, this.onEdit, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Text(product.name.isNotEmpty ? product.name[0] : '?')),
        title:
            Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(product.sku),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.grey.shade700),
              onPressed: onEdit),
          IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
              onPressed: onDelete),
        ]),
      ),
    );
  }
}
