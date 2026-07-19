import 'package:flutter/material.dart' hide SearchBar;
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../pages/cart_page.dart';
import '../pages/profile_page.dart';
import '../widgets/banner_card.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/home_appbar.dart';
import '../widgets/product_card.dart';
import '../widgets/section_title.dart';
import '../widgets/search_bar.dart';
import '../widgets/offer_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _service = ProductService();
  late Future<List<ProductModel>> _productsFuture;
  int _selectedIndex = 0;
  int _cartCount = 0;
  String _searchQuery = '';
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = _service.fetchProducts(limit: 20);
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
      _showSearch = false;
      _searchQuery = '';
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  void _addToCart() {
    setState(() {
      _cartCount += 1;
    });
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchQuery = '';
      }
    });
  }

  void _goToCart() {
    setState(() {
      _selectedIndex = 2;
      _showSearch = false;
      _searchQuery = '';
    });
  }

  void _goToProfile() {
    setState(() {
      _selectedIndex = 4;
      _showSearch = false;
      _searchQuery = '';
    });
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    if (_searchQuery.isEmpty) return products;
    return products.where((product) {
      final query = _searchQuery;
      return product.name.toLowerCase().contains(query) ||
          (product.brand?.toLowerCase().contains(query) ?? false) ||
          (product.category?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        // ignore: sort_child_properties_last
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(),
            _buildPlaceholderView(context, 'Categories'),
            const CartPage(),
            _buildPlaceholderView(context, 'Orders'),
            const ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppBar(
                onSearchTap: _toggleSearch,
                onCartTap: _goToCart,
                onProfileTap: _goToProfile,
                isSearchActive: _showSearch,
                cartCount: _cartCount,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        if (_showSearch) ...[
          SliverToBoxAdapter(
            child: SearchBar(onChanged: _onSearchChanged),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
        const SliverToBoxAdapter(child: BannerCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        const SliverToBoxAdapter(child: OfferCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        const SliverToBoxAdapter(
          child: SectionTitle(
            title: 'Trending Now',
            actionText: 'See all',
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 270,
            child: FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load products.'));
                }
                final products = _filterProducts(snapshot.data ?? []);
                final trending = products.take(5).toList();
                if (trending.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: trending.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: trending[index],
                      onPressed: _addToCart,
                    );
                  },
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Text(
                  'Flash Deals',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.red, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '02:14:36',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 270,
            child: FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load products.'));
                }
                final products = _filterProducts(snapshot.data ?? []);
                final flashDeals = products.skip(5).take(4).toList();
                if (flashDeals.isEmpty) {
                  return const Center(child: Text('No flash deals available.'));
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: flashDeals.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: flashDeals[index],
                      onPressed: _addToCart,
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SectionTitle(
            title: 'Handpicked For You',
            actionText: 'See all',
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return FutureBuilder<List<ProductModel>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    }
                    final products = _filterProducts(snapshot.data ?? []);
                    final handpicked = products.skip(9).take(4).toList();
                    if (index >= handpicked.length) {
                      return const SizedBox.shrink();
                    }
                    return ProductCard(
                      product: handpicked[index],
                      onPressed: _addToCart,
                    );
                  },
                );
              },
              childCount: 4,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 90)),
      ],
    );
  }

  Widget _buildPlaceholderView(BuildContext context, String title) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
