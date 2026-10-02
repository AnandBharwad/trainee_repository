import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_assignment/cubit/product/product_cubit.dart';
import 'package:t_assignment/cubit/product/product_state.dart';
import 'package:t_assignment/model/productData_model.dart';
import 'package:t_assignment/screens/add_product_screen.dart';
import 'package:t_assignment/screens/product_info.dart';
import 'package:t_assignment/theme/AppTheme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myTextTheme = Theme.of(context).textTheme;
    final myColorTheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 18.0,
        actionsPadding: const EdgeInsets.only(right: 18.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product Explorer", style: myTextTheme.headlineMedium),
            Text("Discover amazing products", style: myTextTheme.headlineSmall),
          ],
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductScreen()),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppTheme.primaryBlue,
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
          // IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 30)),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<ProductCubit>().fetchProducts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                //searchbar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Search Products or Category....",
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                            },
                            icon: Icon(Icons.clear),
                            color: myColorTheme.error,
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                //FutureBuilder for product
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    //checking connection state
                    if (state is ProductLoading) {
                      return SizedBox(
                        height: screenHeight * 0.6,
                        child: Center(child: _buildLoader(myTextTheme)),
                      );
                    }

                    //checking if snapshot has any error
                    if (state is ProductError) {
                      return SizedBox(
                        height: screenHeight * 0.6,

                        child: Center(
                          child: _buildHasError(myTextTheme, myColorTheme),
                        ),
                      );
                    }

                    //checking if snapshot has not any data
                    if (state is ProductLoaded) {
                      if (state.products.isEmpty) {
                        return SizedBox(
                          height: screenHeight * 0.6,

                          child: Center(
                            child: _buildEmpty(myTextTheme, myColorTheme),
                          ),
                        );
                      }

                      final List<ProductdataModel> allProducts = state.products;

                      final products = _searchQuery.isEmpty
                          ? allProducts
                          : allProducts.where((product) {
                              return product.name.toLowerCase().contains(
                                    _searchQuery,
                                  ) ||
                                  product.category.toLowerCase().contains(
                                    _searchQuery,
                                  );
                            }).toList();

                      //checking if no product found for search query
                      if (products.isEmpty && _searchQuery.isNotEmpty) {
                        return SizedBox(
                          height: screenHeight * 0.6,

                          child: Center(
                            child: _buildNoSearchResults(
                              myTextTheme,
                              myColorTheme,
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${products.length} Products",
                            style: TextStyle(
                              color: myColorTheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 10),

                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final ProductdataModel productIndex =
                                  products[index];

                              return _buildProductCard(
                                context,
                                productIndex,
                                myTextTheme,
                                myColorTheme,
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoader(TextTheme myTextTheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text("Loading Products.....", style: myTextTheme.headlineSmall),
      ],
    );
  }

  Widget _buildHasError(TextTheme myTextTheme, ColorScheme myColorTheme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 72, color: myColorTheme.error),
          const SizedBox(height: 16),
          Text(
            "Failed to load products",
            style: myTextTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 9),
          Text(
            "Something went wrong while fetching the products.",
            style: TextStyle(fontSize: 14, color: AppTheme.errorRed),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: context.read<ProductCubit>().fetchProducts,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(TextTheme myTextTheme, ColorScheme myColorTheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.inventory_2_outlined, color: myColorTheme.primary, size: 72),
        const SizedBox(height: 16),
        Text(
          "No Products Found.\nThe product data source is empty.",
          style: myTextTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 9),
        Text(
          "Add your product data!",
          style: myTextTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        FilledButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductScreen()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Product"),
        ),
      ],
    );
  }

  Widget _buildNoSearchResults(
    TextTheme myTextTheme,
    ColorScheme myColorTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: myColorTheme.primary),
          const SizedBox(height: 16),
          Text(
            "No Products Found",
            style: myTextTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Try searching with a different name or category.",
            style: myTextTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductdataModel productIndex,
    TextTheme myTextTheme,
    ColorScheme myColorTheme,
  ) {
    return GestureDetector(
      onDoubleTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductInfoScreen(productObj: productIndex),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: myColorTheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: myColorTheme.onSurfaceVariant.withAlpha(80),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 3 / 3,
                    child: Image.network(
                      productIndex.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          color: myColorTheme.surfaceContainerHighest,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey.shade500,
                                size: 36,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Image unavailable",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(127),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      productIndex.category,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(127),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      spacing: 1.5,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Text(
                          "${productIndex.rating}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 9),
            Text(productIndex.name, style: myTextTheme.titleLarge),
            SizedBox(height: 3),

            Text(
              productIndex.description,
              style: myTextTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 9),

            Divider(color: myColorTheme.secondary),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  "₹ ${productIndex.price}",
                  style: TextStyle(
                    color: AppTheme.textGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app_outlined,
                      size: 15,
                      color: myColorTheme.secondary,
                    ),
                    Text(
                      "Double tap to see Info",
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.borderGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
