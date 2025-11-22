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


/* Results and Key Insights

    Result table as json:

    Most optimized skills to learn - 
    [
        {
            "skill_name": "sql",
            "job_count": "469",
            "yearly_avg_salary": "101068.65"
        },
        {
            "skill_name": "python",
            "job_count": "276",
            "yearly_avg_salary": "104309.04"
        },
        {
            "skill_name": "tableau",
            "job_count": "273",
            "yearly_avg_salary": "102818.44"
        },
        {
            "skill_name": "excel",
            "job_count": "269",
            "yearly_avg_salary": "90034.09"
        },
        {
            "skill_name": "r",
            "job_count": "164",
            "yearly_avg_salary": "102050.97"
        },
        {
            "skill_name": "power bi",
            "job_count": "127",
            "yearly_avg_salary": "97449.31"
        },
        {
            "skill_name": "looker",
            "job_count": "78",
            "yearly_avg_salary": "110997.04"
        },
        {
            "skill_name": "sas",
            "job_count": "70",
            "yearly_avg_salary": "99524.12"
        },
        {
            "skill_name": "sas",
            "job_count": "70",
            "yearly_avg_salary": "99524.12"
        },
        {
            "skill_name": "powerpoint",
            "job_count": "62",
            "yearly_avg_salary": "87275.89"
        },
        {
            "skill_name": "snowflake",
            "job_count": "55",
            "yearly_avg_salary": "115032.35"
        },
        {
            "skill_name": "word",
            "job_count": "55",
            "yearly_avg_salary": "86472.52"
        },
        {
            "skill_name": "sql server",
            "job_count": "41",
            "yearly_avg_salary": "102768.33"
        },
        {
            "skill_name": "flow",
            "job_count": "39",
            "yearly_avg_salary": "102594.72"
        },
        {
            "skill_name": "oracle",
            "job_count": "37",
            "yearly_avg_salary": "112966.13"
        },
        {
            "skill_name": "go",
            "job_count": "36",
            "yearly_avg_salary": "115843.28"
        },
        {
            "skill_name": "azure",
            "job_count": "36",
            "yearly_avg_salary": "106568.06"
        },
        {
            "skill_name": "aws",
            "job_count": "33",
            "yearly_avg_salary": "110729.52"
        },
        {
            "skill_name": "sheets",
            "job_count": "33",
            "yearly_avg_salary": "87808.77"
        },
        {
            "skill_name": "spss",
            "job_count": "30",
            "yearly_avg_salary": "97742.16"
        },
        {
            "skill_name": "jira",
            "job_count": "28",
            "yearly_avg_salary": "107987.79"
        },
        {
            "skill_name": "vba",
            "job_count": "24",
            "yearly_avg_salary": "95159.17"
        },
        {
            "skill_name": "javascript",
            "job_count": "22",
            "yearly_avg_salary": "103897.27"
        },
        {
            "skill_name": "alteryx",
            "job_count": "22",
            "yearly_avg_salary": "93874.34"
        },
        {
            "skill_name": "java",
            "job_count": "21",
            "yearly_avg_salary": "113128.55"
        }
    ]

    ⭐ Top-Level Insights (4 Key Points)

        1. SQL + Python + Tableau = The Unshakeable Core

            Our data shows:

            SQL → 469 postings | ~$101k

            Python → 276 postings | ~$104k

            Tableau → 273 postings | ~$103k

        👉 These three dominate both demand and salary.
        👉 They remain the foundation of almost every data analyst job.

        2. Excel & Power BI → High Demand but Lower Salary Impact

            Excel has 269 postings, but only ~$90k

            Power BI has 127 postings, ~$97k

        👉 Extremely important for employability
        👉 But they don’t boost salary as much as technical/cloud skills.

        3. Cloud & Data Warehousing Skills = Huge Salary Multipliers

            These are the standout salary boosters:

            Skill	        Avg Salary
            Snowflake	        $115k
            Go (Golang)	        $115k
            Oracle	            $112k
            AWS	                $110k
            Looker	            $110k
            Java	            $113k

        👉 These skills dramatically increase salary
        👉 Even with moderate demand, they are the best add-ons for earning more

        4. The “Premium Analyst” Stack Emerges

        A clear pattern appears: The highest-paid analysts tend to know:
        
            SQL
            Python
            Tableau/Looker/Snowflake
            Cloud (AWS or Azure)
            One backend/engineering language (Go/Java)

        👉 This combination pushes people from $90k → $120k+.
*/