import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_assignment/cubit/product/product_cubit.dart';
import 'package:t_assignment/screens/bottom_nav_screen.dart';
import 'package:t_assignment/theme/AppTheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductCubit()..fetchProducts(), //It will start fetching immediately
      child: MaterialApp(
        title: "Product Explorer",

        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: BottomNavScreen(),
      ),
    );
  }
}
