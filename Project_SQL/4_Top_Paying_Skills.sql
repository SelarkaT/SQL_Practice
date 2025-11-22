/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and 
    helps identify the most financially rewarding skills to acquire or improve
*/

SELECT
    skills.skill_id,
    skills.skills AS skill_name,
    COUNT(job_postings.job_id) AS job_count,
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
    -- job_postings.job_work_from_home = TRUE
    AND
    -- filtering for job postings with yearly salaries mentioned
    job_postings.salary_year_avg IS NOT NULL 
GROUP BY
    skill_id,skills.skills
ORDER BY
    yearly_avg_salary DESC
LIMIT 25 ;


/* Insights from Top Demanded Skills and Top Paying Skills Results

    1. High-paying skills are niche and engineering-heavy.
        - Skills like Kafka, Airflow, Rust, Go, FastAPI, and ML tools (Keras/PyTorch) appear in very few analyst postings but pay extremely well because they overlap with data engineering or ML roles.

     2. High-demand skills are the core analyst toolkit.
        - SQL, Excel, Python, Tableau, and Power BI dominate tens of thousands of postings — these are the foundation of almost every Data Analyst job.

    3. High demand ≠ high salary.

        - The most popular skills don’t always pay the most, and the highest-paying skills aren’t widely required.
        Demand drives job availability; niche skills drive salary.

    4. Career strategy: Master core skills, then add niche ones.

        - Build SQL + Excel + Python + BI tools first for job access, and then add Airflow, Kafka, or ML tools to jump into higher-paying hybrid analyst/engineer roles.

-- Result Tables as json

    Top Demanded Skills -
    
    [
        {
            "skill_name": "sql",
            "skill_type": "programming",
            "job_count": "89431"
        },
        {
            "skill_name": "excel",
            "skill_type": "analyst_tools",
            "job_count": "60793"
        },
        {
            "skill_name": "python",
            "skill_type": "programming",
            "job_count": "55017"
        },
        {
            "skill_name": "tableau",
            "skill_type": "analyst_tools",
            "job_count": "46306"
        },
        {
            "skill_name": "power bi",
            "skill_type": "analyst_tools",
            "job_count": "37279"
        },
        {
            "skill_name": "r",
            "skill_type": "programming",
            "job_count": "29103"
        },
        {
            "skill_name": "sas",
            "skill_type": "analyst_tools",
            "job_count": "13315"
        },
        {
            "skill_name": "sas",
            "skill_type": "programming",
            "job_count": "13315"
        },
        {
            "skill_name": "powerpoint",
            "skill_type": "analyst_tools",
            "job_count": "12131"
        },
        {
            "skill_name": "word",
            "skill_type": "analyst_tools",
            "job_count": "11590"
        }
    ]

    Top Paying Skills -
    [
        {
            "skill_name": "yarn",
            "job_count": "1",
            "yearly_avg_salary": "340000.00"
        },
        {
            "skill_name": "dplyr",
            "job_count": "2",
            "yearly_avg_salary": "196250.00"
        },
        {
            "skill_name": "fastapi",
            "job_count": "1",
            "yearly_avg_salary": "185000.00"
        },
        {
            "skill_name": "golang",
            "job_count": "2",
            "yearly_avg_salary": "161750.00"
        },
        {
            "skill_name": "couchbase",
            "job_count": "1",
            "yearly_avg_salary": "160515.00"
        },
        {
            "skill_name": "vmware",
            "job_count": "1",
            "yearly_avg_salary": "147500.00"
        },
        {
            "skill_name": "perl",
            "job_count": "21",
            "yearly_avg_salary": "141921.21"
        },
        {
            "skill_name": "dynamodb",
            "job_count": "2",
            "yearly_avg_salary": "140000.00"
        },
        {
            "skill_name": "twilio",
            "job_count": "2",
            "yearly_avg_salary": "138500.00"
        },
        {
            "skill_name": "datarobot",
            "job_count": "2",
            "yearly_avg_salary": "128992.75"
        },
        {
            "skill_name": "bitbucket",
            "job_count": "5",
            "yearly_avg_salary": "128599.60"
        },
        {
            "skill_name": "keras",
            "job_count": "3",
            "yearly_avg_salary": "127833.33"
        },
        {
            "skill_name": "gitlab",
            "job_count": "9",
            "yearly_avg_salary": "127033.78"
        },
        {
            "skill_name": "rust",
            "job_count": "3",
            "yearly_avg_salary": "124833.33"
        },
        {
            "skill_name": "watson",
            "job_count": "3",
            "yearly_avg_salary": "121838.33"
        },
        {
            "skill_name": "notion",
            "job_count": "5",
            "yearly_avg_salary": "116710.00"
        },
        {
            "skill_name": "swift",
            "job_count": "8",
            "yearly_avg_salary": "116625.00"
        },
        {
            "skill_name": "kafka",
            "job_count": "29",
            "yearly_avg_salary": "116515.97"
        },
        {
            "skill_name": "php",
            "job_count": "35",
            "yearly_avg_salary": "116354.98"
        },
        {
            "skill_name": "airflow",
            "job_count": "85",
            "yearly_avg_salary": "115752.12"
        },
        {
            "skill_name": "confluence",
            "job_count": "68",
            "yearly_avg_salary": "114840.24"
        },
        {
            "skill_name": "scala",
            "job_count": "51",
            "yearly_avg_salary": "114716.94"
        },
        {
            "skill_name": "jupyter",
            "job_count": "45",
            "yearly_avg_salary": "113386.92"
        },
        {
            "skill_name": "pytorch",
            "job_count": "10",
            "yearly_avg_salary": "112531.35"
        },
        {
            "skill_name": "angular",
            "job_count": "14",
            "yearly_avg_salary": "112411.71"
        }
    ]
*/