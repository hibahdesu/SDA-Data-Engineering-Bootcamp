/**
1. Find the superheros who are above 200 cm height, and column:full_name 
is not null or in _ by using a CTE statement in tablesuperhero_info:
-- - HINT: replace values in _ to NULL in the column full_name first
**/

USE superhero;  

select * from superhero_info;

with superheros_high as 
	(select full_name, superhero_name,
	case
		when full_name = '-' then null
		else full_name
	end as full_name_clean
	from superhero_info
	where height_cm > 200
    )
    select superhero_name 
    from superheros_high
    where full_name_clean is not null
 ;
 
 
 /**
 2. We will use tables superhero_info, gender, publisher, and alignment.
	- Use a CTE to retrieve the top 10 tallest male superheros 
    who have good alighment from DC Comics and Marvel Comics:
 **/
 
select * from superhero_info;
select * from gender;
select * from publisher;
select * from alignment;


with tallest_superhero as 
	(select info.superhero_name, info.height_cm, info.alignment_id 
	from superhero_info as info
	inner join gender as g
	on info.gender_id = g.id
	inner join publisher as p
	on info.publisher_id = p.id
	where g.gender = 'Male'
	and p.publisher_name in ('DC Comics', 'Marvel Comics')
    ) 
    
    select superhero_name from tallest_superhero as t
    inner join alignment as a
	on t.alignment_id = a.id
    where a.alignment = 'Good'
    and height_cm > 200
    limit 10
    ;

/**
3. We will use tables superhero_info, hero_power, superpower, gender, and publisher.
- Use multiple CTEs to display the top(1) count of 
	DC & Marvel superheros in both genders with their superpower names, 
    and the avgerage height & weight per group.
- You may need to use a window function
- HINT: filter out gender is N/A, and replace 
	values in _ to NULL in the column full_name (you can refer to the first question)
**/


select * from superhero_info;

select * from hero_power;

select * from superpower;

select * from gender;

select * from publisher;






    
with superpower_heros as 
	(select s.id as superhero_id, sp.power_name, g.gender  
	from superhero_info as s
	inner join hero_power as hp
		on s.id = hp.hero_id
	inner join superpower as sp
		on hp.power_id = sp.id
	inner join publisher as p
		on s.publisher_id = p.id
	inner join gender as g
		on s.gender_id = g.id
	where p.publisher_name in ('DC Comics', 'Marvel Comics')
		and g.gender != 'N/A'),
	clean_superhero_info as (
		select superhero_id, height_cm, weight_kg
        from (
			select s.id as superhero_id, height_cm, weight_kg,
            case 
				when full_name = '-' then NULL
                else full_name
			end as full_name_cleaned
		from superhero_info as s
        where height_cm > 0
        and weight_kg > 0
        ) sub
        where full_name_cleaned is not null
    ),
    cal_avg as (
		select sh.gender, sh.power_name,
			count(distinct csi.superhero_id) as superhero_cnt,
            round(avg(csi.height_cm), 2) as avg_height,
            round(avg(csi.weight_kg), 2) as avg_weight
			
		from superpower_heros sh
        inner join clean_superhero_info as csi
			on sh.superhero_id = csi.superhero_id
		group by sh.gender, sh.power_name
    ),
    ranking_by_cnt as (
		select gender, power_name, avg_height, avg_weight, superhero_cnt,
			rank() over(partition by gender order by superhero_cnt desc) as rank_superhero_cnt
		from cal_avg
    )
    select gender, power_name, avg_height, avg_weight, superhero_cnt
    from ranking_by_cnt
    where rank_superhero_cnt = 1
    order by gender
;
