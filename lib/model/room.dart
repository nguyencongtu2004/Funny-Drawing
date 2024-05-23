class Room {
  Room({
    this.roomOwner,
    this.roomId = '',
    this.mode = 'Thường',
    this.curPlayer = 0,
    this.maxPlayer = 5,
    this.isPrivate = false,
    this.password,
  });

  final String? roomOwner;
  final String roomId;
  final String mode;
  final int curPlayer;
  final int maxPlayer;
  final bool isPrivate;
  final String? password;

  factory Room.fromRTDB(Object snapshot) {
    final data = Map<String, dynamic>.from(snapshot as Map<dynamic, dynamic>);

    Room newRoom = Room();

    for (final room in data.entries) {
      newRoom = Room(
        roomId: room.key,
        roomOwner: room.value['roomOwner'],
        mode: room.value['mode'],
        curPlayer: room.value['curPlayer'],
        maxPlayer: room.value['maxPlayer'],
        isPrivate: room.value['isPrivate'],
        password: room.value['password'],
      );
    }

    return newRoom;
  }
}


