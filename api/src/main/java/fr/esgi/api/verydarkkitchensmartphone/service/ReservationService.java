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

@Service
@RequiredArgsConstructor
@Transactional
public class ReservationService {

    private final ReservationRepository reservationRepository;
    private final PlatRepository platRepository;
    private final UserRepository userRepository;

    public ReservationResponse createReservation(ReservationRequest request) {
        List<Plat> plats = platRepository.findAllById(request.getPlatIds());

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

    public ReservationResponse getReservationById(Long id) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        return convertToResponse(reservation);
    }

    public List<ReservationResponse> getAllReservations() {
        return reservationRepository.findAll().stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public List<ReservationResponse> getReservationsByEmail(String email) {
        return reservationRepository.findByEmail(email).stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public List<ReservationResponse> getReservationByUserId(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        return reservationRepository.findByUser(user).stream().map(this::convertToResponse).collect(Collectors.toList());
    }

    public ReservationResponse updateStatut(Long id, String statut) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        reservation.setStatut(StatutReservation.valueOf(statut));
        return convertToResponse(reservationRepository.save(reservation));
    }

    public void cancelReservation(Long id) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        reservation.setStatut(StatutReservation.ANNULEE);
        reservationRepository.save(reservation);
    }

    private ReservationResponse convertToResponse(Reservation reservation) {
        List<PlatDTO> platDTOs = reservation.getPlats().stream()
                .map(plat -> PlatDTO.builder()
                        .id(plat.getId())
                        .nom(plat.getNom())
                        .description(plat.getDescription())
                        .prix(plat.getPrix())
                        .categorie(plat.getCategorie().name())
                        .build())
                .collect(Collectors.toList());

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
