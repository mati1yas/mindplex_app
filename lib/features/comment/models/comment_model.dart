import 'package:get/get.dart';

class Comment {
  String? commentID;
  String? commentPostID;
  String? commentAuthor;
  String? commentAuthorEmail;
  String? commentDate;
  String? commentDateGmt;
  String? commentContent;
  String? commentApproved;
  String? commentParent;
  String? userId;
  String? commenterUsername;
  String? displayName;
  String? authorAvatarUrls;
  int? replyCount;
  RxList<Comment>? replies = <Comment>[].obs;

  Comment(
      {this.commentID,
      this.commentPostID,
      this.commentAuthor,
      this.commentAuthorEmail,
      this.commentDate,
      this.commentDateGmt,
      this.commentContent,
      this.commentApproved,
      this.commentParent,
      this.userId,
      this.commenterUsername,
      this.displayName,
      this.authorAvatarUrls,
      this.replyCount});

  Comment.fromJson(Map<String, dynamic> json) {
    commentID = json['comment_ID'];
    commentPostID = json['comment_post_ID'];
    commentAuthor = json['comment_author'];
    commentAuthorEmail = json['comment_author_email'];
    commentDate = json['comment_date'];
    commentDateGmt = json['comment_date_gmt'];
    commentContent = json['comment_content'];
    commentApproved = json['comment_approved'];
    commentParent = json['comment_parent'];
    userId = json['user_id'];
    commenterUsername = json['commenter_username'];
    displayName = json['display_name'];
    authorAvatarUrls = json['author_avatar_urls'];
    replyCount = json['child_comments_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_ID'] = this.commentID;
    data['comment_post_ID'] = this.commentPostID;
    data['comment_author'] = this.commentAuthor;
    data['comment_author_email'] = this.commentAuthorEmail;
    data['comment_date'] = this.commentDate;
    data['comment_date_gmt'] = this.commentDateGmt;
    data['comment_content'] = this.commentContent;
    data['comment_approved'] = this.commentApproved;
    data['comment_parent'] = this.commentParent;
    data['user_id'] = this.userId;
    data['commenter_username'] = this.commenterUsername;
    data['display_name'] = this.displayName;
    data['author_avatar_urls'] = this.authorAvatarUrls;
    data['child_comments_count'] = this.replyCount;
    return data;
  }
}
