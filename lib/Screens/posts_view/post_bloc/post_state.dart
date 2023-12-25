part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostLoadingState extends PostState {
  bool isLoading = false;
  PostLoadingState(this.isLoading);
}

class PostSuccessState extends PostState{
  final String response;
  PostSuccessState(this.response);
}
class PostErrorState extends PostState{
  final String response;
  PostErrorState(this.response);
}

