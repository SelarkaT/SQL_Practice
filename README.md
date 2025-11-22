# 📌 Introduction #

This SQL project explores the current job market for Data Analyst roles by analyzing job postings, required skills, salaries, company details, and remote-work availability.

It is designed for both technical practice and job-market insight, making it ideal for recruiters or employers reviewing analytical capability and SQL proficiency.
# 📂 Background #
The dataset is composed of multiple relational tables representing real-world job-posting data:

job_postings_fact — Job listings with titles, locations, salary data, and posting dates  
company_dim — Lookup table containing company names and details  
skills_dim — List of all unique skills associated with job roles  
skills_job_dim — Bridge table linking skills to corresponding job postings

## The project tackles 5 core analytical problems:

### [1] Top-paying Data Analyst jobs
Retrieves the highest salary postings with company names and remote-work availability.

### [2] Skills required for the top-paying roles
Shows which technical skills are associated with the best-paying positions.

### [3] Most in-demand Data Analyst skills
Ranks skills based on how frequently they appear across all job postings.

### [4] Top-paying skills
Calculates the average salary for each skill to identify high-value technologies.

### [5] Optimal skills (high demand + high salary)
Combines demand and salary metrics to find the most strategically valuable skills to learn.

SQL queries? Check them out here: [Project_SQL folder](/Project_SQL/)

# 🛠 Tools Used #
### [1] SQL ###

The core language used throughout the project.
Techniques include:
- CTEs (WITH statements)
- Aggregations & grouping
- Complex joins (INNER, LEFT)
- Filtering with ILIKE, IS NOT NULL, and Boolean conditions
- Subqueries & ordered materialization
- Calculating averages and counts
- Ranking & sorting for top-N analysis

### [2] PostgreSQL ###

The project is designed and written for PostgreSQL, leveraging its functions and type casting (e.g., job_posted_date::DATE).

### [3] Git & GitHub ###
Used for:

- Version control
- Repository organization
- Sharing the project publicly as part of a data analytics portfolio
### [4] Visual Studio Code (VS Code) ###

- Used as the primary IDE for writing, editing, and managing SQL scripts.   
- Extensions like SQLTools and SQLTools PostgreSQL/ Cockroach Driver assist in query formatting, syntax highlighting, and database interaction.


# 📊 Analysis & Key Insights
## 1️⃣ Top-Paying Data Analyst Jobs ##

***Question: Which are the highest-paying Data Analyst jobs available remotely?***

```sql
SELECT
    job_id,
    job_title_short AS job_role,
    companies.name AS company_name,
    job_location AS location,
    job_schedule_type AS job_type,
    job_posted_date::DATE AS posted_date,
    salary_year_avg AS yearly_avg_salary
FROM
    job_postings_fact
LEFT JOIN company_dim AS companies
    ON job_postings_fact.company_id = companies.company_id    
WHERE
    job_postings_fact.job_title ILIKE '%Data Analyst%'
    AND job_postings_fact.job_work_from_home = TRUE
    AND job_postings_fact.salary_year_avg IS NOT NULL 
ORDER BY
    yearly_avg_salary DESC
LIMIT 20;
```

### Key Insights: ###

1. Highest-paying roles are often remote-friendly.

2. SQL, Python, and Tableau appear frequently in these top roles.

3. Cloud and niche engineering skills (AWS, Snowflake, Go) can significantly increase salary.      

## 2️⃣ Skills Required for Top-Paying Jobs ##

***Question: What skills are required for the top-paying Data Analyst jobs?***
```sql
WITH top_paying_jobs AS (
    SELECT *
    FROM (
        SELECT
            job_id,
            job_title_short AS job_role,
            companies.name AS company_name,    
            job_schedule_type AS job_type,
            job_posted_date::DATE AS posted_date,
            salary_year_avg AS yearly_avg_salary
        FROM
            job_postings_fact AS job_postings
        LEFT JOIN company_dim AS companies
            ON job_postings.company_id = companies.company_id
        WHERE
            job_postings.job_title ILIKE '%Data Analyst%'
            AND job_postings.job_work_from_home = TRUE
            AND job_postings.salary_year_avg IS NOT NULL    
        ORDER BY yearly_avg_salary DESC
        LIMIT 20                    
    )
)
SELECT
    top_paying_jobs.*,
    skills.skills AS skill_name,
    skills.type AS skill_type
FROM
    top_paying_jobs
INNER JOIN skills_job_dim AS bridge
    ON top_paying_jobs.job_id = bridge.job_id
INNER JOIN skills_dim AS skills
    ON bridge.skill_id = skills.skill_id 
ORDER BY
    top_paying_jobs.yearly_avg_salary DESC;
```

### Key Insights: ###

1. Top-paying jobs consistently require SQL, Python, and Tableau.

2. Cloud and data engineering skills appear in fewer jobs but correlate with higher salaries.

## 3️⃣ Most In-Demand Skills ##

***Question: What are the most in-demand skills for Data Analysts?***
```sql
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
    job_postings.job_title ILIKE '%Data Analyst%'
GROUP BY    
    skill_name, skill_type           
ORDER BY 
    job_count DESC 
LIMIT 10;
```

### Key Insights: ###

1. SQL, Python, and Tableau dominate demand.

2. Excel and Power BI are common but less impactful on salary.

3. Cloud skills are emerging as important for modern analytics roles.


## 4️⃣ Top-Paying Skills ##

***Question: Which skills are associated with the highest salaries?***
```sql
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
    job_postings.job_title ILIKE '%Data Analyst%'
    AND job_postings.salary_year_avg IS NOT NULL 
GROUP BY
    skill_id, skills.skills
ORDER BY
    yearly_avg_salary DESC
LIMIT 25;
```

### Key Insights: ###

1. Niche skills like Snowflake, Go, AWS, and Java pay the highest.

2. Core skills (SQL, Python, Tableau) are both high-demand and well-paying.

## 5️⃣ Optimal Skills to Learn (High Demand + High Salary) ##

***Question: Which skills offer both high demand and high salary for remote Data Analyst roles?***
```sql
WITH skills_demand_per_job_count AS (
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
        job_postings.job_title ILIKE '%Data Analyst%'
        AND job_postings.job_work_from_home = TRUE
        AND job_postings.salary_year_avg IS NOT NULL 
    GROUP BY skills.skill_id
),
top_paying_skills AS (
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
        job_postings.job_title ILIKE '%Data Analyst%'
        AND job_postings.job_work_from_home = TRUE
        AND job_postings.salary_year_avg IS NOT NULL 
    GROUP BY skills.skill_id
)
SELECT
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
LIMIT 25;
```

### Key Insights: ###

1. SQL, Python, and Tableau form the core skills for most roles.

2. Adding Cloud, Snowflake, or Go/Java skills significantly increases salary potential.

3. Core skills ensure employability; niche skills increase earning power.
# 📘 Learnings (What I Learned) #

- Gained hands-on experience writing complex SQL queries with joins, CTEs, and aggregations to extract meaningful insights from multi-table datasets.

- Learned to analyze job market trends, identify in-demand and high-paying skills, and interpret the impact of different skills on salary and demand.

- Improved my ability to structure end-to-end analysis: formulating questions, validating results, and summarizing findings clearly for decision-making.
# ✅ Conclusions #

### Key Insights: ###

- SQL, Python, and Tableau are the core skills required for almost every Data Analyst role, forming the foundation for employability and higher-paying positions.

- Excel and Power BI remain important for analysis and reporting, but they have less impact on salary compared to programming and cloud skills.

- Cloud and data engineering skills (AWS, Snowflake, Go, Java) are niche but significantly increase salary potential when combined with core skills.

- High demand ≠ high salary — the most common skills ensure job availability, while specialized technical skills drive earning potential.

- A “premium analyst stack” combining core analytics, cloud, and one engineering skill positions you for hybrid roles with the highest market value.

### Closing Thoughts / Personal Takeaway: ###

This project taught me how to approach real-world datasets strategically, connect multiple tables to answer practical questions, and translate analysis into actionable insights. I now have a clearer understanding of which skills truly matter in the Data Analytics job market and how to prioritize learning to maximize both employability and earning potential.