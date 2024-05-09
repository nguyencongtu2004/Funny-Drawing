import 'package:draw_and_guess_promax/model/room.dart';

// Thay list này bằng data trên firebase
final availableRoom = [
  Room(
    mode: 'Thường',
    curPlayer: 2,
    maxPlayer: 5,
    isPrivate: true,
    roomId: '111111',
  ),
  Room(
    mode: 'Tam sao thất bản',
    curPlayer: 2,
    maxPlayer: 5,
    isPrivate: false,
    roomId: '222222',
  ),
  Room(
    mode: 'Tuyệt tác',
    curPlayer: 0,
    maxPlayer: 10,
    isPrivate: false,
    roomId: '333333',
  ),
  Room(
    mode: 'Tuyệt tác',
    curPlayer: 0,
    maxPlayer: 10,
    isPrivate: false,
    roomId: '547454',
  ),
  Room(
    mode: 'Tam sao thất bản',
    curPlayer: 2,
    maxPlayer: 5,
    isPrivate: true,
    roomId: '225222',
  ),
  Room(
    mode: 'Thường',
    curPlayer: 2,
    maxPlayer: 5,
    isPrivate: false,
    roomId: '111911',
  ),
];
