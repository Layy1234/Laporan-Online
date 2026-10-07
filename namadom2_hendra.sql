-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 07, 2026 at 09:13 AM
-- Server version: 10.6.28-MariaDB
-- PHP Version: 8.4.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `namadom2_hendra`
--

-- --------------------------------------------------------

--
-- Table structure for table `stores`
--

CREATE TABLE `stores` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `storeName` varchar(255) NOT NULL,
  `ownerName` varchar(255) NOT NULL,
  `picName` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text NOT NULL,
  `volx` varchar(50) DEFAULT NULL,
  `takis` varchar(50) DEFAULT NULL,
  `tribe` varchar(50) DEFAULT NULL,
  `pod_volx` varchar(50) DEFAULT NULL,
  `pod_takis` varchar(50) DEFAULT NULL,
  `pod_tribe` varchar(50) DEFAULT NULL,
  `ct` varchar(50) DEFAULT NULL,
  `inside` text DEFAULT NULL,
  `reporterName` varchar(255) DEFAULT NULL,
  `imagePaths` text DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stores`
--

INSERT INTO `stores` (`id`, `user_id`, `storeName`, `ownerName`, `picName`, `phone`, `address`, `volx`, `takis`, `tribe`, `pod_volx`, `pod_takis`, `pod_tribe`, `ct`, `inside`, `reporterName`, `imagePaths`, `createdAt`) VALUES
(1, 1, 'abc', 'abc', 'abc', NULL, 'abc', '22', '22', '', '22', '', '', '5', 'Bcd', 'Hendrawan Harahap', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791021879_image_picker_49CCFEDC-2506-4BAC-B1D4-A221EAAB4771-10909-0000029C5B4740E3.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791021879_image_picker_B51B3426-1781-45B5-886C-1E3FC6BCED8B-10909-0000029C5ADE2AC8.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791021879_image_picker_884AC2E0-850F-40A8-9AF3-43D1A38CE53B-10909-0000029C5BC208A9.jpg\"]', '2026-10-03 10:04:39'),
(2, NULL, 'simple', 'abc', 'abc', NULL, 'sbc', '', '', '', '22', '', '', '22', '', 'Hendrawan Harahap', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791022369_image_picker_F07634BE-2711-4528-B13C-33BAE5F8A468-10950-0000029F147D4E5F.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791022369_image_picker_3F002A2B-515B-4FC9-A7BF-95DC8485E193-10950-0000029F14E9BB01.jpg\"]', '2026-10-03 10:12:49'),
(3, 1, 'abc', 'abc', 'abc', NULL, 'abc', '88', '88', '', '', '', '', '', 'abcd ', 'Hendrawan Harahap', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791022508_image_picker_F941ED52-C521-4E63-AFE9-A0629013686A-10950-0000029FDB71C6C8.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791022508_image_picker_1D59CE52-FF38-4095-9F8E-5FAB834C0C6B-10950-0000029FDBDEC78D.jpg\"]', '2026-10-03 10:15:08'),
(4, NULL, 'abc', 'abc', 'abc', NULL, 'abc', '22', '22', '22', '', '', '', '', 'bv', 'Hendrawan Harahap', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791023659_image_picker_1373AFA3-AE1A-4355-8A6A-5E47D013BB6D-11062-000002A64FE96E31.jpg\"]', '2026-10-03 10:34:19'),
(5, 1, 'abcd', 'abc', 'abc', NULL, 'abcd', '22', '', '', '', '', '', '', '', 'Hendrawan Harahap', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791046667_18782.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791046667_18781.jpg\"]', '2026-10-03 16:57:47'),
(6, 1, 'abcd', 'abc', 'abc', NULL, 'abc', '', '', '', '', '', '', '', '', 'Hendrawan Harahap', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791047177_19054.jpg\"]', '2026-10-03 17:06:17'),
(7, 1, 'abv', 'bb', 'bb', NULL, 'bb', '', '', '', '', '', '', '', '', 'Hendrawan Harahap', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791048756_19058.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791048756_19054.jpg\"]', '2026-10-03 17:32:36'),
(8, 2, 'Vape Port', 'TIAR', 'TIAR', NULL, 'vape port, Jl.Pramuka, Rajabasa, Bandar Lampung, Lampung (samping bebek belur pramuka)', '0', '112', '0', '0', '0', '0', '0', '-reminder program\n-mengingatkan traking volume pembelian per september di mildos\n-pemberian tester\n-penetrasi liquid volx', 'Moh Tegar Huda Putra', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791201456_image_picker_CD8DB445-B6FD-4C58-BCBC-62483FF85A85-20277-000004D1B35DDCDE.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791201456_image_picker_3FA87871-BCC1-4EE8-AB3D-B813C17BD3EF-20277-000004D1B2EF3F1F.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791201456_image_picker_FD2A359F-0F20-4367-8C5E-9916386611FE-20277-000004D1B27D203D.jpg\"]', '2026-10-05 11:57:36'),
(10, 2, 'SIMPLE VAPE STORE', 'egga', 'Alex', NULL, 'Jl. Pancasila Sakti Gg. Fajar Sari No.7 Sumberejo Kemiling, Bandar Lampung 35153', '14', '77', NULL, NULL, NULL, NULL, NULL, 'produk TVA always ready\norder 250pcs liquid volx fu ke cycloz distribution\norder takis otw belum kirim jumlah qty beso sudah di forwards ke bang egiv', 'Moh Tegar Huda Putra', NULL, NULL),
(11, 2, 'SAILOR VAPE STORE', 'WAWAN', 'MAYA', NULL, 'Jl. Teuku Umar, Penengahan, Kec. Tj. Karang Pusat, Kota Bandar Lampung, Lampung 35112 (Depan pertigaan rumah sakit abdoel moelok)', NULL, '50', NULL, NULL, NULL, NULL, NULL, 'pergantian owner dari teteh risma ke bang wawan mildos\nperkenalan dengan vaporista baru\nperihal program dll aman karna sudah dibawah naungan bang wawan mildos', 'Moh Tegar Huda Putra', NULL, NULL),
(12, 2, 'SIMPLE VAPE STORE KAMPUNG BARU', 'Egga', 'Nabil', NULL, 'Jl. Bumi Manti III, Kp. Baru, Kec. Kedaton, Kota Bandar Lampung, Lampung 35141', '21', '54', NULL, NULL, NULL, NULL, '15', 'produk tva always ready!\nseluruh pod volx dijadikan satu untuk didata keseluruhan total volx pod ada berapa yang mau dijadikan barang dengan modal baru', 'Moh Tegar Huda Putra', NULL, NULL),
(13, 2, 'VAPE EOK', 'AGUS', 'VIDHY', NULL, 'Jl. Abd Muis II No.07, Gedong Meneng, Kec. Rajabasa, Kota Bandar Lampung 35145 (depan kosan putih)', '22', '5', NULL, NULL, NULL, NULL, NULL, 'reminder program\npemberian tester\ningin taking order 300pcs botol (150botol takis 150botol volx) pr nya ingin minta top 1 bulan', 'Moh Tegar Huda Putra', NULL, NULL),
(14, 2, 'BONG VAPE STORE', 'Koh Ahen', 'Koh Ahen', '0821-4491-8889', 'Jl. ZA. Pagar Alam No.52.B, Gedong Meneng, Kec. Rajabasa, Kota Bandar Lampung, Lampung 35145', NULL, '35', NULL, NULL, NULL, NULL, NULL, 'reminder program\nnotice perihal harga baru pod volx sudah mau stok\npemberian tester', 'Moh Tegar Huda Putra', NULL, NULL),
(15, 2, 'AYMAN VAPE STORE', 'jazman', 'jazman', NULL, 'Jln. Alamsyah Ratu prawiranegara, Pemanggilan, Kec. Natar, Kabupaten Lampung Selatan, Lampung 35362', '0', '58', '0', NULL, NULL, NULL, '0', 'visit biasa\nsounding tracking volume per september\npemberian tester', 'Moh Tegar Huda Putra', NULL, NULL),
(17, 2, 'Naga Raja Vape Store', 'Teteh Risma', 'Anjas', '0821-7629-8475', 'Jl. P. Senopati, Jatimulyo, Kec. Jati Agung, Kabupaten Lampung Selatan, Lampung 35365', '0', '16', '0', '0', '0', '0', '0', '-perkenalan sebagai sales area tva yang baru\n-ngobrol santai perihal vape store (pic sudah kenal)\n-minta di follow up ke pihak owner supaya lebih banyak lagi stok takis dan minta diusahakan di stok liquid volxnya ', 'Moh Tegar Huda Putra', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791286971_image_picker_E910ADC7-6544-4F80-9F58-85C72FCE3346-1728-00000030834BE89C.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791286971_image_picker_73A91503-F013-4FC5-9E1F-8AA23B459472-1728-0000003082B30286.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791286971_image_picker_7F71B9C5-16D2-4638-8A9E-3F4B97C18FFC-1728-0000003083006913.jpg\"]', '2026-10-06 11:42:51'),
(19, 2, 'SIMPLE VAPE STORE KEMILING2', 'Egga', 'NDOY', '082195903700', 'DEPAN EUREKA STUDIO, Jl. Imam Bonjol, Sumber Rejo, Kec. Kemiling, Kota Bandar Lampung, Lampung 35151', '20', '34', '0', '', '', '', '9', 'laporan untuk simple kurang lebih sama dengan yang lain', 'Moh Tegar Huda Putra', '[\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791292015_image_picker_7FF62A9A-44AC-493B-9314-4D57A8694628-1728-00000048D0E944F3.jpg\",\"https:\\/\\/laporantva.my.id\\/api\\/uploads\\/1791292015_image_picker_6CBB2EBB-D662-47ED-AB2E-A8C15D6624F1-1728-00000048D06DB38C.jpg\"]', '2026-10-06 13:06:55');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `username`) VALUES
(1, 'Hendrawan Harahap', 'hendra'),
(2, 'Moh Tegar Huda Putra', 'ega'),
(3, 'Ar. reza indra pahlevi', 'Reza');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `stores`
--
ALTER TABLE `stores`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `stores`
--
ALTER TABLE `stores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
