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

  factory Room.fromRTDB(Map<String, dynamic> data) {
    return Room(
        roomId: data['roomId'],
        password: data['password'],
        isPrivate: data['isPrivate'],
        maxPlayer: data['maxPlayer'],
        curPlayer: data['curPlayer'],
        mode: data['mode']);
  }
}


