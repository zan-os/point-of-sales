import 'package:dependencies/equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CubitState extends Equatable {}

class LoadingState extends CubitState {
  final String message;

  LoadingState({this.message = ''});
  @override
  List<Object?> get props => [message];
}

class CompleteState<Type> extends CubitState {
  final Type data;

  CompleteState(this.data);

  @override
  List<Object?> get props => [data];
}

class ErrorState extends CubitState {
  final String message;

  ErrorState({this.message = ''});
  @override
  List<Object?> get props => [message];
}

class EmptyState extends CubitState {
  final String message;

  EmptyState({this.message = ''});
  @override
  List<Object?> get props => [message];
}
