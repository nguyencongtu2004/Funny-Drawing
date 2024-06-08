import 'dart:math';

String pickRandomWordToGuess() {
  return wordToGuess[Random().nextInt(wordToGuess.length)];
}

final allWords = [
  {
    'Table': ['Bàn', 'Cái bàn']
  },
  {
    'Chair': ['Ghế', 'Cái ghế']
  },
  {
    'Computer': ['Máy tính']
  },
  {
    'Phone': ['Điện thoại', 'Cái điện thoại', 'iPhone']
  },
  {
    'Book': ['Sách', 'Cuốn sách']
  },
  {
    'Pen': ['Bút', 'Cây bút', 'Cây bút bi', 'Bút bi', 'Bút mực', 'Cái Bút']
  },
  {
    'Pencil': [
      'Bút chì',
      'Cây bút chì',
    ]
  },
  {
    'Eraser': ['Cục tẩy', 'Cục gôm', 'Cục tẩy chì', 'Cục tẩy bút']
  },
  {
    'Ruler': ['Thước kẻ', 'Thước', 'Cái Thước', 'Cây Thước']
  },
  {
    'Lamp': ['Đèn', 'Cái đèn']
  },
  {
    'Clock': ['Đồng hồ', 'Cái đồng hồ']
  },
  {
    'Television': ['Tivi', 'TV', 'Cái tivi']
  },
  {
    'Refrigerator': ['Tủ lạnh', 'Cái tủ lạnh']
  },
  {
    'Microwave': ['Lò vi sóng']
  },
  {
    'Oven': ['Lò', 'Lò nướng', 'Cái lò']
  },
  {
    'Washing machine': ['Máy giặt', 'Cái máy giặt']
  },
  {
    'Dishwasher': [
      'Máy rửa chén',
      'Cái máy rửa chén',
      'Máy rửa bát',
      'Cái máy rửa bát'
          'Hương',
      'Hay',
    ]
  },
  {
    'Bed': ['Giường', 'Cái giường', 'Giường ngủ', 'Chiếc Giường']
  },
  {
    'Sofa': ['Ghế sofa', 'Sofa']
  },
  {
    'Painting': ['Bức tranh', 'Tranh', 'Bức tranh vẽ', 'Tranh vẽ']
  },
  {
    'Mirror': ['Gương', 'Cái gương']
  },
  {
    'Shower': ['Vòi sen', 'Sen', 'Tắm', 'Cái vòi sen']
  },
  {
    'Toilet': ['Toilet', 'Cái toilet', 'Nhà vệ sinh', 'Bồn cầu']
  },
  {
    'Bathtub': ['Bồn tắm', 'Cái bồn tắm']
  },
  {
    'Sink': ['Bồn rửa', 'Bồn rửa mặt']
  },
  {
    'Towel': ['Khăn', 'Khăn tắm', 'Khăn lau']
  },
  {
    'Shampoo': ['Dầu gội', 'Dầu gội đầu']
  },
  {
    'Soap': ['Xà phòng', 'Cục xà phòng', 'Xà bông', 'Cục xà bông']
  },
  {
    'Toothbrush': ['Bàn chải', 'Bàn chải đánh răng']
  },
  {
    'Toothpaste': ['Kem đánh răng']
  },
  {
    'Fork': ['Nĩa', 'Cái nĩa']
  },
  {
    'Spoon': ['Thìa', 'Cái thìa']
  },
  {
    'Knife': ['Dao', 'Con dao']
  },
  {
    'Plate': ['Đĩa', 'Cái đĩa']
  },
  {
    'Bowl': ['Cái tô', 'Tô', 'Chén', 'Cái chén', 'Cái bát', 'Bát']
  },
  {
    'Cup': ['Cốc', 'Cái cốc']
  },
  {
    'Glass': ['Cái ly', 'Ly']
  },
  {
    'Mug': ['Cốc', 'Cái cốc']
  },
  {
    'Pot': ['Nồi', 'Cái nồi', 'Chậu hoa', 'Chậu cây']
  },
  {
    'Pan': ['Chảo', 'Cái chảo']
  },
  {
    'Bottle': ['Chai', 'Cái chai']
  },
  {
    'Can': ['Lon', 'Cái lon']
  },
  {
    'Jar': ['Lọ', 'Cái lọ']
  },
  {
    'Bag': ['Túi', 'Cái túi', 'Ba lô']
  },
  {
    'Box': ['Hộp', 'Cái hộp', 'Chiếc hộp']
  },
  {
    'Basket': ['Giỏ', 'Cái giỏ']
  },
  {
    'Eyes': ['Mắt', 'Con mắt', 'Đôi mắt']
  },
  {
    'Ear': ['Tai', 'Cái tai']
  },
  {
    'Mouth': ['Miệng', 'Cái miệng', 'Mồm', 'Cái mồm']
  },
  {
    'Nose': ['Mũi', 'Cái mũi']
  },
  {
    'Hand': [
      'Tay',
      'Bàn tay',
    ]
  },
  {
    'Foot': ['Bàn chân']
  },
  {
    'Leg': ['Chân', 'CáiChân']
  },
  {
    'Arm': ['Cánh tay', 'Tay', 'Cái tay']
  },
  {
    'Head': ['Đầu', 'Cái đầu']
  },
  {
    'Hair': ['Tóc']
  },
  {
    'Face': ['Mặt', 'Cái mặt']
  },
  {
    'Pizza': ['Bánh pizza', 'Pizza']
  },
  {
    'Angry': ['Tức giận', 'Tức']
  },
  {
    'Fireworks': ['Pháo hoa', 'Pháo', 'Pháo bông']
  },
  {
    'Pumpkin': ['Bí ngô', 'Quả bí ngô']
  },
  {
    'Baby': ['Em bé', 'Bé', 'Đứa trẻ']
  },
  {
    'Flower': ['Hoa', 'Bông hoa']
  },
  {
    'Rainbow': ['Cầu vồng', 'Cầu vòng']
  },
  {
    'Recycle': ['Tái chế', 'Tái sử dụng']
  },
  {
    'Giraffe': ['Hươu cao cổ', 'Hươu']
  },
  {
    'Sand castle': ['Lâu đài cát']
  },
  {
    'Bikini': ['Bikini', 'Bộ bikini']
  },
  {
    'Glasses': ['Kính', 'Kính mắt', 'Mắt kính']
  },
  {
    'High heel': ['Giày cao gót', 'Giày gót cao']
  },
  {
    'Ice cream': ['Cây kem', 'Kem']
  },
  {
    'Starfish': [
      'Sao biển',
    ]
  },
  {
    'Bee': ['Ong', 'Con ong']
  },
  {
    'Strawberry': ['Dâu', 'Dâu tây', 'Quả dâu', 'Quả dâu tây']
  },
  {
    'Butterfly': ['Bướm', 'Con bướm']
  },
  {
    'Ladybug': ['Bọ rùa', 'Bọ rùa đỏ']
  },
  {
    'Sun': ['Mặt trời']
  },
  {
    'Camera': ['Máy ảnh', 'Máy chụp ảnh']
  },
  {
    'Lion': ['Sư tử', 'Con sư tử']
  },
  {
    'Coffee': ['Cà phê', 'Ly cà phê', 'Cốc cà phê']
  },
  {
    'Nail': ['Móng', 'Móng tay']
  },
  {
    'Crayon': ['Bút màu', 'Bút chì màu']
  },
  {
    'Night': ['Đêm', 'Đêm tối', 'Buổi tối', 'Ban đêm']
  },
  {
    'Penguin': ['Chim cánh cụt', 'Con chim cánh cụt']
  },
  {
    'Dog': ['Con chó', 'Chó']
  },
  {
    'Nose': ['Mũi', 'Cái mũi']
  },
  {
    'Dolphin': ['Cá heo', 'Con cá heo']
  },
  {
    'Olympics': ['Olympic', 'Thế vận hội']
  },
  {
    'Oreo': ['Bánh Oreo']
  },
  {
    'Vase': ['Bình hoa', 'Bình']
  },
  {
    'Egg': ['Quả trứng', 'Trứng']
  },
  {
    'Wheel': ['Bánh xe', 'Bánh', 'Cái bánh xe']
  },
  {
    'Kiss': ['Hôn', 'Hôn nhau', 'Nụ hôn']
  },
  {
    'Brain': ['Não', 'Bộ não']
  },
  {
    'Kitten': ['Mèo con', 'Mèo nhỏ', 'Con mèo con']
  },
  {
    'Playground': ['Sân chơi', 'Sân chơi trẻ em']
  },
  {
    'Buckle': ['Khóa', 'Khóa cài']
  },
  {
    'Lipstick': ['Son môi', 'Son']
  },
  {
    'Bus': ['Xe buýt', 'Xe bus']
  },
  {
    'Lobster': ['Tôm hùm', 'Con tôm hùm']
  },
  {
    'Robot': ['Robot', 'Con Robot']
  },
  {
    'Car accident': ['Tai nạn xe hơi', 'Tai nạn']
  },
  {
    'Lollipop': ['Kẹo mút', 'Kẹo']
  },
  {
    'Salamander': ['Thằn lằn', 'Thằn']
  },
  {
    'Castle': [
      'Lâu đài',
    ]
  },
  {
    'Magnet': ['Nam châm']
  },
  {
    'Chainsaw': ['Cưa', 'Cưa gỗ', 'Cái cưa']
  },
  {
    'Megaphone': ['Loa', 'Loa phóng thanh']
  },
  {
    'Snowball': ['Quả cầu tuyết', 'Cầu tuyết']
  },
  {
    'Circus tent': ['Lều xiếc', 'Lều', 'Cái lều', 'Rạp', 'Rạp xiếc']
  },
  {
    'Mermaid': ['Nàng tiên cá', 'Tiên cá']
  },
  {
    'Sprinkler': ['Máy tưới', 'Máy tưới nước']
  },
  {
    'Crib': ['Nôi', 'Nôi trẻ em']
  },
  {
    'Tadpole': ['Ếch con', 'Ếch']
  },
  {
    'Dragon': ['Rồng', 'Con rồng']
  },
  {
    'Music': ['Âm nhạc', 'Nhạc']
  },
  {
    'Dumbbell': ['Tạ', 'Tạ tập thể dục', 'Quả tạ']
  },
  {
    'North Pole': ['Cực Bắc', 'Cực']
  },
  {
    'Telescope': ['Kính thiên văn']
  },
  {
    'Eel': ['Lươn', 'Con lươn']
  },
  {
    'Nurse': ['Y tá', 'Y']
  },
  {
    'Tomato': ['Cà chua', 'Quả cà chua']
  },
  {
    'Elephant': ['Voi', 'Con voi']
  },
  {
    'Onion': ['Hành tây', 'Củ hành tây']
  },
  {
    'Train': ['Tàu hỏa', 'Tàu', 'Con tàu']
  },
  {
    'Ferris wheel': ['Đu quay', 'Vòng quay', 'Vòng quay lớn']
  },
  {
    'Owl': ['Con cú', 'Cú']
  },
  {
    'Tricycle': ['Xe ba bánh', 'Xe']
  },
  {
    'Flag': ['Cờ', 'Cờ quốc kỳ', 'Lá cờ']
  },
  {
    'Golf': ['Gôn']
  },
  {
    'Penny': ['Đồng xu']
  },
  {
    'Umbrella': [
      'Ô',
      'Ô che mưa',
      'Dù',
      'Cái dù',
      'Cái ô',
      'Chiếc dù',
      'Chiếc ô'
    ]
  },
  {
    'Piano': ['Đàn piano', 'Đàn dương cầm']
  },
  {
    'Walrus': ['Hải mã']
  },
  {
    'Eclipse': ['Nhật thực']
  },
  {
    'Chandelier': ['Đèn chùm', 'Đèn']
  },
  {
    'Ketchup': ['Sốt cà chua', 'Sốt']
  },
  {
    'Bunk bed': ['Giường tầng', 'Giường']
  },
  {
    'Beehive': ['Tổ ong']
  },
  {
    'Lemon': ['Quả chanh vàng', 'Chanh vàng']
  },
  {
    'Lime': ['Quả chanh xanh', 'Chanh xanh']
  },
  {
    'Pineapple': ['Dứa', 'Quả dứa']
  },
  {
    'Wreath': ['Vòng hoa']
  },
  {
    'Waffles': ['Bánh quế']
  },
  {
    'Bubble': ['Bong bóng', 'Quả bóng']
  },
  {
    'Bouquet': ['Bó hoa', 'Bó']
  },
  {
    'Headphones': ['Tai nghe']
  },
  {
    'Banana peel': ['Vỏ chuối']
  },
  {
    'Summer': ['Mùa hè']
  },
  {
    'Cupcake': ['Bánh cupcake']
  },
  {
    'Sleeping bag': ['Túi ngủ']
  },
  {
    'Fog': ['Sương mù']
  },
  {
    'Battery': ['Pin', 'Pin điện']
  },
  {
    'Cow': ['Con bò']
  },
  {
    'Jellyfish': ['Sứa', 'Sứa biển', 'Con sứa']
  },
  {
    'Pig': ['Con lợn', 'Con heo', 'Lợn', 'Heo']
  },
  {
    'Candle': ['Nến', 'Cây nến', 'Cái nến']
  },
  {
    'Kite': ['Con diều', 'Diều']
  },
];

final wordToGuess = allWords.map((word) => word.values.first.first).toList();
