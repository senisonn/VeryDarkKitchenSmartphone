-- Créer la table users si elle n'existe pas
CREATE TABLE IF NOT EXISTS users (
                                     id BIGSERIAL PRIMARY KEY,
                                     username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL,
    account_non_expired BOOLEAN DEFAULT true,
    account_non_locked BOOLEAN DEFAULT true,
    credentials_non_expired BOOLEAN DEFAULT true,
    enabled BOOLEAN DEFAULT true
    );

-- Créer la table plats
CREATE TABLE IF NOT EXISTS plats (
                                     id BIGSERIAL PRIMARY KEY,
                                     nom VARCHAR(100) NOT NULL,
    description TEXT,
    prix DECIMAL(10, 2) NOT NULL,
    categorie VARCHAR(50) NOT NULL,
    image_url VARCHAR(255),
    disponible BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Insérer les utilisateurs de test (mot de passe: password123)
INSERT INTO users (username, password, email, role)
VALUES
    ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMye7I73TIeREq.tfpkQdZTJLgqCk6UM4jG', 'admin@restaurant.com', 'ADMIN'),
    ('user', '$2a$10$N9qo8uLOickgx2ZMRZoMye7I73TIeREq.tfpkQdZTJLgqCk6UM4jG', 'user@restaurant.com', 'USER')
    ON CONFLICT (username) DO NOTHING;

-- Insertion des plats
INSERT INTO plats (nom, description, prix, categorie, image_url, disponible)
VALUES
    ('Salade César', 'Salade avec poulet, parmesan et croûtons', 8.50, 'ENTREE', 'https://exemple.com/salade.jpg', TRUE),
    ('Steak Frites', 'Steak avec frites maison', 15.00, 'PLAT_PRINCIPAL', 'https://exemple.com/steak.jpg', TRUE),
    ('Tarte Tatin', 'Tarte aux pommes caramélisées', 6.00, 'DESSERT', 'https://exemple.com/tarte.jpg', TRUE),
    ('Coca-Cola', 'Boisson gazeuse', 2.50, 'BOISSON', 'https://exemple.com/coca.jpg', TRUE);


