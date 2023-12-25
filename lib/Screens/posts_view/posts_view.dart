import 'package:block_strucuture/CustomWidgets/custom_widgets.dart';
import 'package:block_strucuture/Screens/posts_view/post_bloc/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Common/common_function.dart';
import '../../Repository/auth_repository.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  var postBloc = PostBloc(authRepository: AuthRepository());

  @override
  void initState() {
    postBloc.add(FetchPostsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomWidget.commonText(commonText: "All Posts"),
      ),
      body: BlocListener(
        bloc: postBloc,
        listener: (context, state) {
          if (state is PostLoadingState) {
            print("Listener_State :- ${state.isLoading}");
          } else if (state is PostSuccessState) {
            CommonFunction().showCustomSnackBar(context, state.response);
          } else if (state is PostErrorState) {
            CommonFunction().showCustomSnackBar(context, state.response);
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          bloc: postBloc,
          builder: (context, state) {
            if (state is PostLoadingState && state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostSuccessState) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: postBloc.postsModel!.posts?.length ?? 0,
                      physics: const BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.only(top: 20, right: 10, left: 10),
                      itemBuilder: (context, index) {
                        final posts = postBloc.postsModel!.posts?[index];
                        final id = posts?.id;
                        final title = posts?.title;
                        final body = posts?.body;
                        final userId = posts?.userId;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomWidget.commonText(commonText: "id - $id"),
                              CustomWidget.commonText(
                                  commonText: "userId - $userId"),
                              CustomWidget.commonText(
                                  commonText: "title - $title"),
                              CustomWidget.commonText(
                                  commonText: "body - $body",
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            } else if (state is PostErrorState) {
              return Text('Error: ${state.response}');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
