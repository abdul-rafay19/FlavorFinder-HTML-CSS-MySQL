-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Feb 09, 2025 at 10:45 AM
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
-- Database: `project`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddUser` (IN `p_username` VARCHAR(50), IN `p_email` VARCHAR(100), IN `p_password` VARCHAR(255))   BEGIN
    INSERT INTO Users (Username, Email, Password)
    VALUES (p_username, p_email, p_password);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUser` (IN `p_userID` INT)   BEGIN
    DELETE FROM Users
    WHERE ID = p_userID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRestaurantsByCuisine` (IN `p_cuisineName` VARCHAR(50))   BEGIN
    SELECT r.*
    FROM Restaurants r
    JOIN Cuisines c ON r.CuisineID = c.ID
    WHERE c.CuisineName = p_cuisineName;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUserEmail` (IN `p_userID` INT, IN `p_newEmail` VARCHAR(100))   BEGIN
    UPDATE Users
    SET Email = p_newEmail
    WHERE ID = p_userID;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `CountReviewsByUser` (`p_userID` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE v_reviewCount INT;
    SELECT COUNT(*) INTO v_reviewCount
    FROM Reviews
    WHERE UserID = p_userID;
    RETURN v_reviewCount;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetAverageRating` (`p_restaurantID` INT) RETURNS FLOAT DETERMINISTIC BEGIN
    DECLARE v_avgRating FLOAT;
    SELECT AVG(Rating) INTO v_avgRating
    FROM Reviews
    WHERE RestaurantID = p_restaurantID;
    RETURN v_avgRating;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetRestaurantNameByID` (`p_restaurantID` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE v_name VARCHAR(100);
    SELECT Name INTO v_name
    FROM Restaurants
    WHERE ID = p_restaurantID;
    RETURN v_name;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetUserEmailByUsername` (`p_username` VARCHAR(50)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE v_email VARCHAR(100);
    SELECT Email INTO v_email
    FROM Users
    WHERE Username = p_username;
    RETURN v_email;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cuisines`
--

CREATE TABLE `cuisines` (
  `ID` int(11) NOT NULL,
  `CuisineName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cuisines`
--

INSERT INTO `cuisines` (`ID`, `CuisineName`) VALUES
(1, 'Italian'),
(2, 'Chinese'),
(3, 'Indian'),
(4, 'Mexican'),
(5, 'Japanese'),
(6, 'American'),
(7, 'Thai'),
(8, 'Greek'),
(9, 'French'),
(10, 'Spanish');

--
-- Triggers `cuisines`
--
DELIMITER $$
CREATE TRIGGER `LogCuisineUpdate` AFTER UPDATE ON `cuisines` FOR EACH ROW BEGIN
    INSERT INTO cuisine_updates (cuisine_id, old_name, new_name, updated_at)
    VALUES (OLD.ID, OLD.CuisineName, NEW.CuisineName, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cuisine_updates`
--

CREATE TABLE `cuisine_updates` (
  `id` int(11) NOT NULL,
  `cuisine_id` int(11) DEFAULT NULL,
  `old_name` varchar(50) DEFAULT NULL,
  `new_name` varchar(50) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `ID` int(11) NOT NULL,
  `LocationName` varchar(100) NOT NULL,
  `Latitude` decimal(10,8) NOT NULL,
  `Longitude` decimal(11,8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`ID`, `LocationName`, `Latitude`, `Longitude`) VALUES
(1, 'New York', 40.71277600, -74.00597400),
(2, 'Los Angeles', 34.05223500, -118.24368300),
(3, 'Chicago', 41.87811300, -87.62979900),
(4, 'Houston', 29.76042700, -95.36980400),
(5, 'Denver', 39.73923600, -104.99025100),
(6, 'Phoenix', 33.44837600, -112.07403600),
(7, 'San Diego', 32.71573600, -117.16108700),
(8, 'San Antonio', 29.42434900, -98.49114200),
(9, 'Philadelphia', 39.95258300, -75.16522200),
(10, 'San Francisco', 37.77492900, -122.41941800);

-- --------------------------------------------------------

--
-- Table structure for table `restaurants`
--

CREATE TABLE `restaurants` (
  `ID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Address` varchar(255) NOT NULL,
  `LocationID` int(11) DEFAULT NULL,
  `CuisineID` int(11) DEFAULT NULL,
  `Rating` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restaurants`
--

INSERT INTO `restaurants` (`ID`, `Name`, `Address`, `LocationID`, `CuisineID`, `Rating`) VALUES
(1, 'Luigi s Italian Bistro', '123 Main St', 1, 1, 4.5),
(2, 'Dragon Palace', '456 Elm St', 2, 2, 4),
(3, 'Taj Mahal', '789 Oak St', 3, 3, 3.5),
(4, 'El Sombrero', '101 Pine St', 4, 4, 4.2),
(5, 'Sakura Sushi', '202 Maple St', 5, 5, 4.8),
(6, 'Burger Haven', '303 Birch St', 6, 6, 3.9),
(7, 'Thai Spice', '404 Cedar St', 7, 7, 4.7),
(8, 'Olympus Taverna', '505 Spruce St', 8, 8, 3.6),
(9, 'Café de Paris', '606 Fir St', 9, 9, 4.3),
(10, 'Tapas Delight', '707 Ash St', 10, 10, 4.9);

--
-- Triggers `restaurants`
--
DELIMITER $$
CREATE TRIGGER `LogRestaurantInsert` AFTER INSERT ON `restaurants` FOR EACH ROW BEGIN
    INSERT INTO restaurant_inserts (restaurant_id, inserted_at)
    VALUES (NEW.ID, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `restaurant_inserts`
--

CREATE TABLE `restaurant_inserts` (
  `id` int(11) NOT NULL,
  `restaurant_id` int(11) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `RestaurantID` int(11) DEFAULT NULL,
  `Rating` int(11) NOT NULL,
  `Comment` text DEFAULT NULL,
  `ReviewDate` datetime DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`ID`, `UserID`, `RestaurantID`, `Rating`, `Comment`, `ReviewDate`) VALUES
(1, 1, 1, 5, 'Authentic and delicious Italian cuisine!', '2025-02-09 14:35:18'),
(2, 2, 2, 4, 'Great Chinese food, very flavorful.', '2025-02-09 14:35:18'),
(3, 3, 3, 3, 'Indian food was okay, not very spicy.', '2025-02-09 14:35:18'),
(4, 4, 4, 5, 'Loved the Mexican dishes, very tasty!', '2025-02-09 14:35:18'),
(5, 5, 5, 4, 'Fresh and delicious Japanese sushi.', '2025-02-09 14:35:18'),
(6, 6, 6, 3, 'Typical American food, nothing special.', '2025-02-09 14:35:18'),
(7, 7, 7, 4, 'Nice and spicy Thai food.', '2025-02-09 14:35:18'),
(8, 8, 8, 5, 'Amazing Greek food, loved the gyros!', '2025-02-09 14:35:18'),
(9, 9, 9, 4, 'Elegant French cuisine, very good.', '2025-02-09 14:35:18'),
(10, 10, 10, 5, 'Fantastic Spanish tapas, highly recommend!', '2025-02-09 14:35:18');

--
-- Triggers `reviews`
--
DELIMITER $$
CREATE TRIGGER `LogReviewInsert` AFTER INSERT ON `reviews` FOR EACH ROW BEGIN
    INSERT INTO review_inserts (review_id, inserted_at)
    VALUES (NEW.ID, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `review_inserts`
--

CREATE TABLE `review_inserts` (
  `id` int(11) NOT NULL,
  `review_id` int(11) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `ID` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `RegistrationDate` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`ID`, `Username`, `Email`, `Password`, `RegistrationDate`) VALUES
(1, 'Muhammad', 'Muhammad123@gmail.com', 'muhammad095', '2025-02-09 14:34:21'),
(2, 'Husnain', 'Husnain5667@gmail.com', 'husnain1122', '2025-02-09 14:34:21'),
(3, 'Ahsan', 'Ahsan768@gmail.com', 'Ahsan66', '2025-02-09 14:34:21'),
(4, 'Salaar', 'Salaar456@gmail.com', 'salaar023', '2025-02-09 14:34:21'),
(5, 'Saad', 'Saadhassan2233@gmail.com', 'Saad0654', '2025-02-09 14:34:21'),
(6, 'Hassaan', 'Hassaan99@gmail.com', 'Hassan654', '2025-02-09 14:34:21'),
(7, 'Inayah', 'Inayah56@gmail.com', 'inayah4433', '2025-02-09 14:34:21'),
(8, 'Muniba', 'Muniba786@gmail.com', 'Muniba786', '2025-02-09 14:34:21'),
(9, 'Tayyab', 'Tayyab454@gmail.com', 'Tayyab321', '2025-02-09 14:34:21'),
(10, 'Ahmad', 'Ahmad99@gmail.com', 'Ahmad9955', '2025-02-09 14:34:21'),
(11, 'newuser', 'newuser@example.com', 'newpassword', '2025-02-09 14:37:35');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `LogUserDeletion` AFTER DELETE ON `users` FOR EACH ROW BEGIN
    INSERT INTO user_deletions (user_id, deleted_at)
    VALUES (OLD.ID, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_deletions`
--

CREATE TABLE `user_deletions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cuisines`
--
ALTER TABLE `cuisines`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `cuisine_updates`
--
ALTER TABLE `cuisine_updates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `restaurants`
--
ALTER TABLE `restaurants`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `LocationID` (`LocationID`),
  ADD KEY `CuisineID` (`CuisineID`);

--
-- Indexes for table `restaurant_inserts`
--
ALTER TABLE `restaurant_inserts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `RestaurantID` (`RestaurantID`);

--
-- Indexes for table `review_inserts`
--
ALTER TABLE `review_inserts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `user_deletions`
--
ALTER TABLE `user_deletions`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cuisines`
--
ALTER TABLE `cuisines`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `cuisine_updates`
--
ALTER TABLE `cuisine_updates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `restaurants`
--
ALTER TABLE `restaurants`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `restaurant_inserts`
--
ALTER TABLE `restaurant_inserts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `review_inserts`
--
ALTER TABLE `review_inserts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `user_deletions`
--
ALTER TABLE `user_deletions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `restaurants`
--
ALTER TABLE `restaurants`
  ADD CONSTRAINT `restaurants_ibfk_1` FOREIGN KEY (`LocationID`) REFERENCES `locations` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `restaurants_ibfk_2` FOREIGN KEY (`CuisineID`) REFERENCES `cuisines` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurants` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
