/******************************************************************************
*******************************************************************************

WeCloudData - Data Engineer Program

SQL CTE Statement Exercise

*******************************************************************************
******************************************************************************/


/****************************************
  Please download the superhero data file from [HERE]() and load into your database accordingly for this exercise. 
  List of nine tables in `superhero` database:
    --  alignment, attribute, colour, gender, publisher, race, superhero_info, superpower, hero_power
****************************************/

-- Questions:
  -- 1. Find the superheros whose heights are above 200 cm, and column `full_name` is not null or in '_' by using a CTE statement in table `superhero_info`:
  -- HINT: replace values in `_` to `NULL` in the column `full_name`

    USE superhero;  

    WITH superheros_over_200 AS (
        SELECT superhero_name, 
                full_name,
                CASE 
                    WHEN full_name = '-' THEN NULL 
                    ELSE full_name 
                END AS full_name_cleaned
        FROM superhero_info
        WHERE height_cm >200 
    )
    SELECT 
        superhero_name
    FROM
        superheros_over_200
    WHERE
        full_name_cleaned IS NOT NULL
   ;


  -- 2. We will use tables `superhero_info`, `gender`, `publisher`, and `alignment`.
      -- Use a CTE to retrieve the top 10 tallest male superheros who have good alighment from `DC Comics` and `Marvel Comics`:
    
    WITH tallest_male_superhero AS (
        SELECT  s.superhero_name,
                s.height_cm,
                s.alignment_id
        FROM superhero_info AS s
        INNER JOIN gender AS g
                ON s.gender_id =g.id
        INNER JOIN publisher AS p
                ON p.id = s.publisher_id
        WHERE g.gender = 'Male'
            AND p.publisher_name IN ('DC Comics', 'Marvel Comics') 
    ) 

        SELECT superhero_name
        FROM tallest_male_superhero t
        INNER JOIN alignment AS a
                ON t.alignment_id =a.id
        WHERE a.alignment = 'Good'
        ORDER BY s.height_cm DESC    
        LIMIT 10
    ;


  -- 3. We will use tables  `superhero_info`, `hero_power`, `superpower`, `gender`, and `publisher`.
    -- Use multiple CTEs to display the top(1) count of DC & Marvel superheros in both genders 
    -- with their superpower names, and the avgerage height & weight per group.
    -- You may need to use a window function
    -- HINT: filter out gender is N/A, and replace values in `_` to `NULL` in the column `full_name` 
    -- (you can refer to the first question)

   -- Superpower names by gender of the DC & Marvel superheros, filter out gender is N/A 
    WITH superpower_heros AS ( 
        SELECT s.id AS superhero_id, 
                sp.power_name,
                g.gender
            FROM superhero_info AS s
            INNER JOIN hero_power AS hp
                    ON s.id = hp.hero_id
            INNER JOIN superpower AS sp
                    ON hp.power_id = sp.id
            INNER JOIN publisher AS p
                    ON p.id =s.publisher_id
            INNER JOIN gender AS g
                ON s.gender_id =g.id
            WHERE p.publisher_name IN ('DC Comics', 'Marvel Comics') 
                AND g.gender != 'N/A'
    ),
    -- Superheros whose full_names are not NULL or '-', and height & weight > 0 
    clean_superhero_info AS (
        SELECT superhero_id,
                height_cm,
                weight_kg
        FROM (
            SELECT s.id AS superhero_id,
                    height_cm,
                    weight_kg,
                    CASE 
                        WHEN full_name = '-' THEN NULL 
                        ELSE full_name 
                    END AS full_name_cleaned
            FROM superhero_info s
            WHERE height_cm > 0
            AND weight_kg > 0
        ) sub
            WHERE full_name_cleaned IS NOT NULL
    ),
    -- Join the two tables above together, and get the avg height & weight by gender and superpower
    cal_avg AS (
        SELECT sh.gender,
                sh.power_name,
                COUNT(DISTINCT csi.superhero_id) AS superhero_cnt,
                ROUND(AVG(csi.height_cm),2) AS avg_height,
                ROUND(AVG(csi.weight_kg),2) AS avg_weight
        FROM superpower_heros sh
        INNER JOIN clean_superhero_info csi
            ON sh.superhero_id = csi.superhero_id
        GROUP BY sh.gender, sh.power_name
    ),
    -- Rank the superheros by descending order per gender
    ranking_by_cnt AS (
        SELECT gender,
                power_name,
                avg_height,
                avg_weight,
                superhero_cnt,
                RANK() OVER (PARTITION BY gender
                        ORDER BY superhero_cnt DESC) AS rank_superhero_cnt
        FROM cal_avg
    )
    -- Display the most numbers of superheros superpower name and its avgerage height & weight per gender per superpower
    SELECT gender,
                power_name,
                avg_height,
                avg_weight,
                superhero_cnt
    FROM ranking_by_cnt
    WHERE rank_superhero_cnt = 1
    ORDER BY gender

