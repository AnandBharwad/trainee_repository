import 'package:equatable/equatable.dart';
import 'package:t_assignment/model/productData_model.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

//initial idle state
class ProductInitial extends ProductState {}

//Loading state for fetch operation
class ProductLoading extends ProductState {}

//Successfull fetched products
class ProductLoaded extends ProductState {
  final List<ProductdataModel> products;

  const ProductLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

//Error state
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

//state emitted when an action succeeds.(e.g., products added or deleted)
class ProductActionSuccess extends ProductState {
  final String successMessage;

  const ProductActionSuccess(this.successMessage);

  @override
  List<Object?> get props => [successMessage];
}
