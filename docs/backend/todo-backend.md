# DeenMate Backend - Prioritized Task Backlog for MVP

**Date**: September 4, 2025  
**Purpose**: A prioritized and actionable list of tasks for the development team to begin implementing the backend API, based on the MVP phase of the roadmap.  
**Sprint Goal**: Launch the core backend API to validate the architecture and provide essential data to the mobile app.  

---

## Sprint 1: Foundation & Core Services (Weeks 1-2)

**Goal**: Set up the project, infrastructure, and core data models. Implement the user authentication and prayer times services.

| Task ID | Priority | Task Description                                             | Component      | Owner       | Est. Effort | Dependencies |
|---------|----------|--------------------------------------------------------------|----------------|-------------|-------------|--------------|
| **B-01**| **P1**   | **Setup Project Skeleton**: Initialize FastAPI project, configure linters, formatters, and pre-commit hooks. | `Project Setup`| Backend Lead| 1 day       | -            |
| **B-02**| **P1**   | **Define Core DB Models**: Implement `User`, `PrayerLocation`, `PrayerTimesCache` models using SQLAlchemy/Pydantic. | `Database`     | Backend Dev | 2 days      | B-01         |
| **B-03**| **P1**   | **Implement User Auth**: Create `POST /users` and `POST /auth/token` endpoints with JWT generation and validation. | `API`          | Backend Dev | 3 days      | B-02         |
| **D-01**| **P1**   | **Provision Staging Infra**: Set up basic AWS RDS (Postgres) and ElastiCache (Redis) instances using Terraform. | `DevOps`       | DevOps Eng  | 3 days      | -            |
| **B-04**| **P2**   | **Prayer Times Service**: Implement service to fetch data from Aladhan API and cache it in the database. | `Service`      | Backend Dev | 2 days      | B-02         |
| **B-05**| **P2**   | **Prayer Times API**: Expose `GET /prayer/times` endpoint, fetching from the cache/service. | `API`          | Backend Dev | 1 day       | B-04         |
| **T-01**| **P2**   | **Setup CI Pipeline**: Create GitHub Actions workflow to run linting and unit tests on every PR. | `DevOps`       | DevOps Eng  | 2 days      | B-01         |

---

## Sprint 2: Quran Data Integration (Weeks 3-4)

**Goal**: Integrate all Quran-related data, including text, translations, and metadata. Expose core Quran endpoints.

| Task ID | Priority | Task Description                                             | Component      | Owner       | Est. Effort | Dependencies |
|---------|----------|--------------------------------------------------------------|----------------|-------------|-------------|--------------|
| **B-06**| **P1**   | **Define Quran DB Models**: Implement `Surah`, `Verse`, `Translation`, `Reciter` models. | `Database`     | Backend Dev | 2 days      | B-02         |
| **B-07**| **P1**   | **Quran Data Importer**: Create a script to bootstrap the database with Quran text and translations from Quran.com dumps. | `Sync Job`     | Backend Dev | 3 days      | B-06         |
| **D-02**| **P1**   | **Run Data Import**: Execute the importer script on the staging database and validate data integrity. | `DevOps`       | DevOps Eng  | 1 day       | B-07, D-01   |
| **B-08**| **P1**   | **Quran Service Layer**: Implement logic to query for surahs, verses, and translations from the database. | `Service`      | Backend Dev | 2 days      | B-06         |
| **B-09**| **P2**   | **Quran API Endpoints**: Expose `GET /quran/surahs` and `GET /quran/surah/{id}` endpoints. | `API`          | Backend Dev | 2 days      | B-08         |
| **T-02**| **P2**   | **Integration Tests for Quran**: Write tests to verify the correctness of the Quran service and API endpoints. | `Testing`      | QA Engineer | 2 days      | B-09         |
| **M-01**| **P2**   | **Mobile App - Auth Integration**: Update the Flutter app to use the new JWT authentication endpoints. | `Mobile`       | Mobile Dev  | 3 days      | B-03         |

---

## Sprint 3: Remaining Data & Sync Jobs (Weeks 5-6)

**Goal**: Integrate Hadith and Gold Price data. Set up the initial data synchronization jobs.

| Task ID | Priority | Task Description                                             | Component      | Owner       | Est. Effort | Dependencies |
|---------|----------|--------------------------------------------------------------|----------------|-------------|-------------|--------------|
| **B-10**| **P1**   | **Define Hadith/Gold DB Models**: Implement `HadithCollection`, `Hadith`, `GoldRate` models. | `Database`     | Backend Dev | 2 days      | B-02         |
| **B-11**| **P1**   | **Gold Price Sync Job**: Create a daily cron job (Celery/RQ) to fetch gold prices from Metals-API. | `Sync Job`     | Backend Dev | 2 days      | B-10         |
| **B-12**| **P1**   | **Hadith Data Importer**: Create a script to bootstrap the database with Hadith data from Sunnah.com dumps. | `Sync Job`     | Backend Dev | 3 days      | B-10         |
| **B-13**| **P2**   | **Expose Hadith/Gold APIs**: Create `GET /gold/rate` and basic `GET /hadith/...` browse endpoints. | `API`          | Backend Dev | 2 days      | B-11, B-12   |
| **D-03**| **P2**   | **Setup Staging Deployment**: Configure the CI/CD pipeline to automatically deploy the `develop` branch to a staging environment. | `DevOps`       | DevOps Eng  | 2 days      | T-01         |
| **M-02**| **P2**   | **Mobile App - Data Integration**: Update the Flutter app to fetch Prayer Times and Quran data from the new backend. | `Mobile`       | Mobile Dev  | 4 days      | B-05, B-09   |
| **T-03**| **P3**   | **Basic API Monitoring**: Set up CloudWatch dashboards and alerts for API 5xx errors and high latency. | `Observability`| DevOps Eng  | 1 day       | D-03         |

---

## Sprint 4: Testing, Docs & MVP Launch Prep (Weeks 7-8)

**Goal**: Finalize testing, documentation, and prepare for the MVP release.

| Task ID | Priority | Task Description                                             | Component      | Owner       | Est. Effort | Dependencies |
|---------|----------|--------------------------------------------------------------|----------------|-------------|-------------|--------------|
| **T-04**| **P1**   | **End-to-End Testing**: Perform manual and automated E2E tests for all MVP user flows (login, view prayers, read Quran). | `Testing`      | QA Engineer | 3 days      | M-01, M-02   |
| **D-04**| **P1**   | **Provision Production Infra**: Create the production environment in AWS, including VPC, EKS, RDS, and ElastiCache. | `DevOps`       | DevOps Eng  | 3 days      | D-01         |
| **B-14**| **P1**   | **API Documentation**: Generate and publish OpenAPI documentation for all public endpoints. | `Docs`         | Backend Lead| 2 days      | B-13         |
| **M-03**| **P2**   | **Mobile App - Final Integration**: Integrate Hadith and Gold Price APIs into the app. | `Mobile`       | Mobile Dev  | 2 days      | B-13         |
| **D-05**| **P2**   | **Production Deployment Pipeline**: Configure the CI/CD pipeline for deploying the `main` branch to production. | `DevOps`       | DevOps Eng  | 2 days      | D-04, D-03   |
| **T-05**| **P2**   | **Load Testing**: Run basic load tests against the staging environment to identify any major bottlenecks. | `Testing`      | QA Engineer | 2 days      | T-04         |
| **B-15**| **P3**   | **Code Cleanup & Refactoring**: Address any tech debt accumulated during the MVP sprints. | `Code Quality` | All Devs    | 1 day       | -            |

---
### Next Steps:
1.  Create these tasks in the project management tool (e.g., Jira, Linear).
2.  Hold a sprint planning meeting to assign tasks and confirm estimates.
3.  Begin Sprint 1.
