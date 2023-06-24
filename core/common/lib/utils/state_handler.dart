import 'dart:developer';

import 'package:flutter/material.dart';
import '../common.dart';

class StateHandler<T extends StateStreamable<CubitState>>
    extends StatelessWidget {
  final T stateStreamable;
  final Function? onLoading, onComplete, onError;
  final Widget onCompleteBuilder;

  const StateHandler({
    super.key,
    required this.stateStreamable,
    this.onLoading,
    this.onComplete,
    this.onError,
    required this.onCompleteBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<T, CubitState>(
      listener: listenerStateHandler,
      builder: builderStateHandler,
    );
  }

  Widget builderStateHandler(context, state) {
    if (state is LoadingState) {
      log('ojan state ==> $state');
      log('loading bro');
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is ErrorState) {
      log('ojan state ==> $state');
      log('error bro');
      return Center(
        child: Text(state.message),
      );
    }

    if (state is CompleteState) {
      log('ojan state ==> $state');
      log('success bro');
      return onCompleteBuilder;
    }

    if (state is EmptyState) {
      log('ojan state ==> $state');
      log('empty bro');
      return Center(
        child: Text(state.message),
      );
    }

    return const Center(
      child: Text('Error outside of State'),
    );
  }

  void listenerStateHandler(context, state) {
    if (state is LoadingState) {
      if (onLoading != null) {
        onLoading!();
      }
    }

    if (state is ErrorState) {
      if (onError != null) {
        onError!();
      }
    }

    if (state is CompleteState) {
      if (onComplete != null) {
        onComplete!();
      }
    }
  }
}
