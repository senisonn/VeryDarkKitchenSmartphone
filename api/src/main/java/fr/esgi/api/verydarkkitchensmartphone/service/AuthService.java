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

@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    
    public AuthResponse register(RegisterRequest request) {
        // Vérifier si le username existe déjà
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username already exists");
        }
        
        // Vérifier si l'email existe déjà
        if (request.getEmail() != null && userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists");
        }
        
        // Créer le nouvel utilisateur
        User user = User.builder()
                .username(request.getUsername())
                .password(passwordEncoder.encode(request.getPassword()))
                .email(request.getEmail())
                .role(request.getRole())
                .build();
        
        userRepository.save(user);
        
        // Générer le token
        String token = jwtService.generateToken(user);
        
        return AuthResponse.builder()
                .token(token)
                .role(user.getRole().name())
                .userId(user.getId())
                .username(user.getUsername())
                .build();
    }
    
    public AuthResponse login(AuthRequest request) {
        // Authentifier l'utilisateur
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );
        
        // Récupérer l'utilisateur
        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Générer le token
        String token = jwtService.generateToken(user);
        
        return AuthResponse.builder()
                .token(token)
                .role(user.getRole().name())
                .userId(user.getId())
                .username(user.getUsername())
                .build();
    }
}

