---
name: java-spring-boot-coldstart
description: Bootstrap and build Java 21 Spring Boot 3 services for a team with mixed Java experience. Covers REST APIs, SQS messaging via Spring Cloud AWS, Spring Security 6 (JWT resource server), and JUnit 5 + Mockito testing. Maven, no Lombok. Use when creating a new Spring Boot project, adding REST endpoints/SQS listeners/security config, or writing tests against Spring components.
---

# Java Spring Boot

Java 21, Spring Boot 3.x, Maven, JUnit 5 + Mockito, no Lombok.

## When the user wants a new project

Run the bootstrap script. It calls Spring Initializr with the team's defaults baked in (Java 21, Maven, Boot 3.3.5, web + validation + security + oauth2-resource-server + actuator + configuration-processor + testcontainers).

```bash
scripts/new_project.sh <artifact-id> [group-id] [output-dir]
```

After it runs, follow up with whatever the project actually needs:
- **SQS** — add `spring-cloud-aws-starter-sqs` and BOM ([sqs.md](references/sqs.md)). Initializr does not include this.
- **Persistence** — add `spring-boot-starter-data-jpa` + a driver. (Not covered in detail by this skill — ask the user about their DB choice.)
- **Lombok** — don't, see [conventions.md](references/conventions.md). Plant the seed; don't fight a lost battle.

## When the user wants to add/modify code in an existing project

Read the relevant reference file before writing code. Each one is short and focused:

| What you're working on              | Read |
|-------------------------------------|------|
| REST controllers, DTOs, validation, error handling | [rest.md](references/rest.md) |
| SQS producers, listeners, DLQs, LocalStack | [sqs.md](references/sqs.md) |
| Auth filter chain, JWT, scopes, method security, CORS | [security.md](references/security.md) |
| JUnit 5, Mockito, MockMvc, slice tests, Testcontainers | [testing.md](references/testing.md) |
| Project layout, DI, records, config props, Java 21 features | [conventions.md](references/conventions.md) |

If a task spans multiple areas (e.g. "add a secured endpoint that publishes to SQS") read each relevant file — don't try to remember.

## Audience

This skill is for a team with **mixed Java experience**. When explaining choices, briefly say *why* — especially when the modern Spring Boot 3 / Java 21 idiom diverges from older patterns the team may remember (`WebSecurityConfigurerAdapter`, `javax.*`, field injection, manual constructors instead of records). The reference files do this; carry the same tone into the code you write.

## Non-goals

- **Reactive (WebFlux)** — out of scope. Use Spring MVC.
- **Kotlin** — out of scope. Java only.
- **Microservice patterns** (service discovery, config server, gateway) — not covered. Add explicitly when needed.
