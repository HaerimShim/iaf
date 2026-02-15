# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run Commands

```bash
# Build
./mvnw clean package

# Run tests
./mvnw test

# Run single test class
./mvnw test -Dtest=IafApplicationTests

# Run locally (requires MariaDB on localhost:3306)
./mvnw spring-boot:run
```

## Architecture

Spring Boot 4.0.2 WAR application with JSP server-side rendering, targeting Java 17.

- **Deployment**: WAR packaged for servlet containers (Tomcat); `ServletInitializer` extends `SpringBootServletInitializer`
- **View layer**: JSP + JSTL, resolved from `/WEB-INF/views/*.jsp` (configured via `spring.mvc.view.prefix`/`suffix`)
- **Data access**: Both Spring Data JPA and MyBatis are available as persistence frameworks
- **Database**: MariaDB (connection configured in `application.properties`)
- **Controllers**: Located in `Controller/` package (note: non-standard uppercase package name, outside the `com.iaf` component scan base package)

## Key Paths

- `src/main/java/com/iaf/` — Spring Boot application entry point
- `src/main/java/Controller/` — MVC controllers (separate from main package)
- `src/main/webapp/WEB-INF/views/` — JSP templates
- `src/main/resources/application.properties` — datasource and view resolver config
