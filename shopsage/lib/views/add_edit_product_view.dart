import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopsage_auth_app/controllers/vendor_controller.dart';
import 'package:shopsage_auth_app/models/product.dart';

class AddEditProductView extends StatefulWidget {
  final Product? product;
  AddEditProductView({Key? key, this.product}) : super(key: key);

  @override
  State<AddEditProductView> createState() => _AddEditProductViewState();
}

class _AddEditProductViewState extends State<AddEditProductView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();

  late VendorController ctrl;

  @override
  void initState() {
    super.initState();
    // Ensure controller exists — if not, register one.
    ctrl = Get.isRegistered<VendorController>()
        ? Get.find<VendorController>()
        : Get.put(VendorController());
    if (widget.product != null) {
      _nameCtrl.text = widget.product!.name;
      _priceCtrl.text = widget.product!.price.toString();
      _skuCtrl.text = widget.product!.sku;
      _stockCtrl.text = widget.product!.stock.toString();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _skuCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final sku = _skuCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text) ?? 0.0;
    final stock = int.tryParse(_stockCtrl.text) ?? 0;

    try {
      if (widget.product == null) {
        final p = Product(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            sku: sku,
            price: price,
            stock: stock);
        ctrl.addProduct(p);
      } else {
        final updated = widget.product!
            .copyWith(name: name, sku: sku, price: price, stock: stock);
        ctrl.updateProduct(widget.product!.id, updated);
      }
      Get.back();
    } catch (err, st) {
      Get.snackbar('Error', 'Failed to save product: $err',
          snackPosition: SnackPosition.BOTTOM);
      print('Save product error: $err\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit product' : 'Add product'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  MediaQuery.of(context).padding.bottom +
                  12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.red.shade100)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextFormField(
                            controller: _nameCtrl,
                            decoration:
                                InputDecoration(labelText: 'Product name'),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null),
                        SizedBox(height: 8),
                        TextFormField(
                            controller: _priceCtrl,
                            decoration: InputDecoration(labelText: 'Price'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null),
                        SizedBox(height: 8),
                        TextFormField(
                            controller: _stockCtrl,
                            decoration: InputDecoration(labelText: 'Stock'),
                            keyboardType: TextInputType.number,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null),
                        SizedBox(height: 8),
                        TextFormField(
                            controller: _skuCtrl,
                            decoration: InputDecoration(labelText: 'SKU'),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700),
                            onPressed: _save,
                            child:
                                Text(isEdit ? 'Save changes' : 'Save product'),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
