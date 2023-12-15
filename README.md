[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/X04JntxH)
Написать запрос, который сгенерирует псевдослучайные данные. Поля:
id integer         - порядковый номер строки
first_name text    - сгенерированный текст
last_name text     - сгенерированный текст 
birth_date date    - сгенерированная дата в диапазоне от начала текущего года до текущего дня
weight float       - рандом в диапазоне от 0.4 до 12
all_in_month float - сумма всех "weight" за месяц поле "birth_date"
hash uuid          - хэш строки

Результат отсортирован в обратном порядке по "first_name" и "last_name", содержит 500 строк.