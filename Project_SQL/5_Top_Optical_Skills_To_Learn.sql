/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/

WITH skills_demand_per_job_count AS
(
    SELECT
        skills.skill_id,
        skills.skills AS skill_name,
        skills.type AS skill_type,
        COUNT(job_postings.job_id) AS job_count
    FROM
        job_postings_fact AS job_postings 
    INNER JOIN skills_job_dim AS bridge
        ON job_postings.job_id = bridge.job_id
    INNER JOIN skills_dim AS skills
        ON bridge.skill_id = skills.skill_id    
    WHERE
        -- filtering for any roles with 'Data Analyst' in the title
        job_postings.job_title ILIKE '%Data Analyst%'
        AND
        -- filtering for remote jobs
        job_postings.job_work_from_home = TRUE
        AND
        -- filtering for job postings with yearly salaries mentioned
        job_postings.salary_year_avg IS NOT NULL 
    GROUP BY    
    skills.skill_id
),
top_paying_skills AS
(
    SELECT
        skills.skill_id,
        ROUND(AVG(salary_year_avg),2) AS yearly_avg_salary
    FROM
        job_postings_fact AS job_postings
    INNER JOIN skills_job_dim AS bridge
        ON job_postings.job_id = bridge.job_id
    INNER JOIN skills_dim AS skills
        ON bridge.skill_id = skills.skill_id
        WHERE
        -- filtering for any roles with 'Data Analyst' in the title
        job_postings.job_title ILIKE '%Data Analyst%'
        AND
        -- filtering for remote jobs
        job_postings.job_work_from_home = TRUE
        AND
        -- filtering for job postings with yearly salaries mentioned
        job_postings.salary_year_avg IS NOT NULL 
    GROUP BY
        skills.skill_id
)

SELECT
    -- skills_demand_per_job_count.skill_id,
    skills_demand_per_job_count.skill_name,
    job_count,
    yearly_avg_salary
FROM
    skills_demand_per_job_count
INNER JOIN top_paying_skills
    ON skills_demand_per_job_count.skill_id = top_paying_skills.skill_id
ORDER BY
    job_count DESC,
    yearly_avg_salary DESC
LIMIT 25 ;        
