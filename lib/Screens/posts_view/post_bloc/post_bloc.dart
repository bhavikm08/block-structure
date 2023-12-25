import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:block_strucuture/Bloc/auth_bloc.dart';
import 'package:meta/meta.dart';

import '../../../Repository/auth_repository.dart';
import '../post_model/post_model.dart';

part 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final AuthRepository authRepository;
  PostBloc({required this.authRepository}) : super(PostInitial()) {
    on<PostEvent>((event, emit) async {
      if (event is FetchPostsEvent) {
        await for (var state in fetchPosts()) {
          emit(state);
          print("STATS $state");
        }
      }
    });
  }
  PostsModel? postsModel;

  Stream<PostState> fetchPosts() async* {
    try {
      yield PostLoadingState(true);
      final response = await authRepository.fetchPosts();
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        postsModel = PostsModel.fromJson(responseBody);
        yield PostLoadingState(false);
        print("POSTS_MODEL $postsModel");
        yield PostSuccessState("Success");
      } else if (response.statusCode == 404) {
        yield PostErrorState("Error: Not Found");
        yield PostLoadingState(false);
      } else {
        yield PostErrorState("Error: ${response.statusCode}");
        yield PostLoadingState(false);
      }
    } catch (e) {
      yield PostErrorState("Error: $e");
      yield PostLoadingState(false);
    }
  }

}
