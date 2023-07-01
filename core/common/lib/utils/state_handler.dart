import 'dart:developer';

import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/material.dart';

class StateHandler<T extends StateStreamable<S>, S extends StateStreamable<S>> extends StatelessWidget {
  final T cubit;
  final S state;
  final Function onLoadingListener, onCompleteListener, onError;
  final Widget defaultBuilder;
  final Widget? onCompleteBuilder;

  const StateHandler({
    super.key,
    required this.cubit,
    required this.onLoadingListener,
    required this.onCompleteListener,
    required this.onError,
    this.onCompleteBuilder,
    required this.defaultBuilder, required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<T, S>(
      listener: listenerStateHandler,
      builder: builderStateHandler,
    );
  }

  Widget builderStateHandler(context, state) {
    if (state == CubitState.loading) {
      log('ojan state ==> $state');
      log('loading bro');
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state == CubitState.error) {
      log('ojan state ==> $state');
      log('error bro');
      return Center(
        child: Text(state.message),
      );
    }

    if (state == CubitState.hasData) {
      log('ojan state ==> $state');
      log('success bro');
      if (onCompleteBuilder != null) {
        return onCompleteBuilder!;
      }
    }

    if (state == CubitState.noData) {
      log('ojan state ==> $state');
      log('empty bro');
      return Center(
        child: Text(state.message),
      );
    }

    return defaultBuilder;
  }

  void listenerStateHandler(context, state) {
    if (state == CubitState.loading) {
      onLoadingListener();
    }

    if (state == CubitState.error) {
      onError();
    }

    if (state == CubitState.hasData) {
      log('ojan data');
      onCompleteListener;
    }
  }
}
