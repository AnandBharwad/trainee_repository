import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_assignment/cubit/product/product_state.dart';
import 'package:t_assignment/model/productData_model.dart';
import 'package:t_assignment/services/api_operation_service.dart';

class ProductCubit extends Cubit<ProductState> {
  final ApiOperationService _apiService;

  ProductCubit({ApiOperationService? apiService})
    : _apiService = apiService ?? ApiOperationService(),
      super(ProductInitial());

  //1. Fetch Products
  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final products = await _apiService.fetchRecords();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  //2. Add Product
  Future<void> addProduct(ProductdataModel product) async {
    emit(ProductLoading());
    try {
      await _apiService.addProduct(product);
      emit(const ProductActionSuccess("Product added successfully"));
      await fetchProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  //3. Seed Database
  Future<void> seedDatabase() async {
    emit(ProductLoading());
    try {
      await _apiService.seedDatabase();
      emit(const ProductActionSuccess("Sample products added successfully"));
      await fetchProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  //4. Wipe Database
  Future<void> deleteAllProducts() async {
    emit(ProductLoading());
    try {
      await _apiService.deleteAllProducts();
      emit(const ProductActionSuccess("All products deleted successfully"));
      emit(const ProductLoaded(products: []));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
