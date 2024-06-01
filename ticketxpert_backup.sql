--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-06-01 11:19:46

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 182002)
-- Name: events; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA events;


ALTER SCHEMA events OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 182003)
-- Name: tickets; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tickets;


ALTER SCHEMA tickets OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 182004)
-- Name: transactions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA transactions;


ALTER SCHEMA transactions OWNER TO postgres;

--
-- TOC entry 6 (class 2615 OID 182001)
-- Name: users; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA users;


ALTER SCHEMA users OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 182013)
-- Name: attendee; Type: TABLE; Schema: events; Owner: postgres
--

CREATE TABLE events.attendee (
    user_id bigint NOT NULL
);


ALTER TABLE events.attendee OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 182032)
-- Name: customer_support; Type: TABLE; Schema: events; Owner: postgres
--

CREATE TABLE events.customer_support (
    customer_support_id bigint NOT NULL,
    name text,
    contact_number character varying(12)
);


ALTER TABLE events.customer_support OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 182031)
-- Name: customer_support_customer_support_id_seq; Type: SEQUENCE; Schema: events; Owner: postgres
--

ALTER TABLE events.customer_support ALTER COLUMN customer_support_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME events.customer_support_customer_support_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 182048)
-- Name: event; Type: TABLE; Schema: events; Owner: postgres
--

CREATE TABLE events.event (
    event_id bigint NOT NULL,
    name text,
    description text,
    _date date,
    category text,
    portrait_image_url text,
    cover_image_url text,
    seat_plan_image_url text,
    venue_id bigint NOT NULL,
    customer_support_id bigint NOT NULL,
    logistic_id bigint NOT NULL
);


ALTER TABLE events.event OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 182047)
-- Name: event_event_id_seq; Type: SEQUENCE; Schema: events; Owner: postgres
--

ALTER TABLE events.event ALTER COLUMN event_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME events.event_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 182040)
-- Name: logistic; Type: TABLE; Schema: events; Owner: postgres
--

CREATE TABLE events.logistic (
    logistic_id bigint NOT NULL,
    name text,
    contact_number character varying(12)
);


ALTER TABLE events.logistic OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 182039)
-- Name: logistic_logistic_id_seq; Type: SEQUENCE; Schema: events; Owner: postgres
--

ALTER TABLE events.logistic ALTER COLUMN logistic_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME events.logistic_logistic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 182024)
-- Name: venue; Type: TABLE; Schema: events; Owner: postgres
--

CREATE TABLE events.venue (
    venue_id bigint NOT NULL,
    name text,
    address text,
    capacity integer
);


ALTER TABLE events.venue OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 182023)
-- Name: venue_venue_id_seq; Type: SEQUENCE; Schema: events; Owner: postgres
--

ALTER TABLE events.venue ALTER COLUMN venue_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME events.venue_venue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 182123)
-- Name: seat; Type: TABLE; Schema: tickets; Owner: postgres
--

CREATE TABLE tickets.seat (
    transaction_id bigint NOT NULL,
    seat_number integer
);


ALTER TABLE tickets.seat OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 182077)
-- Name: ticket; Type: TABLE; Schema: tickets; Owner: postgres
--

CREATE TABLE tickets.ticket (
    ticket_id bigint NOT NULL,
    quantity integer,
    price numeric(10,2),
    location text,
    event_id bigint NOT NULL
);


ALTER TABLE tickets.ticket OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 182113)
-- Name: ticket_delivery; Type: TABLE; Schema: tickets; Owner: postgres
--

CREATE TABLE tickets.ticket_delivery (
    transaction_id bigint NOT NULL,
    is_delivered boolean
);


ALTER TABLE tickets.ticket_delivery OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 182071)
-- Name: ticket_promo; Type: TABLE; Schema: tickets; Owner: postgres
--

CREATE TABLE tickets.ticket_promo (
    promo_id bigint NOT NULL,
    code character varying(16),
    discount_amount numeric(10,2),
    expiration_date date,
    usage_limit integer
);


ALTER TABLE tickets.ticket_promo OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 182070)
-- Name: ticket_promo_promo_id_seq; Type: SEQUENCE; Schema: tickets; Owner: postgres
--

ALTER TABLE tickets.ticket_promo ALTER COLUMN promo_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tickets.ticket_promo_promo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 182076)
-- Name: ticket_ticket_id_seq; Type: SEQUENCE; Schema: tickets; Owner: postgres
--

ALTER TABLE tickets.ticket ALTER COLUMN ticket_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tickets.ticket_ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 182090)
-- Name: transaction; Type: TABLE; Schema: transactions; Owner: postgres
--

CREATE TABLE transactions.transaction (
    transaction_id bigint NOT NULL,
    attendee_id bigint NOT NULL,
    ticket_id bigint NOT NULL,
    promo_id bigint,
    reference_number text,
    transaction_date timestamp without time zone,
    amount numeric(10,2),
    is_confirmed boolean DEFAULT false
);


ALTER TABLE transactions.transaction OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 182089)
-- Name: transaction_transaction_id_seq; Type: SEQUENCE; Schema: transactions; Owner: postgres
--

ALTER TABLE transactions.transaction ALTER COLUMN transaction_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME transactions.transaction_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 182006)
-- Name: user; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users."user" (
    user_id bigint NOT NULL,
    name text,
    address text,
    contact_number character varying(12),
    username text,
    password text
);


ALTER TABLE users."user" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 182005)
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

ALTER TABLE users."user" ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME users.user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4866 (class 0 OID 182013)
-- Dependencies: 221
-- Data for Name: attendee; Type: TABLE DATA; Schema: events; Owner: postgres
--

COPY events.attendee (user_id) FROM stdin;
1
\.


--
-- TOC entry 4870 (class 0 OID 182032)
-- Dependencies: 225
-- Data for Name: customer_support; Type: TABLE DATA; Schema: events; Owner: postgres
--

COPY events.customer_support (customer_support_id, name, contact_number) FROM stdin;
1	SM Online	09673948765
\.


--
-- TOC entry 4874 (class 0 OID 182048)
-- Dependencies: 229
-- Data for Name: event; Type: TABLE DATA; Schema: events; Owner: postgres
--

COPY events.event (event_id, name, description, _date, category, portrait_image_url, cover_image_url, seat_plan_image_url, venue_id, customer_support_id, logistic_id) FROM stdin;
1	2024 NCT DREAM WORLD TOUR	2024 NCT DREAM WORLD TOUR	2024-08-10	Music	https://images1.smtickets.com/images/portrait_07052024121212.jpg	https://images1.smtickets.com/images/carousel_09052024103727.jpg	https://images1.smtickets.com/images/seatplan_07052024121255.jpg	1	1	1
2	LAUFEY 2024 BEWITCHED THE GODDESS TOUR	Laufey (pronounced lay-vay) is a 24-year-old, Los Angeles-based singer, composer, producer and multi-instrumentalist whose jazz songs are about young love and self-discovery. Raised between Reykjavík and Washington, D.C. with annual visits to Beijing, the Icelandic-Chinese artist grew up playing cello as well as piano and became hooked on the jazz standards of Ella Fitzgerald after digging through her father’s record collection.	2024-09-02	Music	https://images1.smtickets.com/images/portrait_11042024164540.jpg	https://images1.smtickets.com/images/carousel_11042024164540.jpg	https://images1.smtickets.com/images/seatplan_11042024164554.jpg	1	1	1
3	TWICE X OISHI SNACKTACULAR FAN MEET	KPOP group TWICE is returning to the Philippines for the Twice x Oishi Snacktacular Fan Meet. An O, Wow! O, Wow! fusion of flavor, fun, and fandom.	2024-05-01	Music	https://images1.smtickets.com/images/portrait_23042024162627.jpg	https://images1.smtickets.com/images/carousel_23042024162627.jpg	https://images1.smtickets.com/images/seatplan_05052024130650.jpg	1	1	1
4	ITZY 2ND WORLD TOUR BORN TO BE	ITZY 2ND WORLD TOUR BORN TO BE	2024-08-03	Music	https://images1.smtickets.com/images/portrait_05042024142732.jpg	https://images1.smtickets.com/images/carousel_05042024142653.jpg	https://images1.smtickets.com/images/seatplan_05042024142750.jpg	1	1	1
5	MISS UNIVERSE PHILIPPINES 2024	MISS UNIVERSE PHILIPPINES 2024	2024-04-22	Others	https://images1.smtickets.com/images/portrait_05042024173719.jpg	https://images1.smtickets.com/images/carousel_05042024173719.jpg	https://images1.smtickets.com/images/seatplan_05042024173729.jpg	1	1	1
\.


--
-- TOC entry 4872 (class 0 OID 182040)
-- Dependencies: 227
-- Data for Name: logistic; Type: TABLE DATA; Schema: events; Owner: postgres
--

COPY events.logistic (logistic_id, name, contact_number) FROM stdin;
1	SM Online	09673948765
\.


--
-- TOC entry 4868 (class 0 OID 182024)
-- Dependencies: 223
-- Data for Name: venue; Type: TABLE DATA; Schema: events; Owner: postgres
--

COPY events.venue (venue_id, name, address, capacity) FROM stdin;
1	SM Mall Of Asia Arena	Complex, SM Mall of Asia Arena, J.W. Diokno Boulevard, Mall of Asia - Cavite City, Pasay, 1300 Metro Manila	20000
2	Samsung Hall, SM Aura Premier	6/F SM Aura Premier, 26th Street, corner McKinley Pkwy, Taguig, Metro Manila	1000
\.


--
-- TOC entry 4882 (class 0 OID 182123)
-- Dependencies: 237
-- Data for Name: seat; Type: TABLE DATA; Schema: tickets; Owner: postgres
--

COPY tickets.seat (transaction_id, seat_number) FROM stdin;
\.


--
-- TOC entry 4878 (class 0 OID 182077)
-- Dependencies: 233
-- Data for Name: ticket; Type: TABLE DATA; Schema: tickets; Owner: postgres
--

COPY tickets.ticket (ticket_id, quantity, price, location, event_id) FROM stdin;
1	1	15800.00	VIP SOUNDCHECK PACKAGE	1
2	1	14250.00	FLOOR STANDING	1
3	16	13500.00	LBA	1
4	10	12500.00	LBB	1
5	16	7500.00	UBB	1
8	1	8750.00	FLOOR BACK	2
9	1	9250.00	FLOOR FRONT	2
10	8	8250.00	PATRON	2
11	4	7750.00	LBA PREMIUM	2
12	10	7250.00	LBA REGULAR	2
13	4	6750.00	LBB PREMIUM	2
14	6	6250.00	LBB REGULAR	2
15	4	4250.00	UB PREMIUM	2
16	12	3250.00	UB REGULAR	2
17	16	2250.00	GEN AD	2
19	3	30.00	VIP	3
20	14	30.00	LOWER BOX	3
21	16	30.00	UPPER BOX	3
24	6	16000.00	VIP 2	4
25	8	13000.00	LBA	4
26	6	12500.00	LBB PREMIUM	4
27	4	11750.00	LBB REGULAR	4
28	6	7250.00	UB PREMIUM	4
29	10	6500.00	UB REGULAR	4
30	16	3000.00	GEN AD	4
18	0	30.00	SVIP	3
23	0	16500.00	VIP 1	4
6	0	3500.00	GEN AD	1
7	0	9250.00	FLOOR FRONT	2
22	0	30.00	GEN AD	3
\.


--
-- TOC entry 4881 (class 0 OID 182113)
-- Dependencies: 236
-- Data for Name: ticket_delivery; Type: TABLE DATA; Schema: tickets; Owner: postgres
--

COPY tickets.ticket_delivery (transaction_id, is_delivered) FROM stdin;
\.


--
-- TOC entry 4876 (class 0 OID 182071)
-- Dependencies: 231
-- Data for Name: ticket_promo; Type: TABLE DATA; Schema: tickets; Owner: postgres
--

COPY tickets.ticket_promo (promo_id, code, discount_amount, expiration_date, usage_limit) FROM stdin;
\.


--
-- TOC entry 4880 (class 0 OID 182090)
-- Dependencies: 235
-- Data for Name: transaction; Type: TABLE DATA; Schema: transactions; Owner: postgres
--

COPY transactions.transaction (transaction_id, attendee_id, ticket_id, promo_id, reference_number, transaction_date, amount, is_confirmed) FROM stdin;
3	1	6	\N	UB20240050204024	2024-05-31 22:01:02.014596	16.00	t
1	1	18	\N	asdasdasdasdasda	2024-05-31 22:00:21.620675	3.00	f
2	1	23	\N	wadawdawdaw	2024-05-31 22:00:27.312471	5.00	f
4	1	7	\N	awdawdiuawgduiaw	2024-05-31 22:07:28.76295	1.00	f
5	1	22	\N	\N	2024-06-01 10:56:26.671977	16.00	f
\.


--
-- TOC entry 4865 (class 0 OID 182006)
-- Dependencies: 220
-- Data for Name: user; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users."user" (user_id, name, address, contact_number, username, password) FROM stdin;
1	Jhon Lloyd Dayo Viernes	Oro Habitat Phase 1, Calaanan	09673948765	dlord213	$2y$10$azHefJPyO27zBskaVv1kiuo9HIoVdy547X7uM1DUkVXCyBBajsspK
\.


--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 224
-- Name: customer_support_customer_support_id_seq; Type: SEQUENCE SET; Schema: events; Owner: postgres
--

SELECT pg_catalog.setval('events.customer_support_customer_support_id_seq', 1, true);


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 228
-- Name: event_event_id_seq; Type: SEQUENCE SET; Schema: events; Owner: postgres
--

SELECT pg_catalog.setval('events.event_event_id_seq', 5, true);


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 226
-- Name: logistic_logistic_id_seq; Type: SEQUENCE SET; Schema: events; Owner: postgres
--

SELECT pg_catalog.setval('events.logistic_logistic_id_seq', 1, true);


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 222
-- Name: venue_venue_id_seq; Type: SEQUENCE SET; Schema: events; Owner: postgres
--

SELECT pg_catalog.setval('events.venue_venue_id_seq', 2, true);


--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 230
-- Name: ticket_promo_promo_id_seq; Type: SEQUENCE SET; Schema: tickets; Owner: postgres
--

SELECT pg_catalog.setval('tickets.ticket_promo_promo_id_seq', 1, false);


--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 232
-- Name: ticket_ticket_id_seq; Type: SEQUENCE SET; Schema: tickets; Owner: postgres
--

SELECT pg_catalog.setval('tickets.ticket_ticket_id_seq', 30, true);


--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 234
-- Name: transaction_transaction_id_seq; Type: SEQUENCE SET; Schema: transactions; Owner: postgres
--

SELECT pg_catalog.setval('transactions.transaction_transaction_id_seq', 5, true);


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 219
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.user_user_id_seq', 1, true);


--
-- TOC entry 4690 (class 2606 OID 182017)
-- Name: attendee attendee_pkey; Type: CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.attendee
    ADD CONSTRAINT attendee_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4695 (class 2606 OID 182038)
-- Name: customer_support customer_support_pkey; Type: CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.customer_support
    ADD CONSTRAINT customer_support_pkey PRIMARY KEY (customer_support_id);


--
-- TOC entry 4699 (class 2606 OID 182054)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (event_id);


--
-- TOC entry 4697 (class 2606 OID 182046)
-- Name: logistic logistic_pkey; Type: CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.logistic
    ADD CONSTRAINT logistic_pkey PRIMARY KEY (logistic_id);


--
-- TOC entry 4693 (class 2606 OID 182030)
-- Name: venue venue_pkey; Type: CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.venue
    ADD CONSTRAINT venue_pkey PRIMARY KEY (venue_id);


--
-- TOC entry 4710 (class 2606 OID 182127)
-- Name: seat seat_pkey; Type: CONSTRAINT; Schema: tickets; Owner: postgres
--

ALTER TABLE ONLY tickets.seat
    ADD CONSTRAINT seat_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4708 (class 2606 OID 182117)
-- Name: ticket_delivery ticket_delivery_pkey; Type: CONSTRAINT; Schema: tickets; Owner: postgres
--

ALTER TABLE ONLY tickets.ticket_delivery
    ADD CONSTRAINT ticket_delivery_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4704 (class 2606 OID 182083)
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: tickets; Owner: postgres
--

ALTER TABLE ONLY tickets.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (ticket_id);


--
-- TOC entry 4702 (class 2606 OID 182075)
-- Name: ticket_promo ticket_promo_pkey; Type: CONSTRAINT; Schema: tickets; Owner: postgres
--

ALTER TABLE ONLY tickets.ticket_promo
    ADD CONSTRAINT ticket_promo_pkey PRIMARY KEY (promo_id);


--
-- TOC entry 4706 (class 2606 OID 182097)
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4688 (class 2606 OID 182012)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4700 (class 1259 OID 182133)
-- Name: idx_event; Type: INDEX; Schema: events; Owner: postgres
--

CREATE INDEX idx_event ON events.event USING btree (event_id);


--
-- TOC entry 4691 (class 1259 OID 182134)
-- Name: idx_venue; Type: INDEX; Schema: events; Owner: postgres
--

CREATE INDEX idx_venue ON events.venue USING btree (venue_id);


--
-- TOC entry 4686 (class 1259 OID 182135)
-- Name: idx_user; Type: INDEX; Schema: users; Owner: postgres
--

CREATE INDEX idx_user ON users."user" USING btree (user_id);


--
-- TOC entry 4711 (class 2606 OID 182018)
-- Name: attendee attendee_user_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.attendee
    ADD CONSTRAINT attendee_user_id_fkey FOREIGN KEY (user_id) REFERENCES users."user"(user_id);


--
-- TOC entry 4712 (class 2606 OID 182060)
-- Name: event fk_customer_support; Type: FK CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.event
    ADD CONSTRAINT fk_customer_support FOREIGN KEY (customer_support_id) REFERENCES events.customer_support(customer_support_id) ON DELETE CASCADE;


--
-- TOC entry 4713 (class 2606 OID 182065)
-- Name: event fk_logistics; Type: FK CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.event
    ADD CONSTRAINT fk_logistics FOREIGN KEY (logistic_id) REFERENCES events.logistic(logistic_id);


--
-- TOC entry 4714 (class 2606 OID 182055)
-- Name: event fk_venue; Type: FK CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.event
    ADD CONSTRAINT fk_venue FOREIGN KEY (venue_id) REFERENCES events.venue(venue_id) ON DELETE CASCADE;


--
-- TOC entry 4715 (class 2606 OID 182084)
-- Name: ticket fk_event; Type: FK CONSTRAINT; Schema: tickets; Owner: postgres
--

ALTER TABLE ONLY tickets.ticket
    ADD CONSTRAINT fk_event FOREIGN KEY (event_id) REFERENCES events.event(event_id) ON DELETE CASCADE;


--
-- TOC entry 4720 (class 2606 OID 182128)
-- Name: seat fk_ticket_delivery; Type: FK CONSTRAINT; Schema: tickets; Owner: postgres
--

ALTER TABLE ONLY tickets.seat
    ADD CONSTRAINT fk_ticket_delivery FOREIGN KEY (transaction_id) REFERENCES tickets.ticket_delivery(transaction_id);


--
-- TOC entry 4719 (class 2606 OID 182118)
-- Name: ticket_delivery fk_transaction; Type: FK CONSTRAINT; Schema: tickets; Owner: postgres
--

ALTER TABLE ONLY tickets.ticket_delivery
    ADD CONSTRAINT fk_transaction FOREIGN KEY (transaction_id) REFERENCES transactions.transaction(transaction_id);


--
-- TOC entry 4716 (class 2606 OID 182098)
-- Name: transaction fk_attendee; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.transaction
    ADD CONSTRAINT fk_attendee FOREIGN KEY (attendee_id) REFERENCES events.attendee(user_id);


--
-- TOC entry 4717 (class 2606 OID 182108)
-- Name: transaction fk_promo; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.transaction
    ADD CONSTRAINT fk_promo FOREIGN KEY (promo_id) REFERENCES tickets.ticket_promo(promo_id);


--
-- TOC entry 4718 (class 2606 OID 182103)
-- Name: transaction fk_ticket; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.transaction
    ADD CONSTRAINT fk_ticket FOREIGN KEY (ticket_id) REFERENCES tickets.ticket(ticket_id);


--
-- TOC entry 4888 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA events; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA events TO public_user;


--
-- TOC entry 4889 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA tickets; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA tickets TO public_user;


--
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 9
-- Name: SCHEMA transactions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA transactions TO public_user;


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA users; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA users TO public_user;


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE attendee; Type: ACL; Schema: events; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE events.attendee TO public_user;


--
-- TOC entry 4893 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE customer_support; Type: ACL; Schema: events; Owner: postgres
--

GRANT SELECT ON TABLE events.customer_support TO public_user;


--
-- TOC entry 4894 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE event; Type: ACL; Schema: events; Owner: postgres
--

GRANT SELECT ON TABLE events.event TO public_user;


--
-- TOC entry 4895 (class 0 OID 0)
-- Dependencies: 228
-- Name: SEQUENCE event_event_id_seq; Type: ACL; Schema: events; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE events.event_event_id_seq TO public_user;


--
-- TOC entry 4896 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE logistic; Type: ACL; Schema: events; Owner: postgres
--

GRANT SELECT ON TABLE events.logistic TO public_user;


--
-- TOC entry 4897 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE venue; Type: ACL; Schema: events; Owner: postgres
--

GRANT SELECT ON TABLE events.venue TO public_user;


--
-- TOC entry 4898 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE seat; Type: ACL; Schema: tickets; Owner: postgres
--

GRANT SELECT ON TABLE tickets.seat TO public_user;


--
-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE ticket; Type: ACL; Schema: tickets; Owner: postgres
--

GRANT SELECT,UPDATE ON TABLE tickets.ticket TO public_user;


--
-- TOC entry 4900 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE ticket_delivery; Type: ACL; Schema: tickets; Owner: postgres
--

GRANT SELECT ON TABLE tickets.ticket_delivery TO public_user;


--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE ticket_promo; Type: ACL; Schema: tickets; Owner: postgres
--

GRANT SELECT,UPDATE ON TABLE tickets.ticket_promo TO public_user;


--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 230
-- Name: SEQUENCE ticket_promo_promo_id_seq; Type: ACL; Schema: tickets; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE tickets.ticket_promo_promo_id_seq TO public_user;


--
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE ticket_ticket_id_seq; Type: ACL; Schema: tickets; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE tickets.ticket_ticket_id_seq TO public_user;


--
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE transaction; Type: ACL; Schema: transactions; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE transactions.transaction TO public_user;


--
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE transaction_transaction_id_seq; Type: ACL; Schema: transactions; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE transactions.transaction_transaction_id_seq TO public_user;


--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE "user"; Type: ACL; Schema: users; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE users."user" TO public_user;


--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE user_user_id_seq; Type: ACL; Schema: users; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE users.user_user_id_seq TO public_user;


-- Completed on 2024-06-01 11:19:47

--
-- PostgreSQL database dump complete
--

