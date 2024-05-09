import 'package:draw_and_guess_promax/model/play_mode.dart';

final availabePlayMode = [
  PlayMode(
    mode: 'Thường',
    description: 'Chế độ cơ bản nhất, vẽ và đoán từ.',
    howToPlay:
        'Mỗi lượt sẽ có một người vẽ, và các người chơi còn lại phải đoán chính xác từ đó.\n\nNgười vẽ không được phép sử dụng các chữ cái, số hoặc hình ảnh thực tế trong bức tranh của mình.\n\nNgười vẽ chỉ được phép sử dụng các công cụ vẽ được cung cấp trong ứng dụng.\n\nNgười nào đoán đúng nhiều nhất và được nhiều người đoán đúng nhất bức tranh mình vẽ nhiều nhất thì được điểm càng cao.',
  ),
  PlayMode(
    mode: 'Tam sao thất bản',
    description:
        'Nghệ thuật biến một câu chuyện đơn giản thành... một vở kịch dài tập.',
    howToPlay:
        'Mỗi người sẽ đưa ra một từ hoặc một câu để người khác vẽ.\n\nNgười đầu tiên sẽ phải vẽ hình dựa trên từ đó và những người chơi sau sẽ phải nhìn hình của người trước và vẽ lại.\n\nNgười vẽ chỉ được phép sử dụng các công cụ vẽ được cung cấp trong ứng dụng.\n\nVà mỗi người sẽ được đoán 1 lần nhé! Càng đông càng vui nha!!!',
  ),
  PlayMode(
    mode: 'Tuyệt tác',
    description: 'Chọn 1 từ và biến nó thành tác phẩm nghệ thuật đỉnh cao.',
    howToPlay:
        'Mỗi người sẽ đưa ra một từ hoặc một câu để người khác vẽ.\n\nMỗi người chơi sẽ vẽ hình dựa trên từ của người khác và số lần vẽ tương ứng với số người chơi có trong phòng.\n\nNgười vẽ chỉ được phép sử dụng các công cụ vẽ được cung cấp trong ứng dụng.\n\nTranh của bạn sẽ được các người chơi còn lại chấm và bạn cũng chấm các bức tranh còn lại sau khi kết thúc mỗi vòng!\n\nVẽ càng đẹp thì càng điểm cao thôi!',
  ),
];
