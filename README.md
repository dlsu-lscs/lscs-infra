# LSCS Infrastructure

* The official LSCS Infrastructure-as-Code (IaC) maintained by the LSCS Research and Development DevOps Team.
* This document provides a high-level overview. For a detailed explanation of the architecture and strategic choices, please refer to the **[LSCS Infrastructure: DevOps Blueprint]([LSCS-RND] LSCS Infrastructure Blueprint.pdf)**.

---

## Technology Stack

The LSCS stack is composed of carefully selected tools, each serving a specific purpose within the DevOps lifecycle, as defined in the official blueprint.

**Configuration & Infrastructure as Code (IaC)**
*   **Ansible** - Used for initial server configuration and hardening, including the installation of Coolify.
*   **Terraform** - Manages all resources *within* the Coolify platform (e.g., projects, applications, databases), ensuring the PaaS layer is managed as code.

**CI/CD Automation**
*   **GitHub Actions** - Orchestrates the entire CI/CD workflow, including building images, running tests, scanning for vulnerabilities with Trivy, and triggering deployments on Coolify.

**Deployment & Containerization**
*   **Docker & Docker Compose** - The foundation for containerizing all applications and services.
*   **Coolify** - Serves as the central deployment engine and user interface (PaaS).
*   **Traefik** - Functions as the reverse proxy, managed by Coolify to handle routing, load balancing, and SSL generation.

**Observability**
*   **Monitoring**:
    *   **Netdata** - The primary tool for real-time, high-granularity monitoring of the VPS and containers.
    *   **Prometheus & Grafana Stack** - An advanced option for long-term metric storage, powerful querying, and customized dashboards.
*   **Logging**:
    *   **Loki & Promtail** - A lightweight, robust stack for log aggregation and visualization within Grafana.
*   **Tracing (Application-Level)**:
    *   **Jaeger / OpenTelemetry** - Reserved for future use as the architecture evolves towards microservices, providing distributed tracing to debug complex service interactions.

**Security**
*   **Trivy** - A vulnerability scanner integrated into the CI/CD pipeline to check Docker images and run as a scheduled task on the server to detect vulnerabilities in running applications.
*   **Falco** - Provides runtime security by continuously monitoring kernel and container activity to detect and alert on suspicious behavior.

**Supporting Infrastructure**
*   **Alerting & Notifications**:
    *   **Discord Webhooks** - Serves as the central notification channel for alerts from Coolify, Trivy, Falco, and Netdata.
*   **Cron Job Management**:
    *   **GoCron or Cronicle** - A dedicated service deployed within Coolify to manage scheduled tasks.
*   **Secrets Management (Optional but Recommended)**:
    *   **HashiCorp Vault or Bitwarden** - For centralized, secure management of application secrets in production.

---

## Architecture

Based on the principles outlined in the **LSCS Infrastructure: DevOps Blueprint**, the architecture is centered around Coolify as an automated PaaS, fronted by Traefik.

### Core Infrastructure Flow

A visual representation of the request and data flow:

```text
================================================================================
|                                Public Internet                               |
================================================================================
                                     │
                                     ▼
+------------------------------------------------------------------------------+
| Traefik (Reverse Proxy)                                                      |
| - Handles incoming traffic, SSL termination, and routing to services.        |
| - Managed by Coolify.                                                        |
+------------------------------------------------------------------------------+
                                     │
                                     ▼
+--------------------------------------------------------------------------------+
| Coolify Platform                                                               |
| - Central PaaS for deploying and managing applications and services.           |
|                                                                                |
|   ┌───────────────────────────┐   ┌──────────────────────────────────────────┐ |       
|   │   Deployed Applications   │   │         Observability & Others           │ |       
|   │  (Docker Compose based)   │   │ - Netdata, Prometheus, Grafana (Metrics) │ |
|   └───────────────────────────┘   │ - Loki, Promtail (Logging)               │ |
|                                   │ - GoCron / Cronicle (Cron Jobs)          │ |
|                                   └──────────────────────────────────────────┘ |
+--------------------------------------------------------------------------------+
      │                 │                   │                     │
      │ (Deployments)   │ (Metrics)         │ (Logs)              │ (Runtime Events)
      ▼                 ▼                   ▼                     ▼
+------------------------------------------------------------------------------+
| Monitoring, Alerting & Security                                              |
|                                                                              |
| ┌──────────────┐ ┌───────────────┐ ┌──────────┐      ┌─────────────────────┐ |
| │   Coolify    │ │    Netdata    │ │  Falco   │----->│   Discord Webhooks  │ |
| │ Notifications│ │(Perf. Anomaly)│ │ (Threats)│      │ (Centralized Alerts)│ |
| └──────────────┘ └───────────────┘ └──────────┘      └─────────────────────┘ |
|                                                                              |
+------------------------------------------------------------------------------+
```

---

## DevOps Workflow on Development Teams

1. Developer pushes code to GitHub.
2. CI pipeline builds, tests, scans, and pushes Docker image to GitHub Container Registry (GHCR).
3. CD pipeline deploys to Coolify via webhooks or on to a hosting platform/provider.
4. Monitoring, logging, and tracing tools provide observability.
5. Security tools scan images and monitor runtime.
6. Alerts and logs are routed to Discord via webhooks and dashboards.
