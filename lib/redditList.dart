class redditList {
  String after;
  num numberOfPost;
  var  postList = [];

  redditList() {
    numberOfPost = 0;
  }

  void addPostList(var newPost) {
    postList.addAll(newPost);
    numberOfPost += newPost.length;
  }
}