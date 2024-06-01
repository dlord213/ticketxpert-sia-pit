-- Database name: ticketxpert (For SIA PIT)

/* **************** */
/* SCHEMAS CREATION */
/* **************** */

CREATE SCHEMA users;
CREATE SCHEMA events;
CREATE SCHEMA tickets;
CREATE SCHEMA transactions;

/* ************** */
/* TABLE CREATION */
/* ************** */

CREATE TABLE users.user(
	user_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name TEXT,
	address TEXT,
	contact_number VARCHAR(12),
	username TEXT,
	password TEXT
);

CREATE TABLE events.attendee(
	user_id BIGINT NOT NULL PRIMARY KEY REFERENCES users.user(user_id)
);

CREATE TABLE events.venue(
	venue_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name TEXT,
	address TEXT,
	capacity INT
);

CREATE TABLE events.customer_support(
	customer_support_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name TEXT,
	contact_number VARCHAR(12)
);

CREATE TABLE events.logistic(
	logistic_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name TEXT,
	contact_number VARCHAR(12)
);

CREATE TABLE events.event(
	event_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name TEXT,
	description TEXT,
	_date DATE,
	category TEXT,
	portrait_image_url TEXT,
	cover_image_url TEXT,
	seat_plan_image_url TEXT,
	venue_id BIGINT NOT NULL,
	customer_support_id BIGINT NOT NULL,
	logistic_id BIGINT NOT NULL,
	CONSTRAINT fk_venue
		FOREIGN KEY (venue_id)
		REFERENCES events.venue(venue_id)
		ON DELETE CASCADE,
	CONSTRAINT fk_customer_support
		FOREIGN KEY (customer_support_id)
		REFERENCES events.customer_support(customer_support_id)
		ON DELETE CASCADE,
	CONSTRAINT fk_logistics
		FOREIGN KEY (logistic_id)
		REFERENCES events.logistic(logistic_id)
);

CREATE TABLE tickets.ticket_promo(
	promo_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	code VARCHAR(16),
	discount_amount DECIMAL(10, 2),
	expiration_date DATE,
	usage_limit INT
);

CREATE TABLE tickets.ticket(
	ticket_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	quantity INT,
	price DECIMAL(10, 2),
	location TEXT,
	event_id BIGINT NOT NULL,
	CONSTRAINT fk_event
		FOREIGN KEY (event_id)
		REFERENCES events.event(event_id)
		ON DELETE CASCADE
);

CREATE TABLE transactions.transaction(
	transaction_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	attendee_id BIGINT NOT NULL,
	ticket_id BIGINT NOT NULL,
	promo_id BIGINT DEFAULT NULL,
	reference_number TEXT DEFAULT NULL,
	transaction_date TIMESTAMP,
	amount DECIMAL(10, 2),
	is_confirmed BOOLEAN DEFAULT FALSE,
	CONSTRAINT fk_attendee
		FOREIGN KEY (attendee_id)
		REFERENCES events.attendee(user_id),
	CONSTRAINT fk_ticket
		FOREIGN KEY (ticket_id)
		REFERENCES tickets.ticket(ticket_id),
	CONSTRAINT fk_promo
		FOREIGN KEY (promo_id)
		REFERENCES tickets.ticket_promo(promo_id)
);

CREATE TABLE tickets.ticket_delivery(
	transaction_id BIGINT PRIMARY KEY NOT NULL,
	is_delivered BOOLEAN,
	CONSTRAINT fk_transaction
		FOREIGN KEY (transaction_id)
		REFERENCES transactions.transaction(transaction_id)
);

CREATE TABLE tickets.seat(
	transaction_id BIGINT PRIMARY KEY NOT NULL,
	seat_number INT,
	CONSTRAINT fk_ticket_delivery
		FOREIGN KEY (transaction_id)
		REFERENCES tickets.ticket_delivery(transaction_id)
);

/* ************** */
/* INDEX CREATION */
/* ************** */

CREATE INDEX idx_event ON events.event(event_id);
CREATE INDEX idx_venue ON events.venue(venue_id);
CREATE INDEX idx_user ON users.user(user_id);


/* ************** */
/* ROLES CREATION */
/* ************** */

CREATE ROLE administrator
	WITH LOGIN 
	PASSWORD 'admin'
	SUPERUSER;

CREATE ROLE public_user
	WITH LOGIN PASSWORD 'public_user';

-- Grant privileges on users schema
GRANT USAGE ON SCHEMA users TO public_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA users TO public_user;

-- Grant privileges on events schema
GRANT USAGE ON SCHEMA events TO public_user;
GRANT SELECT ON ALL TABLES IN SCHEMA events TO public_user;
GRANT INSERT, UPDATE ON events.attendee TO public_user;

-- Grant privileges on tickets schema
GRANT USAGE ON SCHEMA tickets TO public_user;
GRANT SELECT, UPDATE ON tickets.ticket TO public_user;
GRANT SELECT, UPDATE ON tickets.ticket_promo TO public_user;
GRANT SELECT ON tickets.ticket_delivery TO public_user;
GRANT SELECT ON tickets.seat TO public_user;

-- Grant privileges on transactions schema
GRANT USAGE ON SCHEMA transactions TO public_user;
GRANT INSERT, SELECT, UPDATE ON transactions.transaction TO public_user;

-- Grant privileges on sequences ID for lastInsertID() function
GRANT USAGE, SELECT ON SEQUENCE transactions.transaction_transaction_id_seq TO public_user;
GRANT USAGE, SELECT ON SEQUENCE users.user_user_id_seq TO public_user;
GRANT USAGE, SELECT ON SEQUENCE tickets.ticket_promo_promo_id_seq TO public_user;
GRANT USAGE, SELECT ON SEQUENCE tickets.ticket_ticket_id_seq TO public_user;
GRANT USAGE, SELECT ON SEQUENCE events.event_event_id_seq TO public_user;

/* ******************* */
/* POPULATE THE TABLES */
/* ******************* */

INSERT INTO events.venue(name, address, capacity)
VALUES 
	('SM Mall Of Asia Arena', 'Complex, SM Mall of Asia Arena, J.W. Diokno Boulevard, Mall of Asia - Cavite City, Pasay, 1300 Metro Manila', 20000),
	('Samsung Hall, SM Aura Premier', '6/F SM Aura Premier, 26th Street, corner McKinley Pkwy, Taguig, Metro Manila', 1000);

INSERT INTO events.customer_support(name, contact_number)
VALUES
	('SM Online', '09673948765');
	
INSERT INTO events.logistic(name, contact_number)
VALUES
	('SM Online', '09673948765');
	
INSERT INTO events.event(name, description, _date, category, 
				  portrait_image_url, cover_image_url, seat_plan_image_url, 
				  venue_id, customer_support_id, logistic_id)
VALUES
	(
		'2024 NCT DREAM WORLD TOUR', '2024 NCT DREAM WORLD TOUR', '2024-08-10', 'Music',
		'https://images1.smtickets.com/images/portrait_07052024121212.jpg', 'https://images1.smtickets.com/images/carousel_09052024103727.jpg', 'https://images1.smtickets.com/images/seatplan_07052024121255.jpg',
		1, 1, 1
	),
	(
		'LAUFEY 2024 BEWITCHED THE GODDESS TOUR', 'Laufey (pronounced lay-vay) is a 24-year-old, Los Angeles-based singer, composer, producer and multi-instrumentalist whose jazz songs are about young love and self-discovery. Raised between Reykjavík and Washington, D.C. with annual visits to Beijing, the Icelandic-Chinese artist grew up playing cello as well as piano and became hooked on the jazz standards of Ella Fitzgerald after digging through her father’s record collection.',
		'2024-09-02', 'Music',
		'https://images1.smtickets.com/images/portrait_11042024164540.jpg', 'https://images1.smtickets.com/images/carousel_11042024164540.jpg', 'https://images1.smtickets.com/images/seatplan_11042024164554.jpg',
		1, 1, 1
	),
	(
		'TWICE X OISHI SNACKTACULAR FAN MEET', 'KPOP group TWICE is returning to the Philippines for the Twice x Oishi Snacktacular Fan Meet. An O, Wow! O, Wow! fusion of flavor, fun, and fandom.',
		'2024-05-01', 'Music', 'https://images1.smtickets.com/images/portrait_23042024162627.jpg', 'https://images1.smtickets.com/images/carousel_23042024162627.jpg',
		'https://images1.smtickets.com/images/seatplan_05052024130650.jpg', 1, 1, 1
	),
	(
		'ITZY 2ND WORLD TOUR BORN TO BE', 'ITZY 2ND WORLD TOUR BORN TO BE', '2024-08-03', 'Music',
		'https://images1.smtickets.com/images/portrait_05042024142732.jpg', 'https://images1.smtickets.com/images/carousel_05042024142653.jpg', 'https://images1.smtickets.com/images/seatplan_05042024142750.jpg',
		1, 1, 1
	),
	(
		'MISS UNIVERSE PHILIPPINES 2024', 'MISS UNIVERSE PHILIPPINES 2024', '2024-04-22', 'Others',
		'https://images1.smtickets.com/images/portrait_05042024173719.jpg', 'https://images1.smtickets.com/images/carousel_05042024173719.jpg', 'https://images1.smtickets.com/images/seatplan_05042024173729.jpg',
		1, 1, 1
	);
	
	-- NCT Tickets
INSERT INTO tickets.ticket(quantity, price, location, event_id)
VALUES
	(1, 15800, 'VIP SOUNDCHECK PACKAGE', 1),
	(1, 14250, 'FLOOR STANDING', 1),
	(16, 13500, 'LBA', 1),
	(10, 12500, 'LBB', 1),
	(16, 7500, 'UBB', 1),
	(16, 3500, 'GEN AD', 1);
	
-- Laufey Tickets
INSERT INTO tickets.ticket(quantity, price, location, event_id)
VALUES
	(1, 9250, 'FLOOR FRONT', 2),
	(1, 8750, 'FLOOR BACK', 2),	
	(1, 9250, 'FLOOR FRONT', 2),
	(8, 8250, 'PATRON', 2),
	(4, 7750, 'LBA PREMIUM', 2),
	(10, 7250, 'LBA REGULAR', 2),
	(4, 6750, 'LBB PREMIUM', 2),
	(6, 6250, 'LBB REGULAR', 2),
	(4, 4250, 'UB PREMIUM', 2),
	(12, 3250, 'UB REGULAR', 2),
	(16, 2250, 'GEN AD', 2);
	
-- TWICE Tickets
INSERT INTO tickets.ticket(quantity, price, location, event_id)
VALUES
	(3, 30, 'SVIP', 3),
	(3, 30, 'VIP', 3),
	(14, 30, 'LOWER BOX', 3),
	(16, 30, 'UPPER BOX', 3),
	(16, 30, 'GEN AD', 3);

-- ITZY Tickets
INSERT INTO tickets.ticket(quantity, price, location, event_id)
VALUES
	(5, 16500, 'VIP 1', 4),
	(6, 16000, 'VIP 2', 4),
	(8, 13000, 'LBA', 4),
	(6, 12500, 'LBB PREMIUM', 4),
	(4, 11750, 'LBB REGULAR', 4),
	(6, 7250, 'UB PREMIUM', 4),
	(10, 6500, 'UB REGULAR', 4),
	(16, 3000, 'GEN AD', 4)