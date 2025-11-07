package fr.esgi.api.verydarkkitchensmartphone.service;

import fr.esgi.api.verydarkkitchensmartphone.dto.AuthRequest;
import fr.esgi.api.verydarkkitchensmartphone.dto.AuthResponse;
import fr.esgi.api.verydarkkitchensmartphone.dto.RegisterRequest;
import fr.esgi.api.verydarkkitchensmartphone.models.User;
import fr.esgi.api.verydarkkitchensmartphone.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * Service gérant l'authentification et l'inscription des utilisateurs.
 * Fournit les méthodes pour créer de nouveaux comptes et authentifier les utilisateurs existants.
 */
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    /**
     * Enregistre un nouvel utilisateur dans le système.
     * Vérifie l'unicité du nom d'utilisateur et de l'email avant la création.
     *
     * @param request Données d'inscription de l'utilisateur
     * @return Réponse contenant le token JWT et les informations utilisateur
     * @throws RuntimeException si le nom d'utilisateur ou l'email existe déjà
     */
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username already exists");
        }

        if (request.getEmail() != null && userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        User user = User.builder()
                .username(request.getUsername())
                .password(passwordEncoder.encode(request.getPassword()))
                .email(request.getEmail())
                .role(request.getRole())
                .build();

        userRepository.save(user);

        String token = jwtService.generateToken(user);

        return AuthResponse.builder()
                .token(token)
                .role(user.getRole().name())
                .userId(user.getId())
                .username(user.getUsername())
                .build();
    }

    /**
     * Authentifie un utilisateur existant.
     * Vérifie les credentials et génère un token JWT en cas de succès.
     *
     * @param request Données de connexion (username et password)
     * @return Réponse contenant le token JWT et les informations utilisateur
     * @throws RuntimeException si l'utilisateur n'est pas trouvé
     */
    public AuthResponse login(AuthRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        String token = jwtService.generateToken(user);

        return AuthResponse.builder()
                .token(token)
                .role(user.getRole().name())
                .userId(user.getId())
                .username(user.getUsername())
                .build();
    }
}