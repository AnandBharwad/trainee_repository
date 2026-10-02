import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_assignment/cubit/product/product_cubit.dart';
import 'package:t_assignment/cubit/product/product_state.dart';
import 'package:t_assignment/theme/AppTheme.dart';

class OperationScreen extends StatefulWidget {
  const OperationScreen({super.key});

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final myTextTheme = Theme.of(context).textTheme;
    final myColorTheme = Theme.of(context).colorScheme;
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductActionSuccess) {
          setState(() {
            _isDeleting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage),
              backgroundColor: myColorTheme.surfaceBright,
            ),
          );
        }

        if (state is ProductError) {
          setState(() {
            _isDeleting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: myColorTheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ProductLoading;
        return Scaffold(
          appBar: AppBar(
            title: Text("Operations", style: myTextTheme.headlineMedium),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: myColorTheme.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: myColorTheme.primary.withAlpha(50),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.settings_suggest_outlined,
                            color: Colors.orange,
                            size: 80,
                          ),
                          Text(
                            "Manage Product Data",
                            style: myTextTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.upload, color: myColorTheme.primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Seed operation adds sample product data.",
                                  style: myTextTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: myColorTheme.error,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Delete operation permanently removes all products.\n(Note: You can perform seed operation again.That will seed 70 products by default.)",
                                  style: myTextTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildButton(
                      label: 'Seed Sample Data',
                      icon: Icons.upload,
                      color: Colors.green,
                      isLoading: isLoading,

                      onPressed: () {
                        setState(() {
                          _isDeleting = false;
                        });
                        context.read<ProductCubit>().seedDatabase();
                      },
                    ),

                    const SizedBox(height: 10),

                    _buildButton(
                      label: 'Delete All Products',
                      icon: Icons.delete_outline,
                      color: Colors.redAccent,
                      isLoading: isLoading,
                      onPressed: () {
                        setState(() {
                          _isDeleting = true;
                        });
                        context.read<ProductCubit>().deleteAllProducts();
                      },
                    ),

                    if (isLoading) ...[
                      const SizedBox(height: 20),
                      _isDeleting
                          ? const LinearProgressIndicator(
                              color: AppTheme.errorRed,
                            )
                          : const LinearProgressIndicator(
                              color: AppTheme.successGreen,
                            ),
                      const SizedBox(height: 20),
                      Text(
                        _isDeleting
                            ? "Deleting Product Data..."
                            : "Uploading Product Data...",
                        style: myTextTheme.headlineSmall,
                      ),
                      const SizedBox(height: 9),
                      Text(
                        "It will take some time.",
                        style: myTextTheme.titleSmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
