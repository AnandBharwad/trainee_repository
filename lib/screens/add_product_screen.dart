import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_assignment/cubit/product/product_cubit.dart';
import 'package:t_assignment/cubit/product/product_state.dart';
import 'package:t_assignment/model/productData_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _productDescription = TextEditingController();
  final TextEditingController _productImageUrl = TextEditingController();
  final TextEditingController _productRating = TextEditingController();
  final TextEditingController _productCategory = TextEditingController();

  void _clearFields() {
    _productName.clear();
    _productPrice.clear();
    _productDescription.clear();
    _productImageUrl.clear();
    _productRating.clear();
    _productCategory.clear();
  }

  @override
  void dispose() {
    _productName.dispose();
    _productPrice.dispose();
    _productDescription.dispose();
    _productImageUrl.dispose();
    _productRating.dispose();
    _productCategory.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myColorTheme = Theme.of(context).colorScheme;

    final myTextTheme = Theme.of(context).textTheme;

    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        //1. listen for success
        if (state is ProductActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage),
              backgroundColor: myColorTheme.surfaceBright,
            ),
          );
          _clearFields();
        }

        //2.Listen for errors
        if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error : ${state.message}"),
              backgroundColor: myColorTheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isAdding = state is ProductLoading;

        return Scaffold(
          backgroundColor: myColorTheme.surface,

          appBar: AppBar(
            title: Text("Add Product Data", style: myTextTheme.headlineMedium),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Product Name
                  TextFormField(
                    controller: _productName,
                    decoration: InputDecoration(
                      labelText: "Product Name",
                      hintText: "Enter Product Name",
                      icon: Icon(Icons.shopping_basket_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter product name";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Product Price
                  TextFormField(
                    controller: _productPrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Price",
                      hintText: "Enter Product Price",
                      icon: Icon(Icons.currency_rupee),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter product price";
                      }

                      if (num.tryParse(value) == null) {
                        return "Enter a valid price";
                      }

                      if (num.tryParse(value)! <= 0) {
                        return "Product price should be greater than 0";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Product Description
                  TextFormField(
                    controller: _productDescription,
                    maxLines: 3,
                    maxLength: 250,
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Enter Product Description",
                      icon: Icon(Icons.description_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter description";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Product Image URL
                  TextFormField(
                    controller: _productImageUrl,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: "Image URL",
                      hintText: "Enter Product Image URL",
                      icon: Icon(Icons.link),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter image URL";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Product Rating
                  TextFormField(
                    controller: _productRating,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: "Rating",
                      hintText: "Enter Product Rating",
                      icon: Icon(Icons.star_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter rating";
                      }

                      if (num.tryParse(value) == null) {
                        return "Enter a valid rating";
                      }

                      if (num.tryParse(value)! < 0 ||
                          num.tryParse(value)! > 5) {
                        return "Rating must be in 0 to 5 range";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Product Category
                  TextFormField(
                    controller: _productCategory,
                    decoration: InputDecoration(
                      labelText: "Category",
                      hintText: "Enter Product Category",
                      icon: Icon(Icons.category_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter category";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Add Product Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isAdding
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              // await addProduct();

                              // Create model from input
                              final newProduct = ProductdataModel(
                                name: _productName.text.trim(),
                                price: double.parse(_productPrice.text),
                                description: _productDescription.text.trim(),
                                imageUrl: _productImageUrl.text.trim(),
                                rating: double.parse(_productRating.text),
                                category: _productCategory.text.trim(),
                              );

                              //trigger cubit
                              context.read<ProductCubit>().addProduct(
                                newProduct,
                              );
                            },

                      child: isAdding
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Add Product",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
