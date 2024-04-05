class UserProfileReputation {
  int? user;
  double? mpxr;
  double? voteRepAvailabe;
  String? publicAddress;
  double? sharedRep;
  List<Categories>? categories;
  double? userReadTime;

  UserProfileReputation(
      {this.user,
      this.mpxr,
      this.voteRepAvailabe,
      this.publicAddress,
      this.sharedRep,
      this.categories,
      this.userReadTime});

  UserProfileReputation.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    mpxr = json['mpxr'].toDouble();
    voteRepAvailabe = json['vote_rep_availabe'].toDouble();
    publicAddress = json['public_address'];
    sharedRep = json['shared_rep'].toDouble();
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    userReadTime = json['user_read_time'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['mpxr'] = this.mpxr;
    data['vote_rep_availabe'] = this.voteRepAvailabe;
    data['public_address'] = this.publicAddress;
    data['shared_rep'] = this.sharedRep;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['user_read_time'] = this.userReadTime;
    return data;
  }
}

class Categories {
  String? category;
  double? rep;

  Categories({this.category, this.rep});

  Categories.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    rep = json['rep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['rep'] = this.rep;
    return data;
  }
}
