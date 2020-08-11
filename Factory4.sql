--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

-- Started on 2020-08-12 00:11:19 +03

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
-- TOC entry 233 (class 1255 OID 16639)
-- Name: add_address(integer, integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_address(sehir_id integer, ilce_id integer, text character varying)
    LANGUAGE plpgsql
    AS $$ BEGIN
   insert into public.adres(text,sehir_id,ilce_id) values(text,sehir_id,ilce_id);
 END;$$;


ALTER PROCEDURE public.add_address(sehir_id integer, ilce_id integer, text character varying) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 16640)
-- Name: add_factory(character varying, integer, integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_factory(factory_name character varying, city_id integer, ilce_id integer, address_text character varying)
    LANGUAGE plpgsql
    AS $$DECLARE 
  tempMax INTEGER;
 BEGIN 
   insert into public.adres(text,sehir_id,ilce_id) values(address_text,city_id,ilce_id);
   SELECT id Into tempMax FROM public.adres ORDER BY id DESC LIMIT 1;
   insert into public.fabrika(fabrika_adi,adres_id) values(factory_name,tempMax);

 END;$$;


ALTER PROCEDURE public.add_factory(factory_name character varying, city_id integer, ilce_id integer, address_text character varying) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 16649)
-- Name: add_imalathane(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_imalathane(imalathane_adi character varying)
    LANGUAGE plpgsql
    AS $$ BEGIN 
  insert into public.imalathane(imalathane_adi) values(imalathane_adi);
END;$$;


ALTER PROCEDURE public.add_imalathane(imalathane_adi character varying) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 16661)
-- Name: log_table(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_table() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN
   insert into logtable select 'ALTER Table',now();
 END;$$;


ALTER FUNCTION public.log_table() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 16650)
-- Name: remove_factory(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.remove_factory(factory_id integer)
    LANGUAGE plpgsql
    AS $$ BEGIN
   delete from public.fabrika WHERE id = factory_id;
   delete from public.fabrika_imalathane WHERE fabrika_id = factory_id;
   update public.genel_mudur SET fabrika_id = -1 WHERE fabrika_id = factory_id;
 END;$$;


ALTER PROCEDURE public.remove_factory(factory_id integer) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 16652)
-- Name: remove_imalathane(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.remove_imalathane(im_id integer)
    LANGUAGE plpgsql
    AS $$BEGIN
   delete from public.imalathane where id = im_id;
   delete from public.imalathane_urun where imalathane_id = im_id;
   update public.personel set imalathane_id=-1 where imalathane_id = im_id;
   update public.sorumlu set imalathane_id=-1 where imalathane_id = im_id;
   delete from public.fabrika_imalathane where imalathane_id = im_id;
 END;$$;


ALTER PROCEDURE public.remove_imalathane(im_id integer) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 16653)
-- Name: remove_kategori(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.remove_kategori(cat_id integer)
    LANGUAGE plpgsql
    AS $$ BEGIN
  delete from public.kategori where id = cat_id;
  update public.urun set kategori_id = -1 where kategori_id = cat_id;
 END;$$;


ALTER PROCEDURE public.remove_kategori(cat_id integer) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 16663)
-- Name: trigger_scream(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_scream() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN
      IF (TG_OP = 'DELETE') THEN
	    RAISE NOTICE 'DELETED: ';
      ELSIF (TG_OP = 'UPDATE') THEN
	    RAISE NOTICE 'UPDATED: ';
      ELSIF (TG_OP = 'INSERT') THEN
	    RAISE NOTICE 'INSERTED: ';
      END IF;
    RETURN NULL;
	END;$$;


ALTER FUNCTION public.trigger_scream() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 16518)
-- Name: adres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adres (
    id integer NOT NULL,
    text character varying(220),
    sehir_id integer,
    ilce_id integer
);


ALTER TABLE public.adres OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16610)
-- Name: adres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.adres ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.adres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 207 (class 1259 OID 16503)
-- Name: fabrika; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fabrika (
    id integer NOT NULL,
    fabrika_adi character varying(120) NOT NULL,
    adres_id integer
);


ALTER TABLE public.fabrika OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16616)
-- Name: fabrika_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.fabrika ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fabrika_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 208 (class 1259 OID 16508)
-- Name: fabrika_imalathane; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fabrika_imalathane (
    id integer NOT NULL,
    fabrika_id integer,
    imalathane_id integer
);


ALTER TABLE public.fabrika_imalathane OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16665)
-- Name: fabrika_imalathane_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.fabrika_imalathane ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fabrika_imalathane_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 203 (class 1259 OID 16483)
-- Name: kisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kisi (
    id integer NOT NULL,
    ad character varying(34) NOT NULL,
    soyad character varying(34) NOT NULL,
    iletisim_id integer
);


ALTER TABLE public.kisi OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16543)
-- Name: genel_mudur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genel_mudur (
    fabrika_id integer NOT NULL
)
INHERITS (public.kisi);


ALTER TABLE public.genel_mudur OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16641)
-- Name: genel_mudur_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.genel_mudur ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.genel_mudur_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 211 (class 1259 OID 16523)
-- Name: ilce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ilce (
    id integer NOT NULL,
    ilce_adi character varying(56)
);


ALTER TABLE public.ilce OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16614)
-- Name: ilce_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ilce ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ilce_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 202 (class 1259 OID 16478)
-- Name: iletisim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.iletisim (
    id integer NOT NULL,
    tel_no character varying(24),
    adres_id integer
);


ALTER TABLE public.iletisim OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16528)
-- Name: imalathane; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imalathane (
    id integer NOT NULL,
    imalathane_adi character varying(64)
);


ALTER TABLE public.imalathane OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16618)
-- Name: imalathane_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.imalathane ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.imalathane_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 214 (class 1259 OID 16538)
-- Name: imalathane_urun; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imalathane_urun (
    id integer NOT NULL,
    imalathane_id integer,
    urun_id integer
);


ALTER TABLE public.imalathane_urun OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16628)
-- Name: imalathane_urun_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.imalathane_urun ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.imalathane_urun_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 16546)
-- Name: kategori; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kategori (
    id integer NOT NULL,
    kategori_adi character varying(120)
);


ALTER TABLE public.kategori OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16620)
-- Name: kategori_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.kategori ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kategori_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 16622)
-- Name: kisi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.kisi ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16654)
-- Name: logtable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logtable (
    id integer NOT NULL,
    log_text character varying(120),
    time_log timestamp(6) with time zone
);


ALTER TABLE public.logtable OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16659)
-- Name: logtable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.logtable ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.logtable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 206 (class 1259 OID 16500)
-- Name: personel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personel (
    imalathane_id integer,
    gorev character varying(120)
)
INHERITS (public.kisi);


ALTER TABLE public.personel OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16643)
-- Name: personel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.personel ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.personel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 204 (class 1259 OID 16494)
-- Name: personel_yakini; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personel_yakini (
    personel_id integer
)
INHERITS (public.kisi);


ALTER TABLE public.personel_yakini OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16645)
-- Name: personel_yakini_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.personel_yakini ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.personel_yakini_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 209 (class 1259 OID 16513)
-- Name: sehir; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sehir (
    id integer NOT NULL,
    sehir_adi character varying(45)
);


ALTER TABLE public.sehir OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16612)
-- Name: sehir_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sehir ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sehir_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 205 (class 1259 OID 16497)
-- Name: sorumlu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sorumlu (
    ulasim_id integer,
    imalathane_id integer
)
INHERITS (public.kisi);


ALTER TABLE public.sorumlu OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16647)
-- Name: sorumlu_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sorumlu ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sorumlu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 213 (class 1259 OID 16533)
-- Name: urun; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.urun (
    id integer NOT NULL,
    urun_adi character varying(120),
    kategori_id integer
);


ALTER TABLE public.urun OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16624)
-- Name: urun_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.urun ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.urun_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);


--
-- TOC entry 3266 (class 0 OID 16518)
-- Dependencies: 210
-- Data for Name: adres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adres (id, text, sehir_id, ilce_id) FROM stdin;
10	\N	1	1
11	$post["text"]	1	1
12	''	1	1
13	'kaşıkçı caddesi , 98/B'	1	1
16	çekirge	1	1
17	çekirge	1	1
18	'kaşıkçı caddesi , 98/BADAS'	1	1
19	'Yarrak Hasan caddesi'	1	2
20	'Amcık caddesi'	2	2
21	'asdasdkdksjd   jjdskdk'	1	1
8	Aybek Caddesi	1	2
9	Can Caddesi 123	1	1
22	'fabrika yeri'	1	1
23	kaşıkçı caddesi , 98/B	1	2
14	'asdasd 4343424'	1	1
15	Aybek Caddesi123 32323	2	1
\.


--
-- TOC entry 3263 (class 0 OID 16503)
-- Dependencies: 207
-- Data for Name: fabrika; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fabrika (id, fabrika_adi, adres_id) FROM stdin;
7	çekirge	16
8	çekirge	17
13	Yeni fab	22
14	Aybekin Fabrikası	23
5	'çekirge'	14
6	Aybek Can Kaya	15
\.


--
-- TOC entry 3264 (class 0 OID 16508)
-- Dependencies: 208
-- Data for Name: fabrika_imalathane; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fabrika_imalathane (id, fabrika_id, imalathane_id) FROM stdin;
4	5	8
5	6	8
6	6	9
7	6	7
8	7	7
9	8	6
10	8	7
\.


--
-- TOC entry 3271 (class 0 OID 16543)
-- Dependencies: 215
-- Data for Name: genel_mudur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genel_mudur (id, ad, soyad, iletisim_id, fabrika_id) FROM stdin;
1	osman	osmik	1	-1
3	Barış	Manço	-1	5
4	İrem	Subaşı	-1	6
5	Ricardo	Quaresma	-1	7
6	Süleyman	Seba	-1	8
2	Emmanuel	Kant	-1	-1
\.


--
-- TOC entry 3267 (class 0 OID 16523)
-- Dependencies: 211
-- Data for Name: ilce; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ilce (id, ilce_adi) FROM stdin;
1	mamak
2	tuzla
\.


--
-- TOC entry 3258 (class 0 OID 16478)
-- Dependencies: 202
-- Data for Name: iletisim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.iletisim (id, tel_no, adres_id) FROM stdin;
1	02122333233	\N
2	02122333233	\N
\.


--
-- TOC entry 3268 (class 0 OID 16528)
-- Dependencies: 212
-- Data for Name: imalathane; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imalathane (id, imalathane_adi) FROM stdin;
6	İstanbul İmalathanesi
7	Ankara İmalathanesi
8	Tuzla İmalathanesi
9	Yağlı Gıdalar İmalathanesi
12	Gebze İmalat
\.


--
-- TOC entry 3270 (class 0 OID 16538)
-- Dependencies: 214
-- Data for Name: imalathane_urun; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imalathane_urun (id, imalathane_id, urun_id) FROM stdin;
\.


--
-- TOC entry 3272 (class 0 OID 16546)
-- Dependencies: 216
-- Data for Name: kategori; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kategori (id, kategori_adi) FROM stdin;
6	Tuzlu Gıdalar
7	Tatlı Gıdalar
\.


--
-- TOC entry 3259 (class 0 OID 16483)
-- Dependencies: 203
-- Data for Name: kisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kisi (id, ad, soyad, iletisim_id) FROM stdin;
\.


--
-- TOC entry 3286 (class 0 OID 16654)
-- Dependencies: 230
-- Data for Name: logtable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logtable (id, log_text, time_log) FROM stdin;
\.


--
-- TOC entry 3262 (class 0 OID 16500)
-- Dependencies: 206
-- Data for Name: personel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personel (id, ad, soyad, iletisim_id, imalathane_id, gorev) FROM stdin;
\.


--
-- TOC entry 3260 (class 0 OID 16494)
-- Dependencies: 204
-- Data for Name: personel_yakini; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personel_yakini (id, ad, soyad, iletisim_id, personel_id) FROM stdin;
\.


--
-- TOC entry 3265 (class 0 OID 16513)
-- Dependencies: 209
-- Data for Name: sehir; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sehir (id, sehir_adi) FROM stdin;
1	istanbul
2	ankara
\.


--
-- TOC entry 3261 (class 0 OID 16497)
-- Dependencies: 205
-- Data for Name: sorumlu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sorumlu (id, ad, soyad, iletisim_id, ulasim_id, imalathane_id) FROM stdin;
\.


--
-- TOC entry 3269 (class 0 OID 16533)
-- Dependencies: 213
-- Data for Name: urun; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.urun (id, urun_adi, kategori_id) FROM stdin;
2	Zeytinyağı	-1
1	Cikolata	-1
4	Ekmek	3
5	Su	4
\.


--
-- TOC entry 3294 (class 0 OID 0)
-- Dependencies: 217
-- Name: adres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adres_id_seq', 23, true);


--
-- TOC entry 3295 (class 0 OID 0)
-- Dependencies: 220
-- Name: fabrika_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fabrika_id_seq', 14, true);


--
-- TOC entry 3296 (class 0 OID 0)
-- Dependencies: 232
-- Name: fabrika_imalathane_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fabrika_imalathane_id_seq', 10, true);


--
-- TOC entry 3297 (class 0 OID 0)
-- Dependencies: 226
-- Name: genel_mudur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genel_mudur_id_seq', 6, true);


--
-- TOC entry 3298 (class 0 OID 0)
-- Dependencies: 219
-- Name: ilce_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ilce_id_seq', 2, true);


--
-- TOC entry 3299 (class 0 OID 0)
-- Dependencies: 221
-- Name: imalathane_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imalathane_id_seq', 12, true);


--
-- TOC entry 3300 (class 0 OID 0)
-- Dependencies: 225
-- Name: imalathane_urun_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imalathane_urun_id_seq', 2, true);


--
-- TOC entry 3301 (class 0 OID 0)
-- Dependencies: 222
-- Name: kategori_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kategori_id_seq', 8, true);


--
-- TOC entry 3302 (class 0 OID 0)
-- Dependencies: 223
-- Name: kisi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kisi_id_seq', 1, false);


--
-- TOC entry 3303 (class 0 OID 0)
-- Dependencies: 231
-- Name: logtable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logtable_id_seq', 1, false);


--
-- TOC entry 3304 (class 0 OID 0)
-- Dependencies: 227
-- Name: personel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personel_id_seq', 1, false);


--
-- TOC entry 3305 (class 0 OID 0)
-- Dependencies: 228
-- Name: personel_yakini_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personel_yakini_id_seq', 1, false);


--
-- TOC entry 3306 (class 0 OID 0)
-- Dependencies: 218
-- Name: sehir_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sehir_id_seq', 2, true);


--
-- TOC entry 3307 (class 0 OID 0)
-- Dependencies: 229
-- Name: sorumlu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sorumlu_id_seq', 1, false);


--
-- TOC entry 3308 (class 0 OID 0)
-- Dependencies: 224
-- Name: urun_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.urun_id_seq', 5, true);


--
-- TOC entry 3116 (class 2606 OID 16522)
-- Name: adres adres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT adres_pkey PRIMARY KEY (id);


--
-- TOC entry 3112 (class 2606 OID 16512)
-- Name: fabrika_imalathane fabrika_imalathane_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fabrika_imalathane
    ADD CONSTRAINT fabrika_imalathane_pkey PRIMARY KEY (id);


--
-- TOC entry 3110 (class 2606 OID 16507)
-- Name: fabrika fabrika_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fabrika
    ADD CONSTRAINT fabrika_pkey PRIMARY KEY (id);


--
-- TOC entry 3118 (class 2606 OID 16527)
-- Name: ilce ilce_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_pkey PRIMARY KEY (id);


--
-- TOC entry 3103 (class 2606 OID 16482)
-- Name: iletisim iletisim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.iletisim
    ADD CONSTRAINT iletisim_pkey PRIMARY KEY (id);


--
-- TOC entry 3120 (class 2606 OID 16532)
-- Name: imalathane imalathane_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imalathane
    ADD CONSTRAINT imalathane_pkey PRIMARY KEY (id);


--
-- TOC entry 3124 (class 2606 OID 16542)
-- Name: imalathane_urun imalathane_urun_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imalathane_urun
    ADD CONSTRAINT imalathane_urun_pkey PRIMARY KEY (id);


--
-- TOC entry 3126 (class 2606 OID 16550)
-- Name: kategori kategori_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kategori
    ADD CONSTRAINT kategori_pkey PRIMARY KEY (id);


--
-- TOC entry 3106 (class 2606 OID 16487)
-- Name: kisi kisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT kisi_pkey PRIMARY KEY (id);


--
-- TOC entry 3128 (class 2606 OID 16658)
-- Name: logtable logtable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logtable
    ADD CONSTRAINT logtable_pkey PRIMARY KEY (id);


--
-- TOC entry 3114 (class 2606 OID 16517)
-- Name: sehir sehir_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sehir
    ADD CONSTRAINT sehir_pkey PRIMARY KEY (id);


--
-- TOC entry 3108 (class 2606 OID 16627)
-- Name: sorumlu sorumlu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sorumlu
    ADD CONSTRAINT sorumlu_pkey PRIMARY KEY (id);


--
-- TOC entry 3122 (class 2606 OID 16537)
-- Name: urun urun_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urun
    ADD CONSTRAINT urun_pkey PRIMARY KEY (id);


--
-- TOC entry 3104 (class 1259 OID 16493)
-- Name: fki_iletisim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_iletisim_id ON public.kisi USING btree (iletisim_id);


--
-- TOC entry 3131 (class 2620 OID 16662)
-- Name: kategori kategori_log_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER kategori_log_trigger AFTER INSERT OR UPDATE OF id, kategori_adi ON public.kategori FOR EACH STATEMENT EXECUTE FUNCTION public.log_table();


--
-- TOC entry 3130 (class 2620 OID 16664)
-- Name: urun scream_alterations; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER scream_alterations AFTER INSERT OR UPDATE ON public.urun FOR EACH STATEMENT EXECUTE FUNCTION public.trigger_scream();


--
-- TOC entry 3129 (class 2606 OID 16488)
-- Name: kisi iletisim_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT iletisim_id FOREIGN KEY (iletisim_id) REFERENCES public.iletisim(id) NOT VALID;


-- Completed on 2020-08-12 00:11:20 +03

--
-- PostgreSQL database dump complete
--

