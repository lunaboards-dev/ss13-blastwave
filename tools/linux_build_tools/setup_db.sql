CREATE DATABASE IF NOT EXISTS feedback CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'spess'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON feedback.* TO 'spess'@'localhost';
FLUSH PRIVILEGES;
