import 'package:flutter/material.dart';
import 'package:t_assignment/model/productData_model.dart';

class ProductInfoScreen extends StatefulWidget {
  final ProductdataModel productObj;
  ProductInfoScreen({super.key, required this.productObj});

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final myTextTheme = Theme.of(context).textTheme;
    final myColorTheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: myColorTheme.surface,
      appBar: AppBar(
        title: Text("Product Info", style: myTextTheme.headlineMedium),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: myColorTheme.surface),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 3 / 3,
                  child: Image.network(
                    widget.productObj.imageUrl,
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
              const SizedBox(height: 16),

              Text(widget.productObj.name, style: myTextTheme.headlineMedium),
              const SizedBox(height: 9),
              Text(
                "₹ ${widget.productObj.price}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: myColorTheme.surfaceBright,
                ),
              ),
              const SizedBox(height: 9),

              Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                decoration: BoxDecoration(
                  color: myColorTheme.primary.withAlpha(50),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.productObj.category,
                  style: TextStyle(color: myColorTheme.primary),
                ),
              ),
              const SizedBox(height: 9),
              Text("Description", style: myTextTheme.headlineMedium),
              Text(
                widget.productObj.description,
                style: myTextTheme.headlineSmall,
              ),

              const SizedBox(height: 9),

              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(127),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  spacing: 1.5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      "${widget.productObj.rating}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
