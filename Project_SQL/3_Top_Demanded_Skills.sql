/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/

SELECT
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
    -- job_postings.job_work_from_home = TRUE
    AND
    -- filtering for job postings with yearly salaries mentioned
    -- job_postings.salary_year_avg IS NOT NULL 
GROUP BY    
    skill_name, skill_type           
ORDER BY 
    job_count DESC 
LIMIT 10 ;
 