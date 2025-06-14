import 'package:bookstore_app/core/theme/app_theme.dart';
import 'package:bookstore_app/modules/products/bloc/product_bloc.dart';
import 'package:bookstore_app/modules/products/controller/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProductDetailController(context: context);
    _controller.fetchProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductStateError) {
            return Center(
              child: Text(
                'Failed to load product.',
                style: textTheme.bodyLarge,
              ),
            );
          }

          if (state is ProductStateSingleLoaded) {
            final product = state.product;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover Image
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.lightMistGrey,
                      image: DecorationImage(
                        image: NetworkImage(product.coverUrl ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title & Author
                  Text(product.title, style: textTheme.displayLarge),
                  const SizedBox(height: 4),
                  Text('by ${product.author}', style: textTheme.bodyMedium),

                  const SizedBox(height: 12),

                  // Price and Format Tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${product.price}',
                        style: textTheme.titleLarge?.copyWith(
                          color: AppTheme.deepTeal,
                        ),
                      ),
                      Chip(
                        label: Text(product.productType),
                        backgroundColor: AppTheme.lightMistGrey,
                        labelStyle: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.inkBlack,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text('Description', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    product.description ?? 'No description',
                    style: textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _controller.addToCart(product.id),
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // OutlinedButton(
                      //   onPressed: () => _controller.toggleWishList(product.id, product.isWished),
                      //   child: Icon(product.isWished ? Icons.favorite : Icons.favorite_border),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Ratings & Reviews
                  // Text('Reviews', style: textTheme.titleMedium),
                  // const SizedBox(height: 12),
                  // for (final review in product.reviews)
                  //   _buildReviewCard(
                  //     context,
                  //     reviewer: review.userName,
                  //     comment: review.comment,
                  //     rating: review.rating,
                  //   ),
                ],
              ),
            );
          }

          return const SizedBox.shrink(); // fallback
        },
      ),
    );
  }
}
