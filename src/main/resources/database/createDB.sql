-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 29, 2026 lúc 03:30 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `web_ban_sach` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `web_ban_sach`;

--
-- Cơ sở dữ liệu: `web_ban_sach`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSelectPublicKey` (IN `user_id` INT, IN `cart_id` INT)   BEGIN
    -- Check if there is a record with a non-null expire date that satisfies the conditions
    IF EXISTS (SELECT 1 FROM carts
                                 JOIN public_key ON carts.idUser = public_key.id_user
               WHERE carts.id = cart_id
                 AND carts.idUser = user_id
                 AND public_key.expire IS NOT NULL
                 AND carts.create_time <= public_key.expire) THEN

        SELECT pk.public_Key
        FROM customer c
                 JOIN public_key pk ON c.id_user = pk.id_user
                 JOIN carts ct ON c.id_user = ct.idUser
        WHERE ct.id = cart_id
          AND ct.idUser = user_id
          AND ct.create_time > pk.create_date
          AND ct.create_time <= pk.expire;
    ELSE
        SELECT pk.public_Key
        FROM customer c
                 JOIN public_key pk ON c.id_user = pk.id_user
                 JOIN carts ct ON c.id_user = ct.idUser
        WHERE ct.id = cart_id
          AND ct.idUser = user_id
          AND ct.create_time > pk.create_date
          AND pk.expire IS NULL;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `auction`
--

CREATE TABLE `auction` (
                           `id` int(11) NOT NULL,
                           `book_id` int(11) NOT NULL,
                           `start_price` double NOT NULL,
                           `current_price` double NOT NULL,
                           `min_increment` double NOT NULL,
                           `start_time` datetime NOT NULL,
                           `end_time` datetime NOT NULL,
                           `winner_id` int(11) DEFAULT NULL,
                           `status` varchar(20) DEFAULT 'WAITING',
                           `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `auction`
--

INSERT INTO `auction` (`id`, `book_id`, `start_price`, `current_price`, `min_increment`, `start_time`, `end_time`, `winner_id`, `status`, `created_at`) VALUES
                                                                                                                                                            (1, 1, 100000, 100000, 5000, '2026-06-27 22:41:20', '2026-06-28 22:41:20', NULL, 'FINISHED', '2026-06-27 22:41:20'),
                                                                                                                                                            (2, 1, 50000, 2000000, 5000, '2026-06-27 23:33:12', '2026-06-28 22:46:12', 49, 'FINISHED', '2026-06-27 23:33:12'),
                                                                                                                                                            (3, 2, 120000, 3000000, 10000, '2026-06-27 23:33:12', '2026-06-28 23:39:00', 49, 'FINISHED', '2026-06-27 23:33:12'),
                                                                                                                                                            (4, 3, 80000, 80000, 5000, '2026-06-27 23:33:12', '2026-06-28 23:33:12', NULL, 'FINISHED', '2026-06-27 23:33:12'),
                                                                                                                                                            (5, 1, 50000, 200000, 5000, '2026-06-27 23:36:58', '2026-06-28 23:35:58', 49, 'FINISHED', '2026-06-27 23:36:58'),
                                                                                                                                                            (6, 2, 80000, 300000, 5000, '2026-06-27 23:36:58', '2026-06-28 22:58:00', 49, 'FINISHED', '2026-06-27 23:36:58'),
                                                                                                                                                            (7, 3, 120000, 40000000, 10000, '2026-06-27 23:36:58', '2026-06-29 08:02:58', 49, 'FINISHED', '2026-06-27 23:36:58');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `auction_bid`
--

CREATE TABLE `auction_bid` (
                               `id` int(11) NOT NULL,
                               `auction_id` int(11) NOT NULL,
                               `user_id` int(11) NOT NULL,
                               `bid_price` double NOT NULL,
                               `bid_time` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `auction_bid`
--

INSERT INTO `auction_bid` (`id`, `auction_id`, `user_id`, `bid_price`, `bid_time`) VALUES
                                                                                       (1, 7, 49, 140000, '2026-06-28 22:30:34'),
                                                                                       (2, 2, 49, 100000, '2026-06-28 22:44:47'),
                                                                                       (3, 2, 49, 2000000, '2026-06-28 22:44:58'),
                                                                                       (4, 6, 49, 300000, '2026-06-28 22:57:44'),
                                                                                       (5, 5, 49, 100000, '2026-06-28 23:34:48'),
                                                                                       (6, 5, 49, 200000, '2026-06-28 23:34:54'),
                                                                                       (7, 3, 49, 200000, '2026-06-28 23:38:28'),
                                                                                       (8, 3, 49, 3000000, '2026-06-28 23:38:33'),
                                                                                       (9, 7, 49, 3000000, '2026-06-29 08:02:28'),
                                                                                       (10, 7, 49, 40000000, '2026-06-29 08:02:45');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `auction_notification`
--

CREATE TABLE `auction_notification` (
                                        `id` int(11) NOT NULL,
                                        `user_id` int(11) NOT NULL,
                                        `auction_id` int(11) NOT NULL,
                                        `title` varchar(255) DEFAULT NULL,
                                        `content` text DEFAULT NULL,
                                        `is_read` tinyint(4) DEFAULT 0,
                                        `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `author`
--

CREATE TABLE `author` (
                          `id_author` int(11) NOT NULL,
                          `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
                          `img` varchar(200) DEFAULT NULL,
                          `information` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `author`
--

INSERT INTO `author` (`id_author`, `name`, `img`, `information`) VALUES
                                                                     (1, 'Victor Hugo', '/templates/images/author/Victor_Hugo.jpg', NULL),
                                                                     (2, 'Olga Tokarczuk', '/templates/images/author/Olga_Tokarczuk-9739.jpg', 'Tác giả Olga Tokarczuk sinh năm 1962 tại Sulechov, Lublin, Ba Lan; hiện sống tại Vrotslav, Ba Lan. Bà là nhà văn, nhà phê bình văn học, nhà thơ, tác giả kịch bản sân khấu và điện ảnh. Năm 1979 truyện ngắn đầu tay của bà được đăng tải trên tạp chí Thanh niên, năm 1989 những bài thơ đầu tay được in trong các tạp chí Radar và Đời sống văn học. Tiểu thuyết đầu tay của bà xuất bản năm 1993 và từ đó đến nay hầu như năm nào cũng có tác phẩm ra mắt độc giả Tokarczuk là một trong những nhà văn được đánh giá cao trên thế giới và là nhà văn nhận được nhiều giải thưởng ở trong nước và nước ngoài trong những năm gần đây. Cho đến tháng 10 năm 2019 sách của bà đã được dịch ra 37 thứ tiếng.'),
                                                                     (3, 'J.K.Rowling', '/templates/images/author/J.K.Rowling.jpg', 'J.K. Rowling là tác giả của bộ tiểu thuyết Harry Potter, đã đạt nhiều giải thưởng và có con số phát hành kỷ lục. Bộ sách được bạn đọc trên khắp thế giới yêu chuộng, đã bán được hơn 500 triệu bản, được dịch sang 80 thứ tiếng và dựng thành tám tập phim bom tấn. Bà đã viết ba ngoại truyện vì mục đích từ thiện: Quidditch qua các thời kỳ, Những sinh vật huyền bí và nơi tìm ra chúng (để hỗ trợ cho quỹ Comic Relief và Lumos), và Những câu chuyện của Beedle người hát rong (hỗ trợ cho quỹ Lumos), cũng như kịch bản phim những sinh vật huyền bí và nơi tìm ra chúng, khởi đầu cho loạt phim năm sau được viết bởi chính tác giả truyện gốc. Năm 2016, J.K. Rowling hợp tác với Hack Thorne và giám đốc sản xuất John Tiffany trong vở kịch Harry Potter và đứa trẻ bị nguyền rủa Phần Một và Hai, hiện đang công diễn tại The Palace Theatre tại khu West End, London và diễn tại sân khấu Broadway vào tháng 4 năm 2018 Năm 2012, công ty kỹ thuật số Pottermore của J,K. Rowling ra đời, tạo điều kiện cho người'),
                                                                     (4, 'Nguyễn Nhật Ánh', '/templates/images/author/nguyennhatanh-compressed.jpg', 'Nguyễn Nhật Ánh sinh ngày 7 tháng 5 năm 1955 tại tỉnh Quảng Nam.  Ông được coi là một trong những nhà văn thành công nhất viết sách cho tuổi thơ, tuồi mới lớn với hơn 100 tác phẩm các thể loại. Trước khi trở thành nhà văn nổi tiếng, Nguyễn Nhật Ánh từng có thời gian đi dạy học, viết báo với nhiều bút danh như Chu Đình Ngạn, Lê Duy Cật, Đông Phương Sóc, Sóc Phương Đông,... Năm 13 tuổi, ông đã có thơ đăng báo. Năm 1984, tác phẩm truyện dài đầu tiên Trước vòng chung kết đã định vị tên tuổi của ông trong lòng độc giả và kể từ đó, ông tập trung viết cho lứa tuổi thanh thiếu niên. Tên tuổi của nhà văn Nguyễn Nhật Ánh gắn liền với các tác phẩm làm say lòng độc giả bao thế hệ như Mắt biếc, Cỏn chút gì để nhớ, Hạ đỏ, Cô gái đến từ hôm qua, Chú bé rắc rối,… Truyện của ông được tái bản liên tục và chưa bao giờ giảm sức hút với những người yêu mến chất văn Nguyễn Nhật Ánh.'),
                                                                     (5, 'Kim Khánh', '/templates/images/author/KimKhanh.gif', NULL),
                                                                     (6, 'Nguyễn Mạnh Hùng', '/templates/images/author/nguyen-manh-hung.jpg', NULL),
                                                                     (7, 'Thạch Lam', '/templates/images/author/Nhà_văn_Thạch_Lam.jpeg', NULL),
                                                                     (8, 'ONO Eriko', '/templates/images/author/Ono_Eriko.jpg', NULL),
                                                                     (9, 'Phoebe Garnsworthy', '/templates/images/author/Phoebe_Garnsworthy_Spiritual_Author-1.jpg', NULL),
                                                                     (10, 'Phạm Ngọc Hiền', '/templates/images/author/PhamNgocHien.jpg', NULL),
                                                                     (11, 'Cửu Lộ Phi Hương', NULL, NULL),
                                                                     (12, 'Daniel Defoe', NULL, NULL),
                                                                     (13, 'Paul Coelho', NULL, NULL),
                                                                     (14, 'TS Patrizia Collard', NULL, NULL),
                                                                     (15, 'Phan Văn Trường', NULL, NULL),
                                                                     (16, 'Dale Carnegie', NULL, NULL),
                                                                     (17, 'Ajahn Brahm', NULL, NULL),
                                                                     (18, 'Gosho Aoyama', NULL, NULL),
                                                                     (19, 'Kim Eun Ju', NULL, 'Tác giả xê-ri tản văn 1 cm rất được yêu thích tại Hàn Quốc và đã được xuất bản tại nhiều nước châu Á như Đài Loan, Thái Lan…Hiện đang hoạt động tự do với tư cách là nhà sáng tạo nội dung, mong muốn qua những cuốn sách mình viết có thể đem tới nhiều góc nhìn sáng tạo, mới mẻ về cuộc sống và truyền thêm năng lượng tích cực tới nhiều người'),
                                                                     (20, 'Rosie Nguyễn', NULL, NULL),
                                                                     (21, 'Nguyễn Công Hoan', NULL, NULL),
                                                                     (22, 'Phỉ Ngã Tư Tồn', NULL, NULL),
                                                                     (23, 'Nhiều Tác giả', NULL, NULL),
                                                                     (24, 'Shelle Rose Charvet', NULL, NULL),
                                                                     (25, 'Robert T Kiyosaki', NULL, NULL),
                                                                     (26, 'B R O group', NULL, NULL),
                                                                     (27, 'Mặc Bảo Phi Bảo', NULL, NULL),
                                                                     (28, 'Mặc Bảo Phi Bảo', NULL, NULL),
                                                                     (29, 'Harper Lee', NULL, NULL),
                                                                     (30, 'Kirsten Smith', NULL, 'Kirsten Smith là nhà biên kịch Hollywood và tác giả của dòng sách dành cho tuổi mới lớn. Cô đồng biên kịch nhiều phim nổi tiếng như 10 Things I Hate About You (1999), Legally Blonde (2001), She\\s the Man (2006) và The Ugly Truth (2009). Hai tác phẩm Kirsten Smith viết cho thanh thiếu niên là The Geography of Girlhood (2009) và Bộ ba bất hảo (2013).'),
                                                                     (31, 'Nguyễn Ngọc Tư', NULL, 'Nguyễn Ngọc Tư sinh năm 1976 tại Đầm Dơi, Cà Mau. Là nữ nhà văn trẻ của Hội nhà văn Việt Nam. Với niềm đam mê viết lách, chị miệt mài viết như một cách giải tỏa và thể nghiệm, chị biết rằng chị muốn viết về những điều gần gũi nhất xung quanh cuộc sống của mình. Giọng văn chị đậm chất Nam bộ, là giọng kể mềm mại mà sâu cay về những cuộc đời éo le, những số phận chìm nổi. Cái chất miền quê sông nước ngấm vào các tác phẩm, thấm đẫm cái tình của làng, của đất, của những con người chân chất hồn hậu nhưng ít nhiều gặp những bất hạnh. Âm thầm đến với văn chương và bừng sáng khi được nhận giải Nhất cuộc thi Văn học tuổi 20 của NXB Trẻ, Nguyễn Ngọc Tư đã trở thành tâm điểm của sự hy vọng vào một nền văn trẻ đương đại. Chị đã tiếp tục có những cú nhảy ngoạn mục trên chặng đường văn cùng những tác phẩm được giới chuyên môn đánh giá cao. Tập truyện ngắn Cánh đồng bất tận của chị gây được tiếng vang lớn, nhận được nhiều giải thưởng cũng như chuyển thể thành kịch, phim điện ảnh.Các mốc sự kiện'),
                                                                     (32, 'Diệp Hồng Vũ ', NULL, NULL),
                                                                     (33, 'Emily Bronte', NULL, NULL),
                                                                     (34, 'John C Bogle', NULL, 'John C. Bogle là nhà sáng lập của tập đoàn Vanguard, một trong hai tổ chức cung cấp quỹ tương hỗ lớn nhất trên thế giới. Ông có tên trong danh sách một trăm người quyền lực và có tầm ảnh hưởng nhất thế giới, do tạp chí TIME bình chọn. Tờ FORTUNE gọi ông là một trong bốn “người khổng lồ của thế kỷ 20” trong lĩnh vực đầu tư.'),
                                                                     (35, 'José Mauro de Vasconcelos', NULL, 'JOSÉ MAURO DE VASCONCELOS (1920-1984) là nhà văn người Brazil. Sinh ra trong một gia đình nghèo ở ngoại ô Rio de Janeiro, lớn lên ông phải làm đủ nghề để kiếm sống. Nhưng với tài kể chuyện thiên bẩm, trí nhớ phi thường, trí tưởng tượng tuyệt vời cùng vốn sống phong phú, José cảm thấy trong mình thôi thúc phải trở thành nhà văn nên đã bắt đầu sáng tác năm 22 tuổi. Tác phẩm nổi tiếng nhất của ông là tiểu thuyết mang màu sắc tự truyện Cây cam ngọt của tôi. Cuốn sách được đưa vào chương trình tiểu học của Brazil, được bán bản quyền cho hai mươi quốc gia và chuyển thể thành phim điện ảnh. Ngoài ra, José còn rất thành công trong vai trò diễn viên điện ảnh và biên kịch.'),
                                                                     (36, 'Đinh Mặc', NULL, NULL),
                                                                     (37, 'Thích Nhất Hạnh', NULL, NULL),
                                                                     (38, 'Olga Makhovskaya', NULL, 'Olga Makhovskaya – nhà tâm lý học nổi tiếng, phó tiến sĩ khoa học tâm lý, cộng tác viên của Viện Tâm lý thuộc Viện Hành lâm khoa học Liên bang Nga, cộng tác viên của trường Đại học Điện ảnh Liên bang Nga. Olga Makhovskaya còn là người nhận được rất nhiều Học bổng các chương trình khoa học quốc tế. Bà còn là Giám đốc nội dung Dự án truyền hình giáo dục dành cho trẻ em “Sesame Street” (Phố Vừng) tại Nga, đồng thời là tác giả và người dẫn chương trình một số chương trình dành cho các bậc cha mẹ.Olga Makhovskaya còn là tác giả của các tác phẩm Trẻ em Mỹ chơi với niềm vui, trẻ em Pháp chơi theo nguyên tắc, còn trẻ em Nga chơi đến khi chiến thắng; Bình tĩnh nói chuyện với trẻ như thế nào về cuộc sống để trẻ cho bạn sống bình yên.'),
                                                                     (39, 'Cố Tây Tước', NULL, NULL),
                                                                     (40, 'Hoàng Khánh Duy', NULL, NULL),
                                                                     (41, 'Nguyên Phong', NULL, 'Tác giả Nguyên Phong (Vũ Văn Du) du học ở Mỹ từ năm 1968, tốt nghiệp cao học Sinh vật học, Điện toán. Ông từng là Kỹ sư trưởng, CIO của Tập đoàn Boeing của Mỹ, Viện trưởng Viện Công nghệ Sinh học Đại học Carnegie Mellon. Ông được mọi người biết tới là Giáo sư John Vu – Nhà khoa học uy tín về công nghệ thông tin. , CMMI và từng giảng dạy ở nhiều trường đại học trên thế giới. Nguyên Phong là bút danh của bộ sách văn hóa tâm linh được dịch, viết phóng tác từ trải nghiệm, tiềm thức và quá trình nghiên cứu, khám phá các giá trị tinh thần Đông phương. Ông đã viết phóng tác tác phẩm bất hủ Hành trình về Phương Đông năm 24 tuổi (1974). Các tác phẩm khác của Nguyên Phong được bạn đọc nhiều thế hệ yêu thích: Ngọc sáng trong hoa sen, Bên rặng tuyết sơn, Hoa sen trên tuyết, Hoa trôi trên sóng nước, Huyền thuật và các đạo sĩ Tây Tạng, Trở về từ xứ tuyết, Trở về từ cõi sáng, Minh triết trong đời sống, Đường mây qua xứ tuyết, Dấu chân trên cát, Đường mây trong cõi mộng, Đường mây trên đất hoa… và.'),
                                                                     (42, 'Lục Xu', NULL, NULL),
                                                                     (43, 'Baird T Spalding', NULL, NULL),
                                                                     (44, 'Trần Ánh Phương', NULL, 'Tác giả Trần Ánh Phương hiện đang là chủ doanh nghiệp. Mới ra trường, chị làm nghề nhân sự. Công việc ứng xử với con người rất phức tạp. Nhờ thế, chị rèn được cho mình sự tinh tế, khéo léo, khôn ngoan Chị cho rằng cuộc đời sự nghiệp chính là con người mình. Thành người cống hiến hay lu mờ, sống đời ý nghĩa hay vô nghĩa, ta có 30-40 năm làm việc để lựa chọn và cố gắng. Dù thế nào, hãy bước đi để khám phá và trưởng thành hơn. Cuốn sách Ánh mắt xa cuộc đời gần chia sẻ những góc nhìn rất khác về nghề nhân sự, để những ai làm nhân sự luôn yêu nghề, hiểu nghề, và từ đấy trở thành người nhân sự nhìn xa đẩy doanh nghiệp tiến bước, nhìn gần giữ tinh thần nhân viên.'),
                                                                     (45, 'Vũ Bằng', NULL, NULL),
                                                                     (46, 'Tống Mặc ', NULL, NULL),
                                                                     (47, 'Nguyễn Du', NULL, NULL),
                                                                     (48, 'Xuân Quỳnh', NULL, NULL),
                                                                     (49, 'Mã Hạo Thiên', '', NULL),
                                                                     (50, 'Hoài Thanh', NULL, NULL),
                                                                     (51, 'Nguyễn Huy Thắng', NULL, NULL),
                                                                     (52, 'Vương Trọng', NULL, NULL),
                                                                     (53, 'Ngô Mạnh Lân', NULL, NULL),
                                                                     (54, 'Trâu Hoành Minh', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bill`
--

CREATE TABLE `bill` (
                        `id_order` int(11) NOT NULL,
                        `id_user` int(11) NOT NULL,
                        `id_book` int(11) NOT NULL,
                        `idCart` int(11) DEFAULT NULL,
                        `shipping_info` int(11) NOT NULL DEFAULT 1 COMMENT '1: chờ xử lý; 2: đang vận chuyển; 3: đã hoàn thành; 4: đã hủy',
                        `id_discount` int(11) DEFAULT NULL,
                        `address` varchar(255) NOT NULL,
                        `pack` int(11) NOT NULL DEFAULT 0 COMMENT '0:Bọc blastic, 1:Để nguyên seal',
                        `payment_method` int(11) NOT NULL DEFAULT 0 COMMENT '0: tiền mặt; 1: online',
                        `totalBill` double DEFAULT NULL,
                        `quantity` int(11) DEFAULT NULL,
                        `phone` varchar(50) DEFAULT NULL,
                        `info` text DEFAULT NULL,
                        `create_order_time` timestamp NULL DEFAULT NULL COMMENT 'Thời gian tạo bill',
                        `ship_time` timestamp NULL DEFAULT NULL COMMENT 'Thời gian ship',
                        `receive_time` timestamp NULL DEFAULT NULL COMMENT 'Thời gian nhận'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `bill`
--

INSERT INTO `bill` (`id_order`, `id_user`, `id_book`, `idCart`, `shipping_info`, `id_discount`, `address`, `pack`, `payment_method`, `totalBill`, `quantity`, `phone`, `info`, `create_order_time`, `ship_time`, `receive_time`) VALUES
                                                                                                                                                                                                                                     (105, 38, 19, 28, 1, NULL, 'Thôn 13 Xã Quảng Ngạn Huyện Quảng Điền Tỉnh Thừa Thiên Huế, Xã Sơn Tình, Huyện Cẩm Khê, Tỉnh Phú Thọ', 0, 0, 167199, 1, '0867415853', '', '2023-11-29 11:58:07', NULL, NULL),
                                                                                                                                                                                                                                     (106, 38, 14, 28, 1, NULL, 'Thôn 13 Xã Quảng Ngạn Huyện Quảng Điền Tỉnh Thừa Thiên Huế, Xã Sơn Tình, Huyện Cẩm Khê, Tỉnh Phú Thọ', 0, 0, 167199, 2, '0867415853', '', '2023-11-29 11:58:07', NULL, NULL),
                                                                                                                                                                                                                                     (107, 49, 14, 29, 2, NULL, '245,ds10,Linh Xuan, Phường Linh Trung, Thành phố Thủ Đức, Thành phố Hồ Chí Minh', 0, 0, 67200, 2, '0123456789', '', '2026-05-23 15:38:36', NULL, NULL),
                                                                                                                                                                                                                                     (108, 49, 1, 30, 2, NULL, 'DT, Xã Tà Gia, Huyện Than Uyên, Tỉnh Lai Châu', 0, 0, 150000, 1, '0123456789', '', '2026-05-23 15:59:09', NULL, NULL),
                                                                                                                                                                                                                                     (109, 49, 3, 31, 2, NULL, '123,abc,def,vn, Phường Yên Thọ, Thành phố Đông Triều, Tỉnh Quảng Ninh', 0, 0, 72000, 1, '0123456789', '', '2026-05-23 16:27:25', NULL, NULL),
                                                                                                                                                                                                                                     (110, 49, 18, 32, 4, NULL, 'DT, Xã Nghĩa Sơn, Huyện Văn Chấn, Tỉnh Yên Bái', 0, 0, 450000, 3, '0123456789', '', '2026-05-24 12:48:10', NULL, NULL),
                                                                                                                                                                                                                                     (111, 49, 1, 33, 4, NULL, 'dsdf, Xã Vạn Linh, Huyện Chi Lăng, Tỉnh Lạng Sơn', 0, 0, 600000, 4, '0123456789', '', '2026-05-24 13:13:02', NULL, NULL),
                                                                                                                                                                                                                                     (112, 49, 1, 34, 2, NULL, 'dsdf, Xã Suối Bu, Huyện Văn Chấn, Tỉnh Yên Bái', 0, 0, 600000, 2, '0123456789', '', '2026-05-24 13:19:08', NULL, NULL),
                                                                                                                                                                                                                                     (113, 49, 18, 34, 2, NULL, 'dsdf, Xã Suối Bu, Huyện Văn Chấn, Tỉnh Yên Bái', 0, 0, 600000, 2, '0123456789', '', '2026-05-24 13:19:08', NULL, NULL),
                                                                                                                                                                                                                                     (114, 49, 1, 35, 4, NULL, 'dsdf, Xã Tú Đoạn, Huyện Lộc Bình, Tỉnh Lạng Sơn', 0, 0, 333600, 1, '0123456789', '', '2026-05-24 13:28:00', NULL, NULL),
                                                                                                                                                                                                                                     (115, 49, 18, 35, 4, NULL, 'dsdf, Xã Tú Đoạn, Huyện Lộc Bình, Tỉnh Lạng Sơn', 0, 0, 333600, 1, '0123456789', '', '2026-05-24 13:28:00', NULL, NULL),
                                                                                                                                                                                                                                     (116, 49, 14, 35, 4, NULL, 'dsdf, Xã Tú Đoạn, Huyện Lộc Bình, Tỉnh Lạng Sơn', 0, 0, 333600, 1, '0123456789', '', '2026-05-24 13:28:00', NULL, NULL),
                                                                                                                                                                                                                                     (117, 49, 1, 36, 4, NULL, 'dsdf, Xã Nậm Lạnh, Huyện Sốp Cộp, Tỉnh Sơn La', 0, 0, 900000, 4, '0123456789', '', '2026-05-25 02:08:52', NULL, NULL),
                                                                                                                                                                                                                                     (118, 49, 18, 36, 4, NULL, 'dsdf, Xã Nậm Lạnh, Huyện Sốp Cộp, Tỉnh Sơn La', 0, 0, 900000, 2, '0123456789', '', '2026-05-25 02:08:52', NULL, NULL),
                                                                                                                                                                                                                                     (119, 49, 3, 37, 4, NULL, 'dsdf, Phường Yên Giang, Thị xã Quảng Yên, Tỉnh Quảng Ninh', 0, 0, 72000, 1, '0123456789', '', '2026-05-25 02:09:31', NULL, NULL),
                                                                                                                                                                                                                                     (120, 49, 18, 38, 4, NULL, 'dsdf, Xã Danh Thắng, Huyện Hiệp Hòa, Tỉnh Bắc Giang', 0, 0, 150000, 1, '0123456789', '', '2026-05-26 15:51:25', NULL, NULL),
                                                                                                                                                                                                                                     (121, 49, 18, 39, 1, NULL, 'dsdf, Xã Danh Thắng, Huyện Hiệp Hòa, Tỉnh Bắc Giang', 0, 0, 150000, 1, '0123456789', '', '2026-05-26 15:51:32', NULL, NULL),
                                                                                                                                                                                                                                     (122, 49, 18, 40, 4, NULL, 'sa, Xã Tu Vũ, Huyện Thanh Thuỷ, Tỉnh Phú Thọ', 0, 0, 150000, 1, '0123456789', '', '2026-05-26 16:06:29', NULL, NULL),
                                                                                                                                                                                                                                     (123, 49, 14, 41, 4, NULL, 'sa, Xã Quỳnh Sơn, Thành phố Bắc Giang, Tỉnh Bắc Giang', 0, 0, 33600, 1, '0123456789', '', '2026-05-26 16:52:44', NULL, NULL),
                                                                                                                                                                                                                                     (124, 49, 3, 42, 4, NULL, '245,ds10,Linh Xuan, Phường 14, Quận 5, Thành phố Hồ Chí Minh', 1, 0, 72000, 1, '0123456789', '', '2026-05-26 16:57:56', NULL, NULL),
                                                                                                                                                                                                                                     (125, 49, 18, 43, 4, NULL, '245,ds10,Linh Xuan, Phường An Lạc, Quận Bình Tân, Thành phố Hồ Chí Minh', 0, 0, 327600, 1, '0123456789', '', '2026-05-26 17:25:06', NULL, NULL),
                                                                                                                                                                                                                                     (126, 49, 3, 43, 4, NULL, '245,ds10,Linh Xuan, Phường An Lạc, Quận Bình Tân, Thành phố Hồ Chí Minh', 0, 0, 327600, 2, '0123456789', '', '2026-05-26 17:25:06', NULL, NULL),
                                                                                                                                                                                                                                     (127, 49, 14, 43, 4, NULL, '245,ds10,Linh Xuan, Phường An Lạc, Quận Bình Tân, Thành phố Hồ Chí Minh', 0, 0, 327600, 1, '0123456789', '', '2026-05-26 17:25:06', NULL, NULL),
                                                                                                                                                                                                                                     (128, 49, 18, 44, 4, NULL, '245,ds10,Linh Xuan, Phường An Lạc, Quận Bình Tân, Thành phố Hồ Chí Minh', 0, 0, 327600, 1, '0123456789', '', '2026-05-26 17:25:19', NULL, NULL),
                                                                                                                                                                                                                                     (129, 49, 3, 44, 4, NULL, '245,ds10,Linh Xuan, Phường An Lạc, Quận Bình Tân, Thành phố Hồ Chí Minh', 0, 0, 327600, 2, '0123456789', '', '2026-05-26 17:25:19', NULL, NULL),
                                                                                                                                                                                                                                     (130, 49, 14, 44, 4, NULL, '245,ds10,Linh Xuan, Phường An Lạc, Quận Bình Tân, Thành phố Hồ Chí Minh', 0, 0, 327600, 1, '0123456789', '', '2026-05-26 17:25:19', NULL, NULL),
                                                                                                                                                                                                                                     (131, 49, 3, 45, 4, NULL, '245,ds10,Linh Xuan, Phường 16, Quận 8, Thành phố Hồ Chí Minh', 0, 0, 144000, 2, '0123456789', '', '2026-05-26 17:27:06', NULL, NULL),
                                                                                                                                                                                                                                     (132, 49, 1, 46, 4, NULL, 'sa, Xã Phú Lai, Huyện Yên Thủy, Tỉnh Hoà Bình', 0, 0, 150000, 1, '0123456789', '', '2026-05-26 17:30:18', NULL, NULL),
                                                                                                                                                                                                                                     (133, 49, 3, 47, 1, NULL, '245,ds10,Linh Xuan, Phường Hưng Phú, Quận 8, Thành phố Hồ Chí Minh', 0, 0, 159200, 1, '0123456789', '', '2026-06-19 02:03:53', NULL, NULL),
                                                                                                                                                                                                                                     (134, 49, 14, 47, 1, NULL, '245,ds10,Linh Xuan, Phường Hưng Phú, Quận 8, Thành phố Hồ Chí Minh', 0, 0, 159200, 2, '0123456789', '', '2026-06-19 02:03:53', NULL, NULL),
                                                                                                                                                                                                                                     (135, 49, 18, 48, 1, NULL, '245,ds10,Linh Xuan, Phường 9, Quận 4, Thành phố Hồ Chí Minh', 0, 0, 450000, 3, '0123456789', '', '2026-06-19 07:17:18', NULL, NULL),
                                                                                                                                                                                                                                     (136, 49, 3, 49, 1, NULL, '245,ds10,Linh Xuan, Phường 12, Quận 3, Thành phố Hồ Chí Minh', 1, 0, 236000, 3, '0123456789', 'abc', '2026-06-19 07:47:50', NULL, NULL),
                                                                                                                                                                                                                                     (137, 49, 3, 50, 1, NULL, '245,ds10,Linh Xuan, Phường Tân Thuận Tây, Quận 7, Thành phố Hồ Chí Minh', 0, 0, 72000, 1, '0123456789', '', '2026-06-19 07:51:54', NULL, NULL),
                                                                                                                                                                                                                                     (138, 49, 18, 51, 1, NULL, '245,ds10,Linh Xuan, Phường An Lạc A, Quận Bình Tân, Thành phố Hồ Chí Minh', 0, 0, 320000, 2, '0123456789', '', '2026-06-19 14:57:55', NULL, NULL),
                                                                                                                                                                                                                                     (139, 49, 3, 52, 1, NULL, '245,ds10,Linh Xuan, Xã Mường Và, Huyện Sốp Cộp, Tỉnh Sơn La', 1, 0, 72000, 1, '0123456789', '', '2026-06-19 15:04:36', NULL, NULL),
                                                                                                                                                                                                                                     (140, 49, 1, 53, 1, NULL, '245,ds10,Linh Xuan, Phường 5, Quận 11, Thành phố Hồ Chí Minh', 0, 0, 620000, 4, '0123456789', '', '2026-06-19 15:30:03', NULL, NULL),
                                                                                                                                                                                                                                     (141, 49, 3, 54, 1, NULL, '245,ds10,Linh Xuan, Phường 4, Quận 8, Thành phố Hồ Chí Minh', 0, 0, 308000, 4, '0123456789', '', '2026-06-19 15:31:57', NULL, NULL),
                                                                                                                                                                                                                                     (142, 49, 18, 55, 4, NULL, '245,ds10,Linh Xuan, Phường Hưng Phú, Quận 8, Thành phố Hồ Chí Minh', 0, 0, 320000, 2, '0123456789', '', '2026-06-21 14:32:23', NULL, NULL),
                                                                                                                                                                                                                                     (143, 49, 18, 56, 1, NULL, '245,ds10,Linh Xuan, Phường 4, Quận 8, Thành phố Hồ Chí Minh', 0, 0, 239999, 1, '0123456789', '', '2026-06-21 14:40:02', NULL, NULL),
                                                                                                                                                                                                                                     (144, 49, 19, 56, 1, NULL, '245,ds10,Linh Xuan, Phường 4, Quận 8, Thành phố Hồ Chí Minh', 0, 0, 239999, 1, '0123456789', '', '2026-06-21 14:40:02', NULL, NULL),
                                                                                                                                                                                                                                     (145, 49, 19, 57, 1, NULL, '245,ds10,Linh Xuan, Phường 7, Quận 11, Thành phố Hồ Chí Minh', 0, 0, 299997, 3, '0123456789', '', '2026-06-21 15:36:04', NULL, NULL),
                                                                                                                                                                                                                                     (146, 49, 19, 58, 1, NULL, '245,ds10,Linh Xuan, Phường 7, Quận 11, Thành phố Hồ Chí Minh', 0, 1, 489995, 5, '0123456789', '', '2026-06-21 15:58:42', NULL, NULL),
                                                                                                                                                                                                                                     (147, 49, 1, 59, 1, NULL, '245,ds10,Linh Xuann, Phường 8, Quận 6, Thành phố Hồ Chí Minh', 0, 0, 460000, 3, '0123456789', '', '2026-06-24 02:07:50', NULL, NULL),
                                                                                                                                                                                                                                     (148, 49, 2, 60, 1, NULL, '245,ds10,Linh Xuan, Phường 1, Quận 11, Thành phố Hồ Chí Minh', 0, 0, 300000, 1, '0123456789', '', '2026-06-29 01:12:50', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `book`
--

CREATE TABLE `book` (
                        `id_book` int(11) NOT NULL,
                        `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
                        `id_author` int(11) NOT NULL,
                        `id_catalog` int(11) NOT NULL,
                        `quantity` int(11) DEFAULT NULL,
                        `prime_cost` double DEFAULT NULL,
                        `price` double DEFAULT NULL,
                        `discount_price` double DEFAULT NULL,
                        `isNew` tinyint(1) DEFAULT NULL,
                        `isActive` tinyint(1) DEFAULT NULL,
                        `id_pc` int(11) NOT NULL,
                        `id_p` int(11) NOT NULL,
                        `published_time` int(11) DEFAULT NULL,
                        `created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `book`
--

INSERT INTO `book` (`id_book`, `name`, `id_author`, `id_catalog`, `quantity`, `prime_cost`, `price`, `discount_price`, `isNew`, `isActive`, `id_pc`, `id_p`, `published_time`, `created`) VALUES
                                                                                                                                                                                              (1, 'Ánh Mắt Xa, Cuộc Đời Gần', 44, 7, 570, 120000, 150000, 0, 1, 1, 9, 5, 2022, '2026-06-28 16:45:00'),
                                                                                                                                                                                              (2, 'Dạy Con Làm Giàu - Tập 1 (Tái Bản 2018)', 44, 5, 463, 30000, 65000, 0.41, 0, 1, 12, 12, 2018, '2026-06-29 01:12:26'),
                                                                                                                                                                                              (3, 'Công Dân Toàn Cầu - Công Dân Vũ Trụ', 15, 5, 64, 60000, 90000, 0.2, 1, 1, 12, 12, 2022, '2026-06-28 17:11:52'),
                                                                                                                                                                                              (4, 'Muôn Kiếp Nhân Sinh - Many Times, Many Lives', 41, 2, 87, 100000, 168000, 0.39, 0, 1, 10, 10, 2020, '2023-01-06 14:35:48'),
                                                                                                                                                                                              (5, 'Hành Trình Về Phương Đông (Tái Bản 2021)', 43, 2, 395, 70000, 118000, 0.35, 0, 1, 10, 15, 2021, '2023-03-01 02:31:48'),
                                                                                                                                                                                              (6, 'All In Love - Ngập Tràn Yêu Thương (Tái Bản 2020)', 7, 8, 297, 75000, 119000, 0.2, 0, 1, 5, 7, 2020, '2023-11-29 06:37:52'),
                                                                                                                                                                                              (7, 'Giết Con Chim Nhại (Tái Bản 2019)', 29, 8, 74, 75000, 120000, 0.2, 0, 1, 8, 14, 2019, '2023-03-01 02:24:10'),
                                                                                                                                                                                              (8, 'Nhà Giả Kim (Tái Bản 2020)', 19, 8, 248, 50000, 79000, 0.32, 0, 1, 8, 6, 2020, '2023-02-24 15:03:57'),
                                                                                                                                                                                              (9, '1 Cm Giữa Anh Và Em', 19, 8, 62, 120000, 160000, 0.1, 0, 1, 8, 3, 2020, '2023-02-25 08:03:40'),
                                                                                                                                                                                              (10, 'Cây Cam Ngọt Của Tôi', 35, 8, 50, 60000, 108000, 0.35, 0, 1, 8, 6, 2020, '2023-01-06 14:36:20'),
                                                                                                                                                                                              (11, 'Đầu Tư Chứng Khoán Theo Chỉ Số', 34, 4, 300, 70000, 110000, 0.2, 0, 1, 12, 1, 2019, '2023-01-06 14:36:23'),
                                                                                                                                                                                              (12, 'Tĩnh Lặng - Sức Mạnh Tĩnh Lặng Trong Thế Giới Huyền Ảo (Tái Bản 2020)', 37, 2, 86, 50000, 69000, 0.2, 0, 1, 12, 15, 2020, '2023-06-01 04:13:46'),
                                                                                                                                                                                              (13, 'Những Người Khốn Khổ (Trọn Bộ 2 Tập)', 32, 8, 111, 350000, 499000, 0.2, 0, 1, 8, 14, 2020, '2023-02-25 08:14:59'),
                                                                                                                                                                                              (14, 'Robinson Crusoe (Tái Bản)', 12, 8, 175, 90000, 112000, 0.7, 1, 1, 13, 14, 2022, '2026-06-19 15:05:07'),
                                                                                                                                                                                              (15, '100 sai lầm của bố mẹ khiến con thất bại', 38, 8, 70, 90000, 135000, 0.2, 0, 1, 15, 7, 2020, '2023-01-06 14:36:36'),
                                                                                                                                                                                              (16, 'Bieguni, Những Người Không Ngừng Chuyển Động', 2, 8, 221, 120000, 185000, 0.2, 0, 1, 15, 7, 2020, '2023-02-25 09:09:44'),
                                                                                                                                                                                              (17, 'Bộ Ba Bất Hảo - Quẩy Lên Nào! - Tình Bạn Là Vô Giá', 30, 8, 35, 80000, 118000, 0.2, 0, 1, 15, 7, 2021, '2023-02-28 12:09:16'),
                                                                                                                                                                                              (18, 'Hãy nhắm mắt khi anh đến', 1, 1, 2, 120000, 150000, 0, 1, 1, 1, 1, 2022, '2026-06-21 14:39:42'),
                                                                                                                                                                                              (19, 'Ngày Cuối Cùng Của Một Tử Tù', 1, 1, 12291, 88888, 99999, 0, 1, 1, 1, 1, 2022, '2026-06-21 15:58:27'),
                                                                                                                                                                                              (22, 'Tinh Hoa Văn Học Việt Nam - Truyện Ngắn Nguyễn Công HoanTinh Hoa Văn Học Việt Nam - Truyện Ngắn Nguyễn Công Hoan\r\n', 21, 9, 0, 83000, 88000, 0.06, 1, 1, 13, 14, 2016, '2023-03-22 13:02:49'),
                                                                                                                                                                                              (23, 'Danh Tác Văn Học Việt Nam - Sợi Tóc\r\n', 39, 9, 0, 30000, 35000, 0.13, 1, 1, 16, 14, 2022, '2023-03-22 13:02:49'),
                                                                                                                                                                                              (24, 'Danh Tác Việt Nam - Thạch Lam Tuyển Tập (Tái Bản 2019)\r\n', 39, 9, 0, 100000, 113000, 0.05, 1, 1, 13, 14, 2019, '2023-03-22 13:02:50'),
                                                                                                                                                                                              (25, 'Văn Học Trong Nhà Trường: Gió Lạnh Đầu Mùa (Tái Bản 2019)\r\n', 39, 9, 0, 40000, 45000, 0.07, 1, 1, 17, 4, 2019, '2023-03-22 13:02:54'),
                                                                                                                                                                                              (27, 'Thi Nhân Việt Nam (1932-1941)\r\n', 50, 9, 0, 90000, 120000, 0.25, 1, 1, 18, 14, 2022, '2023-03-22 13:02:57'),
                                                                                                                                                                                              (29, 'Văn Học Trong Nhà Trường: Thơ Xuân Quỳnh\r\n', 48, 9, 0, 33000, 35000, 0.06, 1, 1, 17, 4, 2019, '2023-03-22 13:02:58'),
                                                                                                                                                                                              (30, 'Văn Học Trong Nhà Trường: Truyện Kiều (Tái Bản 2019)\r\n', 47, 9, 100, 38000, 40000, 0.05, 1, 1, 17, 4, 2019, '2023-01-08 14:23:36'),
                                                                                                                                                                                              (31, 'Việt Nam Danh Tác - Ngày Mới\r\n', 39, 9, 100, 82000, 89000, 0.07, 1, 1, 8, 6, 2022, '2023-01-08 14:24:47'),
                                                                                                                                                                                              (44, 'Văn Học Tuổi 20 - Cõi Người Mắc Cạn\r\n', 40, 9, 100, 56000, 65000, 0.13, 1, 1, 19, 12, 2022, '2023-01-08 14:26:55'),
                                                                                                                                                                                              (45, 'Ngược Chiều Thiên Di\r\n', 40, 9, 100, 47000, 50000, 0.06, 1, 1, 20, 10, 2020, '2023-01-08 14:28:05'),
                                                                                                                                                                                              (46, 'Việt Nam Danh Tác - Miếng Ngon Hà Nội\r\n', 45, 9, 100, 66000, 70000, 0.06, 1, 1, 22, 6, 2021, '2023-01-08 14:29:37'),
                                                                                                                                                                                              (47, 'Tiểu Thuyết Việt Nam 1945 -1975\r\n', 10, 9, 100, 109000, 115000, 0.05, 1, 1, 21, 17, 2018, '2023-01-08 14:31:12'),
                                                                                                                                                                                              (56, 'Truyện Tranh Trạng Quỷnh - Tập 418: Lời To\r\n', 49, 3, 100, 10000, 12000, 0.08, 1, 1, 23, 18, 2021, '2023-01-08 14:33:33'),
                                                                                                                                                                                              (58, 'Truyện Tranh Trạng Quỷnh - Tập 365: Con Lân Năm Chân\r\n', 49, 3, 100, 10000, 12000, 0.08, 1, 1, 23, 18, 2020, '2023-01-08 14:34:30'),
                                                                                                                                                                                              (59, 'Truyện Tranh Trạng Quỷnh - Tập 163: Đóng Cửa Nhà Hát\r\n', 49, 3, 100, 10000, 12000, 0.08, 1, 1, 23, 18, 2020, '2023-01-08 14:35:10'),
                                                                                                                                                                                              (60, 'Truyện Tranh Trạng Quỷnh - Tập 419: Hai Đứa Bé Chăn Trâu\r\n', 49, 3, 100, 10000, 12000, 0.08, 1, 1, 23, 18, 2021, '2023-01-08 14:35:43'),
                                                                                                                                                                                              (62, 'Cậu Bé Rồng - Tập 243: Bắt Cóc Thần Chết\r\nTruyện Tranh Lịch Sử Việt Nam: Hàm Nghi\r\n', 49, 3, 100, 10000, 12000, 0.08, 1, 1, 23, 18, 2021, '2023-01-08 14:36:55'),
                                                                                                                                                                                              (63, 'Truyện Tranh Lịch Sử Việt Nam: Hàm Nghi\r\n', 51, 3, 100, 12000, 15000, 0.2, 1, 1, 17, 4, 2022, '2023-01-08 14:39:55'),
                                                                                                                                                                                              (64, 'Truyện Tranh Lịch Sử Việt Nam: Lê Chân\r\n', 52, 3, 100, 12000, 15000, 0.2, 1, 1, 17, 4, 2021, '2023-01-08 14:41:25'),
                                                                                                                                                                                              (65, 'Tranh Truyện Dân Gian Việt Nam: Cây Tre Trăm Đốt \r\n', 53, 3, 100, 12000, 15000, 0.2, 1, 1, 17, 4, 2021, '2023-01-08 14:42:58'),
                                                                                                                                                                                              (66, 'Tranh Truyện Dân Gian Việt Nam: Sự Tích Con Thạch Sùng\r\n', 21, 3, 100, 12000, 15000, 0.2, 1, 1, 17, 4, 2022, '2023-01-08 14:43:56'),
                                                                                                                                                                                              (67, 'Thám Tử Lừng Danh Conan - Tập 98\r\n', 18, 3, 100, 20000, 25000, 0, 1, 1, 17, 4, 2021, '2023-01-08 14:45:03'),
                                                                                                                                                                                              (68, 'Thám Tử Lừng Danh Conan - Tập 99\r\n', 18, 3, 100, 20000, 25000, 0, 1, 1, 17, 4, 2021, '2023-01-08 14:45:46'),
                                                                                                                                                                                              (69, 'Thám Tử Lừng Danh Conan Tập 61 (Tái Bản 2019)\r\n', 18, 3, 100, 20000, 25000, 0, 1, 1, 17, 4, 2019, '2023-01-08 14:46:30'),
                                                                                                                                                                                              (70, 'Tâm Lý Học - Phác Họa Chân Dung Kẻ Phạm Tội\r\n', 1, 7, 99, 94000, 145000, 0.35, 1, 1, 2, 11, 2021, '2023-08-31 02:14:18'),
                                                                                                                                                                                              (71, 'Tuổi Trẻ Đáng Giá Bao Nhiêu (Tái Bản 2021)\r\n', 20, 7, 100, 59000, 90000, 0.34, 1, 1, 8, 6, 2021, '2023-01-08 14:49:02'),
                                                                                                                                                                                              (75, 'Đắc Nhân Tâm (Tái Bản 2021)\r\nTâm Lý Học Tính Cách\r\n', 16, 7, 100, 56000, 86000, 0.35, 1, 1, 6, 10, 2021, '2023-01-08 14:51:17'),
                                                                                                                                                                                              (76, 'Tâm Lý Học Tính Cách\r\n', 54, 7, 100, 78000, 109000, 0.27, 1, 1, 6, 10, 2022, '2023-01-08 14:54:28'),
                                                                                                                                                                                              (77, 'Tâm Lý Học Biểu Cảm\r\n', 5, 7, 100, 78000, 98000, 0.2, 1, 1, 6, 18, 2020, '2023-01-08 14:55:47'),
                                                                                                                                                                                              (78, 'Ngôn Từ Thay Đổi Tư Duy\r\n', 24, 7, 100, 140000, 188000, 0.25, 1, 1, 14, 2, 2021, '2023-01-08 14:57:04'),
                                                                                                                                                                                              (79, 'Nóng Giận Là Bản Năng, Tĩnh Lặng Là Bản Lĩnh (Tái Bản 2020)\r\n', 8, 7, 100, 75000, 89000, 0.15, 1, 1, 6, 5, 2022, '2023-01-08 14:59:26'),
                                                                                                                                                                                              (80, 'Năng Lượng Chữa Lành - Lắng Nghe Tâm Thức Để Mang Đến Tình Yêu, Hạnh Phúc Và Bình Yên\r\n', 9, 7, 100, 55000, 69000, 0.2, 1, 1, 9, 14, 2021, '2023-01-08 14:59:24'),
                                                                                                                                                                                              (82, 'Buông Bỏ Buồn Buông (Tái Bản 2019)\r\n', 17, 7, 100, 66000, 86000, 0.2, 1, 1, 1, 7, 2022, '2023-01-08 15:02:11'),
                                                                                                                                                                                              (83, 'Ta Vui Đời Sẽ Vui\r\n', 6, 7, 100, 70000, 89000, 0.2, 1, 1, 20, 15, 2021, '2023-01-08 15:04:12'),
                                                                                                                                                                                              (86, 'Nhà Máy Sản Xuất Niềm Vui\r\n', 6, 7, 100, 44000, 55000, 0.2, 1, 1, 8, 12, 2020, '2023-01-08 15:07:00'),
                                                                                                                                                                                              (200, 'Lập Trình Hướng Đối Tượng Với Java', 23, 12, 118, 55000, 82000, 0.1, 0, 1, 2, 2, 2022, '2026-06-29 01:06:51'),
                                                                                                                                                                                              (201, 'Cơ Sở Dữ Liệu - Lý Thuyết Và Thực Hành', 23, 12, 100, 60000, 89000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (202, 'Mạng Máy Tính - Nguyên Lý Và Ứng Dụng', 23, 12, 80, 65000, 95000, 0.1, 0, 1, 2, 2, 2020, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (203, 'Cấu Trúc Dữ Liệu Và Giải Thuật', 23, 12, 110, 58000, 85000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (204, 'Hệ Điều Hành', 23, 12, 75, 62000, 92000, 0.1, 0, 1, 2, 2, 2020, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (205, 'Kỹ Thuật Điện Tử (Tái Bản 2021)', 23, 12, 90, 68000, 98000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (206, 'Mạch Điện - Lý Thuyết Và Bài Tập', 23, 12, 85, 55000, 82000, 0.1, 0, 1, 2, 2, 2020, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (207, 'Sức Bền Vật Liệu (Tái Bản 2022)', 23, 12, 100, 72000, 105000, 0.1, 0, 1, 2, 2, 2022, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (208, 'Cơ Học Kỹ Thuật', 23, 12, 80, 68000, 99000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (209, 'Kinh Tế Vi Mô (Tái Bản 2022)', 23, 12, 150, 52000, 78000, 0.1, 0, 1, 2, 2, 2022, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (210, 'Kinh Tế Vĩ Mô (Tái Bản 2022)', 23, 12, 140, 52000, 78000, 0.1, 0, 1, 2, 2, 2022, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (211, 'Quản Trị Kinh Doanh - Lý Thuyết Và Tình Huống', 23, 12, 95, 65000, 95000, 0.1, 0, 1, 2, 2, 2020, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (212, 'Marketing Căn Bản (Philip Kotler - Bản Dịch)', 23, 12, 120, 58000, 85000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (213, 'Tài Chính Doanh Nghiệp (Tái Bản 2021)', 23, 12, 89, 68000, 99000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:06:04'),
                                                                                                                                                                                              (214, 'Phân Tích Tài Chính', 23, 12, 75, 62000, 92000, 0.1, 0, 1, 2, 2, 2020, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (215, 'Nguyên Lý Kế Toán (Tái Bản 2022)', 23, 12, 130, 55000, 82000, 0.1, 0, 1, 2, 2, 2022, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (216, 'Giải Phẫu Học Người (Tập 1)', 23, 12, 60, 145000, 210000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (217, 'Sinh Lý Học Y Khoa (Tái Bản 2020)', 23, 12, 55, 135000, 195000, 0.1, 0, 1, 2, 2, 2020, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (218, 'Dược Lý Học (Tái Bản 2022)', 23, 12, 65, 125000, 185000, 0.1, 0, 1, 2, 2, 2022, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (219, 'Hóa Học Dược (Tập 1)', 23, 12, 50, 98000, 145000, 0.1, 0, 1, 2, 2, 2020, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (220, 'Giáo Trình Đại Số Tuyến Tính', 23, 12, 110, 48000, 72000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (221, 'Giải Tích 1 (Tái Bản 2021)', 23, 12, 120, 52000, 78000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (222, 'Vật Lý Đại Cương - Tập 1 (Cơ Nhiệt)', 23, 12, 200, 45000, 68000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (223, 'Vật Lý Đại Cương - Tập 2 (Điện Từ - Quang)', 23, 12, 180, 45000, 68000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (224, 'Hóa Học Đại Cương (Tái Bản 2022)', 23, 12, 180, 48000, 72000, 0.1, 0, 1, 2, 2, 2022, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (225, 'Sinh Học Tế Bào (Tái Bản 2021)', 23, 12, 70, 68000, 99000, 0.1, 0, 1, 2, 2, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (226, 'Giáo Trình Triết Học Mác - Lênin (Bộ GD&ĐT 2021)', 23, 12, 500, 28000, 42000, 0.05, 0, 1, 2, 8, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (227, 'Giáo Trình Kinh Tế Chính Trị Mác - Lênin (Bộ GD&ĐT 2021)', 23, 12, 480, 28000, 42000, 0.05, 0, 1, 2, 8, 2021, '2026-06-29 01:05:28'),
                                                                                                                                                                                              (228, 'Giáo Trình Lịch Sử Đảng Cộng Sản Việt Nam (Bộ GD&ĐT 2021)', 23, 12, 450, 25000, 38000, 0.05, 0, 1, 2, 8, 2021, '2026-06-29 01:05:28');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `book_details`
--

CREATE TABLE `book_details` (
                                `id_book` int(11) NOT NULL,
                                `isbn` varchar(200) NOT NULL,
                                `year` int(11) DEFAULT NULL,
                                `weight` double DEFAULT NULL,
                                `size` varchar(20) DEFAULT NULL,
                                `page` int(11) DEFAULT NULL,
                                `language` varchar(10) DEFAULT NULL,
                                `description` text DEFAULT NULL,
                                `extract` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `book_details`
--

INSERT INTO `book_details` (`id_book`, `isbn`, `year`, `weight`, `size`, `page`, `language`, `description`, `extract`) VALUES
                                                                                                                           (1, 'ISBN 978-604-973-896-8	', 2022, 200, '20.5 x 13 x 0.5', 200, 'Tiếng Việt', ' Người nhân sự, từng việc họ làm dù thầm lặng hay rầm rộ, đều đóng góp rất lớn vào thành tích và thành tựu của mỗi công ty\r\n\r\nNgười làm nhân sự như tay chân của ông chủ, luôn cần đứng từ góc độ công ty để ra quyết định, tốt cho việc chung. Mặt khác, từng quyền lợi cho mỗi nhân viên cũng cần dược đảm bảo, để mọi thành viên trong công ty giữ vững tinh thần say mê, cống hiến.\r\n\r\nCó những nguyên tắc và tâm thái nào giúp người làm nhân sự duy trì trật tự, giúp mọi hoạt động diễn ra nhịp nhàng, ăn khớp? Bi quyết chính là ÁNH MẮT XA, CUỘC ĐỜI GẦN – nhìn xa trông rộng mà vẫn nắm được tiểu tiết chi li Tất cả sẽ được chia sẻ trong cuốn sách này.\r\n\r\nGIỚI THIỆU VỀ TÁC GIẢ\r\n\r\nTác giả Trần Ánh Phương hiện đang là chủ doanh nghiệp. Mới ra trường, chị làm nghề nhân sự. Công việc ứng xử với con người rất phức tạp. Nhờ thế, chị rèn được cho mình sự tinh tế, khéo léo, khôn ngoan\r\n\r\nChị cho rằng cuộc đời sự nghiệp chính là con người mình. Thành người cống hiến hay lu mờ, sống đời ý nghĩa hay vô nghĩa, ta có 30-40 năm làm việc để lựa chọn và cố gắng. Dù thế nào, hãy bước đi để khám phá và trưởng thành hơn.\r\n\r\nCuốn sách Ánh mắt xa cuộc đời gần chia sẻ những góc nhìn rất khác về nghề nhân sự, để những ai làm nhân sự luôn yêu nghề, hiểu nghề, và từ đấy trở thành người nhân sự nhìn xa đẩy doanh nghiệp tiến bước, nhìn gần giữ tinh thần nhân viên.\r\n\r\nMã hàng	3300000024820\r\nTên Nhà Cung Cấp	CÔNG TY CỔ PHẦN VĂN HÓA VÀ TRUYỀN THÔNG OOPSY\r\nTác giả	Trần Ánh Phương\r\nNXB	Thanh Niên\r\nNăm XB	2022\r\nNgôn Ngữ	Tiếng Việt\r\nTrọng lượng (gr)	200\r\nKích Thước Bao Bì	20 x 13.5 cm\r\nSố trang	200\r\nHình thức	Bìa Mềm\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Root Catalog bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nNgười nhân sự, từng việc họ làm dù thầm lặng hay rầm rộ, đều đóng góp rất lớn vào thành tích và thành tựu của mỗi công ty\r\n\r\nNgười làm nhân sự như tay chân của ông chủ, luôn cần đứng từ góc độ công ty để ra quyết định, tốt cho việc chung. Mặt khác, từng quyền lợi cho mỗi nhân viên cũng cần dược đảm bảo, để mọi thành viên trong công ty giữ vững tinh thần say mê, cống hiến.\r\n\r\nCó những nguyên tắc và tâm thái nào giúp người làm nhân sự duy trì trật tự, giúp mọi hoạt động diễn ra nhịp nhàng, ăn khớp? Bi quyết chính là ÁNH MẮT XA, CUỘC ĐỜI GẦN – nhìn xa trông rộng mà vẫn nắm được tiểu tiết chi li Tất cả sẽ được chia sẻ trong cuốn sách này', NULL),
                                                                                                                           (2, 'ISBN 978-604-1-19914-9', 2018, 200, '20.5 x 13 x 0.5', 195, 'Tiếng Việt', 'Người giàu không làm việc vì tiền. Họ bắt tiền làm việc cho họ. Chấp nhận thất bại là bước đầu của thành công? Quyền lực của sự lựa chọn! Những bài học không có trong nhà trường. Hãy bắt đầu từ hôm nay “để không có tiền vẫn tạo ra tiền”….', NULL),
                                                                                                                           (3, 'ISBN 978-604-1-20008-1', 2020, 200, '20.5 x 13 x 0.5', 192, 'Tiếng Việt', 'Những \"công dân toàn cầu\" mang những nét đặc trưng nào? Họ có sinh hoạt, làm việc, và hành xử theo các chuẩn mực khác biệt của riêng một cộng đồng mang đẳng cấp cao? Liệu có những hình mẫu nào để chúng ta tham khảo, từ đó tự rèn cho mình phong thái của một \"công dân toàn cầu\"? Và xa hơn nữa, một công dân của Vũ trụ? Bằng cách mô tả vừa rộng vừa sâu, vừa bao quát nhưng vẫn cung cấp nhiều ví dụ cụ thể, tác giả Phan Văn Trường mang đến một cách nhìn mới mẻ và sâu sắc về hình ảnh của những con người yêu thương đồng loại, trách nhiệm với địa cầu, và trân quý Vũ trụ mà chúng ta đang sống.\r\n\r\nMã hàng	8934974179221\r\nTên Nhà Cung Cấp	NXB Trẻ\r\nTác giả	Phan Văn Trường\r\nNXB	NXB Trẻ\r\nNăm XB	2022\r\nTrọng lượng (gr)	200\r\nKích Thước Bao Bì	23 x 15.5 cm\r\nSố trang	192\r\nHình thức	Bìa Mềm\r\nSản phẩm hiển thị trong	\r\nNXB Trẻ\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Phân Tích Kinh Tế bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nNhững \"công dân toàn cầu\" mang những nét đặc trưng nào? Họ có sinh hoạt, làm việc, và hành xử theo các chuẩn mực khác biệt của riêng một cộng đồng mang đẳng cấp cao? Liệu có những hình mẫu nào để chúng ta tham khảo, từ đó tự rèn cho mình phong thái của một \"công dân toàn cầu\"? Và xa hơn nữa, một công dân của Vũ trụ? Bằng cách mô tả vừa rộng vừa sâu, vừa bao quát nhưng vẫn cung cấp nhiều ví dụ cụ thể, tác giả Phan Văn Trường mang đến một cách nhìn mới mẻ và sâu sắc về hình ảnh của những con người yêu thương đồng loại, trách nhiệm với địa cầu, và trân quý Vũ trụ mà chúng ta đang sống.', NULL),
                                                                                                                           (4, 'ISBN 978-604-377-367-5', 2020, 450, '20.5 x 13 x 0.5', 408, 'Tiếng Việt', 'Muôn Kiếp Nhân Sinh - Many Times, Many Lives\r\n\r\nGiáo sư John Vũ – Nguyên Phong và những câu chuyện chưa từng có về tiền kiếp, khám phá luật Nhân quả, Luân hồi.\r\n\r\n“Muôn kiếp nhân sinh” là tác phẩm do Giáo sư John Vũ - Nguyên Phong viết từ năm 2017 và hoàn tất đầu năm 2020 ghi lại những câu chuyện, trải nghiệm tiền kiếp kỳ lạ từ nhiều kiếp sống của người bạn tâm giao lâu năm, ông Thomas – một nhà kinh doanh tài chính nổi tiếng ở New York. Những câu chuyện chưa từng tiết lộ này sẽ giúp mọi người trên thế giới chiêm nghiệm, khám phá các quy luật về luật Nhân quả và Luân hồi của vũ trụ giữa lúc trái đất đang gặp nhiều tai ương, biến động, khủng hoảng từng ngày.\r\n\r\n“Muôn kiếp nhân sinh” là một bức tranh lớn với vô vàn mảnh ghép cuộc đời, là một cuốn phim đồ sộ, sống động về những kiếp sống huyền bí, trải dài từ nền văn minh Atlantis hùng mạnh đến vương quốc Ai Cập cổ đại của các Pharaoh quyền uy, đến Hợp Chủng Quốc Hoa Kỳ ngày nay.\r\n\r\n“Muôn kiếp nhân sinh”cung cấp cho bạn đọc kiến thức mới mẻ, vô tận của nhân loại lần đầu được hé mở, cùng những phân tích uyên bác, tiên đoán bất ngờ về hiện tại và tương lai thế giới của những bậc hiền triết thông thái. Đời người tưởng chừng rất dài nhưng lại trôi qua rất nhanh, sinh vượng suy tử, mong manh như sóng nước. Luật nhân quả cực kỳ chính xác, chi tiết, phức tạp được thu thập qua nhiều đời, nhiều kiếp, liên hệ tương hỗ đan xen chặt chữ lẫn nhau, không ai có thể tính được tích đức này có thể trừ được nghiệp kia không, không ai có thể biết được khi nào nhân sẽ trổ quả. Nhưng, một khi đã gây ra nhân thì chắc chắn sẽ gặt quả - luật Nhân quả của vũ trụ trước giờ không bao giờ sai.\r\n\r\nLuật Luân hồi và Nhân quả đã tạo nhân duyên để người này gặp người kia. Gặp nhau có khi là duyên, có khi là nợ; gặp nhau có lúc để trả nợ, có lúc để nối lại duyên xưa. Có biết bao việc diễn ra trong đời, tưởng chừng như là ngẫu nhiên nhưng thật ra đã được sắp đặt từ trước. Luân hồi là một ngôi trường rộng lớn, nơi tất cả con người, tất cả sinh vật đều phải học bài học của riêng mình cho đến khi thật hoàn thiện mới thôi. Nếu không chịu học hay chưa học được trọn vẹn thì buộc phải học lại, chính xác theo quy luật của Nhân quả.\r\n\r\nThomas đã chia sẻ vì sao đã kể những câu chuyện riêng tư huyền bí này với Giáo sư John Vũ để thực hiện tác phẩm “Muôn kiếp nhân sinh”:\r\n\r\n “Hiện nay thế giới đang trải qua giai đoạn hỗn loạn, xáo trộn, mà thật ra thì mọi quốc gia đều đang gánh chịu những nghiệp quả mà họ đã gây ra trong quá khứ. Mỗi quốc gia, cũng như mọi cá nhân, đều có những nghiệp quả riêng do những nhân mà họ đã gây ra. Cá nhân thì có ‘biệt nghiệp‘ riêng của từng người, nhưng quốc gia thì có ‘cộng nghiệp‘ mà tất cả những người sống trong đó đều phải trả.\r\n\r\nThường thì con người, khi hành động, ít ai nghĩ đến hậu quả, nhưng một khi hậu quả xảy đến thì họ nghĩ gì, làm gì? Họ oán hận, trách trời, trách đất, trách những người chung quanh đã gây ra những hậu quả đó? Có mấy ai biết chiêm nghiệm, tự trách mình và thay đổi không?\r\n\r\nTôi mong chúng ta - những cánh bướm bé nhỏ rung động mong manh cũng có thể tạo nên những trận cuồng phong mãnh liệt để thức tỉnh mọi người.\r\n\r\nTương lai của mỗi con người, mỗi tổ chức, mỗi quốc gia và cả hành tinh này sẽ ra sao trong giai đoạn sắp tới là tùy thuộc vào thái độ ứng xử, nhìn nhận và thức tỉnh của từng cá nhân, từng tổ chức, từng quốc gia đó tạo nên. Nếu muốn thay đổi, cần khởi đầu bằng việc nhận thức, chuyển đổi tâm thức, lan tỏa yêu thương và chia sẻ sự hiểu biết từ mỗi người chúng ta trước.\r\n\r\nNhân quả đừng đợi thấy mới tin.\r\n\r\nNhân quả là bảng chỉ đường, giúp con người tìm về thiện lương“\r\n\r\nCuốn sách được xuất bản bằng tiếng Việt trước khi được chuyển nhượng bản quyền cho các quốc gia khác trên thế giới.\r\n\r\nVề tác giả\r\n\r\nTác giả Nguyên Phong (Vũ Văn Du) du học ở Mỹ từ năm 1968, tốt nghiệp cao học Sinh vật học, Điện toán. Ông từng là Kỹ sư trưởng, CIO của Tập đoàn Boeing của Mỹ, Viện trưởng Viện Công nghệ Sinh học Đại học Carnegie Mellon. Ông được mọi người biết tới là Giáo sư John Vu – Nhà khoa học uy tín về công nghệ thông tin. , CMMI và từng giảng dạy ở nhiều trường đại học trên thế giới.\r\n\r\n Nguyên Phong là bút danh của bộ sách văn hóa tâm linh được dịch, viết phóng tác từ trải nghiệm, tiềm thức và quá trình nghiên cứu, khám phá các giá trị tinh thần Đông phương. Ông đã viết phóng tác tác phẩm bất hủ Hành trình về Phương Đông năm 24 tuổi (1974). Các tác phẩm khác của Nguyên Phong được bạn đọc nhiều thế hệ yêu thích: Ngọc sáng trong hoa sen, Bên rặng tuyết sơn, Hoa sen trên tuyết, Hoa trôi trên sóng nước, Huyền thuật và các đạo sĩ Tây Tạng, Trở về từ xứ tuyết, Trở về từ cõi sáng, Minh triết trong đời sống, Đường mây qua xứ tuyết, Dấu chân trên cát, Đường mây trong cõi mộng, Đường mây trên đất hoa… và bộ sách dành cho sinh viên, thầy cô: Khởi hành, Kết nối, Bước ra thế giới, Kiến tạo thế hệ Việt Nam ưu việt, GS John Vu và lời khuyên dành cho thầy cô, GS John Vu và lời khuyên dành cho các bậc cha mẹ.\r\n\r\nMã hàng	8935086851760\r\nTên Nhà Cung Cấp	FIRST NEWS\r\nTác giả	Nguyên Phong\r\nNXB	NXB Tổng Hợp TPHCM\r\nNăm XB	2020\r\nNgôn Ngữ	Tiếng Việt\r\nTrọng lượng (gr)	450\r\nKích Thước Bao Bì	20.5 x 14 cm\r\nSố trang	408\r\nHình thức	Bìa Mềm\r\nSản phẩm hiển thị trong	\r\nFIRST NEWS\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Tôn Giáo bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nMuôn Kiếp Nhân Sinh - Many Times, Many Lives\r\n\r\nGiáo sư John Vũ – Nguyên Phong và những câu chuyện chưa từng có về tiền kiếp, khám phá luật Nhân quả, Luân hồi.\r\n\r\n“Muôn kiếp nhân sinh” là tác phẩm do Giáo sư John Vũ - Nguyên Phong viết từ năm 2017 và hoàn tất đầu năm 2020 ghi lại những câu chuyện, trải nghiệm tiền kiếp kỳ lạ từ nhiều kiếp sống của người bạn tâm giao lâu năm, ông Thomas – một nhà kinh doanh tài chính nổi tiếng ở New York. Những câu chuyện chưa từng tiết lộ này sẽ giúp mọi người trên thế giới chiêm nghiệm, khám phá các quy luật về luật Nhân quả và Luân hồi của vũ trụ giữa lúc trái đất đang gặp nhiều tai ương, biến động, khủng hoảng từng ngày.\r\n\r\n“Muôn kiếp nhân sinh” là một bức tranh lớn với vô vàn mảnh ghép cuộc đời, là một cuốn phim đồ sộ, sống động về những kiếp sống huyền bí, trải dài từ nền văn minh Atlantis hùng mạnh đến vương quốc Ai Cập cổ đại của các Pharaoh quyền uy, đến Hợp Chủng Quốc Hoa Kỳ ngày nay.\r\n\r\n“Muôn kiếp nhân sinh”cung cấp cho bạn đọc kiến thức mới mẻ, vô tận của nhân loại lần đầu được hé mở, cùng những phân tích uyên bác, tiên đoán bất ngờ về hiện tại và tương lai thế giới của những bậc hiền triết thông thái. Đời người tưởng chừng rất dài nhưng lại trôi qua rất nhanh, sinh vượng suy tử, mong manh như sóng nước. Luật nhân quả cực kỳ chính xác, chi tiết, phức tạp được thu thập qua nhiều đời, nhiều kiếp, liên hệ tương hỗ đan xen chặt chữ lẫn nhau, không ai có thể tính được tích đức này có thể trừ được nghiệp kia không, không ai có thể biết được khi nào nhân sẽ trổ quả. Nhưng, một khi đã gây ra nhân thì chắc chắn sẽ gặt quả - luật Nhân quả của vũ trụ trước giờ không bao giờ sai.\r\n\r\nLuật Luân hồi và Nhân quả đã tạo nhân duyên để người này gặp người kia. Gặp nhau có khi là duyên, có khi là nợ; gặp nhau có lúc để trả nợ, có lúc để nối lại duyên xưa. Có biết bao việc diễn ra trong đời, tưởng chừng như là ngẫu nhiên nhưng thật ra đã được sắp đặt từ trước. Luân hồi là một ngôi trường rộng lớn, nơi tất cả con người, tất cả sinh vật đều phải học bài học của riêng mình cho đến khi thật hoàn thiện mới thôi. Nếu không chịu học hay chưa học được trọn vẹn thì buộc phải học lại, chính xác theo quy luật của Nhân quả.\r\n\r\nThomas đã chia sẻ vì sao đã kể những câu chuyện riêng tư huyền bí này với Giáo sư John Vũ để thực hiện tác phẩm “Muôn kiếp nhân sinh”:\r\n\r\n “Hiện nay thế giới đang trải qua giai đoạn hỗn loạn, xáo trộn, mà thật ra thì mọi quốc gia đều đang gánh chịu những nghiệp quả mà họ đã gây ra trong quá khứ. Mỗi quốc gia, cũng như mọi cá nhân, đều có những nghiệp quả riêng do những nhân mà họ đã gây ra. Cá nhân thì có ‘biệt nghiệp‘ riêng của từng người, nhưng quốc gia thì có ‘cộng nghiệp‘ mà tất cả những người sống trong đó đều phải trả.\r\n\r\nThường thì con người, khi hành động, ít ai nghĩ đến hậu quả, nhưng một khi hậu quả xảy đến thì họ nghĩ gì, làm gì? Họ oán hận, trách trời, trách đất, trách những người chung quanh đã gây ra những hậu quả đó? Có mấy ai biết chiêm nghiệm, tự trách mình và thay đổi không?\r\n\r\nTôi mong chúng ta - những cánh bướm bé nhỏ rung động mong manh cũng có thể tạo nên những trận cuồng phong mãnh liệt để thức tỉnh mọi người.\r\n\r\nTương lai của mỗi con người, mỗi tổ chức, mỗi quốc gia và cả hành tinh này sẽ ra sao trong giai đoạn sắp tới là tùy thuộc vào thái độ ứng xử, nhìn nhận và thức tỉnh của từng cá nhân, từng tổ chức, từng quốc gia đó tạo nên. Nếu muốn thay đổi, cần khởi đầu bằng việc nhận thức, chuyển đổi tâm thức, lan tỏa yêu thương và chia sẻ sự hiểu biết từ mỗi người chúng ta trước.\r\n\r\nNhân quả đừng đợi thấy mới tin.\r\n\r\nNhân quả là bảng chỉ đường, giúp con người tìm về thiện lương“\r\n\r\nCuốn sách được xuất bản bằng tiếng Việt trước khi được chuyển nhượng bản quyền cho các quốc gia khác trên thế giới.', NULL),
                                                                                                                           (5, 'ISBN 978-604-307-151-1', 2021, 300, '20.5 x 13 x 0.5', 256, 'Tiếng Việt', 'Hành Trình Về Phương Đông, một trong những tác phẩm đương đại hay và độc đáo nhất về văn hóa phương Đông vừa tái ngộ bạn đọc trong một diện mạo hoàn toàn mới, sang trọng và ấn tượng. Đây là ấn bản có lượng phát hành ấn tượng, hơn 40.000 bản tại Việt Nam chỉ trong vài năm trở lại đây.\r\n\r\nHành Trình Về Phương Đông kể về những trải nghiệm của một đoàn khoa học gồm các chuyên gia hàng đầu của Hội Khoa Học Hoàng Gia Anh được cử sang Ấn Độ nghiên cứu về huyền học và những khả năng siêu nhiên của con người. Suốt hai năm trời rong ruổi khắp các đền chùa Ấn Độ, diện kiến nhiều pháp thuật, nhiều cảnh mê tín dị đoan, thậm chí lừa đào… của nhiều pháp sư, đạo sĩ… họ được tiếp xúc với những vị chân tu thông thái sống ẩn dật ở thị trấn hay trên rặng Tuyết Sơn. Nhờ thế, họ được chứng kiến, trải nghiệm, hiểu biết sâu sắc về các khoa học cổ xức và bí truyền của văn hóa Ấn Độ như yoga, thiền định, thuật chiêm tinh, các phép dưỡng sinh và chữa bệnh, những kiến thức về nhân duyên, nghiệp báo, luật nhân quả, cõi sống và cõi chết…\r\n\r\nCuốn sách là một phần trong bộ hồi ký nổi tiếng của giáo sư Blair T. Spalding (1857 - 1953), “Life and Teaching of the Masters of the Far East” (xuất bản năm 1953). Bộ sách có tất cả sáu quyển, ghi nhận đầy đủ về cuộc hành trình gay go nhưng lý thú và tràn đầy sự huyền bí ở Ấn Độ, Tây Tạng, Trung Hoa và Ba Tư. Ba quyển đầu ghi lại những cuộc thám hiểm của phái đoàn gồm các nhà khoa học hàng đầu của Hoàng gia Anh đi từ Anh quốc sang Ấn Độ, các cuộc gặp gỡ giữa phái đoàn và những vị thầy tâm linh sống ở châu Á và dãy Hy Mã Lạp Sơn. Ba quyển sau là những ghi nhận riêng của giáo sư Spalding về các cuộc hành trình, sự trao đổi kiến thức giữa phái đoàn và các vị thầy tâm linh, cùng bản tường trình của phái đoàn đã đưa đến những cuộc tranh luận sôi nổi. Cuối cùng thì ba người trong phái đoàn đã trở lại Ấn Độ sống đời ẩn sĩ.\r\n\r\nXuất bản lần đầu tiên tại NXB Adyar Ấn Độ năm 1924, Hành Trình Về Phương Đông đã gây ra một dư luận tranh cãi không chỉ ở nước Anh mà ở cả châu Âu và Mỹ. Sau đó, vì tự ái và sĩ diện, chính phủ Anh cấm phát hành cuốn sách này ở Anh Quốc, rồi chiến tranh thế giới lần thứ II xảy ra, cuốn sách đã không được tái bản ở bất kỳ NXB nào khác trên thế giới. Mãi đến năm 2009, NXB Booksurge Hoa Kỳ đã tìm mọi cách liên lạc với dịch giả Nguyên Phong để xin phép chuyển ngữ cuốn sách tiếng Việt này.  \r\n\r\nCó thể nói, Hành Trình Về Phương Đông là một trong những cuốn sách có số phận khá ly kỳ, một phần vì dịch giả của nó cũng bí ẩn không kém. Không xuất hiện trên truyền thông, mà chỉ sống ẩn danh nên có rất nhiều người không biết về Nguyên Phong. Và đó chính là bút danh của Giáo sư John Vu (tên thật là Vũ Văn Du). Ông là tác giả, dịch giả nổi tiếng của các tác phẩm về văn học, tâm linh phương Đông, về giáo dục, và công nghệ. Ông đã chuyển thể và phóng tác rất thành công nhiều tác phẩm của các học giả phương Tây sau quá trình tìm hiểu và khám phá các giá trị văn hóa phương Đông. Trong số đó tác phẩm phóng tác nổi tiếng nhất là Hành Trình Về Phương Đông; ngoài ra, tại Việt Nam, First News đã xuất bản nhiều tác phẩm phóng tác nổi tiếng của dịch giả Nguyên Phong như: Ngọc sáng trong hoa sen, Bên rặng Tuyết Sơn, Hoa trôi trên sóng nước, Minh triết trong đời sống, Đường mây qua xứ tuyết…\r\n\r\nMã hàng	8935086854495\r\nTên Nhà Cung Cấp	FIRST NEWS\r\nTác giả	Baird T Spalding\r\nNgười Dịch	Nguyên Phong\r\nNXB	NXB Thế Giới\r\nNăm XB	2021\r\nNgôn Ngữ	Tiếng Việt\r\nTrọng lượng (gr)	300\r\nKích Thước Bao Bì	20.5 x 14.5 cm\r\nSố trang	256\r\nHình thức	Bìa Mềm\r\nSản phẩm hiển thị trong	\r\nFIRST NEWS\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Tôn Giáo bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nHành Trình Về Phương Đông, một trong những tác phẩm đương đại hay và độc đáo nhất về văn hóa phương Đông vừa tái ngộ bạn đọc trong một diện mạo hoàn toàn mới, sang trọng và ấn tượng. Đây là ấn bản có lượng phát hành ấn tượng, hơn 40.000 bản tại Việt Nam chỉ trong vài năm trở lại đây.\r\n\r\nHành Trình Về Phương Đông kể về những trải nghiệm của một đoàn khoa học gồm các chuyên gia hàng đầu của Hội Khoa Học Hoàng Gia Anh được cử sang Ấn Độ nghiên cứu về huyền học và những khả năng siêu nhiên của con người. Suốt hai năm trời rong ruổi khắp các đền chùa Ấn Độ, diện kiến nhiều pháp thuật, nhiều cảnh mê tín dị đoan, thậm chí lừa đào… của nhiều pháp sư, đạo sĩ… họ được tiếp xúc với những vị chân tu thông thái sống ẩn dật ở thị trấn hay trên rặng Tuyết Sơn. Nhờ thế, họ được chứng kiến, trải nghiệm, hiểu biết sâu sắc về các khoa học cổ xức và bí truyền của văn hóa Ấn Độ như yoga, thiền định, thuật chiêm tinh, các phép dưỡng sinh và chữa bệnh, những kiến thức về nhân duyên, nghiệp báo, luật nhân quả, cõi sống và cõi chết…\r\n\r\nCuốn sách là một phần trong bộ hồi ký nổi tiếng của giáo sư Blair T. Spalding (1857 - 1953), “Life and Teaching of the Masters of the Far East” (xuất bản năm 1953). Bộ sách có tất cả sáu quyển, ghi nhận đầy đủ về cuộc hành trình gay go nhưng lý thú và tràn đầy sự huyền bí ở Ấn Độ, Tây Tạng, Trung Hoa và Ba Tư. Ba quyển đầu ghi lại những cuộc thám hiểm của phái đoàn gồm các nhà khoa học hàng đầu của Hoàng gia Anh đi từ Anh quốc sang Ấn Độ, các cuộc gặp gỡ giữa phái đoàn và những vị thầy tâm linh sống ở châu Á và dãy Hy Mã Lạp Sơn. Ba quyển sau là những ghi nhận riêng của giáo sư Spalding về các cuộc hành trình, sự trao đổi kiến thức giữa phái đoàn và các vị thầy tâm linh, cùng bản tường trình của phái đoàn đã đưa đến những cuộc tranh luận sôi nổi. Cuối cùng thì ba người trong phái đoàn đã trở lại Ấn Độ sống đời ẩn sĩ.\r\n\r\nXuất bản lần đầu tiên tại NXB Adyar Ấn Độ năm 1924, Hành Trình Về Phương Đông đã gây ra một dư luận tranh cãi không chỉ ở nước Anh mà ở cả châu Âu và Mỹ. Sau đó, vì tự ái và sĩ diện, chính phủ Anh cấm phát hành cuốn sách này ở Anh Quốc, rồi chiến tranh thế giới lần thứ II xảy ra, cuốn sách đã không được tái bản ở bất kỳ NXB nào khác trên thế giới. Mãi đến năm 2009, NXB Booksurge Hoa Kỳ đã tìm mọi cách liên lạc với dịch giả Nguyên Phong để xin phép chuyển ngữ cuốn sách tiếng Việt này.  \r\n\r\nCó thể nói, Hành Trình Về Phương Đông là một trong những cuốn sách có số phận khá ly kỳ, một phần vì dịch giả của nó cũng bí ẩn không kém. Không xuất hiện trên truyền thông, mà chỉ sống ẩn danh nên có rất nhiều người không biết về Nguyên Phong. Và đó chính là bút danh của Giáo sư John Vu (tên thật là Vũ Văn Du). Ông là tác giả, dịch giả nổi tiếng của các tác phẩm về văn học, tâm linh phương Đông, về giáo dục, và công nghệ. Ông đã chuyển thể và phóng tác rất thành công nhiều tác phẩm của các học giả phương Tây sau quá trình tìm hiểu và khám phá các giá trị văn hóa phương Đông. Trong số đó tác phẩm phóng tác nổi tiếng nhất là Hành Trình Về Phương Đông; ngoài ra, tại Việt Nam, First News đã xuất bản nhiều tác phẩm phóng tác nổi tiếng của dịch giả Nguyên Phong như: Ngọc sáng trong hoa sen, Bên rặng Tuyết Sơn, Hoa trôi trên sóng nước, Minh triết trong đời sống, Đường mây qua xứ tuyết…', NULL),
                                                                                                                           (6, 'ISBN 978-604-56-6125-3', 2020, 450, '20.5 x 13 x 0.5', 416, 'Tiếng Việt', 'Từ Vi Vũ hơi mắc bệnh sạch sẽ, có chút bỉ ổi, có chút mặt dày, tuy nhiên trước mặt người ngoài anh luôn hào hoa phong nhã, sống tách biệt, độc lập, lạnh lùng mà kiêu ngạo, lạnh lùng mà xa cách, trong sự xa cách ấy lại toát lên sự cao quý. Nhưng cứ về đến nhà, anh liền biến thành quý ông “thích cởi”, luôn miệng kêu: “Tắm, tắm, tắm! Cố Thanh Khê, em có muốn đến chà đạp anh không?”\r\n\r\nCố Thanh Khê luôn nghĩ, con người này còn có thể bỉ ổi hơn được nữa không?\r\n\r\nNếu không sẽ là:\r\n\r\n“Vợ ơi, mau nấu cơm cho anh, yêu cầu hợp pháp đấy!”\r\n\r\n“Vợ ơi, hôm nay đi xem phim nhé! Yêu cầu hợp pháp đấy!”\r\n\r\n“Thanh Khê, hát tặng anh một bài đi, yêu cầu hợp pháp đấy!”\r\n\r\nMỗi lần như thế, bạn Cố Thanh Khê lại phải cố kiềm chế không xử lý anh một cách phi pháp.\r\n\r\nHạnh phúc là gì?\r\n\r\nHạnh phúc là mười ba năm trước, cứ tan học về, có một cậu bé lại đi hình chữ S đến trước mặt bạn.\r\n\r\nMười ba năm sau, vẫn cậu bé đó ôm bạn vào lòng, thủ thỉ: “Cố Thanh Khê, cả tuổi thanh xuân của anh đều dành hết cho em, thế nên em phải có trách nhiệm với anh đấy!”\r\n\r\nMã hàng	8935212349215\r\nTên Nhà Cung Cấp	Đinh Tị\r\nTác giả	Cố Tây Tước\r\nNgười Dịch	Hà Giang\r\nNXB	NXB Phụ Nữ\r\nNăm XB	2020\r\nTrọng lượng (gr)	450\r\nKích Thước Bao Bì	20.5 x 14.5 cm\r\nSố trang	416\r\nHình thức	Bìa Mềm\r\nSản phẩm hiển thị trong	\r\nĐinh Tị\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Ngôn Tình bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nTừ Vi Vũ hơi mắc bệnh sạch sẽ, có chút bỉ ổi, có chút mặt dày, tuy nhiên trước mặt người ngoài anh luôn hào hoa phong nhã, sống tách biệt, độc lập, lạnh lùng mà kiêu ngạo, lạnh lùng mà xa cách, trong sự xa cách ấy lại toát lên sự cao quý. Nhưng cứ về đến nhà, anh liền biến thành quý ông “thích cởi”, luôn miệng kêu: “Tắm, tắm, tắm! Cố Thanh Khê, em có muốn đến chà đạp anh không?”\r\n\r\nCố Thanh Khê luôn nghĩ, con người này còn có thể bỉ ổi hơn được nữa không?\r\n\r\nNếu không sẽ là:\r\n\r\n“Vợ ơi, mau nấu cơm cho anh, yêu cầu hợp pháp đấy!”\r\n\r\n“Vợ ơi, hôm nay đi xem phim nhé! Yêu cầu hợp pháp đấy!”\r\n\r\n“Thanh Khê, hát tặng anh một bài đi, yêu cầu hợp pháp đấy!”\r\n\r\nMỗi lần như thế, bạn Cố Thanh Khê lại phải cố kiềm chế không xử lý anh một cách phi pháp.\r\n\r\nHạnh phúc là gì?\r\n\r\nHạnh phúc là mười ba năm trước, cứ tan học về, có một cậu bé lại đi hình chữ S đến trước mặt bạn.\r\n\r\nMười ba năm sau, vẫn cậu bé đó ôm bạn vào lòng, thủ thỉ: “Cố Thanh Khê, cả tuổi thanh xuân của anh đều dành hết cho em, thế nên em phải có trách nhiệm với anh đấy!”', NULL),
                                                                                                                           (7, 'ISBN 978-604-976-592-6', 2019, 420, '20.5 x 13 x 0.5', 419, 'Tiếng Việt', 'Nào, hãy mở cuốn sách này ra. Bạn phải làm quen ngay với bố Atticus của hai anh em - Jem và Scout, ông bố luật sư có một cách riêng, để những đứa trẻ của mình cứng cáp và vững vàng hơn khi đón nhận những bức xúc không sao hiểu nổi trong cuộc sống. Bạn sẽ nhớ rất lâu người đàn ông thích trốn trong nhà Boo Radley, kẻ bị đám đông coi là lập dị đã chọn một cách rất riêng để gửi những món quà nhỏ cho Jem và Scout, và khi chúng lâm nguy, đã đột nhiên xuất hiện để che chở. Và tất nhiên, bạn không thể bỏ qua anh chàng Tom Robinson, kẻ bị kết án tử hình vì tội hãm hiếp một cô gái da trắng, sự thật thà và suy nghĩ quá đỗi đơn giản của anh lại dẫn đến một cái kết hết sức đau lòng, chỉ vì lý do anh là một người da đen.\r\n\r\nCho dù được kể dưới góc nhìn của một cô bé, cuốn sách Giết con chim nhạikhông né tránh bất kỳ vấn đề nào, gai góc hay lớn lao, sâu xa hay phức tạp: nạn phân biệt chủng tộc, những định kiến khắt khe, sự trọng nam khinh nữ… Góc nhìn trẻ thơ là một dấu ấn đậm nét và cũng là đặc sắc trong Giết con chim nhại. Trong sáng, hồn nhiên và đầy cảm xúc, những câu chuyện tưởng như chẳng có gì to tát gieo vào người đọc hạt mầm yêu thương.\r\n\r\nGần 50 năm từ ngày đầu ra mắt, Giết con chim nhại, tác phẩm đầu tay và cũng là cuối cùng của nữ nhà văn Mỹ Harper Lee vẫn đầy sức hút với độc giả ở nhiều lứa tuổi. Thông điệp yêu thương trải khắp các chương sách là một trong những lý do khiến Giết con chim nhại giữ sức sống lâu bền của mình trong trái tim độc giả ở nhiều quốc gia, nhiều thế hệ. Những độc giả nhí tìm cho mình các trò nghịch ngợm và cách nhìn dí dỏm về thế giới xung quanh. Người lớn lại tìm ra điều thú vị sâu xa trong tình cha con nhà Atticus, và đặc biệt là tình người trong cuộc sống, như bé Scout quả quyết nói “em nghĩ chỉ có một hạng người. Đó là người”.\r\n\r\nMã hàng	8935235220423\r\nTên Nhà Cung Cấp	Nhã Nam\r\nTác giả	Harper Lee\r\nNgười Dịch	Huỳnh Kim Anh, Phạm Viêm Phương.\r\nNXB	NXB Văn Học\r\nNăm XB	2019\r\nTrọng lượng (gr)	420\r\nKích Thước Bao Bì	14 x 20.5\r\nSố trang	419\r\nHình thức	Bìa Mềm\r\nSản phẩm hiển thị trong	\r\nNhã Nam\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Tác Phẩm Kinh Điển bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nNào, hãy mở cuốn sách này ra. Bạn phải làm quen ngay với bố Atticus của hai anh em - Jem và Scout, ông bố luật sư có một cách riêng, để những đứa trẻ của mình cứng cáp và vững vàng hơn khi đón nhận những bức xúc không sao hiểu nổi trong cuộc sống. Bạn sẽ nhớ rất lâu người đàn ông thích trốn trong nhà Boo Radley, kẻ bị đám đông coi là lập dị đã chọn một cách rất riêng để gửi những món quà nhỏ cho Jem và Scout, và khi chúng lâm nguy, đã đột nhiên xuất hiện để che chở. Và tất nhiên, bạn không thể bỏ qua anh chàng Tom Robinson, kẻ bị kết án tử hình vì tội hãm hiếp một cô gái da trắng, sự thật thà và suy nghĩ quá đỗi đơn giản của anh lại dẫn đến một cái kết hết sức đau lòng, chỉ vì lý do anh là một người da đen.\r\n\r\nCho dù được kể dưới góc nhìn của một cô bé, cuốn sách Giết con chim nhạikhông né tránh bất kỳ vấn đề nào, gai góc hay lớn lao, sâu xa hay phức tạp: nạn phân biệt chủng tộc, những định kiến khắt khe, sự trọng nam khinh nữ… Góc nhìn trẻ thơ là một dấu ấn đậm nét và cũng là đặc sắc trong Giết con chim nhại. Trong sáng, hồn nhiên và đầy cảm xúc, những câu chuyện tưởng như chẳng có gì to tát gieo vào người đọc hạt mầm yêu thương.\r\n\r\nGần 50 năm từ ngày đầu ra mắt, Giết con chim nhại, tác phẩm đầu tay và cũng là cuối cùng của nữ nhà văn Mỹ Harper Lee vẫn đầy sức hút với độc giả ở nhiều lứa tuổi. Thông điệp yêu thương trải khắp các chương sách là một trong những lý do khiến Giết con chim nhại giữ sức sống lâu bền của mình trong trái tim độc giả ở nhiều quốc gia, nhiều thế hệ. Những độc giả nhí tìm cho mình các trò nghịch ngợm và cách nhìn dí dỏm về thế giới xung quanh. Người lớn lại tìm ra điều thú vị sâu xa trong tình cha con nhà Atticus, và đặc biệt là tình người trong cuộc sống, như bé Scout quả quyết nói “em nghĩ chỉ có một hạng người. Đó là người”.', NULL),
                                                                                                                           (8, 'ISBN 978-604-69-4850-6', 2020, 220, '20.5 x 13 x 0.5', 227, 'Tiếng Việt', 'Tất cả những trải nghiệm trong chuyến phiêu du theo đuổi vận mệnh của mình đã giúp Santiago thấu hiểu được ý nghĩa sâu xa nhất của hạnh phúc, hòa hợp với vũ trụ và con người. \r\n\r\nTiểu thuyết Nhà giả kim của Paulo Coelho như một câu chuyện cổ tích giản dị, nhân ái, giàu chất thơ, thấm đẫm những minh triết huyền bí của phương Đông. Trong lần xuất bản đầu tiên tại Brazil vào năm 1988, sách chỉ bán được 900 bản. Nhưng, với số phận đặc biệt của cuốn sách dành cho toàn nhân loại, vượt ra ngoài biên giới quốc gia, Nhà giả kim đã làm rung động hàng triệu tâm hồn, trở thành một trong những cuốn sách bán chạy nhất mọi thời đại, và có thể làm thay đổi cuộc đời người đọc.\r\n\r\n“Nhưng nhà luyện kim đan không quan tâm mấy đến những điều ấy. Ông đã từng thấy nhiều người đến rồi đi, trong khi ốc đảo và sa mạc vẫn là ốc đảo và sa mạc. Ông đã thấy vua chúa và kẻ ăn xin đi qua biển cát này, cái biển cát thường xuyên thay hình đổi dạng vì gió thổi nhưng vẫn mãi mãi là biển cát mà ông đã biết từ thuở nhỏ. Tuy vậy, tự đáy lòng mình, ông không thể không cảm thấy vui trước hạnh phúc của mỗi người lữ khách, sau bao ngày chỉ có cát vàng với trời xanh nay được thấy chà là xanh tươi hiện ra trước mắt. ‘Có thể Thượng đế tạo ra sa mạc chỉ để cho con người biết quý trọng cây chà là,’ ông nghĩ.”\r\n\r\n- Trích Nhà giả kim\r\n\r\nNhận định\r\n\r\n“Sau Garcia Márquez, đây là nhà văn Mỹ Latinh được đọc nhiều nhất thế giới.” - The Economist, London, Anh\r\n\r\n \r\n\r\n“Santiago có khả năng cảm nhận bằng trái tim như Hoàng tử bé của Saint-Exupéry.” - Frankfurter Allgemeine Zeitung, Đức', NULL),
                                                                                                                           (9, 'ISBN 978-604-55-6124-9', 2020, 360, '20.5 x 13 x 0.5', 302, 'Tiếng Việt', '1cm giữa anh và em – cuốn tản văn sâu lắng khắc họa tình yêu dưới lăng kính đầy mới mẻ và dễ thương là cuốn cẩm nang cần có, để những kẻ dại khờ trong tình yêu học cách tiến thêm tới trái tim người mình yêu thương và sẵn sàng để thế giới của cả hai rộng mở, khời đầu từ 1cm nhỏ bé nhất!\r\n\r\nTác giả\r\nKIM EUN JU\r\nTác giả xê-ri tản văn 1 cm rất được yêu thích tại Hàn Quốc và đã được xuất bản tại nhiều nước châu Á như Đài Loan, Thái Lan…\r\nHiện đang hoạt động tự do với tư cách là nhà sáng tạo nội dung, mong muốn qua những cuốn sách mình viết có thể đem tới nhiều góc nhìn sáng tạo, mới mẻ về cuộc sống và truyền thêm năng lượng tích cực tới nhiều người.\r\n\r\nYANG HYUN JUNG\r\nHọa sĩ minh họa tự do. Sen toàn thời gian của mèo cưng Haru.\r\nNgoài minh họa sách còn hợp tác minh họa cho nhiều phim truyền hình của đài tvN.\r\n\r\nTrích dẫn\r\n\r\nVà lời tỏ tình đáng tiếc nhất\r\nKhông phải lời tỏ tình bị từ chối ngay tức khắc,\r\nCũng chẳng phải lời tỏ tình bị từ chối vòng vo,\r\nMà chính là lời tỏ tình không bao giờ được thốt ra miệng.\r\n\r\n--------\r\nMột ưu điểm khác của tình yêu chính là,\r\nTrong quá trình sẵn sàng thay đổi vì một ai đó,\r\nChúng ta phát hiện thêm một khía cạnh mới đầy cuốn hút của bản thân.\r\n\r\n---\r\nNgay cả khi bắt đầu từ mắt, mũi, miệng,\r\nNhưng cuối cùng tình yêu vẫn dẫn đến trái tim.\r\n\r\nMã hàng	8935235226913\r\nTên Nhà Cung Cấp	Nhã Nam\r\nTác giả	Kim Eun Ju, Yang Hyun Jung minh họa\r\nNgười Dịch	Vương Thúy Quỳnh Anh\r\nNXB	NXB Hà Nội\r\nNăm XB	2020\r\nTrọng lượng (gr)	360\r\nKích Thước Bao Bì	20.5 x 14 cm\r\nSố trang	302\r\nHình thức	Bìa Mềm\r\nSản phẩm hiển thị trong	\r\nVNPAY\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Truyện ngắn - Tản Văn bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\n1cm giữa anh và em – cuốn tản văn sâu lắng khắc họa tình yêu dưới lăng kính đầy mới mẻ và dễ thương là cuốn cẩm nang cần có, để những kẻ dại khờ trong tình yêu học cách tiến thêm tới trái tim người mình yêu thương và sẵn sàng để thế giới của cả hai rộng mở, khời đầu từ 1cm nhỏ bé nhất!', 'Và lời tỏ tình đáng tiếc nhất\r\nKhông phải lời tỏ tình bị từ chối ngay tức khắc,\r\nCũng chẳng phải lời tỏ tình bị từ chối vòng vo,\r\nMà chính là lời tỏ tình không bao giờ được thốt ra miệng.\r\n\r\n--------\r\nMột ưu điểm khác của tình yêu chính là,\r\nTrong quá trình sẵn sàng thay đổi vì một ai đó,\r\nChúng ta phát hiện thêm một khía cạnh mới đầy cuốn hút của bản thân.\r\n\r\n---\r\nNgay cả khi bắt đầu từ mắt, mũi, miệng,\r\nNhưng cuối cùng tình yêu vẫn dẫn đến trái tim.'),
                                                                                                                           (10, 'ISBN 978-604-347-838-9', 2020, 280, '20.5 x 13 x 0.5', 244, 'Tiếng Việt', '“Vị chua chát của cái nghèo hòa trộn với vị ngọt ngào khi khám phá ra những điều khiến cuộc đời này đáng sống... một tác phẩm kinh điển của Brazil.” - Booklist\r\n\r\n“Một cách nhìn cuộc sống gần như hoàn chỉnh từ con mắt trẻ thơ… có sức mạnh sưởi ấm và làm tan nát cõi lòng, dù người đọc ở lứa tuổi nào.” - The National\r\n\r\nHãy làm quen với Zezé, cậu bé tinh nghịch siêu hạng đồng thời cũng đáng yêu bậc nhất, với ước mơ lớn lên trở thành nhà thơ cổ thắt nơ bướm. Chẳng phải ai cũng công nhận khoản “đáng yêu” kia đâu nhé. Bởi vì, ở cái xóm ngoại ô nghèo ấy, nỗi khắc khổ bủa vây đã che mờ mắt người ta trước trái tim thiện lương cùng trí tưởng tượng tuyệt vời của cậu bé con năm tuổi.\r\n\r\nCó hề gì đâu bao nhiêu là hắt hủi, đánh mắng, vì Zezé đã có một người bạn đặc biệt để trút nỗi lòng: cây cam ngọt nơi vườn sau. Và cả một người bạn nữa, bằng xương bằng thịt, một ngày kia xuất hiện, cho cậu bé nhạy cảm khôn sớm biết thế nào là trìu mến, thế nào là nỗi đau, và mãi mãi thay đổi cuộc đời cậu.\r\n\r\nMở đầu bằng những thanh âm trong sáng và kết thúc lắng lại trong những nốt trầm hoài niệm, Cây cam ngọt của tôi khiến ta nhận ra vẻ đẹp thực sự của cuộc sống đến từ những điều giản dị như bông hoa trắng của cái cây sau nhà, và rằng cuộc đời thật khốn khổ nếu thiếu đi lòng yêu thương và niềm trắc ẩn. Cuốn sách kinh điển này bởi thế không ngừng khiến trái tim người đọc khắp thế giới thổn thức, kể từ khi ra mắt lần đầu năm 1968 tại Brazil.\r\n\r\nTÁC GIẢ:\r\n\r\nJOSÉ MAURO DE VASCONCELOS (1920-1984) là nhà văn người Brazil. Sinh ra trong một gia đình nghèo ở ngoại ô Rio de Janeiro, lớn lên ông phải làm đủ nghề để kiếm sống. Nhưng với tài kể chuyện thiên bẩm, trí nhớ phi thường, trí tưởng tượng tuyệt vời cùng vốn sống phong phú, José cảm thấy trong mình thôi thúc phải trở thành nhà văn nên đã bắt đầu sáng tác năm 22 tuổi. Tác phẩm nổi tiếng nhất của ông là tiểu thuyết mang màu sắc tự truyện Cây cam ngọt của tôi. Cuốn sách được đưa vào chương trình tiểu học của Brazil, được bán bản quyền cho hai mươi quốc gia và chuyển thể thành phim điện ảnh. Ngoài ra, José còn rất thành công trong vai trò diễn viên điện ảnh và biên kịch.\r\n\r\nMã hàng	8935235228351\r\nTên Nhà Cung Cấp	Nhã Nam\r\nTác giả	José Mauro de Vasconcelos\r\nNgười Dịch	Nguyễn Bích Lan, Tô Yến Ly\r\nNXB	NXB Hội Nhà Văn\r\nNăm XB	2020\r\nTrọng lượng (gr)	280\r\nKích Thước Bao Bì	20 x 14.5 cm\r\nSố trang	244\r\nHình thức	Bìa Mềm\r\nSản phẩm hiển thị trong	\r\nĐồ Chơi Cho Bé - Giá Cực Tốt\r\nNhã Nam\r\nRƯỚC DEAL LINH ĐÌNH VUI ĐÓN TRUNG THU\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Tiểu thuyết bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\n“Vị chua chát của cái nghèo hòa trộn với vị ngọt ngào khi khám phá ra những điều khiến cuộc đời này đáng sống... một tác phẩm kinh điển của Brazil.” - Booklist\r\n\r\n“Một cách nhìn cuộc sống gần như hoàn chỉnh từ con mắt trẻ thơ… có sức mạnh sưởi ấm và làm tan nát cõi lòng, dù người đọc ở lứa tuổi nào.” - The National\r\n\r\nHãy làm quen với Zezé, cậu bé tinh nghịch siêu hạng đồng thời cũng đáng yêu bậc nhất, với ước mơ lớn lên trở thành nhà thơ cổ thắt nơ bướm. Chẳng phải ai cũng công nhận khoản “đáng yêu” kia đâu nhé. Bởi vì, ở cái xóm ngoại ô nghèo ấy, nỗi khắc khổ bủa vây đã che mờ mắt người ta trước trái tim thiện lương cùng trí tưởng tượng tuyệt vời của cậu bé con năm tuổi.\r\n\r\nCó hề gì đâu bao nhiêu là hắt hủi, đánh mắng, vì Zezé đã có một người bạn đặc biệt để trút nỗi lòng: cây cam ngọt nơi vườn sau. Và cả một người bạn nữa, bằng xương bằng thịt, một ngày kia xuất hiện, cho cậu bé nhạy cảm khôn sớm biết thế nào là trìu mến, thế nào là nỗi đau, và mãi mãi thay đổi cuộc đời cậu.\r\n\r\nMở đầu bằng những thanh âm trong sáng và kết thúc lắng lại trong những nốt trầm hoài niệm, Cây cam ngọt của tôi khiến ta nhận ra vẻ đẹp thực sự của cuộc sống đến từ những điều giản dị như bông hoa trắng của cái cây sau nhà, và rằng cuộc đời thật khốn khổ nếu thiếu đi lòng yêu thương và niềm trắc ẩn. Cuốn sách kinh điển này bởi thế không ngừng khiến trái tim người đọc khắp thế giới thổn thức, kể từ khi ra mắt lần đầu năm 1968 tại Brazil.', NULL);
INSERT INTO `book_details` (`id_book`, `isbn`, `year`, `weight`, `size`, `page`, `language`, `description`, `extract`) VALUES
                                                                                                                           (11, 'ISBN 978-604-311-392-1', 2019, 350, '20.5 x 13 x 0.5', 337, 'Tiếng Việt', 'Đầu tư chứng khoán theo chỉ số là cuốn thánh kinh về đầu tư, với những thông tin và góc nhìn mới. Nhà tiên phong về quỹ chỉ số, John C. Bogle tiết lộ với độc giả bí quyết đầu tư hiệu quả: mua và giữ các quỹ chỉ số với chi phí quản lý thấp, bao gồm cổ phiếu của những công ty niêm yết trên các sàn chứng khoán lớn như S&P 500. Với chiến lược này, nhà đầu tư có thể loại bỏ rủi ro trong việc lựa chọn các cổ phiếu riêng lẻ và thu được nhiều lợi tức hơn trong dài hạn.\r\n\r\nTác giả cũng nhấn mạnh tầm quan trọng của chi phí trong đầu tư, đề cao phong cách đầu tư đơn giản với chi phí tối thiểu và đưa ra những nhận định đầy thuyết phục về thị trường chứng khoán, được những ông lớn trong giới đầu tư ủng hộ.\r\n\r\nTrong ấn bản kỷ niệm 10 năm phát hành của cuốn sách, John C. Bogle đem đến cho các nhà đầu tư hai chương hoàn toàn mới, bao gồm những lời khuyên của ông về phân bổ tài sản: giữa cổ phiếu và trái phiếu; cũng như kế hoạch tiết kiệm hưu trí. Các nhà đầu tư thuộc mọi lứa tuổi đều có thể áp dụng triết lí đầu tư thông thái của ông.\r\n\r\n“Nếu có ai được vinh danh là người làm được nhiều điều nhất cho các nhà đầu tư ở nước Mỹ, người đó chính là Jack Bogle… Anh ấy là vị anh hùng của họ và tôi.” – Warren Buffett.\r\n\r\nThông tin về tác giả:\r\n\r\nJohn C. Bogle là nhà sáng lập của tập đoàn Vanguard, một trong hai tổ chức cung cấp quỹ tương hỗ lớn nhất trên thế giới. Ông có tên trong danh sách một trăm người quyền lực và có tầm ảnh hưởng nhất thế giới, do tạp chí TIME bình chọn. Tờ FORTUNE gọi ông là một trong bốn “người khổng lồ của thế kỷ 20” trong lĩnh vực đầu tư.\r\n\r\nTrích đoạn sách:\r\n\r\nThị trường thực tế và thị trường kỳ vọng\r\n\r\nĐể hiểu rõ điểm này, các bạn hãy coi việc đầu tư bao gồm hai trò chơi khác hẳn nhau. Đây chính là cách mà Roger Martin, hiệu trưởng trường quản lý Rotman của Đại học Toronto, đã dùng để diễn tả chúng. Một trong hai trò chơi là “thị trường thực, trong đó các công ty đại chúng khổng lồ cạnh tranh với nhau. Tại đây, các doanh nghiệp thực sử dụng tiền thực để sản xuất và bán các sản phẩm, dịch vụ thực. Và nếu chơi khéo léo, họ sẽ kiếm được lợi nhuận thực và trả cổ tức thực. Trò chơi này cũng đòi hỏi chiến lược, sự quyết tâm và kiến thức thực, cũng như sự sáng tạo và khả năng nhìn xa trông rộng thực.” Gắn bó lỏng lẻo với trò chơi này là một trò chơi khác: thị trường kỳ vọng. Ở đây, “giá cả không được định đoạt bởi những yếu tố thực như biên lợi nhuận hay lợi nhuận. Trong ngắn hạn, giá cổ phiếu chỉ tăng lên khi kỳ vọng của các nhà đầu tư tăng, chứ không nhất thiết là khi doanh thu, biên lợi nhuận hoặc lợi nhuận tăng.”\r\n\r\nThị trường chứng khoán là một yếu tố gây xao nhãng lớn đối với việc đầu tư\r\n\r\nVới sự phân biệt quan trọng này, tôi muốn nói thêm rằng, thị trường kỳ vọng chủ yếu được tạo nên từ kỳ vọng của các nhà đầu cơ cố gắng đoán xem những nhà đầu tư khác sẽ kỳ vọng gì và hành động ra sao, khi các thông tin mới xuất hiện trên thị trường. Thị trường kỳ vọng hoàn toàn gắn với việc đầu cơ. Trong khi đó, thị trường thực gắn với việc đầu tư.\r\n\r\nChính vì vậy, thị trường chứng khoán là một yếu tố xao nhãng lớn đối với việc đầu tư. Thường thì thị trường chứng khoán khiến các nhà đầu tư tập trung vào các kỳ vọng ngắn hạn, có mức biến động cao và chỉ mang tính tạm thời, thay vì những điều thực sự quan trọng – sự tích tụ dần dần lợi nhuận của các tập đoàn.\r\n\r\nKhi Shakespeare viết rằng “đó là một câu chuyện do một tên ngốc kể, đầy âm thanh và cuồng nộ nhưng chẳng có ý nghĩa gì,”1 ông hoàn toàn có thể đang diễn tả những biến động ngẫu nhiên hằng ngày, hằng tháng, thậm chí hằng năm của cổ phiếu. Tôi có một lời khuyên cho các nhà đầu tư, hãy bỏ qua những âm thanh và cuồng nộ ngắn hạn trong tâm lý của nhà đầu tư được thể hiện trên thị trường chứng khoán, mà tập trung vào những khía cạnh kinh tế dài hạn của doanh nghiệp. Bí quyết để đầu tư thành công là thoát khỏi thị trường kỳ vọng và đánh cược vào thị trường thực.\r\n\r\nĐừng chỉ nghe lời tôi nói\r\n\r\nBạn chỉ cần xem xét cách phân biệt bất hủ của Benjamin Graham, nhà đầu tư huyền thoại, tác giả của cuốn The Intelligent Investor (Nhà đầu tư thông minh) và là thầy của Warren Buffett. Ông đã rất đúng khi chỉ ra bản chất thực tế của việc đầu tư: “Trong ngắn hạn, thị trường chứng khoán là một chiếc máy đếm phiếu bầu… nhưng trong dài hạn, nó lại là một cái cân.” Sử dụng phép ẩn dụ kỳ diệu về “Ngài Thị-trường”, Ben Graham đã nói: “Hãy tưởng tượng rằng bạn bỏ 1.000 đô-la để sở hữu một phần nhỏ trong công ty tư nhân. Một trong những đối tác của bạn là Ngài Thị-trường, một người vô cùng sốt sắng. Mỗi ngày, ông ta đều nói cho bạn biết cổ phiếu của bạn có giá bao nhiêu và hơn nữa ngày nào cũng đề xuất mua lại cổ phần của bạn, hoặc chào mời để bạn mua thêm cổ phần của công ty. Có lúc, những đánh giá của ông ta dường như đúng đắn và được chứng tỏ bởi sự phát triển và tiềm năng của công ty. Nhưng mặt khác, nhiều lúc Ngài Thị-trường để cho sự sợ hãi hoặc sự nhiệt tình thái quá khống chế mình và giá trị mà ông ta đưa ra gần như ngớ ngẩn.\r\n\r\nNếu bạn là một nhà đầu tư khôn ngoan… liệu bạn có để những đánh giá của Ngài Thị-trường định đoạt quan điểm của bạn về giá trị của 1.000 đô-la cổ phần trong công ty? Bạn sẽ chỉ làm thế khi bạn đồng tình với Ngài Thị-trường hoặc muốn giao dịch với ông ta… Nhưng trong những trường hợp khác, tốt hơn bạn nên hình thành những ý tưởng của riêng mình về giá trị cổ phần bạn đang nắm giữ… Một nhà đầu tư chân chính sẽ thành công hơn… nếu anh ta quên đi thị trường chứng khoán mà tập trung vào cổ tức và kết quả kinh doanh của công ty. (Phần in nghiêng được viết thêm vào.)…\r\n\r\nMột nhà đầu tư có danh mục gồm những cổ phiếu bền vững có thể kỳ vọng giá của chúng biến động mạnh, nhưng không nên cảm thấy lo lắng khi giá giảm sâu hoặc phấn khích khi giá tăng cao. Anh ta phải luôn luôn nhớ rằng những mức giá được đưa ra trên thị trường chỉ là công cụ và vì thế có thể tận dụng nó hoặc bỏ qua.\r\n\r\n[…]\r\n\r\nBenjamin Graham sẽ nghĩ gì về đầu tư chỉ số\r\n\r\nCái tên Benjamin Graham gắn chặt, thậm chí gần như song hành, với khái niệm “đầu tư giá trị” và cuộc tìm kiếm các chứng khoán bị định giá quá thấp. Nhưng cuốn sách kinh điển của ông lại tập trung nhiều hơn vào những điều căn bản đầy thực tế của chiến lược danh mục đầu tư – những nguyên tắc dễ hiểu, không phức tạp của việc đa dạng hóa và kỳ vọng hợp lý trong dài hạn – đây cũng là những chủ đề chính của cuốn sách nhỏ bạn đang đọc. Ông ít tập trung hơn vào việc cố gắng giải đáp câu đố hóc búa như của nhân sư, trong việc lựa chọn cổ phiếu vượt trội thông qua phân tích chứng khoán.\r\n\r\nTìm kiếm giá trị vượt trội từng là một việc rất có lợi, nhưng giờ thì không còn như vậy nữa.\r\n\r\nGraham hiểu rõ những phần thưởng vượt trội mà cá nhân ông nhận được bằng cách sử dụng những nguyên tắc định giá của mình sẽ rất khó vươn tới trong tương lai. Trong buổi phỏng vấn năm 1976 đó, ông đã thừa nhận một điều đáng kinh ngạc: “Tôi không còn là người cổ súy các kỹ thuật phức tạp trong phân tích chứng khoán để tìm cơ hội đem lại giá trị vượt trội. Đó từng là một việc rất có lợi khoảng 40 năm trước, nhưng tình hình đã thay đổi quá nhiều kể từ đó tới giờ. Ngày xưa, bất kỳ nhà phân tích chứng khoán được đào tạo bài bản nào cũng có thể lựa chọn các chứng khoán bị đánh giá thấp hơn giá trị thực thông qua nghiên cứu chi tiết. Nhưng khi nhìn vào số lượng khổng lồ các nghiên cứu đang được tiến hành, tôi nghi ngờ liệu trong phần lớn các trường hợp, những việc đó có còn đem lại đủ những lựa chọn tốt để bù đắp cho chi phí hay không.”\r\n\r\nSẽ là công bằng khi nói rằng theo tiêu chuẩn rất cao của Graham, phần lớn các quỹ tương hỗ ngày nay đã không thể thực hiện lời hứa của mình do mức chi phí cao và hành vi đầu cơ. Kết quả là các quỹ chỉ số truyền thống đang ngày càng được nhà đầu tư ưa chuộng.\r\n\r\nTại sao? Một phần vì chính những gì quỹ chỉ số làm – cung cấp sự đa dạng hóa cao nhất – và một phần vì những gì nó không làm – không tính mức phí quản lý quá cao hoặc thực hiện chuyển đổi danh mục quá nhiều. Những trích dẫn trong cuốn sách của Graham là một phần quan trọng trong di sản mà ông để lại cho đại đa số các nhà đầu tư, những người mà ông tin rằng nên đi theo nguyên tắc của nhà đầu tư phòng thủ.\r\n\r\n“Đạt kết quả đầu tư ở mức hài lòng dễ hơn phần lớn mọi người vẫn tưởng.”\r\n\r\nChính lý trí, sự thông minh, tư duy rõ ràng, đơn giản, và sự nhạy bén với lịch sử tài chính của Benjamin Graham – cùng sự sẵn lòng tuân thủ chặt chẽ những nguyên tắc của đầu tư dài hạn – đã tạo nên di sản bất diệt của ông. Ông đã tóm tắt những lời khuyên của mình như sau: “Thật may cho các nhà đầu tư thông thường vì nếu muốn thành công… trong đầu tư, họ không cần đến những phẩm chất xuyên thời gian… như sự dũng cảm, hiểu biết, khả năng đánh giá, và kinh nghiệm – họ chỉ cần giới hạn tham vọng trong khả năng của mình và duy trì các hoạt động đầu tư trong khuôn khổ hạn hẹp nhưng an toàn của lối đầu tư phòng thủ theo tiêu chuẩn. Đạt kết quả đầu tư ở mức độ hài lòng dễ hơn phần lớn mọi người vẫn tưởng; đạt kết quả vượt trội thì khó hơn vẻ bề ngoài.”\r\n\r\nTrong khi thật dễ dàng – thậm chí đơn giản đến khó tin – để kiếm được lợi nhuận ngang với thị trường thông qua quỹ chỉ số, bạn không cần phải chịu thêm rủi ro – hay cả gánh nặng chi phí – để có được kết quả vượt trội. Với tài nhìn xa trông rộng, lý trí, tính thực tế và hiểu biết của Benjamin Graham, tôi tin chắc ông sẽ tán dương các quỹ chỉ số. Quả thực, khi đọc những lời của Warren Buffett sau đây, bạn sẽ thấy đó chính là điều ông ấy đã làm.\r\n\r\nĐừng chỉ nghe lời tôi nói\r\n\r\nTrong khi những bình luận rõ ràng của Benjamin Graham có thể dễ dàng được coi là lời cổ động cho quỹ chỉ số bao quát thị trường chi phí thấp, các bạn đừng chỉ nghe những lời tôi nói. Thay vào đó, hãy nghe Warren Buffett, người vừa là học trò vừa là cộng sự của Graham, mà những ý kiến tư vấn và sự giúp đỡ của ông đã được Graham coi là vô cùng quý giá trong ấn bản cuối cùng của cuốn Nhà đầu tư thông minh. Năm 1993, Buffet cật lực tán dương quỹ chỉ số. Năm 2006, ông thậm chí còn đi xa hơn khi không chỉ khẳng định lại nhận định của mình mà còn nói với tôi rằng nhiều thập niên trước, chính Graham cũng đã ủng hộ quỹ chỉ số.\r\n\r\nBuffett nói trực tiếp những lời này với tôi tại một bữa tiệc tối ở Omaha năm 2006: “Một quỹ chỉ số chi phí thấp là cách đầu tư vốn hợp lý nhất cho phần lớn các nhà đầu tư. Người thầy của tôi, Ben Graham, đã đưa ra quan điểm này nhiều năm trước và tất cả những gì tôi từng chứng kiến đều khiến tôi tin rằng ông ấy đã đúng.”\r\n\r\nMã hàng	8935280904309\r\nTên Nhà Cung Cấp	Thái Hà\r\nTác giả	John C Bogle\r\nNgười Dịch	Mai\r\nNXB	NXB Công Thương\r\nNăm XB	2019\r\nTrọng lượng (gr)	350\r\nKích Thước Bao Bì	13 x 20.5cm\r\nSố trang	337\r\nHình thức	Bìa Mềm\r\nSản phẩm hiển thị trong	\r\nSách Kinh Tế\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Chứng Khoán - Bất Động Sản - Đầu Tư bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nĐầu tư chứng khoán theo chỉ số là cuốn thánh kinh về đầu tư, với những thông tin và góc nhìn mới. Nhà tiên phong về quỹ chỉ số, John C. Bogle tiết lộ với độc giả bí quyết đầu tư hiệu quả: mua và giữ các quỹ chỉ số với chi phí quản lý thấp, bao gồm cổ phiếu của những công ty niêm yết trên các sàn chứng khoán lớn như S&P 500. Với chiến lược này, nhà đầu tư có thể loại bỏ rủi ro trong việc lựa chọn các cổ phiếu riêng lẻ và thu được nhiều lợi tức hơn trong dài hạn.\r\n\r\nTác giả cũng nhấn mạnh tầm quan trọng của chi phí trong đầu tư, đề cao phong cách đầu tư đơn giản với chi phí tối thiểu và đưa ra những nhận định đầy thuyết phục về thị trường chứng khoán, được những ông lớn trong giới đầu tư ủng hộ.\r\n\r\nTrong ấn bản kỷ niệm 10 năm phát hành của cuốn sách, John C. Bogle đem đến cho các nhà đầu tư hai chương hoàn toàn mới, bao gồm những lời khuyên của ông về phân bổ tài sản: giữa cổ phiếu và trái phiếu; cũng như kế hoạch tiết kiệm hưu trí. Các nhà đầu tư thuộc mọi lứa tuổi đều có thể áp dụng triết lí đầu tư thông thái của ông.\r\n\r\n“Nếu có ai được vinh danh là người làm được nhiều điều nhất cho các nhà đầu tư ở nước Mỹ, người đó chính là Jack Bogle… Anh ấy là vị anh hùng của họ và tôi.” – Warren Buffett.', 'Thị trường thực tế và thị trường kỳ vọng\r\n\r\nĐể hiểu rõ điểm này, các bạn hãy coi việc đầu tư bao gồm hai trò chơi khác hẳn nhau. Đây chính là cách mà Roger Martin, hiệu trưởng trường quản lý Rotman của Đại học Toronto, đã dùng để diễn tả chúng. Một trong hai trò chơi là “thị trường thực, trong đó các công ty đại chúng khổng lồ cạnh tranh với nhau. Tại đây, các doanh nghiệp thực sử dụng tiền thực để sản xuất và bán các sản phẩm, dịch vụ thực. Và nếu chơi khéo léo, họ sẽ kiếm được lợi nhuận thực và trả cổ tức thực. Trò chơi này cũng đòi hỏi chiến lược, sự quyết tâm và kiến thức thực, cũng như sự sáng tạo và khả năng nhìn xa trông rộng thực.” Gắn bó lỏng lẻo với trò chơi này là một trò chơi khác: thị trường kỳ vọng. Ở đây, “giá cả không được định đoạt bởi những yếu tố thực như biên lợi nhuận hay lợi nhuận. Trong ngắn hạn, giá cổ phiếu chỉ tăng lên khi kỳ vọng của các nhà đầu tư tăng, chứ không nhất thiết là khi doanh thu, biên lợi nhuận hoặc lợi nhuận tăng.”\r\n\r\nThị trường chứng khoán là một yếu tố gây xao nhãng lớn đối với việc đầu tư\r\n\r\nVới sự phân biệt quan trọng này, tôi muốn nói thêm rằng, thị trường kỳ vọng chủ yếu được tạo nên từ kỳ vọng của các nhà đầu cơ cố gắng đoán xem những nhà đầu tư khác sẽ kỳ vọng gì và hành động ra sao, khi các thông tin mới xuất hiện trên thị trường. Thị trường kỳ vọng hoàn toàn gắn với việc đầu cơ. Trong khi đó, thị trường thực gắn với việc đầu tư.\r\n\r\nChính vì vậy, thị trường chứng khoán là một yếu tố xao nhãng lớn đối với việc đầu tư. Thường thì thị trường chứng khoán khiến các nhà đầu tư tập trung vào các kỳ vọng ngắn hạn, có mức biến động cao và chỉ mang tính tạm thời, thay vì những điều thực sự quan trọng – sự tích tụ dần dần lợi nhuận của các tập đoàn.\r\n\r\nKhi Shakespeare viết rằng “đó là một câu chuyện do một tên ngốc kể, đầy âm thanh và cuồng nộ nhưng chẳng có ý nghĩa gì,”1 ông hoàn toàn có thể đang diễn tả những biến động ngẫu nhiên hằng ngày, hằng tháng, thậm chí hằng năm của cổ phiếu. Tôi có một lời khuyên cho các nhà đầu tư, hãy bỏ qua những âm thanh và cuồng nộ ngắn hạn trong tâm lý của nhà đầu tư được thể hiện trên thị trường chứng khoán, mà tập trung vào những khía cạnh kinh tế dài hạn của doanh nghiệp. Bí quyết để đầu tư thành công là thoát khỏi thị trường kỳ vọng và đánh cược vào thị trường thực.\r\n\r\nĐừng chỉ nghe lời tôi nói\r\n\r\nBạn chỉ cần xem xét cách phân biệt bất hủ của Benjamin Graham, nhà đầu tư huyền thoại, tác giả của cuốn The Intelligent Investor (Nhà đầu tư thông minh) và là thầy của Warren Buffett. Ông đã rất đúng khi chỉ ra bản chất thực tế của việc đầu tư: “Trong ngắn hạn, thị trường chứng khoán là một chiếc máy đếm phiếu bầu… nhưng trong dài hạn, nó lại là một cái cân.” Sử dụng phép ẩn dụ kỳ diệu về “Ngài Thị-trường”, Ben Graham đã nói: “Hãy tưởng tượng rằng bạn bỏ 1.000 đô-la để sở hữu một phần nhỏ trong công ty tư nhân. Một trong những đối tác của bạn là Ngài Thị-trường, một người vô cùng sốt sắng. Mỗi ngày, ông ta đều nói cho bạn biết cổ phiếu của bạn có giá bao nhiêu và hơn nữa ngày nào cũng đề xuất mua lại cổ phần của bạn, hoặc chào mời để bạn mua thêm cổ phần của công ty. Có lúc, những đánh giá của ông ta dường như đúng đắn và được chứng tỏ bởi sự phát triển và tiềm năng của công ty. Nhưng mặt khác, nhiều lúc Ngài Thị-trường để cho sự sợ hãi hoặc sự nhiệt tình thái quá khống chế mình và giá trị mà ông ta đưa ra gần như ngớ ngẩn.\r\n\r\nNếu bạn là một nhà đầu tư khôn ngoan… liệu bạn có để những đánh giá của Ngài Thị-trường định đoạt quan điểm của bạn về giá trị của 1.000 đô-la cổ phần trong công ty? Bạn sẽ chỉ làm thế khi bạn đồng tình với Ngài Thị-trường hoặc muốn giao dịch với ông ta… Nhưng trong những trường hợp khác, tốt hơn bạn nên hình thành những ý tưởng của riêng mình về giá trị cổ phần bạn đang nắm giữ… Một nhà đầu tư chân chính sẽ thành công hơn… nếu anh ta quên đi thị trường chứng khoán mà tập trung vào cổ tức và kết quả kinh doanh của công ty. (Phần in nghiêng được viết thêm vào.)…\r\n\r\nMột nhà đầu tư có danh mục gồm những cổ phiếu bền vững có thể kỳ vọng giá của chúng biến động mạnh, nhưng không nên cảm thấy lo lắng khi giá giảm sâu hoặc phấn khích khi giá tăng cao. Anh ta phải luôn luôn nhớ rằng những mức giá được đưa ra trên thị trường chỉ là công cụ và vì thế có thể tận dụng nó hoặc bỏ qua.\r\n\r\n[…]\r\n\r\nBenjamin Graham sẽ nghĩ gì về đầu tư chỉ số\r\n\r\nCái tên Benjamin Graham gắn chặt, thậm chí gần như song hành, với khái niệm “đầu tư giá trị” và cuộc tìm kiếm các chứng khoán bị định giá quá thấp. Nhưng cuốn sách kinh điển của ông lại tập trung nhiều hơn vào những điều căn bản đầy thực tế của chiến lược danh mục đầu tư – những nguyên tắc dễ hiểu, không phức tạp của việc đa dạng hóa và kỳ vọng hợp lý trong dài hạn – đây cũng là những chủ đề chính của cuốn sách nhỏ bạn đang đọc. Ông ít tập trung hơn vào việc cố gắng giải đáp câu đố hóc búa như của nhân sư, trong việc lựa chọn cổ phiếu vượt trội thông qua phân tích chứng khoán.\r\n\r\nTìm kiếm giá trị vượt trội từng là một việc rất có lợi, nhưng giờ thì không còn như vậy nữa.\r\n\r\nGraham hiểu rõ những phần thưởng vượt trội mà cá nhân ông nhận được bằng cách sử dụng những nguyên tắc định giá của mình sẽ rất khó vươn tới trong tương lai. Trong buổi phỏng vấn năm 1976 đó, ông đã thừa nhận một điều đáng kinh ngạc: “Tôi không còn là người cổ súy các kỹ thuật phức tạp trong phân tích chứng khoán để tìm cơ hội đem lại giá trị vượt trội. Đó từng là một việc rất có lợi khoảng 40 năm trước, nhưng tình hình đã thay đổi quá nhiều kể từ đó tới giờ. Ngày xưa, bất kỳ nhà phân tích chứng khoán được đào tạo bài bản nào cũng có thể lựa chọn các chứng khoán bị đánh giá thấp hơn giá trị thực thông qua nghiên cứu chi tiết. Nhưng khi nhìn vào số lượng khổng lồ các nghiên cứu đang được tiến hành, tôi nghi ngờ liệu trong phần lớn các trường hợp, những việc đó có còn đem lại đủ những lựa chọn tốt để bù đắp cho chi phí hay không.”\r\n\r\nSẽ là công bằng khi nói rằng theo tiêu chuẩn rất cao của Graham, phần lớn các quỹ tương hỗ ngày nay đã không thể thực hiện lời hứa của mình do mức chi phí cao và hành vi đầu cơ. Kết quả là các quỹ chỉ số truyền thống đang ngày càng được nhà đầu tư ưa chuộng.\r\n\r\nTại sao? Một phần vì chính những gì quỹ chỉ số làm – cung cấp sự đa dạng hóa cao nhất – và một phần vì những gì nó không làm – không tính mức phí quản lý quá cao hoặc thực hiện chuyển đổi danh mục quá nhiều. Những trích dẫn trong cuốn sách của Graham là một phần quan trọng trong di sản mà ông để lại cho đại đa số các nhà đầu tư, những người mà ông tin rằng nên đi theo nguyên tắc của nhà đầu tư phòng thủ.\r\n\r\n“Đạt kết quả đầu tư ở mức hài lòng dễ hơn phần lớn mọi người vẫn tưởng.”\r\n\r\nChính lý trí, sự thông minh, tư duy rõ ràng, đơn giản, và sự nhạy bén với lịch sử tài chính của Benjamin Graham – cùng sự sẵn lòng tuân thủ chặt chẽ những nguyên tắc của đầu tư dài hạn – đã tạo nên di sản bất diệt của ông. Ông đã tóm tắt những lời khuyên của mình như sau: “Thật may cho các nhà đầu tư thông thường vì nếu muốn thành công… trong đầu tư, họ không cần đến những phẩm chất xuyên thời gian… như sự dũng cảm, hiểu biết, khả năng đánh giá, và kinh nghiệm – họ chỉ cần giới hạn tham vọng trong khả năng của mình và duy trì các hoạt động đầu tư trong khuôn khổ hạn hẹp nhưng an toàn của lối đầu tư phòng thủ theo tiêu chuẩn. Đạt kết quả đầu tư ở mức độ hài lòng dễ hơn phần lớn mọi người vẫn tưởng; đạt kết quả vượt trội thì khó hơn vẻ bề ngoài.”\r\n\r\nTrong khi thật dễ dàng – thậm chí đơn giản đến khó tin – để kiếm được lợi nhuận ngang với thị trường thông qua quỹ chỉ số, bạn không cần phải chịu thêm rủi ro – hay cả gánh nặng chi phí – để có được kết quả vượt trội. Với tài nhìn xa trông rộng, lý trí, tính thực tế và hiểu biết của Benjamin Graham, tôi tin chắc ông sẽ tán dương các quỹ chỉ số. Quả thực, khi đọc những lời của Warren Buffett sau đây, bạn sẽ thấy đó chính là điều ông ấy đã làm.\r\n\r\nĐừng chỉ nghe lời tôi nói\r\n\r\nTrong khi những bình luận rõ ràng của Benjamin Graham có thể dễ dàng được coi là lời cổ động cho quỹ chỉ số bao quát thị trường chi phí thấp, các bạn đừng chỉ nghe những lời tôi nói. Thay vào đó, hãy nghe Warren Buffett, người vừa là học trò vừa là cộng sự của Graham, mà những ý kiến tư vấn và sự giúp đỡ của ông đã được Graham coi là vô cùng quý giá trong ấn bản cuối cùng của cuốn Nhà đầu tư thông minh. Năm 1993, Buffet cật lực tán dương quỹ chỉ số. Năm 2006, ông thậm chí còn đi xa hơn khi không chỉ khẳng định lại nhận định của mình mà còn nói với tôi rằng nhiều thập niên trước, chính Graham cũng đã ủng hộ quỹ chỉ số.\r\n\r\nBuffett nói trực tiếp những lời này với tôi tại một bữa tiệc tối ở Omaha năm 2006: “Một quỹ chỉ số chi phí thấp là cách đầu tư vốn hợp lý nhất cho phần lớn các nhà đầu tư. Người thầy của tôi, Ben Graham, đã đưa ra quan điểm này nhiều năm trước và tất cả những gì tôi từng chứng kiến đều khiến tôi tin rằng ông ấy đã đúng.”'),
                                                                                                                           (12, 'ISBN 978-604-365-032-7', 2020, 200, '20.5 x 13 x 0.5', 187, 'Tiếng Việt', NULL, NULL),
                                                                                                                           (13, 'ISBN 978-604-323-569-2 & ISBN 978-604-323-568-5', 2020, 3000, '20.5 x 13 x 0.5', 1672, 'Tiếng Việt', 'Những người khốn khổ (Tiếng Pháp: Les Misérables) là tiểu thuyết của văn hào Pháp Victor Hugo, được xuất bản năm 1862. Tác phẩm được đánh giá là một trong những tiểu thuyết nổi tiếng nhất của nền văn học thế giới thế kỷ 19.\r\n\r\nNhững người khốn khổ là câu chuyện về xã hội nước Pháp trong khoảng hơn 20 năm đầu thế kỷ 19 kể từ thời điểm Napoléon I lên ngôi và vài thập niên sau đó. Nhân vật chính của tiểu thuyết là Jean Valjean, một cựu tù khổ sai tìm cách chuộc lại những lỗi lầm gây ra thời trai trẻ. Bộ tiểu thuyết không chỉ nói tới bản chất của cái tốt, cái xấu, của luật pháp, mà tác phẩm còn là cuốn bách khoa thư đồ sộ về lịch sử, kiến trúc của Paris, nền chính trị, triết lý, luật pháp, công lý, tín ngưỡng của nước Pháp nửa đầu thế kỷ 19. Chính nhà văn Victor Hugo cũng đã viết cho người biên tập rằng: \"Tôi có niềm tin rằng đây sẽ là một trong những tác phẩm đỉnh cao, nếu không nói là tác phẩm lớn nhất, trong sự nghiệp cầm bút của mình\".\r\n\r\nNhững người khốn khổ cũng nổi tiếng vì đã được chuyển thể nhiều lần thành các vở kịch, bộ phim, trong đó nổi tiếng nhất phải kể tới vở nhạc kịch cùng tên.\r\n\r\nMã hàng	9786043077957\r\nNhà Cung Cấp	Công Ty TNHH Thương Mại Dịch Vụ Sách Tuyệt Đỉnh\r\nTác giả	Victor Hugo\r\nNgười Dịch	Huỳnh Lý, Vũ Đình Liên, Lê Trí Viễn, Đỗ Đức Hiểu\r\nNXB	NXB Văn Học\r\nNăm XB	2020\r\nNgôn Ngữ	Tiếng Việt\r\nTrọng lượng (gr)	3000\r\nKích Thước Bao Bì	24 x 16 cm\r\nSố trang	1672\r\nHình thức	Bìa Mềm\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Tác Phẩm Kinh Điển bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nNhững người khốn khổ (Tiếng Pháp: Les Misérables) là tiểu thuyết của văn hào Pháp Victor Hugo, được xuất bản năm 1862. Tác phẩm được đánh giá là một trong những tiểu thuyết nổi tiếng nhất của nền văn học thế giới thế kỷ 19.\r\n\r\nNhững người khốn khổ là câu chuyện về xã hội nước Pháp trong khoảng hơn 20 năm đầu thế kỷ 19 kể từ thời điểm Napoléon I lên ngôi và vài thập niên sau đó. Nhân vật chính của tiểu thuyết là Jean Valjean, một cựu tù khổ sai tìm cách chuộc lại những lỗi lầm gây ra thời trai trẻ. Bộ tiểu thuyết không chỉ nói tới bản chất của cái tốt, cái xấu, của luật pháp, mà tác phẩm còn là cuốn bách khoa thư đồ sộ về lịch sử, kiến trúc của Paris, nền chính trị, triết lý, luật pháp, công lý, tín ngưỡng của nước Pháp nửa đầu thế kỷ 19. Chính nhà văn Victor Hugo cũng đã viết cho người biên tập rằng: \"Tôi có niềm tin rằng đây sẽ là một trong những tác phẩm đỉnh cao, nếu không nói là tác phẩm lớn nhất, trong sự nghiệp cầm bút của mình\".\r\n\r\nNhững người khốn khổ cũng nổi tiếng vì đã được chuyển thể nhiều lần thành các vở kịch, bộ phim, trong đó nổi tiếng nhất phải kể tới vở nhạc kịch cùng tên.\r\n', NULL),
                                                                                                                           (14, 'ISBN 978-604-2-26317-7', 2022, 400, '20.5 x 13 x 0.5', 396, 'Tiếng Việt', 'Dựa trên một câu chuyện có thật, nhà văn Daniel Defoe đã dùng nghệ thuật viết văn bậc thầy của mình biến nó thành một câu chuyện phiêu lưu kì thú vô cùng li kì, hấp dẫn kể về Robinson thay vì hoang mang sợ hãi khi một mình dạt lên đảo hoang đã dũng cảm dám dùng hết sức mình cải tạo và chiến thắng thiên nhiên...\r\n\r\nCốt truyện giản dị, văn phong trong sáng của tác phẩm khiến nó rất được thanh thiếu niên trên toàn thế giới yêu thích. Câu chuyện cũng trở thành cảm hứng cho nhiều tác phẩm nghệ thuật về đề tài phiêu lưu sau này.\r\n\r\nMã hàng	9786043726886\r\nTên Nhà Cung Cấp	Cty Văn Hóa & Truyền Thông Trí Việt.\r\nTác giả	Daniel Defoe\r\nNgười Dịch	Nguyễn Thành Long\r\nNXB	Văn Học\r\nNăm XB	2022\r\nTrọng lượng (gr)	400\r\nKích Thước Bao Bì	20.5 x 13 cm\r\nSố trang	396\r\nHình thức	Bìa Mềm\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Root Catalog bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nDựa trên một câu chuyện có thật, nhà văn Daniel Defoe đã dùng nghệ thuật viết văn bậc thầy của mình biến nó thành một câu chuyện phiêu lưu kì thú vô cùng li kì, hấp dẫn kể về Robinson thay vì hoang mang sợ hãi khi một mình dạt lên đảo hoang đã dũng cảm dám dùng hết sức mình cải tạo và chiến thắng thiên nhiên...\r\n\r\nCốt truyện giản dị, văn phong trong sáng của tác phẩm khiến nó rất được thanh thiếu niên trên toàn thế giới yêu thích. Câu chuyện cũng trở thành cảm hứng cho nhiều tác phẩm nghệ thuật về đề tài phiêu lưu sau này.', NULL),
                                                                                                                           (15, 'ISBN 978-604-56-7920-3', 2020, 300, '20.5 x 13 x 0.5', 284, 'Tiếng Việt', '100 sai lầm có thể dễ dàng tránh được trong nuôi dạy trẻ\r\n\r\nTất cả các ông bố, bà mẹ đều sợ mắc phải những lỗi lầm dẫn đến việc phủ nhận mọi cố gắng nuôi dưỡng và giáo dục trẻ. Tuy nhiên, chúng ta không nên sợ lỗi lầm mà nên học cách để có thể tránh được chúng. Cuốn sách này là một cuốn cẩm nang chi tiết, trong đó chỉ ra những sai lầm của các bậc cha mẹ và cách thức khắc phục những sai lầm đó!\r\n\r\nCác sai lầm của cha mẹ ảnh hưởng thế nào đến giáo dục trẻ của chúng ta\r\n\r\nCó thể làm gì để không lặp lại các sai lầm của người khác và không mắc sai lầm\r\n\r\nNhững gì cần chú ý đầu tiên trong phát triển trẻ\r\n\r\nTại sao không nên lạm dụng phát triển trí tuệ ở trẻ quá sớm\r\n\r\nQuá tự kiêu, tự đại ở trẻ là gì và vì sao sự tự kiêu, tự đại có vị trí quan trọng trong phát triển nhân cách\r\n\r\n10 ảo tưởng về hạnh phúc mà chúng ta đã mang theo từ tuổi thơ\r\n\r\nLàm thế nào để truyền đạt cho trẻ hiểu biết đúng đắn về hạnh phúc và thành công\r\n\r\nĐiều gì bổ ích có thể học hỏi từ hệ thống giáo dục của các nước khác\r\n\r\nLàm thế nào để đáp ứng nhu cầu yêu thương mà vẫn không nuông chiều trẻ\r\n\r\n10 mong muốn quan trọng nhất của trẻ\r\n\r\nCách phản ứng đúng đắn đối với mong muốn của trẻ: thực hiện hay bỏ qua\r\n\r\n10 nỗi sợ của trẻ mà cha mẹ bắt buộc phải xử lý\r\n\r\n10 điểm trong giáo dục trẻ có thể hủy hoại tất cả\r\n\r\nTập hợp những sai lầm cụ thể trong giáo dục trẻ với những ví dụ và kết luận cụ thể.\r\n\r\nVề tác giả: Sách mua bản quyền của Exem Licence Limited, Nga do tác giả Olga Makhovskaya – nhà tâm lý học nổi tiếng, phó tiến sĩ khoa học tâm lý, cộng tác viên của Viện Tâm lý thuộc Viện Hành lâm khoa học Liên bang Nga, cộng tác viên của trường Đại học Điện ảnh Liên bang Nga. Olga Makhovskaya còn là người nhận được rất nhiều Học bổng các chương trình khoa học quốc tế. Bà còn là Giám đốc nội dung Dự án truyền hình giáo dục dành cho trẻ em “Sesame Street” (Phố Vừng) tại Nga, đồng thời là tác giả và người dẫn chương trình một số chương trình dành cho các bậc cha mẹ.\r\n\r\nOlga Makhovskaya còn là tác giả của các tác phẩm Trẻ em Mỹ chơi với niềm vui, trẻ em Pháp chơi theo nguyên tắc, còn trẻ em Nga chơi đến khi chiến thắng; Bình tĩnh nói chuyện với trẻ như thế nào về cuộc sống để trẻ cho bạn sống bình yên.\r\n\r\nMã hàng	9786045679203\r\nTên Nhà Cung Cấp	Phụ Nữ\r\nTác giả	Olga Makhovskaya\r\nNgười Dịch	Nhật Linh\r\nNXB	NXB Phụ Nữ Việt Nam\r\nNăm XB	2020\r\nNgôn Ngữ	Tiếng Việt\r\nTrọng lượng (gr)	300\r\nKích Thước Bao Bì	22.5 x 17 cm\r\nSố trang	284\r\nHình thức	Bìa Mềm\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Phương Pháp Giáo Dục Trẻ Các Nước bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\n100 sai lầm có thể dễ dàng tránh được trong nuôi dạy trẻ\r\n\r\nTất cả các ông bố, bà mẹ đều sợ mắc phải những lỗi lầm dẫn đến việc phủ nhận mọi cố gắng nuôi dưỡng và giáo dục trẻ. Tuy nhiên, chúng ta không nên sợ lỗi lầm mà nên học cách để có thể tránh được chúng. Cuốn sách này là một cuốn cẩm nang chi tiết, trong đó chỉ ra những sai lầm của các bậc cha mẹ và cách thức khắc phục những sai lầm đó!', 'Các sai lầm của cha mẹ ảnh hưởng thế nào đến giáo dục trẻ của chúng ta\r\n\r\nCó thể làm gì để không lặp lại các sai lầm của người khác và không mắc sai lầm\r\n\r\nNhững gì cần chú ý đầu tiên trong phát triển trẻ\r\n\r\nTại sao không nên lạm dụng phát triển trí tuệ ở trẻ quá sớm\r\n\r\nQuá tự kiêu, tự đại ở trẻ là gì và vì sao sự tự kiêu, tự đại có vị trí quan trọng trong phát triển nhân cách\r\n\r\n10 ảo tưởng về hạnh phúc mà chúng ta đã mang theo từ tuổi thơ\r\n\r\nLàm thế nào để truyền đạt cho trẻ hiểu biết đúng đắn về hạnh phúc và thành công\r\n\r\nĐiều gì bổ ích có thể học hỏi từ hệ thống giáo dục của các nước khác\r\n\r\nLàm thế nào để đáp ứng nhu cầu yêu thương mà vẫn không nuông chiều trẻ\r\n\r\n10 mong muốn quan trọng nhất của trẻ\r\n\r\nCách phản ứng đúng đắn đối với mong muốn của trẻ: thực hiện hay bỏ qua\r\n\r\n10 nỗi sợ của trẻ mà cha mẹ bắt buộc phải xử lý\r\n\r\n10 điểm trong giáo dục trẻ có thể hủy hoại tất cả\r\n\r\nTập hợp những sai lầm cụ thể trong giáo dục trẻ với những ví dụ và kết luận cụ thể.'),
                                                                                                                           (16, 'ISBN 978-604-56-8983-7', 2020, 700, '20.5 x 13 x 0.5', 500, 'Tiếng Việt', 'Trong tiểu thuyết phân mảnh  Bieguni, những người không ngừng chuyển động – một thách thức mới cho người đọc vốn quen thể loại tiểu thuyết truyền thống – Tokarczuk tìm thấy cảm hứng từ những tấm bản đồ và góc nhìn từ trên cao, khiến vũ trụ thu nhỏ của bà trở thành tấm gương phản chiếu vũ trụ rộng lớn. Chúng ta có gì chung với các tín đồ cổ hủ của Chính thống giáo “Bieguni”, những kẻ chế ngự cái ác bằng chuyển động? Tên gọi bieguni, như tác giả giải thích, xuất phát từ các từ bieg (chạy) và ucieczka (chạy trốn). Trong chúng ta có bao nhiêu phần giống họ? Từ các cung điện xưa của vua một nước Hồi giáo nhỏ bé, qua các phòng trưng bày đồ cổ thế kỷ XVII, đến các nhà ga hiện đại ở sân bay, Olga Tokarczuk đưa độc giả vào cuộc hành trình hiếm thấy qua các địa điểm và thời gian khác nhau. Tác giả mời chúng ta cùng chế ngự thực tế mơ hồ, chắp vá, vứt bỏ những lối mòn quen thuộc. Bà thường được nhắc đến với giọng điệu huyền bí trong các tác phẩm của mình.\r\n\r\nChính trong tác phẩm này bà thổ lộ: “Trong những trang viết của tôi cuộc sống biến đổi thành những câu chuyện không đầy đủ, những lời nói mơ mộng, những chủ đề không rõ ràng, xuất hiện từ xa trong những viễn cảnh không bình thường và luôn di động hoặc trong những lát cắt ngang – và khó đưa ra được những kết luận nào đó về toàn bộ”.\r\n\r\nTác phẩm này không có biên giới – chuyện xảy ra trên toàn thế giới. Bà nói: “Văn học là phương cách an toàn nhất để vượt qua mọi ranh giới”.\r\n\r\nOlga Tokarczuk đã mô tả thế giới quanh ta bằng phương pháp hết sức đặc biệt, thông minh và nhạy cảm. Bà đã dành ra ba năm để hoàn thành tác phẩm này. Bà kể rằng phần lớn các ghi chép được bà thực hiện trong các chuyến đi. “Song đây không phải là cuốn sách về du lịch. Trong đó không miêu tả di tích và địa điểm. Đó không phải là nhật ký du lịch và cũng không phải là phóng sự. Tôi chỉ muốn nhìn kỹ cái được gọi là du lịch, là chuyển dịch, là thay đổi chỗ. Điều đó có ý nghĩa gì? Nó mang lại cho chúng ta cái gì?” Bà viết trong phần giới thiệu cuốn sách xuất bản lần thứ nhất. Như bà nói “Viết tiểu thuyết đối với tôi là kể chuyện cổ tích cho chính bản thân mình ở tuổi trưởng thành. Giống như trẻ con vẫn làm trước khi chúng đi ngủ. Ngôn ngữ được dùng nằm giữa mơ và thực, vừa miêu tả vừa bịa đặt.”\r\n\r\nĐÁNH GIÁ VỀ TÁC PHẨM\r\n\r\n“Chúng ta có nhà văn tầm cỡ thế giới, người miêu tả thế giới bằng phong cách đầy chất thơ và khác thường”.  - Giáo sư Per Wastberg, Chủ tịch Ủy ban Nobel về văn học\r\n\r\n“vì trí tưởng tượng dựa trên các quan sát tinh tế, kết hợp với sự say mê của bộ óc bách khoa, bà chỉ ra cho chúng ta thấy việc vượt qua các ranh giới như là một dạng của cuộc sống. Bà chưa bao giờ xem hiện thực là thứ gì đó ổn định và tồn tại vĩnh hằng.”   - Ủy ban Nobel vinh danh Olga Tokarczuk\r\n\r\n“Chắc chắn cuốn sách nên đọc trước tiên của Olga Tokarczuk là Bieguni, những người không ngừng chuyển động.” - Nhà phê bình văn học Janowska viết trong tạp chí Onet.kultura\r\n\r\n“Bieguni, những người không ngừng chuyển động tràn đầy năng lượng, là cuốn sách tỏa sáng chói lọi, rất dí dỏm hài hước và hết sức cuốn hút”. - Lisa Appignanesi, Chủ tịch Hội đồng The Man Booker International Prize, đồng thời là Chủ tịch Hội Văn học Hoàng gia Anh\r\n\r\n“Việc nữ nhà văn Ba Lan nhận được giải thưởng cao quý đó không làm tôi bất ngờ. Văn của Tokarczuk có tính chất phổ cập rộng rãi một cách khác thường – nó không gắn với bất kỳ địa điểm nào, đất nước nào hay dân tộc nào, nó nói đến con người ở mọi nơi trên thế giới. Tôi vô cùng vui mừng. Hơn nữa, rõ ràng là văn của bà cũng là biểu tượng của tự do, giá trị khiến người ta liên tưởng đến thành phố Gdansk, nơi hiện nay tôi sinh sống”. - Janusz Leon Wiśniewski, tác giả cuốn bestseller Cô đơn trên mạng', NULL),
                                                                                                                           (17, 'ISBN 978-604-56-9794-8', 2021, 300, '20.5 x 13 x 0.5', 296, 'Tiếng Việt', 'Bộ ba bất hảo xoay quanh ba cô gái học chung trường trung học lần lượt tên là Tabitha, Elodie và Moe: một người là “beauty queen”, một người là “wallflower” và người còn lại thì lúc nào cũng mang dáng vẻ “đừng lại gần ta”. Ba người với ba tính cách khác nhau, ba hoàn cảnh sống khác nhau tưởng chừng chẳng có chút mối liên hệ gì, và có thể chẳng dính líu tới nhau cho tới hết đời, ấy thế mà “nhờ” có chung thói quen \"mua sắm không trả tiền\" (hay còn có tên là… ăn cắp vặt), Tabitha, Elodie và Moe dần trở nên thân thiết và trở thành những người bạn thân không thể thiếu của nhau.\r\n\r\nĐộc giả sẽ không thể không hồi hộp muốn lật ngay sang trang kế tiếp để xem làm thế nào ba cô gái lại có thể trót lọt các “phi vụ” của mình… để rồi bị bắt, và màn so găng xem ai trong ba cô là người hốt được thứ đồ “ngon” nhất. Với những cú plot twist mà tác giả cài cắm, ta sẽ thấy được rằng đằng sau cái “thói quen” chẳng lấy gì làm tự hào (mà bản thân các cô gái của chúng ta cũng thấy vậy) không phải là ham muốn vật chất, không phải là hành động nổi loạn tuổi dậy thì, mà là nỗi cô đơn trống vắng thường trực, khát khao được yêu thương và chia sẻ. Những thứ mà dù cho có hàng núi vàng núi bạc, chúng ta cũng không thể mua được.\r\n\r\nBộ ba bất hảo là một món quà dành cho độc giả lứa tuổi học đường với nhiều biến chuyển trong tâm sinh lý được nhìn thấy mình qua ba nhân vật chính Tabitha, Elodie và Moe. Hơn thế nữa, cuốn sách cũng là món quà dành cho bạn đọc phụ huynh và thanh niên để có thể hiểu hơn các bạn tuổi teen năng động và nhiều hoài bão.\r\n\r\nNhà xuất bản Phụ nữ Việt Nam xin trân trọng giới thiệu quý độc giả cuốn sách Bộ ba bất hảo – Quẩy lên nào! – Tình bạn là vô giá.\r\n\r\nTác giả\r\n\r\nKirsten Smith là nhà biên kịch Hollywood và tác giả của dòng sách dành cho tuổi mới lớn. Cô đồng biên kịch nhiều phim nổi tiếng như 10 Things I Hate About You (1999), Legally Blonde (2001), She\'s the Man (2006) và The Ugly Truth (2009). Hai tác phẩm Kirsten Smith viết cho thanh thiếu niên là The Geography of Girlhood (2009) và Bộ ba bất hảo (2013).\r\n\r\nNhững lời khen dành cho cuốn sách\r\n\r\n“Sâu sắc, tinh tế và hài hước. Bộ ba bất hảo là một tác phẩm tuyệt vời!” –Ellen Page, ngôi sao của The Umbrella Academy và Whip It–\r\n\r\n“Tôi muốn dựng một điện thờ cho cuốn sách này. Nó không chỉ khám phá và đập tan những lối nói ráo rỗng về thời trung học, mà còn giúp ta hiểu ngôn ngữ của tuổi teen. Cuốn sách với ba nhân vật khác nhau làm nên một câu chuyện độc đáo khiến ta phấn khích và đồng cảm.” –Tavi Gevinson, tổng biên tập của tạp chí dành cho thanh thiếu niên Rookie–\r\n\r\n\"Với ba góc nhìn khác nhau về thời trung học, chuyện tình lãng mạn và drama gia đình, Bộ ba bất hảo là một cuốn sách dễ đọc và có tính giải trí cao.” –School Library Journal–\r\n\r\nBộ ba bất hảo đã được Netflix chuyển thể thành bộ phim nhiều tập vào năm 2019.\r\n\r\nMã hàng	9786045697948\r\nTên Nhà Cung Cấp	Phụ Nữ\r\nTác giả	Kirsten Smith\r\nNgười Dịch	Trương Thị Thanh Hoa\r\nNXB	NXB Phụ Nữ Việt Nam\r\nNăm XB	2021\r\nTrọng lượng (gr)	300\r\nKích Thước Bao Bì	21 x 13 cm\r\nSố trang	296\r\nHình thức	Bìa Mềm\r\nSản phẩm bán chạy nhất	Top 100 sản phẩm Tuổi Teen bán chạy của tháng\r\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\r\nTác phẩm\r\n\r\nBộ ba bất hảo xoay quanh ba cô gái học chung trường trung học lần lượt tên là Tabitha, Elodie và Moe: một người là “beauty queen”, một người là “wallflower” và người còn lại thì lúc nào cũng mang dáng vẻ “đừng lại gần ta”. Ba người với ba tính cách khác nhau, ba hoàn cảnh sống khác nhau tưởng chừng chẳng có chút mối liên hệ gì, và có thể chẳng dính líu tới nhau cho tới hết đời, ấy thế mà “nhờ” có chung thói quen \"mua sắm không trả tiền\" (hay còn có tên là… ăn cắp vặt), Tabitha, Elodie và Moe dần trở nên thân thiết và trở thành những người bạn thân không thể thiếu của nhau.\r\n\r\nĐộc giả sẽ không thể không hồi hộp muốn lật ngay sang trang kế tiếp để xem làm thế nào ba cô gái lại có thể trót lọt các “phi vụ” của mình… để rồi bị bắt, và màn so găng xem ai trong ba cô là người hốt được thứ đồ “ngon” nhất. Với những cú plot twist mà tác giả cài cắm, ta sẽ thấy được rằng đằng sau cái “thói quen” chẳng lấy gì làm tự hào (mà bản thân các cô gái của chúng ta cũng thấy vậy) không phải là ham muốn vật chất, không phải là hành động nổi loạn tuổi dậy thì, mà là nỗi cô đơn trống vắng thường trực, khát khao được yêu thương và chia sẻ. Những thứ mà dù cho có hàng núi vàng núi bạc, chúng ta cũng không thể mua được.\r\n\r\nBộ ba bất hảo là một món quà dành cho độc giả lứa tuổi học đường với nhiều biến chuyển trong tâm sinh lý được nhìn thấy mình qua ba nhân vật chính Tabitha, Elodie và Moe. Hơn thế nữa, cuốn sách cũng là món quà dành cho bạn đọc phụ huynh và thanh niên để có thể hiểu hơn các bạn tuổi teen năng động và nhiều hoài bão.\r\n\r\nNhà xuất bản Phụ nữ Việt Nam xin trân trọng giới thiệu quý độc giả cuốn sách Bộ ba bất hảo – Quẩy lên nào! – Tình bạn là vô giá.', NULL),
                                                                                                                           (18, '2394012038478', 2022, 234, '20.5 x 13 x 0.5', 700, 'Tiếng Việt', '', NULL),
                                                                                                                           (19, '4658890979', 2022, 789, '20.5 x 13 x 0.5', 909, 'Tiếng Việt', '', NULL),
                                                                                                                           (22, 'ISBN 978-604-976-902-1', 2021, 890, '20.5 x 13 x 0.5', 220, 'Tiếng Việt', 'Nguyễn Công Hoan (1903 - 1977) là nhà văn tiêu biểu của văn học hiện thực phê phán Việt Nam. Trong cuộc đời sáng tác của mình, ông để lại một di sản nghệ thuật với hơn 200 truyện ngắn, gần 30 truyện dài và nhiều tiểu luận văn học. Hoạt động văn học của Nguyễn Công Hoan luôn song hành cùng với sự nghiệp cách mạng chống Mỹ cứu nước. Chính vì thế trong các sáng tác của ông, bức tranh xã hội của người nông dân dưới mới tầng áp bức hiện ra chân thực nhất, rõ nét nhất\r\n', NULL),
                                                                                                                           (23, 'ISBN 978-604-976-909-8', 2022, 820, '20.5 x 13 x 0.5', 210, 'Tiếng Việt', 'Sợi tóc thể hiện cái thiên tài hiếm có của Thạch Lam trong kỹ thuật mô tả tâm lý con người. Ngòi bút của Thạch Lam đã dẫn chúng ta đi sâu vào tận đáy tâm hồn con người để ta chứng kiến được cái biên giới mong manh giữa thiện, ác, giữa ăn cắp hay không ăn cắp, cái địa giới chỉ mỏng manh như một sợi tóc.\r\n', NULL),
                                                                                                                           (24, 'ISBN 978-604-999-346-8', 2021, 210, '20.5 x 13 x 0.5', 230, 'Tiếng Việt', 'Tuyển tập Thạch Lam xin trân trọng giới thiệu đến quý độc giả những tác phẩm xuất sắc nhất của nhà văn Thạch Lam: Hà Nội băm sáu phố phường, Qùa Hà Nội, Trẻ con lấy vợ; Theo giòng; Hà Nội ban đêm; Những biển hàng; Người ta viết chữ Tây; Hai đứa trẻ; Dưới bóng hoàng lan; Nhà mẹ Lê; Gió lạnh đầu mùa; Sợi tóc…\r\n', NULL),
                                                                                                                           (25, 'ISBN 978-604-954-765-8', 2022, 225, '20.5 x 13 x 0.5', 250, 'Tiếng Việt', 'Ngay trong tác phẩm đầu tay (Gió đầu mùa), người ta đã thấy Thạch Lam đứng vào một phái riêng… Ông có một ngòi bút lặng lẽ, điềm tĩnh vô cùng, ngòi bút chuyên tả tỉ mỉ những cái rất nhỏ và rất đẹp… Phải là người giàu tình cảm lắm mới viết được như vậy…\r\n', NULL),
                                                                                                                           (27, 'ISBN 978-604-917-889-5', 2021, 365, '20.5 x 13 x 0.5', 433, 'Tiếng Việt', 'Hơn nửa thế kỷ trước đây, phong trào Thơ mới đã có những đóng góp đáng kể vào sự phát triển của nền văn học trước Cách mạng tháng Tám của đất nước. Các thi sĩ của thuở ấy đã đem lại cho bạn đọc một tiếng nói mới, phản ánh khá trung thực tâm trạng của cả một lớp thanh niên tiểu tư sản trong cuộc sống có nhiều đau buồn, trăn trở và đôi khí bế tắc trước hiện trạng của đất nước thời bấy giờ.\r\n', NULL),
                                                                                                                           (29, 'ISBN 978-604-972-372-9', 2022, 399, '20.5 x 13 x 0.5', 233, 'Tiếng Việt', 'Thế giới thơ ca Xuân Quỳnh là sự tương tranh không ngừng giữa khắc nghiệt và yên lành với những biểu hiện sống động và biến hóa khôn cùng của chúng. Ở đó trái tim thơ Xuân Quỳnh là cánh chuồn chuồn báo bão cứ chao đi chao về, mệt nhoài giữa biến động và yên định, bão tố và bình yên, chiến tranh và hòa bình, thác lũ và êm trôi, tình yêu và cách trở, ra đi và trở lại, chảy trôi phiêu bạt và trụ vững kiên gan, tổ ấm và dòng đời, sóng và bờ, thuyền và biển, nhà ga và con tàu, trời xanh và bom đạn, gió Lào và cát trắng, cỏ dại và nắng lửa, thủy chung và trắc trở, xuân sắc và tàn phai, ngọn lửa cô đơn và đại ngàn tối sẫm...\r\n', NULL),
                                                                                                                           (30, 'ISBN 978-604-988-911-3', 2020, 492, '20.5 x 13 x 0.5', 236, 'Tiếng Việt', 'Truyện Kiều đã có cả một vận mệnh rất vẻ vang. Qua đó, ta có thể nhận thấy rằng: Dù từ xưa đến nay các thế hệ nhà văn, nhà thơ đều đồng thanh về giá trị văn nghệ của Truyện Kiều, thì mỗi thời đại, mỗi một giai tầng xã hội đều đã nhận xét tác phẩm của Nguyễn Du theo một quan điểm riêng biệt.\r\nTHI ĐỖ, RỒI ĐI LÀM CÔNG SỞ, đó là mục đích của cả một đời. Nhưng bây giờ Trường mới rõ cái nhỏ mọn của điều mong ước ấy. Sự sống đã cho chàng bao nhiêu bài học hay. Trường không băn khoăn vì cảnh nghèo của mình nữa. Chàng không ganh ghét với những người sang trọng, giàu có hơn chàng, - Trường nghĩ đến Quang, đến người bạn học cũ ở nhà quê, - và tự thấy mình giàu hơn họ nhiều, giàu hơn họ nhiều, giàu những tính tình tốt đẹp, những ý nghĩ đằm thắm mà những người chỉ biết đến mình không bao giờ có được.\r\n', NULL),
                                                                                                                           (31, 'ISBN 978-604-988-998-9', 2021, 230, '20.5 x 13 x 0.5', 120, 'Tiếng Việt', 'THI ĐỖ, RỒI ĐI LÀM CÔNG SỞ, đó là mục đích của cả một đời. Nhưng bây giờ Trường mới rõ cái nhỏ mọn của điều mong ước ấy. Sự sống đã cho chàng bao nhiêu bài học hay. Trường không băn khoăn vì cảnh nghèo của mình nữa. Chàng không ganh ghét với những người sang trọng, giàu có hơn chàng, - Trường nghĩ đến Quang, đến người bạn học cũ ở nhà quê, - và tự thấy mình giàu hơn họ nhiều, giàu hơn họ nhiều, giàu những tính tình tốt đẹp, những ý nghĩ đằm thắm mà những người chỉ biết đến mình không bao giờ có được.\r\n', NULL),
                                                                                                                           (44, 'ISBN 978-604-988-998-6', 2022, 120, '20.5 x 13 x 0.5', 320, 'Tiếng Việt', 'Cõi người mắc cạn là tiểu thuyết 12 chương của Hoàng Khánh Duy, được tác giả sáng tác theo phương thức huyền thoại hóa, chú trọng yếu tố văn hóa và môi trường “xanh”. Trong tác phẩm, tác giả đã tạo dựng một không gian nghệ thuật vừa lạ, vừa quen. Lạ vì đó là một không gian mang sắc màu huyền ảo, mơ hồ nhưng cũng là một không gian quen thuộc vì nó thấm đượm linh hồn của sông nước Tây Nam Bộ.  Xuyên suốt tiểu thuyết là hành trình đi tìm chân lý, đi tìm lẽ sống và đấng cứu rỗi một vùng quê đã khô cằn vì hạn mặn của nhân vật “hắn”. Nỗi bàng hoàng trước sự méo mó của phong cảnh và nỗi đau của con người là điểm khởi nguồn của dòng sông chữ Cõi người mắc cạn.\r\n', NULL),
                                                                                                                           (45, 'ISBN 978-604-988-887-5', 2022, 120, '20.5 x 13 x 0.5', 320, 'Tiếng Việt', 'Có những khoảnh khắc trong cuộc đời mỗi chúng ta thấy nhớ nhà, nhớ tuổi thơ, nhớ con đò nhỏ lâu rồi không có khách qua sông nên nằm buồn bến nước, nhớ cánh đồng và cánh cò trắng \"chở luôn nước mắt cay nồng của cha\", nhớ những người thân yêu vẫn hằng ngày ngóng vọng ta về.\r\n', NULL),
                                                                                                                           (46, 'ISBN 978-604-988-654-4', 2021, 320, '20.5 x 13 x 0.5', 365, 'Tiếng Việt', 'Người chồng đắc ý cười vang, nhấp thêm một chút nước trà sen; đoạn, thong thả lấy ngón tay cái và ngón tay trỏ nhón một chiếc bánh xuân cầu màu hoàng yến đưa lên miệng...\r\n', NULL),
                                                                                                                           (47, 'ISBN 978-604-988-887-4', 2021, 365, '20.5 x 13 x 0.5', 223, 'Tiếng Việt', 'Mỗi tác phẩm đều có ưu và nhược, không nên coi nặng một vài khuyết điểm mà bỏ qua ưu điểm. Người thẩm định cũng cần có nhãn quan tiến bộ, khách quan và có bản lĩnh… Dễ nhận thấy rằng, độ lùi tiếp nhận càng xa thì tính khách quan càng cao, những thiên kiến xã hội sẽ giảm bớt, quá khứ sẽ được đề cao.(…) “ Không thể vĩ đại trong thời đại mình, sự vĩ đại bao giờ cũng trông hòng ở con cháu”. Càng lùi về phía sau người ta càng thấy rõ hơn đỉnh núi nào cao thấp. Như vậy, công việc đánh giá những thành tựu của tiểu thuyết cách mạng Việt Nam thời chiến tranh sẽ còn tiếp tục đế mai sau.\r\n', NULL),
                                                                                                                           (56, 'ISBN 978-604-988-867-9', 2022, 256, '20.5 x 13 x 0.5', 221, 'Tiếng Việt', '\"Trạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\n\nMã hàng 9786045290910\nNhà Cung Cấp CÔNG TY TNHH IN ẤN-DV-TM SIÊU TỐC\nTác giả Kim Khánh\nNXB NXB Đồng Nai\nNăm XB 2020\nTrọng lượng (gr) 80\nKích Thước Bao Bì 17.5 x 11.5 x 0.7 cm\nSố trang 120\nHình thức Bìa Mềm\nSản phẩm bán chạy nhất Top 100 sản phẩm Truyện Tranh Việt Nam bán chạy của tháng\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\nTrạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\"\r\n', NULL);
INSERT INTO `book_details` (`id_book`, `isbn`, `year`, `weight`, `size`, `page`, `language`, `description`, `extract`) VALUES
                                                                                                                           (58, 'ISBN 978-604-988-889-7', 2021, 236, '20.5 x 13 x 0.5', 223, 'Tiếng Việt', '\"Trạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\n\nMã hàng 9786045290910\nNhà Cung Cấp CÔNG TY TNHH IN ẤN-DV-TM SIÊU TỐC\nTác giả Kim Khánh\nNXB NXB Đồng Nai\nNăm XB 2020\nTrọng lượng (gr) 80\nKích Thước Bao Bì 17.5 x 11.5 x 0.7 cm\nSố trang 120\nHình thức Bìa Mềm\nSản phẩm bán chạy nhất Top 100 sản phẩm Truyện Tranh Việt Nam bán chạy của tháng\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\nTrạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\"\r\n', NULL),
                                                                                                                           (59, 'ISBN 978-604-988-665-9', 2022, 523, '20.5 x 13 x 0.5', 252, 'Tiếng Việt', '\"Trạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\n\nMã hàng 9786045290910\nNhà Cung Cấp CÔNG TY TNHH IN ẤN-DV-TM SIÊU TỐC\nTác giả Kim Khánh\nNXB NXB Đồng Nai\nNăm XB 2020\nTrọng lượng (gr) 80\nKích Thước Bao Bì 17.5 x 11.5 x 0.7 cm\nSố trang 120\nHình thức Bìa Mềm\nSản phẩm bán chạy nhất Top 100 sản phẩm Truyện Tranh Việt Nam bán chạy của tháng\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\nTrạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\"\r\n', NULL),
                                                                                                                           (60, 'ISBN 978-604-988-898-5', 2022, 512, '20.5 x 13 x 0.5', 212, 'Tiếng Việt', '\"Trạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\n\nMã hàng 9786045290910\nNhà Cung Cấp CÔNG TY TNHH IN ẤN-DV-TM SIÊU TỐC\nTác giả Kim Khánh\nNXB NXB Đồng Nai\nNăm XB 2020\nTrọng lượng (gr) 80\nKích Thước Bao Bì 17.5 x 11.5 x 0.7 cm\nSố trang 120\nHình thức Bìa Mềm\nSản phẩm bán chạy nhất Top 100 sản phẩm Truyện Tranh Việt Nam bán chạy của tháng\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\nTrạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\"\r\n', NULL),
                                                                                                                           (62, 'ISBN 978-604-988-433-8', 2022, 652, '20.5 x 13 x 0.5', 220, 'Tiếng Việt', '\"Trạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\n\nMã hàng 9786045290910\nNhà Cung Cấp CÔNG TY TNHH IN ẤN-DV-TM SIÊU TỐC\nTác giả Kim Khánh\nNXB NXB Đồng Nai\nNăm XB 2020\nTrọng lượng (gr) 80\nKích Thước Bao Bì 17.5 x 11.5 x 0.7 cm\nSố trang 120\nHình thức Bìa Mềm\nSản phẩm bán chạy nhất Top 100 sản phẩm Truyện Tranh Việt Nam bán chạy của tháng\nGiá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...\nTrạng Quỷnh là một bộ truyện tranh thiếu nhi nhiều tập của Việt Nam, tập truyện đầu tiên mang tên Sao sáng xứ Thanh được Nhà xuất bản Đồng Nai phát hành giữa tháng 6 năm 2003.\n\nBan đầu tác phẩm được đặt là Trạng Quỳnh (từ tập 1 đến tập 24), còn từ tập 25 trở đi thì đặt tên là Trạng Quỷnh.\n\nTác phẩm được thực hiện bởi tác giả Kim Khánh. \n\nTruyện lấy bối cảnh vào thời chúa Nguyễn, dưới thời chúa Nguyễn Phúc Khoát, nhưng những sự kiện xảy ra trong truyện không trùng lặp với những sự kiện xảy ra trên thực tế. Tác phẩm này ban đầu kể lại về cuộc đời của Trạng Quỳnh - một người có tính cách trào phúng dân gian Việt Nam. Trong truyện này, Trạng Quỳnh vốn thông minh từ trong bụng mẹ.\n\nTrước khi cậu sinh ra, một lần bà mẹ ra ao giặt đồ, bỗng nhìn thấy một chú vịt, bà mẹ liền ngâm câu thơ, và lập tức có tiếng đối đáp lại trong bụng vịt.\n\nBà cho rằng đó là điềm lạ, nghĩ rằng bà sẽ sinh ra một quý tử, hiểu biết hơn người, sẽ là người có tiếng tăm. Thời gian trôi qua, bà hạ sinh một bé trai, tư dung thông minh lạ thường, đặt tên là Quỳnh.\"\r\n', NULL),
                                                                                                                           (63, 'ISBN 978-604-988-564-8', 2020, 541, '20.5 x 13 x 0.5', 265, 'Tiếng Việt', 'Ở một làng nhỏ ven biển thuộc Đông Triều (Quảng Ninh ngày nay), có vợ chồng nhà họ Lê hiếm muộn mãi mới hạ sinh được cô con gái, đặt tên là Lê Chân. Cô gái lớn lên xinh đẹp ngời ngời, vì thế tên Thái thú Tô Định muốn đem về làm thê thiếp. Lê Chân không chịu, nàng trốn khỏi làng. Vì căm giận tên Thái thú cũng như bọn giặc nhà Hán, nàng đã học võ nghệ và chiêu tập nghĩa quân, tham gia khởi nghĩa cùng Hai Bà Trưng và hi sinh khi tuổi mới tròn 23.\r\n', NULL),
                                                                                                                           (64, 'ISBN 978-604-988-987-4', 2022, 213, '20.5 x 13 x 0.5', 555, 'Tiếng Việt', 'Có lão phú ông bủn xỉn, hành hạ kẻ ở đủ đường. Lão hứa gả con gái, để bắt anh đầy tớ dốc sức làm lụng ngày đêm. Nhưng ít lâu sau, vì muốn gả con gái cho một nhà giàu, lão chủ lại nghĩ mưu tính kế, bắt anh đầy tớ đi tìm cho được cây tre có một trăm đốt thì mới được lấy cô gái kia làm vợ. Nhưng liệu có cây tre nào cao đủ một trăm đốt? Anh đầy tớ phải làm sao? Mời các em cùng đọc truyện!\r\n', NULL),
                                                                                                                           (65, 'ISBN 978-604-988-223-4', 2022, 233, '20.5 x 13 x 0.5', 530, 'Tiếng Việt', 'Ngày nay, ta vẫn thường thấy con thạch sùng đậu trên bờ tường hoặc mái nhà mà chắt lưỡi kêu “Tạch, tạch!” Người đời bảo rằng, đó là do xưa kia thạch sùng vốn là một chàng trai giàu có, nên khi chết vẫn còn nhiều tiếc nuối. Câu chuyện về thạch sùng ra sao? Mời độc giả đón đọc Tranh Truyện Dân Gian Việt Nam - Sự Tích Con Thạch Sùng.\r\n', NULL),
                                                                                                                           (66, 'ISBN 978-604-988-998-8', 2022, 200, '20.5 x 13 x 0.5', 326, 'Tiếng Việt', 'Không chỉ ở địa điểm tổ chức Hội nghị Thượng đỉnh, nhiều vụ khủng bố còn đồng loạt xảy ra trên địa bàn thành phố vốn đã được bố trí an ninh nghiêm ngặt!! Trong khi Conan vắt óc suy nghĩ tìm hiểu mục đích thực sự của kẻ tội phạm, và công an tiến gần hơn tới âm mưu về một vụ án ẩn dấu, Hội nghị Thượng đỉnh Tokyo đã chính thức khai mạc!!\r\n', NULL),
                                                                                                                           (67, 'ISBN 978-604-988-765-9', 2020, 230, '20.5 x 13 x 0.5', 360, 'Tiếng Việt', 'Không chỉ ở địa điểm tổ chức Hội nghị Thượng đỉnh, nhiều vụ khủng bố còn đồng loạt xảy ra trên địa bàn thành phố vốn đã được bố trí an ninh nghiêm ngặt!! Trong khi Conan vắt óc suy nghĩ tìm hiểu mục đích thực sự của kẻ tội phạm, và công an tiến gần hơn tới âm mưu về một vụ án ẩn dấu, Hội nghị Thượng đỉnh Tokyo đã chính thức khai mạc!!\r\n', NULL),
                                                                                                                           (68, 'ISBN 978-604-988-988-9', 2022, 260, '20.5 x 13 x 0.5', 365, 'Tiếng Việt', 'Không chỉ ở địa điểm tổ chức Hội nghị Thượng đỉnh, nhiều vụ khủng bố còn đồng loạt xảy ra trên địa bàn thành phố vốn đã được bố trí an ninh nghiêm ngặt!! Trong khi Conan vắt óc suy nghĩ tìm hiểu mục đích thực sự của kẻ tội phạm, và công an tiến gần hơn tới âm mưu về một vụ án ẩn dấu, Hội nghị Thượng đỉnh Tokyo đã chính thức khai mạc!!\r\n', NULL),
                                                                                                                           (69, 'ISBN 978-604-988-765-7', 2022, 623, '20.5 x 13 x 0.5', 399, 'Tiếng Việt', 'Lấy 36 vụ án CÓ THẬT kinh điển nhất trong hồ sơ tội phạm của FBI, “Tâm lý học tội phạm - phác họa chân dung kẻ phạm tội” mang đến cái nhìn toàn cảnh của các chuyên gia về chân dung tâm lý tội phạm. Trả lời cho câu hỏi: Làm thế nào phân tích được tâm lý và hành vi tội phạm, từ đó khôi phục sự thật thông qua các manh mối, từ hiện trường vụ án, thời gian, dấu tích,… để tìm ra kẻ sát nhân thực sự. \r\n', NULL),
                                                                                                                           (70, 'ISBN 978-604-988-564-8', 2022, 215, '20.5 x 13 x 0.5', 894, 'Tiếng Việt', 'Tôi đã đọc quyển sách này một cách thích thú. Có nhiều kiến thức và kinh nghiệm hữu ích, những điều mới mẻ ngay cả với người gần trung niên như tôi. Tuổi trẻ đáng giá bao nhiêu? được tác giả chia làm 3 phần: HỌC, LÀM, ĐI. Nhưng tôi thấy cuốn sách còn thể hiện một phần thứ tư nữa, đó là ĐỌC. Hãy đọc sách, nếu bạn đọc sách một cách bền bỉ, sẽ đến lúc bạn bị thôi thúc không ngừng bởi ý muốn viết nên cuốn sách của riêng mình.\r\n', NULL),
                                                                                                                           (71, 'ISBN 978-604-988-445-8', 2020, 254, '20.5 x 13 x 0.5', 441, 'Tiếng Việt', 'Đắc nhân tâm của Dale Carnegie là quyển sách của mọi thời đại và một hiện tượng đáng kinh ngạc trong ngành xuất bản Hoa Kỳ. Trong suốt nhiều thập kỷ tiếp theo và cho đến tận bây giờ, tác phẩm này vẫn chiếm vị trí số một trong danh mục sách bán chạy nhất và trở thành một sự kiện có một không hai trong lịch sử ngành xuất bản thế giới và được đánh giá là một quyển sách có tầm ảnh hưởng nhất mọi thời đại.\r\n', NULL),
                                                                                                                           (75, 'ISBN 978-604-988-876-1', 2021, 778, '20.5 x 13 x 0.5', 145, 'Tiếng Việt', '“Tâm lý học tính cách” lấy “chín kiểu hình tính cách” làm trọng tâm, với nền tảng là những lý luận của tâm lý học tính cách và tâm lý học chiều sâu , giới thiệu đến bạn đọc một cách chi tiết về đặc trưng và phương pháp cải thiện khuyết điểm dành cho chín kiểu hình tính cách của con người.\r\n', NULL),
                                                                                                                           (76, 'ISBN 978-604-988-776-1', 2022, 895, '20.5 x 13 x 0.5', 120, 'Tiếng Việt', 'Nhắc đến biểu cảm siêu nhỏ, đa số chúng ta đều cho rằng đó chỉ là những biểu hiện cảm xúc từ ngũ quan trên khuôn mặt. Tuy nhiên, phạm vi của biểu cảm siêu nhỏ không chỉ gói gọn trên khuôn mặt một người, mà còn bao gồm những biểu cảm trên cơ thể, trong ngôn ngữ và hành vi của người đó.\r\n', NULL),
                                                                                                                           (77, 'ISBN 978-604-988-772-9', 2020, 895, '20.5 x 13 x 0.5', 150, 'Tiếng Việt', 'Bạn đã bao giờ cảm thấy như bạn đang nói chuyện với một bức tường? Chà, đó là một mô tả rất chính xác về những gì mà xảy ra khi hai người đang giao tiếp! Mọi người đều có một phép ẩn dụ “Bức tường giao tiếp” xung quanh họ để bảo vệ họ khỏi “những người xấu”. Nhưng trong tất cả các bức tường của chúng ta, chúng ta đã bỏ một số viên gạch ra, để cho “những người tốt” giao tiếp với chúng ta.\r\n', NULL),
                                                                                                                           (78, 'ISBN 978-604-988-887-9', 2021, 455, '20.5 x 13 x 0.5', 152, 'Tiếng Việt', 'Cái gì cũng nói toạc ra, cái gì cũng bộc lộ hết không phải là thẳng tính, mà là thiếu bản lĩnh. Suy cho cùng, tất cả những cảm xúc tiêu cực của con người đều là sự phẫn nộ dành cho bất lực của bản thân. Nếu bạn đúng, bạn không cần phải nổi giận. Nếu bạn sai, bạn không có tư cách nổi giận.\r\n', NULL),
                                                                                                                           (79, 'ISBN 978-604-988-342-2', 2022, 123, '20.5 x 13 x 0.5', 153, 'Tiếng Việt', 'Thất vọng, phẫn nộ, uất ức, đau đớn, buồn bã… là những cung bậc cảm xúc mà mỗi người đều phải nếm trải ít nhất một lần trong đời. Tuy nhiên, vấn đề lớn nhất là mọi người đều đang hiểu sai nỗi đau của bản thân. Chúng ta thường vô thức đắm chìm trong hàng tá suy nghĩ tiêu cực cứ chất chồng theo năm tháng để rồi vùi sâu vào thương tổn, và cuối cùng là bỏ rơi chính mình. \r\n', NULL),
                                                                                                                           (80, 'ISBN 978-604-988-453-8', 2020, 236, '20.5 x 13 x 0.5', 662, 'Tiếng Việt', 'Bạn sẽ yên tâm hơn, tự tin hơn như được ở bên cạnh một nhà tâm lý học thấu hiểu và luôn chia sẻ cùng bạn khi có trong tay cuốn sách “Buông bỏ buồn buông”. Cuốn sách sẽ giúp bạn bóc tách những lo âu, phiền não ra khỏi tâm trí; giúp bạn có một cái nhìn về cuộc sống lạc quan, vui vẻ cách ứng xử thông và nhẹ nhàng hơn.\r\n', NULL),
                                                                                                                           (82, 'ISBN 978-604-988-998-1', 2020, 223, '20.5 x 13 x 0.5', 332, 'Tiếng Việt', 'Cuộc sống ngày càng trở nên bận rộn và hối hả. Chúng ta luôn chạy đua với thời gian, công việc, những suy nghĩ và cả những con đường mà đôi khi ta đánh mất đi chính mình, quên đi việc nuôi dưỡng trái tim và tinh thần. Tôi tin rằng đã có lúc bạn từng cảm thấy băn khoăn và tự hỏi niềm vui trong công việc và cuộc sống của mình là gì? Ý nghĩa thật sự của cuộc đời mình là gì đây?\r\n', NULL),
                                                                                                                           (83, 'ISBN 978-604-988-776-9', 2022, 223, '20.5 x 13 x 0.5', 254, 'Tiếng Việt', 'Mỗi ngày ta thức dậy, ấy là ta có trọn vẹn một ngày mới. Nhưng không phải ai cũng nhận ra hạnh phúc diệu kỳ này, để rồi lãng phí một cơ hội tận hưởng niềm vui. Không phải ai cũng biết tận dụng tối đa từng giây từng phút của một ngày quý gia để tạo ra niềm vui cho chính mình.\r\n', NULL),
                                                                                                                           (86, 'ISBN 978-604-988-429-3', 2022, 224, '20.5 x 13 x 0.5', 212, 'Tiếng Việt', 'Thật sự truyền cảm hứng và vô cùng dí dỏm, những câu chuyện và những suy ngẫm ngắn trong sách Ai đổ đống rác ở đây? mang lại cho chúng ta trí tuệ phi thời gian về mọi chủ đề, từ tình yêu và sự cam kết đến nỗi sợ hãi và đau đớn. Rút ra từ trải nghiệm sống của chính mình cũng như những truyện cổ Phật giáo, Ajahn Brahm tạo ra một cuốn sách tuyệt vời cho mọi lứa tuổi.\r\n', NULL),
                                                                                                                           (200, 'ISBN 978-604-15-0234-1', 2022, 450, '24 x 17', 420, 'Tiếng Việt', 'Giáo trình Lập Trình Hướng Đối Tượng Với Java cung cấp kiến thức nền tảng về OOP sử dụng ngôn ngữ Java. Nội dung: lớp và đối tượng, kế thừa, đa hình, đóng gói, xử lý ngoại lệ, lập trình GUI với Swing, kết nối CSDL JDBC.\n\nNXB Giáo Dục – Năm XB: 2022 – 420 trang – Bìa Mềm', NULL),
                                                                                                                           (201, 'ISBN 978-604-15-0512-0', 2021, 480, '24 x 17', 452, 'Tiếng Việt', 'Giáo trình Cơ Sở Dữ Liệu trình bày lý thuyết và thực hành thiết kế, quản trị CSDL quan hệ. Nội dung: mô hình ER, chuẩn hóa dữ liệu, SQL, giao dịch, bảo mật. Thực hành với MySQL/MariaDB.\n\nNXB Giáo Dục – Năm XB: 2021 – 452 trang – Bìa Mềm', NULL),
                                                                                                                           (202, 'ISBN 978-604-15-0344-7', 2020, 520, '24 x 17', 498, 'Tiếng Việt', 'Giáo trình Mạng Máy Tính trình bày nguyên lý và thực hành mạng máy tính. Nội dung: mô hình OSI/TCP-IP, các giao thức mạng (HTTP, DNS, DHCP), định tuyến, bảo mật mạng.\n\nNXB Giáo Dục – Năm XB: 2020 – 498 trang – Bìa Mềm', NULL),
                                                                                                                           (203, 'ISBN 978-604-15-0423-9', 2021, 460, '24 x 17', 436, 'Tiếng Việt', 'Giáo trình Cấu Trúc Dữ Liệu Và Giải Thuật trình bày các cấu trúc dữ liệu cơ bản: danh sách liên kết, ngăn xếp, hàng đợi, cây, đồ thị; các giải thuật sắp xếp, tìm kiếm và phân tích độ phức tạp O-notation.\n\nNXB Giáo Dục – Năm XB: 2021 – 436 trang – Bìa Mềm', NULL),
                                                                                                                           (204, 'ISBN 978-604-15-0667-7', 2020, 500, '24 x 17', 476, 'Tiếng Việt', 'Giáo trình Hệ Điều Hành trình bày quản lý tiến trình, lập lịch CPU, đồng bộ hóa, quản lý bộ nhớ ảo, quản lý file system. Thực hành trên Linux.\n\nNXB Giáo Dục – Năm XB: 2020 – 476 trang – Bìa Mềm', NULL),
                                                                                                                           (205, 'ISBN 978-604-15-0789-1', 2021, 480, '24 x 17', 452, 'Tiếng Việt', 'Kỹ Thuật Điện Tử trình bày nguyên lý hoạt động của các linh kiện điện tử, mạch khuếch đại, mạch số, vi xử lý cơ bản. Đi kèm bài thực hành trong phòng lab.\n\nNXB Giáo Dục – Năm XB: 2021 – 452 trang – Bìa Mềm', NULL),
                                                                                                                           (206, 'ISBN 978-604-15-0345-6', 2020, 420, '24 x 17', 398, 'Tiếng Việt', 'Giáo trình Mạch Điện trình bày lý thuyết mạch điện tuyến tính, phân tích mạch một chiều và xoay chiều, mạch cộng hưởng, hàm truyền và ứng dụng.\n\nNXB Giáo Dục – Năm XB: 2020 – 398 trang – Bìa Mềm', NULL),
                                                                                                                           (207, 'ISBN 978-604-15-0891-2', 2022, 520, '24 x 17', 492, 'Tiếng Việt', 'Sức Bền Vật Liệu trình bày lý thuyết biến dạng và ứng suất trong kết cấu chịu lực. Nội dung: kéo nén, uốn, xoắn, ổn định cột, phân tích biến dạng. Có bài tập từng chương.\n\nNXB Giáo Dục – Năm XB: 2022 – 492 trang – Bìa Mềm', NULL),
                                                                                                                           (208, 'ISBN 978-604-15-0654-3', 2021, 480, '24 x 17', 456, 'Tiếng Việt', 'Cơ Học Kỹ Thuật trình bày tĩnh học, động học và động lực học cho các kỹ sư cơ khí. Nội dung: hệ lực, cân bằng, chuyển động chất điểm và vật rắn, năng lượng và công suất.\n\nNXB Giáo Dục – Năm XB: 2021 – 456 trang – Bìa Mềm', NULL),
                                                                                                                           (209, 'ISBN 978-604-15-1234-7', 2022, 420, '24 x 17', 398, 'Tiếng Việt', 'Giáo trình Kinh Tế Vi Mô được biên soạn theo chương trình Bộ GD&ĐT. Nội dung: lý thuyết cung – cầu, hành vi người tiêu dùng, lý thuyết sản xuất và chi phí, cấu trúc thị trường.\n\nNXB Giáo Dục – Năm XB: 2022 – 398 trang – Bìa Mềm', NULL),
                                                                                                                           (210, 'ISBN 978-604-15-1356-6', 2022, 420, '24 x 17', 402, 'Tiếng Việt', 'Giáo trình Kinh Tế Vĩ Mô cung cấp kiến thức kinh tế tầm quốc gia. Nội dung: đo lường GDP, tăng trưởng, thất nghiệp, lạm phát, chính sách tài khóa và tiền tệ, thương mại quốc tế.\n\nNXB Giáo Dục – Năm XB: 2022 – 402 trang – Bìa Mềm', NULL),
                                                                                                                           (211, 'ISBN 978-604-15-0912-8', 2020, 480, '24 x 17', 456, 'Tiếng Việt', 'Quản Trị Kinh Doanh trình bày các nguyên lý quản lý hiện đại: hoạch định chiến lược, tổ chức, lãnh đạo, kiểm soát, quản trị nhân sự và tài chính.\n\nNXB Giáo Dục – Năm XB: 2020 – 456 trang – Bìa Mềm', NULL),
                                                                                                                           (212, 'ISBN 978-604-15-0789-6', 2021, 440, '24 x 17', 416, 'Tiếng Việt', 'Marketing Căn Bản (Philip Kotler) dịch sang tiếng Việt, trình bày Marketing Mix (4P), phân khúc và định vị thị trường, hành vi người tiêu dùng, marketing kỹ thuật số.\n\nNXB Giáo Dục – Năm XB: 2021 – 416 trang – Bìa Mềm', NULL),
                                                                                                                           (213, 'ISBN 978-604-15-0977-2', 2021, 460, '24 x 17', 438, 'Tiếng Việt', 'Tài Chính Doanh Nghiệp trình bày các quyết định đầu tư, cơ cấu vốn, chi phí vốn, định giá doanh nghiệp, quản trị vốn lưu động và chính sách cổ tức.\n\nNXB Giáo Dục – Năm XB: 2021 – 438 trang – Bìa Mềm', NULL),
                                                                                                                           (214, 'ISBN 978-604-15-0788-4', 2020, 400, '24 x 17', 378, 'Tiếng Việt', 'Phân Tích Tài Chính hướng dẫn đọc và phân tích báo cáo tài chính doanh nghiệp: bảng cân đối kế toán, kết quả hoạt động kinh doanh, lưu chuyển tiền tệ và các chỉ số tài chính.\n\nNXB Giáo Dục – Năm XB: 2020 – 378 trang – Bìa Mềm', NULL),
                                                                                                                           (215, 'ISBN 978-604-15-0456-8', 2022, 420, '24 x 17', 398, 'Tiếng Việt', 'Nguyên Lý Kế Toán trình bày nguyên tắc cơ bản của kế toán tài chính: hệ thống tài khoản, phương trình kế toán, ghi chép nghiệp vụ, lập báo cáo tài chính.\n\nNXB Giáo Dục – Năm XB: 2022 – 398 trang – Bìa Mềm', NULL),
                                                                                                                           (216, 'ISBN 978-604-11-9234-5', 2021, 850, '24 x 17', 812, 'Tiếng Việt', 'Giải Phẫu Học Người Tập 1 (Nguyễn Quang Quyền chủ biên) mô tả hệ vận động: xương, khớp, cơ. Là tài liệu học tập bắt buộc cho sinh viên Y, Điều dưỡng, Dược năm I–II.\n\nNXB Y Học – Năm XB: 2021 – 812 trang – Bìa Cứng', NULL),
                                                                                                                           (217, 'ISBN 978-604-11-8876-8', 2020, 780, '24 x 17', 748, 'Tiếng Việt', 'Sinh Lý Học Y Khoa (Guyton & Hall – Bản dịch tiếng Việt) trình bày cơ chế hoạt động của các hệ thống cơ quan trong cơ thể người: tim mạch, hô hấp, thần kinh, nội tiết, thận và tiêu hóa.\n\nNXB Y Học – Năm XB: 2020 – 748 trang – Bìa Mềm', NULL),
                                                                                                                           (218, 'ISBN 978-604-11-9567-4', 2022, 720, '24 x 17', 692, 'Tiếng Việt', 'Dược Lý Học (Tái Bản 2022) trình bày cơ chế tác dụng, chỉ định, chống chỉ định và tác dụng phụ của các nhóm thuốc chính: kháng sinh, tim mạch, thần kinh, giảm đau, kháng viêm.\n\nNXB Y Học – Năm XB: 2022 – 692 trang – Bìa Mềm', NULL),
                                                                                                                           (219, 'ISBN 978-604-11-8234-6', 2020, 580, '24 x 17', 554, 'Tiếng Việt', 'Hóa Học Dược Tập 1 trình bày mối liên hệ giữa cấu trúc hóa học và tác dụng sinh học của thuốc: đại cương hóa dược, phương pháp tổng hợp và phân tích thuốc cơ bản.\n\nNXB Y Học – Năm XB: 2020 – 554 trang – Bìa Mềm', NULL),
                                                                                                                           (220, 'ISBN 978-604-15-0178-3', 2021, 380, '24 x 17', 358, 'Tiếng Việt', 'Đại Số Tuyến Tính trình bày ma trận và định thức, hệ phương trình tuyến tính, không gian vectơ, ánh xạ tuyến tính, trị riêng và vectơ riêng, dạng toàn phương.\n\nNXB Giáo Dục – Năm XB: 2021 – 358 trang – Bìa Mềm', NULL),
                                                                                                                           (221, 'ISBN 978-604-15-0267-9', 2021, 400, '24 x 17', 378, 'Tiếng Việt', 'Giải Tích 1 trình bày giới hạn và liên tục, đạo hàm và vi phân, ứng dụng đạo hàm (tìm cực trị, vẽ đồ thị), tích phân xác định và bất định, tích phân suy rộng.\n\nNXB Giáo Dục – Năm XB: 2021 – 378 trang – Bìa Mềm', NULL),
                                                                                                                           (222, 'ISBN 978-604-15-0123-9', 2021, 400, '24 x 17', 376, 'Tiếng Việt', 'Vật Lý Đại Cương Tập 1 (Cơ Nhiệt): động học chất điểm, định luật Newton, công – năng lượng, va chạm, chuyển động quay; nhiệt động lực học I & II, thuyết động học phân tử.\n\nNXB Giáo Dục – Năm XB: 2021 – 376 trang – Bìa Mềm', NULL),
                                                                                                                           (223, 'ISBN 978-604-15-0124-6', 2021, 380, '24 x 17', 358, 'Tiếng Việt', 'Vật Lý Đại Cương Tập 2 (Điện Từ – Quang): điện trường, từ trường, điện từ cảm ứng, sóng điện từ, quang học sóng, quang học lượng tử, cơ học lượng tử cơ sở.\n\nNXB Giáo Dục – Năm XB: 2021 – 358 trang – Bìa Mềm', NULL),
                                                                                                                           (224, 'ISBN 978-604-15-0245-7', 2022, 420, '24 x 17', 396, 'Tiếng Việt', 'Hóa Học Đại Cương trình bày cấu tạo nguyên tử, liên kết hóa học, nhiệt hóa học, động hóa học, cân bằng hóa học, dung dịch và điện hóa học.\n\nNXB Giáo Dục – Năm XB: 2022 – 396 trang – Bìa Mềm', NULL),
                                                                                                                           (225, 'ISBN 978-604-15-0567-9', 2021, 350, '24 x 17', 328, 'Tiếng Việt', 'Sinh Học Tế Bào trình bày cấu trúc và chức năng tế bào nhân thực: màng tế bào, bào quan, chu kỳ tế bào, phân bào, truyền tin tế bào và sự chết theo chương trình.\n\nNXB Giáo Dục – Năm XB: 2021 – 328 trang – Bìa Mềm', NULL),
                                                                                                                           (226, 'ISBN 978-604-0-23761-8', 2021, 280, '24 x 17', 268, 'Tiếng Việt', 'Giáo trình Triết Học Mác - Lênin ban hành theo QĐ 4890/QĐ-BGDĐT năm 2021, dùng cho sinh viên không chuyên ngành Lý luận chính trị. Nội dung: triết học và vai trò trong đời sống; chủ nghĩa duy vật biện chứng; chủ nghĩa duy vật lịch sử.\n\nNXB Chính Trị Quốc Gia Sự Thật – Năm XB: 2021 – 268 trang – Bìa Mềm', NULL),
                                                                                                                           (227, 'ISBN 978-604-0-23762-5', 2021, 260, '24 x 17', 250, 'Tiếng Việt', 'Giáo trình Kinh Tế Chính Trị Mác - Lênin ban hành theo QĐ 4890/QĐ-BGDĐT năm 2021. Nội dung: hàng hóa và quy luật kinh tế; lý luận giá trị thặng dư; kinh tế thị trường định hướng XHCN.\n\nNXB Chính Trị Quốc Gia Sự Thật – Năm XB: 2021 – 250 trang – Bìa Mềm', NULL),
                                                                                                                           (228, 'ISBN 978-604-0-23763-2', 2021, 240, '24 x 17', 232, 'Tiếng Việt', 'Giáo trình Lịch Sử Đảng Cộng Sản Việt Nam ban hành theo QĐ 4890/QĐ-BGDĐT năm 2021. Nội dung: sự ra đời của Đảng; Đảng lãnh đạo đấu tranh giành chính quyền; kháng chiến; đổi mới và hội nhập.\n\nNXB Chính Trị Quốc Gia Sự Thật – Năm XB: 2021 – 232 trang – Bìa Mềm', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `carts`
--

CREATE TABLE `carts` (
                         `id` int(11) NOT NULL,
                         `idUser` int(11) DEFAULT 0,
                         `timeShip` varchar(50) DEFAULT NULL,
                         `feeShip` int(11) DEFAULT 0,
                         `totalPrice` int(11) UNSIGNED DEFAULT 0,
                         `infoShip` int(11) DEFAULT 0,
                         `create_time` timestamp NULL DEFAULT NULL,
                         `verify` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `carts`
--

INSERT INTO `carts` (`id`, `idUser`, `timeShip`, `feeShip`, `totalPrice`, `infoShip`, `create_time`, `verify`) VALUES
                                                                                                                   (28, 38, '2023/12/04 - 2023/12/07', 0, 167199, 1, '2023-11-29 11:58:07', NULL),
                                                                                                                   (29, 49, '2026-05-26', 0, 67200, 4, '2026-05-23 15:38:36', 'G8L4hsgfhOaqFZD0iFS8LhyeGwX72UEDXSru9xwriiAVjzH6jg+FIu67RkewrucN1g2j0/ZrGSgH3EexjSo/WTTmK+Mtc2/TU67pkogBhJ50ckuuQx9H4rkipssTZeSzxC+ChkcwvdOKZjHjR8wOB5KxJUfGifRF5nf0D2HUbuvZ3+ecCsfp0W85zvEVwqVYO7LcCIrRFnA4pXH8W85y1eG4dPt7ceFZAzBx6V788TvnyAR6ygM2cBllxHZ+P7u14YYUTgaLf7jf+2bghSrVe5UApd7RurUux02F+oVNXDK9wYf1gUPZaE0gjthztOEkk3r1XWuZm8X4VZfyaW692w=='),
                                                                                                                   (30, 49, '2026-05-26', 0, 150000, 3, '2026-05-23 15:59:09', NULL),
                                                                                                                   (31, 49, '2026-05-26', 0, 72000, 3, '2026-05-23 16:27:25', NULL),
                                                                                                                   (32, 49, '2026-05-27', 0, 450000, 4, '2026-05-24 12:48:10', NULL),
                                                                                                                   (33, 49, '2026-05-27', 0, 600000, 4, '2026-05-24 13:13:02', NULL),
                                                                                                                   (34, 49, '2026-05-27', 0, 600000, 4, '2026-05-24 13:19:08', 'J9swAZFDd9WS6ZrC5Kc3DgOoo517SAtGgfvdb5ihJ1eMWe0aclbiCTk39RPOuHSf8IHhqg18gLL69DRPkU0Ev/Mx2NLmXxzLqnk+WJhRFe7zJSvS8Kg4XQvCciIucrngkzJX5tLKih8SFnpynpERKfOcHu5keAjmKyj+0BC2fID5jSYKG5SmdLz/IxWTBMj7P4XAz8Qihzrl1Rm/5IdYMmxZheWtmxuvbNvC7035IyROXzS/c8aTIhyiNlqxUOTdsdkzgGTQbyN15sWT6xh4rPnZcVyhyicUlel6OkaOOd7iqpP0RgUA2jve1GGs1rs2FQsL0M/qIO4GBZEVAsiEEA=='),
                                                                                                                   (35, 49, '2026-05-27', 0, 333600, 4, '2026-05-24 13:28:00', 'ecWwC8vqV6b6odnMdknWpm7O2WNcM6cfWcZ42Fy2ZF/UNxxWM6QhgKj2EGmmDMkg+b1o+q9sgiR5fq/cmeCc4Z/idAN5pC3keAir4YYcDYAJMGZc3F2gnRgYpfAK9PVOCDfjfjn0R+l8CKd0yShpCrIOw+BTK49v5WMjPMBQL+6c4nPawxCK+1NECwLPdLPdJ5q9Vz6rMpPLiatxU7zH1hKGkUChPj5Eiseg6RNyN9xoT7bq3s8cR/9w4JHi8l9ewgMqqjT3wnS0uRf/lx44bQII7SFo+RyNDqQ2uuQGzZPkLWxWyfzrnvcZgyfwWQrjfNCHKSwvhFEn3I3a43fh1A=='),
                                                                                                                   (36, 49, '2026-05-28', 0, 900000, 4, '2026-05-25 02:08:51', 'uFHvBXkCnXlzR/9Mec4G9hTZNJL0l1ZaJPB1V7DHe1ISyQL1go4k/M1rmaQcs3qXszw+as6F+8MoZo5bE1Y0PfTkTeGFTrnDQKLFITbL7qu9LUsAFd/XkxuyEJcljltgf1d7OsP/Azgs3MiqDdNF35q+Yq6Zn/HOJTj2Izwtbp+5MyXxu7vcYZAbxxOU/abToLW1pin9fw+XJjh1AU2Blu4MSE8mqEfX5BgX9JX0cb8PKnAHSTDugvN4gIcwh9nSODzCjxRfz0/ecVlvU29C2mTaxlefpdwV50PPfBxrD0xzV8K/CoPaPJMzFdbGRqd3ZW3wJ0ctK/4ElVk9wGDjdA=='),
                                                                                                                   (37, 49, '2026-05-28', 0, 72000, 4, '2026-05-25 02:09:31', 'fK0XCVD/s0q/7xV1+xHGM7lyjhFj3/fYmA7dyVDCSh1Oie8Lp+xHCsHcTkWtaQsdQqKxP7Jvgd8+TBUhqwsCbyzCbUWVmSlUuBKWmadZWUOqw/3iPMhrsrTgZN4tFIDOmk1hWLNX9LtxI5qE2lDIi4d4RUnz8nv7yFZwgX6DCfUSWG9K1EhWmRRcBHIaawCnSK3CpUDw9FuSFupPOkQ9DKauvNqlvSouoPWQ9XWNODMNC1jbrFZ6yQwP/IziJVlpHEp+AQMwrnWsaatDNg+nL/RXRfsQw12B8Dv4yBP1TBa59ceScxde1KDVLUPMmQvAayp/aeFD8g39VnyPE7cLoA=='),
                                                                                                                   (38, 49, '2026-05-29', 0, 150000, 4, '2026-05-26 15:51:25', 'qNygpHIPL+LXVifzH5Hwrpzb6GwGg4XlUyfqJjtkW3MowDe0ou+G/XRnblGxXUl9boQdWkz57sXSxapN+AiupQExiPbJ9eFPYRvz6ClRjtKY4vuv3AiYRysY+6LWDL8JhjsdRfC2B73xZcI59dIq2EgYF3XY0B5JiStjvSHz/FH87giAYxRgExPm2ojx9VF8pnG9f1mgT5EgHmBNYmvH7KQeX8lKh+GKA73OXch/8L3vnxbsuEQ+eww29Q58hjV4KzECdYZ1ybO+zKDqgzswwfUaz99xQ1pVSInlEfiWcsmyWqnWldkyNweqWMeWsKKyKnH6eYY50b8BKeHU2ZXNpA=='),
                                                                                                                   (39, 49, '2026-05-29', 0, 150000, 4, '2026-05-26 15:51:32', 'IJ81uPNuDQHHV2LutopDh0sGV163QIL0ssTfPvGESQVUarjzqsey9Mzy959JcxdQ5cIjc9Sx4XJ7GPn2IDvKZxqAtiBBsjYVQK7tBxDcyQarQipVbSw4fRZP3bKi47TVnTInAa6aAT1Ue2Gj63CYuKEdTeW3bJgGd5C86c8hOxBb0n39ifOWbqzQtbFkmUaEeGydQP+1WA4p8eM5MEzOuInkkIWmillILhWRy49hjKJ4Kzlw/tgw7D9g3oBCviMHVX+zPY8cvnubUGQlzt325RmpMc5rqMM3uESkO/Bnz19xq3ApvDvhniXvfN3mVWFGP+gyOW7kkXZQJ9yp6rZVwA=='),
                                                                                                                   (40, 49, '2026-05-29', 0, 150000, 4, '2026-05-26 16:06:29', 'jogClzioxw/kqfNj9caLnO4KcLACmPsU50eELTyIYg+FRRAksb3gi2Hr8YcQ/o7aYUqRKNlME3gXTr1JjD/4XVb8FsbJHtOZ/fk23GddM2zlTrCOus5tnc2lXeqUC+r0E0O9ty+GTn04NXiFdQ6dG2Y3Hv61GiGp4qondvFWfadQHWEL18dzRAzV5u+O1hdHUDBUiw0Zw5YYpYLsQeh+cJLJNqzgZRZWrjpB5mp81KgKwyUU6PhdgDQEwxLCcpI5d6o2ucylbLA9Ytd6CYZcxSKNm6JyBQFXVJMmzfpmeUJN2v5oThqQ1jA0e10M+l7LR4WZZ5Kqgc2nhR9cxepUdw=='),
                                                                                                                   (41, 49, '2026-05-29', 0, 33600, -1, '2026-05-26 16:52:44', NULL),
                                                                                                                   (42, 49, '2026-05-29', 0, 72000, -1, '2026-05-26 16:57:56', NULL),
                                                                                                                   (43, 49, '2026-05-30', 0, 327600, -1, '2026-05-26 17:25:06', NULL),
                                                                                                                   (44, 49, '2026-05-30', 0, 327600, -1, '2026-05-26 17:25:19', NULL),
                                                                                                                   (45, 49, '2026-05-30', 0, 144000, -1, '2026-05-26 17:27:06', NULL),
                                                                                                                   (46, 49, '2026-05-30', 0, 150000, -1, '2026-05-26 17:30:18', NULL),
                                                                                                                   (47, 49, '2026-06-22', 30000, 159200, 1, '2026-06-19 02:03:53', NULL),
                                                                                                                   (48, 49, '2026-06-22', 30000, 450000, 4, '2026-06-19 07:17:17', 'GQMDy0QKq/lUBn0Rv2+HGc35QvZvDM/ZH1GJbm4r+eAy2YNVqXa/67gEkmbAtWQVsdJ0pt4WD96SsHK/AGwLyAURktnsdq6aPlsiX7nU2zierMb8/ro1ixhQmdLjBw7x1LZgH5FlWpyl+0/5P3wFiUH3/p9a5FBkpEh+0fKKt5gxUxheYVEVrYNM8fD7+LSiMKAZXrTo45br7+k8L6EtqB0glbpv1z4Tb3lJK8PBdRw/3Hcz9TenI76xBhBsr0jOHcBebsfzlK+ACf1Sc0TMhFjCYQZZP7a0W2+EUZTtTNjReBiw9557hdOXh9uIgFwUTOrpsq7Um+UGkwH5YqG8pg=='),
                                                                                                                   (49, 49, '2026-06-22', 30000, 236000, 1, '2026-06-19 07:47:50', NULL),
                                                                                                                   (50, 49, '2026-06-22', 0, 72000, 4, '2026-06-19 07:51:54', 'yCz0sAoJRBva2/BqG6iKCASP9UIzcBUdB238dc0BJKOu7ZMwm1OkLjrRjVSXoyUJenh1lNbT9uMkoh0VbeXKlU6/HZVio0LWOPh71wkX7MAbmv0npXFI1d/9dtJcxpjwYY8i36+7VtdLCZ2Fpwp3woRpHmr+yCkLmoN+JF2b4oV6uxnggLA0mILjlRn/qxExQ0MfDjsoWPPQSX/h/Zsto3FATMeT5bQlY4HSZh/6vzVFoXagHZ2kK7qeTzvfVTufJUw3eZqo+8LjNWXhXYf67kga4u2rz5tfHBd3LOkfeVIcAR3QO9TOgZkRnlocR4ZDydusrs3UP5kvDZNmChAJTA=='),
                                                                                                                   (51, 49, '2026-06-22', 30000, 320000, 1, '2026-06-19 14:57:55', NULL),
                                                                                                                   (52, 49, '2026-06-22', 0, 72000, 1, '2026-06-19 15:04:36', NULL),
                                                                                                                   (53, 49, '2026-06-22', 30000, 620000, 1, '2026-06-19 15:30:03', NULL),
                                                                                                                   (54, 49, '2026-06-22', 30000, 308000, 4, '2026-06-19 15:31:57', 'bE1kqJrispzRdo/fgoU6uBGM8gkDkgyeYGzCqpdmSeEg4ugaz9yCVLrsHC0h+p8mtkKcyVrarKxhnmjnA9b83/Hoo3HOouOpNmHrSlD4wp25/wtAZibGsVARyy6pGwLlPv11BMPu6KQVPRc/vf7Yjmxgzh5l7230M73OBQpAu0AUsGaGcOzlRiMenuKRrsYyRE0Hw8XKdkmKAZ6DF2BPv0S+cEo7+5XyWZyzn6To2WUqpk9wO1eNhXL/Wx6PLyrlxFSFrVf8D/PL06eq+4XnSIKTNzax/sqTlOUyHtvOwdhJBiwZEkPg4D0PYXeLg6G8zbtBLliI+uu/hxy2fEpjHA==                '),
                                                                                                                   (55, 49, '2026-06-24', 30000, 320000, 4, '2026-06-21 14:32:22', NULL),
                                                                                                                   (56, 49, '2026-06-24', 30000, 100000, 4, '2026-06-21 14:40:02', 'TQMLs7DEdRA4/nU5a5u45gRLw4uKZf7Hhfl1n2eivjhxz/gTOSRXI0dxttLaaharCRMYfKjG7ycgx+IZLF1EsS/NkeZhOFqjDvdgaNXfFKlif+6J2UGAkTy/6rbGRTt2HhELBuGNf5XU1Wtlpjhws5OUiyBomlZvEi8KUQ23dg2+vo1N/3YC3i+ayzsqMm6Pj+umsTswzUdjspby+yrDXij8iXJGchA2zBSMLzRkN6sQ0i9EydXw0SA0GS+Y4TThy34TFCu11WP71RTsCNmODQbGdrIUsYV8bbu1mWeFo3hJrXPWSda1fourid+OxdCc9gNRkag/ctm0a/uVCG8L9Q==                '),
                                                                                                                   (57, 49, '2026-06-24', 0, 299997, 4, '2026-06-21 15:35:44', 'A17W5KS+XTpBrgSpo7+9Wam+HIdEMVVxSaIZQrybJuCW9BY1Hl55MOATt9c8sTWXVabfMGGAp0L03xg1CiXdX2MUSs2fs92MQzn0pa4DrkKRWoE/jv4tt5uVOkhk1/RfRJTLU3e7u30Ik5Jo+wmiHx3wOEwwiFdey5mNDaK5AcWH2TFnKoUqwnwylQIics/cBBiGBkSOH7azzbH8x2A056lXG7DzEXZuIM1uZxSs4j0FU6AUIzpIxe1lwK44i0yaXm1p9qwPAX5bG3jFofoDdplnahL6QrRp8weIKCEpGYfMscl/s9Sccbw/ZlrXm5hmKCet2f0xUh1oFVY5dL9Acw==                '),
                                                                                                                   (58, 49, '2026-06-24', 30000, 48999, 4, '2026-06-21 15:58:42', 'ALVeCJYX6QGl6eyHpWCtePTiG+J1GUrfThxqwA4HsmvaeZye8nLVEHR1LsBLTtaM8Msh7dUEMe0YzXiTMc9ofrBU0YZeBTP6yvkRZ9IrtciifMoaarO2PYZby6s8DJZuFgUXA71YAugwCxBVmDMsN/HBh6TloCmFKnY0UJodC76RafvjBY5xU/HhmWCd5/uRamuOUSpW1wfTTQgQDRzAZ9jyyDO7DHL9UxQBVvyDEoLx8l62IzbIEIuyPF+EpkT/nkusYCIT+bNxqRBckPklnkunCVgd6NEhUjUQlJeNT9eJ+tHGOaOb7GgN7fDYijtX+xsogFVGLXa54mZq6eC0LQ==                '),
                                                                                                                   (59, 49, '2026-06-27', 30000, 460000, 1, '2026-06-24 02:07:50', '2089081e7fcb178cdc1790b45a2164a49aa4b5526ccfd0aae431eb9310373c94                '),
                                                                                                                   (60, 49, '2026-07-02', 0, 300000, 1, '2026-06-29 01:12:49', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart_detail`
--

CREATE TABLE `cart_detail` (
                               `id` int(11) NOT NULL,
                               `cart_id` int(11) DEFAULT NULL,
                               `product_id` int(11) DEFAULT NULL,
                               `quantity` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `catalog`
--

CREATE TABLE `catalog` (
                           `id_catalog` int(11) NOT NULL,
                           `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
                           `parent_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `catalog`
--

INSERT INTO `catalog` (`id_catalog`, `name`, `parent_id`) VALUES
                                                              (1, 'Khoa Học Kỹ Thuật', 1),
                                                              (2, 'Lịch Sử - Địa Lý - Tôn Giáo', 2),
                                                              (3, 'Truyện Tranh', 3),
                                                              (4, 'Sách Kinh Tế', 4),
                                                              (5, 'Sách Thiếu Nhi', 5),
                                                              (6, 'Tạp Chí - Báo', 6),
                                                              (7, 'Sách Tâm Lý - Kĩ Năng Sống', 7),
                                                              (8, 'Văn Học Nước Ngoài', 8),
                                                              (9, 'Văn Học Trong Nước', 9),
                                                              (12, 'Sách Giáo Trình', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `contact`
--

CREATE TABLE `contact` (
                           `id_contact` int(11) NOT NULL,
                           `id_user` int(11) NOT NULL,
                           `full_name` varchar(50) DEFAULT NULL,
                           `phone_number` varchar(15) NOT NULL,
                           `email_contact` varchar(50) NOT NULL,
                           `content_contact` varchar(500) NOT NULL,
                           `status` int(11) NOT NULL DEFAULT 0,
                           `feedback_content` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `contact`
--

INSERT INTO `contact` (`id_contact`, `id_user`, `full_name`, `phone_number`, `email_contact`, `content_contact`, `status`, `feedback_content`) VALUES
                                                                                                                                                   (1, 4, 'Tần Phong', '0234678179', 'phong@gmail.com', 'Đơn hàng vận chuyển quá lâu', 0, NULL),
                                                                                                                                                   (2, 12, 'Hoàng Mỹ Duyên', '0329810578', 'myduyen@gmail.com', 'Sách nhận được bị rách bìa', 0, NULL),
                                                                                                                                                   (3, 6, 'Vương Tuấn Khải', '0329476587', 'karrywang@gmail.com', 'Giao sách quá cũ, giấy ngã vàng', 0, NULL),
                                                                                                                                                   (4, 18, 'Nguyễn Dư Lập', '0867415853', '20130302@st.hcmuaf.edu.vn', 'Sách đắc nhân tâm còn không ạ', 0, NULL),
                                                                                                                                                   (5, 18, 'Nguyá»n DÆ° Láº­p', '0867415853', '20130302@st.hcmuaf.edu.vn', 'SÃ¡ch Äáº¯c nhÃ¢n tÃ¢m cÃ²n khÃ´ng áº¡!', 1, 'SÃ¡ch váº«n cÃ²n ban, báº¡n muá»n mua bao nhiÃªu');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `customer`
--

CREATE TABLE `customer` (
                            `id_user` int(11) NOT NULL,
                            `first_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
                            `last_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
                            `email` varchar(100) NOT NULL,
                            `password` varchar(50) NOT NULL,
                            `address` varchar(255) DEFAULT NULL,
                            `phone` varchar(15) DEFAULT NULL,
                            `created_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                            `role` varchar(20) DEFAULT NULL,
                            `status` int(11) DEFAULT NULL,
                            `attempts` int(11) DEFAULT 3,
                            `lock_time` int(11) DEFAULT -1,
                            `typeLogin` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `customer`
--

INSERT INTO `customer` (`id_user`, `first_name`, `last_name`, `email`, `password`, `address`, `phone`, `created_time`, `role`, `status`, `attempts`, `lock_time`, `typeLogin`) VALUES
                                                                                                                                                                                   (1, 'Nguyễn', 'Uyên Thư', 'admin@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12', 'Tịnh Sơn - Sơn Tịnh - Quảng Ngãi', '0932766789', '2026-03-23 01:36:24', 'admin', 1, 1, -1, 1),
                                                                                                                                                                                   (2, 'Hoàng', 'Minh An', 'minan@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Hòa Ninh - Hoà Vang - Đà Nẵng', '0927378788', '2023-11-28 00:53:40', 'mod', 1, 1, -1, 1),
                                                                                                                                                                                   (3, 'Lâm', 'Tố Mỹ', 'tomy@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Phường Yên Hòa - Quận Cầu Giấy - Hà Nội', '0127856567', '2023-11-28 00:53:40', 'mod', 1, 3, -1, 1),
                                                                                                                                                                                   (4, 'Đoàn', 'Phong', 'phong@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Phường Mai Dịch - Quận Cầu Giấy - Hà Nội', '0234678179', '2023-11-28 00:53:39', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (5, 'Hà', 'Minh Minh', 'minh@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Phường Nghĩa Tân - Cầu Giấy - Hà Nội', '0909887766', '2023-11-28 00:53:38', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (6, 'Vương', 'Tuấn Khải', 'karrywang@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Phường Linh Xuân - TP Thủ Đức - TPHCM', '0329476587', '2023-11-28 00:53:37', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (7, 'Nguyễn ', 'Minh Thư', 'minhthu@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Đông Hòa - Dĩ An - Bình Dương', '0868652232', '2023-11-28 00:53:37', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (8, 'Lương', 'Thùy Linh', 'thuylinh@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Huyện Cần Giờ - TP Hồ Chí Minh', '0326524478', '2023-11-28 00:53:36', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (9, 'Nguyễn', 'Thùy Tiên', 'thuytien@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Gò Vấp - TP Hồ Chí Minh', '0352232365', '2023-11-28 00:53:35', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (10, 'Trần', 'Thanh Phong', 'thanhphong@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Gò Vấp - TP Hồ Chí Minh', '0969236214', '2023-11-28 00:53:35', 'user', 1, 2, -1, 1),
                                                                                                                                                                                   (11, 'Trần', 'Quang Vũ', 'quangvu@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Đông Hòa - Dĩ An - Bình Dương', '0966323665', '2023-11-28 00:53:34', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (12, 'Hoàng', 'Mỹ Duyên', 'myduyen@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Quận 5 - TP Hồ Chí Minh', '0329810548', '2023-11-28 00:53:33', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (13, 'Đặng', 'Mỹ Ngọc', 'myngoc@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Quận 6 - TP Hồ Chí Minh', '0963124562', '2023-11-28 00:53:33', 'user', 1, 2, -1, 1),
                                                                                                                                                                                   (14, 'Đỗ ', 'Hoàng Phú', 'hoangphu@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Quận Bình Thạnh - TP Hồ Chí Minh', '0866025036', '2023-11-28 00:53:32', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (15, 'Hương', 'Mỹ', 'nguyenthiquynhhuong2002@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', NULL, '0867415853', '2023-11-28 00:53:31', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (16, 'Nguyễn', 'Thư', 'minhthu08111208@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', '', '0365200110', '2023-11-28 00:53:31', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (28, 'A', 'B', 'sosinhsv1a@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', '', '0987', '2023-11-28 00:53:30', 'mod', 1, 1, -1, 1),
                                                                                                                                                                                   (38, 'Nguyễn Dư', 'Lập', 'ndl22012002@gmail.com', 'brd4e8c59ed0bb1a0ca5f46667c5115a49', 'Phường Mai Dịch - Quận Cầ Giấy - Hà Nội', '0867415853', '2023-11-29 06:55:06', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (39, 'A', 'Kim', 'sosinhsv1b@gmail.com', '', '', '', '2023-05-02 10:27:50', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (40, 'tiến', 'trần đình minh', '4tiensau@gmail.com', '', '', '', '2023-06-01 04:19:24', 'mod', 1, 3, -1, 1),
                                                                                                                                                                                   (43, 'A', 'A', '123@gmail.com', 'ewc65ded5885fe80672bd2979c9f14f182', 'A', '12345678', '2026-03-23 01:10:38', 'mod', 1, 2, -1, 1),
                                                                                                                                                                                   (48, 'A', 'A', '1234@gmail.com', '9afeb8ef0abfaa5a15d0dcf605f5ca373684c3835e787712fb', 'A', '12345678', '2026-03-23 01:52:27', 'admin', 1, 0, -1, 1),
                                                                                                                                                                                   (49, 'Phạm', 'Tiến', 'phamhoangtien2003@gmail.com', '9rj8bca527aaa29879628b8410aaf6418d', '245,ds10,Linh Xuan', '0123456789', '2026-05-23 16:25:13', 'user', 1, 3, -1, 1),
                                                                                                                                                                                   (50, 'Hoàng', 'Tiến', 'phamhoangtien832003@gmail.com', '9vw8bca527aaa29879628b8410aaf6418d', '245,ds10,Linh Trung', '0123456789', '2026-06-21 14:38:33', 'admin', 1, 3, -1, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `department`
--

CREATE TABLE `department` (
                              `id_department` int(11) NOT NULL,
                              `name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Tên khoa',
                              `id_university` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `department`
--

INSERT INTO `department` (`id_department`, `name`, `id_university`) VALUES
                                                                        (1, 'Khoa Khoa Học & Kỹ Thuật Máy Tính', 1),
                                                                        (2, 'Khoa Điện - Điện Tử', 1),
                                                                        (3, 'Khoa Cơ Khí', 1),
                                                                        (4, 'Khoa Quản Lý Công Nghiệp', 1),
                                                                        (5, 'Khoa Kỹ Thuật Hóa Học', 1),
                                                                        (6, 'Khoa Kinh Tế', 2),
                                                                        (7, 'Khoa Quản Trị Kinh Doanh', 2),
                                                                        (8, 'Khoa Tài Chính', 2),
                                                                        (9, 'Khoa Kế Toán', 2),
                                                                        (10, 'Khoa Marketing', 2),
                                                                        (11, 'Khoa Y', 3),
                                                                        (12, 'Khoa Dược', 3),
                                                                        (13, 'Khoa Điều Dưỡng - Kỹ Thuật Y Tế', 3),
                                                                        (14, 'Khoa Y Tế Công Cộng', 3),
                                                                        (15, 'Khoa Toán - Tin', 4),
                                                                        (16, 'Khoa Ngữ Văn', 4),
                                                                        (17, 'Khoa Vật Lý', 4),
                                                                        (18, 'Khoa Hóa Học', 4),
                                                                        (19, 'Khoa Sinh Học', 4),
                                                                        (20, 'Khoa Giáo Dục Chính Trị', 4);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `department_book`
--

CREATE TABLE `department_book` (
                                   `id_department` int(11) NOT NULL,
                                   `id_book` int(11) NOT NULL,
                                   `note` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Bắt buộc / Tham khảo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `department_book`
--

INSERT INTO `department_book` (`id_department`, `id_book`, `note`) VALUES
                                                                       (1, 200, 'Bắt buộc'),
                                                                       (1, 201, 'Bắt buộc'),
                                                                       (1, 202, 'Bắt buộc'),
                                                                       (1, 203, 'Bắt buộc'),
                                                                       (1, 204, 'Tham khảo'),
                                                                       (1, 226, 'Bắt buộc'),
                                                                       (1, 227, 'Bắt buộc'),
                                                                       (1, 228, 'Bắt buộc'),
                                                                       (2, 205, 'Bắt buộc'),
                                                                       (2, 206, 'Bắt buộc'),
                                                                       (2, 222, 'Bắt buộc'),
                                                                       (2, 226, 'Bắt buộc'),
                                                                       (2, 227, 'Bắt buộc'),
                                                                       (2, 228, 'Bắt buộc'),
                                                                       (3, 207, 'Bắt buộc'),
                                                                       (3, 208, 'Bắt buộc'),
                                                                       (3, 222, 'Tham khảo'),
                                                                       (3, 226, 'Bắt buộc'),
                                                                       (3, 227, 'Bắt buộc'),
                                                                       (3, 228, 'Bắt buộc'),
                                                                       (4, 209, 'Tham khảo'),
                                                                       (4, 211, 'Bắt buộc'),
                                                                       (4, 226, 'Bắt buộc'),
                                                                       (4, 227, 'Bắt buộc'),
                                                                       (4, 228, 'Bắt buộc'),
                                                                       (5, 224, 'Tham khảo'),
                                                                       (5, 226, 'Bắt buộc'),
                                                                       (5, 227, 'Bắt buộc'),
                                                                       (5, 228, 'Bắt buộc'),
                                                                       (6, 209, 'Bắt buộc'),
                                                                       (6, 210, 'Bắt buộc'),
                                                                       (6, 226, 'Bắt buộc'),
                                                                       (6, 227, 'Bắt buộc'),
                                                                       (6, 228, 'Bắt buộc'),
                                                                       (7, 209, 'Tham khảo'),
                                                                       (7, 211, 'Bắt buộc'),
                                                                       (7, 212, 'Bắt buộc'),
                                                                       (7, 226, 'Bắt buộc'),
                                                                       (7, 227, 'Bắt buộc'),
                                                                       (7, 228, 'Bắt buộc'),
                                                                       (8, 209, 'Tham khảo'),
                                                                       (8, 213, 'Bắt buộc'),
                                                                       (8, 214, 'Bắt buộc'),
                                                                       (8, 226, 'Bắt buộc'),
                                                                       (8, 227, 'Bắt buộc'),
                                                                       (8, 228, 'Bắt buộc'),
                                                                       (9, 214, 'Tham khảo'),
                                                                       (9, 215, 'Bắt buộc'),
                                                                       (9, 226, 'Bắt buộc'),
                                                                       (9, 227, 'Bắt buộc'),
                                                                       (9, 228, 'Bắt buộc'),
                                                                       (10, 211, 'Tham khảo'),
                                                                       (10, 212, 'Bắt buộc'),
                                                                       (10, 226, 'Bắt buộc'),
                                                                       (10, 227, 'Bắt buộc'),
                                                                       (10, 228, 'Bắt buộc'),
                                                                       (11, 216, 'Bắt buộc'),
                                                                       (11, 217, 'Bắt buộc'),
                                                                       (11, 226, 'Bắt buộc'),
                                                                       (11, 227, 'Bắt buộc'),
                                                                       (11, 228, 'Bắt buộc'),
                                                                       (12, 217, 'Tham khảo'),
                                                                       (12, 218, 'Bắt buộc'),
                                                                       (12, 219, 'Bắt buộc'),
                                                                       (12, 226, 'Bắt buộc'),
                                                                       (12, 227, 'Bắt buộc'),
                                                                       (12, 228, 'Bắt buộc'),
                                                                       (13, 216, 'Bắt buộc'),
                                                                       (13, 217, 'Tham khảo'),
                                                                       (13, 226, 'Bắt buộc'),
                                                                       (13, 227, 'Bắt buộc'),
                                                                       (13, 228, 'Bắt buộc'),
                                                                       (14, 217, 'Tham khảo'),
                                                                       (14, 226, 'Bắt buộc'),
                                                                       (14, 227, 'Bắt buộc'),
                                                                       (14, 228, 'Bắt buộc'),
                                                                       (15, 200, 'Tham khảo'),
                                                                       (15, 220, 'Bắt buộc'),
                                                                       (15, 221, 'Bắt buộc'),
                                                                       (15, 226, 'Bắt buộc'),
                                                                       (15, 227, 'Bắt buộc'),
                                                                       (15, 228, 'Bắt buộc'),
                                                                       (16, 226, 'Bắt buộc'),
                                                                       (16, 227, 'Bắt buộc'),
                                                                       (16, 228, 'Bắt buộc'),
                                                                       (17, 222, 'Bắt buộc'),
                                                                       (17, 223, 'Bắt buộc'),
                                                                       (17, 226, 'Bắt buộc'),
                                                                       (17, 227, 'Bắt buộc'),
                                                                       (17, 228, 'Bắt buộc'),
                                                                       (18, 224, 'Bắt buộc'),
                                                                       (18, 226, 'Bắt buộc'),
                                                                       (18, 227, 'Bắt buộc'),
                                                                       (18, 228, 'Bắt buộc'),
                                                                       (19, 217, 'Tham khảo'),
                                                                       (19, 225, 'Bắt buộc'),
                                                                       (19, 226, 'Bắt buộc'),
                                                                       (19, 227, 'Bắt buộc'),
                                                                       (19, 228, 'Bắt buộc'),
                                                                       (20, 226, 'Bắt buộc'),
                                                                       (20, 227, 'Bắt buộc'),
                                                                       (20, 228, 'Bắt buộc');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `discount`
--

CREATE TABLE `discount` (
                            `id_discount` int(11) NOT NULL,
                            `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
                            `quantity` int(11) DEFAULT NULL,
                            `percent_discount` int(11) DEFAULT NULL,
                            `diktat` varchar(50) DEFAULT NULL,
                            `status` int(11) DEFAULT 0,
                            `price_minimum` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `discount`
--

INSERT INTO `discount` (`id_discount`, `name`, `quantity`, `percent_discount`, `diktat`, `status`, `price_minimum`) VALUES
                                                                                                                        (1, 'Giảm giá 50K cho khach hang moi', 1000, 50000, 'Khách hàng mới hoặc đơn hàng đầu tiên', 0, 0),
                                                                                                                        (2, 'Giảm giá 10K', 47, 10000, 'Đơn hàng trên 100K', 1, 100000),
                                                                                                                        (3, 'Giảm giá 30K', 48, 30000, 'Đơn hàng có giá trị trên 300K', 1, 300000),
                                                                                                                        (4, 'Giảm giá 40K', 68, 40000, 'Đơn hàng có ngày đặt là 12/12', 1, 0),
                                                                                                                        (5, 'Giảm giá 50K', 99, 50000, 'Đơn hàng có giá trị trên 500K', 1, 500000),
                                                                                                                        (6, 'Giảm giá 20K', 19, 20000, 'Đơn hàng thanh toán bằng hình thức chuyển khoản', 1, 0),
                                                                                                                        (7, 'Giảm giá 70K', 49, 70000, 'Đơn hàng có giá trị trên 700K', 1, 700000),
                                                                                                                        (8, 'Giảm giá 30K', 10, 30000, 'Đơn hàng thanh toán bằng hình thức chuyển khoản', 1, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `discount_customer`
--

CREATE TABLE `discount_customer` (
                                     `id_discount` int(11) NOT NULL,
                                     `id_user` int(11) NOT NULL,
                                     `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `discount_customer`
--

INSERT INTO `discount_customer` (`id_discount`, `id_user`, `quantity`) VALUES
                                                                           (2, 49, 1),
                                                                           (3, 49, 1),
                                                                           (4, 49, 1),
                                                                           (6, 49, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `image_book`
--

CREATE TABLE `image_book` (
                              `id_image` int(11) NOT NULL,
                              `id_book` int(11) NOT NULL,
                              `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `image_book`
--

INSERT INTO `image_book` (`id_image`, `id_book`, `image`) VALUES
                                                              (1, 18, '/templates/images/sachtiengviet/hay-nham-mat-khi-anh-den-t1-b_359d984128b247a49d20039dfa9f98f7_master.jpg'),
                                                              (2, 19, '/templates/images/sachtiengviet/NgayCuoiCungCuaMotTuTu.jpg'),
                                                              (6, 22, '/templates/images/van-hoc-trong-nuoc/truyen_ngan_Nguyen_Cong_Hoan_title.jpg'),
                                                              (7, 23, '/templates/images/van-hoc-trong-nuoc/soi_toc_title.jpg'),
                                                              (8, 24, '/templates/images/van-hoc-trong-nuoc/thach_lam_tuyen_tap_title.jpg'),
                                                              (9, 25, '/templates/images/van-hoc-trong-nuoc/gio_lanh_dau_mua_title.jpg'),
                                                              (10, 27, '/templates/images/van-hoc-trong-nuoc/thi_nhan_viet_nam_tilte.jpg'),
                                                              (11, 29, '/templates/images/van-hoc-trong-nuoc/tho_xuan_quynh_title.jpg'),
                                                              (12, 30, '/templates/images/van-hoc-trong-nuoc/truyen_kieu_title.jpg'),
                                                              (13, 31, '/templates/images/van-hoc-trong-nuoc/ngay_moi_title.jpg'),
                                                              (14, 44, '/templates/images/van-hoc-trong-nuoc/coi_nguoi_mac_can_title.jpg'),
                                                              (15, 45, '/templates/images/van-hoc-trong-nuoc/nguoc_chieu_thien_di_title.jpg'),
                                                              (16, 46, '/templates/images/van-hoc-trong-nuoc/mieng_ngon_ha_noi_title.jpg'),
                                                              (17, 46, '/templates/images/van-hoc-trong-nuoc/mieng_ngon_ha_noi_content1.jpg'),
                                                              (18, 46, '/templates/images/van-hoc-trong-nuoc/mieng_ngon_ha_noi_content2.jpg'),
                                                              (19, 46, '/templates/images/van-hoc-trong-nuoc/mieng_ngon_ha_noi_content3.jpg'),
                                                              (20, 46, '/templates/images/van-hoc-trong-nuoc/mieng_ngon_ha_noi_content4.jpg'),
                                                              (21, 47, '/templates/images/van-hoc-trong-nuoc/tieu_thuyet_viet_nam_title.jpg'),
                                                              (22, 56, '/templates/images/truyen-tranh/trang_quynh_tap418_title.jpg'),
                                                              (23, 56, '/templates/images/truyen-tranh/trang_quynh_tap418_content1.jpg'),
                                                              (24, 56, '/templates/images/truyen-tranh/trang_quynh_tap418_content2.jpg'),
                                                              (25, 56, '/templates/images/truyen-tranh/trang_quynh_tap418_content3.jpg'),
                                                              (26, 56, '/templates/images/truyen-tranh/trang_quynh_tap418_content4.jpg'),
                                                              (27, 58, '/templates/images/truyen-tranh/trang_quynh_tap365_title.jpg'),
                                                              (28, 59, '/templates/images/truyen-tranh/trang_quynh_tap163_title.jpg'),
                                                              (29, 59, '/templates/images/truyen-tranh/trang_quynh_tap163_content1.jpg'),
                                                              (30, 59, '/templates/images/truyen-tranh/trang_quynh_tap163_content2.jpg'),
                                                              (31, 59, '/templates/images/truyen-tranh/trang_quynh_tap163_content3.jpg'),
                                                              (32, 60, '/templates/images/truyen-tranh/trang_quynh_tap419_title.jpg'),
                                                              (33, 60, '/templates/images/truyen-tranh/trang_quynh_tap419_content1.jpg'),
                                                              (34, 60, '/templates/images/truyen-tranh/trang_quynh_tap419_content2.jpg'),
                                                              (35, 60, '/templates/images/truyen-tranh/trang_quynh_tap419_content3.jpg'),
                                                              (36, 60, '/templates/images/truyen-tranh/trang_quynh_tap419_content4.jpg'),
                                                              (37, 62, '/templates/images/truyen-tranh/cau_be_rong_tap243_title.jpg'),
                                                              (38, 62, '/templates/images/truyen-tranh/cau_be_rong_tap243_content1.jpg'),
                                                              (39, 62, '/templates/images/truyen-tranh/cau_be_rong_tap243_content2.jpg'),
                                                              (40, 62, '/templates/images/truyen-tranh/cau_be_rong_tap243_content3.jpg'),
                                                              (41, 62, '/templates/images/truyen-tranh/cau_be_rong_tap243_content4.jpg'),
                                                              (42, 63, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_ham_nghi_title.jpg'),
                                                              (43, 63, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_ham_nghi_content1.jpg'),
                                                              (44, 63, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_ham_nghi_content2.jpg'),
                                                              (45, 63, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_ham_nghi_content3.jpg'),
                                                              (46, 63, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_ham_nghi_content4.jpg'),
                                                              (47, 64, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_le_chan_title.jpg'),
                                                              (48, 64, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_le_chan_review.jpg'),
                                                              (49, 64, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_le_chan_content1.jpg'),
                                                              (50, 64, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_le_chan_content2.jpg'),
                                                              (51, 64, '/templates/images/truyen-tranh/truyen_tranh_lich_su_viet_nam_le_chan_content3.jpg'),
                                                              (52, 65, '/templates/images/truyen-tranh/tranh_truyen_dan_gian_viet_nam_cay_tre_tram_dot_title.jpg'),
                                                              (53, 65, '/templates/images/truyen-tranh/tranh_truyen_dan_gian_viet_nam_cay_tre_tram_dot_content1.jpg'),
                                                              (54, 65, '/templates/images/truyen-tranh/tranh_truyen_dan_gian_viet_nam_cay_tre_tram_dot_content2.jpg'),
                                                              (55, 65, '/templates/images/truyen-tranh/tranh_truyen_dan_gian_viet_nam_cay_tre_tram_dot_content3.jpg'),
                                                              (56, 66, '/templates/images/truyen-tranh/tranh_truyen_dan_gian_viet_nam_su_tich_con_thach_sung_title.jpg'),
                                                              (57, 66, '/templates/images/truyen-tranh/tranh_truyen_dan_gian_viet_nam_su_tich_con_thach_sung_content1.jpg'),
                                                              (58, 66, '/templates/images/truyen-tranh/tranh_truyen_dan_gian_viet_nam_su_tich_con_thach_sung_content2.jpg'),
                                                              (59, 66, '/templates/images/truyen-tranh/tranh_truyen_dan_gian_viet_nam_su_tich_con_thach_sung_content3.jpg'),
                                                              (60, 67, '/templates/images/truyen-tranh/conan_tap98_title.jpg'),
                                                              (61, 68, '/templates/images/truyen-tranh/conan_tap99_title.jpg'),
                                                              (62, 69, '/templates/images/truyen-tranh/conan_tap61_title.jpg'),
                                                              (63, 70, '/templates/images/tam-ly-ki-nang-song/tam_ly_hoc_pham_toi_title.jpg'),
                                                              (64, 70, '/templates/images/tam-ly-ki-nang-song/tam_ly_hoc_pham_toi_review.jpg'),
                                                              (65, 70, '/templates/images/tam-ly-ki-nang-song/tam_ly_hoc_pham_toi_content1.jpg'),
                                                              (66, 71, '/templates/images/tam-ly-ki-nang-song/tuoi_tre_dang_gia_bao_nhieu_title.jpg'),
                                                              (67, 71, '/templates/images/tam-ly-ki-nang-song/tuoi_tre_dang_gia_bao_nhieu_content1.jpg'),
                                                              (68, 71, '/templates/images/tam-ly-ki-nang-song/tuoi_tre_dang_gia_bao_nhieu_content2.jpg'),
                                                              (69, 71, '/templates/images/tam-ly-ki-nang-song/tuoi_tre_dang_gia_bao_nhieu_content3.jpg'),
                                                              (103, 1, '/templates/images/sachtiengviet/_nh-m_t-xa_-cu_c-_i-g_nuntitled.jpg'),
                                                              (104, 1, '/templates/images/sachtiengviet/_nh_m_t_xa_cu_c_i_g_nuntitled.jpg'),
                                                              (105, 3, '/templates/images/sachtiengviet/CongDanToanCauCongDanVuTru.jpg'),
                                                              (106, 4, '/templates/images/van-hoc-trong-nuoc/muonkiepnhansinh.jpg'),
                                                              (107, 5, '/templates/images/sachtiengviet/HanhTrinhVePhuongDong(TaiBan2021).jpg'),
                                                              (108, 6, '/templates/images/sachtiengviet/All_In_Love_Ngap_Tran_Yeu_Thuong(TaiBan2020).jpg'),
                                                              (109, 7, '/templates/images/sachtiengviet/GietConChimNhai(TaiBan2019).jpg'),
                                                              (110, 8, '/templates/images/sachtiengviet/Nha_Gia_Kim(TaiBan2020).jpg'),
                                                              (111, 9, '/templates/images/sachtiengviet/1cm_Giua_Anh_Va_Em.jpg'),
                                                              (112, 15, '/templates/images/van-hoc-trong-nuoc/100sailamcuabome.png.webp'),
                                                              (113, 16, '/templates/images/sachtiengviet/Bieguni_Nhung_Nguoi_Khong_Ngung_Chuyen_Dong.jpg'),
                                                              (114, 17, '/templates/images/sachtiengviet/bo-ba-bat-hao-quay-len-nao-tinh-ban-la-vo-gia_1_f9a4563afc48457cbd979544842f76ed_master.jpg'),
                                                              (115, 18, '/templates/images/van-hoc-trong-nuoc/thach_lam_tuyen_tap_title.jpg'),
                                                              (116, 10, '/templates/images/sachtiengviet/cay-cam-ngot-cua-toi_1_d3689c94e8614673b72f6bcbee854219_master.jpg'),
                                                              (117, 11, '/templates/images/sachtiengviet/image_195509_1_13785_41544bce9d934c36a18c1941a257791b_master.jpg'),
                                                              (118, 12, '/templates/images/sachtiengviet/8936037799834_893ca74968e44710a288a69a5efb1137_large.jpg'),
                                                              (119, 13, '/templates/images/vanhocnuocngoai/nhungnguoikhonkho1.jpeg'),
                                                              (121, 17, '/templates/images/sachtiengviet/bo-ba-bat-hao-quay-len-nao-tinh-ban-la-vo-gia_2_df18625701224fadb504b4348e1d772b_master.jpg'),
                                                              (122, 17, '/templates/images/sachtiengviet/bo-ba-bat-hao-quay-len-nao-tinh-ban-la-vo-gia_3_834b2d28a0cc4c2dacc46754cccde4db_master.jpg'),
                                                              (123, 13, '/templates/images/vanhocnuocngoai/nhungnguoikhonkho2.jpeg'),
                                                              (124, 13, '/templates/images/vanhocnuocngoai/nhungnguoikhonkho3.jpeg'),
                                                              (125, 13, '/templates/images/vanhocnuocngoai/nhungnguoikhonkho4.jpeg'),
                                                              (126, 1, '/templates/images/sachtiengviet/_nh_m_t_xa_cu_c_i_g_nuntitled.jpg'),
                                                              (128, 9, '/templates/images/sachtiengviet/1cm_Giua_Anh_Va_Em(2).jpg'),
                                                              (129, 5, '/templates/images/sachtiengviet/HanhTrinhVePhuongDong(TaiBan2021)-2.jpg'),
                                                              (130, 8, '/templates/images/sachtiengviet/Nha_Gia_Kim(TaiBan2020)-2.jpg'),
                                                              (131, 8, '/templates/images/sachtiengviet/Nha_Gia_Kim(TaiBan2020)-3.jpg'),
                                                              (132, 16, '/templates/images/sachtiengviet/Bieguni_Nhung_Nguoi_Khong_Ngung_Chuyen_Dong(2).jpg'),
                                                              (133, 75, '/templates/images/van-hoc-trong-nuoc/dacnhantam.jpg'),
                                                              (134, 76, '/templates/images/van-hoc-trong-nuoc/tamlihoctinhcach.jpg.webp'),
                                                              (135, 77, '/templates/images/van-hoc-trong-nuoc/tamlihocbieucam.jpg.webp'),
                                                              (136, 78, '/templates/images/van-hoc-trong-nuoc/ngontuthaydoituduy.jpg.webp'),
                                                              (137, 79, '/templates/images/van-hoc-trong-nuoc/nonggianlabannang.jpg.webp'),
                                                              (138, 80, '/templates/images/van-hoc-trong-nuoc/nangluongchualanhlangnghe.jpg.webp'),
                                                              (139, 82, '/templates/images/van-hoc-trong-nuoc/buongbobuonbuong.jpg.webp'),
                                                              (140, 83, '/templates/images/van-hoc-trong-nuoc/tavuidoisevui.jpg.webp'),
                                                              (141, 86, '/templates/images/van-hoc-trong-nuoc/nhamaysanxuatniemvui.jpg.webp'),
                                                              (144, 14, '/templates/images/van-hoc-trong-nuoc/robinson.webp'),
                                                              (145, 1, '/templates/images/sachtiengviet/_nh_m_t_xa_cu_c_i_g_nuntitled.jpg'),
                                                              (146, 3, '/templates/images/sachtiengviet/CongDanToanCauCongDanVuTru.jpg'),
                                                              (147, 2, '/templates/images/sachtiengviet/GietConChimNhai(TaiBan2019).jpg'),
                                                              (148, 12, '/templates/images/vanhocnuocngoai/gietconchimnhai1.jpg'),
                                                              (149, 2, '/templates/images/vanhocnuocngoai/gietconchimnhai1.jpg'),
                                                              (150, 4, '/templates/images/van-hoc-trong-nuoc/muonkiepnhansinh.jpg'),
                                                              (151, 6, '/templates/images/sachtiengviet/All_In_Love_Ngap_Tran_Yeu_Thuong(TaiBan2020).jpg'),
                                                              (152, 7, '/templates/images/sachtiengviet/GietConChimNhai(TaiBan2019).jpg'),
                                                              (200, 200, 'https://i.ebayimg.com/images/g/v34AAOSwMbFjLteQ/s-l960.webp'),
                                                              (201, 201, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAP6wWb_c9xVfb4C0O8wsllEfM-PZXXSFdBk4iRkTF0A&s=10'),
                                                              (202, 202, 'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcQLScxROfsaAQ6haoCy6BJM-1uhFzRDUMwBv4KA6Wcn_Vo8HZK8PuyJlksyFif2X1mDVVUaeYUcJj5wsXehHzcph9kHWqvj6VUUBlPjDN_leySdEPOPM_aBK3tkGz4Ev-IKFmj3pdrBhA&usqp=CAc'),
                                                              (203, 203, 'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcSONXfYnw9diNlJPE-QuQtPm1Z_bsDiZfKeywMoGv78TaCJWhPxUS57UVnZrsij7AnrXnHOJ8JAlj7c0OVDV9gJ7bcUw5YhpbjVsgWa_gGuVgF3dMS96W9bresx_g0bb5i_m_mGOpdljQ&usqp=CAc'),
                                                              (204, 204, 'https://vietbooks.info/attachments/upload_2023-7-21_15-35-13-png.24762/'),
                                                              (205, 205, 'https://shop.ueh.edu.vn/ueh-book/wp-content/uploads/2024/10/z5955240113396_3da744348de29b93b71ee59702bb06a9.jpg'),
                                                              (206, 206, 'https://nxbkhkt.com.vn/wp-content/uploads/2024/02/Ly-thuyet-mach-dien-mach-tuyen-tinh-o-che-do-xac-lap-1.png'),
                                                              (207, 207, 'https://salt.tikicdn.com/cache/750x750/ts/product/37/6c/66/a64181f346887580f144682a15b09a46.jpg'),
                                                              (208, 208, 'https://imgv2-1-f.scribdassets.com/img/document/707874353/original/73c7d838a6/1?v=1'),
                                                              (209, 209, 'https://cdn1.fahasa.com/media/catalog/product/9/7/9786043026542_1.jpg'),
                                                              (210, 210, 'https://vietbooks.info/attachments/upload_2022-12-13_23-42-50-png.18251/'),
                                                              (211, 211, 'https://website-assets.studocu.com/img/document_thumbnails/eac63fe1029274141e5e6bfd6073904d/thumb_1200_1698.png'),
                                                              (212, 212, 'https://shop.ueh.edu.vn/ueh-book/wp-content/uploads/2024/10/z5942056648091_de44703a79e3855fa4b0d51bd381461e.jpg'),
                                                              (213, 213, 'https://lic.haui.edu.vn/media/80/t80447.jpg'),
                                                              (214, 214, 'https://vn-test-11.slatic.net/p/ac7b600be3fe192e166833761cc437cf.jpg'),
                                                              (215, 215, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMQ2382EoHA7iGjRDUiaVJmYOrWXjOEXKHYQ&s'),
                                                              (216, 216, 'https://hevobooks.com/wp-content/uploads/2022/01/22-Vinh2021-Gt-Giai-phau-hoc-Tap-1A_bia_1.jpg'),
                                                              (217, 217, 'https://downloadsachyhoc.com/wp-content/uploads/2025/11/sinh-ly-hoc-y-khoa-yds-2024.jpg'),
                                                              (218, 218, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/371/634/products/6e997274-8739-443f-b1fa-4b26c9eed96d.jpg?v=1766910233980'),
                                                              (219, 219, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSefuRleWpueN27w5jrHAVwOlhbF7PZiFZ62A&s'),
                                                              (220, 220, 'https://bizweb.dktcdn.net/thumb/grande/100/490/462/products/z5398918528491-4fe09b3a004c62a4e02cac306ed5a167.jpg?v=1714556331270'),
                                                              (221, 221, 'https://imgv2-1-f.scribdassets.com/img/document/708185980/original/370d28e56a/1?v=1'),
                                                              (222, 222, 'https://thuvienso.uhd.edu.vn/home/uploads/news/2024_12/vldc-tap-3.jpg'),
                                                              (223, 223, 'https://thuvienso.uhd.edu.vn/home/uploads/news/2024_12/vat-ly-dai-cuong-tap-2.jpg'),
                                                              (224, 224, 'https://images.nxbxaydung.com.vn/Picture/2021/12/9/image-2021120911041172.jpg'),
                                                              (225, 225, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRX37efDaj6jAh29sigR0cLRBLNvo0tRasCPQ&s'),
                                                              (226, 226, 'https://www.nxbctqg.org.vn/img_data/images/739286287572_3dbc698c-49e1-484d-a595-2044a48d52ae.jpg'),
                                                              (227, 227, 'https://cdn1.fahasa.com/media/catalog/product/z/5/z5458631230813_639bb254be8a2bcb9276d51c26d89e82_1.jpg'),
                                                              (228, 228, 'https://nxbctqg.org.vn/img_data/images/815399422137_dcns.jpg');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `infomationdelivers`
--

CREATE TABLE `infomationdelivers` (
                                      `id` int(11) NOT NULL,
                                      `idCart` int(11) NOT NULL DEFAULT 0,
                                      `x` int(11) NOT NULL DEFAULT 0,
                                      `y` int(11) NOT NULL DEFAULT 0,
                                      `z` int(11) NOT NULL DEFAULT 0,
                                      `w` int(11) NOT NULL DEFAULT 0,
                                      `districtTo` varchar(50) NOT NULL DEFAULT '0',
                                      `warTo` varchar(50) NOT NULL DEFAULT '0',
                                      `token` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `infomationdelivers`
--

INSERT INTO `infomationdelivers` (`id`, `idCart`, `x`, `y`, `z`, `w`, `districtTo`, `warTo`, `token`) VALUES
                                                                                                          (19, 28, 20, 13, 2, 448, 'Huyện Cẩm Khê', 'Xã Sơn Tình', NULL),
                                                                                                          (20, 45, 20, 13, 2, 672, 'Quận Bình Tân', 'Phường An Lạc', NULL),
                                                                                                          (21, 54, 20, 13, 1, 224, 'Quận 11', 'Phường 5', NULL),
                                                                                                          (22, 55, 0, 0, 0, 0, 'Quận 8', 'Phường Hưng Phú', NULL),
                                                                                                          (23, 56, 20, 13, 1, 224, 'Quận 8', 'Phường 4', NULL),
                                                                                                          (24, 57, 0, 0, 0, 0, 'Quận 11', 'Phường 7', NULL),
                                                                                                          (25, 58, 0, 0, 0, 0, 'Quận 11', 'Phường 7', NULL),
                                                                                                          (26, 59, 0, 0, 0, 0, 'Quận 6', 'Phường 8', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `logs`
--

CREATE TABLE `logs` (
                        `id` int(11) NOT NULL,
                        `level` int(11) NOT NULL DEFAULT 0,
                        `user` int(11) NOT NULL DEFAULT 0,
                        `ip` varchar(200) NOT NULL DEFAULT '0',
                        `src` varchar(200) NOT NULL DEFAULT '0',
                        `content` varchar(200) NOT NULL DEFAULT '0',
                        `createAt` datetime NOT NULL DEFAULT current_timestamp(),
                        `status` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `logs`
--

INSERT INTO `logs` (`id`, `level`, `user`, `ip`, `src`, `content`, `createAt`, `status`) VALUES
                                                                                             (1, 0, 0, '192.168.186.1', 'Register', 'User register suscess', '2023-04-19 16:10:38', 1),
                                                                                             (2, 0, 38, '192.168.186.1', 'Login', 'Login fall', '2023-04-19 16:10:51', 1),
                                                                                             (3, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 18', '2023-04-25 21:41:37', 1),
                                                                                             (4, 0, 18, '192.168.186.1', 'Login', 'Login fall', '2023-04-28 13:13:25', 1),
                                                                                             (5, 0, 18, '192.168.186.1', 'Login', 'Login fall', '2023-04-28 14:17:52', 1),
                                                                                             (6, 0, 18, '192.168.186.1', 'Login', 'Login fall', '2023-04-28 15:34:23', 1),
                                                                                             (7, 1, 38, '192.168.186.1', 'Xác nhận đơn hàng', 'Xác nhận đơn hàng: 51', '2023-05-02 10:16:58', 1),
                                                                                             (8, 1, 38, '192.168.186.1', 'Xác nhận đơn hàng', 'Xác nhận đơn hàng: 52', '2023-05-02 10:17:02', 1),
                                                                                             (9, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 35', '2023-05-02 16:11:50', 1),
                                                                                             (10, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 53', '2023-05-02 16:20:33', 1),
                                                                                             (11, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 54', '2023-05-02 16:23:01', 1),
                                                                                             (12, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 59', '2023-05-02 16:28:33', 1),
                                                                                             (13, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-05-02 16:55:36', 1),
                                                                                             (14, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 6', '2023-05-02 16:55:36', 1),
                                                                                             (15, 0, 38, '192.168.186.1', 'Login', 'Login fall', '2023-05-02 16:57:08', 1),
                                                                                             (16, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 19', '2023-05-02 17:19:23', 1),
                                                                                             (17, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 6', '2023-05-02 17:19:23', 1),
                                                                                             (18, 0, 39, '192.168.186.1', 'Register', 'User register suscess', '2023-05-02 17:27:50', 1),
                                                                                             (19, 0, 39, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 6', '2023-05-02 17:28:21', 1),
                                                                                             (20, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 18', '2023-05-02 17:40:09', 1),
                                                                                             (21, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 19', '2023-05-02 17:40:09', 1),
                                                                                             (22, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 71', '2023-05-03 09:23:48', 1),
                                                                                             (23, 0, 38, '192.168.186.1', 'Quản lý slide', 'Hiện slide', '2023-05-03 09:25:48', 1),
                                                                                             (24, 0, 38, '192.168.186.1', 'Login', 'Login fall', '2023-05-03 09:32:40', 1),
                                                                                             (25, 2, 38, '192.168.186.1', 'Quản lý sản phẩm', 'Thay đổi thông tin sản phẩm', '2023-05-24 09:39:59', 1),
                                                                                             (26, 2, 38, '192.168.186.1', 'Quản lý sản phẩm', 'Thay đổi thông tin sản phẩm', '2023-05-24 09:43:31', 1),
                                                                                             (27, 2, 38, '192.168.186.1', 'Quản lý sản phẩm', 'Thay đổi thông tin sản phẩm', '2023-05-24 10:48:55', 1),
                                                                                             (28, 0, 28, '192.168.1.41', 'Login', 'Login fall', '2023-06-01 11:14:54', 1),
                                                                                             (29, 0, 39, '192.168.1.41', 'OrderPay', 'The customer makes the payment: 6', '2023-06-01 11:15:22', 1),
                                                                                             (30, 0, 39, '192.168.1.41', 'OrderPay', 'The customer makes the payment: 18', '2023-06-01 11:16:54', 1),
                                                                                             (31, 0, 39, '192.168.1.41', 'OrderPay', 'The customer makes the payment: 3', '2023-06-01 11:18:24', 1),
                                                                                             (32, 0, 40, '192.168.1.41', 'Register', 'User register suscess', '2023-06-01 11:19:11', 1),
                                                                                             (33, 1, 40, '192.168.1.41', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 80', '2023-06-01 12:27:26', 1),
                                                                                             (34, 0, 28, '192.168.1.41', 'Login', 'Login fall', '2023-06-01 15:12:32', 1),
                                                                                             (35, 0, 39, '192.168.1.41', 'OrderPay', 'The customer makes the payment: 18', '2023-06-01 15:12:53', 1),
                                                                                             (36, 0, 39, '192.168.1.41', 'OrderPay', 'The customer makes the payment: 18', '2023-06-01 15:14:20', 1),
                                                                                             (37, 0, 39, '192.168.1.41', 'OrderPay', 'The customer makes the payment: 18', '2023-06-01 15:15:59', 1),
                                                                                             (38, 0, 39, '192.168.1.41', 'OrderPay', 'The customer makes the payment: 19', '2023-06-01 15:15:59', 1),
                                                                                             (39, 0, 39, '192.168.1.41', 'OrderPay', 'The customer makes the payment: 18', '2023-06-01 15:24:24', 1),
                                                                                             (40, 0, 39, '192.168.1.41', 'OrderPay', 'The customer makes the payment: 18', '2023-06-01 15:25:29', 1),
                                                                                             (41, 1, 40, '192.168.1.41', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 89', '2023-06-01 15:29:03', 1),
                                                                                             (42, 1, 40, '192.168.1.41', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 88', '2023-06-01 16:09:35', 1),
                                                                                             (43, 1, 40, '192.168.1.41', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 82', '2023-06-01 16:11:18', 1),
                                                                                             (44, 1, 40, '192.168.1.41', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 84', '2023-06-01 16:12:05', 1),
                                                                                             (45, 1, 40, '192.168.1.41', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 84', '2023-06-01 16:12:21', 1),
                                                                                             (46, 1, 40, '192.168.1.41', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 89', '2023-06-01 16:15:58', 1),
                                                                                             (47, 1, 40, '192.168.1.41', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 7', '2023-06-01 16:19:10', 1),
                                                                                             (48, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-06-02 17:20:25', 1),
                                                                                             (49, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-06-02 20:22:27', 1),
                                                                                             (50, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 9', '2023-06-02 20:27:00', 1),
                                                                                             (51, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-06-02 20:31:49', 1),
                                                                                             (52, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-06-02 20:38:07', 1),
                                                                                             (53, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 11', '2023-06-02 20:47:16', 1),
                                                                                             (54, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 11', '2023-06-02 20:56:19', 1),
                                                                                             (55, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 11', '2023-06-02 21:00:09', 1),
                                                                                             (56, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 18', '2023-06-02 21:14:54', 1),
                                                                                             (57, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 14', '2023-06-02 21:14:54', 1),
                                                                                             (58, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 12', '2023-06-02 21:17:47', 1),
                                                                                             (59, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 12', '2023-06-02 21:47:18', 1),
                                                                                             (60, 0, 1, '192.168.186.1', 'Login', 'Login fall', '2023-06-03 10:05:03', 1),
                                                                                             (61, 0, 38, '192.168.186.1', 'Login', 'Login fall', '2023-06-03 10:22:33', 1),
                                                                                             (62, 0, 1, '192.168.186.1', 'Login', 'Login fall', '2023-06-03 10:31:24', 1),
                                                                                             (63, 0, 1, '192.168.186.1', 'Quản lý slide', 'Hiện slide', '2023-06-04 10:47:14', 1),
                                                                                             (64, 0, 1, '192.168.186.1', 'Quản lý slide', 'Hiện slide', '2023-06-04 10:47:16', 1),
                                                                                             (65, 0, 1, '192.168.186.1', 'Quản lý slide', 'Hiện slide', '2023-06-04 10:47:17', 1),
                                                                                             (66, 2, 1, '192.168.186.1', 'Chỉnh sửa thông tin người dùng', 'Tài khoản được chỉnh sửa: 2', '2023-06-12 21:00:40', 1),
                                                                                             (67, 0, 1, '192.168.186.1', 'Quản lý nhân viên', 'Thêm nhân viên', '2023-06-12 21:03:21', 1),
                                                                                             (68, 0, 41, '192.168.186.1', 'Register', 'User register suscess', '2023-06-12 21:03:21', 1),
                                                                                             (69, 0, 1, '192.168.186.1', 'Quản lý nhân viên', 'Thêm nhân viên', '2023-06-12 21:12:55', 1),
                                                                                             (70, 0, 42, '192.168.186.1', 'Register', 'User register suscess', '2023-06-12 21:12:55', 1),
                                                                                             (71, 0, 1, '192.168.186.1', 'Quản lý nhân viên', 'Thêm nhân viên', '2023-06-12 21:15:41', 1),
                                                                                             (72, 0, 43, '192.168.186.1', 'Register', 'User register suscess', '2023-06-12 21:15:41', 1),
                                                                                             (73, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 18', '2023-06-13 15:09:26', 1),
                                                                                             (74, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-06-13 15:09:26', 1),
                                                                                             (75, 1, 18, '192.168.186.1', 'Cancel Product', 'Customer cancel product: 9', '2023-06-13 15:09:48', 1),
                                                                                             (76, 1, 18, '192.168.186.1', 'ConfirmOTP forgot Password', 'Verification code is incorrect', '2023-06-13 15:24:04', 1),
                                                                                             (77, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-06-13 15:34:13', 1),
                                                                                             (78, 0, 38, '192.168.186.1', 'Login', 'Login fall', '2023-06-13 15:43:01', 1),
                                                                                             (79, 2, 38, '192.168.186.1', 'Quản lý sản phẩm', 'Thay đổi thông tin sản phẩm', '2023-06-13 15:52:41', 1),
                                                                                             (80, 2, 38, '192.168.186.1', 'Quản lý sản phẩm', 'Thay đổi thông tin sản phẩm', '2023-06-13 15:54:06', 1),
                                                                                             (81, 0, 38, '192.168.186.1', 'Quản lý sản phẩm', 'Thêm sản phẩm', '2023-06-13 15:57:18', 1),
                                                                                             (82, 0, 38, '192.168.186.1', 'Quản lý sản phẩm', 'Thêm mục lục sản phẩm', '2023-06-13 15:59:30', 1),
                                                                                             (83, 1, 38, '192.168.186.1', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 1', '2023-06-13 16:02:51', 1),
                                                                                             (84, 0, 38, '192.168.186.1', 'Quản lý đánh giá, bình luận', 'Hiện bình luận', '2023-06-13 16:07:11', 1),
                                                                                             (85, 0, 38, '192.168.186.1', 'Quản lý đánh giá, bình luận', 'Hiện bình luận', '2023-06-13 16:07:15', 1),
                                                                                             (86, 0, 38, '192.168.186.1', 'Quản lý đánh giá, bình luận', 'Ẩn bình luận', '2023-06-13 16:07:19', 1),
                                                                                             (87, 2, 1, '192.168.186.1', 'Chỉnh sửa thông tin người dùng', 'Tài khoản được chỉnh sửa: 28', '2023-06-14 13:17:27', 1),
                                                                                             (88, 2, 1, '192.168.186.1', 'Chỉnh sửa thông tin người dùng', 'Tài khoản được chỉnh sửa: 28', '2023-06-14 13:24:12', 1),
                                                                                             (89, 0, 1, '192.168.186.1', 'Login', 'Login fall', '2023-06-14 21:25:21', 1),
                                                                                             (90, 0, 1, '192.168.186.1', 'Login', 'Login fall', '2023-06-14 21:58:31', 1),
                                                                                             (91, 2, 18, '192.168.186.1', 'Phản hổi từ khách hàng', 'SÃ¡ch Äáº¯c nhÃ¢n tÃ¢m cÃ²n khÃ´ng áº¡!', '2023-06-16 18:34:06', 1),
                                                                                             (92, 0, 38, '192.168.186.1', 'Quản lí contact', 'Nhân viên phản hồi khách hàng', '2023-06-16 18:37:01', 1),
                                                                                             (93, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 19', '2023-06-16 18:48:35', 1),
                                                                                             (94, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 1', '2023-08-31 09:20:20', 1),
                                                                                             (95, 0, 18, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 1', '2023-08-31 10:01:10', 1),
                                                                                             (96, 0, 44, '192.168.186.1', 'Register', 'User register suscess', '2023-11-21 21:52:56', 1),
                                                                                             (97, 0, 45, '192.168.186.1', 'Register', 'User register suscess', '2023-11-21 22:28:26', 1),
                                                                                             (98, 0, 46, '192.168.186.1', 'Register', 'User register suscess', '2023-11-28 07:52:53', 1),
                                                                                             (99, 0, 47, '192.168.186.1', 'Register', 'User register suscess', '2023-11-28 07:54:33', 1),
                                                                                             (100, 1, 38, '192.168.186.1', 'Cancel Product', 'Customer cancel product: 16', '2023-11-29 11:35:15', 1),
                                                                                             (101, 1, 38, '192.168.186.1', 'Cancel Product', 'Customer cancel product: 16', '2023-11-29 11:35:26', 1),
                                                                                             (102, 1, 38, '192.168.186.1', 'Cancel Product', 'Customer cancel product: 8', '2023-11-29 11:35:30', 1),
                                                                                             (103, 1, 38, '192.168.186.1', 'Cancel Product', 'Customer cancel product: 8', '2023-11-29 11:35:38', 1),
                                                                                             (104, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 19', '2023-11-29 13:17:43', 1),
                                                                                             (105, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 19', '2023-11-29 13:18:56', 1),
                                                                                             (106, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 1', '2023-11-29 13:20:26', 1),
                                                                                             (107, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 6', '2023-11-29 13:38:53', 1),
                                                                                             (108, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 18', '2023-11-29 13:44:29', 1),
                                                                                             (109, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 18', '2023-11-29 13:56:16', 1),
                                                                                             (110, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 6', '2023-11-29 14:02:20', 1),
                                                                                             (111, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 6', '2023-11-29 14:11:43', 1),
                                                                                             (112, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 6', '2023-11-29 14:21:31', 1),
                                                                                             (113, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 19', '2023-11-29 14:24:02', 1),
                                                                                             (114, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-11-29 14:51:28', 1),
                                                                                             (115, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-11-29 15:14:03', 1),
                                                                                             (116, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 3', '2023-11-29 15:51:48', 1),
                                                                                             (117, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 14', '2023-11-29 17:34:50', 1),
                                                                                             (118, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 14', '2023-11-29 17:37:24', 1),
                                                                                             (119, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 14', '2023-11-29 17:41:24', 1),
                                                                                             (120, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 14', '2023-11-29 17:55:49', 1),
                                                                                             (121, 0, 38, '192.168.186.1', 'OrderPay', 'The customer makes the payment: 14', '2023-11-29 18:12:04', 1),
                                                                                             (122, 0, 43, '10.201.20.120', 'Login', 'Login fall', '2026-03-23 08:10:38', 1),
                                                                                             (123, 0, 48, '10.201.20.120', 'Login', 'Login fall', '2026-03-23 08:11:47', 1),
                                                                                             (124, 0, 1, '10.201.20.120', 'Login', 'Login fall', '2026-03-23 08:16:30', 1),
                                                                                             (125, 0, 1, '10.201.20.120', 'Login', 'Login fall', '2026-03-23 08:16:40', 1),
                                                                                             (126, 0, 48, '10.50.107.210', 'Login', 'Login fall', '2026-03-23 08:23:21', 1),
                                                                                             (127, 1, 48, '10.50.107.210', 'Login', 'Account has been locked', '2026-03-23 08:24:00', 1),
                                                                                             (128, 1, 48, '10.50.107.210', 'Login', 'Account has been locked', '2026-03-23 08:25:45', 1),
                                                                                             (129, 0, 48, '10.50.107.210', 'Login', 'Login fall', '2026-03-23 08:26:21', 1),
                                                                                             (130, 0, 48, '10.50.107.210', 'Login', 'Login fall', '2026-03-23 08:39:41', 1),
                                                                                             (131, 0, 48, '10.50.107.210', 'Login', 'Login fall', '2026-03-23 08:41:03', 1),
                                                                                             (132, 0, 48, '10.50.107.210', 'Login', 'Login fall', '2026-03-23 08:42:41', 1),
                                                                                             (133, 0, 48, '10.50.107.210', 'Login', 'Login fall', '2026-03-23 08:52:27', 1),
                                                                                             (134, 0, 49, '192.168.1.28', 'Register', 'User register suscess', '2026-05-23 22:34:35', 1),
                                                                                             (135, 0, 50, '192.168.1.28', 'Register', 'User register suscess', '2026-05-23 22:49:44', 1),
                                                                                             (136, 1, 50, '192.168.1.28', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 29', '2026-05-23 22:52:19', 1),
                                                                                             (137, 1, 50, '192.168.1.28', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 29', '2026-05-23 22:52:58', 1),
                                                                                             (138, 0, 49, '192.168.1.28', 'Login', 'Login fall', '2026-05-23 22:53:12', 1),
                                                                                             (139, 1, 50, '192.168.1.28', 'Xác nhận đơn hàng', 'Đã guao: 29', '2026-05-23 22:55:52', 1),
                                                                                             (140, 1, 50, '192.168.1.28', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 30', '2026-05-23 23:00:47', 1),
                                                                                             (141, 0, 49, '192.168.1.28', 'Login', 'Login fall', '2026-05-23 23:15:14', 1),
                                                                                             (142, 0, 49, '192.168.1.28', 'Login', 'Login fall', '2026-05-23 23:15:19', 1),
                                                                                             (143, 0, 49, '192.168.1.28', 'Login', 'Login fall', '2026-05-23 23:15:34', 1),
                                                                                             (144, 0, 49, '192.168.1.28', 'Login', 'Login fall', '2026-05-23 23:24:17', 1),
                                                                                             (145, 0, 49, '192.168.1.28', 'Login', 'Login fall', '2026-05-23 23:25:04', 1),
                                                                                             (146, 1, 50, '192.168.1.28', 'Đăng kí đơn hàng', 'Đăng kí đơn hàng vận chuyển: 31', '2026-05-23 23:28:46', 1),
                                                                                             (147, 1, 50, '192.168.1.28', 'Xác nhận đơn hàng', 'Đã guao: 31', '2026-05-23 23:29:56', 1),
                                                                                             (148, 1, 50, '192.168.1.28', 'Xác nhận đơn hàng', 'Đã guao: 31', '2026-05-23 23:30:29', 1),
                                                                                             (149, 1, 50, '192.168.1.28', 'Xác nhận đơn hàng', 'Đã guao: 30', '2026-05-23 23:31:07', 1),
                                                                                             (150, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 32', '2026-05-25 09:07:06', 1),
                                                                                             (151, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 33', '2026-05-25 09:07:21', 1),
                                                                                             (152, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 37', '2026-05-25 09:10:06', 1),
                                                                                             (153, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 37', '2026-05-25 09:11:04', 1),
                                                                                             (154, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 35', '2026-05-26 22:45:25', 1),
                                                                                             (155, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 36', '2026-05-26 22:50:25', 1),
                                                                                             (156, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 36', '2026-05-26 22:50:33', 1),
                                                                                             (157, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 40', '2026-05-26 23:52:58', 1),
                                                                                             (158, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 44', '2026-05-27 00:25:43', 1),
                                                                                             (159, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 38', '2026-05-27 00:25:55', 1),
                                                                                             (160, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 41', '2026-05-27 00:26:18', 1),
                                                                                             (161, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 43', '2026-05-27 00:26:29', 1),
                                                                                             (162, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 46', '2026-05-27 00:30:31', 1),
                                                                                             (163, 1, 49, '192.168.1.28', 'Cancel Product', 'Customer cancel product: 42', '2026-05-27 00:31:07', 1),
                                                                                             (164, 0, 50, '192.168.1.16', 'Login', 'Login fall', '2026-06-18 18:37:16', 1),
                                                                                             (165, 0, 50, '192.168.1.16', 'Login', 'Login fall', '2026-06-18 18:38:09', 1),
                                                                                             (166, 0, 50, '192.168.1.16', 'Login', 'Login fall', '2026-06-18 18:39:36', 1),
                                                                                             (167, 0, 50, '192.168.1.16', 'Login', 'Login fall', '2026-06-18 19:13:42', 1),
                                                                                             (168, 0, 50, '192.168.1.6', 'Login', 'Login fall', '2026-06-21 21:38:27', 1),
                                                                                             (169, 1, 49, '192.168.1.6', 'Cancel Product', 'Customer cancel product: 45', '2026-06-23 22:35:18', 1),
                                                                                             (170, 1, 49, '192.168.1.6', 'Cancel Product', 'Customer cancel product: 45', '2026-06-23 22:35:22', 1),
                                                                                             (171, 1, 49, '192.168.1.6', 'Cancel Product', 'Customer cancel product: 55', '2026-06-23 22:56:33', 1),
                                                                                             (172, 1, 49, '192.168.1.6', 'Cancel Product', 'Customer cancel product: 55', '2026-06-23 22:56:37', 1),
                                                                                             (173, 1, 49, '192.168.1.6', 'Cancel Product', 'Customer cancel product: 55', '2026-06-23 22:56:42', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `news`
--

CREATE TABLE `news` (
                        `id_news` int(11) NOT NULL,
                        `title_news` varchar(255) NOT NULL,
                        `content_news` text NOT NULL,
                        `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `news`
--

INSERT INTO `news` (`id_news`, `title_news`, `content_news`, `id_user`) VALUES
                                                                            (1, 'Tặng voucher mua hàng trị giá 500k', 'Tặng voucher mua hàng trị giá 500k cho khách hàng có tổng hóa đơn trên 3 triệu (tổng trị giá của tất cả hóa đơn khách hàng đã mua trong năm 2022, với điều kiện giao hàng thành công và không hoàn trả). Voucher được gửi vào ví voucher của khách hàng thỏa điều kiện và có thời hạn sử dụng 30 ngày kể từ ngày gửi.', 2),
                                                                            (2, 'Lỗi website không thể thanh toán bằng hình thức chuyển khoản', 'Hiện website đang gặp sự cố không thể thanh toán bằng hình thức chuyển khoản, quý khách mua hàng có thể chọn thanh toán bằng tiền mặt khi nhận hàng. Mọi thắc mắc xin vui lòng gửi mail phản hồi về website.', 3);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `owner`
--

CREATE TABLE `owner` (
                         `id_company` int(11) NOT NULL,
                         `name_website` varchar(255) NOT NULL,
                         `name_company` varchar(255) NOT NULL,
                         `time_start_proprietary` datetime NOT NULL,
                         `time_finish_proprietary` datetime DEFAULT NULL,
                         `information_company` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `owner`
--

INSERT INTO `owner` (`id_company`, `name_website`, `name_company`, `time_start_proprietary`, `time_finish_proprietary`, `information_company`) VALUES
    (1, 'DORAEMON', 'Doraemon', '2022-11-11 20:41:21', NULL, 'Doraemon gồm 3 thành viên.');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `public_key`
--

CREATE TABLE `public_key` (
                              `id_key` int(11) NOT NULL,
                              `id_user` int(11) NOT NULL,
                              `public_Key` text DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              `create_date` timestamp NOT NULL DEFAULT current_timestamp(),
                              `expire` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `public_key`
--

INSERT INTO `public_key` (`id_key`, `id_user`, `public_Key`, `status`, `create_date`, `expire`) VALUES
                                                                                                    (1, 49, 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmcQvlOsglWM2Mq6JqekYp+iCU0HeRT7Sxae8w2G3qbnA4ha0WGtBjPb8PyuwKnL5KLRsw0gKnq4lZ9qTDo2Uho0bIMiV8Pq8ZuTHkix/Hb+ewWsH6S6tINIr2J3uatmymX2hX1hTugImy6TdYhKFzSKGcEL467dSHy/JFEtZRYWYiemP1bCtWrPcen76zYMaFcZH0af9caiZo8K8IfCAmm/GrYm1e6xVJw4f/s1H66HWX2+Lwc4eoaeqD9Mn2Zi5VNS5iYb38mEfvtr8UinXR4tIE0evMZ8cN26BbsHe6gAuuk8i+ioth+AhGRKzeH6iRdEIer2wxx9l3eyiI5qhjQIDAQAB', 0, '2026-05-23 15:34:35', '2026-06-19 15:30:47'),
                                                                                                    (2, 49, 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwXDWgyCpuxtkrOwVzFDFU9GLqcXIwaI7WLd4pTVhKebF/O/fC5vQt2dtNkHyfZYbCDOJG66AH1aY8IHpuAwiIo2cRtTmRGdp5sCMd5Mi4F0O7tIUwkiEEpsZMhpUZN2CJ94d0n7FYr7tDnFkZPmYNYvQZZiqVrmtOUMtYkqCq1dDD11y7f4N52w5zA7mvJv/S1ITrKabpAleR1BaHnf0zfHMHoUZQJo2tfhW0T3ejEMsBZuL6oLryyjlLFHSFgy0GL92Rp0J0gEbA0mXbJbnRExWRhsqLqbbeamezGiEadaRTeQIoRaRQ/YaDiJe9O050guKdQOPaycuGpOra4/pmwIDAQAB', 0, '2026-05-23 15:34:35', '2026-06-19 15:30:47'),
                                                                                                    (3, 50, 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxPMvIjVJzcaJhoczIl0dQXjy/iw7+qFU7R940VOFt/LY6+lUkxCRiws24CUwi/kgdrABAkSQiNf+0uWoMnAvbPcbGWDUMH15d865QStANC4So0k7VxovFYXa1YoAYROeMC+i9DPG8a4vFhEgvn4OIhQu0Ba8ELsM/MSMNvJ+xVVS316SR65MVO5Z+WZpBkKevbqUgE/+xGWtneoWTqNU52r20b21mIsmmnMxxsT4V8oyVJhstxa0771Yad7eHaTfm9SUi8YGZ3O33fQy74IsCJ3mUMQ2T/yXq1B8gqmDNWi8K1OPbtFLzuL0R26d1weLONi5nocdWBDj3sdl5hUqUQIDAQAB', 1, '2026-05-23 15:49:44', NULL),
                                                                                                    (4, 50, 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvlGhDiOVHw3IivkhJDedXyIxY2k71mPC4t+5xoI1AwraDwJAOF/MiqJlczMaJG62din5R0/452P4HykQB/ARNVnxFPRZAizfErEzksS3VaIJJvFEiJtUyUQ/iRG951iHTQSSDeuAm6QNAFcESZ6axduhMFvgkU7NqKjUO4G6I40XcwmhNYsEwRNdAves4xGpF+ofYy2GF1gPMajGZb7rvtGopdT3+O3sjTPQvgRhjFYzBDqD2D0ci1PfwKOI/35cv69cL78Yvw9IiQ8tyBTr2S7hzrf2U/NOrKdHXDtGQmJsf4NPtdO/cjAD/cDZ3FThsU6MDulb9WJN+3++BgOU7QIDAQAB', 1, '2026-05-23 15:49:44', NULL),
                                                                                                    (5, 49, 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAl0gZZnVQVev0R8VLwA1BaUITF2svVZYTVruqtFGU92DzvTeOmVF3BeupINhNkD7qT81sl0O83UIZdSsElJ6FHbw08Jh0V6ZK34i2ig/pbsi1k/RyeRNLU29Hgu5joxc/yka3prhKF1jpYqYwF+ArG37ufSD106VFzsH6mOJkTwlsgPfxT4HfQ4cIguuaN8wExnUeyksfgA/l3KzoW9bKL9LhikrYtqoY0X65HFjl/p+wVuzpuy6e1PCf150LK/DuQrjUc52v/DKWoRWgWUueeINkY3/ra0acg2LojPecvcO78HaqgT93a/Ue7bscGUdGQzBa8S+iB4m/FpNHdRzvawIDAQAB', 1, '2026-06-19 15:30:48', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `publisher`
--

CREATE TABLE `publisher` (
                             `id_p` int(11) NOT NULL,
                             `name` varchar(50) DEFAULT NULL,
                             `time_start_coop` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                             `time_finish_coop` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `publisher`
--

INSERT INTO `publisher` (`id_p`, `name`, `time_start_coop`, `time_finish_coop`) VALUES
                                                                                    (1, 'NXB Công Thương', '2023-01-06 09:44:22', '2023-01-06'),
                                                                                    (2, 'Nhà xuất bản Giáo dục', '2023-01-06 09:44:25', NULL),
                                                                                    (3, 'Nhà xuất bản Hà Nội', '2023-01-06 09:44:28', NULL),
                                                                                    (4, 'Nhà xuất bản Kim Đồng', '2023-01-06 09:44:29', NULL),
                                                                                    (5, 'Nhà xuất bản Mỹ thuật', '2023-01-06 09:44:31', NULL),
                                                                                    (6, 'Nhà xuất bản Hội Nhà Văn', '2023-01-06 09:44:36', NULL),
                                                                                    (7, 'Nhà xuất bản Phụ nữ', '2023-01-06 09:44:37', NULL),
                                                                                    (8, 'Nhà xuất bản Chính trị Quốc Gia', '2023-01-06 09:44:39', NULL),
                                                                                    (9, 'Nhà xuất bản Tôn giáo', '2023-01-06 09:44:40', NULL),
                                                                                    (10, 'NXB Tổng Hợp TPHCM', '2023-01-06 09:44:41', NULL),
                                                                                    (11, 'Nhà xuất bản Thanh Niên', '2023-01-06 09:44:42', NULL),
                                                                                    (12, 'Nhà Xuất Bản Trẻ', '2023-01-06 09:44:43', NULL),
                                                                                    (13, 'Nhà xuất bản Thông tấn', '2023-01-06 09:44:43', NULL),
                                                                                    (14, 'Nhà xuất bản Văn học', '2023-01-06 09:44:44', NULL),
                                                                                    (15, 'Nhà xuất bản Thế Giới', '2023-01-06 09:44:45', NULL),
                                                                                    (17, 'Nhà xuất bản Văn Hóa Văn Nghệ', '2023-01-08 13:57:10', NULL),
                                                                                    (18, 'Nhà xuất bản Đồng Nai', '2023-01-08 13:57:27', NULL),
                                                                                    (19, 'Nhà xuất bản Lao Động', '2023-01-08 13:58:08', NULL),
                                                                                    (20, 'Nhà xuất bản Hồng Đức', '2023-01-08 13:58:23', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `publisher_company`
--

CREATE TABLE `publisher_company` (
                                     `id_pc` int(11) NOT NULL,
                                     `name` varchar(50) DEFAULT NULL,
                                     `time_start_coop` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                                     `time_finish_coop` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `publisher_company`
--

INSERT INTO `publisher_company` (`id_pc`, `name`, `time_start_coop`, `time_finish_coop`) VALUES
                                                                                             (1, 'Alpha Books', '2023-01-06 09:47:17', NULL),
                                                                                             (2, 'Az Vietnam', '2023-01-06 09:47:17', NULL),
                                                                                             (3, 'ChiBooks', '2023-01-06 09:47:18', NULL),
                                                                                             (4, 'Đông A Book', '2023-01-06 09:47:18', NULL),
                                                                                             (5, 'Đinh Tị', '2023-01-06 09:47:20', NULL),
                                                                                             (6, 'FIRST NEWS', '2023-01-06 09:47:20', NULL),
                                                                                             (7, 'IPM', '2023-01-06 09:47:21', NULL),
                                                                                             (8, 'Nhã Nam', '2023-01-06 09:47:21', NULL),
                                                                                             (9, 'CÔNG TY CỔ PHẦN VĂN HÓA VÀ TRUYỀN THÔNG OOPSY', '2023-01-06 09:47:22', NULL),
                                                                                             (10, 'Phương Nam Books', '2023-01-06 09:47:22', NULL),
                                                                                             (11, 'SkyBooks', '2023-01-06 09:47:23', NULL),
                                                                                             (12, 'Thái Hà Books', '2023-01-06 09:47:24', NULL),
                                                                                             (13, 'Công ty Văn Hóa & Truyền Thông Trí Việt', '2023-01-06 09:47:24', NULL),
                                                                                             (14, 'Việt Thư', '2023-01-06 09:47:25', NULL),
                                                                                             (15, 'Phụ Nữ', '2023-01-06 09:47:26', NULL),
                                                                                             (16, 'Nhà Sách Minh Thắng', '2023-01-08 13:51:11', NULL),
                                                                                             (17, 'Nhà Xuất Bản Kim Đồng', '2023-01-08 13:51:31', NULL),
                                                                                             (18, 'Huy Hoang Bookstore', '2023-01-08 13:52:02', NULL),
                                                                                             (19, 'NXB Trẻ', '2023-01-08 13:52:15', NULL),
                                                                                             (20, 'NXB Tổng Hợp TPHCM', '2023-01-08 13:52:39', NULL),
                                                                                             (21, 'NXB Văn Hóa Văn Nghệ', '2023-01-08 13:53:12', NULL),
                                                                                             (22, 'NXB Hội Nhà Văn', '2023-01-08 13:53:26', NULL),
                                                                                             (23, 'CÔNG TY TNHH IN ẤN-DV-TM SIÊU TỐC', '2023-01-08 13:53:56', NULL),
                                                                                             (24, 'Panda Books', '2023-01-08 13:54:43', NULL),
                                                                                             (25, 'Cty Văn Hóa Văn Lang', '2023-01-08 13:54:52', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `rate`
--

CREATE TABLE `rate` (
                        `id_user` int(11) NOT NULL,
                        `id_book` int(11) NOT NULL,
                        `id_order` int(11) NOT NULL,
                        `start_rate` int(11) DEFAULT NULL,
                        `comment` text DEFAULT NULL,
                        `rate_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                        `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `slide_pr`
--

CREATE TABLE `slide_pr` (
                            `id_pr` int(11) NOT NULL,
                            `name_pr` varchar(50) DEFAULT NULL,
                            `img` text DEFAULT NULL,
                            `link` text DEFAULT NULL,
                            `start_time` date DEFAULT NULL,
                            `finish_time` date DEFAULT NULL,
                            `create_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                            `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `slide_pr`
--

INSERT INTO `slide_pr` (`id_pr`, `name_pr`, `img`, `link`, `start_time`, `finish_time`, `create_time`, `status`) VALUES
                                                                                                                     (1, 'silde1', '/templates/images/slide1.jpg', '/templates/images/slide1.jpg', '2023-02-12', NULL, '2023-02-12 09:21:07', 1),
                                                                                                                     (2, 'silde2', '/templates/images/slide2.jpg', '/templates/images/slide2.jpg', '2023-02-12', NULL, '2023-02-12 09:21:10', 1),
                                                                                                                     (3, 'slide3', '/templates/images/slide3.jpg', '/templates/images/slide3.jpg', '2023-02-12', NULL, '2023-02-12 09:21:18', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `transactions`
--

CREATE TABLE `transactions` (
                                `id_transaction` int(11) NOT NULL,
                                `status` text DEFAULT NULL COMMENT '1: thành công; 0: không thành công',
                                `id_user` int(11) NOT NULL,
                                `name_customer` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
                                `email_customer` varchar(30) DEFAULT NULL,
                                `phone_customer` char(10) DEFAULT NULL,
                                `quantity` int(11) DEFAULT NULL,
                                `payment` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'tên cổng thanh toán',
                                `payment_info` text DEFAULT NULL COMMENT 'thông tin trả về',
                                `messenger` text DEFAULT NULL,
                                `security` text DEFAULT NULL COMMENT 'mã bảo mật',
                                `created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `transactions`
--

INSERT INTO `transactions` (`id_transaction`, `status`, `id_user`, `name_customer`, `email_customer`, `phone_customer`, `quantity`, `payment`, `payment_info`, `messenger`, `security`, `created`) VALUES
    (1, NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-06 13:54:45');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `university`
--

CREATE TABLE `university` (
                              `id_university` int(11) NOT NULL,
                              `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Tên trường',
                              `short_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Tên viết tắt',
                              `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `university`
--

INSERT INTO `university` (`id_university`, `name`, `short_name`, `address`) VALUES
                                                                                (1, 'Đại Học Bách Khoa TP.HCM (HCMUT)', 'BKU', '268 Lý Thường Kiệt, Phường 14, Quận 10, TP.HCM'),
                                                                                (2, 'Đại Học Kinh Tế TP.HCM (UEH)', 'UEH', '59C Nguyễn Đình Chiểu, Phường 6, Quận 3, TP.HCM'),
                                                                                (3, 'Đại Học Y Dược TP.HCM (UMP)', 'UMP', '217 Hồng Bàng, Phường 11, Quận 5, TP.HCM'),
                                                                                (4, 'Đại Học Sư Phạm TP.HCM (HCMUE)', 'HCMUE', '280 An Dương Vương, Phường 4, Quận 5, TP.HCM');

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_comment`
-- (See below for the actual view)
--
CREATE TABLE `v_comment` (
                             `id_book` int(11)
    ,`sl_comment` bigint(21)
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_dept_book`
-- (See below for the actual view)
--
CREATE TABLE `v_dept_book` (
                               `id_university` int(11)
    ,`university_name` varchar(200)
    ,`short_name` varchar(50)
    ,`id_department` int(11)
    ,`department_name` varchar(150)
    ,`id_book` int(11)
    ,`book_name` varchar(200)
    ,`price` double
    ,`discount_price` double
    ,`note` varchar(50)
    ,`cover_img` varchar(255)
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_rate`
-- (See below for the actual view)
--
CREATE TABLE `v_rate` (
                          `id_book` int(11)
    ,`start` decimal(14,4)
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_sl_pay_top`
-- (See below for the actual view)
--
CREATE TABLE `v_sl_pay_top` (
                                `id_book` int(11)
    ,`sl_book` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_comment`
--
DROP TABLE IF EXISTS `v_comment`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_comment`  AS SELECT `rate`.`id_book` AS `id_book`, count(`rate`.`comment`) AS `sl_comment` FROM `rate` GROUP BY `rate`.`id_book` ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_dept_book`
--
DROP TABLE IF EXISTS `v_dept_book`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_dept_book`  AS SELECT `u`.`id_university` AS `id_university`, `u`.`name` AS `university_name`, `u`.`short_name` AS `short_name`, `d`.`id_department` AS `id_department`, `d`.`name` AS `department_name`, `b`.`id_book` AS `id_book`, `b`.`name` AS `book_name`, `b`.`price` AS `price`, `b`.`discount_price` AS `discount_price`, `db2`.`note` AS `note`, (select `img`.`image` from `image_book` `img` where `img`.`id_book` = `b`.`id_book` limit 1) AS `cover_img` FROM (((`university` `u` join `department` `d` on(`d`.`id_university` = `u`.`id_university`)) join `department_book` `db2` on(`db2`.`id_department` = `d`.`id_department`)) join `book` `b` on(`b`.`id_book` = `db2`.`id_book`)) WHERE `b`.`isActive` = 1 ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_rate`
--
DROP TABLE IF EXISTS `v_rate`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_rate`  AS SELECT `rate`.`id_book` AS `id_book`, avg(`rate`.`start_rate`) AS `start` FROM `rate` GROUP BY `rate`.`id_book` ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_sl_pay_top`
--
DROP TABLE IF EXISTS `v_sl_pay_top`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_sl_pay_top`  AS SELECT `bill`.`id_book` AS `id_book`, sum(`bill`.`quantity`) AS `sl_book` FROM `bill` GROUP BY `bill`.`id_book` ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `auction`
--
ALTER TABLE `auction`
    ADD PRIMARY KEY (`id`),
    ADD KEY `fk_auction_book` (`book_id`),
    ADD KEY `fk_auction_customer` (`winner_id`);

--
-- Chỉ mục cho bảng `auction_bid`
--
ALTER TABLE `auction_bid`
    ADD PRIMARY KEY (`id`),
    ADD KEY `fk_bid_auction` (`auction_id`),
    ADD KEY `fk_bid_user` (`user_id`);

--
-- Chỉ mục cho bảng `auction_notification`
--
ALTER TABLE `auction_notification`
    ADD PRIMARY KEY (`id`),
    ADD KEY `fk_notification_user` (`user_id`),
    ADD KEY `fk_notification_auction` (`auction_id`);

--
-- Chỉ mục cho bảng `author`
--
ALTER TABLE `author`
    ADD PRIMARY KEY (`id_author`) USING BTREE;

--
-- Chỉ mục cho bảng `bill`
--
ALTER TABLE `bill`
    ADD PRIMARY KEY (`id_order`) USING BTREE,
    ADD KEY `bil_ibfk_1` (`id_user`),
    ADD KEY `bil_ibfk_2` (`id_book`),
    ADD KEY `bil_ibfk_3` (`idCart`);

--
-- Chỉ mục cho bảng `book`
--
ALTER TABLE `book`
    ADD PRIMARY KEY (`id_book`) USING BTREE,
    ADD KEY `id_author` (`id_author`) USING BTREE,
    ADD KEY `id_catalog` (`id_catalog`) USING BTREE,
    ADD KEY `id_pc` (`id_pc`) USING BTREE,
    ADD KEY `id_p` (`id_p`) USING BTREE;

--
-- Chỉ mục cho bảng `book_details`
--
ALTER TABLE `book_details`
    ADD KEY `book_details_ibfk_1` (`id_book`) USING BTREE;

--
-- Chỉ mục cho bảng `carts`
--
ALTER TABLE `carts`
    ADD PRIMARY KEY (`id`),
    ADD KEY `carts_ibfk_1` (`idUser`);

--
-- Chỉ mục cho bảng `cart_detail`
--
ALTER TABLE `cart_detail`
    ADD PRIMARY KEY (`id`),
    ADD KEY `cart_id` (`cart_id`);

--
-- Chỉ mục cho bảng `catalog`
--
ALTER TABLE `catalog`
    ADD PRIMARY KEY (`id_catalog`) USING BTREE;

--
-- Chỉ mục cho bảng `contact`
--
ALTER TABLE `contact`
    ADD PRIMARY KEY (`id_contact`) USING BTREE;

--
-- Chỉ mục cho bảng `customer`
--
ALTER TABLE `customer`
    ADD PRIMARY KEY (`id_user`) USING BTREE;

--
-- Chỉ mục cho bảng `department`
--
ALTER TABLE `department`
    ADD PRIMARY KEY (`id_department`),
    ADD KEY `fk_dept_univ` (`id_university`);

--
-- Chỉ mục cho bảng `department_book`
--
ALTER TABLE `department_book`
    ADD PRIMARY KEY (`id_department`,`id_book`),
    ADD KEY `fk_db_book` (`id_book`);

--
-- Chỉ mục cho bảng `discount`
--
ALTER TABLE `discount`
    ADD PRIMARY KEY (`id_discount`) USING BTREE;

--
-- Chỉ mục cho bảng `discount_customer`
--
ALTER TABLE `discount_customer`
    ADD PRIMARY KEY (`id_discount`,`id_user`) USING BTREE,
    ADD KEY `voucher_fk2` (`id_user`) USING BTREE;

--
-- Chỉ mục cho bảng `image_book`
--
ALTER TABLE `image_book`
    ADD PRIMARY KEY (`id_image`) USING BTREE,
    ADD KEY `book_fk12` (`id_book`) USING BTREE;

--
-- Chỉ mục cho bảng `infomationdelivers`
--
ALTER TABLE `infomationdelivers`
    ADD PRIMARY KEY (`id`),
    ADD KEY `infomationdelivers_ibfk_1` (`idCart`);

--
-- Chỉ mục cho bảng `logs`
--
ALTER TABLE `logs`
    ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `news`
--
ALTER TABLE `news`
    ADD PRIMARY KEY (`id_news`) USING BTREE,
    ADD KEY `news_fk1` (`id_user`) USING BTREE;

--
-- Chỉ mục cho bảng `owner`
--
ALTER TABLE `owner`
    ADD PRIMARY KEY (`id_company`) USING BTREE;

--
-- Chỉ mục cho bảng `public_key`
--
ALTER TABLE `public_key`
    ADD PRIMARY KEY (`id_key`),
    ADD KEY `id_user` (`id_user`);

--
-- Chỉ mục cho bảng `publisher`
--
ALTER TABLE `publisher`
    ADD PRIMARY KEY (`id_p`) USING BTREE;

--
-- Chỉ mục cho bảng `publisher_company`
--
ALTER TABLE `publisher_company`
    ADD PRIMARY KEY (`id_pc`) USING BTREE;

--
-- Chỉ mục cho bảng `rate`
--
ALTER TABLE `rate`
    ADD PRIMARY KEY (`id_user`,`id_book`,`id_order`) USING BTREE,
    ADD KEY `id_book` (`id_book`) USING BTREE,
    ADD KEY `id_order` (`id_order`) USING BTREE;

--
-- Chỉ mục cho bảng `slide_pr`
--
ALTER TABLE `slide_pr`
    ADD PRIMARY KEY (`id_pr`) USING BTREE;

--
-- Chỉ mục cho bảng `transactions`
--
ALTER TABLE `transactions`
    ADD PRIMARY KEY (`id_transaction`) USING BTREE,
    ADD KEY `id_user` (`id_user`) USING BTREE;

--
-- Chỉ mục cho bảng `university`
--
ALTER TABLE `university`
    ADD PRIMARY KEY (`id_university`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `auction`
--
ALTER TABLE `auction`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `auction_bid`
--
ALTER TABLE `auction_bid`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `auction_notification`
--
ALTER TABLE `auction_notification`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `author`
--
ALTER TABLE `author`
    MODIFY `id_author` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT cho bảng `bill`
--
ALTER TABLE `bill`
    MODIFY `id_order` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=149;

--
-- AUTO_INCREMENT cho bảng `book`
--
ALTER TABLE `book`
    MODIFY `id_book` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=229;

--
-- AUTO_INCREMENT cho bảng `carts`
--
ALTER TABLE `carts`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT cho bảng `cart_detail`
--
ALTER TABLE `cart_detail`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `catalog`
--
ALTER TABLE `catalog`
    MODIFY `id_catalog` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `contact`
--
ALTER TABLE `contact`
    MODIFY `id_contact` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `customer`
--
ALTER TABLE `customer`
    MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT cho bảng `department`
--
ALTER TABLE `department`
    MODIFY `id_department` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `discount`
--
ALTER TABLE `discount`
    MODIFY `id_discount` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10004;

--
-- AUTO_INCREMENT cho bảng `image_book`
--
ALTER TABLE `image_book`
    MODIFY `id_image` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=229;

--
-- AUTO_INCREMENT cho bảng `infomationdelivers`
--
ALTER TABLE `infomationdelivers`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT cho bảng `logs`
--
ALTER TABLE `logs`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=174;

--
-- AUTO_INCREMENT cho bảng `news`
--
ALTER TABLE `news`
    MODIFY `id_news` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `owner`
--
ALTER TABLE `owner`
    MODIFY `id_company` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `public_key`
--
ALTER TABLE `public_key`
    MODIFY `id_key` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `publisher`
--
ALTER TABLE `publisher`
    MODIFY `id_p` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `publisher_company`
--
ALTER TABLE `publisher_company`
    MODIFY `id_pc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT cho bảng `transactions`
--
ALTER TABLE `transactions`
    MODIFY `id_transaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `university`
--
ALTER TABLE `university`
    MODIFY `id_university` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `auction`
--
ALTER TABLE `auction`
    ADD CONSTRAINT `fk_auction_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`id_book`),
    ADD CONSTRAINT `fk_auction_customer` FOREIGN KEY (`winner_id`) REFERENCES `customer` (`id_user`);

--
-- Các ràng buộc cho bảng `auction_bid`
--
ALTER TABLE `auction_bid`
    ADD CONSTRAINT `fk_bid_auction` FOREIGN KEY (`auction_id`) REFERENCES `auction` (`id`) ON DELETE CASCADE,
    ADD CONSTRAINT `fk_bid_user` FOREIGN KEY (`user_id`) REFERENCES `customer` (`id_user`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `auction_notification`
--
ALTER TABLE `auction_notification`
    ADD CONSTRAINT `fk_notification_auction` FOREIGN KEY (`auction_id`) REFERENCES `auction` (`id`),
    ADD CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `customer` (`id_user`);

--
-- Các ràng buộc cho bảng `bill`
--
ALTER TABLE `bill`
    ADD CONSTRAINT `bil_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `customer` (`id_user`),
    ADD CONSTRAINT `bil_ibfk_2` FOREIGN KEY (`id_book`) REFERENCES `book` (`id_book`),
    ADD CONSTRAINT `bil_ibfk_3` FOREIGN KEY (`idCart`) REFERENCES `carts` (`id`);

--
-- Các ràng buộc cho bảng `book`
--
ALTER TABLE `book`
    ADD CONSTRAINT `book_ibfk_1` FOREIGN KEY (`id_author`) REFERENCES `author` (`id_author`),
    ADD CONSTRAINT `book_ibfk_2` FOREIGN KEY (`id_catalog`) REFERENCES `catalog` (`id_catalog`),
    ADD CONSTRAINT `book_ibfk_3` FOREIGN KEY (`id_pc`) REFERENCES `publisher_company` (`id_pc`),
    ADD CONSTRAINT `book_ibfk_4` FOREIGN KEY (`id_p`) REFERENCES `publisher` (`id_p`);

--
-- Các ràng buộc cho bảng `book_details`
--
ALTER TABLE `book_details`
    ADD CONSTRAINT `book_details_ibfk_1` FOREIGN KEY (`id_book`) REFERENCES `book` (`id_book`);

--
-- Các ràng buộc cho bảng `carts`
--
ALTER TABLE `carts`
    ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `customer` (`id_user`);

--
-- Các ràng buộc cho bảng `cart_detail`
--
ALTER TABLE `cart_detail`
    ADD CONSTRAINT `cart_detail_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`);

--
-- Các ràng buộc cho bảng `department`
--
ALTER TABLE `department`
    ADD CONSTRAINT `fk_dept_univ` FOREIGN KEY (`id_university`) REFERENCES `university` (`id_university`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `department_book`
--
ALTER TABLE `department_book`
    ADD CONSTRAINT `fk_db_book` FOREIGN KEY (`id_book`) REFERENCES `book` (`id_book`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_db_dept` FOREIGN KEY (`id_department`) REFERENCES `department` (`id_department`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `discount_customer`
--
ALTER TABLE `discount_customer`
    ADD CONSTRAINT `voucher_fk1` FOREIGN KEY (`id_discount`) REFERENCES `discount` (`id_discount`),
    ADD CONSTRAINT `voucher_fk2` FOREIGN KEY (`id_user`) REFERENCES `customer` (`id_user`);

--
-- Các ràng buộc cho bảng `image_book`
--
ALTER TABLE `image_book`
    ADD CONSTRAINT `book_fk12` FOREIGN KEY (`id_book`) REFERENCES `book` (`id_book`);

--
-- Các ràng buộc cho bảng `infomationdelivers`
--
ALTER TABLE `infomationdelivers`
    ADD CONSTRAINT `infomationdelivers_ibfk_1` FOREIGN KEY (`idCart`) REFERENCES `carts` (`id`);

--
-- Các ràng buộc cho bảng `news`
--
ALTER TABLE `news`
    ADD CONSTRAINT `news_fk1` FOREIGN KEY (`id_user`) REFERENCES `customer` (`id_user`);

--
-- Các ràng buộc cho bảng `public_key`
--
ALTER TABLE `public_key`
    ADD CONSTRAINT `public_key_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `customer` (`id_user`);

--
-- Các ràng buộc cho bảng `rate`
--
ALTER TABLE `rate`
    ADD CONSTRAINT `rate_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `customer` (`id_user`),
    ADD CONSTRAINT `rate_ibfk_2` FOREIGN KEY (`id_book`) REFERENCES `book` (`id_book`),
    ADD CONSTRAINT `rate_ibfk_3` FOREIGN KEY (`id_order`) REFERENCES `bill` (`id_order`);

--
-- Các ràng buộc cho bảng `transactions`
--
ALTER TABLE `transactions`
    ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `customer` (`id_user`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
