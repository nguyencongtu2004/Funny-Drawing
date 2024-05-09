class Room {
  Room({
    this.roomId = '',
    this.mode = 'Thường',
    this.curPlayer = 0,
    this.maxPlayer = 5,
    this.isPrivate = false,
  });

  final String roomId;
  final String mode;
  final int curPlayer;
  final int maxPlayer;
  final bool isPrivate;
}
