import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'reaction.g.dart';

@JsonSerializable()
class Reaction extends Equatable {
  final int id;
  final String emoji;
  final User user;
  final DateTime createdAt;

  const Reaction({
    required this.id,
    required this.emoji,
    required this.user,
    required this.createdAt,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) => _$ReactionFromJson(json);
  Map<String, dynamic> toJson() => _$ReactionToJson(this);

  Reaction copyWith({
    int? id,
    String? emoji,
    User? user,
    DateTime? createdAt,
  }) {
    return Reaction(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, emoji, user, createdAt];
}
