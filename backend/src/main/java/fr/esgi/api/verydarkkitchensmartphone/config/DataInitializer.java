package fr.esgi.api.verydarkkitchensmartphone.config;

import fr.esgi.api.verydarkkitchensmartphone.models.Role;
import fr.esgi.api.verydarkkitchensmartphone.models.User;
import fr.esgi.api.verydarkkitchensmartphone.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Initialise les données par défaut de l'application au démarrage.
 * Crée un compte administrateur par défaut si aucun n'existe.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        createDefaultAdmin();
    }

    /**
     * Crée un compte administrateur par défaut si aucun n'existe.
     * Username: admin
     * Password: admin123
     * Email: admin@verydarkkitchen.com
     */
    private void createDefaultAdmin() {
        if (!userRepository.existsByUsername("admin")) {
            User admin = User.builder()
                    .username("admin")
                    .password(passwordEncoder.encode("admin123"))
                    .email("admin@verydarkkitchen.com")
                    .role(Role.ADMIN)
                    .build();

            userRepository.save(admin);
            log.info("✓ Default admin user created successfully");
            log.info("  Username: admin");
            log.info("  Password: admin123");
            log.info("  Email: admin@verydarkkitchen.com");
        } else {
            // Update existing admin user password
            userRepository.findByUsername("admin").ifPresent(admin -> {
                admin.setPassword(passwordEncoder.encode("admin123"));
                userRepository.save(admin);
                log.info("✓ Admin user password reset successfully");
                log.info("  Username: admin");
                log.info("  Password: admin123");
                log.info("  Email: " + admin.getEmail());
            });
        }
    }
}
