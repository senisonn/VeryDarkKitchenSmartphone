package fr.esgi.api.verydarkkitchensmartphone.service;

import fr.esgi.api.verydarkkitchensmartphone.dto.PlatDTO;
import fr.esgi.api.verydarkkitchensmartphone.dto.ReservationRequest;
import fr.esgi.api.verydarkkitchensmartphone.dto.ReservationResponse;
import fr.esgi.api.verydarkkitchensmartphone.models.Plat;
import fr.esgi.api.verydarkkitchensmartphone.models.Reservation;
import fr.esgi.api.verydarkkitchensmartphone.models.StatutReservation;
import fr.esgi.api.verydarkkitchensmartphone.models.User;
import fr.esgi.api.verydarkkitchensmartphone.repository.PlatRepository;
import fr.esgi.api.verydarkkitchensmartphone.repository.ReservationRepository;
import fr.esgi.api.verydarkkitchensmartphone.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Service gérant les opérations métier liées aux réservations.
 * Permet de créer, consulter, modifier et annuler des réservations de restaurant.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class ReservationService {

    private final ReservationRepository reservationRepository;
    private final PlatRepository platRepository;
    private final UserRepository userRepository;

    /**
     * Crée une nouvelle réservation dans le système.
     * Initialise le statut à EN_ATTENTE et enregistre la date de création.
     *
     * @param request Données de la réservation (client, date, plats, etc.)
     * @return Réponse contenant les détails de la réservation créée
     */
    public ReservationResponse createReservation(ReservationRequest request) {
        // Récupération des plats sélectionnés
        List<Plat> plats = platRepository.findAllById(request.getPlatIds());

        // Construction de l'entité réservation
        Reservation reservation = Reservation.builder()
                .user(userRepository.findById(request.getIdClient()).orElse(null))
                .email(request.getEmail())
                .telephone(request.getTelephone())
                .dateReservation(request.getDateReservation())
                .nombrePersonnes(request.getNombrePersonnes())
                .plats(plats)
                .commentaire(request.getCommentaire())
                .statut(StatutReservation.EN_ATTENTE)
                .dateCreation(LocalDateTime.now())
                .build();

        Reservation saved = reservationRepository.save(reservation);
        return convertToResponse(saved);
    }

    /**
     * Récupère une réservation spécifique par son identifiant.
     *
     * @param id Identifiant de la réservation
     * @return Détails de la réservation
     * @throws RuntimeException si la réservation n'est pas trouvée
     */
    public ReservationResponse getReservationById(Long id) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        return convertToResponse(reservation);
    }

    /**
     * Récupère toutes les réservations enregistrées dans le système.
     *
     * @return Liste de toutes les réservations
     */
    public List<ReservationResponse> getAllReservations() {
        return reservationRepository.findAll().stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Récupère toutes les réservations associées à une adresse email.
     * Utile pour les clients non authentifiés ou les recherches par email.
     *
     * @param email Adresse email du client
     * @return Liste des réservations liées à cet email
     */
    public List<ReservationResponse> getReservationsByEmail(String email) {
        return reservationRepository.findByEmail(email).stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Récupère toutes les réservations d'un utilisateur authentifié.
     *
     * @param userId Identifiant de l'utilisateur
     * @return Liste des réservations de l'utilisateur
     * @throws java.util.NoSuchElementException si l'utilisateur n'existe pas
     */
    public List<ReservationResponse> getReservationByUserId(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        return reservationRepository.findByUser(user).stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Met à jour le statut d'une réservation existante.
     * Permet de passer une réservation de EN_ATTENTE à CONFIRMEE, ANNULEE, etc.
     *
     * @param id Identifiant de la réservation
     * @param statut Nouveau statut à appliquer (doit correspondre à un StatutReservation)
     * @return Réservation mise à jour
     * @throws RuntimeException si la réservation n'est pas trouvée
     * @throws IllegalArgumentException si le statut fourni n'est pas valide
     */
    public ReservationResponse updateStatut(Long id, String statut) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        reservation.setStatut(StatutReservation.valueOf(statut));
        return convertToResponse(reservationRepository.save(reservation));
    }

    /**
     * Annule une réservation en changeant son statut à ANNULEE.
     * La réservation n'est pas supprimée de la base de données pour conserver l'historique.
     *
     * @param id Identifiant de la réservation à annuler
     * @throws RuntimeException si la réservation n'est pas trouvée
     */
    public void cancelReservation(Long id) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        reservation.setStatut(StatutReservation.ANNULEE);
        reservationRepository.save(reservation);
    }

    /**
     * Convertit une entité Reservation en DTO pour l'exposition via l'API.
     * Transforme également la liste des plats en PlatDTO.
     *
     * @param reservation Entité réservation à convertir
     * @return DTO contenant toutes les informations de la réservation
     */
    private ReservationResponse convertToResponse(Reservation reservation) {
        // Conversion des plats en DTO
        List<PlatDTO> platDTOs = reservation.getPlats().stream()
                .map(plat -> PlatDTO.builder()
                        .id(plat.getId())
                        .nom(plat.getNom())
                        .description(plat.getDescription())
                        .prix(plat.getPrix())
                        .categorie(plat.getCategorie().name())
                        .build())
                .collect(Collectors.toList());

        // Construction de la réponse complète
        return ReservationResponse.builder()
                .id(reservation.getId())
                .idClient(reservation.getUser().getId())
                .email(reservation.getEmail())
                .telephone(reservation.getTelephone())
                .dateReservation(reservation.getDateReservation())
                .nombrePersonnes(reservation.getNombrePersonnes())
                .plats(platDTOs)
                .statut(reservation.getStatut().name())
                .commentaire(reservation.getCommentaire())
                .dateCreation(reservation.getDateCreation())
                .build();
    }
}