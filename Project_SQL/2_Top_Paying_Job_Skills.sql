/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (

    -- If you need to use ORDER BY and LIMIT inside a CTE, wrap it inside a subquery so that it is materialized and becomes reliable across databases
    SELECT *
    FROM
    (
        SELECT
            -- gettings job IDs, titles, schedule types, posted dates,  yearly salary and company names
            job_id,
            job_title_short AS job_role,
            companies.name AS company_name,    
            job_schedule_type AS job_type,
            job_posted_date:: DATE AS posted_date,
            salary_year_avg AS yearly_avg_salary
        FROM
            job_postings_fact AS job_postings
            -- getting company details from company_dim table
        LEFT JOIN 
            company_dim AS companies
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
        ORDER BY yearly_avg_salary DESC
        LIMIT 20                    
    )
)

SELECT
    -- selecting every column from top_paying_jobs
    top_paying_jobs.*,
    -- selecting respective skill names and types for those jobs
    skills.skills AS skill_name,
    skills.type AS skill_type
FROM
    top_paying_jobs
    -- getting skill names and types from skills_dim table
INNER JOIN skills_job_dim AS bridge
    ON top_paying_jobs.job_id = bridge.job_id
INNER JOIN skills_dim AS skills
    ON bridge.skill_id = skills.skill_id 
ORDER BY
    top_paying_jobs.yearly_avg_salary DESC ;                        


/*
Insights of result's table based on CHATGPT:

-- Skill Insights Summary
    1. Most In-Demand Skills (by frequency)
        Rank	Skill	     Frequency
        1️⃣	     SQL	      17
        2️⃣	     Python	    15
        3️⃣	     Tableau	  13
        4️⃣	     R	         9
        5️⃣	     Excel	     5

-- What This Means

    - SQL is the #1 foundational requirement. Nearly every top-paying job requires it.
    - Python is almost equally crucial, especially for automation and statistical modeling.
    - Tableau leads in visualization tools, beating Power BI in this dataset.
    - R is still relevant, especially in more research-heavy or statistical roles.
    - Excel appears less in top-tier listings, showing a shift toward more advanced tools.

-- Key Takeaways

    ✅ Programming dominates
    - The majority of high-paying roles require programming skills (SQL, Python, R).
    Top employers want analysts who can automate workflows, query large datasets, and build models.

    ✅ Analyst tools are the second priority
    - Tools like Tableau, Power BI, Excel continue to be essential for storytelling and dashboarding.

    ✅ Cloud is now a major requirement
    - Cloud skills (AWS, GCP, Azure) appearing 18 times shows companies are shifting analytics workloads to the cloud.

-- Result table as json:

    [
  {
    "job_id": 99305,
    "job_role": "Data Analyst",
    "company_name": "Pinterest Job Advertisements",
    "job_type": "Full-time",
    "posted_date": "2023-12-05",
    "yearly_avg_salary": "232423.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 99305,
    "job_role": "Data Analyst",
    "company_name": "Pinterest Job Advertisements",
    "job_type": "Full-time",
    "posted_date": "2023-12-05",
    "yearly_avg_salary": "232423.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 99305,
    "job_role": "Data Analyst",
    "company_name": "Pinterest Job Advertisements",
    "job_type": "Full-time",
    "posted_date": "2023-12-05",
    "yearly_avg_salary": "232423.0",
    "skill_name": "r",
    "skill_type": "programming"
  },
  {
    "job_id": 99305,
    "job_role": "Data Analyst",
    "company_name": "Pinterest Job Advertisements",
    "job_type": "Full-time",
    "posted_date": "2023-12-05",
    "yearly_avg_salary": "232423.0",
    "skill_name": "hadoop",
    "skill_type": "libraries"
  },
  {
    "job_id": 99305,
    "job_role": "Data Analyst",
    "company_name": "Pinterest Job Advertisements",
    "job_type": "Full-time",
    "posted_date": "2023-12-05",
    "yearly_avg_salary": "232423.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1021647,
    "job_role": "Data Analyst",
    "company_name": "Uclahealthcareers",
    "job_type": "Full-time",
    "posted_date": "2023-01-17",
    "yearly_avg_salary": "217000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 1021647,
    "job_role": "Data Analyst",
    "company_name": "Uclahealthcareers",
    "job_type": "Full-time",
    "posted_date": "2023-01-17",
    "yearly_avg_salary": "217000.0",
    "skill_name": "crystal",
    "skill_type": "programming"
  },
  {
    "job_id": 1021647,
    "job_role": "Data Analyst",
    "company_name": "Uclahealthcareers",
    "job_type": "Full-time",
    "posted_date": "2023-01-17",
    "yearly_avg_salary": "217000.0",
    "skill_name": "oracle",
    "skill_type": "cloud"
  },
  {
    "job_id": 1021647,
    "job_role": "Data Analyst",
    "company_name": "Uclahealthcareers",
    "job_type": "Full-time",
    "posted_date": "2023-01-17",
    "yearly_avg_salary": "217000.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1021647,
    "job_role": "Data Analyst",
    "company_name": "Uclahealthcareers",
    "job_type": "Full-time",
    "posted_date": "2023-01-17",
    "yearly_avg_salary": "217000.0",
    "skill_name": "flow",
    "skill_type": "other"
  },
  {
    "job_id": 168310,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-08-09",
    "yearly_avg_salary": "205000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 168310,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-08-09",
    "yearly_avg_salary": "205000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 168310,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-08-09",
    "yearly_avg_salary": "205000.0",
    "skill_name": "go",
    "skill_type": "programming"
  },
  {
    "job_id": 168310,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-08-09",
    "yearly_avg_salary": "205000.0",
    "skill_name": "snowflake",
    "skill_type": "cloud"
  },
  {
    "job_id": 168310,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-08-09",
    "yearly_avg_salary": "205000.0",
    "skill_name": "pandas",
    "skill_type": "libraries"
  },
  {
    "job_id": 168310,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-08-09",
    "yearly_avg_salary": "205000.0",
    "skill_name": "numpy",
    "skill_type": "libraries"
  },
  {
    "job_id": 168310,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-08-09",
    "yearly_avg_salary": "205000.0",
    "skill_name": "excel",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 168310,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-08-09",
    "yearly_avg_salary": "205000.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 168310,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-08-09",
    "yearly_avg_salary": "205000.0",
    "skill_name": "gitlab",
    "skill_type": "other"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "azure",
    "skill_type": "cloud"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "aws",
    "skill_type": "cloud"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "oracle",
    "skill_type": "cloud"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "snowflake",
    "skill_type": "cloud"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "power bi",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "sap",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "jenkins",
    "skill_type": "other"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "bitbucket",
    "skill_type": "other"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "atlassian",
    "skill_type": "other"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "jira",
    "skill_type": "async"
  },
  {
    "job_id": 731368,
    "job_role": "Data Analyst",
    "company_name": "Inclusively",
    "job_type": "Full-time",
    "posted_date": "2023-12-07",
    "yearly_avg_salary": "189309.0",
    "skill_name": "confluence",
    "skill_type": "async"
  },
  {
    "job_id": 310660,
    "job_role": "Data Analyst",
    "company_name": "Motional",
    "job_type": "Full-time",
    "posted_date": "2023-01-05",
    "yearly_avg_salary": "189000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 310660,
    "job_role": "Data Analyst",
    "company_name": "Motional",
    "job_type": "Full-time",
    "posted_date": "2023-01-05",
    "yearly_avg_salary": "189000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 310660,
    "job_role": "Data Analyst",
    "company_name": "Motional",
    "job_type": "Full-time",
    "posted_date": "2023-01-05",
    "yearly_avg_salary": "189000.0",
    "skill_name": "r",
    "skill_type": "programming"
  },
  {
    "job_id": 310660,
    "job_role": "Data Analyst",
    "company_name": "Motional",
    "job_type": "Full-time",
    "posted_date": "2023-01-05",
    "yearly_avg_salary": "189000.0",
    "skill_name": "git",
    "skill_type": "other"
  },
  {
    "job_id": 310660,
    "job_role": "Data Analyst",
    "company_name": "Motional",
    "job_type": "Full-time",
    "posted_date": "2023-01-05",
    "yearly_avg_salary": "189000.0",
    "skill_name": "bitbucket",
    "skill_type": "other"
  },
  {
    "job_id": 310660,
    "job_role": "Data Analyst",
    "company_name": "Motional",
    "job_type": "Full-time",
    "posted_date": "2023-01-05",
    "yearly_avg_salary": "189000.0",
    "skill_name": "atlassian",
    "skill_type": "other"
  },
  {
    "job_id": 310660,
    "job_role": "Data Analyst",
    "company_name": "Motional",
    "job_type": "Full-time",
    "posted_date": "2023-01-05",
    "yearly_avg_salary": "189000.0",
    "skill_name": "jira",
    "skill_type": "async"
  },
  {
    "job_id": 310660,
    "job_role": "Data Analyst",
    "company_name": "Motional",
    "job_type": "Full-time",
    "posted_date": "2023-01-05",
    "yearly_avg_salary": "189000.0",
    "skill_name": "confluence",
    "skill_type": "async"
  },
  {
    "job_id": 1749593,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-07-11",
    "yearly_avg_salary": "186000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 1749593,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-07-11",
    "yearly_avg_salary": "186000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 1749593,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-07-11",
    "yearly_avg_salary": "186000.0",
    "skill_name": "go",
    "skill_type": "programming"
  },
  {
    "job_id": 1749593,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-07-11",
    "yearly_avg_salary": "186000.0",
    "skill_name": "snowflake",
    "skill_type": "cloud"
  },
  {
    "job_id": 1749593,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-07-11",
    "yearly_avg_salary": "186000.0",
    "skill_name": "pandas",
    "skill_type": "libraries"
  },
  {
    "job_id": 1749593,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-07-11",
    "yearly_avg_salary": "186000.0",
    "skill_name": "numpy",
    "skill_type": "libraries"
  },
  {
    "job_id": 1749593,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-07-11",
    "yearly_avg_salary": "186000.0",
    "skill_name": "excel",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1749593,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-07-11",
    "yearly_avg_salary": "186000.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1749593,
    "job_role": "Data Analyst",
    "company_name": "SmartAsset",
    "job_type": "Full-time",
    "posted_date": "2023-07-11",
    "yearly_avg_salary": "186000.0",
    "skill_name": "gitlab",
    "skill_type": "other"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "html",
    "skill_type": "programming"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "css",
    "skill_type": "programming"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "aws",
    "skill_type": "cloud"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "keras",
    "skill_type": "libraries"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "angular",
    "skill_type": "webframeworks"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "flask",
    "skill_type": "webframeworks"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "fastapi",
    "skill_type": "webframeworks"
  },
  {
    "job_id": 1638595,
    "job_role": "Senior Data Analyst",
    "company_name": "Patterned Learning AI",
    "job_type": "Full-time",
    "posted_date": "2023-08-15",
    "yearly_avg_salary": "185000.0",
    "skill_name": "windows",
    "skill_type": "os"
  },
  {
    "job_id": 387860,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-06-09",
    "yearly_avg_salary": "184000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 387860,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-06-09",
    "yearly_avg_salary": "184000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 387860,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-06-09",
    "yearly_avg_salary": "184000.0",
    "skill_name": "r",
    "skill_type": "programming"
  },
  {
    "job_id": 813346,
    "job_role": "Senior Data Analyst",
    "company_name": "Zoom Video Communications",
    "job_type": "Full-time",
    "posted_date": "2023-05-27",
    "yearly_avg_salary": "181000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 813346,
    "job_role": "Senior Data Analyst",
    "company_name": "Zoom Video Communications",
    "job_type": "Full-time",
    "posted_date": "2023-05-27",
    "yearly_avg_salary": "181000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 813346,
    "job_role": "Senior Data Analyst",
    "company_name": "Zoom Video Communications",
    "job_type": "Full-time",
    "posted_date": "2023-05-27",
    "yearly_avg_salary": "181000.0",
    "skill_name": "r",
    "skill_type": "programming"
  },
  {
    "job_id": 813346,
    "job_role": "Senior Data Analyst",
    "company_name": "Zoom Video Communications",
    "job_type": "Full-time",
    "posted_date": "2023-05-27",
    "yearly_avg_salary": "181000.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 813346,
    "job_role": "Senior Data Analyst",
    "company_name": "Zoom Video Communications",
    "job_type": "Full-time",
    "posted_date": "2023-05-27",
    "yearly_avg_salary": "181000.0",
    "skill_name": "jira",
    "skill_type": "async"
  },
  {
    "job_id": 813346,
    "job_role": "Senior Data Analyst",
    "company_name": "Zoom Video Communications",
    "job_type": "Full-time",
    "posted_date": "2023-05-27",
    "yearly_avg_salary": "181000.0",
    "skill_name": "zoom",
    "skill_type": "sync"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "scala",
    "skill_type": "programming"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "javascript",
    "skill_type": "programming"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "golang",
    "skill_type": "programming"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "rust",
    "skill_type": "programming"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "bigquery",
    "skill_type": "cloud"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "spark",
    "skill_type": "libraries"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "jupyter",
    "skill_type": "libraries"
  },
  {
    "job_id": 511999,
    "job_role": "Senior Data Analyst",
    "company_name": "Fastly",
    "job_type": "Full-time",
    "posted_date": "2023-02-01",
    "yearly_avg_salary": "178500.0",
    "skill_name": "github",
    "skill_type": "other"
  },
  {
    "job_id": 1020432,
    "job_role": "Senior Data Analyst",
    "company_name": "Omada Health",
    "job_type": "Full-time",
    "posted_date": "2023-08-25",
    "yearly_avg_salary": "173000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 1020432,
    "job_role": "Senior Data Analyst",
    "company_name": "Omada Health",
    "job_type": "Full-time",
    "posted_date": "2023-08-25",
    "yearly_avg_salary": "173000.0",
    "skill_name": "excel",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1020432,
    "job_role": "Senior Data Analyst",
    "company_name": "Omada Health",
    "job_type": "Full-time",
    "posted_date": "2023-08-25",
    "yearly_avg_salary": "173000.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1290878,
    "job_role": "Senior Data Analyst",
    "company_name": "Cisco Meraki",
    "job_type": "Full-time",
    "posted_date": "2023-06-06",
    "yearly_avg_salary": "172500.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 1290878,
    "job_role": "Senior Data Analyst",
    "company_name": "Cisco Meraki",
    "job_type": "Full-time",
    "posted_date": "2023-06-06",
    "yearly_avg_salary": "172500.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 1290878,
    "job_role": "Senior Data Analyst",
    "company_name": "Cisco Meraki",
    "job_type": "Full-time",
    "posted_date": "2023-06-06",
    "yearly_avg_salary": "172500.0",
    "skill_name": "r",
    "skill_type": "programming"
  },
  {
    "job_id": 1290878,
    "job_role": "Senior Data Analyst",
    "company_name": "Cisco Meraki",
    "job_type": "Full-time",
    "posted_date": "2023-06-06",
    "yearly_avg_salary": "172500.0",
    "skill_name": "snowflake",
    "skill_type": "cloud"
  },
  {
    "job_id": 1290878,
    "job_role": "Senior Data Analyst",
    "company_name": "Cisco Meraki",
    "job_type": "Full-time",
    "posted_date": "2023-06-06",
    "yearly_avg_salary": "172500.0",
    "skill_name": "react",
    "skill_type": "libraries"
  },
  {
    "job_id": 1290878,
    "job_role": "Senior Data Analyst",
    "company_name": "Cisco Meraki",
    "job_type": "Full-time",
    "posted_date": "2023-06-06",
    "yearly_avg_salary": "172500.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1290878,
    "job_role": "Senior Data Analyst",
    "company_name": "Cisco Meraki",
    "job_type": "Full-time",
    "posted_date": "2023-06-06",
    "yearly_avg_salary": "172500.0",
    "skill_name": "microstrategy",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 332437,
    "job_role": "Senior Data Analyst",
    "company_name": "Empassion",
    "job_type": "Full-time",
    "posted_date": "2023-05-11",
    "yearly_avg_salary": "171000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 332437,
    "job_role": "Senior Data Analyst",
    "company_name": "Empassion",
    "job_type": "Full-time",
    "posted_date": "2023-05-11",
    "yearly_avg_salary": "171000.0",
    "skill_name": "r",
    "skill_type": "programming"
  },
  {
    "job_id": 332437,
    "job_role": "Senior Data Analyst",
    "company_name": "Empassion",
    "job_type": "Full-time",
    "posted_date": "2023-05-11",
    "yearly_avg_salary": "171000.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 332437,
    "job_role": "Senior Data Analyst",
    "company_name": "Empassion",
    "job_type": "Full-time",
    "posted_date": "2023-05-11",
    "yearly_avg_salary": "171000.0",
    "skill_name": "looker",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 332437,
    "job_role": "Senior Data Analyst",
    "company_name": "Empassion",
    "job_type": "Full-time",
    "posted_date": "2023-05-11",
    "yearly_avg_salary": "171000.0",
    "skill_name": "zoom",
    "skill_type": "sync"
  },
  {
    "job_id": 1781684,
    "job_role": "Data Analyst",
    "company_name": "Robert Half",
    "job_type": "Full-time",
    "posted_date": "2023-10-06",
    "yearly_avg_salary": "170000.0",
    "skill_name": "java",
    "skill_type": "programming"
  },
  {
    "job_id": 1781684,
    "job_role": "Data Analyst",
    "company_name": "Robert Half",
    "job_type": "Full-time",
    "posted_date": "2023-10-06",
    "yearly_avg_salary": "170000.0",
    "skill_name": "go",
    "skill_type": "programming"
  },
  {
    "job_id": 1781684,
    "job_role": "Data Analyst",
    "company_name": "Robert Half",
    "job_type": "Full-time",
    "posted_date": "2023-10-06",
    "yearly_avg_salary": "170000.0",
    "skill_name": "excel",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 7859,
    "job_role": "Senior Data Analyst",
    "company_name": "Arsenault",
    "job_type": "Full-time",
    "posted_date": "2023-09-20",
    "yearly_avg_salary": "170000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 7859,
    "job_role": "Senior Data Analyst",
    "company_name": "Arsenault",
    "job_type": "Full-time",
    "posted_date": "2023-09-20",
    "yearly_avg_salary": "170000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 7859,
    "job_role": "Senior Data Analyst",
    "company_name": "Arsenault",
    "job_type": "Full-time",
    "posted_date": "2023-09-20",
    "yearly_avg_salary": "170000.0",
    "skill_name": "nosql",
    "skill_type": "programming"
  },
  {
    "job_id": 7859,
    "job_role": "Senior Data Analyst",
    "company_name": "Arsenault",
    "job_type": "Full-time",
    "posted_date": "2023-09-20",
    "yearly_avg_salary": "170000.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1525451,
    "job_role": "Data Analyst",
    "company_name": "Uber",
    "job_type": "Full-time",
    "posted_date": "2023-04-18",
    "yearly_avg_salary": "167000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 1525451,
    "job_role": "Data Analyst",
    "company_name": "Uber",
    "job_type": "Full-time",
    "posted_date": "2023-04-18",
    "yearly_avg_salary": "167000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 1525451,
    "job_role": "Data Analyst",
    "company_name": "Uber",
    "job_type": "Full-time",
    "posted_date": "2023-04-18",
    "yearly_avg_salary": "167000.0",
    "skill_name": "r",
    "skill_type": "programming"
  },
  {
    "job_id": 1525451,
    "job_role": "Data Analyst",
    "company_name": "Uber",
    "job_type": "Full-time",
    "posted_date": "2023-04-18",
    "yearly_avg_salary": "167000.0",
    "skill_name": "swift",
    "skill_type": "programming"
  },
  {
    "job_id": 1525451,
    "job_role": "Data Analyst",
    "company_name": "Uber",
    "job_type": "Full-time",
    "posted_date": "2023-04-18",
    "yearly_avg_salary": "167000.0",
    "skill_name": "excel",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1525451,
    "job_role": "Data Analyst",
    "company_name": "Uber",
    "job_type": "Full-time",
    "posted_date": "2023-04-18",
    "yearly_avg_salary": "167000.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1525451,
    "job_role": "Data Analyst",
    "company_name": "Uber",
    "job_type": "Full-time",
    "posted_date": "2023-04-18",
    "yearly_avg_salary": "167000.0",
    "skill_name": "looker",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 712473,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-08-14",
    "yearly_avg_salary": "165000.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 712473,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-08-14",
    "yearly_avg_salary": "165000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 712473,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-08-14",
    "yearly_avg_salary": "165000.0",
    "skill_name": "r",
    "skill_type": "programming"
  },
  {
    "job_id": 712473,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-08-14",
    "yearly_avg_salary": "165000.0",
    "skill_name": "sas",
    "skill_type": "programming"
  },
  {
    "job_id": 712473,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-08-14",
    "yearly_avg_salary": "165000.0",
    "skill_name": "matlab",
    "skill_type": "programming"
  },
  {
    "job_id": 712473,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-08-14",
    "yearly_avg_salary": "165000.0",
    "skill_name": "pandas",
    "skill_type": "libraries"
  },
  {
    "job_id": 712473,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-08-14",
    "yearly_avg_salary": "165000.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 712473,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-08-14",
    "yearly_avg_salary": "165000.0",
    "skill_name": "looker",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 712473,
    "job_role": "Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_type": "Full-time",
    "posted_date": "2023-08-14",
    "yearly_avg_salary": "165000.0",
    "skill_name": "sas",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 1246069,
    "job_role": "Data Analyst",
    "company_name": "Plexus Resource Solutions",
    "job_type": "Full-time",
    "posted_date": "2023-12-08",
    "yearly_avg_salary": "165000.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 1246069,
    "job_role": "Data Analyst",
    "company_name": "Plexus Resource Solutions",
    "job_type": "Full-time",
    "posted_date": "2023-12-08",
    "yearly_avg_salary": "165000.0",
    "skill_name": "mysql",
    "skill_type": "databases"
  },
  {
    "job_id": 1246069,
    "job_role": "Data Analyst",
    "company_name": "Plexus Resource Solutions",
    "job_type": "Full-time",
    "posted_date": "2023-12-08",
    "yearly_avg_salary": "165000.0",
    "skill_name": "aws",
    "skill_type": "cloud"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "sql",
    "skill_type": "programming"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "python",
    "skill_type": "programming"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "scala",
    "skill_type": "programming"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "r",
    "skill_type": "programming"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "mysql",
    "skill_type": "databases"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "postgresql",
    "skill_type": "databases"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "couchbase",
    "skill_type": "databases"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "azure",
    "skill_type": "cloud"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "databricks",
    "skill_type": "cloud"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "aws",
    "skill_type": "cloud"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "redshift",
    "skill_type": "cloud"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "oracle",
    "skill_type": "cloud"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "snowflake",
    "skill_type": "cloud"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "watson",
    "skill_type": "cloud"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "pyspark",
    "skill_type": "libraries"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "airflow",
    "skill_type": "libraries"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "linux",
    "skill_type": "os"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "tableau",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "ssis",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "cognos",
    "skill_type": "analyst_tools"
  },
  {
    "job_id": 918213,
    "job_role": "Data Analyst",
    "company_name": "DIRECTV",
    "job_type": "Full-time",
    "posted_date": "2023-06-14",
    "yearly_avg_salary": "160515.0",
    "skill_name": "visio",
    "skill_type": "analyst_tools"
  }
]
*/