class Room {
  Room({
    this.roomId = '',
    this.mode = 'Thường',
    this.curPlayer = 0,
    this.maxPlayer = 5,
    this.isPrivate = false,
    this.password,
  });

  final String roomId;
  final String mode;
  final int curPlayer;
  final int maxPlayer;
  final bool isPrivate;
  final String? password;
}

/*class Mode {
  Mode({
    required this.mode,
    required this.description,
});

  final String mode;
  final String description;
}*/
