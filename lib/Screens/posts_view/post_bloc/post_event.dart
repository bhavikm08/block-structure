part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class FetchPostsEvent extends PostEvent {}

class AddPostModelEvent extends PostEvent {
  final PostsModel postsModel;
  AddPostModelEvent(this.postsModel);
}
