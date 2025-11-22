/* 

Question: 
    What are the top paying jobs for Data-Analyst Role?
        - Identify the top 10 highest paying data analyst jobs along with their company name that are available remotely.
        - Focus on jobs that actually have salaries posted (No NULL values)
        - Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility

*/

SELECT
    job_id,
    job_title_short AS job_role,
    companies.name AS company_name,
    job_location AS location,
    job_schedule_type As job_type,
    job_posted_date::DATE AS posted_date,
    salary_year_avg AS yearly_avg_salary
FROM
    job_postings_fact AS job_postings
LEFT JOIN company_dim AS companies
    ON job_postings.company_id = companies.company_id    
WHERE
    -- filtering for any roles with 'Data Analyst' in the title
    job_postings.job_title ILIKE '%Data Analyst%'
    AND
    -- filtering for remote jobs
    job_postings.job_work_from_home = TRUE
    AND
    -- filtering for job postings with yearly salaries mentioned
    job_postings.salary_year_avg IS NOT NULL 
ORDER BY
    yearly_avg_salary DESC
LIMIT 20 ;    

