import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopsage_auth_app/controllers/vendor_controller.dart';
import 'package:shopsage_auth_app/views/add_edit_product_view.dart';
import 'package:shopsage_auth_app/widgets/product_list_item.dart';

class VendorDashboardView extends StatelessWidget {
  VendorDashboardView({Key? key}) : super(key: key);

  final VendorController ctrl = Get.put(VendorController());

  Widget _statCard(String title, String value, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: Colors.grey.shade700),
                ),
              Spacer(),
            ],
          ),
          SizedBox(height: 8),
          Text(value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(title, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Vendor dashboard'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700),
                      onPressed: () => Get.to(() => AddEditProductView()),
                      icon: Icon(Icons.add_box_outlined),
                      label: Text('Add product'),
                    ),
                    SizedBox(height: 12),

                    // Stats grid — only wrap the dynamic parts in Obx
                    Column(
                      children: [
                        SizedBox(
                            height: 120,
                            child: Obx(() => _statCard(
                                'Total products', '${ctrl.products.length}',
                                icon: Icons.inventory_2))),
                        SizedBox(height: 12),
                        SizedBox(
                            height: 120,
                            child: Obx(() => _statCard(
                                'Orders', '${ctrl.orders.value}',
                                icon: Icons.shopping_bag_outlined))),
                        SizedBox(height: 12),
                        SizedBox(
                            height: 120,
                            child: Obx(() => _statCard('Revenue',
                                '\$${ctrl.revenue.value.toStringAsFixed(0)}',
                                icon: Icons.attach_money))),
                        SizedBox(height: 12),
                        SizedBox(
                            height: 120,
                            child: Obx(() => _statCard(
                                'Pending orders', '${ctrl.pendingOrders.value}',
                                icon: Icons.pending_actions))),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Recent orders (mock)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recent orders',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                ListTile(
                                    title: Text('#SS-10284'),
                                    trailing: Text('\$119.00'),
                                    subtitle: Text('Processing')),
                                ListTile(
                                    title: Text('#SS-10279'),
                                    trailing: Text('\$36.00'),
                                    subtitle: Text('Processing')),
                                ListTile(
                                    title: Text('#SS-10273'),
                                    trailing: Text('\$79.00'),
                                    subtitle: Text('Processing')),
                              ],
                            )
                          ]),
                    ),

                    SizedBox(height: 12),

                    // Low stock alert
                    Obx(() {
                      final low = ctrl.lowStock;
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Low stock alert',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              if (low.isEmpty) Text('No low stock items'),
                              ...low.map((p) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(p.name),
                                  trailing: Text('${p.stock} left',
                                      style: TextStyle(color: Colors.orange))))
                            ]),
                      );
                    }),

                    SizedBox(height: 12),

                    // Product list
                    Text('Products',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    Obx(() => ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: ctrl.products.length,
                          separatorBuilder: (_, __) => SizedBox(height: 8),
                          itemBuilder: (context, idx) {
                            final p = ctrl.products[idx];
                            return ProductListItem(
                                product: p,
                                onEdit: () => Get.to(
                                    () => AddEditProductView(product: p)),
                                onDelete: () => ctrl.deleteProduct(p.id));
                          },
                        )),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
