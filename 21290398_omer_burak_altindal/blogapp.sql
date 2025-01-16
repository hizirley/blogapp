-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 16, 2025 at 11:06 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `blogapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `post_id`, `user_email`, `content`, `created_at`) VALUES
(1, 6, 'user@example.com', 'deneme yorum 1', '2025-01-15 23:31:51'),
(2, 6, 'omer4@gmail.com', 'deneme yorum 2', '2025-01-15 23:35:41'),
(3, 6, 'burak3@gmail.com', 'bu yorum bir deneme yorumudur aaa bbbb ccc', '2025-01-15 23:36:25'),
(4, 7, 'burak3@gmail.com', 'dsfzbdxgngsfxd', '2025-01-15 23:40:22'),
(5, 7, 'omer4@gmail.com', 'ccccc', '2025-01-15 23:40:33'),
(6, 7, 'omer4@gmail.com', 'jjjj', '2025-01-15 23:40:40'),
(7, 6, 'omer4@gmail.com', 'asd asd 123', '2025-01-15 23:40:48'),
(8, 5, 'omer4@gmail.com', 'd', '2025-01-15 23:56:28'),
(9, 7, 'elif@gmail.com', 'deneme yorumu', '2025-01-16 18:16:26'),
(10, 8, 'elif@gmail.com', 'deneme yorum 1', '2025-01-16 18:27:03'),
(11, 8, 'elif@gmail.com', 'deneme yorum 2', '2025-01-16 18:27:09'),
(12, 11, 'omer4@gmail.com', 'yorum 1', '2025-01-16 20:18:04');

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`id`, `post_id`, `user_email`, `created_at`) VALUES
(11, 6, 'omer4@gmail.com', '2025-01-15 23:56:14'),
(13, 7, 'omer4@gmail.com', '2025-01-15 23:56:20'),
(15, 5, 'elif@gmail.com', '2025-01-16 18:35:31'),
(17, 11, 'omer4@gmail.com', '2025-01-16 20:18:05');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `picture` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_email`, `title`, `content`, `picture`, `created_at`) VALUES
(3, 'omer4@gmail.com', 'adsfxb', 'safdgfxg', '678823011e674_1010.png', '2025-01-15 21:05:05'),
(4, 'burak3@gmail.com', 'deneme 2', 'deneme 2 içerik', '678824acbcef5_Ekran görüntüsü 2022-03-31 134212.png', '2025-01-15 21:12:12'),
(5, 'omer4@gmail.com', 'deneme postu 3', 'deneme postu 3 içerik', '678824cc30726_Ekran görüntüsü 2022-03-19 224824.png', '2025-01-15 21:12:44'),
(6, 'burak3@gmail.com', 'deneme post 4 başlık', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', '67882512b77e9_Ekran görüntüsü 2023-04-27 231418.png', '2025-01-15 21:13:54'),
(7, 'omer4@gmail.com', 'deneme 5', 'deneme 5 içerik  deneme 5 içerik  deneme 5 içerik  deneme 5 içerik  deneme 5 içerik', '6788411b21344_Ekran görüntüsü 2022-10-23 183026.png', '2025-01-15 23:13:31'),
(8, 'elif@gmail.com', 'en son 1', 'en son içerik 1', '67894d0e7ffff_Ekran görüntüsü 2024-07-29 005333.png', '2025-01-16 18:16:46'),
(9, 'elif@gmail.com', 'ankara', 'ankara içerik', '6789627910273_erp_1.png', '2025-01-16 19:48:09'),
(10, 'omer4@gmail.com', 'dfsagdsfhng 23', 'sdaf k jb h yuv kyv v uasvjhfavj fvakshvf jhas vjhvasfjsav jv  vkahsjv', '6789684e08bf0_IMG-20211119-WA0011.jpg', '2025-01-16 20:13:02'),
(11, 'omer4@gmail.com', 'gönderi 1', 'gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1 gönderi 1 içerik 1', '67896956642c5_2021-11-15.png', '2025-01-16 20:17:26');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `name` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `profile_picture` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `created_at`, `name`, `surname`, `phone`, `profile_picture`) VALUES
(1, 'test@example.com', '$2y$10$GL1V6MQ.7s9M70.WVbHid.aWyLizGmQzdLOmGQPmm73eSOP/9kVuC', '2025-01-12 18:42:04', '', '', '', NULL),
(16, 'deenem@gmail.com', '$2y$10$WumGylWPHYxUn0cOavd4O.pRUiPO6Wobtf7ed1oLypypHdJJkEXe2', '2025-01-12 18:56:59', 'kemal', 'Altındal 2', '5467217390', NULL),
(17, 'afdsgcnvb@gmail.com', '$2y$10$J/HfSS5ISp5VA8PYkBJ2e.WzbIETHQAXxoQGFrD7iTkwj6ZeNEOIi', '2025-01-13 16:41:27', '', '', '', NULL),
(18, 'son@gmail.com', '$2y$10$cHdo3diXwnYy8mMRcno.ku20gxGvUleF1fp./b6GRbTKjBxq282pa', '2025-01-13 16:44:55', '', '', '', NULL),
(19, 'test@gmail.com', '$2y$10$UxaQ2Qi3mSbIieGkv6aPy.yY2lmkNWDN18PdusqudslRt/ci3XbnK', '2025-01-13 16:52:22', '', '', '', NULL),
(20, 'omer4@gmail.com', '$2y$10$SFkVk6jNX3/oTEazu9vbxOKLvbE5qixxQ2k4Sw2al0/qdY4I6tdfq', '2025-01-13 17:07:36', 'Ömer Burak 5', 'Altındal 4', '5467217394', 'uploads/67896a8416db3_2021-11-04.png'),
(21, 'sadfgda@gmail.com', '$2y$10$S64Zp.ZknDvAC.ChlzxFw.VqZ7uoa1stMSm/rAkGXQsvp92KIHO3q', '2025-01-13 18:40:51', 'asd', 'sdf', '23432', NULL),
(22, 'ssssss@gmail.com', '$2y$10$k3kvzLHbbAO7G.LLtSRs7eNpkdTZPxFLVYSuzGEX.QuyzyPDvH17e', '2025-01-13 18:42:29', 'sdaf', 'ewfsgdhgj', '3245', NULL),
(23, 'mehmet@gmail.com', '$2y$10$/2V0Fb/OPnCZFqqoYuyzQOLb3F7g.cUKuXrj6u4rlYU4IEn/nIIVK', '2025-01-13 18:58:31', 'Mehmet', 'Çakır', '2342342343', NULL),
(24, 'ldsjnvbhds@gmail.com', '$2y$10$99m8RCgasiLbFqB44g1PZ.2GKgYs7AHlsCbt6Dp9M.VjpqCIiqob2', '2025-01-13 19:09:10', 'sdsdf', 'fdsggfd', '23424324', NULL),
(25, 'burak3@gmail.com', '$2y$10$fPovg7iH3k63Gi3cuEV/E.xg9zxDzBeiNOw1DCU2PvFiKf/k/4UAa', '2025-01-15 18:11:51', 'Burak 3', 'Altındal 3', '5467217393', 'uploads/678800709c077_Ekran görüntüsü 2022-04-28 211127.png'),
(26, 'elif@gmail.com', '$2y$10$pGpp1nGpJg2/qvLWeUBo9uqH4tT.Yy.l.8Mmanv2PtNHqsmV8OG3i', '2025-01-16 17:48:40', 'Elif 1', 'Şimşek 1', '2345678971', 'uploads/678946a7a943d_Ekran görüntüsü 2024-07-27 162710.png'),
(27, 'gfd@gmail.com', '$2y$10$Y7zix0exgSqXZFjs0UKIsecWl7O1tlUK2jH/BJhwCKJ4iTVsPxO/u', '2025-01-16 19:54:57', 'gfd', 'gfd', '3453453445', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `post_id` (`post_id`,`user_email`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
