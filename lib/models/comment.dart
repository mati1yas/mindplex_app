// ignore_for_file: public_member_api_docs, sort_constructors_first

//-----Comment model-----------------//
class Comment {
  late final int id;
  late final String post_slug;
  late final String date;
  late final String authorId;
  late final String authorName;
  late final String imageUrl;
  late final int
      parent; // if 0, it is a main comment. otherwise, it is a reply for this comment
  late final int
      numOfReplies; // the number of replies to this comment. 0 if this is a reply itself.
  late String content;
  late bool
      isUserLiked; // whether or not the currently logged in user has liked this comment
  List<Comment>? replies;

  Comment({
    required this.id,
    required this.post_slug,
    required this.date,
    required this.authorId,
    required this.authorName,
    required this.imageUrl,
    required this.parent,
    required this.numOfReplies,
    required this.content,
    required this.isUserLiked,
  });

// Comment copyWith({
//   String? date,
//   String? firstName,
//   Bool? like,
//   Bool? disLike,
//   String? isReply,
//   String? message,
// }) {
//   return Comment(
//     date: date ?? this.date,
//     firstName: firstName ?? this.firstName,
//     like: like ?? this.like,
//     disLike: disLike ?? this.disLike,
//     isReply: isReply ?? this.isReply,
//     message: message ?? this.message,
//   );
// }

// Map<String, dynamic> toMap() {
//   return <String, dynamic>{
//     'date': date.toMap(),
//     'firstName': firstName.toMap(),
//     'like': like.toMap(),
//     'disLike': disLike.toMap(),
//     'isReply': isReply.toMap(),
//     'message': message.toMap(),
//   };
// }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: int.parse(map['comment_ID']),
      post_slug: map['post_slug'],
      date: map['comment_date'],
      authorId: map['user_id'],
      authorName: map['comment_author'],
      parent: int.parse(map['comment_parent']),
      numOfReplies: map['child_comments_count'],
      content: map['comment_content'],
      imageUrl: map['author_avatar_urls'],
      isUserLiked: map['is_user_liked'] == 1,
    );
  }

//   String toJson() => json.encode(toMap());

//   factory comment.fromJson(String source) => comment.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'comment(date: $date, firstName: $firstName, like: $like, disLike: $disLike, isReply: $isReply, message: $message)';
//   }

//   @override
//   bool operator ==(covariant comment other) {
//     if (identical(this, other)) return true;

//     return
//       other.date == date &&
//       other.firstName == firstName &&
//       other.like == like &&
//       other.disLike == disLike &&
//       other.isReply == isReply &&
//       other.message == message;
//   }

//   @override
//   int get hashCode {
//     return date.hashCode ^
//       firstName.hashCode ^
//       like.hashCode ^
//       disLike.hashCode ^
//       isReply.hashCode ^
//       message.hashCode;
//   }
// }
}

// var comment1 = comm{
//   date: '',
//   'firstName': "Naol",
//   'islike': true,
//   'dislike': false,
//   'isReply': true,
//   'msg': "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis bibendum, odio semper placerat efficitur, augue nibh dictum lectus, at ultricies justo dolor non orci.",
// };