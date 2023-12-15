WITH random_data AS (
    SELECT
        ROW_NUMBER() OVER () AS id,
        CASE WHEN gender = 'female' THEN first_name_female ELSE first_name_male END AS first_name,
        last_name_part1 || ' ' || last_name_part2 AS last_name,
        DATE_TRUNC('day', CURRENT_DATE - INTERVAL '1 year' * RANDOM()) AS birth_date,
        CAST(CAST(RANDOM() * (12 - 0.4) + 0.4 AS NUMERIC(10, 2)) AS DECIMAL(10, 2)) AS weight
    FROM
        (
            SELECT
                generator AS id,
                CASE WHEN RANDOM() > 0.5 THEN 'female' ELSE 'male' END AS gender,
                (
                    SELECT
                        CONCAT('Мария-', STRING_AGG(x, '-')) AS first_name_female
                    FROM (
                        SELECT
                            start_arr[1 + ( (RANDOM() * 100)::INT) % 32]
                        FROM
                            (
                                SELECT
                                    '{Анна,Мария,Екатерина,Ольга,Ирина,Татьяна,Наталья,Светлана,Елена,Виктория,Александра,Анastасия,Александра,София,Валерия,Вероника,Полина,Алиса,Маргарита,Варвара,Дарья,Кристина,Юлия,Евгения,Марина,Ева,Зоя,Ангелина,Людмила,Регина,Лариса,Любовь,Галина}'::TEXT[] AS start_arr
                            ) syllarr,
                            GENERATE_SERIES(1, 1 + ( ( (generator::INT % 3) * (RANDOM() * 0.5))::INT % 3))
                    ) AS con_name_female(x)
                ),
                (
                    SELECT
                        CONCAT('Иван-', STRING_AGG(y, '-')) AS first_name_male
                    FROM (
                        SELECT
                            start_arr[1 + ( (RANDOM() * 100)::INT) % 33]
                        FROM
                            (
                                SELECT
                                    '{Александр,Максим,Даниил,Артём,Илья,Михаил,Сергей,Дмитрий,Никита,Кирилл,Андрей,Егор,Владимир,Павел,Владислав,Григорий,Роман,Станислав,Евгений,Фёдор,Антон,Борис,Иван,Тимофей,Арсений,Артемий,Денис,Константин,Николай,Тимур,Валентин,Валерий}'::TEXT[] AS start_arr
                            ) syllarr,
                            GENERATE_SERIES(1, 1 + ( ( (generator::INT % 3) * (RANDOM() * 0.5))::INT % 3))
                    ) AS con_name_male(y)
                ),
                (
                    SELECT
                        CONCAT(last_name_part1a, last_char) AS last_name_part1
                    FROM (
                        SELECT
                            INITCAP(CONCAT(STRING_AGG(z1, ''))) AS last_name_part1a
                        FROM (
                            SELECT
                                last_arr[1 + ( (RANDOM() * 100 + (generator * 0))::INT) % 35]
                            FROM
                                (
                                    SELECT
                                        '{Иванов,Петров,Смирнов,Соколов,Михайлов,Новиков,Федоров,Морозов,Волков,Алексеев,Лебедев,Семенов,Егоров,Павлов,Козлов,Степанов,Николаев,Орлов,Зайцев,Соловьев,Борисов,Ковалев,Григорьев,Титов,Фролов,Александров,Дмитриев,Королев,Гусев,Кузнецов,Кудрявцев,Беляев,Кирсанов,Малахов}'::TEXT[] AS last_arr
                                ) sub1,
                                GENERATE_SERIES(1, 3 + (generator * 0))
                        ) AS con_name_first(z1)
                    ) sub2,
                    (
                        SELECT
                            last_last[1 + ( (RANDOM() * 10 + (generator * 0))::INT) % 5] AS last_char
                        FROM (
                            SELECT
                                '{ев,ов,енко,их,ский}'::TEXT[] AS last_last
                        ) sub3
                    ) sub4
                ),
                (
                    SELECT
                        part_arr[1 + ( (RANDOM() * 100 + (generator * 0))::INT) % 26] AS last_name_part2
                    FROM
                        (
                            SELECT
                                '{II,III,Де Луанлуан,Де Мёмё,Де Парлуан,Де Парлà,Де Монлуан,Де Валлуантэн,Де Перпетэ,Де Петушнок,Де Трифуи-ле-Уа,Де Клошмерл,Дю Трупомэ,Де Сен-глин-глин,Де Бэрдуй,Де Макапэт,Де Фуфни,Де Пампаригуст,Де Глинглин,Де Линлин,Де Фуфияр,Д''Апрэ,Д''Исиба,Д''Отэ,Д''Олуан}'::TEXT[] AS part_arr
                        ) sub
                )
            FROM
                GENERATE_SERIES(1, 1000) AS generator
        ) AS main_sub
)
SELECT
    id,
    first_name,
    last_name,
    birth_date,
    weight,
    SUM(weight) OVER (PARTITION BY EXTRACT(YEAR FROM birth_date), EXTRACT(MONTH FROM birth_date)) AS all_in_month,
    MD5(CAST(id AS TEXT)) AS hash
FROM
    random_data
ORDER BY
    first_name DESC,
    last_name DESC
LIMIT 500;
