// models.dart
import 'dart:convert';

class ProfileViewersResponse {
  final List<Viewer> data;
  final Links links;
  final Meta meta;
  final bool result;

  ProfileViewersResponse({
    required this.data,
    required this.links,
    required this.meta,
    required this.result,
  });

  factory ProfileViewersResponse.fromJson(Map<String, dynamic> json) {
    return ProfileViewersResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Viewer.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      links: Links.fromJson(json['links'] as Map<String, dynamic>? ?? {}),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
      result: json['result'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((v) => v.toJson()).toList(),
    'links': links.toJson(),
    'meta': meta.toJson(),
    'result': result,
  };

  @override
  String toString() => jsonEncode(toJson());
}

class Viewer {
  final int userId;
  final bool packageUpdateAlert;
  final String photo;
  final String name;
  final int age;
  final String religion;
  final String country;
  final String motherTongue;

  Viewer({
    required this.userId,
    required this.packageUpdateAlert,
    required this.photo,
    required this.name,
    required this.age,
    required this.religion,
    required this.country,
    required this.motherTongue,
  });

  factory Viewer.fromJson(Map<String, dynamic> json) {
    return Viewer(
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      packageUpdateAlert: json['package_update_alert'] as bool? ?? false,
      photo: json['photo'] as String? ?? '',
      name: json['name'] as String? ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      religion: json['religion'] as String? ?? '',
      country: json['country'] as String? ?? '',
      motherTongue: json['mothere_tongue'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'package_update_alert': packageUpdateAlert,
    'photo': photo,
    'name': name,
    'age': age,
    'religion': religion,
    'country': country,
    'mothere_tongue': motherTongue,
  };
}

class Links {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json['first'] as String?,
    last: json['last'] as String?,
    prev: json['prev'] as String?,
    next: json['next'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'first': first,
    'last': last,
    'prev': prev,
    'next': next,
  };
}

class Meta {
  final int currentPage;
  final int from;
  final int lastPage;
  final List<MetaLink> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
    from: (json['from'] as num?)?.toInt() ?? 0,
    lastPage: (json['last_page'] as num?)?.toInt() ?? 0,
    links: (json['links'] as List<dynamic>?)
        ?.map((e) => MetaLink.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
    path: json['path'] as String? ?? '',
    perPage: (json['per_page'] as num?)?.toInt() ?? 0,
    to: (json['to'] as num?)?.toInt() ?? 0,
    total: (json['total'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'from': from,
    'last_page': lastPage,
    'links': links.map((l) => l.toJson()).toList(),
    'path': path,
    'per_page': perPage,
    'to': to,
    'total': total,
  };
}

class MetaLink {
  final String? url;
  final String label;
  final bool active;

  MetaLink({this.url, required this.label, required this.active});

  factory MetaLink.fromJson(Map<String, dynamic> json) => MetaLink(
    url: json['url'] as String?,
    label: json['label'] as String? ?? '',
    active: json['active'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'active': active,
  };
}
