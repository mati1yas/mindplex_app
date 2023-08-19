class AppUrls {
  static var baseUrl = "https://staging.mindplex.ai/wp-json";
  static var loginUrl = '$baseUrl/auth/v1/token';
  static var registerationUrl = '$baseUrl/wp/v2/users/register';
  static var blogUrl = '$baseUrl/mp_gl/v1/posts';
  static var commentsFetch = '$baseUrl/wp/v2/comments';
  static var commentCreate = '$baseUrl/wp/v2/comment';
  static var commentDelete = '$baseUrl/wp/v2/comment/delete';
  static var commentUpdate = '$baseUrl/wp/v2/comment/update';
  static var commentLikeDislike = '$baseUrl/wp/v2/comment/like_dislike';
}
