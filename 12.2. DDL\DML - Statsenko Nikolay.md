# Домашнее задание к занятию «Работа с данными (DDL/DML)» - `Statsenko Nikolay`

### Задание 1

1.1. Поднимите чистый инстанс MySQL версии 8.0+.

![Task1_1](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/12.2/ddl_task1_1.png)

1.2. Создайте учётную запись sys_temp.
```
CREATE USER 'sys_temp'@'localhost' IDENTIFIED BY 'password';
```
1.3. Выполните запрос на получение списка пользователей в базе данных.

```
SELECT User, Host FROM mysql.user;
```

![Task1_2](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/12.2/ddl_task1_2.png)

1.4. Дайте все права для пользователя sys_temp.
```
GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'localhost';
```

1.5. Выполните запрос на получение списка прав для пользователя sys_temp. 
```
SHOW GRANTS FOR 'sys_temp'@'localhost';
```
![Task1_3](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/12.2/ddl_task1_3.png)

1.6.1 Переподключитесь к базе данных от имени sys_temp.
```
sudo mysql -u sys_temp -p
```
1.6.2 Cкачайте дамп базы данных.
```
wget https://downloads.mysql.com/docs/sakila-db.zip
sudo unzip sakila-db.zip
```
1.7. Восстановите дамп в базу данных.
```
sudo mysql -u sys_temp -p sakila < ~/sakila-db/sakila-schema.sql
sudo mysql -u sys_temp -p sakila < ~/sakila-db/sakila-data.sql
```

1.8. При работе в IDE сформируйте ER-диаграмму получившейся базы данных.

![Task1_4](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/12.2/ddl_task1_4.png)

### Задание 2

![Task2](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/12.2/ddl_task2.png)

### Задание 3
