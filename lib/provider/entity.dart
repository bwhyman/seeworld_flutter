import 'package:seeworld_flutter/components/random_utils.dart';

class News {
  int nid;
  String title;
  String content;
  int? likes;
  int? comments;
  int? favorite;
  String type;
  String publishedTime;

  News(
      {this.nid = 0,
      this.title = '',
      this.content = '',
      this.type = '',
      this.publishedTime = '',
      this.likes = 0,
      this.comments = 0,
      this.favorite = 0});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        nid: json['nid'] ?? 0,
        title: json['title'],
        content: json['content'].toString().replaceAll('\\n', '.'),
        type: json['type'],
        publishedTime: json['publishedTime'],
        likes: RandomUtils.getRandomInt(300),
        comments: 3,
        favorite: RandomUtils.getRandomInt(30));
  }
}

class Book {
  static const table_name = 'book';
  int? id;
  String? name;
  String? inserttime;

  Book({this.id, this.name, this.inserttime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'inserttime': inserttime,
    };
  }
}

class Chapter {
  static const table_name = 'chapter';
  int? id;
  String? title;
  int? bid;
  String? content;
  String? inserttime;

  Chapter({this.id, this.title, this.content, this.inserttime, this.bid});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bid': bid,
      'title': title,
      'content': content,
      'inserttime': inserttime,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
        id: map['id'],
        title: map['title'],
        bid: map['bid'],
        content: map['content'],
        inserttime: map['inserttime']);
  }
}

class NewsComment {
  int? id;
  int? nid;
  String? avatarUrl;
  String? userName;
  String? content;
  String? inserttime;

  NewsComment(
      {this.id, this.nid, this.userName, this.content, this.inserttime, this.avatarUrl});

  static const images = {
    'https://tvax3.sinaimg.cn/crop.0.0.664.664.180/006VHRawly8ged6odlo8yj30ig0ig3zq.jpg?KID=imgbed,tva&Expires=1658439368&ssig=ZBIdvrkj3Q',
    'https://tvax4.sinaimg.cn/crop.0.0.1080.1080.180/005Vg6y8ly8gy237k17v7j30u00u00vf.jpg?KID=imgbed,tva&Expires=1658438413&ssig=9FpAyK%2B%2Fd2',
    'https://tvax4.sinaimg.cn/crop.0.0.511.511.180/007ZifEily8gy3tqb2a0gj30e70e73yr.jpg?KID=imgbed,tva&Expires=1658438263&ssig=mrlZHtYvjr',
    'https://tvax4.sinaimg.cn/crop.38.0.435.435.180/007pQrhIly8h2ss8xjkczj30e80c3wez.jpg?KID=imgbed,tva&Expires=1658438230&ssig=gjt6uLcZJ%2F',
    'https://tvax3.sinaimg.cn/crop.0.0.640.640.180/ac66e9b5ly8gdjcoyfdo4j20hs0hs0ui.jpg?KID=imgbed,tva&Expires=1658438179&ssig=gYQeVngbE5',
  };
}


