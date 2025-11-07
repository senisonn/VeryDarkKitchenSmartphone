package fr.esgi.api.verydarkkitchensmartphone.service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import fr.esgi.api.verydarkkitchensmartphone.models.User;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

/**
 * Service de gestion des JSON Web Tokens (JWT).
 * Responsable de la génération, validation et extraction des informations des tokens.
 */
@Service
public class JwtService {

    @Value("${jwt.secret}")
    private String secretKey;

    @Value("${jwt.expiration}")
    private long jwtExpiration;

    /**
     * Génère un token JWT pour un utilisateur authentifié.
     * Inclut le rôle et l'ID utilisateur dans les claims.
     *
     * @param userDetails Détails de l'utilisateur authentifié
     * @return Token JWT signé
     */
    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        User user = (User) userDetails;
        claims.put("role", user.getRole().name());
        claims.put("userId", user.getId());

        return Jwts.builder()
                .claims(claims)
                .subject(userDetails.getUsername())
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + jwtExpiration))
                .signWith(getSigningKey())
                .compact();
    }

    /**
     * Extrait le nom d'utilisateur du token JWT.
     *
     * @param token Token JWT
     * @return Nom d'utilisateur
     */
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    /**
     * Extrait le rôle de l'utilisateur du token JWT.
     *
     * @param token Token JWT
     * @return Rôle de l'utilisateur
     */
    public String extractRole(String token) {
        return extractClaim(token, claims -> claims.get("role", String.class));
    }

    /**
     * Extrait l'identifiant de l'utilisateur du token JWT.
     *
     * @param token Token JWT
     * @return ID de l'utilisateur
     */
    public Long extractUserId(String token) {
        return extractClaim(token, claims -> claims.get("userId", Long.class));
    }

    /**
     * Valide un token JWT en vérifiant le nom d'utilisateur et la date d'expiration.
     *
     * @param token Token JWT à valider
     * @param userDetails Détails de l'utilisateur à comparer
     * @return true si le token est valide, false sinon
     */
    public boolean isTokenValid(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return username.equals(userDetails.getUsername()) && !isTokenExpired(token);
    }

    /**
     * Vérifie si le token JWT a expiré.
     *
     * @param token Token JWT
     * @return true si expiré, false sinon
     */
    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    /**
     * Extrait la date d'expiration du token JWT.
     *
     * @param token Token JWT
     * @return Date d'expiration
     */
    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    /**
     * Extrait une claim spécifique du token JWT.
     *
     * @param token Token JWT
     * @param claimsResolver Fonction pour extraire la claim désirée
     * @return Valeur de la claim
     */
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    /**
     * Extrait toutes les claims du token JWT.
     *
     * @param token Token JWT
     * @return Ensemble des claims
     */
    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * Récupère la clé de signature pour les opérations JWT.
     *
     * @return Clé secrète pour signer/vérifier les tokens
     */
    private SecretKey getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}