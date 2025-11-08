package fr.esgi.api.verydarkkitchensmartphone.service;

import fr.esgi.api.verydarkkitchensmartphone.dto.AvailabilityRequest;
import fr.esgi.api.verydarkkitchensmartphone.dto.AvailabilityResponse;
import fr.esgi.api.verydarkkitchensmartphone.models.Reservation;
import fr.esgi.api.verydarkkitchensmartphone.models.StatutReservation;
import fr.esgi.api.verydarkkitchensmartphone.repository.ReservationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AvailabilityService {

    private final ReservationRepository reservationRepository;

    @Value("${restaurant.capacity:50}")
    private Integer restaurantCapacity;

    /**
     * Check availability for a given time slot (2-hour window)
     * Considers reservations within ±1 hour of requested time
     */
    public AvailabilityResponse checkAvailability(AvailabilityRequest request) {
        LocalDateTime requestedTime = request.getDateReservation();
        Integer requestedSeats = request.getNombrePersonnes();

        // Define time slot window (1 hour before and after)
        LocalDateTime startWindow = requestedTime.minusHours(1);
        LocalDateTime endWindow = requestedTime.plusHours(1);

        // Get all active reservations in this time window
        List<Reservation> reservations = reservationRepository
                .findByDateReservationBetween(startWindow, endWindow);

        // Calculate total reserved seats (excluding cancelled reservations)
        int reservedSeats = reservations.stream()
                .filter(r -> r.getStatut() != StatutReservation.ANNULEE)
                .mapToInt(Reservation::getNombrePersonnes)
                .sum();

        int availableSeats = restaurantCapacity - reservedSeats;
        boolean isAvailable = availableSeats >= requestedSeats;

        return new AvailabilityResponse(
                requestedTime,
                restaurantCapacity,
                reservedSeats,
                availableSeats,
                isAvailable
        );
    }

    /**
     * Check availability excluding a specific reservation (for updates)
     */
    public AvailabilityResponse checkAvailabilityExcluding(
            AvailabilityRequest request,
            Long excludeReservationId
    ) {
        LocalDateTime requestedTime = request.getDateReservation();
        Integer requestedSeats = request.getNombrePersonnes();

        LocalDateTime startWindow = requestedTime.minusHours(1);
        LocalDateTime endWindow = requestedTime.plusHours(1);

        List<Reservation> reservations = reservationRepository
                .findByDateReservationBetween(startWindow, endWindow);

        // Calculate reserved seats excluding the reservation being updated
        int reservedSeats = reservations.stream()
                .filter(r -> r.getStatut() != StatutReservation.ANNULEE)
                .filter(r -> !r.getId().equals(excludeReservationId))
                .mapToInt(Reservation::getNombrePersonnes)
                .sum();

        int availableSeats = restaurantCapacity - reservedSeats;
        boolean isAvailable = availableSeats >= requestedSeats;

        return new AvailabilityResponse(
                requestedTime,
                restaurantCapacity,
                reservedSeats,
                availableSeats,
                isAvailable
        );
    }
}
