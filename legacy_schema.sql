--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: tmp1; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tmp1 AS ENUM (
    'Y',
    'N'
);


ALTER TYPE tmp1 OWNER TO postgres;

--
-- Name: tmp2; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tmp2 AS ENUM (
    'Y',
    'N'
);


ALTER TYPE tmp2 OWNER TO postgres;

--
-- Name: tmp3; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tmp3 AS ENUM (
    'Y',
    'N'
);


ALTER TYPE tmp3 OWNER TO postgres;

--
-- Name: tmp4; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tmp4 AS ENUM (
    'Y',
    'N'
);


ALTER TYPE tmp4 OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bank_konto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE bank_konto (
    bkid integer DEFAULT nextval(('"bank_konto_bkid_seq"'::text)::regclass) NOT NULL,
    datum date NOT NULL,
    wert integer DEFAULT 0 NOT NULL,
    bes text
);


ALTER TABLE bank_konto OWNER TO postgres;

--
-- Name: bk_buchung; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE bk_buchung (
    bkid integer NOT NULL,
    datum timestamp with time zone DEFAULT now() NOT NULL,
    bearbeiter character varying DEFAULT "current_user"() NOT NULL,
    rechnungs_nr integer,
    konto_id integer NOT NULL,
    uid integer
);


ALTER TABLE bk_buchung OWNER TO postgres;

--
-- Name: computer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE computer (
    computer_id integer NOT NULL,
    nutzer_id integer NOT NULL,
    c_wheim_id integer DEFAULT 0 NOT NULL,
    c_etage integer,
    c_zimmernr character varying(10),
    c_typ character varying(20),
    c_cpu character varying(10),
    c_bs character varying(20),
    c_etheraddr character varying(20),
    c_ip inet NOT NULL,
    c_hname character varying(20) DEFAULT ''::character varying NOT NULL,
    c_alias character varying(20),
    c_subnet_id integer DEFAULT 0 NOT NULL,
    c_eth_segment character varying(20),
    last_change timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


ALTER TABLE computer OWNER TO postgres;

--
-- Name: computer_computer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE computer_computer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE computer_computer_id_seq OWNER TO postgres;

--
-- Name: computer_computer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE computer_computer_id_seq OWNED BY computer.computer_id;


--
-- Name: finanz_buchungen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE finanz_buchungen (
    fbid integer DEFAULT nextval(('fbid_seq'::text)::regclass) NOT NULL,
    datum date DEFAULT ('now'::text)::date NOT NULL,
    bearbeiter character varying DEFAULT "current_user"() NOT NULL,
    rechnungs_nr integer,
    wert integer DEFAULT 0 NOT NULL,
    soll integer NOT NULL,
    soll_uid integer,
    haben integer NOT NULL,
    haben_uid integer,
    bes text
);


ALTER TABLE finanz_buchungen OWNER TO postgres;

--
-- Name: finanz_konten; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE finanz_konten (
    konto_id integer DEFAULT nextval(('konto_id_seq'::text)::regclass) NOT NULL,
    name character varying(40) NOT NULL,
    bes text,
    konto_typ character varying(8) NOT NULL,
    nutzer_bezogen boolean DEFAULT false NOT NULL,
    abgeschlossen boolean DEFAULT false NOT NULL,
    vater_konto integer
);


ALTER TABLE finanz_konten OWNER TO postgres;

--
-- Name: finanz_konto_typ; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE finanz_konto_typ (
    konto_typ_id character varying(8) NOT NULL,
    name character varying(40) NOT NULL,
    bes text
);


ALTER TABLE finanz_konto_typ OWNER TO postgres;

--
-- Name: hp4108_ports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE hp4108_ports (
    id integer NOT NULL,
    port character varying(10),
    haus character varying(10),
    wheim_id integer DEFAULT 0 NOT NULL,
    etage character varying(10),
    zimmernr character varying(10),
    ip inet,
    sperrbar character varying(1),
    kommentar character varying(50)
);


ALTER TABLE hp4108_ports OWNER TO postgres;

--
-- Name: hp4108_ports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE hp4108_ports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hp4108_ports_id_seq OWNER TO postgres;

--
-- Name: hp4108_ports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE hp4108_ports_id_seq OWNED BY hp4108_ports.id;


--
-- Name: ldap_nutzer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ldap_nutzer (
    uid character varying NOT NULL,
    mail character varying,
    "userPassword" character varying NOT NULL,
    "homeDirectory" character varying NOT NULL,
    "uidNumber" integer NOT NULL,
    "gidNumber" integer NOT NULL,
    "loginShell" character varying NOT NULL
);


ALTER TABLE ldap_nutzer OWNER TO postgres;

--
-- Name: nutzer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nutzer (
    nutzer_id integer DEFAULT 0 NOT NULL,
    name character varying(30) DEFAULT ''::character varying NOT NULL,
    vname character varying(30) DEFAULT ''::character varying NOT NULL,
    wheim_id integer DEFAULT 0 NOT NULL,
    etage integer DEFAULT 0 NOT NULL,
    zimmernr character varying(10) DEFAULT ''::character varying NOT NULL,
    tel character varying(20),
    unix_account character varying(40) NOT NULL,
    anmeldedatum date DEFAULT '1970-01-01'::date NOT NULL,
    sperrdatum date,
    status integer DEFAULT 1 NOT NULL,
    comment text,
    last_change timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    icq_uin character varying(255),
    bezahlt smallint DEFAULT '1'::smallint NOT NULL
);


ALTER TABLE nutzer OWNER TO postgres;

--
-- Name: status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE status (
    id integer DEFAULT 0 NOT NULL,
    short_str character varying(30) DEFAULT ''::character varying NOT NULL,
    long_str character varying(60) DEFAULT ''::character varying NOT NULL,
    account tmp1 DEFAULT 'Y'::tmp1 NOT NULL,
    ip tmp2 DEFAULT 'Y'::tmp2 NOT NULL,
    del_account tmp3 DEFAULT 'Y'::tmp3 NOT NULL,
    dns tmp4 DEFAULT 'Y'::tmp4 NOT NULL
);


ALTER TABLE status OWNER TO postgres;

--
-- Name: subnet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE subnet (
    subnet_id integer DEFAULT 0 NOT NULL,
    domain character varying(30) DEFAULT ''::character varying NOT NULL,
    net_ip character varying(15) DEFAULT ''::character varying NOT NULL,
    netmask character varying(15) DEFAULT ''::character varying NOT NULL,
    net_broadcast character varying(15) DEFAULT ''::character varying NOT NULL,
    default_gateway character varying(15) DEFAULT ''::character varying NOT NULL,
    vlan_name character varying(15)
);


ALTER TABLE subnet OWNER TO postgres;

--
-- Name: wheim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE wheim (
    wheim_id integer DEFAULT 0 NOT NULL,
    kuerzel character varying(8) DEFAULT ''::character varying NOT NULL,
    str character varying(30) DEFAULT ''::character varying NOT NULL,
    hausnr character varying(4),
    stadt character varying(20) DEFAULT ''::character varying NOT NULL,
    plz character varying(5) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE wheim OWNER TO postgres;

--
-- Name: zih_incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE zih_incidents (
    id character varying(30) NOT NULL,
    type character varying(255) NOT NULL,
    ip character varying(15) NOT NULL,
    "time" timestamp without time zone NOT NULL
);


ALTER TABLE zih_incidents OWNER TO postgres;

--
-- Name: computer computer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY computer ALTER COLUMN computer_id SET DEFAULT nextval('computer_computer_id_seq'::regclass);


--
-- Name: hp4108_ports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hp4108_ports ALTER COLUMN id SET DEFAULT nextval('hp4108_ports_id_seq'::regclass);


--
-- Name: bank_konto bank_konto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bank_konto
    ADD CONSTRAINT bank_konto_pkey PRIMARY KEY (bkid);


--
-- Name: bk_buchung bk_buchung_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bk_buchung
    ADD CONSTRAINT bk_buchung_pkey PRIMARY KEY (bkid);


--
-- Name: computer computer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY computer
    ADD CONSTRAINT computer_pkey PRIMARY KEY (computer_id);


--
-- Name: finanz_buchungen finanz_buchungen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY finanz_buchungen
    ADD CONSTRAINT finanz_buchungen_pkey PRIMARY KEY (fbid);


--
-- Name: finanz_konten finanz_konten_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY finanz_konten
    ADD CONSTRAINT finanz_konten_pkey PRIMARY KEY (konto_id);


--
-- Name: finanz_konto_typ finanz_konto_typ_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY finanz_konto_typ
    ADD CONSTRAINT finanz_konto_typ_pkey PRIMARY KEY (konto_typ_id);


--
-- Name: hp4108_ports hp4108_ports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hp4108_ports
    ADD CONSTRAINT hp4108_ports_pkey PRIMARY KEY (id);


--
-- Name: ldap_nutzer ldap_nutzer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ldap_nutzer
    ADD CONSTRAINT ldap_nutzer_pkey PRIMARY KEY (uid);


--
-- Name: nutzer nutzer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nutzer
    ADD CONSTRAINT nutzer_pkey PRIMARY KEY (nutzer_id);


--
-- Name: nutzer nutzer_unix_account_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nutzer
    ADD CONSTRAINT nutzer_unix_account_key UNIQUE (unix_account);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id);


--
-- Name: subnet subnet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subnet
    ADD CONSTRAINT subnet_pkey PRIMARY KEY (subnet_id);


--
-- Name: wheim wheim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wheim
    ADD CONSTRAINT wheim_pkey PRIMARY KEY (wheim_id);


--
-- Name: zih_incidents zih_incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zih_incidents
    ADD CONSTRAINT zih_incidents_pkey PRIMARY KEY (id);


--
-- Name: ix_computer_c_ip; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_computer_c_ip ON computer USING btree (c_ip);


--
-- Name: ix_hp4108_ports_wheim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_hp4108_ports_wheim_id ON hp4108_ports USING btree (wheim_id);


--
-- Name: ix_nutzer_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_nutzer_status ON nutzer USING btree (status);


--
-- Name: ix_nutzer_wheim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_nutzer_wheim_id ON nutzer USING btree (wheim_id);


--
-- Name: ix_subnet_subnet_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_subnet_subnet_id ON subnet USING btree (subnet_id);


--
-- Name: ix_wheim_wheim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_wheim_wheim_id ON wheim USING btree (wheim_id);


--
-- Name: zimmer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX zimmer ON nutzer USING btree (etage, zimmernr);


--
-- Name: zimmer_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX zimmer_idx ON hp4108_ports USING btree (zimmernr, etage);


--
-- Name: bk_buchung bk_buchung_bkid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bk_buchung
    ADD CONSTRAINT bk_buchung_bkid_fkey FOREIGN KEY (bkid) REFERENCES bank_konto(bkid);


--
-- Name: bk_buchung bk_buchung_konto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bk_buchung
    ADD CONSTRAINT bk_buchung_konto_id_fkey FOREIGN KEY (konto_id) REFERENCES finanz_konten(konto_id);


--
-- Name: computer computer_nutzer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY computer
    ADD CONSTRAINT computer_nutzer_id_fkey FOREIGN KEY (nutzer_id) REFERENCES nutzer(nutzer_id);


--
-- Name: finanz_buchungen finanz_buchungen_haben_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY finanz_buchungen
    ADD CONSTRAINT finanz_buchungen_haben_fkey FOREIGN KEY (haben) REFERENCES finanz_konten(konto_id);


--
-- Name: finanz_buchungen finanz_buchungen_soll_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY finanz_buchungen
    ADD CONSTRAINT finanz_buchungen_soll_fkey FOREIGN KEY (soll) REFERENCES finanz_konten(konto_id);


--
-- Name: finanz_konten finanz_konten_konto_typ_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY finanz_konten
    ADD CONSTRAINT finanz_konten_konto_typ_fkey FOREIGN KEY (konto_typ) REFERENCES finanz_konto_typ(konto_typ_id);


--
-- Name: finanz_konten finanz_konten_vater_konto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY finanz_konten
    ADD CONSTRAINT finanz_konten_vater_konto_fkey FOREIGN KEY (vater_konto) REFERENCES finanz_konten(konto_id);


--
-- Name: nutzer nutzer_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nutzer
    ADD CONSTRAINT nutzer_status_fkey FOREIGN KEY (status) REFERENCES status(id);


--
-- PostgreSQL database dump complete
--


DELETE FROM ldap_nutzer;
DELETE FROM nutzer;
DELETE FROM status;
DELETE FROM wheim;
DELETE FROM hp4108_ports;

INSERT INTO ldap_nutzer (uid, "userPassword", "homeDirectory", "uidNumber", "gidNumber", "loginShell", aktiv, exaktiv)
    VALUES (
        'meister',
        '{CRYPT}$6$rounds=656000$RUd95PgPwSxjIXew$n8C2pAqXLSX3rh9M9WUrJBCWZIiB1VSMpUfoQt9oQUcZJeWpcK226XQzgjqjtMV/1o2QzMpmic39N1xItinSQ1',
        '/home/meister',
        1234,
        1001,
        '/bin/bash',
        true,
        false
    ), (
        'mustermann',
        '{CRYPT}$6$rounds=656000$RUd95PgPwSxjIXew$n8C2pAqXLSX3rh9M9WUrJBCWZIiB1VSMpUfoQt9oQUcZJeWpcK226XQzgjqjtMV/1o2QzMpmic39N1xItinSQ1',
        '/home/mustermann',
        1235,
        1001,
        '/bin/bash',
        false,
        false
    ), (
        'musterfrau',
        '{CRYPT}$6$rounds=656000$RUd95PgPwSxjIXew$n8C2pAqXLSX3rh9M9WUrJBCWZIiB1VSMpUfoQt9oQUcZJeWpcK226XQzgjqjtMV/1o2QzMpmic39N1xItinSQ1',
        '/home/musterfrau',
        1236,
        1001,
        '/bin/bash',
        false,
        false
    );


INSERT INTO status VALUES
    (1,'ok','bezahlt, ok','Y','Y','N','Y'),
    (2,'nicht bez.','angemeldet, aber nicht bezahlt','N','N','N','Y'),
    (3,'n.bez.Mail','nicht bezahlt, hat nur Mail','N','N','N','N'),
    (4,'nicht bez., 2W','angemeldet, nicht bezahlt, 2. Warnung','N','N','N','Y'),
    (5,'nicht bez., gesperrt','angemeldet, nicht bezahlt, gesperrt','N','N','N','Y'),
    (6,'gesperrt (ruhend)','angemeldet, gesperrt (ruhend)','N','N','N','Y'),
    (7,'gesperrt (Verstoss)','angemeldet, gesperrt (Verstoss gegen Netzordnung)','N','N','N','Y'),
    (8,'gesperrt (ausgezogen)','ausgezogen, gesperrt','N','N','Y','N'),
    (9,'Ex-Aktiver','Ex-Aktiver','Y','N','N','N'),
    (10,'E-Mail','E-Mail, ehemals IP','Y','N','N','N'),
    (11,'Renovierung','uebrig in Wu die in Renovierung','N','N','N','N'),
    (12,'Traffic','gesperrt wegen Trafficueberschreitung','Y','N','N','Y'),
    (13,'Traffic (gedrosselt)','gedrosselt wegen Trafficueberschreitung','Y','Y','N','Y');

INSERT INTO nutzer (nutzer_id, unix_account, name, vname, status) VALUES
    (1234, 'meister', 'Meister', 'Netz', 1),
    (1235, 'mustermann', 'Mustermann', 'Max', 1),
    (1236, 'musterfrau', 'Musterfrau', 'Martina', 12);

INSERT INTO wheim (wheim_id, kuerzel, plz, stadt, str, hausnr) VALUES
    (1, 'Wu5', '01217', 'Dresden', 'Wundtstraße', '5'),
    (2, 'Wu7', '01217', 'Dresden', 'Wundtstraße', '7');

INSERT INTO hp4108_ports (etage, haus, ip, port, sperrbar, wheim_id, zimmernr) VALUES
    ('1', 'Wu5', '127.0.0.1', 'A1', '0', 1, '001');