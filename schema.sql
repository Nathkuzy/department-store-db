-- Створення бази даних інформаційної системи універмагу
CREATE DATABASE DepartmentStoreDB;
USE DepartmentStoreDB;

-- Категорії товарів
CREATE TABLE Kategoriyi_Tovariv (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    nazva_kategoriyi VARCHAR(100) NOT NULL
);

-- Постачальники
CREATE TABLE Postachalnyky (
    postachalnyk_id INT PRIMARY KEY AUTO_INCREMENT,
    kompaniya VARCHAR(150) NOT NULL,
    kontaktna_osoba VARCHAR(100),
    telefon VARCHAR(20)
);

-- Товари
CREATE TABLE Tovary (
    tovary_id INT PRIMARY KEY AUTO_INCREMENT,
    artykul VARCHAR(50) UNIQUE NOT NULL,
    nazva_tovaru VARCHAR(150) NOT NULL,
    category_id INT,
    postachalnyk_id INT,
    tsina DECIMAL(10, 2) NOT NULL,
    kilkist_na_skladi INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Kategoriyi_Tovariv(category_id),
    FOREIGN KEY (postachalnyk_id) REFERENCES Postachalnyky(postachalnyk_id)
);

-- Клієнти
CREATE TABLE Kliienty (
    kliient_id INT PRIMARY KEY AUTO_INCREMENT,
    pryzvyshche VARCHAR(50) NOT NULL,
    imya VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    data_reestratsiyi DATE NOT NULL
);

-- Чеки / Продажі
CREATE TABLE Prodazhi (
    prodazh_id INT PRIMARY KEY AUTO_INCREMENT,
    kliient_id INT,
    data_chas DATETIME NOT NULL,
    zagalna_suma DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (kliient_id) REFERENCES Kliienty(kliient_id)
);

-- Деталі продажу (позиції в чеку)
CREATE TABLE Detali_Prodazhu (
    detal_id INT PRIMARY KEY AUTO_INCREMENT,
    prodazh_id INT,
    tovary_id INT,
    kilkist INT NOT NULL,
    tsina_prodazhu DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (prodazh_id) REFERENCES Prodazhi(prodazh_id),
    FOREIGN KEY (tovary_id) REFERENCES Tovary(tovary_id)
);

-- --- ТЕСТОВІ ДАНІ ---

INSERT INTO Kategoriyi_Tovariv (nazva_kategoriyi) VALUES 
('Одяг та взуття'), ('Побутова техніка'), ('Дім і затишок');

INSERT INTO Postachalnyky (kompaniya, kontaktna_osoba, telefon) VALUES 
('ТОВ "ТехноПром"', 'Іван Павленко', '+380501112233'),
('ФОП "Мода Стріт"', 'Олена Коваль', '+380674445566');

INSERT INTO Tovary (artykul, nazva_tovaru, category_id, postachalnyk_id, tsina, kilkist_na_skladi) VALUES 
('CL-001', 'Куртка зимова', 1, 2, 2500.00, 25),
('TECH-10', 'Блендер кухонний', 2, 1, 1800.00, 12),
('HM-55', 'Набір рушників', 3, 2, 650.00, 40);

INSERT INTO Kliienty (pryzvyshche, imya, email, data_reestratsiyi) VALUES 
('Шевченко', 'Андрій', 'shev@gmail.com', '2026-02-10'),
('Мельник', 'Тетяна', 'melnyk@ukr.net', '2026-03-01');

INSERT INTO Prodazhi (kliient_id, data_chas, zagalna_suma) VALUES 
(1, '2026-03-10 14:15:00', 3150.00),
(2, '2026-03-11 11:30:00', 1800.00);

INSERT INTO Detali_Prodazhu (prodazh_id, tovary_id, kilkist, tsina_prodazhu) VALUES 
(1, 1, 1, 2500.00),
(1, 3, 1, 650.00),
(2, 2, 1, 1800.00);


-- --- АНАЛІТИЧНІ ЗАПИТИ ---

-- Вибірка товарів з критичним залишком
SELECT nazva_tovaru, kilkist_na_skladi, tsina 
FROM Tovary 
WHERE kilkist_na_skladi < 15;

-- Загальна сума покупок кожного клієнта
SELECT k.pryzvyshche, k.imya, SUM(p.zagalna_suma) AS suma_vitrat
FROM Kliienty k
JOIN Prodazhi p ON k.kliient_id = p.kliient_id
GROUP BY k.kliient_id, k.pryzvyshche, k.imya;
