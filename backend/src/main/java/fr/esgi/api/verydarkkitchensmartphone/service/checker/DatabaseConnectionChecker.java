package fr.esgi.api.verydarkkitchensmartphone.service.checker;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.Connection;

@Component
@RequiredArgsConstructor
@Slf4j
public class DatabaseConnectionChecker implements CommandLineRunner {

    private final DataSource dataSource;

    @Override
    public void run(String... args) {
        try (Connection connection = dataSource.getConnection()) {
            log.info("✅ Connexion PostgreSQL réussie!");
            log.info("URL: " + connection.getMetaData().getURL());
            log.info("User: " + connection.getMetaData().getUserName());
        } catch (Exception e) {
            System.err.println("❌ Erreur de connexion PostgreSQL: " + e.getMessage());
        }
    }
}
